<%@page import="be.openclinic.adt.Bed,
                java.util.Vector"%>
<%@include file="/includes/validateUser.jsp"%>

<%
    String sFindBedName    = checkString(request.getParameter("FindBedName")),
    	   sFindBedService = checkString(request.getParameter("FindBedService"));

    String sEditUID = checkString(request.getParameter("EditUID")); // display in bold

    if(sFindBedName.length() > 0){
        sFindBedName = sFindBedName.replaceAll("\\[pct\\]","%");
    }

	/// DEBUG /////////////////////////////////////////////////////////////////////////////////////
	if(Debug.enabled){
	    Debug.println("\n********************** system/ajax/searchBeds.jsp *********************");
	    Debug.println("sFindBedName    : "+sFindBedName);
	    Debug.println("sFindBedService : "+sFindBedService);
	    Debug.println("sEditUID        : "+sEditUID);
	}
	///////////////////////////////////////////////////////////////////////////////////////////////


    StringBuffer sBeds = new StringBuffer();
    Vector vBeds = Bed.selectBeds("","",sFindBedName,sFindBedService,"","","");
    Debug.println("--> Found "+vBeds.size()+" beds '"+sFindBedName+"' in service '"+sFindBedService+"'\n");

    Iterator bedIter = vBeds.iterator();
    Bed tmpBed;
        
    String sClass = "list1";
    String sServiceUID = "", sServiceName = "";

    while(bedIter.hasNext()){
        tmpBed = (Bed)bedIter.next();
                    
        // service
        sServiceUID = checkString(tmpBed.getServiceUID());
        if(sServiceUID.length() > 0){
            sServiceName = getTran(request,"Service",sServiceUID,sWebLanguage);
        } 
        else{
            sServiceName = "";
        }
        
        // limit comment
        String sComment = checkString(tmpBed.getComment());
        if(sComment.length() > 50){
        	sComment = sComment.substring(0,50)+"..";
        }

    	// alternate row-style
        if(sClass.equals("list")) sClass = "list1";
        else                      sClass = "list";
    	
    	// mark currently edited record
        if(tmpBed.getUid().equals(sEditUID)){
            sClass = "list_select";
        }
    	
        sBeds.append("<tr class='"+sClass+"'>"+  
                      "<td><img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' class='link' onClick=\"doDeleteBed('"+tmpBed.getUid()+"');\" alt='"+getTranNoLink("web","delete",sWebLanguage)+"'></td>"+
                      "<td><a href='#' onclick=\"doSelect('"+checkString(tmpBed.getUid())+"');\">"+checkString(tmpBed.getName())+"</a></td>"+
	                  "<td>"+tmpBed.getPriority()+"</td>"+
	                  "<td>"+checkString(tmpBed.getLocation())+"</td>"+
	                  "<td>"+sComment+"</td>"+
	                 "</tr>");
    }
        
    if(sBeds.length()==0){
        out.print(getTran(request,"web","noRecordsFound",sWebLanguage));
    }
    else{       
	    %>
	        <i><b><%=getTran(request,"Service",sFindBedService,sWebLanguage)%></b></i>
	        <table width="100%" cellspacing="0" cellpadding="0" class="sortable" id="searchresults">
	            <tr class="admin">
	                <td width="20">&nbsp;</td>
	                <td width="20%"><%=getTran(request,"web","bed",sWebLanguage)%></td>
	                <td width="7%"><%=getTran(request,"web","priority",sWebLanguage)%></td>
	                <td width="30%"><%=getTran(request,"web","location",sWebLanguage)%></td>
	                <td width="43%"><%=getTran(request,"web","comment",sWebLanguage)%></td>
	            </tr>
	            <%=sBeds%>
	        </table>
	
	        <div><%=vBeds.size()%> <%=getTran(request,"web","recordsFound",sWebLanguage)%></div><br>
	        <script>sortables_init();</script>
	    <%
    }
%>