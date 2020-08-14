<%@page import="be.openclinic.finance.*,
                java.util.Vector,
                be.mxs.common.util.system.HTMLEntities,
                be.openclinic.finance.Insurance"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
	String sAction = checkString(request.getParameter("Action"));

    String sFindPrestationRefName = checkString(request.getParameter("FindPrestationRefName")),
           sFindPrestationCode    = checkString(request.getParameter("FindPrestationCode")),
           sFindPrestationDescr   = checkString(request.getParameter("FindPrestationDescr")),
           sFindPrestationType    = checkString(request.getParameter("FindPrestationType")),
 		   sFindPrestationSort    = checkString(request.getParameter("FindPrestationSort")),
 		   sFindPrestationKeywords   = checkString(request.getParameter("keywordsid")),
 		   sEncounterUid	      = checkString(request.getParameter("encounteruid")),
           sFindPrestationPrice   = checkString(request.getParameter("FindPrestationPrice"));

    String sFunction = checkString(request.getParameter("doFunction"));
    String sCheckInsurance = checkString(request.getParameter("CheckInsurance"));
    boolean mustCheckInsurance=false;
    Insurar insurar=null;
    if(sCheckInsurance.length()>0){
    	Insurance insurance = Insurance.get(sCheckInsurance);
    	if(insurance!=null){
    		insurar = insurance.getInsurar();
    		mustCheckInsurance=insurar.getUseLimitedPrestationsList()==1;
    	}
    }

    String sReturnFieldUid   = checkString(request.getParameter("ReturnFieldUid")),
           sReturnFieldCode  = checkString(request.getParameter("ReturnFieldCode")),
           sReturnFieldDescr = checkString(request.getParameter("ReturnFieldDescr")),
           sReturnFieldType  = checkString(request.getParameter("ReturnFieldType")),
           sReturnFieldPrice = checkString(request.getParameter("ReturnFieldPrice"));
    
    if(sFindPrestationSort.length()==0){
    	sFindPrestationSort = "OC_PRESTATION_CODE";
    }

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n************* search/searchByAjax/searchPrestationShow.jsp *************");
        Debug.println("sAction                : "+sAction);
        Debug.println("sFindPrestationRefName : "+sFindPrestationRefName);
        Debug.println("sFindPrestationCode    : "+sFindPrestationCode);
        Debug.println("sFindPrestationDescr   : "+sFindPrestationDescr);
        Debug.println("sFindPrestationType    : "+sFindPrestationType);
        Debug.println("sFindPrestationSort    : "+sFindPrestationSort);
        Debug.println("sFindPrestationPrice   : "+sFindPrestationPrice);
        Debug.println("sFindPrestationKeywords: "+sFindPrestationKeywords);
        Debug.println("sFunction              : "+sFunction+"\n");
        
        Debug.println("sReturnFieldUid   : "+sReturnFieldUid);
        Debug.println("sReturnFieldCode  : "+sReturnFieldCode);
        Debug.println("sReturnFieldDescr : "+sReturnFieldDescr);
        Debug.println("sReturnFieldType  : "+sReturnFieldType);
        Debug.println("sReturnFieldPrice : "+sReturnFieldPrice+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////

    String sCurrency = MedwanQuery.getInstance().getConfigParam("currency","€");

    
    //*** SEARCH **********************************************************************************
    if(sAction.equals("search")){
    	String sFindDescr = sFindPrestationDescr.replaceAll(MedwanQuery.getInstance().getConfigString("equivalentofe","[eéèê]"),"e")
    			                                .replaceAll(MedwanQuery.getInstance().getConfigString("equivalentofa","[aàá]"),"a");
        Vector foundPrestations = Prestation.searchActivePrestations(sFindPrestationCode,sFindDescr.replaceAll(" ","%"),sFindPrestationType,sFindPrestationPrice,"",sFindPrestationSort,sFindPrestationKeywords);
        Iterator prestationsIter = foundPrestations.iterator();
        String sClass = "", sUid, sCode, sDescr, sType, sTypeTran, sPrice, sSupplement;
        String sSelectTran = getTranNoLink("web","select",sWebLanguage);
        int recCount = 0;
        StringBuffer sHtml = new StringBuffer();
        Prestation prestation;
        
        String category = "";            
        Insurance insurance = null;
        
        if(sCheckInsurance.split("\\.").length==2){
        	insurance=Insurance.get(sCheckInsurance);
        }
        else{
        	insurance = activePatient!=null?Insurance.getMostInterestingInsuranceForPatient(checkString(activePatient.personid)):null;
        }
        if(insurance!=null){
            category = insurance.getType();
        }
		Encounter encounter = null;
		if(sEncounterUid.length()>0){
			encounter=Encounter.get(sEncounterUid);
		}
		else if(activePatient!=null){
			encounter=Encounter.getActiveEncounter(activePatient.personid);
		}
        while(prestationsIter.hasNext()){
            prestation = (Prestation)prestationsIter.next();
            if(prestation==null || (encounter!=null && !prestation.isVisibleFor(insurar,encounter.getService()))){
            	continue;
            }
            if(MedwanQuery.getInstance().getConfigInt("showZeroPricePrestationsWithoutCategoryPrice",1)==0 && prestation.getCategories().indexOf(category+"=")<0 && prestation.getPrice()==0){
            	continue;
            }
            if(MedwanQuery.getInstance().getConfigInt("showNegativeCategoryPrice",0)==0 && prestation.getPrice(category)<0){
            	continue;
            }
            if(prestation!=null && !checkString(prestation.getType()).equalsIgnoreCase("con.openinsurance")){
            	recCount++;

	             // names
	             sUid = prestation.getUid();
	             sCode = checkString(prestation.getCode());
	             sDescr = checkString(prestation.getDescription()).replaceAll("'","´").replaceAll("\"","´´");
	             String sCleanDescr = sDescr;
	             if(sFindPrestationDescr.length()>0){
	            	 String[] s = sFindPrestationDescr.split(" ");
	            	 for(int n=0;n<s.length;n++){
	            		 if(s[n].length()>0){
	            			 sDescr=sDescr.toUpperCase().replaceAll(s[n].toUpperCase(), "<font style='background-color: yellow'>"+s[n].toUpperCase()+"</font>");
	            		 }
	            	 }
	             }
	
	             // type
	             sType = checkString(prestation.getType());
	             sTypeTran = getTran(request,"prestation.type",sType,sWebLanguage);
	
	             // price
	             double price = prestation.getPrice();
	             if(price==0) sPrice = "";
	             else         sPrice = price+"";
	
	             // supplement
	             double supplement = prestation.getSupplement();
	             if(supplement==0) sSupplement = "";
	             else              sSupplement = supplement+"";
	
	             // alternate row-style
	             if(sClass.equals("")) sClass = "1";
	             else                  sClass = "";
	             
		         if(activeUser.getAccessRight("financial.entervariableprice.select") && prestation.getVariablePrice()==1){
	                 sHtml.append("<tr class='list"+sClass+"' title='"+sSelectTran+"' onclick=\"setPrestationVariable('"+sUid+"','"+sCode+"','"+sCleanDescr+"','"+sType+"','"+sPrice+"','"+sSupplement+"');\">")
	                       .append("<td>"+prestation.getUid()+"</td>")
	                       .append("<td>"+sCode+"</td>")
	                       .append("<td>"+sDescr+"</td>")
	                       .append("<td>"+sTypeTran+"</td>")
	                       .append("<td nowrap>"+prestation.getPriceFormatted(category)+"</td>")
	                       .append("<td width='20%'>"+checkString(prestation.getCategoriesFormatted(category))+"</td>")
	                      .append("</tr>");
		         }
		         else{
	                 sHtml.append("<tr class='list"+sClass+"' title='"+sSelectTran+"' onclick=\"setPrestation('"+sUid+"','"+sCode+"','"+sCleanDescr+"','"+sType+"','"+sPrice+"','"+sSupplement+"');\">")
	                       .append("<td>"+prestation.getUid()+"</td>")
	                       .append("<td>"+sCode+"</td>")
	                       .append("<td>"+sDescr+"</td>")
	                       .append("<td>"+sTypeTran+"</td>")
	                       .append("<td nowrap>"+prestation.getPriceFormatted(category)+"</td>")
	                       .append("<td width='20%'>"+checkString(prestation.getCategoriesFormatted(category))+"</td>")
	                      .append("</tr>");
		         }
             }
         }

         if(recCount > 0){
	     	%>
			    <table id="searchresults" class="sortable" width="100%" cellpadding="1" cellspacing="0">
			        <%-- header --%>
			        <tr class="admin">
			            <td><%=HTMLEntities.htmlentities(getTran(request,"web","id",sWebLanguage))%></td>
			            <td><%=HTMLEntities.htmlentities(getTran(request,"web","code",sWebLanguage))%></td>
			            <td><%=HTMLEntities.htmlentities(getTran(request,"web","description",sWebLanguage))%></td>
			            <td><%=HTMLEntities.htmlentities(getTran(request,"web","type",sWebLanguage))%></td>
			            <td><%=HTMLEntities.htmlentities(getTran(request,"web","price",sWebLanguage))%> <%=HTMLEntities.htmlentities(sCurrency)%> </td>
			            <td><%=HTMLEntities.htmlentities(getTran(request,"web","categories",sWebLanguage))%></td>
			        </tr>
			
			        <tbody class="hand"><%=HTMLEntities.htmlentities(sHtml.toString())%></tbody>
			    </table>
	    
                <%=recCount%> <%=HTMLEntities.htmlentities(getTran(request,"web","norecordsfound",sWebLanguage))%>
                <script>sortables_init();</script>
	        <%
	    }
        else{
	        // display 'no results' message
	        %><%=HTMLEntities.htmlentities(getTran(request,"web","norecordsfound",sWebLanguage))%><%
        }
    }
%>