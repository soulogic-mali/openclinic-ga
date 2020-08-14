<%@page import="be.openclinic.finance.Insurar,
               java.util.Vector,
               be.mxs.common.util.system.HTMLEntities"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
    String sAction = checkString(request.getParameter("Action"));

    String sFindInsurarUid     = checkString(request.getParameter("FindInsurarUid")),
           sFindInsurarName    = checkString(request.getParameter("FindInsurarName")),
           sFindInsurarContact = checkString(request.getParameter("FindInsurarContact"));
    
    String sFunction = checkString(request.getParameter("doFunction"));
    String sExcludeCoverageplans = checkString(request.getParameter("ExcludeCoverageplans"));
    String sRestrictedListOnly=checkString(request.getParameter("RestrictedListOnly"));
    
    String sReturnFieldUid     = checkString(request.getParameter("ReturnFieldInsurarUid")),
           sReturnFieldName    = checkString(request.getParameter("ReturnFieldInsurarName")),
           sReturnFieldContact = checkString(request.getParameter("ReturnFieldInsurarContact"));
    
    
    if(sAction.length()==0 && sFindInsurarName.length() > 0){
    	sAction = "search"; // default
    }

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n*************** search/searchByAjax/searchInsurarShow.jsp **************");
        Debug.println("sAction             : "+sAction);
        Debug.println("sFindInsurarUid     : "+sFindInsurarUid);
        Debug.println("sFindInsurarName    : "+sFindInsurarName);
        Debug.println("sFindInsurarContact : "+sFindInsurarContact+"\n");
        Debug.println("sReturnFieldUid     : "+sReturnFieldUid);
        Debug.println("sReturnFieldName    : "+sReturnFieldName);
        Debug.println("sReturnFieldContact : "+sReturnFieldContact+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////

    String msg = "";

    //--- SEARCH ----------------------------------------------------------------------------------
    if(sAction.equals("search")){
        Vector foundInsurars = Insurar.getInsurarsByName(sFindInsurarName);
        int insurarCount = 0;

        if(foundInsurars.size() > 0){
%>
<br>

<%-- SEARCH RESULTS TABLE --%>
<table id="searchresults" class="sortable" cellpadding="0" cellspacing="0" width="100%">
    <%-- header --%>
    <tr class="admin">
        <td><%=HTMLEntities.htmlentities(getTran(request,"system.manage","insurarName",sWebLanguage))%></td>
        <td><%=HTMLEntities.htmlentities(getTran(request,"system.manage","insurarContact",sWebLanguage))%></td>
    </tr>
    
    <tbody class="hand">
        <%
            String sClass = "1", sContact;
            Insurar insurar;
            
            for(int i=0; i<foundInsurars.size(); i++){
                insurar = (Insurar) foundInsurars.get(i);
                
                if("true".equalsIgnoreCase(request.getParameter("excludePatientSelfInsurarUID")) && 
                   insurar.getUid().equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("patientSelfInsurarUID","none"))){
                    continue;
                }
                if(sExcludeCoverageplans.equalsIgnoreCase("true") && insurar.getContact().equalsIgnoreCase("plan.openinsurance")){
                	continue;
                }
                

                sContact = checkString(insurar.getContact());

                // alternate row-style
                if(sClass.equals("")) sClass = "1";
                else                  sClass = "";

		        %>
	        	<%if(!sRestrictedListOnly.equalsIgnoreCase("1") || insurar.getUseLimitedPrestationsList()==1){insurarCount++;%>
			        <tr class="list<%=sClass%>">
			            <td onClick="selectInsurar('<%=insurar.getUid()%>','<%=HTMLEntities.htmlentities(insurar.getName())%>');"><%=HTMLEntities.htmlentities(checkString(insurar.getName()))%></td>
			            <td onClick="selectInsurar('<%=insurar.getUid()%>','<%=HTMLEntities.htmlentities(insurar.getName())%>');"><%=HTMLEntities.htmlentities(sContact)%></td>
			        </tr>
	            <%}%>
		        <%
            }
        %>
    </tbody>
</table>
<script>sortables_init();</script>
<%
	    }
	
	    // number of found records
	    if(insurarCount > 0){
	        %>
	            <%=insurarCount%> <%=HTMLEntities.htmlentities(getTran(request,"web","recordsFound",sWebLanguage))%>
	            <script>sortables_init();</script>
	        <%
	    }
	    else{
	    	if(!sRestrictedListOnly.equalsIgnoreCase("1")){
	        	%><br><%=HTMLEntities.htmlentities(getTran(request,"web","noRecordsFound",sWebLanguage))%><%
	    	}
	    	else{
	        	%><br><%=HTMLEntities.htmlentities(getTran(request,"web","noRecordsFoundwithlimitedprestationlist",sWebLanguage))%><%
	    	}
	    }
	
	    // display message
        if(msg.length() > 0){
            %><br><%=HTMLEntities.htmlentities(msg)%><br><%
        }
    }
%>