<%@page import="java.math.BigDecimal"%>
<%@page import="be.openclinic.mobilemoney.MobileMoney"%>
<%@page import="be.openclinic.adt.Encounter,
                be.openclinic.finance.*,
                be.openclinic.pharmacy.*,
                java.util.Vector,java.text.*,
                be.mxs.common.util.io.ExportSAP_AR_INV,
                be.mxs.common.util.system.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"financial.patientCreditEdit","select",activeUser)%>
<%=sJSSTRINGFUNCTIONS%>
<%=sJSPROTOTYPE%>

<%
	String sFindPatientCreditUID = checkString(request.getParameter("FindPatientCreditUID"));
	PatientCredit credit = null;
	String sPatientId = "";
	
	if(sFindPatientCreditUID.length() > 0){
	    credit = PatientCredit.get(MedwanQuery.getInstance().getConfigString("serverId")+"."+sFindPatientCreditUID);
	    if(credit!=null && credit.getDate()!=null){
	        sPatientId = credit.getEncounter().getPatientUID();
	        if(request.getParameter("LoadPatientId")!=null && (activePatient==null || !sPatientId.equalsIgnoreCase(activePatient.personid))){
	        	if(activePatient==null){
	        		activePatient=new AdminPerson();
	        		session.setAttribute("activePatient",activePatient);
	        	}
	        	activePatient.initialize(sPatientId);
	        }
	    	%>
	    	<script>
	    	  url = '<c:url value="/main.do"/>?Page=financial/patientCreditEdit.jsp&ts=<%=ScreenHelper.getTs()%>&EditCreditUid=<%=credit.getUid()%>';
	    	  window.location.href = url;
	    	</script>
	    	<%
	    	out.flush();
	    }
	    else{
	    	out.print(getTran(request,"web","credit.does.not.exist",sWebLanguage)+": "+sFindPatientCreditUID);
	    }	
	} 

    String sAction = checkString(request.getParameter("Action"));
    String sScreenType = checkString(request.getParameter("ScreenType"));

    String sFindDateBegin = checkString(request.getParameter("FindDateBegin")),
           sFindDateEnd   = checkString(request.getParameter("FindDateEnd")),
           sFindAmountMin = checkString(request.getParameter("FindAmountMin")),
           sFindAmountMax = checkString(request.getParameter("FindAmountMax"));

    String sEditCreditUid        = checkString(request.getParameter("EditCreditUid")),
           sEditCreditDate       = checkString(request.getParameter("EditCreditDate")),
           sEditCreditInvoiceUid = checkString(request.getParameter("EditCreditInvoiceUid")),
           sEditCreditInvoiceNr  = checkString(request.getParameter("EditCreditInvoiceNr")),
           sEditCreditAmount     = checkString(request.getParameter("EditCreditAmount")),
           sEditCreditType       = checkString(request.getParameter("EditCreditType")),
           sEditCreditCategory   = checkString(request.getParameter("EditCreditCategory")),
           sEditCreditEncUid     = checkString(request.getParameter("EditCreditEncounterUid")),
           sEditCreditDescr      = checkString(request.getParameter("EditCreditDescription")),
       	   sEditBalance          = checkString(request.getParameter("EditBalance")),
      	   sEditCreditCurrency   = checkString(request.getParameter("EditCreditCurrency")),
     	   sMomoCashDesk     	 = checkString(request.getParameter("momocashdesk")),
           sEditCreditWicketUid  = checkString(request.getParameter("EditCreditWicketUid"));

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n******************** financial/patientCreditEdit.jsp ******************");
        Debug.println("sAction               : "+sAction);
        Debug.println("sEditCreditUid        : "+sEditCreditUid);
        Debug.println("sEditCreditDate       : "+sEditCreditDate);
        Debug.println("sEditCreditInvoiceUid : "+sEditCreditInvoiceUid);
        Debug.println("sEditCreditInvoiceNr  : "+sEditCreditInvoiceNr);
        Debug.println("sEditCreditAmount     : "+sEditCreditAmount);
        Debug.println("sEditCreditType       : "+sEditCreditType);
        Debug.println("sEditCreditEncUid     : "+sEditCreditEncUid);
        Debug.println("sEditCreditDescr      : "+sEditCreditDescr);
        Debug.println("sEditCreditCurrency   : "+sEditCreditCurrency);
        Debug.println("sMomoCashDesk   		 : "+sMomoCashDesk);
        Debug.println("sEditCreditWicketUid  : "+sEditCreditWicketUid+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    AdminPerson adminPerson = activePatient;
    PatientInvoice invoice = PatientInvoice.get(sEditCreditInvoiceUid);
    if(ScreenHelper.checkString(sEditCreditInvoiceUid).length()>0){
        adminPerson=invoice.getPatient();
    }
    if(adminPerson==null){
    	adminPerson=activePatient;
    }
    String sEditCreditEncName = "", msg = "";

	// use mobile money cash desk if specified
	if(sMomoCashDesk.length()>0){
		sEditCreditWicketUid=sMomoCashDesk;
	}
    // set default wicket if no wicket specified
    if(sEditCreditWicketUid.length()==0){
        sEditCreditWicketUid = activeUser.getParameter("defaultwicket");
    }
    if(sEditCreditWicketUid.length()==0){
        sEditCreditWicketUid = checkString((String)session.getAttribute("defaultwicket"));
    }
    
    //--- SAVE ------------------------------------------------------------------------------------
    if(sAction.equals("save")){
        // get or create credit
        if(sEditCreditUid.length() > 0){
            credit = PatientCredit.get(sEditCreditUid);
        }
        else{
            credit = new PatientCredit();
            credit.setCreateDateTime(ScreenHelper.getSQLDate(getDate()));
        }
        
        // set and store credit
        credit.setDate(ScreenHelper.getSQLDate(sEditCreditDate));
        credit.setInvoiceUid(sEditCreditInvoiceUid);
        credit.setAmount(Double.parseDouble(sEditCreditAmount));
        credit.setType(sEditCreditType);
        credit.setCategory(sEditCreditCategory);
        credit.setEncounter(Encounter.get(sEditCreditEncUid));
        credit.setEncounterUid(sEditCreditEncUid);
        credit.setComment(sEditCreditDescr);
        credit.setUpdateDateTime(ScreenHelper.getSQLDate(getDate()));
        credit.setUpdateUser(activeUser.userid);
        credit.setCurrency(sEditCreditCurrency);
        credit.setPatientUid(MedwanQuery.getInstance().getConfigString("serverId")+"."+adminPerson.personid);
        credit.store();
        
        if(SH.c(sEditCreditInvoiceUid).split("\\.").length==2){
		    PatientInvoice pi = PatientInvoice.get(sEditCreditInvoiceUid);
		    double dBalance=pi.getBalance();
		    if (dBalance < 0) {
				Encounter encounter = Encounter.getActiveEncounter(pi.getPatientUid());
				if(encounter==null){
					encounter = Encounter.getLastEncounter(pi.getPatientUid());
				}
		
		        double dCredit = dBalance;
		        dBalance = 0;
		        PatientCredit patientcredit = new PatientCredit();
		        patientcredit.setAmount(dCredit * (-1));
		        patientcredit.setEncounterUid(encounter==null?"":encounter.getUid());
		        patientcredit.setDate(ScreenHelper.getSQLDate(getDate()));
		        patientcredit.setType("transfer.de.credit");
		        patientcredit.setUpdateDateTime(ScreenHelper.getSQLDate(getDate()));
		        patientcredit.setUpdateUser(activeUser.userid);
		        patientcredit.store();
		        credit.setAmount(credit.getAmount()+dCredit);
		        credit.store();
				
		        String sCreditUid;
		        double dTmpCredits = 0,dTotalDebets=pi.getTotalAmount();
		        boolean paymentCovered=false;
				
		        for (int i = 0; i < pi.getCredits().size(); i++) {
		            sCreditUid = checkString((String) pi.getCredits().elementAt(i));
		
		            if (sCreditUid.length() > 0) {
		                credit = PatientCredit.get(sCreditUid);
		
		                if (credit != null) {
		                    dTmpCredits += credit.getAmount();
		                    if (dTmpCredits > dTotalDebets) {
		                        if(!paymentCovered){
		                        	credit.setAmount(new BigDecimal("" + (credit.getAmount() - (dTmpCredits - dTotalDebets))).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue());
		                        }
		                        else {
		                        	credit.setAmount(0);
		                        }
		                        credit.store();
		                        paymentCovered=true;
		                    }
		                }
		            }
		        }
		    }
		    pi.setBalance(dBalance);
		    pi.store();
        }
        
		String wicketCreditUid="";
        msg = getTran(request,"web","dataIsSaved",sWebLanguage);

        //*** update wicket credit ********************************************
        if(sEditCreditWicketUid.length() > 0){
            // get wicket credit belonging to this patientCredit, if any specified
            WicketCredit wicketCredit = null;
            if(sEditCreditUid.length() > 0){
                wicketCredit = WicketCredit.getByReferenceUid(sEditCreditUid,"PatientCredit");
            }

            // create wicket credit if not found or not specified
            if(wicketCredit==null || wicketCredit.getUid()==null || wicketCredit.getUid().length()==0){
                wicketCredit = new WicketCredit();

                wicketCredit.setWicketUID(sEditCreditWicketUid);
                session.setAttribute("defaultwicket",sEditCreditWicketUid);
                wicketCredit.setCreateDateTime(ScreenHelper.getSQLDate(sEditCreditDate));
                wicketCredit.setUserUID(Integer.parseInt(activeUser.userid));
            }

            wicketCredit.setOperationDate(new Timestamp(ScreenHelper.parseDate(sEditCreditDate).getTime()));
            wicketCredit.setOperationType(sEditCreditType);
            wicketCredit.setCategory(credit.getCategory());
            wicketCredit.setAmount(Double.parseDouble(sEditCreditAmount));

            // set patient name as default comment
            if(wicketCredit.getComment()==null || (wicketCredit.getComment()!=null && wicketCredit.getComment().toString().length()==0)){
                wicketCredit.setComment(adminPerson.lastname+" "+adminPerson.firstname+(invoice==null?"":" - "+invoice.getInvoiceNumber()));
            }

            wicketCredit.setInvoiceUID(sEditCreditInvoiceUid);

            // reference to patientCredit
            ObjectReference objRef = new ObjectReference();
            objRef.setObjectType("PatientCredit");
            objRef.setObjectUid(credit.getUid());
            wicketCredit.setReferenceObject(objRef);

            wicketCredit.setUpdateDateTime(getSQLTime());
            wicketCredit.setUpdateUser(activeUser.userid);
            wicketCredit.setCurrency(sEditCreditCurrency);

            wicketCredit.store();
			wicketCreditUid=wicketCredit.getUid();
            // recalculate wicket balance
            Wicket wicket = Wicket.get(sEditCreditWicketUid);
            wicket.recalculateBalance();

            if(MedwanQuery.getInstance().getConfigInt("enableProductionOrders",0)==1){
    			//Check if a productionOrder must be generated
    			//First verify if at least one prestation on the linked patientinvoice has been linked to a production order
    			if(sEditCreditInvoiceUid.length()>0){
    				PatientInvoice linkedInvoice = PatientInvoice.get(sEditCreditInvoiceUid);
    				if(linkedInvoice!=null && checkString(linkedInvoice.getUid()).split("\\.").length==2){
    					linkedInvoice.createProductionOrders();
    				}
    			}
           	}
        }
        if(SH.c(request.getParameter("momo_financialtransactionid")).length()>0){
        	MobileMoney.updateCreditOperationIds(request.getParameter("momo_financialtransactionid"), credit.getUid(), wicketCreditUid);
        }

        if(sScreenType.length() > 0){
            %>
            <script>
              window.opener.doFind();
              window.close();
            </script>
            <%
        }
    }

    //--- LOAD SPECIFIED CREDIT -------------------------------------------------------------------
    Encounter encounter;

    if(sEditCreditUid.length() > 0){
        credit = PatientCredit.get(sEditCreditUid);

        sEditCreditUid        = credit.getUid();
        sEditCreditDate       = checkString(ScreenHelper.stdDateFormat.format(credit.getDate()));
        sEditCreditInvoiceUid = credit.getInvoiceUid();
        sEditCreditInvoiceNr  = sEditCreditInvoiceUid.substring(sEditCreditInvoiceUid.indexOf(".")+1);
        sEditCreditAmount     = Double.toString(credit.getAmount());
        sEditCreditDescr      = credit.getComment();
        sEditCreditCurrency   = credit.getCurrency();
        sEditCreditType       = credit.getType();

        // encounter
        encounter = credit.getEncounter();
        if(encounter!=null){
            sEditCreditEncUid  = encounter.getUid();
            sEditCreditEncName = encounter.getPatient().lastname+" "+encounter.getPatient().firstname;
        }
    }
    else if(!sScreenType.equals("") && sEditCreditInvoiceUid.length()>0){
        PatientInvoice patientInvoice = PatientInvoice.get(sEditCreditInvoiceUid);
        if(sEditCreditAmount.length()==0 && sEditBalance.length()>0){
        	sEditCreditAmount = sEditBalance;
        }
        sEditCreditInvoiceNr = patientInvoice.getInvoiceUid();
        sEditCreditDate = checkString(ScreenHelper.stdDateFormat.format(new java.util.Date()));

        if(sScreenType.equalsIgnoreCase("doCancellation")){
            sEditCreditType = "correction";
            sEditCreditDescr = getTran(request,"web","canceled",sWebLanguage);
        }
        else{
            sEditCreditType = "patient.payment";
        }

        encounter = Encounter.getActiveEncounter(adminPerson.personid);
        if(encounter==null){
            encounter = new Encounter();
        }
    }
    else{
        // new credit
        sEditCreditUid        = "";
        sEditCreditDate       = getDate(); // now
        sEditCreditInvoiceUid = "";
        sEditCreditInvoiceNr  = "";
        sEditCreditAmount     = "";
        sEditCreditEncUid     = "";
        sEditCreditEncName    = "";
        sEditCreditType       = MedwanQuery.getInstance().getConfigString("defaultPatientCreditType","patient.payment");
        sEditCreditDescr      = "";
        sEditCreditCurrency   = "";

        // active encounter as default
        encounter = Encounter.getActiveEncounter(adminPerson.personid);
        if(encounter==null){
            encounter = new Encounter();
        }
    }

    // compose encounter name
    if(encounter!=null){
        sEditCreditEncUid = checkString(encounter.getUid());

        String sType = "";
        if(checkString(encounter.getType()).length()>0){
            sType = ", "+getTran(request,"encountertype",encounter.getType(),sWebLanguage);
        }

        String sBegin = "";
        if(encounter.getBegin()!=null){
            sBegin = ", "+ScreenHelper.getSQLDate(encounter.getBegin());
        }

        String sEnd = "";
        if(encounter.getEnd()!=null){
            sEnd = ", "+ScreenHelper.getSQLDate(encounter.getEnd());
        }

        sEditCreditEncName = sEditCreditEncUid+sBegin+sEnd+sType;
    }
%>
<form name="EditForm" id="EditForm" method="POST" onClick="checkForMaxAmount(EditForm.EditCreditAmount);">
<%
    if(sScreenType.length()==0){
%>
    <%ScreenHelper.setIncludePage(customerInclude("financial/financialStatusPatient.jsp"),pageContext);%>
    <table class="list" width="100%" cellspacing="1" cellpadding="0">
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web.occup","medwan.common.date",sWebLanguage)%></td>
            <td class="admin2" width="80"><%=getTran(request,"Web","Begin",sWebLanguage)%></td>
            <td class="admin2" width="150"><%=writeDateField("FindDateBegin","EditForm",sFindDateBegin,sWebLanguage)%></td>
            <td class="admin2" width="80"><%=getTran(request,"Web","end",sWebLanguage)%></td>
            <td class="admin2"><%=writeDateField("FindDateEnd","EditForm",sFindDateEnd,sWebLanguage)%></td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web","amount",sWebLanguage)%></td>
            <td class="admin2"><%=getTran(request,"Web","min",sWebLanguage)%></td>
            <td class="admin2"><input type="text" class="text" name="FindAmountMin" id="FindAmountMin" value="<%=sFindAmountMin%>" onblur="isNumber(this)"></td>
            <td class="admin2"><%=getTran(request,"Web","max",sWebLanguage)%></td>
            <td class="admin2"><input type="text" class="text" name="FindAmountMax" id="FindAmountMax" value="<%=sFindAmountMax%>" onblur="isNumber(this)"></td>
        </tr>
        <tr>
            <td class="admin"/>
            <td class="admin2" colspan="4">
                <input type="button" class="button" name="ButtonSearch" value="<%=getTranNoLink("Web","search",sWebLanguage)%>" onclick="loadUnassignedCredits()">&nbsp;
                <input type="button" class="button" name="ButtonClear" value="<%=getTranNoLink("Web","Clear",sWebLanguage)%>" onclick="clearFindFields()">&nbsp;
                <input class="button" type="button" name="buttonNew" value="<%=getTranNoLink("Web","new",sWebLanguage)%>" onclick="clearEditFields();">
            </td>
        </tr>
    </table>
    <br>

    <div id="divCredits" class="searchResults" style="height:122px;width:100%">
       <%-- Filled by Ajax --%>
    </div>
    <br>
<%
    }
%>
    <%-- hidden fields --%>
    <input type="hidden" name="Action">
    <input type="hidden" name="momocashdesk" id="momocashdesk">
    <input type="hidden" name="EditCreditUid" id="EditCreditUid" value="<%=sEditCreditUid%>"/>
    <input type="hidden" name="ScreenType" value="<%=sScreenType%>">
    
    <%=writeTableHeader("financial","patientCreditEdit",sWebLanguage," doBack();")%>
    <table class="list" width="100%" cellspacing="1" cellpadding="0">
	    <tr>
	        <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"Web","creditid",sWebLanguage)%></td>
	        <td class="admin2"><div id="creditid"></div></td>
	    </tr>
	    <tr>
	        <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"Web","date",sWebLanguage)%>&nbsp;*</td>
	        <td class="admin2">
	        	<% 
	        		if(activeUser.getAccessRightNoSA("financial.patientpaymentdate.edit")){
	        			out.println(ScreenHelper.writeDateField("EditCreditDate","EditForm",sEditCreditDate,true,false,sWebLanguage,sCONTEXTPATH));
	        		}
	        		else{
	        			out.println("<input type='text' class='text' size='10' readonly name='EditCreditDate' value='"+sEditCreditDate+"'/>");
	        		}
	        	%>
	        </td>
	    </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web","invoice",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="hidden" name="EditCreditInvoiceUid" id="EditCreditInvoiceUid" value="<%=sEditCreditInvoiceUid%>">
                <input class="text" type="text" name="EditCreditInvoiceNr" readonly size="10" value="<%=sEditCreditInvoiceNr%>">
                
                <%-- icons --%>
                <img src="<c:url value='/_img/icons/icon_search.png'/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchInvoice('EditCreditInvoiceUid','EditCreditInvoiceNr','EditCreditAmount','EditCreditMaxAmount');">
                <img src="<c:url value='/_img/icons/icon_delete.png'/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="EditForm.EditCreditInvoiceUid.value='';EditForm.EditCreditInvoiceNr.value='';EditForm.EditCreditMaxAmount.value='';">
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web","amount",sWebLanguage)%>&nbsp;*</td>
            <td class="admin2">
                <input type="hidden" name="EditCreditMaxAmount">
                <%if(MedwanQuery.getInstance().getConfigString("AlternateCurrency","").length()>0){ 
                %>
	                <input class='text' type='radio' name='EditCreditCurrency' value='<%=MedwanQuery.getInstance().getConfigParam("currency","€")%>' <%=checkString(sEditCreditCurrency).length()==0 || MedwanQuery.getInstance().getConfigParam("currency","€").equalsIgnoreCase(sEditCreditCurrency)?"checked":""%>/><input class="text" type="text" name="EditCreditAmount" id="EditCreditAmount" value="<%=sEditCreditAmount.length()==0?"0":sEditCreditAmount%>" size="14" maxLength="13" onKeyUp="isNumberNegativeAllowed(this);checkAlternate();" onBlur="checkForMaxAmount(this);">&nbsp;<%=MedwanQuery.getInstance().getConfigParam("currency","€")%>
	                &nbsp;&nbsp;<input class='text' type='radio' name='EditCreditCurrency' value='<%=MedwanQuery.getInstance().getConfigParam("AlternateCurrency","€")%>' <%=MedwanQuery.getInstance().getConfigParam("AlternateCurrency","€").equalsIgnoreCase(sEditCreditCurrency)?"checked":""%>/><input class="text" type="text" name="EditAlternateCreditAmount" id="EditAlternateCreditAmount" value="<%=sEditCreditAmount.length()==0?"0":new DecimalFormat(MedwanQuery.getInstance().getConfigString("AlternateCurrencyPriceFormat","# ##0.00")).format(Double.parseDouble(sEditCreditAmount)/ExportSAP_AR_INV.getExchangeRate(MedwanQuery.getInstance().getConfigString("AlternateCurrency"), new java.util.Date()))%>" size="14" maxLength="13" onKeyUp="isNumberNegativeAllowed(this);checkPrimary();" onBlur="checkForMaxAmount(this);">&nbsp;<%=MedwanQuery.getInstance().getConfigString("AlternateCurrency")%>
            	<%}
                 else {
                 %>
	                <input class="text" type="text" name="EditCreditAmount" id="EditCreditAmount" value="<%=sEditCreditAmount%>" size="10" maxLength="9" onKeyUp="isNumberNegativeAllowed(this);" onBlur="checkForMaxAmount(this);">&nbsp;<%=MedwanQuery.getInstance().getConfigParam("currency","€")%>
	                <input type='hidden' name='EditAlternateCreditAmount'/>
	                <input type='hidden' name='EditCreditCurrency' value='<%=MedwanQuery.getInstance().getConfigParam("currency","€")%>'/>
                 <%
                 }
                 %>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web","cash",sWebLanguage)%></td>
            <td class="admin2">
                <input class="text" type="text" name="cash" id="cash" value="<%=sEditCreditAmount%>" size="10" maxLength="9" onKeyUp="document.getElementById('change').value=(document.getElementById('EditCreditAmount').value*1-document.getElementById('cash').value*1)" onBlur="document.getElementById('change').value=(document.getElementById('EditCreditAmount').value*1-document.getElementById('cash').value*1)">&nbsp;<%=MedwanQuery.getInstance().getConfigParam("currency","€")%>
                &nbsp;&nbsp;&nbsp;&nbsp;<b><%=getTran(request,"web","change",sWebLanguage)%></b>
                <input class="text" type="text" name="change" id="change" value="0" size="10" maxLength="9" readonly/>&nbsp;<%=MedwanQuery.getInstance().getConfigParam("currency","€")%>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web","type",sWebLanguage)%>&nbsp;*</td>
            <td class="admin2">
                <select class="text" name="EditCreditType">
                    <option value=""><%=getTranNoLink("web","choose",sWebLanguage)%></option>
                    <%=ScreenHelper.writeSelectExclude(request,"credit.type",sEditCreditType,sWebLanguage,false,false,"reduction")%>
                    <%
                    	if(activeUser.getAccessRight("financial.invoicereduction.select")){
                    		out.println("<option "+(sEditCreditType.equalsIgnoreCase("reduction")?"checked":"")+" value='reduction'>"+getTran(request,"credit.type","reduction",sWebLanguage)+"</option>");
                    	}
                    %>
                </select>
            </td>
        </tr>
        <%if(sEditCreditInvoiceUid.length()==0){ %>
        <tr>
            <td class="admin"><%=getTran(request,"web","category",sWebLanguage)%>&nbsp;*</td>
            <td class="admin2">
                <select class="text" name="EditCreditCategory">
                    <option value=""><%=getTranNoLink("web","choose",sWebLanguage)%></option>
                    <%=ScreenHelper.writeSelect(request,"credit.category",sEditCreditCategory,sWebLanguage)%>
                </select>
            </td>
        </tr>
        <%} else{ %>
        <input type='hidden' name='EditCreditCategory' value='<%=MedwanQuery.getInstance().getConfigString("defaultPatientPaymentCategory","1")%>'/>
        <%} %>
        <tr>
            <td class="admin"><%=getTran(request,"web","encounter",sWebLanguage)%>&nbsp;*</td>
            <td class="admin2">
                <input type="hidden" id="EditCreditEncounterUid" name="EditCreditEncounterUid" value="<%=sEditCreditEncUid%>">
                <input class="text" type="text" name="EditCreditEncounterName" readonly size="40" value="<%=sEditCreditEncName%>">

                <%-- icons --%>
                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchEncounter('EditCreditEncounterUid','EditCreditEncounterName');">
                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="EditForm.EditCreditEncounterUid.value='';EditForm.EditCreditEncounterName.value='';">
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web","description",sWebLanguage)%></td>
            <td class="admin2"><%=writeTextarea("EditCreditDescription","40","","",sEditCreditDescr)%></td>
        </tr>
        
        <%
            Vector userWickets = Wicket.getWicketsForUser(activeUser.userid);
            if(userWickets.size() > 0 && !sScreenType.equalsIgnoreCase("doCancellation")){
                %>
                    <tr>
                        <td class="admin"><%=getTran(request,"wicket","wicket",sWebLanguage)%>&nbsp;*</td>
                        <td class="admin2">
                            <select class="text" id="EditCreditWicketUid" name="EditCreditWicketUid">
                                <option value="" selected><%=getTranNoLink("web","choose",sWebLanguage)%></option>
                                <%
                                    Iterator iter = userWickets.iterator();
                                    Wicket wicket;

                                    while(iter.hasNext()){
                                        wicket = (Wicket)iter.next();

                                        %>
                                          <option value="<%=wicket.getUid()%>" <%=sAction.length()==0 && sEditCreditWicketUid.equals(wicket.getUid())?" selected":""%>>
                                              <%=wicket.getUid()%>&nbsp;<%=getTranNoLink("service",wicket.getServiceUID(),sWebLanguage)%>
                                          </option>
                                        <%
                                    }
                                %>
                            </select>
                        </td>
                    </tr>
                <%
            }
            else{
                %><input type="hidden" name="EditCreditWicketUid"/><%
            }
        %>
        
        <%-- BUTTONS & PRINT --%>
        <tr style='vertical-align: top'>
            <td class="admin"/>
            <td class="admin2">
            	<table width='100%' cellpadding='0' cellspacing='0'>
            		<tr>
            			<td style='vertical-align: top'>
		            	<%
			            	if(userWickets.size() > 0){
			            	    %><input accesskey="S" class="button" type="button" name="buttonSave" id="buttonSave" value="<%=getTranNoLink("Web","save",sWebLanguage)%>" onclick="doSave();">&nbsp;&nbsp;<%
			            	}
			            	else{
			            	    %><font color="red"><%=getTran(request,"web","nowicketassignedtouser",sWebLanguage)%></font><%
		            		}
		                %>
		                </td>
		                <td style='vertical-align: top'>
		                <span id="printsection" name="printsection" style="vertical-align: top;visibility:hidden">
		                    <%=getTran(request,"Web.Occup","PrintLanguage",sWebLanguage)%>&nbsp;
		
		                    <%
		                        String sPrintLanguage = activeUser.person.language;
		                        if(sPrintLanguage.length()==0){
		                            sPrintLanguage = sWebLanguage;
		                        }
		
		                        String sSupportedLanguages = MedwanQuery.getInstance().getConfigString("supportedLanguages","en,fr");
		                    %>
		
		                    <select class="text" name="PrintLanguage" id="PrintLanguage">
		                        <%
		                            String tmpLang;
		                            StringTokenizer tokenizer = new StringTokenizer(sSupportedLanguages,",");
		                            while(tokenizer.hasMoreTokens()){
		                                tmpLang = tokenizer.nextToken();
		
		                                %><option value="<%=tmpLang%>" <%=(tmpLang.equalsIgnoreCase(sPrintLanguage)?" selected":"")%>><%=getTranNoLink("Web.language",tmpLang,sWebLanguage)%></option><%
		                            }
		                        %>
		                    </select>
		
		                    <%-- BUTTONS --%>
		                    <input class="button" type="button" name="buttonPrint" value="<%=getTranNoLink("Web","print",sWebLanguage)%>" onclick="doPrintPdf(document.getElementById('EditCreditUid').value);">
		                    <%
		                    	if(MedwanQuery.getInstance().getConfigInt("javaPOSenabled",0)==1){
		                            %><input class="button" type="button" name="buttonPrint" value='<%=getTranNoLink("Web","print.receipt",sWebLanguage)%>' onclick="doPrintPatientPaymentReceipt();"><%
		                    	}
			                	if(MedwanQuery.getInstance().getConfigInt("printPDFreceiptenabled",0)==1){
			                        %><input class="button" type="button" name="buttonPrintPdf" value='<%=getTranNoLink("Web","print.receipt.pdf",sWebLanguage)%>' onclick="doPrintPatientReceiptPdf();"><%
			                	}
		                    %>                    
		                </span>
		                </td>
		                <td style='vertical-align: top'>
		                <%
		                	if(SH.ci("enableMobilePayment",0)==1 && activeUser.getAccessRight("financial.mobilepayment.select")){
		                %>
		                		&nbsp;<img id='momoimage' style='vertical-align: top' height='30px' src='<%=sCONTEXTPATH%>/_img/themes/default/mtnmomopayblue.png' onclick='doMobilePaymentMTN()'/>
		                <%	
		                	}
		                %>
		                </td>
                	</tr>
                </table>
            </td>
        </tr>
    </table>
    <%=getTran(request,"web","asterisk_fields_are_obligate",sWebLanguage)%>
    <input type='hidden' name='momo_financialtransactionid' id='momo_financialtransactionid' value=''/>
    <%-- display message --%>
    <br><br><span id="msgArea">&nbsp;<%=msg%></span>
</form>

<script>
  var dateFormat = "<%=ScreenHelper.stdDateFormat.toPattern()%>";
   
  function doMobilePaymentMTN(){
	  var url = "financial/mobilemoney/mobileMoneyPayment.jsp&invoiceid="+document.getElementById("EditCreditInvoiceUid").value+"&operator=MTN&amount="+document.getElementById("EditCreditAmount").value+"&currency=<%=SH.cs("currency","RWF")%>&ts=<%=getTs()%>";
	  openPopup(url);
  }
  
  function registerMomoPayment(cashdesk,comment,financialTransactionId){
	  document.getElementById("momocashdesk").value=cashdesk;
	  document.getElementById("EditCreditDescription").value=comment;
	  document.getElementById("momo_financialtransactionid").value=financialTransactionId;
	  doSave();
  }
  
  function checkAlternate(){
	  document.getElementById("EditAlternateCreditAmount").value=parseFloat(document.getElementById("EditCreditAmount").value/<%=ExportSAP_AR_INV.getExchangeRate(MedwanQuery.getInstance().getConfigString("AlternateCurrency"), new java.util.Date())%>).toFixed(<%=MedwanQuery.getInstance().getConfigInt("AlternateCurrencyDecimals",2)%>);
  }
  function checkPrimary(){
	  document.getElementById("EditCreditAmount").value=parseFloat(document.getElementById("EditAlternateCreditAmount").value*<%=ExportSAP_AR_INV.getExchangeRate(MedwanQuery.getInstance().getConfigString("AlternateCurrency"), new java.util.Date())%>).toFixed(<%=MedwanQuery.getInstance().getConfigInt("currencyDecimals",2)%>);
  }
  function clearMessage(){
    <%
        if(msg.length() > 0){
            %>document.getElementById("msgArea").innerHTML = "";<%
        }
    %>
  }

  function doPrintPatientPaymentReceipt(){
    var url= "<c:url value='/financial/printPaymentReceiptOffline.jsp'/>"+
             "?credituid="+document.getElementById("EditCreditUid").value+
             "&language=<%=sWebLanguage%>&userid=<%=activeUser.userid%>"+
             "&ts="+new Date();
    new Ajax.Request(url,{
	  method: "GET",
      parameters: "",
      onSuccess: function(resp){
        var label = eval('('+resp.responseText+')');
        if(label.message.length>0){
          alertDialogDirectText(label.message.unhtmlEntities());
        };
      },
      onFailure: function(){
        alert("Error printing receipt");
      }
    });
  }

  function doPrintPatientReceiptPdf(){
    var url = "<c:url value='/financial/createPatientPaymentReceiptPdf.jsp'/>?creditUid="+EditForm.EditCreditUid.value+"&ts=<%=getTs()%>&PrintLanguage="+EditForm.PrintLanguage.value;
    window.open(url,"PatientPaymentPdf<%=getTs()%>","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
  }

  function checkForMaxAmount(amountField){
    if(EditForm.EditCreditMaxAmount.value.length > 0){
      if(EditForm.EditCreditAmount.value > EditForm.EditCreditMaxAmount.value){
        amountField.value = EditForm.EditCreditMaxAmount.value;
        alertDialog("web.financial","creditAmountLimitedToInvoiceAmount");        
      }
    }
  }

  function doSave(){
	document.getElementById("buttonSave").disabled = true;
	
    if(EditForm.EditCreditDate.value.length > 0 &&
       EditForm.EditCreditAmount.value.length > 0 &&
       EditForm.EditCreditEncounterUid.value.length > 0 &&
       EditForm.EditCreditType.value.length > 0){
      <%
          if(userWickets.size() > 0){
              %>
                if(document.getElementById("momocashdesk").value.length==0 && document.getElementById("EditCreditWicketUid").selectedIndex==0){
                  window.showModalDialog?alertDialog("web.manage","dataMissing"):alertDialogDirectText('<%=getTran(null,"web.manage","dataMissing",sWebLanguage)%>');
                  EditForm.EditCreditWicketUid.focus();
                  document.getElementById("buttonSave").disabled = false;
                }
                else{
                  EditForm.buttonSave.disabled = true;
                  EditForm.Action.value = "save";
                  EditForm.submit();
                }
        	<%
          }
          else{
        	  %>
                EditForm.buttonSave.disabled = true;
                EditForm.Action.value = "save";
                EditForm.submit();
        	  <%
          }
        %>
    }
    else{
      if(EditForm.EditCreditDate.value.length==0){
        EditForm.EditCreditDate.focus();
      }
      else if(EditForm.EditCreditAmount.value.length==0){
        EditForm.EditCreditAmount.focus();
      }
      else if(EditForm.EditCreditEncounterUid.value.length==0){
        EditForm.EditCreditEncounterName.focus();
      }
      else if(EditForm.EditCreditType.value.length==0){
        EditForm.EditCreditType.focus();
      }
      else if(EditForm.EditCreditWicketUid.value.length==0){
        //EditForm.EditCreditWicketUid.focus();
      }

                window.showModalDialog?alertDialog("web.manage","dataMissing"):alertDialogDirectText('<%=getTran(null,"web.manage","dataMissing",sWebLanguage)%>');
	  document.getElementById("buttonSave").disabled = false;
    }
  }

  function searchInvoice(invoiceUidField,invoiceNrField,invoiceBalanceField,invoiceMaxBalanceField){
    var url = "/_common/search/searchPatientInvoice.jsp&ts=<%=getTs()%>"+
              "&ReturnFieldInvoiceUid="+invoiceUidField+
              "&ReturnFieldInvoiceNr="+invoiceNrField+
              //"&FindInvoiceBalanceMin=0.01"+
              "&FindInvoiceStatus=<%=MedwanQuery.getInstance().getConfigString("defaultInvoiceStatus","open")%>"+
              "&FindInvoicePatientId=<%=adminPerson.personid%>"+
              "&Action=search";

    if(invoiceBalanceField!=undefined){
      url+= "&ReturnFieldInvoiceBalance="+invoiceBalanceField;
    }

    if(invoiceMaxBalanceField!=undefined){
      url+= "&ReturnFieldInvoiceMaxBalance="+invoiceMaxBalanceField;
    }

    openPopup(url);
  }

  function searchEncounter(encounterUidField,encounterNameField){
    openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>"+
              "&VarCode="+encounterUidField+
              "&VarText="+encounterNameField+
              "&VarFunction=loadUnassignedCredits()"+
              "&FindEncounterPatient=<%=adminPerson.personid%>");
  }

  function loadUnassignedCredits(){
	<%
	    if(sScreenType.length()==0){
	%>
	    if(document.getElementById("EditCreditEncounterUid").value.length==0){
	      alertDialog("medical","no_encounter");
	    }
	    else{
	      $("divCredits").innerHTML = "<br><br><br><div id='ajaxLoader' style='display:block;text-align:center;'>"+
	                                  "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br>Loading..</div>";
	      var params = "FindDateBegin="+ EditForm.FindDateBegin.value+
	                   "&FindDateEnd="+document.getElementById('FindDateEnd').value+
	                   "&FindAmountMin="+document.getElementById('FindAmountMin').value+
	                   "&FindAmountMax="+document.getElementById('FindAmountMax').value+
	                   "&encounterUID="+document.getElementById("EditCreditEncounterUid").value;
	      var url= "<c:url value='/financial/getEncounterCredits.jsp'/>?ts="+new Date();
	      new Ajax.Request(url,{
	        method: "GET",
	        parameters: params,
	        onSuccess: function(resp){
	          $("divCredits").innerHTML = resp.responseText;
	        },
	        onFailure: function(){
	          $("divCredits").innerHTML = "Error";
	        }
	      });
	    }
	<%
	    }
	%>
  }

  function selectCredit(creditUid,creditDate,amount,type,encUid,encName,descr, invoiceUid,wicketuid,encCur,category){
    EditForm.EditCreditWicketUid.value=wicketuid;
    EditForm.EditCreditUid.value = creditUid;
    EditForm.EditCreditDate.value = creditDate;
    EditForm.EditCreditAmount.value = amount;
    EditForm.EditCreditType.value = type;
    EditForm.EditCreditCategory.value = category;
    EditForm.EditCreditEncounterUid.value = encUid;
    EditForm.EditCreditCurrency.value = encCur;
    EditForm.EditCreditEncounterName.value = encName;
    EditForm.EditCreditDescription.value = replaceAll(descr,"<br>","\r\n");
    EditForm.EditCreditInvoiceUid.value = invoiceUid;
    
    if(<%=(activeUser.getAccessRight("financial.patientcreditedit.edit")?"true":"false")%> && EditForm.EditCreditWicketUid.value==wicketuid){
      document.getElementById("buttonSave").style.visibility='visible';
      document.getElementById("EditCreditWicketUid").style.visibility='visible';
    }
    else if(document.getElementById("buttonSave")){
      document.getElementById("buttonSave").style.visibility='hidden';
      document.getElementById("EditCreditWicketUid").style.visibility='hidden';
    }

    if(invoiceUid.indexOf(".")>-1){
      EditForm.EditCreditInvoiceNr.value = invoiceUid.split(".")[1];
    }
    else{
      EditForm.EditCreditInvoiceNr.value = "";
    }
    
    document.getElementById('creditid').innerHTML=document.getElementById('EditCreditUid').value.split(".")[1];
    document.getElementById('printsection').style.visibility='visible';
    document.getElementById('PrintLanguage').style.visibility='visible';
    document.getElementById('momoimage').style.display='none';

    checkAlternate();
  }

  function clearEditFields(){
	if(document.getElementById("buttonSave")){
	  document.getElementById("buttonSave").style.visibility='visible';
	}
    document.getElementById("EditCreditWicketUid").style.visibility='visible';
    
    EditForm.EditCreditUid.value = "";
    EditForm.EditCreditDate.value = "<%=getDate()%>";
    EditForm.EditCreditInvoiceUid.value = "";
    EditForm.EditCreditInvoiceNr.value = "";
    EditForm.EditCreditAmount.value = "";
    EditForm.EditCreditCurrency.value = "";
    EditForm.EditAlternateCreditAmount.value = "";
    EditForm.EditCreditType.value = "<%=MedwanQuery.getInstance().getConfigString("defaultPatientCreditType","patient.payment")%>";

    <%
        // active encounter as default
        encounter = Encounter.getActiveEncounter(adminPerson.personid);
        if(encounter==null){
            encounter = new Encounter();
        }
    %>
    EditForm.EditCreditEncounterUid.value = "<%=encounter.getUid()%>";
    EditForm.EditCreditEncounterName.value = "<%=encounter.getEncounterDisplayName(sWebLanguage)%>";
    EditForm.EditCreditDescription.value = "";
    document.getElementById('printsection').style.visibility='hidden';
    document.getElementById('PrintLanguage').style.visibility='hidden';
    document.getElementById('creditid').innerHTML="";
    document.getElementById('momoimage').style.display='';

    <%
        if(userWickets.size() > 0){
            %>EditForm.EditCreditWicketUid.value = "<%=activeUser.getParameter("defaultwicket")%>";<%
        }
    %>
  }

  function doPrintPdf(creditUid){
    var url = "<c:url value='/financial/createPaymentReceiptPdf.jsp'/>?CreditUid="+creditUid+"&ts=<%=getTs()%>&PrintLanguage="+EditForm.PrintLanguage.value;
    window.open(url,"PaymentReceiptPdf<%=getTs()%>","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
  }

  function doBack(){
    window.location.href = "<c:url value='/main.do'/>?Page=financial/historyBalance.jsp&ts=<%=getTs()%>";
  }

  function clearFindFields(){
    EditForm.FindDateBegin.value = "";
    EditForm.FindDateEnd.value = "";
    EditForm.FindAmountMin.value = "";
    EditForm.FindAmountMax.value = "";
  }

  EditForm.EditCreditDate.focus();
  
  if(document.getElementById('EditCreditUid').value.length > 0){
    document.getElementById('creditid').innerHTML=document.getElementById('EditCreditUid').value.split(".")[1];
    document.getElementById('printsection').style.visibility = 'visible';
    document.getElementById('PrintLanguage').style.visibility = 'visible';
  }
  
<%
	if(sScreenType.equals("")){
	    %>loadUnassignedCredits();<%
	}
%>
	checkAlternate();
</script>