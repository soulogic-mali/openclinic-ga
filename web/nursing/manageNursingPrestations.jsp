<%@page import="java.text.SimpleDateFormat,
                be.openclinic.finance.*,
                be.openclinic.medical.Prescription,
                java.text.DecimalFormat,
                be.mxs.common.util.system.*,
                be.openclinic.common.KeyValue,
                be.openclinic.pharmacy.PrescriptionSchema,
                be.openclinic.pharmacy.ProductSchema,
                java.util.Vector"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=sJSPROTOTYPE %>
<%
	java.util.Date date=new java.util.Date();
	String sPrescriptionUid="";
	String hour="";
	Prescription prescription=null;
	
	String[] sKey = checkString(request.getParameter("key")).split("\\_");
	if(sKey.length>2){
		date = new SimpleDateFormat("yyyyMMdd").parse(sKey[1]);
		sPrescriptionUid = sKey[2];
		hour = sKey[3];
		prescription = Prescription.get(sPrescriptionUid);
	}
	if(request.getParameter("submitButton")!=null){
		Pointer.deletePointers(checkString(request.getParameter("key")));
		Pointer.storePointer(checkString(request.getParameter("key")), checkString(request.getParameter("comment")));
	}
	else if(request.getParameter("transferButton")!=null){
		//Invoice all checked prestations
		String encounterUid=checkString(request.getParameter("EditEncounterUID"));
		Encounter encounter = Encounter.get(encounterUid);
		if(encounter!=null){
			String insuranceUid=checkString(request.getParameter("EditInsuranceUID"));
			Insurance insurance = Insurance.get(insuranceUid);
			if(insurance!=null){
				Enumeration pars = request.getParameterNames();
				while(pars.hasMoreElements()){
					String parname = (String)pars.nextElement();
					if(parname.startsWith("cb_")){
						String nursingdebetuid = parname.substring(3);
						Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
						PreparedStatement ps = conn.prepareStatement("select * from OC_NURSINGDEBETS where OC_NURSINGDEBET_SERVERID=? and OC_NURSINGDEBET_OBJECTID=? and (OC_NURSINGDEBET_DEBETUID is NULL or OC_NURSINGDEBET_DEBETUID='')");
						ps.setInt(1,Integer.parseInt(nursingdebetuid.split("\\.")[0]));
						ps.setInt(2,Integer.parseInt(nursingdebetuid.split("\\.")[1]));
						ResultSet rs = ps.executeQuery();
						if(rs.next()){
							Debet debet = new Debet();
							debet.setDate(rs.getDate("OC_NURSINGDEBET_DATE"));
							debet.setEncounterUid(encounterUid);
							debet.setPrestationUid(rs.getString("OC_NURSINGDEBET_PRESTATIONUID"));
							debet.setQuantity(rs.getInt("OC_NURSINGDEBET_QUANTITY"));
							debet.setServiceUid(encounter.getServiceUID());
							debet.setUpdateUser(rs.getString("OC_NURSINGDEBET_USERUID"));
		            		debet.setCreateDateTime(new java.util.Date());
		            		debet.setUpdateDateTime(new java.util.Date());
		            		debet.setComment("");
		            		debet.setSupplierUid("");
		            		debet.setCredited(0);
		            		debet.setVersion(1);
		            		
		            		double insuraramount=0;
		            		Prestation prestation = Prestation.get(debet.getPrestationUid());
		            		if(prestation!=null && insurance!=null && insurance.getInsurar()!=null && prestation.isVisibleFor(insurance.getInsurar(),encounter.getService())){
		            			double patientamount = prestation.getPrice(insurance.getType());
			            		debet.setInsurance(insurance);
			            		debet.setInsuranceUid(insurance.getUid());
			            		//First find out if there is a fixed tariff for this prestation
			            		insuraramount = prestation.getInsuranceTariff(insurance.getInsurarUid(), insurance.getInsuranceCategoryLetter());
				                if(encounter.getType().equalsIgnoreCase("admission") && prestation.getMfpAdmissionPercentage()>0){
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
			            		else if(insurance.getExtraInsurar()!=null){
		            				extrainsuraramount=patientamount;
		            				patientamount=0;
		            				debet.setExtraInsurarUid(insurance.getExtraInsurarUid());
			            		}
			            		debet.setAmount(Double.parseDouble(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#.00")).format(patientamount).replaceAll(",", "."))*debet.getQuantity());
			            		debet.setInsurarAmount(Double.parseDouble(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#.00")).format(insuraramount).replaceAll(",", "."))*debet.getQuantity());
			            		debet.setExtraInsurarAmount(Double.parseDouble(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#.00")).format(extrainsuraramount).replaceAll(",", "."))*debet.getQuantity());
		                    	debet.store();
		                    	//Now update the nursingdebet
								PreparedStatement ps2 = conn.prepareStatement("update OC_NURSINGDEBETS set OC_NURSINGDEBET_DEBETUID=? where OC_NURSINGDEBET_SERVERID=? and OC_NURSINGDEBET_OBJECTID=?");
								ps2.setString(1,debet.getUid());
		                    	ps2.setInt(2,Integer.parseInt(nursingdebetuid.split("\\.")[0]));
								ps2.setInt(3,Integer.parseInt(nursingdebetuid.split("\\.")[1]));
								ps2.execute();
								ps2.close();
			            		MedwanQuery.getInstance().getObjectCache().removeObject("debet", debet.getUid());
		            		}
						}
						rs.close();
						ps.close();
						conn.close();
					}
				}
			}
		}
	}
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'><td colspan='3'><%=getTran(request,"web","nursingprestations",sWebLanguage) %></td></tr>
		<%if(prescription!=null && prescription.getProduct()!=null){ %>
			<tr>
				<td class='admin'><%=prescription.getProduct().getName() %></td>
				<td class='admin' colspan="2"><%=ScreenHelper.formatDate(date) +" "+hour+getTran(request,"web","abbreviation.hour",sWebLanguage) %></td>
			</tr>
			<tr>
				<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td>
				<td class='admin2' colspan='2'>
					<textarea class='text' name='comment' id='comment' cols='60' rows='2'><%=Pointer.getPointer(checkString(request.getParameter("key"))) %></textarea>&nbsp;&nbsp;
					<input class='button' type='submit' name='submitButton' value='<%=getTranNoLink("web","save",sWebLanguage)%>'/>				
				</td>
			</tr>
			<tr>
				<td class='admin2' colspan='3'><hr/></td>
			</tr>
		<%} %>
		<tr>
			<td class='admin'><%=getTran(request,"web","insurar",sWebLanguage) %></td>
			<td class='admin2'>
                <select class="text" id='EditInsuranceUID' name="EditInsuranceUID" onchange="changeInsurance()">
                    <option/>
                    <%
                        Vector vInsurances = Insurance.getCurrentInsurances(activePatient.personid);
                        if (vInsurances!=null){
                            boolean bInsuranceSelected = false;
                            Insurance insurance,selectedInsurance;
							selectedInsurance = Insurance.getMostInterestingInsuranceForPatient(activePatient.personid);
                            for (int i=0;i<vInsurances.size();i++){
                                insurance = (Insurance)vInsurances.elementAt(i);

                                if (insurance!=null && insurance.isAuthorized() && insurance.getInsurar()!=null && insurance.getInsurar().getName()!=null && insurance.getInsurar().getName().trim().length()>0){
                                    out.print("<option value='"+insurance.getUid()+"'");

                                    if (selectedInsurance!=null && selectedInsurance.getUid().equals(insurance.getUid())){
                                        out.print(" selected");
                                        bInsuranceSelected = true;
                                    }
                                    else if (!bInsuranceSelected){
                                        if(vInsurances!=null && vInsurances.size()==1){
                                            out.print(" selected");
                                            bInsuranceSelected = true;
                                        }
                                    }
                                       try{
                                       	out.print("/>"+insurance.getInsurar().getName()+" ("+insurance.getInsuranceCategory().getCategory()+": "+insurance.getInsuranceCategory().getPatientShare()+"/"+(100-Integer.parseInt(insurance.getInsuranceCategory().getPatientShare()))+")"+ (checkString(insurance.getInsuranceNr()).length()>0?" #"+insurance.getInsuranceNr():"")+"</option>");
                                       }
                                       catch(Exception e1){
                                       	out.print("/>"+insurance.getInsurar().getName()+ "</option>");
                                       }
                                }
                            }
                        }
                        
                    %>
                </select>&nbsp;
			</td>
			<td class='admin2'>
				<input class='button' type='submit' name='transferButton' value='<%=getTranNoLink("web","invoicechecked",sWebLanguage)%>'/>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","encounter",sWebLanguage) %></td>
            <td class='admin2'>
            	<%
            	Encounter encounter=null;	
            	String encounterUid="";
            		String encounterName=""; 
            		Vector encounters = Encounter.selectEncounters("", "", ScreenHelper.formatDate(date), "", "", "", "", "", activePatient.personid, "OC_ENCOUNTER_BEGINDATE");
            		if(encounters.size()>0){
            			encounter = (Encounter)encounters.elementAt(0);
            		}
            		if(encounter==null && sKey.length<=2){
            			encounter=Encounter.getLastEncounter(activePatient.personid);
            		}
               		if(encounter!=null){
               			encounterUid=encounter.getUid();
               			encounterName=encounter.getEncounterDisplayName(sWebLanguage);
               		}
            	%>
                <input type="hidden" name="EditEncounterUID" id="EditEncounterUID" value="<%=encounterUid%>">
                <input class="text" type="text" name="EditEncounterName" readonly size="60" value="<%=encounterName%>">
                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchEncounter('EditEncounterUID','EditEncounterName');">
                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.EditEncounterUID.value='';transactionForm.EditEncounterName.value='';">
            </td>
			<td class='admin2'>
				<input class='button' type='button' name='printButton' value='<%=getTranNoLink("web","printsummary",sWebLanguage)%>' onclick='printSummary()'/>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","prestation",sWebLanguage) %></td>
			<td class='admin2' colspan='2'>
                <input class="text" type="text" name="EditPrestationCode" id="EditPrestationCode" size="10" maxLength="50" value="" ><img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchPrestation();">
                x <input class="text" type="text" name="EditPrestationQuantity" id="EditPrestationQuantity" size="3" maxLength="10" value="1" >
                <input class="greytext" readonly disabled type="text" name="EditPrestationName" id="EditPrestationName" value="" size="40"/>
                <%=ScreenHelper.writeDateField("EditPrestationDate", "transactionForm", ScreenHelper.formatDate(date), false, false, sWebLanguage, sCONTEXTPATH) %>
				<input class='button' type='button' name='addButton' value='<%=getTranNoLink("web","add",sWebLanguage)%>' onclick='addPrestation()'/>				
            </td>
		</tr>
		<tr>
			<td class='admin2' colspan='3'><hr/></td>
		</tr>
	</table>
	
	<div id='divPrestations'/>
</form>

<script>
	function searchPrestation(){
    	transactionForm.EditPrestationCode.value = "";
    	openPopup("/_common/search/searchPrestation.jsp&ts=<%=getTs()%>&ReturnFieldUid=EditPrestationCode&ReturnFieldDescr=EditPrestationName&keyword=<%=MedwanQuery.getInstance().getConfigString("nursingPrestationKeyword","1")%>");
  	}
	
  	function searchEncounter(encounterUidField,encounterNameField){
	    openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&VarCode="+encounterUidField+"&VarText="+encounterNameField+"&VarFunction=loadPrestations()&FindEncounterPatient=<%=activePatient.personid%>");
	}

    function printSummary(){
    	if(document.getElementById("EditEncounterUID").value.length>0){
	        var url = "<c:url value='/nursing/createNursingDebetsPdf.jsp'/>?EncounterUid="+document.getElementById("EditEncounterUID").value;
	        window.open(url,"NursingDebetsPdf<%=new java.util.Date().getTime()%>","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
    	}
    	else{
    		alert('<%=getTranNoLink("medical","no_encounter",sWebLanguage)%>');
    	}
    }

	function addPrestation(){
	    var params = 'key=<%=checkString(request.getParameter("key"))%>'+
		 '&EditPrestationCode='+document.getElementById("EditPrestationCode").value+
		 '&EditPrestationQuantity='+document.getElementById("EditPrestationQuantity").value+
		 '&EditPrestationDate='+document.getElementById("EditPrestationDate").value+
		 '&EditPrestationHour=<%=hour%>';
	    var today = new Date();
	    var url= '<c:url value="/nursing/savePrestation.jsp"/>?ts='+today;
		new Ajax.Request(url,{
		  method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
	    	window.opener.location.reload();
	        loadPrestations();
	      },
	      onFailure: function(){
	    	  alert('error');
	      }
		});
	}
	
	function deletePrestation(uid){
	    var params = 'uid='+uid;
	    var today = new Date();
	    var url= '<c:url value="/nursing/deletePrestation.jsp"/>?ts='+today;
		new Ajax.Request(url,{
		  method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
	    	window.opener.location.reload();
	        loadPrestations();
	      },
	      onFailure: function(){
	    	  alert('error');
	      }
		});
	}
	
	function loadPrestations(showall){
	    document.getElementById('divPrestations').innerHTML = "<img src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/><br/>Loading";
	    var params = 'key=<%=checkString(request.getParameter("key"))%>'+
	    	'&EditEncounterUID='+document.getElementById("EditEncounterUID").value;
	    if(showall){
	    	params+='&showall=1';
	    }
	    var today = new Date();
	    var url= '<c:url value="/nursing/loadPrestations.jsp"/>?ts='+today;
		new Ajax.Request(url,{
		  method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
	        $('divPrestations').innerHTML=resp.responseText;
	      }
		});
	}
	
	loadPrestations();
</script>