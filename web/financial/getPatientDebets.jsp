<%@page import="be.openclinic.finance.*,
                be.openclinic.adt.Encounter,
                java.text.*"%>
<%@include file="/includes/validateUser.jsp"%>

<%!
    //--- ADD DEBETS ------------------------------------------------------------------------------
    private String addDebets(Vector vDebets, String sClass, String sWebLanguage, boolean bChecked, 
    		                 java.util.Date begin, java.util.Date end, User activeUser,
    		                 PatientInvoice patientInvoice){
        StringBuffer sReturn = new StringBuffer();
        
        if(vDebets!=null){
            Debet debet;
            Encounter encounter;
            Prestation prestation;
            String sEncounterName, sPrestationDescription, sCredited, sDebetUID;
            String sChecked = "";
            if(bChecked){
                sChecked = " checked";
                if(patientInvoice!=null && !((MedwanQuery.getInstance().getConfigInt("authorizeCancellationOfOpenInvoices",1)==1 && !patientInvoice.getStatus().equalsIgnoreCase("closed"))||(activeUser.getParameter("sa")!=null && activeUser.getParameter("sa").length() > 0)||activeUser.getAccessRight("financial.cancelclosedinvoice.select"))){
                	sChecked+=" disabled='true'";
                }
            }

            for(int i=0; i<vDebets.size(); i++){
                sDebetUID = checkString((String)vDebets.elementAt(i));

                if(sDebetUID!=null && sDebetUID.length()>0){
                    debet = Debet.get(sDebetUID);
                    if(debet!=null){
                    	if(begin!=null && debet.getDate()!=null && debet.getDate().before(begin)){
                    		continue;
                    	}
                    	if(end!=null && debet.getDate()!=null && debet.getDate().after(end)){
                    		continue;
                    	}
                    	
                    	// alternate row-style
                        if(sClass.equals("")) sClass = "1";
                        else                  sClass = "";
                        
                        sEncounterName = "";

                        if(checkString(debet.getEncounterUid()).length() > 0){
                            encounter = debet.getEncounter();

                            if(encounter!=null){
                                sEncounterName = encounter.getEncounterDisplayName(sWebLanguage);
                            }
                        }

                        sPrestationDescription = "";

                        if(checkString(debet.getPrestationUid()).length()>0){
                            prestation = debet.getPrestation();

                            if(prestation!=null){
                                sPrestationDescription = checkString(prestation.getDescription());
                            }
                        }

                        sCredited = "";
                        if(debet.getCredited()>0){
                            sCredited = getTran(null,"web","canceled",sWebLanguage);
                        }
                        double patientAmount=debet.getExtraInsurarUid2()!=null && debet.getExtraInsurarUid2().length()>0?0:debet.getAmount();
                        double insurarAmount=debet.getInsurarAmount()+debet.getExtraInsurarAmount();
                        String insuraruid="zeyrfgkaef";
                        if(debet.getInsurance()!=null && debet.getInsurance().getInsurarUid()!=null){
                        	insuraruid = debet.getInsurance().getInsurarUid();
                        }
                        
                        sReturn.append( "<tr class='list"+sClass+"'>"
	                            +((patientInvoice!=null && checkString(patientInvoice.getAcceptationUid()).length()>0) || (activeUser!=null && activeUser.getParameter("insuranceagent")!=null && activeUser.getParameter("insuranceagent").length()>0)?
                        		("<td><input type='hidden' id='cbDebetInsurar"+debet.getUid()+"' value='"+new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceCalculationFormat","#.00")).format(insurarAmount)+"'/><input type='hidden' name='cbDebet"+debet.getUid()+"="+new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceCalculationFormat","#.00")).format(patientAmount)+"' "+sChecked+" "+(sChecked.length()>0?" value='1'":"")+"/>"+(sChecked.length()>0?"<img src='"+sCONTEXTPATH+"/_img/themes/default/checked.png'/>":"<img src='"+sCONTEXTPATH+"/_img/themes/default/unchecked.png'/>")+"</td>"):
	                            ("<td><input type='hidden' id='cbDebetInsurar"+debet.getUid()+"' value='"+new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceCalculationFormat","#.00")).format(insurarAmount)+"'/><input type='hidden' id='cbDebetInsurance"+debet.getUid()+"' value='"+debet.getInsuranceUid()+"'/><input type='checkbox' name='cbDebet"+debet.getUid()+"="+new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceCalculationFormat","#.00")).format(patientAmount)+"' onclick='removeReductions();doBalance(this, true)'"+sChecked+"></td>"))
	                            +"<td>"+(debet.getDate()==null?"":ScreenHelper.getSQLDate(debet.getDate()))+"</td>"
	                            +"<td>"+(debet.getInsurance()==null || debet.getInsurance().getInsurar()==null?"":debet.getInsurance().getInsurar().getName())+"</td>"
	                            +"<td>"+sEncounterName+"</td>"
	                            +"<td>"+debet.getQuantity()+" x "+sPrestationDescription+"</td>"
	                            +"<td>"+patientAmount+" "+MedwanQuery.getInstance().getConfigParam("currency","€")+"</td>"
	                            +"<td>"+sCredited+"</td>"
	                            +"<td>"+(debet.getInsurarInvoiceUid()==null?"":ScreenHelper.checkString(debet.getInsurarInvoiceUid()).replaceAll("1\\.",""))+"</td>"
	                            +"<td>"+(debet.getExtraInsurarInvoiceUid()==null?"":ScreenHelper.checkString(debet.getExtraInsurarInvoiceUid()).replaceAll("1\\.",""))+"</td>"
	                            +"<td>"+(debet.getExtraInsurarInvoiceUid2()==null?"":ScreenHelper.checkString(debet.getExtraInsurarInvoiceUid2()).replaceAll("1\\.",""))+"</td>"
	                        +"</tr>");
                    }
                }
            }
        }
            
        return sReturn.toString();
    }
%>

<%
	String sPatientInvoiceUid = checkString(request.getParameter("PatientInvoiceUID"));
	String sPatientId = checkString(request.getParameter("PatientUID"));
	String sInvoiceService = checkString(request.getParameter("EditInvoiceService"));

	String sBegin = checkString(request.getParameter("Begin")),
	       sEnd   = checkString(request.getParameter("End"));
	java.util.Date begin = null, end = null;
	try{
		begin = ScreenHelper.parseDate(sBegin);
	}
	catch(Exception e){
	}
	
	try{
		end = ScreenHelper.parseDate(sEnd);
	}
	catch(Exception e){
	}

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n##################### financial/getPatientDebets.jsp ##################");
        Debug.println("sPatientInvoiceUid : "+sPatientInvoiceUid);
        Debug.println("sPatientId         : "+sPatientId);
        Debug.println("sInvoiceService    : "+sInvoiceService);
        Debug.println("sBegin             : "+sBegin);
        Debug.println("sEnd               : "+sEnd+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
	Vector vDebets = new Vector();
	PatientInvoice patientInvoice = null;
	if(sPatientInvoiceUid.length() > 0){
		patientInvoice = PatientInvoice.get(sPatientInvoiceUid);
		if(patientInvoice!=null){
			vDebets = patientInvoice.getDebetStrings();
		}
	}
%>

<table width="100%" cellspacing="1" cellpadding="0">
    <%-- HEADER --%>
    <tr class="gray">
        <td width="20"><%=getTranNoLink("web","invoiceabbreviation",sWebLanguage)%></td>
        <td width="80"><%=getTranNoLink("web","date",sWebLanguage)%></td>
        <td><%=getTranNoLink("web","insurar",sWebLanguage)%></td>
        <td><%=getTranNoLink("web.finance","encounter",sWebLanguage)%></td>
        <td><%=getTranNoLink("web","prestation",sWebLanguage)%></td>
        <td><%=getTranNoLink("web","amount",sWebLanguage)%></td>
        <td><%=getTranNoLink("web","credit",sWebLanguage)%></td>
        <td><%=getTranNoLink("web","insuranceinvoiceid",sWebLanguage)%></td>
        <td><%=getTranNoLink("web","extrainsuranceinvoiceid",sWebLanguage)%></td>
        <td><%=getTranNoLink("web","extrainsuranceinvoiceid2",sWebLanguage)%></td>
    </tr>
    
<%
try{
	boolean isInsuranceAgent = false;
	if(activeUser!=null && activeUser.getParameter("insuranceagent")!=null && activeUser.getParameter("insuranceagent").length()>0 && MedwanQuery.getInstance().getConfigString("InsuranceAgentAcceptationNeededFor","").indexOf("*"+activeUser.getParameter("insuranceagent")+"*")>-1){
		// This is an insurance agent, limit the functionalities
		isInsuranceAgent = true;
	}
    String sClass = "";
    out.print(addDebets(vDebets,sClass,sWebLanguage,true,null,null,activeUser,patientInvoice));


    if(!isInsuranceAgent && (patientInvoice==null || checkString(patientInvoice.getAcceptationUid()).length()==0) && (patientInvoice==null || (!(checkString(patientInvoice.getStatus()).equalsIgnoreCase("closed") || checkString(patientInvoice.getStatus()).equalsIgnoreCase("canceled"))))){
        Vector vUnassignedDebets;
        if(sInvoiceService.length()==0){
        	vUnassignedDebets = Debet.getUnassignedPatientDebets(sPatientId);
        }
        else{
        	vUnassignedDebets = Debet.getUnassignedPatientDebets(sPatientId,sInvoiceService);
        }
        	        
        out.print(addDebets(vUnassignedDebets,sClass,sWebLanguage,false,begin,end,activeUser,patientInvoice));
        out.print("<tr><td colspan='10'>"+vUnassignedDebets.size()+" "+getTranNoLink("web","records.loaded",sWebLanguage)+"</td></tr>");
    }
}
catch(Exception e){
	e.printStackTrace();
}
%>
</table>