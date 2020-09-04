<%@page import="be.openclinic.pharmacy.ProductStock"%>
<%@page import="java.awt.ActiveEvent"%>
<%@ page import="be.openclinic.finance.*,be.openclinic.adt.Encounter,java.text.*,be.mxs.common.util.system.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"financial.patientinvoice","edit",activeUser)%>
<%=sJSPROTOTYPE%>
<%=sJSNUMBER%> 
<%=sJSSTRINGFUNCTIONS%>
<%!
    private String addCredits(Vector vCredits, String sClass, boolean bChecked, String sWebLanguage){
        StringBuffer sReturn = new StringBuffer();

        if (vCredits!=null){
            String sPatientCreditUID;
            PatientCredit patientcredit;
            String sChecked = "";
            if (bChecked){
                sChecked = " checked";
            }

            for (int i=0;i<vCredits.size();i++){
                sPatientCreditUID = checkString((String)vCredits.elementAt(i));

                if (sPatientCreditUID.length()>0){
                    patientcredit = PatientCredit.get(sPatientCreditUID);

                    if (patientcredit!=null){
                        if (sClass.equals((""))){
                            sClass = "1";
                        }
                        else {
                            sClass = "";
                        }

                        sReturn.append( "<tr class='list"+sClass+"'>"
                            +"<td><input type='checkbox' name='cbPatientInvoice"+patientcredit.getUid()+"="+patientcredit.getAmount()+"' id='"+patientcredit.getType()+"."+patientcredit.getUid()+"' onclick='doBalance(this, false)'"+sChecked+"></td>"
                            +"<td>"+ScreenHelper.getSQLDate(patientcredit.getDate())+"</td>"
                            +"<td>"+getTran(null,"credit.type",checkString(patientcredit.getType()),sWebLanguage)+"</td>"
                            +"<td align='right'>"+new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat")).format(patientcredit.getAmount())+" "+MedwanQuery.getInstance().getConfigParam("currency","â‚¬")+"</td>"
                        +"</tr>");
                    }
                }
            }
        }
        return sReturn.toString();
    }
%>
<%
	if(checkString(request.getParameter("command")).startsWith("removesignatures")){
		Pointer.deletePointers("INVSIGN."+request.getParameter("command").split(";")[1]);
	}
	if(checkString(request.getParameter("discardautopharmacylist")).length()==0 && checkString(request.getParameter("autopharmacylist")).length()>0){
		//Automatically invoice the list of pharmaceutical products
		String stockuid = request.getParameter("autopharmacylist");
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("SELECT * FROM OC_DRUGSOUTLIST,OC_PRODUCTSTOCKS WHERE (oc_list_invoiced is null or oc_list_invoiced=0) and oc_stock_objectid=replace(oc_list_productstockuid,'"+MedwanQuery.getInstance().getServerId()+".','') and OC_LIST_PATIENTUID=? AND OC_stock_servicestockuid=?");
		ps.setString(1,activePatient.personid);
		ps.setString(2,stockuid);
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			ProductStock stock = ProductStock.get(rs.getString("oc_list_productstockuid"));
        	Debug.println("Facturation automatique");
			if(stock!=null & stock.getProduct()!=null && stock.getProduct().getPrestationcode()!=null){
            	Prestation prestation = Prestation.get(stock.getProduct().getPrestationcode());
            	Encounter activeEncounter = Encounter.getActiveEncounter(activePatient.personid);
            	if(prestation!=null && activePatient!=null && activeEncounter!=null){
                	Debug.println("Prestation existe, patient existe, contact existe");
            		Debet debet = new Debet();
            		debet.setCreateDateTime(new java.util.Date());
            		debet.setUpdateDateTime(new java.util.Date());
            		debet.setUpdateUser(activeUser.userid);
            		debet.setDate(new java.util.Date());
            		debet.setEncounter(activeEncounter);
            		debet.setPrestation(prestation);
            		debet.setQuantity(rs.getInt("oc_list_quantity")*stock.getProduct().getPrestationquantity()*stock.getProduct().getPrestationquantity());
            		debet.setComment("");
            		debet.setSupplierUid("");
            		debet.setCredited(0);
            		debet.setVersion(1);
            		debet.setPerformeruid(rs.getString("oc_list_prescriber"));
            		
            		double patientamount = prestation.getPrice();
            		
            		//Insurance & insurar
            		Insurance insurance = Insurance.getMostInterestingInsuranceForPatient(activePatient.personid);
            		double insuraramount=0;
            		if(insurance!=null && insurance.getInsurar()!=null && prestation.isVisibleFor(insurance.getInsurar(),activeEncounter.getService())){
                    	Debug.println("Assurance existe et est visible");
            			patientamount = prestation.getPrice(insurance.getType());
	            		debet.setInsurance(insurance);
	            		debet.setInsuranceUid(insurance.getUid());
	            		//First find out if there is a fixed tariff for this prestation
	            		insuraramount = prestation.getInsuranceTariff(insurance.getInsurarUid(), insurance.getInsuranceCategoryLetter());
		                if(activeEncounter.getType().equalsIgnoreCase("admission") && prestation.getMfpAdmissionPercentage()>0){
		                	insuraramount = prestation.getInsuranceTariff(insurance.getInsurar().getUid(),"*H");
		                }
	            		if(insuraramount==-1){
	            			//Calculate the insuranceamount based on reimbursementpercentage
	            			insuraramount=patientamount*(100-insurance.getPatientShare())/100;
	            		}
	            		patientamount=patientamount-insuraramount;
	            		//If there are any supplements, then we have to add them to the patient price
	            		patientamount+=prestation.getSupplement();
	            		//Extrainsurar
	            		double extrainsuraramount=0;
	            		if(!MedwanQuery.getInstance().getConfigString("defaultExtraInsurar","-1").equalsIgnoreCase("-1")){
	            			Insurar extrainsurar = Insurar.get(MedwanQuery.getInstance().getConfigString("defaultExtraInsurar","-1"));
	            			if(extrainsurar!=null){
	            				extrainsuraramount=patientamount;
	            				patientamount=0;
	            				debet.setExtraInsurarUid(extrainsurar.getUid());
	            			}
	            		}
	            		debet.setAmount(Double.parseDouble(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#.00")).format(patientamount).replaceAll(",", "."))*debet.getQuantity());
	            		debet.setInsurarAmount(Double.parseDouble(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#.00")).format(insuraramount).replaceAll(",", "."))*debet.getQuantity());
	            		debet.setExtraInsurarAmount(Double.parseDouble(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#.00")).format(extrainsuraramount).replaceAll(",", "."))*debet.getQuantity());
                    	Debug.println("Sauvegarde de la prestation");
                    	debet.store();
                    	//Mark the item in the waiting list as invoiced
                    	PreparedStatement ps2 = conn.prepareStatement("update OC_DRUGSOUTLIST set OC_LIST_INVOICED=1 where OC_LIST_SERVERID=? and OC_LIST_OBJECTID=?");
                    	ps2.setInt(1,rs.getInt("oc_list_serverid"));
                    	ps2.setInt(2,rs.getInt("oc_list_objectid"));
                    	ps2.execute();
                    	ps2.close();
	            		MedwanQuery.getInstance().getObjectCache().removeObject("debet", debet.getUid());
            		}
            	}
			}
		}
		rs.close();
		ps.close();
		conn.close();
	}
	boolean isInsuranceAgent=false;
	if(activeUser!=null && activeUser.getParameter("insuranceagent")!=null && activeUser.getParameter("insuranceagent").length()>0 && MedwanQuery.getInstance().getConfigString("InsuranceAgentAcceptationNeededFor","").indexOf("*"+activeUser.getParameter("insuranceagent")+"*")>-1){
		//This is an insurance agent, limit the functionalities
		isInsuranceAgent=true;
	}
	
	String sExternalSignatureCode= checkString(request.getParameter("externalsignaturecode"));
	String sFindPatientInvoiceUID = checkString(request.getParameter("FindPatientInvoiceUID"));
	boolean automaticPayment=false;
	
	if(!isInsuranceAgent && checkString(request.getParameter("quick")).equals("1")){
		Vector unassignedDebets = Debet.getUnassignedPatientDebets(activePatient.personid);
		if(unassignedDebets.size()>0){
			PatientInvoice invoice=new PatientInvoice();
			invoice.setCreateDateTime(new java.util.Date());
			invoice.setDate(new java.util.Date());
			invoice.setPatientUid(activePatient.personid);
			invoice.setStatus("open");
			invoice.setUpdateDateTime(new java.util.Date());
			invoice.setUpdateUser(activeUser.userid);
			invoice.setVersion(1);
			invoice.setDebets(new Vector());
			for(int n=0;n<unassignedDebets.size();n++){
				Debet debet = Debet.get((String)unassignedDebets.elementAt(n));
				invoice.getDebets().add(debet);
			}
			invoice.store();
			sFindPatientInvoiceUID=invoice.getUid();
			automaticPayment=true;
		}
	}
	
	PatientInvoice patientInvoice=null;
    String sPatientInvoiceID = "", sPatientId = "", sClosed ="", sInsurarReference="", sInsurarReferenceDate="", sVerifier="",sEditComment="",sPatientInvoiceMfpDoctor="",sPatientInvoiceMfpPost="",sPatientInvoiceMfpAgent="",sPatientInvoiceMfpDrugsRecipient="",sPatientInvoiceMfpDrugsIdCard="",sPatientInvoiceMfpDrugsIdCardPlace="",sPatientInvoiceMfpDrugsIdCardDate="";
    if (sFindPatientInvoiceUID.length() > 0) {
    	if(sFindPatientInvoiceUID.split("\\.").length==2){
    		patientInvoice=patientInvoice.get(sFindPatientInvoiceUID);
    	}
    	else {
    		patientInvoice = PatientInvoice.getViaInvoiceUID(sFindPatientInvoiceUID);
    	}
        if (patientInvoice!=null && patientInvoice.getDate()!=null){
            sPatientInvoiceID = checkString(patientInvoice.getInvoiceUid());
            sPatientId = patientInvoice.getPatientUid();
            if(request.getParameter("LoadPatientId")!=null && (activePatient==null || !sPatientId.equalsIgnoreCase(activePatient.personid))){
            	if(activePatient==null){
            		activePatient=new AdminPerson();
            		session.setAttribute("activePatient",activePatient);
            	}
            	activePatient.initialize(sPatientId);
            	%>
            	<script>window.location.href='<c:url value='/main.do'/>?Page=financial/patientInvoiceEdit.jsp&ts=<%=ScreenHelper.getTs()%>&FindPatientInvoiceUID=<%=sFindPatientInvoiceUID%>';</script>
            	<%
            	out.flush();
            }
            sClosed=patientInvoice.getStatus();
            sInsurarReference=checkString(patientInvoice.getInsurarreference());
            sInsurarReferenceDate=checkString(patientInvoice.getInsurarreferenceDate());
            sVerifier=checkString(patientInvoice.getVerifier());
            sEditComment=checkString(patientInvoice.getComment());
            sPatientInvoiceMfpDoctor=checkString(patientInvoice.getMfpDoctor());
            sPatientInvoiceMfpPost=checkString(patientInvoice.getMfpPost());
            sPatientInvoiceMfpAgent=checkString(patientInvoice.getMfpAgent());
            sPatientInvoiceMfpDrugsRecipient=checkString(patientInvoice.getMfpDrugReceiver());
            sPatientInvoiceMfpDrugsIdCard=checkString(patientInvoice.getMfpDrugReceiverId());
            sPatientInvoiceMfpDrugsIdCardDate=checkString(patientInvoice.getMfpDrugIdCardDate());
            sPatientInvoiceMfpDrugsIdCardPlace=checkString(patientInvoice.getMfpDrugIdCardPlace());
        }
        else{
        	out.println(getTran(request,"web","invoice.does.not.exist",sWebLanguage)+": "+sFindPatientInvoiceUID);
        }

    } else {
        patientInvoice = new PatientInvoice();
        patientInvoice.setDate(new java.util.Date());
        patientInvoice.setStatus(MedwanQuery.getInstance().getConfigString("defaultPatientInvoiceStatus","open"));
        sPatientId = activePatient.personid;
        if(MedwanQuery.getInstance().getConfigInt("enableEncounterReference",0)==1){
	        Encounter encounter = Encounter.getActiveEncounter(activePatient.personid);
	        if(encounter!=null){
	        	sInsurarReference=checkString(encounter.getEtiology());
	        }
        }
        patientInvoice.setPatientUid(sPatientId);
    }
	if(patientInvoice!=null && patientInvoice.getDate()!=null){
	    double dBalance = 0;
	    Vector vDebets = patientInvoice.getDebetStrings();
	
	    if (vDebets!=null){
	        String sDebetUID;
	        Debet debet;
	
	        for (int i=0;i<vDebets.size();i++){
	            sDebetUID = (String) vDebets.elementAt(i);
	            debet=Debet.get(sDebetUID);
	            if (checkString(debet.getUid()).length()>0){
	                if (debet != null) {
	                    dBalance += debet.getAmount();
	                }
	            }
	        }
	    }

	    Vector vPatientCredits = PatientCredit.getPatientCreditsViaInvoiceUID(patientInvoice.getUid());
	
	    if (vPatientCredits!=null){
	        String sCreditUID;
	        PatientCredit patientcredit;
	
	        for (int i=0;i<vPatientCredits.size();i++){
	            sCreditUID = checkString((String) vPatientCredits.elementAt(i));
	
	            if (sCreditUID.length()>0){
	                patientcredit = PatientCredit.get(sCreditUID);
	
	                if (patientcredit != null) {
	                    dBalance -= patientcredit.getAmount();
	                }
	            }
	        }
	    }
	    
	    //Check if patient has any insurances with mandatory fields
	    String mandatoryReferenceInsurers = "", mandatoryOtherReferenceInsurers = "";
	    Vector insurances = Insurance.getCurrentInsurances(patientInvoice.getPatientUid());
	    for(int n=0;n<insurances.size();n++){
	    	Insurance insurance = (Insurance)insurances.elementAt(n);
	    	if(insurance.getStop()==null || insurance.getStop().after(new java.util.Date())){
		    	Insurar insurar = insurance.getInsurar();
		    	if(insurar!=null){
			    	if(insurar.getInsuranceReferenceNumberMandatory()==1){
			    		mandatoryReferenceInsurers+="*"+insurance.getUid()+"*";
			    	}
			    	if(insurar.getInvoiceCommentMandatory()==1){
			    		mandatoryOtherReferenceInsurers+="*"+insurance.getUid()+"*";
			    	}
		    	}
	    	}
	    }

	%>
	<form name='FindForm' id="FindForm" method='POST'>
		<input type='hidden' name='command' id='command'/>
		<input type='hidden' name='discardautopharmacylist' value='<%=checkString(request.getParameter("autopharmacylist")).length()>0?"1":""%>'/>
		<input type='hidden' name='mandatoryReferenceInsurers' id='mandatoryReferenceInsurers' value='<%=mandatoryReferenceInsurers %>'/>
		<input type='hidden' name='mandatoryOtherReferenceInsurers' id='mandatoryOtherReferenceInsurers' value='<%=mandatoryOtherReferenceInsurers %>'/>
	    <%=writeTableHeader("web","patientInvoiceEdit",sWebLanguage,"")%>
	    <table id='table1' class="menu" width="100%">
	        <tr>
	            <td width="<%=sTDAdminWidth%>"><%=getTran(request,"web.finance","invoiceid",sWebLanguage)%></td>
	            <td>
	                <input type="text" class="text" id="FindPatientInvoiceUID" name="FindPatientInvoiceUID" onblur="isNumber(this)" value="<%=sFindPatientInvoiceUID%>">
	                <img style='vertical-align: middle' src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"Web","select",sWebLanguage)%>" onclick="searchPatientInvoice();">
	                <img style='vertical-align: middle' src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTran(null,"Web","clear",sWebLanguage)%>" onclick="doClear()">
	                <input type="button" class="button" name="ButtonFind" value="<%=getTran(null,"web","find",sWebLanguage)%>" onclick="doFind()">
	                <% if(!isInsuranceAgent){ %>
	                <input type="button" class="button" name="ButtonNew" value="<%=getTran(null,"web","new",sWebLanguage)%>" onclick="doNew()">
	                <% } 
	                	if(request.getParameter("showpatientname")!=null){
	                %>
	                &nbsp;&nbsp;&nbsp;&nbsp;<font style='font-size: 16px'><%=patientInvoice==null || patientInvoice.getPatient()==null?"":patientInvoice.getPatient().getFullName()%></font>
	                <%
	                	}
	                %>
	            </td>
	        </tr>
	    </table>
	</form>
	<div id="divOpenPatientInvoices" class="searchResults" style="height:120px;"></div>
	<script>
		window.onresize = function(event) {
			window.location.reload();
		};
		document.getElementById("divOpenPatientInvoices").style.width=document.body.clientWidth-25;
	    function searchPatientInvoice(){
	        openPopup("/_common/search/searchPatientInvoice.jsp&FindInvoicePatient=<%=sPatientId%>&doFunction=doFind()&ReturnFieldInvoiceNr=FindPatientInvoiceUID&FindInvoicePatientId=<%=sPatientId%>&Action=search&header=false&PopupHeight=420&ts=<%=getTs()%>");
	    }
	
	    function doFind(){
	        if (FindForm.FindPatientInvoiceUID.value.length>0){
	            FindForm.submit();
	        }
	    }
	
	    function doNew(){
	        FindForm.FindPatientInvoiceUID.value = "";
	        EditForm.EditInvoiceUID.value = "";
	
	        FindForm.submit();
	    }
	
	    function doClear(){
	        FindForm.FindPatientInvoiceUID.value='';
	        FindForm.FindPatientInvoiceUID.focus();
	    }
	    
	    function showHistory(){
		    openPopup("/financial/showPatientInvoiceHistory.jsp&ts=<%=getTs()%>&invoiceuid="+document.getElementById('EditInvoiceUID').value,500,200);
	    }
	</script>
	<form name='EditForm' id="EditForm" method='POST'>
	    <table id='table2' class='list' border='0' width='100%' cellspacing='1'>
	        <tr>
	            <td class="admin" nowrap><%=getTran(request,"web.finance","invoiceid",sWebLanguage)%></td>
	            <td class="admin2">
	            	<table width='100%'>
	            		<tr>
	            			<td>
				                <input type="hidden" id="EditInvoiceUID" name="EditInvoiceUID" value="<%=checkString(patientInvoice.getInvoiceUid())%>">
				                <input type="text" size="10" class="text" readonly id="EditInvoiceUIDText" name="EditInvoiceUIDText" value="<%=sPatientInvoiceID%>">
				            </td> 
			                <%
			                	if(checkString(patientInvoice.getNumber()).length()>0 && !patientInvoice.getInvoiceUid().equalsIgnoreCase(patientInvoice.getInvoiceNumber())){
			                		out.print("<td nowrap>("+patientInvoice.getInvoiceNumber()+")</td>");
			                	}
			                	if(checkString(patientInvoice.getInvoiceUid()).length()==0 && MedwanQuery.getInstance().getConfigString("multiplePatientInvoiceSeries","").length()>0){
			                		out.println("<td>");
			                		String[] invoiceSeries = MedwanQuery.getInstance().getConfigString("multiplePatientInvoiceSeries").split(";");
			                		out.println("<input type='radio' class='text' name='invoiceseries' value='0'/>"+getTran(request,"web","internal",sWebLanguage));
			                		for(int n=0;n<invoiceSeries.length;n++){
			                    		out.println("<input type='radio' class='text' name='invoiceseries' value='"+invoiceSeries[n]+"'/>"+invoiceSeries[n]);
			                		}
			                		out.println("</td>");
			                	}
			                	if(patientInvoice.hasValidUid()){
			                		out.println("<td>"+getTran(request,"web","lastmodification",sWebLanguage)+" <b>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(patientInvoice.getUpdateDateTime())+"</b><br/>"+getTran(request,"web","by",sWebLanguage)+" <b>"+User.getFullUserName(patientInvoice.getUpdateUser()).toUpperCase()+"</b>"+(patientInvoice.getVersion()<=1?"":" <img src='"+sCONTEXTPATH+"/_img/icons/icon_history2.gif' onclick='showHistory();'>")+"</td>");
			                	}
			                %>
			            </tr>
			        </table>
	            </td>
	            <td class="admin" nowrap>
	            	<%=getTran(request,"web.finance","insurarreference",sWebLanguage)%>&nbsp;<br/><%=getTran(request,"web","date",sWebLanguage)%>
	            </td>
	            <td class="admin2">
	            	<table width='100%'>
	            		<tr>
	            			<td><input type="text" size="40" class="text" id="EditInsurarReference" name="EditInsurarReference" value="<%=sInsurarReference%>"></td>
	            		</tr>
	            		<tr>
	            			<td><%=writeDateField("EditInsurarReferenceDate","EditForm",sInsurarReferenceDate,sWebLanguage)%></td>
	            		</tr>
	            	</table>
	            </td>
	        </tr>
	        <tr>
	            <td class="admin" nowrap>
	            	<%=getTran(request,"web.finance","linkedservice",sWebLanguage)%>
	            </td>
	            <td class="admin2">
	            	<table>
	            		<tr>
				            <td>
								<%
									String sLinkedService ="",sLinkedServiceName = "";
									String ls = Pointer.getPointer("INV.SVC."+patientInvoice.getUid());
									if(ls.length()>0){
										sLinkedService=ls;
										sLinkedServiceName=getTranNoLink("service",sLinkedService,sWebLanguage);
									}
								%>
					            <input type="hidden" name="EditLinkedService" id="EditLinkedService" value="<%=sLinkedService%>">
					           	<input class="text" type="text" name="EditLinkedServiceName" id="EditLinkedServiceName" readonly size="<%=40%>" value="<%=sLinkedServiceName%>">
					           	<img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"Web","select",sWebLanguage)%>" onclick="searchService('EditLinkedService','EditLinkedServiceName');">
					           	<img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTran(null,"Web","clear",sWebLanguage)%>" onclick="document.getElementById('EditLinkedService').value='';document.getElementById('EditLinkedServiceName').value='';">
				            </td>
	            		</tr>
	            	</table>
	            </td>
	            <td class="admin" nowrap>
	            	<%=getTran(request,"web.finance","otherreference",sWebLanguage)%>
	            </td>
	            <td class="admin2">
	                <input type="text" size="40" class="text" id="EditComment" name="EditComment" value="<%=sEditComment%>">
	            </td>
	        </tr>
	        <% if(MedwanQuery.getInstance().getConfigInt("enableMFP",0)==1 && MedwanQuery.getInstance().getConfigInt("hideMFPInvoiceFields",0)==0){ %>
		        <tr>
		            <td class="admin">
	           			<%=getTran(request,"web.finance","mfp.invoice.drugsrecipient",sWebLanguage)%>
		            </td>
		            <td class="admin2">
		            	<table width='100%'>
		            		<tr>
		            			<td><%=getTran(request,"web","name",sWebLanguage)%></td>
		            			<td><input type="text" size="30" class="text"  id="EditInvoiceDrugsRecipient" name="EditInvoiceDrugsRecipient" value="<%=sPatientInvoiceMfpDrugsRecipient%>"></td>
								<td><%=getTran(request,"web.finance","mfp.invoice.drugsid",sWebLanguage)%></td>
								<td><input type="text" size="15" class="text"  id="EditInvoiceDrugsIdCard" name="EditInvoiceDrugsIdCard" value="<%=sPatientInvoiceMfpDrugsIdCard%>"></td>
		            		</tr>
		            		<tr>
		            			<td><%=getTran(request,"web","delivered.at",sWebLanguage)%></td>
		            			<td><input type="text" size="30" class="text"  id="EditInvoiceDrugsIdCardPlace" name="EditInvoiceDrugsIdCardPlace" value="<%=sPatientInvoiceMfpDrugsIdCardPlace%>"></td>
		            			<td><%=getTran(request,"web","date",sWebLanguage)%></td>
		            			<td nowrap><%=writeDateField("EditInvoiceDrugsIdCardDate","EditForm",sPatientInvoiceMfpDrugsIdCardDate,sWebLanguage)%></td>
		            		</tr>
		            	</table>
		            </td>
		            <td class="admin" nowrap><%=getTran(request,"web.finance","mfp.invoice.data",sWebLanguage)%></td>
		            <td class="admin2">
		            	<table>
		            		<tr>
		            			<td><%=getTran(request,"web.finance","mfp.invoice.doctor",sWebLanguage)%>: <input type="text" size="8" class="text"  id="EditInvoiceDoctor" name="EditInvoiceDoctor" value="<%=sPatientInvoiceMfpDoctor%>"></td>
		            			<td><%=getTran(request,"web.finance","mfp.invoice.post",sWebLanguage)%>: <input type="text" size="8" class="text"  id="EditInvoicePost" name="EditInvoicePost" value="<%=sPatientInvoiceMfpPost%>"></td>
		            			<td><%=getTran(request,"web.finance","mfp.invoice.agent",sWebLanguage)%>: <input type="text" size="8" class="text"  id="EditInvoiceAgent" name="EditInvoiceAgent" value="<%=sPatientInvoiceMfpAgent%>"></td>
		            		</tr>
		            	</table>
		            </td>
		        </tr>
	        <%
	        }
	        else if(MedwanQuery.getInstance().getConfigInt("enableMFP",0)==1 && MedwanQuery.getInstance().getConfigInt("hideCCBRTInvoiceFields",1)==0){
				boolean bMFPActive = false;
				for(int n=0;n<insurances.size();n++){
					Insurance insurance = (Insurance)insurances.elementAt(n);
					if(insurance!=null && insurance.getInsurarUid()!=null && insurance.getInsurarUid().equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("MFP","NOOP"))){
						bMFPActive=true;
						break;
					}
				}
				if(!bMFPActive && patientInvoice!=null && patientInvoice.getInsurerIds()!=null){				
		        	String[] insurers = patientInvoice.getInsurerIds().split(",");
					for(int n=0;n<insurers.length;n++){
						if(insurers[n].trim().equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("MFP","NOOP"))){
							bMFPActive=true;
							break;
						}
					}
				}
				if(bMFPActive){
		        %>
			        <tr>
			            <td class="admin" rowspan="2">
			            </td>
			            <td class="admin2" rowspan="2">
			            </td>
			            <td class="admin">
							<%=getTran(request,"web.finance","ccbrt.specialauthorizationnumber",sWebLanguage)%>
						</td>
		            	<td class="admin2">
		            		<input type="text" size="40" class="text"  id="EditInvoiceDoctor" name="EditInvoiceDoctor" value="<%=sPatientInvoiceMfpDoctor%>">
					        <%=getTran(request,"web","type",sWebLanguage) %>:
					        <select class='text' name="EditInvoiceDrugsRecipient" id="EditInvoiceDrugsRecipient">
					        	<option/>
		            			<%=ScreenHelper.writeSelect(request,"nhif.authorizationtypes",sPatientInvoiceMfpDrugsRecipient,sWebLanguage) %>
		            		</select>
		            	</td>
		            </tr>
		            <tr>
	           			<td class="admin">
	           				<%=getTran(request,"web","ccbrt.comment",sWebLanguage)%>
	           			</td>
		            	<td class="admin2">
					        <input type="text" size="40" class="text"  id="EditInvoicePost" name="EditInvoicePost" value="<%=sPatientInvoiceMfpPost%>">
					    </td>
			        </tr>
		        <%
				}	        
	        }

	        if(patientInvoice!=null && patientInvoice.getUid()!=null && checkString(Pointer.getPointer("DERIVED."+patientInvoice.getUid())).length()>0){
        %>
        <tr>
        	<td class='admin'/><td class='admin2'/>
            <td class="admin" nowrap><%=getTran(request,"web.finance","derived.from",sWebLanguage)%></td>
            <td class="admin2">
                <a href="javascript:setPatientInvoice('<%=Pointer.getPointer("DERIVED."+patientInvoice.getUid())%>');"><%=Pointer.getPointer("DERIVED."+patientInvoice.getUid())%></a>
            </td>
        </tr>
        <%	
        	}
        	if(patientInvoice!=null && patientInvoice.getUid()!=null && checkString(Pointer.getPointer("FOLLOW."+patientInvoice.getUid())).length()>0){
        %>
        <tr>
        	<td class='admin'/><td class='admin2'/>
            <td class="admin" nowrap><%=getTran(request,"web.finance","corrected.by.invoice",sWebLanguage)%></td>
            <td class="admin2">
                <a href="javascript:setPatientInvoice('<%=Pointer.getPointer("FOLLOW."+patientInvoice.getUid())%>');"><%=Pointer.getPointer("FOLLOW."+patientInvoice.getUid())%></a>
            </td>
        </tr>
        <%	
        	}
        	if(checkString(patientInvoice.getAcceptationUid()).length()>0){
        %>
        <tr>
        	<td class='admin'/><td class='admin2'/>
            <td class="admin" nowrap><%=getTran(request,"web.finance","accepted.by",sWebLanguage)%></td>
            <td class="admin2">
                <%=MedwanQuery.getInstance().getUserName(Integer.parseInt(patientInvoice.getAcceptationUid())) +" - "+patientInvoice.getAcceptationDate()%>
            </td>
        </tr>
        <%	
        	}
        	if(patientInvoice!=null && patientInvoice.getUid()!=null && checkString(Pointer.getPointer("NOVALIDATE."+patientInvoice.getUid())).length()>0){
        		String refusal=Pointer.getPointer("NOVALIDATE."+patientInvoice.getUid());
        %>
        <tr>
        	<td class='admin'/><td class='admin2'/>
            <td class="admin" nowrap><%=getTran(request,"web.finance","refused.by",sWebLanguage)%></td>
            <td class="admin2">
                <%=MedwanQuery.getInstance().getUserName(Integer.parseInt(refusal.split(";")[0])) +" ("+refusal.split(";")[1]+")"%>
            </td>
        </tr>
        <%	
        	}
        	if(patientInvoice!=null && patientInvoice.getUid()!=null && patientInvoice.getUid().length()>0){
        		String signatures="";
        		Vector pointers=Pointer.getFullPointers("INVSIGN."+patientInvoice.getUid());
        		for(int n=0;n<pointers.size();n++){
        			if(n>0){
        				signatures+=", ";
        			}
        			String ptr=(String)pointers.elementAt(n);
        			signatures+=ptr.split(";")[0]+" - "+ScreenHelper.fullDateFormat.format(new SimpleDateFormat("yyyyMMddHHmmSSsss").parse(ptr.split(";")[1]));
        		}
        		if(patientInvoice.hasPatientSignature()){
        			if(signatures.length()>0){
        				signatures+=", ";
        			}
        			signatures+="<b>"+activePatient.getFullName()+" - "+ScreenHelper.fullDateFormat.format(patientInvoice.getPatientSignatureDate())+"</b>";
        		}
        		if(signatures.length()>0){
	    	        %>
	    	        <tr>
	    	        	<td class='admin'/><td class='admin2'/>
	    	            <td class="admin" nowrap>
	    	            	<%=getTran(request,"web.finance","signed.by",sWebLanguage)%>
	    	            	<%
	    	            		if(activeUser.getAccessRight("removepatientinvoicesignatures.select")){
	    	            	%>
	    	            		<img style='vertical-align: middle' src='<%=sCONTEXTPATH %>/_img/icons/icon_delete.png' onclick='removesignatures()'/>
	    	            	<%
	    	            		}
	    	            	%>
	    	            </td>
	    	            <td class="admin2">
	    	                <%=signatures %>
	    	            </td>
	    	        </tr>
	    	        <%
        		}
        	}
        %>
        <tr>
            <td class='admin' nowrap><%=getTran(request,"Web","date",sWebLanguage)%> *</td>
            <td class='admin2'>
            	<table width='100%' cellspacing='0' cellpadding='0'>
            		<tr>
            	    	<td><img id='dateinpastwarning' style='display: none' src='<c:url value="/_img/icons/icon_warning.gif"/>' title='<%=getTranNoLink("web","dateofopeninvoiceinthepast",sWebLanguage)%>'/><%=ScreenHelper.writeDateField("EditDate","EditForm",ScreenHelper.getSQLDate(patientInvoice.getDate()),true,false,sWebLanguage,sCONTEXTPATH,"redIfInThePast();") %></td>
            	    	<%	if(MedwanQuery.getInstance().getConfigInt("enableDeliveryDateonInvoice",0)==1){ %>
				            <td><%=getTran(request,"Web","estimateddeliverydate",sWebLanguage)%></td>
	            	    	<td><%=writeDateField("EditDeliveryDate","EditForm",checkString(patientInvoice.getEstimatedDeliveryDate()),sWebLanguage)%></td>
            	    	<%	}
            	    		else {
            	    	%>
            	    		<input type='hidden' name='EditDeliveryDate' id='EditDeliveryDate'/>
            	    	<%	} %>
            	    </tr>
            	</table>
            </td>
            <td class='admin' nowrap><%=getTran(request,"Web.finance","patientinvoice.status",sWebLanguage)%> *</td>
            <td class='admin2'>
                <select id="invoiceStatus" class="text" name="EditStatus" onchange="doStatus()"  <%=!activeUser.getAccessRight("financial.modifyinvoicestatus.select") || patientInvoice.getStatus().equalsIgnoreCase("closed") || patientInvoice.getStatus().equalsIgnoreCase("canceled")?"disabled":""%>>
                    <%

                        if(checkString(patientInvoice.getStatus()).equalsIgnoreCase("canceled")){
                            out.print("<option value='canceled'>"+getTran(request,"finance.patientinvoice.status","canceled",sWebLanguage)+"</option>");
                        }
                        else {
                            out.print("<option/>"+ScreenHelper.writeSelectExclude("finance.patientinvoice.status",checkString(patientInvoice.getStatus()),sWebLanguage,false,false,"canceled"));
                        }
                    %>
                </select>
                <%
                	if(MedwanQuery.getInstance().getConfigInt("enableNoshowInvoiceCredit",0)==1 && checkString(patientInvoice.getVerifier()).length()==0 && patientInvoice.getPatientAmount()>0 && activeUser.getAccessRight("financial.invoicenoshow.select")){
                %>
                	<input type='button' class='button' name='noshowButton' value='<%=getTranNoLink("web","noshow",sWebLanguage)%>' onclick='noshow()'/>
                <%
                	}                
                %>
            </td>
        </tr>
        <tr>
            <td class='admin' nowrap><%=getTran(request,"web.finance","balance",sWebLanguage)%></td>
            <td class='admin2'>
                <input class='text' readonly type='text' name='EditBalance' id='EditBalance' value='<%=checkString(Double.toString(patientInvoice.getBalance())).length()>0?new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat")).format(dBalance):""%>' size='20'> <%=MedwanQuery.getInstance().getConfigParam("currency","EUR")%>
                <input type='hidden' name='EditBalanceDetailed' id='EditBalanceDetailed' value='<%=""+dBalance%>' size='20'>
                &nbsp;<%=getTran(request,"web","total",sWebLanguage) %>: <label id='invoiceValue'></label> <%=MedwanQuery.getInstance().getConfigString("currency","EUR") %>
                &nbsp;<%=getTran(request,"web","paid",sWebLanguage) %>: <label id='invoicePaid'></label> <%=MedwanQuery.getInstance().getConfigString("currency","EUR") %>
                &nbsp;100%: <label id='invoice100pct'></label> <%=MedwanQuery.getInstance().getConfigString("currency","EUR") %>
            </td>
            <td class='admin' nowrap><%=getTran(request,"web","period",sWebLanguage)%>&nbsp;<input type="button" class="button" name="update" value="<%=getTran(null,"web","update",sWebLanguage)%>" onclick="loadDebets();"/></td>
            <td class='admin2'>
                   <%=writeDateField("EditBegin", "EditForm", "", sWebLanguage)%>
                   <%=getTran(request,"web","to",sWebLanguage)%>
                   <%=writeDateField("EditEnd", "EditForm", "", sWebLanguage)%>
	            <input type="hidden" name="EditInvoiceService" id="EditInvoiceService" value="">
            </td>
        </tr>
        <%
	        if(patientInvoice==null || patientInvoice.getStatus()==null || patientInvoice.getStatus().equalsIgnoreCase("open") || MedwanQuery.getInstance().getConfigInt("enableInvoiceVerification",0)==1){
        %>
            <tr>
            <% 	
            	if(patientInvoice==null || patientInvoice.getStatus()==null || patientInvoice.getStatus().equalsIgnoreCase("open")){ 
            %>
	            	<td class='admin'><%=getTran(request,"web","service",sWebLanguage)%></td>
	            	<td class='admin2'>
			           	<input class="text" type="text" name="EditInvoiceServiceName" id="EditInvoiceServiceName" readonly size="<%=40%>" value="">
			           	<img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"Web","select",sWebLanguage)%>" onclick="searchService('EditInvoiceService','EditInvoiceServiceName');">
			           	<img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTran(null,"Web","clear",sWebLanguage)%>" onclick="document.getElementById('EditInvoiceService').value='';document.getElementById('EditInvoiceServiceName').value='';">
	                    &nbsp;<input type="button" class="button" name="update2" value="<%=getTran(null,"web","update",sWebLanguage)%>" onclick="loadDebets();"/>
					</td>
			<%
				}
				else {
			%>
				<td class='admin'>&nbsp;</td><td class='admin2'>&nbsp;</td>			                        
	        <%
				}
	            if(MedwanQuery.getInstance().getConfigInt("enableInvoiceVerification",0)==1){ 
	        %>
	            	<td class='admin'><%=getTran(request,"web","verifier",sWebLanguage)%></td>
	            	<td class='admin2'>
			           	<input class="text" type="text" name="EditInvoiceVerifier" id="EditInvoiceVerifier" size="<%=sTextWidth%>" value="<%=sVerifier%>">
					</td>
			<%
				}
				else {
			%>
					<td class='admin'>&nbsp;</td><td class='admin2'>&nbsp;<input type='hidden' name='EditInvoiceVerifier' id='EditInvoiceVerifier' value=''/></td>			                        
	        <%
				}
        %>
        </tr>
        <%
	        }
	        else {
			%>
				<input type='hidden' name='EditInvoiceVerifier' id='EditInvoiceVerifier' value=''/>			                        
	        <%
	        }
			boolean bReduction=false;
			Insurance insurance = null;
           	String pid="0";
           	if(patientInvoice!=null){
           		pid=patientInvoice.getPatientUid();
           	}
           	else if(activePatient!=null){
           		pid=activePatient.personid;
           	}
			if(patientInvoice!=null){
				Vector insurers= patientInvoice.getInsurerObjects();
				SortedSet allowedreductions=new TreeSet();
				for(int n=0;n<insurers.size();n++){
					Insurar insurar = (Insurar)insurers.elementAt(n);
            		String options[]=checkString(insurar.getAllowedReductions()).split(";");
            		for(int i=0;i<options.length;i++){
        				try{
	            			if(!allowedreductions.contains(Integer.parseInt(options[i]))){
            					allowedreductions.add(Integer.parseInt(options[i]));
            				}
            			}
        				catch(Exception e){}
            		}
				}
            	if(activeUser.getAccessRight("financial.invoicereduction.select") && patientInvoice!=null && patientInvoice.getStatus()!=null && patientInvoice.getStatus().equals("open") && allowedreductions.size()>0){
					out.println("<tr><td class='admin'>"+getTran(request,"web","acceptable.reductions",sWebLanguage)+"</td><td class='admin2' colspan='3'>");
        			if(!allowedreductions.contains(0)){
        				allowedreductions.add(0);
        			}
					Iterator iAllowedReductions=allowedreductions.iterator();
					while(iAllowedReductions.hasNext()){
						String reduction = ""+iAllowedReductions.next();
             			out.print("<input type='radio' "+(reduction.equalsIgnoreCase("0") && patientInvoice.getReduction()==null?"checked":"")+" name='reduction' class='text' onclick='removeReductions();doBalance();' onDblClick='uncheckRadio(this);doBalance()' value='"+reduction+"'>"+reduction+"%");
					}
            		bReduction=true;
            		out.print("</td></tr>");
            	}
			}
           	if(!bReduction){
           		out.println("<input type='hidden' name='reduction' id='reduction' value='0'/>");
           	}
        %>
        <tr>
            <td class='admin' nowrap<%=getTran(request,"web.finance","prestations",sWebLanguage)%>></td>
            <td class='admin2' colspan='3'>
                <div style="height:120px;"class="searchResults" id="patientInvoiceDebets" name="patientInvoiceDebets" >
                </div>
                <input accesskey="A" class='button' type="button" id="ButtonDebetSelectAll" name="ButtonDebetSelectAll" value="<%=getTran(null,"web","selectall",sWebLanguage)%>" onclick="selectAll('cbDebet',true,'ButtonDebetSelectAll','ButtonDebetDeselectAll',true);">&nbsp;
                <input accesskey="D" class='button' type="button" id="ButtonDebetDeselectAll" name="ButtonDebetDeselectAll" value="<%=getTran(null,"web","deselectall",sWebLanguage)%>" onclick="selectAll('cbDebet',false,'ButtonDebetDeselectAll','ButtonDebetSelectAll',true);">
            </td>
        </tr>
        <tr>
            <td class='admin' nowrap><%=getTran(request,"web.finance","credits",sWebLanguage)%></td>
            <td class='admin2' colspan='3'>
                <div style="height:120px;"class="searchResults">
                    <table id='creditsTable' width="100%" class="list" cellspacing="1">
                        <tr class="gray">
                            <td width="20"/>
                            <td width="80"><%=getTran(request,"web","date",sWebLanguage)%></td>
                            <td ><%=getTran(request,"web","type",sWebLanguage)%></td>
                            <td align="right"><%=getTran(request,"web","amount",sWebLanguage)%></td>
                        </tr>
                    <%
	                    String sClass = "";
                        out.print(addCredits(vPatientCredits,sClass,true,sWebLanguage));

                        if (!(checkString(patientInvoice.getStatus()).equalsIgnoreCase("closed")||checkString(patientInvoice.getStatus()).equalsIgnoreCase("canceled"))){
                            Vector vUnassignedCredits = PatientCredit.getUnassignedPatientCredits(sPatientId);
                            out.print(addCredits(vUnassignedCredits,sClass,false,sWebLanguage));
                        }
                    %>
                    </table>
                </div>
                <input class='button' type="button" id="ButtonPatientInvoiceSelectAll" name="ButtonPatientInvoiceSelectAll" value="<%=getTran(null,"web","selectall",sWebLanguage)%>" onclick="selectAll('cbPatientInvoice',true,'ButtonPatientInvoiceSelectAll', 'ButtonPatientInvoiceDeselectAll',false);">&nbsp;
                <input class='button' type="button" id="ButtonPatientInvoiceDeselectAll" name="ButtonPatientInvoiceDeselectAll" value="<%=getTran(null,"web","deselectall",sWebLanguage)%>" onclick="selectAll('cbPatientInvoice',false,'ButtonPatientInvoiceDeselectAll', 'ButtonPatientInvoiceSelectAll',false);">
            </td>
        </tr>
        <tr>
            <td class="admin"/>
            <td class="admin2" colspan='3'>
                <%
                if (!(isInsuranceAgent || checkString(patientInvoice.getStatus()).equalsIgnoreCase("closed")||checkString(patientInvoice.getStatus()).equalsIgnoreCase("canceled")||checkString(request.getParameter("nosave")).equalsIgnoreCase("1"))){
                %>
                <input accesskey="S" class='button' type="button" name="buttonSave" value='<%=getTranNoLink("Web","save",sWebLanguage)%>' onclick="doSave(this);">&nbsp;
                <%
                }
                if(MedwanQuery.getInstance().getConfigInt("enableUnsavedProformaInvoice",0)==1){
                %>
                <input class='button' type="button" name="buttonSave" value='<%=getTranNoLink("invoice","proforma",sWebLanguage)%>' onclick="doPrintUnsavedInvoice()">&nbsp;
                <%
                }

                // pdf print button for existing invoices
                if(checkString(patientInvoice.getUid()).length() > 0){
                	if(activeUser.getAccessRightNoSA("financial.patientinvoice.overrideprintrestrictions.select") || patientInvoice.canBePrinted()){
                    %>
                        <%=getTran(request,"Web.Occup","PrintLanguage",sWebLanguage)%>

                        <%
                            String sPrintLanguage = activeUser.person.language;

                            if (sPrintLanguage.length()==0){
                                sPrintLanguage = sWebLanguage;
                            }

                            String sSupportedLanguages = MedwanQuery.getInstance().getConfigString("supportedLanguages","en,fr");
                        %>

                        <select class="text" name="PrintLanguage">
                            <%
                                String tmpLang;
                                StringTokenizer tokenizer = new StringTokenizer(sSupportedLanguages, ",");
                                while (tokenizer.hasMoreTokens()) {
                                    tmpLang = tokenizer.nextToken();

                                    %><option value="<%=tmpLang%>"<%if (tmpLang.equalsIgnoreCase(sPrintLanguage)){out.print(" selected");}%>><%=getTran(request,"Web.language",tmpLang,sWebLanguage)%></option><%
                                }
                            %>
                        </select>
                        <%
                        	String defaultmodel="default";
                        	insurance = Insurance.getMostInterestingInsuranceForPatient(pid);
                        	if(insurance!=null && insurance.getInsurar().getDefaultPatientInvoiceModel()!=null){
                        		defaultmodel=insurance.getInsurar().getDefaultPatientInvoiceModel();
                        	}
                        %>
                        <select class="text" name="PrintModel" id="PrintModel">
                            <option value="default" <%=defaultmodel.equalsIgnoreCase("default")?"selected":""%>><%=getTranNoLink("web","defaultmodel",sWebLanguage)%></option>
                            <option value="ctams" <%=defaultmodel.equalsIgnoreCase("ctams")?"selected":""%>><%=getTranNoLink("web","ctamsmodel",sWebLanguage)%></option>
                            <option value="prestationlist" <%=defaultmodel.equalsIgnoreCase("prestationlist")?"selected":""%>><%=getTranNoLink("web","prestationlist",sWebLanguage)%></option>
		                    <%
		                    	if(MedwanQuery.getInstance().getConfigInt("enableMFP",0)==1){
		                    %>
	                            <option value="mfp" <%=defaultmodel.equalsIgnoreCase("mfp")?"selected":""%>><%=getTranNoLink("web","mfpmodel",sWebLanguage)%></option>
	                            <option value="mfppharma" <%=defaultmodel.equalsIgnoreCase("mfpharma")?"selected":""%>><%=getTranNoLink("web","mfpharmamodel",sWebLanguage)%></option>
                        	<%
                   				}
		                    	if(MedwanQuery.getInstance().getConfigInt("enableCMCK",0)==1){
		                    %>
	                            <option value="cmck" <%=defaultmodel.equalsIgnoreCase("cmck")?"selected":""%>><%=getTranNoLink("web","cmckmodel",sWebLanguage)%></option>
                        	<%
                				}
		                    	if(MedwanQuery.getInstance().getConfigInt("enableHMK",0)==1){
		                    %>
	                            <option value="hmk" <%=defaultmodel.equalsIgnoreCase("hmk")?"selected":""%>><%=getTranNoLink("web","hmkmodel",sWebLanguage)%></option>
                        	<%
                   				}
                        	%>
                        </select>
						<%if(!isInsuranceAgent){ %>
                        <input accesskey="R" class="button" type="button" name="buttonPrint" value='<%=getTranNoLink("Web","print",sWebLanguage)%>' onclick="doPrintPdf('<%=patientInvoice.getUid()%>');">
                        <%}
							boolean bInsurerAllowsProforma=false;
				        	String[] insurers = patientInvoice.getInsurerIds().split(",");
							for(int n=0;n<insurers.length;n++){
								Insurar insurar = Insurar.get(insurers[n].trim());
								if(insurar!=null && insurar.getCanPrintProforma()==1){
									bInsurerAllowsProforma=true;
									break;
								}
							}
							
						if(MedwanQuery.getInstance().getConfigInt("enableAllwaysProformaPatientInvoice",0)==1 || (!checkString(patientInvoice.getStatus()).equalsIgnoreCase("closed") && (MedwanQuery.getInstance().getConfigInt("enableProformaPatientInvoice",0)==1 || activeUser.getAccessRight("financial.printproformapatientinvoice.select") || bInsurerAllowsProforma))){ %>
	                        <input class="button" type="button" name="buttonPrint" value='<%=getTranNoLink("invoice","proforma",sWebLanguage)%>' onclick="doPrintProformaPdf('<%=patientInvoice.getUid()%>');">
	                    	<%if(MedwanQuery.getInstance().getConfigInt("enableDebitNotes",0)==1){ %>
	                        	<input class="button" type="button" name="buttonPrintDebit" value='<%=getTranNoLink("invoice","debetnote",sWebLanguage)%>' onclick="doPrintDebitNotePdf('<%=patientInvoice.getUid()%>');">
                        	<%
	                    	}
						}
                        	if(!isInsuranceAgent && MedwanQuery.getInstance().getConfigInt("javaPOSenabled",0)==1){
                        %>
                        <input class="button" type="button" name="buttonPrint" value='<%=getTranNoLink("Web","print.receipt",sWebLanguage)%>' onclick="doPrintPatientReceipt('<%=patientInvoice.getUid()%>');">
                        <%
                        	}
                        	if(!isInsuranceAgent && MedwanQuery.getInstance().getConfigInt("printPDFreceiptenabled",1)==1){
                        %>
                        <input accesskey="I" class="button" type="button" name="buttonPrint" value='<%=getTranNoLink("Web","print.receipt.pdf",sWebLanguage)%>' onclick="doPrintPatientReceiptPdf('<%=patientInvoice.getUid()%>');">
                        <%
                        	}
                		}
                        %>
                        <%
                        	if(MedwanQuery.getInstance().getConfigInt("enablePatientInvoiceRecreation",0)==1 && activeUser.getAccessRight("financial.modifyinvoice.select") && checkString(patientInvoice.getStatus()).equalsIgnoreCase("closed")){
                        %>
                               	<input class="button" type="button" name="buttonModifyInvoice" value='<%=getTranNoLink("Web.finance","modifyinvoice",sWebLanguage)%>' onclick="doModifyInvoice('<%=patientInvoice.getUid()%>');">
	                    <%
                        	}
                            if (!isInsuranceAgent && !(checkString(patientInvoice.getStatus()).equalsIgnoreCase("canceled"))){
                            	if((MedwanQuery.getInstance().getConfigInt("authorizeCancellationOfOpenInvoices",1)==1 && !patientInvoice.getStatus().equalsIgnoreCase("closed"))||(activeUser.getParameter("sa")!=null && activeUser.getParameter("sa").length() > 0)||activeUser.getAccessRight("financial.cancelclosedinvoice.select")){
                        %>
                                	<input class="button" type="button" name="buttonCancellation" value='<%=getTranNoLink("Web.finance","cancellation",sWebLanguage)%>' onclick="doInvoiceCancel('<%=patientInvoice.getUid()%>');">
                        <%
                            	}
                            	Vector userWickets = Wicket.getWicketsForUser(activeUser.userid);
                            	if(userWickets.size()>0){
                        %>
                              	<input accesskey="P" class="button" type="button" name="buttonPayment" value='<%=getTranNoLink("Web.finance","payment",sWebLanguage)%>' onclick="doPayment('<%=patientInvoice.getUid()%>');">
                        <%
                            	}
                            }
                        if(isInsuranceAgent && checkString(patientInvoice.getUid()).split("\\.").length==2 && checkString(patientInvoice.getAcceptationUid()).length()==0 && Pointer.getPointer("NOVALIDATE."+patientInvoice.getUid()).length()==0){
                        %>
                              	<input class="button" type="button" name="buttonAcceptation" value='<%=getTranNoLink("Web.finance","validation",sWebLanguage)%>' onclick="doValidate('<%=patientInvoice.getUid()%>');">
                              	<input class="button" type="button" name="buttonNoAcceptation" value='<%=getTranNoLink("Web.finance","novalidation",sWebLanguage)%>' onclick="doNotValidate('<%=patientInvoice.getUid()%>');">
                        <%
                        }
                        if(!isInsuranceAgent && activeUser.getAccessRight("occup.signinvoices.select") && (MedwanQuery.getInstance().getConfigInt("patientInvoiceSingleSignature",0)==0 || Pointer.getFullPointers("INVSIGN."+patientInvoice.getUid()).size()==0)){
	                    %>
                              	<input class="button" type="button" name="buttonSignature" value='<%=getTranNoLink("Web.finance","signature",sWebLanguage)%>' onclick="doSign('<%=patientInvoice.getUid()%>');">
                       	<%
                        }
                        if(checkString(patientInvoice.getStatus()).equalsIgnoreCase("closed") && MedwanQuery.getInstance().getConfigInt("enablePatientInvoicePatientSignature",0)==1){
	                    %>
                              	<input class="button" type="button" name="buttonPatientSignature" value='<%=getTranNoLink("Web","patientsignature",sWebLanguage)%>' onclick="doPatientSign('<%=patientInvoice.getUid()%>');">
                       	<%
                        }
                        if(checkString(patientInvoice.getStatus()).equalsIgnoreCase("open") && activeUser.getAccessRight("occup.transferinvoiceinsurer.select")){
	                    %>
                            <input class="button" type="button" name="buttonTransferInsurer" value='<%=getTranNoLink("Web.finance","transfer.insurer",sWebLanguage)%>' onclick="doTransfer('<%=patientInvoice.getUid()%>');">
                        <%
                        }
                        if(activeUser.getAccessRight("occup.correctinvoice.select")){
	                    %>
                            <input class="button" type="button" name="buttonCorrect" value='<%=getTranNoLink("Web.finance","correctinvoice",sWebLanguage)%>' onclick='requestCorrection();');">
                        <%
                        }
	                }
	                %>
	            </td>
	        </tr>
	        <tr id="editrequestcorrection" style='display: none'>
	            <td class="admin"><%=getTran(request,"web.finance","correctinvoice",sWebLanguage) %></td>
	            <td class="admin2" colspan='3'>
	            	<table width='100%'>
	            		<tr>
	            			<td>
				            	<%
				            		java.util.Date correctionRequestDate = Pointer.getPointerDate(checkString(patientInvoice.getUid())+".INV.CORRECT");
				            	%>
								<textarea style='border:3px solid red' <%=activeUser.getAccessRight("occup.correctinvoice.select")?"":"readonly" %> name="EditInvoiceCorrection" id="EditInvoiceCorrection" cols="120" rows="4"><%=Pointer.getPointer(checkString(patientInvoice.getUid())+".INV.CORRECT").replaceAll("\n"," ").replaceAll("\r"," ").replaceAll("'","´") %></textarea>	       
								<%if(activeUser.getAccessRight("occup.correctinvoice.select")){ %>    
									<input type='button' class='button' name='storeCorrectionRequestButton' value='<%=getTran(null,"web","save",sWebLanguage) %>' onclick='storeCorrectionRequest()'/>
								<%}
								  if(correctionRequestDate!=null && Pointer.getPointerAfter(checkString(patientInvoice.getUid())+".INV.CORROK", correctionRequestDate).length()==0){  
								%> 	
									<input type='button' class='button' name='markCorrectedButton' value='<%=getTran(null,"web","corrected",sWebLanguage) %>' onclick='markCorrected()'/>
								<%} %>
							</td>
						</tr>
						<%
							if(correctionRequestDate!=null && Pointer.getPointerAfter(checkString(patientInvoice.getUid())+".INV.CORROK", correctionRequestDate).length()>0){
								java.util.Date correctionDate=Pointer.getPointerDate(checkString(patientInvoice.getUid())+".INV.CORROK");
								%>
								<tr>
									<td>
										<%=getTran(request,"web","correctedby",sWebLanguage)+": <b>"+User.getFullUserName(Pointer.getPointerAfter(checkString(patientInvoice.getUid())+".INV.CORROK", correctionRequestDate)) +"</b> "+getTran(request,"web","on",sWebLanguage)+" "+ScreenHelper.formatDate(correctionDate,new SimpleDateFormat("dd/MM/yyyy HH:mm"))%>
									</td>
								</tr>
								<%
							}
						%>
					</table>
	            </td>
	        </tr>
	    </table>
	    <%=getTran(request,"Web","colored_fields_are_obligate",sWebLanguage)%>.
	    <div id="divMessage"></div>
	    <input type='hidden' id="EditPatientInvoiceUID" name='EditPatientInvoiceUID' value='<%=checkString(patientInvoice.getUid())%>'>
	</form>
	<script>
		var printwindow=null;
		if(document.getElementById("EditInvoiceCorrection").value.trim()!=''){
			document.getElementById("editrequestcorrection").style.display="";
		}
		function requestCorrection(){
			document.getElementById("editrequestcorrection").style.display="";
			document.getElementById("EditInvoiceCorrection").focus();
		}
		
		function storeCorrectionRequest(){
			if(document.getElementById('EditInvoiceCorrection').value!='<%=Pointer.getPointer(checkString(patientInvoice.getUid())+".INV.CORRECT").replaceAll("\n"," ").replaceAll("\r"," ").replaceAll("'","´") %>'){
		        var today = new Date();
		        var url= '<c:url value="/financial/storeCorrectionRequest.jsp"/>?ts='+today;
		        new Ajax.Request(url,{
		              method: "POST",
		              postBody: 'EditPatientInvoiceUID=' + document.getElementById('EditPatientInvoiceUID').value+
		              			'&EditInvoiceCorrection='+ document.getElementById('EditInvoiceCorrection').value,
		              onSuccess: function(resp){
		                  $('FindPatientInvoiceUID').value=document.getElementById('EditPatientInvoiceUID').value;
		            	  doFind();
		              },
		              onFailure: function(){
		                  $('divMessage').innerHTML = "Error in function storeCorrectionRequest() => AJAX";
		              }
		          }
		        );
			}
			else{
				alert('<%=getTranNoLink("web","nochanges",sWebLanguage)%>');
			}
		}
		
		function markCorrected(){
	        var today = new Date();
	        var url= '<c:url value="/financial/markCorrected.jsp"/>?ts='+today;
	        new Ajax.Request(url,{
	              method: "POST",
	              postBody: 'EditPatientInvoiceUID=' + document.getElementById('EditPatientInvoiceUID').value+
        			'&EditUserUID=<%=activeUser.userid%>',
	              onSuccess: function(resp){
	                  $('FindPatientInvoiceUID').value=document.getElementById('EditPatientInvoiceUID').value;
	            	  doFind();
	              },
	              onFailure: function(){
	                  $('divMessage').innerHTML = "Error in function markCorrected() => AJAX";
	              }
	          }
	        );
		}
		
		function doValidate(invoiceuid){
	        var today = new Date();
	        var url= '<c:url value="/financial/patientInvoiceValidate.jsp"/>?ts='+today;
	        new Ajax.Request(url,{
	              method: "POST",
	              postBody: 'EditInvoiceUID=' + invoiceuid,
	              onSuccess: function(resp){
	                  $('FindPatientInvoiceUID').value=invoiceuid;
	            	  doFind();
	              },
	              onFailure: function(){
	                  $('divMessage').innerHTML = "Error in function manageTranslationsStore() => AJAX";
	              }
	          }
	        );
		}
	
		function doNotValidate(invoiceuid){
		    openPopup("/financial/patientInvoiceNoValidate.jsp&ts=<%=getTs()%>&invoiceuid="+invoiceuid,500,200);
		}
	
		function doPatientSign(invoiceuid){
		    openPopup("/util/manageSignature.jsp&ts=<%=getTs()%>&signatureuid="+invoiceuid+".INVOICE_SIGN",600,300);
		}
	
		function doSign(invoiceuid){
	        var today = new Date();
	        var url= '<c:url value="/financial/patientInvoiceSign.jsp"/>?ts='+today;
	        new Ajax.Request(url,{
	              method: "POST",
	              postBody: 'EditInvoiceUID=' + invoiceuid,
	              onSuccess: function(resp){
	                  $('FindPatientInvoiceUID').value=invoiceuid;
	            	  doFind();
	            	  <%=sExternalSignatureCode%>
	            	  <%
	            	  	if(sExternalSignatureCode.length()>0){
	            	  %>
	            	  		window.close();
	            	  <%
	            	  	}
	            	  %>
	              },
	              onFailure: function(){
	                  $('divMessage').innerHTML = "Error in function patientInvoiceSign() => AJAX";
	              }
	          }
	        );
		}

		
	    function doSave(){
	    	<%
	    		if(MedwanQuery.getInstance().getConfigInt("askForInvoiceCreationConfirmation",0)==1){
	    	%>
	    			yesnoModalBox("doSaveInvoice()","<%=ScreenHelper.getTranNoLink("Web","areYouSureToCreateInvoice",sWebLanguage)%>");
	    	<%
	    		}
	    		else{
	    	%>
	    			doSaveInvoice();
	    	<%
	    		}
	    	%>
	    }
	    
	    function doSaveInvoice(){
	        var bInvoiceSeries=false;
	        var sInvoiceSeries="";
	        if(EditForm.invoiceseries){
	        	for (var i=0; i < EditForm.invoiceseries.length; i++){
	        	   if (EditForm.invoiceseries[i].checked){
	        	      bInvoiceSeries=true;
	        	      sInvoiceSeries=EditForm.invoiceseries[i].value;
	        	   }
	        	}
	        }
	        else {
				bInvoiceSeries=true;
	        }
	    	var mandatoryReferenceError=0;
	        if(document.getElementById('mandatoryReferenceInsurers').value.length>0 && document.getElementById('EditInsurarReference').value.length==0){
        		var elements = document.getElementsByTagName("input");
    	    	for(var n=0;n<elements.length;n++){
    	    		if(elements[n].name.indexOf("cbDebet")==0 && elements[n].checked){
    	    			if(document.getElementById("mandatoryReferenceInsurers").value.indexOf("*"+document.getElementById(elements[n].name.split("=")[0].replace("cbDebet","cbDebetInsurance")).value+"*")>-1){
    	    				mandatoryReferenceError=1;
    	    				break;
    	    			}
    	    		}
    	    	}
	        }
	    	var mandatoryOtherReferenceError=0;
	        if(document.getElementById('mandatoryOtherReferenceInsurers').value.length>0 && document.getElementById('EditComment').value.length==0){
	    		var elements = document.getElementsByTagName("input");
		    	for(var n=0;n<elements.length;n++){
		    		if(elements[n].name.indexOf("cbDebet")==0 && elements[n].checked){
		    			if(document.getElementById("mandatoryOtherReferenceInsurers").value.indexOf("*"+document.getElementById(elements[n].name.split("=")[0].replace("cbDebet","cbDebetInsurance")).value+"*")>-1){
		    				mandatoryOtherReferenceError=1;
		    				break;
		    			}
		    		}
		    	}
	        }
	        if ((document.getElementById('EditDate').value.length>8)&&(!document.getElementById('invoiceStatus').selectedIndex || document.getElementById('invoiceStatus').selectedIndex>-1)&&bInvoiceSeries){
	        	var invoiceDate = new Date(document.getElementById('EditDate').value.substring(6)+"/"+document.getElementById('EditDate').value.substring(3,5)+"/"+document.getElementById('EditDate').value.substring(0,2));
	            if(invoiceDate> new Date()){
	                var popupUrl = "<c:url value="/popup.jsp"/>?Page=_common/search/okPopup.jsp&ts=<%=getTs()%>&labelType=web.manage&labelID=dateinfuture";
	                var modalities = "dialogWidth:266px;dialogHeight:163px;center:yes;scrollbars:no;resizable:no;status:no;location:no;";
	                (window.showModalDialog)?window.showModalDialog(popupUrl,"",modalities):window.confirm("<%=getTranNoLink("web.manage","dateinfuture",sWebLanguage)%>");
	            }
		        <%
	        	boolean canCloseUnpaidInvoice=(activeUser.getParameter("sa")!=null && activeUser.getParameter("sa").length() > 0)||activeUser.getAccessRight("financial.closeunpaidinvoice.select");
		        if(!canCloseUnpaidInvoice){
		        %>
		            else if(document.getElementById('EditBalance').value.replace('.','').replace('0','').length>0 && document.getElementById('EditBalance').value*1>=<%=MedwanQuery.getInstance().getConfigString("minimumInvoiceBalance","1")%> && document.getElementById('invoiceStatus').value=="closed"){
		                var popupUrl = "<c:url value="/popup.jsp"/>?Page=_common/search/okPopup.jsp&ts=<%=getTs()%>&labelType=web.manage&labelID=cannotcloseunpaidinvoice";
		                var modalities = "dialogWidth:266px;dialogHeight:163px;center:yes;scrollbars:no;resizable:no;status:no;location:no;";
		                (window.showModalDialog)?window.showModalDialog(popupUrl,"",modalities):window.confirm("<%=getTranNoLink("web.manage","cannotcloseunpaidinvoice",sWebLanguage)%>");
		            }
		        <%
	        	}
	        	if(MedwanQuery.getInstance().getConfigInt("enableCloseAntedatedInvoices",1)==0 && !activeUser.getAccessRightNoSA("financial.closeantedatedinvoice.select")){
		        %>
		            else if(invoiceDate<new Date(new Date().getFullYear(),new Date().getMonth(),new Date().getDate(),0,0,0,0) && document.getElementById('invoiceStatus').value=="closed"){
		            	var popupUrl = "<c:url value="/popup.jsp"/>?Page=_common/search/okPopup.jsp&ts=<%=getTs()%>&labelType=web.manage&labelID=cannotcloseantedatedinvoice";
		                var modalities = "dialogWidth:266px;dialogHeight:163px;center:yes;scrollbars:no;resizable:no;status:no;location:no;";
		                (window.showModalDialog)?window.showModalDialog(popupUrl,"",modalities):window.confirm("<%=getTranNoLink("web.manage","cannotcloseantedatedinvoice",sWebLanguage)%>");
		            }
		        <%
	        	}
		        %>
	        	else if(mandatoryReferenceError==1){
	                window.confirm("´<%=getTran(request,"web.finance","insurarreference",sWebLanguage)+"´ "+getTranNoLink("web","ismandatory",sWebLanguage)%>");
	            }
	        	else if(mandatoryOtherReferenceError==1){
	                window.confirm("´<%=getTran(request,"web.finance","otherreference",sWebLanguage)+"´ "+getTranNoLink("web","ismandatory",sWebLanguage)%>");
	            }
	            else {
	            	var originalStatus=document.getElementById('invoiceStatus').selectedIndex;
	            	if (<%=MedwanQuery.getInstance().getConfigInt("enableAutomaticInvoiceClosure",1)%>==1 && (document.getElementById('EditBalance').value*1==0)&&(document.getElementById('invoiceStatus').value!="closed")&&(document.getElementById('invoiceStatus').value!="canceled") && (<%=MedwanQuery.getInstance().getConfigInt("enableCloseAntedatedInvoices",1)%>==1 || invoiceDate>=new Date(new Date().getFullYear(),new Date().getMonth(),new Date().getDate(),0,0,0,0) || <%=activeUser.getAccessRightNoSA("financial.closeantedatedinvoice.select")?"true":"false"%>) ){
		                var popupUrl = "<c:url value='/popup.jsp'/>?Page=_common/search/yesnoPopup.jsp&ts=<%=getTs()%>&labelType=web.finance&labelID=closetheinvoice";
		                var modalities = "dialogWidth:266px;dialogHeight:143px;center:yes;scrollbars:no;resizable:no;status:no;location:no;";
		                var answer = (window.showModalDialog)?window.showModalDialog(popupUrl,"",modalities):window.confirm("<%=getTranNoLink("web.finance","closetheinvoice",sWebLanguage)%>");
		
		                if(answer==1){
		                    EditForm.EditStatus.value = "closed";
		                }
		            }
		
		            var sCbs = "";
		            for(i = 0; i < EditForm.elements.length; i++) {
		                elm = EditForm.elements[i];
		
		                if ((elm.type == 'checkbox'||elm.type == 'hidden')&&(elm.checked)) {
		                    sCbs += elm.name.split("=")[0]+",";
		                }
		            }
					reduction=-1;
			    	var reductions=document.getElementsByName('reduction');
					if(reductions[0] && reductions[0].type=='radio'){
						for(var n=0;n<reductions.length;n++){
							if(reductions[n].checked){
								reduction=reductions[n].value*1;
							}
				    	}
					}
					else {
						reduction=0;
					}
					red="";
					if(reduction!=-1){
						red=reduction;
					}
		            var today = new Date();
		            var url= '<c:url value="/financial/patientInvoiceSave.jsp"/>?ts='+today;
		            document.getElementById('divMessage').innerHTML = "<img src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/><br/>Loading";
		            var status="";
		            if(document.getElementById('invoiceStatus').selectedIndex){
		            	status=document.getElementById("invoiceStatus").options[document.getElementById("invoiceStatus").selectedIndex].value;
		            }
		            else{
		            	status=document.getElementById('invoiceStatus').value;
		            }
		            new Ajax.Request(url,{
		                  method: "POST",
		                  postBody: 'EditDate=' + document.getElementById('EditDate').value
		                          +'&EditDeliveryDate=' + EditForm.EditDeliveryDate.value
		                          +'&EditPatientInvoiceUID=' + EditForm.EditPatientInvoiceUID.value
		                          +'&EditInvoiceUID=' + EditForm.EditInvoiceUID.value
		                          +'&EditStatus=' + status
		                          +'&EditCBs='+sCbs
		                          +'&EditInvoiceSeries='+sInvoiceSeries
		                          +'&EditLinkedService='+EditForm.EditLinkedService.value
		                          +'&EditInsurarReference='+EditForm.EditInsurarReference.value
		                          +'&EditInsurarReferenceDate='+EditForm.EditInsurarReferenceDate.value
		                          +'&EditInvoiceVerifier='+document.getElementById('EditInvoiceVerifier').value
		                          +'&EditReduction='+red
		                          +'&EditInvoiceCorrection='+document.getElementById("EditInvoiceCorrection")
		                          +'&EditComment='+document.getElementById('EditComment').value
		              	        <% if(MedwanQuery.getInstance().getConfigInt("enableMFP",0)==1 && MedwanQuery.getInstance().getConfigInt("hideMFPInvoiceFields",0)==0){ %>
		                          +'&EditInvoiceDoctor='+document.getElementById('EditInvoiceDoctor').value
		                          +'&EditInvoicePost='+document.getElementById('EditInvoicePost').value
		                          +'&EditInvoiceAgent='+document.getElementById('EditInvoiceAgent').value
		                          +'&EditInvoiceDrugsRecipient='+document.getElementById('EditInvoiceDrugsRecipient').value
		                          +'&EditInvoiceDrugsIdCard='+document.getElementById('EditInvoiceDrugsIdCard').value
		                          +'&EditInvoiceDrugsIdCardDate='+document.getElementById('EditInvoiceDrugsIdCardDate').value
		                          +'&EditInvoiceDrugsIdCardPlace='+document.getElementById('EditInvoiceDrugsIdCardPlace').value
		                        <%}
		              	        else if(MedwanQuery.getInstance().getConfigInt("enableMFP",0)==1 && MedwanQuery.getInstance().getConfigInt("hideCCBRTInvoiceFields",1)==0){ 
		              	        %>
		                          +'&EditInvoiceDoctor='+(document.getElementById('EditInvoiceDoctor')?document.getElementById('EditInvoiceDoctor').value:"")
		                          +'&EditInvoicePost='+(document.getElementById('EditInvoicePost')?document.getElementById('EditInvoicePost').value:"")
		                          +'&EditInvoiceDrugsRecipient='+(document.getElementById('EditInvoiceDrugsRecipient')?document.getElementById('EditInvoiceDrugsRecipient').value:"")
		                        <%}
		                        %>
		                          +'&EditBalance=' + document.getElementById('EditBalance').value,
		                  onSuccess: function(resp){
		                      var label = eval('('+resp.responseText+')');
		                      var referenceMandatory=label.ReferenceMandatory;
		                      var otherReferenceMandatory=label.OtherReferenceMandatory;
		                      var uniqueInsurerReferenceMandatory=label.UniqueInsurerReferenceRequired;
		                      var uniqueOtherReferenceMandatory=label.UniqueOtherReferenceRequired;
		                      var uniqueDoctorMandatory=label.UniqueDoctorRequired;
							  if(uniqueInsurerReferenceMandatory=="1"){
		      	                  window.confirm("´<%=getTran(request,"web.finance","insurarreference",sWebLanguage)+"´ "+getTranNoLink("web","mustbeunique",sWebLanguage)%>");
		      	                  document.getElementById('invoiceStatus').selectedIndex=originalStatus;
		      	                  document.getElementById('divMessage').innerHTML =	"";	                      }
		                      else if(uniqueOtherReferenceMandatory=="1"){
		      	                  window.confirm("´<%=getTran(request,"web.finance","otherreference",sWebLanguage)+"´ "+getTranNoLink("web","mustbeunique",sWebLanguage)%>");
		      	                  document.getElementById('invoiceStatus').selectedIndex=originalStatus;
		      	                  document.getElementById('divMessage').innerHTML =	"";	                      }
		                      else if(uniqueDoctorMandatory=="1"){
		      	                  window.confirm("´<%=getTran(request,"web.finance","ccbrt.specialauthorizationnumber",sWebLanguage)+"´ "+getTranNoLink("web","mustbeunique",sWebLanguage)%>");
		      	                  document.getElementById('invoiceStatus').selectedIndex=originalStatus;
		      	                  document.getElementById('divMessage').innerHTML =	"";	                      }
		                      else{
			                      $('divMessage').innerHTML=label.Message;
			                      $('EditPatientInvoiceUID').value=label.EditPatientInvoiceUID;
			                      $('EditInvoiceUID').value=label.EditInvoiceUID;
			                      $('EditInvoiceUIDText').value=label.EditInvoiceUID;
			                      $('EditComment').value=label.EditComment;
			                      $('EditInsurarReference').value=label.EditInsurarReference;
			                      $('EditInsurarReferenceDate').value=label.EditInsurarReferenceDate;
			                      $('FindPatientInvoiceUID').value=label.EditInvoiceUID;
			                      doFind();
		                  	  }
		                  },
		                  onFailure: function(){
		                      $('divMessage').innerHTML = "Error in function manageTranslationsStore() => AJAX";
		                  }
		              }
		            );
		        }
	        }
	        else {
	                    window.showModalDialog?alertDialog("web.manage","dataMissing"):alertDialogDirectText('<%=getTran(null,"web.manage","dataMissing",sWebLanguage)%>');
	        }
	    }
	
   		function doPrintUnsavedInvoice(){
	        var bInvoiceSeries=false;
	        var sInvoiceSeries="";
	        if(EditForm.invoiceseries){
	        	for (var i=0; i < EditForm.invoiceseries.length; i++){
	        	   if (EditForm.invoiceseries[i].checked){
	        	      bInvoiceSeries=true;
	        	      sInvoiceSeries=EditForm.invoiceseries[i].value;
	        	   }
	        	}
	        }
	        else {
				bInvoiceSeries=true;
	        }
	        var originalStatus=document.getElementById('invoiceStatus').selectedIndex;

    	    var sCbs = "";
        	for(i = 0; i < EditForm.elements.length; i++) {
             	elm = EditForm.elements[i];

             	if ((elm.type == 'checkbox'||elm.type == 'hidden')&&(elm.checked)) {
                	sCbs += elm.name.split("=")[0]+",";
             	}
        	}
			reduction=-1;
			var reductions=document.getElementsByName('reduction');
			if(reductions[0] && reductions[0].type=='radio'){
				for(var n=0;n<reductions.length;n++){
					if(reductions[n].checked){
						reduction=reductions[n].value*1;
					}
		   		}
			}
			else {
				reduction=0;
			}
			red="";
			if(reduction!=-1){
				red=reduction;
		 	}
         	var today = new Date();
         	if(document.getElementById('invoiceStatus').selectedIndex){
         		status=document.getElementById("invoiceStatus").options[document.getElementById("invoiceStatus").selectedIndex].value;
         	}
         	else{
         		status=document.getElementById('invoiceStatus').value;
         	}
            parameters= 'EditDate=' + document.getElementById('EditDate').value
                       +'&EditDeliveryDate=' + EditForm.EditDeliveryDate.value
                       +'&EditPatientInvoiceUID=' + EditForm.EditPatientInvoiceUID.value
                       +'&EditInvoiceUID=' + EditForm.EditInvoiceUID.value
                       +'&EditStatus=' + status
                       +'&EditCBs='+sCbs
                       +'&EditInvoiceSeries='+sInvoiceSeries
                       +'&EditInsurarReference='+EditForm.EditInsurarReference.value
                       +'&EditInsurarReferenceDate='+EditForm.EditInsurarReferenceDate.value
                       +'&EditInvoiceVerifier='+document.getElementById('EditInvoiceVerifier').value
                       +'&EditReduction='+red
                       +'&EditInvoiceCorrection='+document.getElementById("EditInvoiceCorrection")
                       +'&EditComment='+document.getElementById('EditComment').value
           	        <% if(MedwanQuery.getInstance().getConfigInt("enableMFP",0)==1 && MedwanQuery.getInstance().getConfigInt("hideMFPInvoiceFields",0)==0){ %>
                    	+'&EditInvoiceDoctor='+document.getElementById('EditInvoiceDoctor').value
                    	+'&EditInvoicePost='+document.getElementById('EditInvoicePost').value
                    	+'&EditInvoiceAgent='+document.getElementById('EditInvoiceAgent').value
                    	+'&EditInvoiceDrugsRecipient='+document.getElementById('EditInvoiceDrugsRecipient').value
                    	+'&EditInvoiceDrugsIdCard='+document.getElementById('EditInvoiceDrugsIdCard').value
                    	+'&EditInvoiceDrugsIdCardDate='+document.getElementById('EditInvoiceDrugsIdCardDate').value
                    	+'&EditInvoiceDrugsIdCardPlace='+document.getElementById('EditInvoiceDrugsIdCardPlace').value
                  	<%}
        	        else if(MedwanQuery.getInstance().getConfigInt("enableMFP",0)==1 && MedwanQuery.getInstance().getConfigInt("hideCCBRTInvoiceFields",1)==0){ 
        	        %>
                    	+'&EditInvoiceDoctor='+(document.getElementById('EditInvoiceDoctor')?document.getElementById('EditInvoiceDoctor').value:"")
                    	+'&EditInvoicePost='+(document.getElementById('EditInvoicePost')?document.getElementById('EditInvoicePost').value:"")
                    	+'&EditInvoiceDrugsRecipient='+(document.getElementById('EditInvoiceDrugsRecipient')?document.getElementById('EditInvoiceDrugsRecipient').value:"")
                  	<%}
                  	%>
                    +'&EditBalance=' + document.getElementById('EditBalance').value;
            var url= '<c:url value="/financial/printUnsavedInvoicePdf.jsp"/>?ts='+today+"&"+parameters;
	        window.open(url,"PatientInvoicePdf<%=new java.util.Date().getTime()%>","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
    	}

	    function selectAll(sStartsWith,bValue,buttonDisable,buttonEnable,bAdd){
	      for(i=0; i<EditForm.elements.length; i++){
	        elm = EditForm.elements[i];
	
	        if(elm.name.indexOf(sStartsWith)>-1){
	          if((elm.type == 'checkbox')&&(elm.checked!=bValue)){
	            elm.checked = bValue;
	            doBalance(elm, bAdd);
	          }
	        }
	      }	
	    }
	
	    function doBalance(){
	    	total=0.01;
	    	total=0;
	    	paid=0.01;
	    	paid=0;
	    	insurar=0.01;
	    	insurar=0;
	    	reduction=0.1;
	    	reduction=0;
	    	var elements = document.getElementsByTagName("input");
	    	for(var n=0;n<elements.length;n++){
	    		if(elements[n].name.indexOf("cbDebet")==0 && elements[n].checked){
	    			total+=parseFloat(elements[n].name.split("=")[1].replace(",","."))*1;
	    			insurar+=parseFloat("0"+document.getElementById(elements[n].name.split("=")[0].replace("cbDebet","cbDebetInsurar")).value)*1;
	    		}
	    		else if(elements[n].name.indexOf("cbPatientInvoice")==0 && elements[n].checked){
	    			paid+=parseFloat(elements[n].name.split("=")[1].replace(",","."))*1;
	    		}
	    	}
	    	document.getElementById('invoiceValue').innerHTML='<b>'+total.toFixed(<%=MedwanQuery.getInstance().getConfigInt("currencyDecimals",2)%>)+'</b>';
	    	document.getElementById('invoicePaid').innerHTML='<b>'+paid.toFixed(<%=MedwanQuery.getInstance().getConfigInt("currencyDecimals",2)%>)+'</b>';
	    	document.getElementById('invoice100pct').innerHTML='<b>'+((insurar+total).toFixed(<%=MedwanQuery.getInstance().getConfigInt("currencyDecimals",2)%>))+'</b>';
			var reductions=document.getElementsByName('reduction');
			if(reductions[0] && reductions[0].type=='radio'){
				for(var n=0;n<reductions.length;n++){
					if(reductions[n].checked){
						reduction=reductions[n].value;
					}
		    	}
			}
	    	document.getElementById('EditBalance').value = (total-paid-(total*reduction/100)).toFixed(<%=MedwanQuery.getInstance().getConfigInt("currencyDecimals",2)%>)*1;
	    	document.getElementById('EditBalanceDetailed').value = (total-paid-(total*reduction/100)).toFixed(2)*1;
	    }
	
	    function doPrintPdf(invoiceUid){
	        if (<%=activeUser.getAccessRight("financial.printopeninvoice.select")?"1":"0"%>==0 && ("<%=sClosed%>"!="closed")&&("<%=sClosed%>"!="canceled")){
	            alert("<%=getTranNoLink("web","closetheinvoicefirst",sWebLanguage)%>");
	        }
	        else {
	            var url = "<c:url value='/financial/createPatientInvoicePdf.jsp'/>?Proforma=no&InvoiceUid="+invoiceUid+"&ts=<%=getTs()%>&PrintLanguage="+EditForm.PrintLanguage.value+"&PrintModel="+EditForm.PrintModel.value;
	            printwindow=window.open(url,"PatientInvoicePdf<%=new java.util.Date().getTime()%>","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
	        }
	    }
	
	    function closeDeadWindow(){
	    	if(printwindow.document.URL==""){
	    		printwindow.close();
	    	}	
	    }
	    
	    function doPrintProformaPdf(invoiceUid){
  	        var url = "<c:url value='/financial/createPatientInvoicePdf.jsp'/>?Proforma=yes&InvoiceUid="+invoiceUid+"&ts=<%=getTs()%>&PrintLanguage="+EditForm.PrintLanguage.value+"&PrintModel="+EditForm.PrintModel.value;
	        window.open(url,"PatientInvoicePdf<%=new java.util.Date().getTime()%>","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
	    }
		
   	    function doPrintDebitNotePdf(invoiceUid){
 	        var url = "<c:url value='/financial/createPatientInvoicePdf.jsp'/>?Proforma=debetnote&InvoiceUid="+invoiceUid+"&ts=<%=getTs()%>&PrintLanguage="+EditForm.PrintLanguage.value+"&PrintModel="+EditForm.PrintModel.value;
   	        window.open(url,"PatientInvoicePdf<%=new java.util.Date().getTime()%>","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
   	    }
   		
	    function doPrintPatientReceiptPdf(invoiceUid){
	        if (("<%=sClosed%>"!="closed")&&("<%=sClosed%>"!="canceled")){
	            alert("<%=getTranNoLink("web","closetheinvoicefirst",sWebLanguage)%>");
	        }
	        else {
	            var url = "<c:url value='/financial/createPatientInvoiceReceiptPdf.jsp'/>?InvoiceUid="+invoiceUid+"&ts=<%=getTs()%>&PrintLanguage="+EditForm.PrintLanguage.value;
	            window.open(url,"PatientInvoicePdf<%=new java.util.Date().getTime()%>","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
            }
	    }
		
	    function doModifyInvoice(invoiceuid){
		    var params = '';
		    var today = new Date();
		    var url= '<c:url value="/financial/recreateInvoice.jsp"/>?invoiceuid='+invoiceuid+'&ts='+today;
		    document.getElementById('patientInvoiceDebets').innerHTML = "<img src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/><br/>Loading";
		    new Ajax.Request(url,{
			  method: "GET",
		      parameters: params,
		      onSuccess: function(resp){
		       	var label = eval('('+resp.responseText+')');
		       	if(label.invoiceuid.length>0){
		          setPatientInvoice(label.invoiceuid);
		        };
		      },
			  onFailure: function(request, status, error){
				alert(request.responseText);
		      }
		    });
		  }
		    
		  function setPatientInvoice(sUid){
		    FindForm.FindPatientInvoiceUID.value = sUid;
		    FindForm.submit();
		  }
		
		  function doPrintPatientReceipt(invoiceUid){
		    var params = '';
		    var today = new Date();
		    var url= '<c:url value="/financial/printPatientReceiptOffline.jsp"/>?invoiceuid='+invoiceUid+'&ts='+today+'&language=<%=sWebLanguage%>&userid=<%=activeUser.userid%>';
		    new Ajax.Request(url,{
			  method: "GET",
		      parameters: params,
		      onSuccess: function(resp){
		        var label = eval('('+resp.responseText+')');
		        if(label.message.length>0){
		          alert(label.message.unhtmlEntities());
		        };
		      },
			  onFailure: function(request, status, error){
			    alert(request.responseText);
		      }
		    });
		  }
	
		  function loadOpenPatientInvoices(){
		    var params = '';
		    var today = new Date();
		    var url= '<c:url value="/financial/patientInvoiceGetOpenPatientInvoices.jsp"/>?PatientId=<%=sPatientId%>&ts='+today;
		    document.getElementById('divOpenPatientInvoices').innerHTML = "<img src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/><br/>Loading";
		    new Ajax.Request(url,{
			  method: "GET",
		      parameters: params,
		      onSuccess: function(resp){
		        $('divOpenPatientInvoices').innerHTML=resp.responseText;
		      }
		    });
		  }
	
		  function loadDebets(){
		    var params = '';
		    var today = new Date();
		    var url= '<c:url value="/financial/getPatientDebets.jsp"/>?PatientUID=<%=sPatientId%>&PatientInvoiceUID='+EditForm.EditPatientInvoiceUID.value+'&EditInvoiceService=' +EditForm.EditInvoiceService.value+'&Begin='+EditForm.EditBegin.value+'&End='+EditForm.EditEnd.value+'&ts='+today;
		    document.getElementById('patientInvoiceDebets').innerHTML = "<img src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/><br/>Loading";
		    new Ajax.Request(url,{
			  method: "GET",
		      parameters: params,
		      onSuccess: function(resp){
		        $('patientInvoiceDebets').innerHTML=resp.responseText;
		        doBalance();
		      }
		    });
		  }
		
		  function doStatus(){
		  }
		    
		  function activateReductions(){
		    var elements = document.getElementsByName("reduction");
			if(elements[0].type=='radio'){
			  elements[0].checked=true;
			}
		  }
		    
		  function removeReductions(){
			  	table = document.getElementById('creditsTable');
	        var rowCount = table.rows.length;
	            
	        for(var i=1; i<rowCount; i++){
	          var row = table.rows[i];
	          var chkbox = row.cells[0].childNodes[0];
	          if(null!=chkbox && chkbox.id.indexOf('reduction')==0){
	            table.deleteRow(i);
	            rowCount--;
	            i--;
	          }
	        }
			//activateReductions();
		  }
		    
		  function removeReductions2(){
		    var elements = document.getElementsByTagName("input");
		    for(var n=0;n<elements.length;n++){
		      if(elements[n].name.indexOf("cbPatientInvoice")==0 && elements[n].checked && elements[n].id.indexOf("reduction")==0){
		    	elements[n].checked=false;
		    	doBalance(elements[n],false);
			  }
		  	}
		  }
		  
		  function removesignatures(){
			  if(window.confirm('<%=getTranNoLink("web","areyousure",sWebLanguage)%>')){
				  document.getElementById('command').value='removesignatures;'+document.getElementById('EditPatientInvoiceUID').value;
				  document.getElementById('FindPatientInvoiceUID').value=document.getElementById('EditInvoiceUID').value;
				  doFind();
			  }
		  }
		
		  function searchService(serviceUidField,serviceNameField){
		    openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&VarCode="+serviceUidField+"&VarText="+serviceNameField);
		    document.getElementById(serviceNameField).focus();
		  }
		  
		  function doPayment(invoiceUid){
			    openPopup("/financial/patientCreditEdit.jsp&ts=<%=getTs()%>&EditCreditInvoiceUid="+invoiceUid+"&ScreenType=doPayment&EditBalance="+document.getElementById('EditBalanceDetailed').value,600,300);
			  }
			
		  function doTransfer(invoiceUid){
			    openPopup("/financial/transferInvoiceToInsurer.jsp&ts=<%=getTs()%>&PopupWidth=500&PopupHeight=200&patientinvoiceuid="+invoiceUid+"&openerfunction=setPatientInvoice('"+invoiceUid+"')");
			  }
			
  		  function noshow(){
		    	openPopup("/financial/noshowInvoiceCredit.jsp&ts=<%=getTs()%>&PopupWidth=500&PopupHeight=100&patientinvoiceuid=<%=patientInvoice.getUid()%>");
  		  }
		
		  function doInvoiceCancel(invoiceUid){
	          if(yesnoDeleteDialog()){
			      if(document.getElementById('invoiceStatus').selectedIndex){
			       	document.getElementById("invoiceStatus").options[document.getElementById("invoiceStatus").selectedIndex].value='canceled';
			      }
			      else{
			       	document.getElementById('invoiceStatus').value='canceled';
			      }
			      doSave();
			  }
		  }
		  
		  function redIfInThePast(){
		<%
			if(MedwanQuery.getInstance().getConfigInt("enableCloseAntedatedInvoices",1)==0){
		%>
			  if ('<%=patientInvoice.getStatus()%>'=='open' && document.getElementById('EditDate').value.length>8){
				  var invoiceDate = new Date(document.getElementById('EditDate').value.substring(6)+"/"+document.getElementById('EditDate').value.substring(3,5)+"/"+document.getElementById('EditDate').value.substring(0,2));
				  var today=new Date(new Date().getFullYear(),new Date().getMonth(),new Date().getDate());
				  if(invoiceDate<today){
			    	  document.getElementById('EditDate').className='textred';
			    	  document.getElementById('dateinpastwarning').style.display='';
			      }
				  else{
			    	  document.getElementById('EditDate').className='text';
			    	  document.getElementById('dateinpastwarning').style.display='none';
				  }
			  }
			  else{
		    	  document.getElementById('EditDate').className='text';
		    	  document.getElementById('dateinpastwarning').style.display='none';
			  }
		<%
			}
		%>
		  }

		  redIfInThePast();
		  FindForm.FindPatientInvoiceUID.focus();
		  loadDebets();
		  loadOpenPatientInvoices();
		  doBalance();
		  document.getElementById('EditBalance').value = formatNumber(document.getElementById('EditBalance').value,<%=MedwanQuery.getInstance().getConfigInt("currencyDecimals",2)%>);
		  document.getElementById('EditBalanceDetailed').value = formatNumber(document.getElementById('EditBalance').value,2);
	  
	  <%
	  	if(automaticPayment){
	  %>
	      window.setTimeout("doPayment('<%=sFindPatientInvoiceUID%>');",500);
	  <%
	  	}
	  %>
	</script>
<%
	}

%>

