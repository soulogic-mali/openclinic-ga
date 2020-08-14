<%@page import="org.dom4j.DocumentException,
                java.util.Vector,
                java.util.Hashtable,
                java.util.Enumeration,
                be.mxs.common.util.system.HTMLEntities"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%!
    //--- GET HTML --------------------------------------------------------------------------------
    private String getHtml(Vector users, String sWebLanguage){
        String sClass = "1";
        StringBuffer html = new StringBuffer();
        Hashtable hServices = new Hashtable();
        String sServiceID, sServiceName;
        
        // run through users
        Hashtable user;
        for(int i=0; i<users.size(); i++){
            user = (Hashtable)users.get(i);

            // alternate row-style
            if(sClass.equals("")) sClass = "1";
            else                  sClass = "";

            sServiceID = (String)user.get("serviceId");
            sServiceName = checkString((String)hServices.get(sServiceID));

            if(sServiceName.length()==0){
                sServiceName = getTran(null,"service",sServiceID,sWebLanguage);
                hServices.put(sServiceID,sServiceName);
            }
            
            // one row (user/service)
            html.append("<tr class='list"+sClass+"' onclick=\"setPerson('"+user.get("personId")+"','"+user.get("userId")+"','"+user.get("lastName")+" "+user.get("firstName")+"');\">")
                 .append("<td class='hand'>"+user.get("lastName")+" "+user.get("firstName")+" ("+user.get("userId")+")</td>")
                 .append("<td class='hand'>"+sServiceName+"</td>")
                .append("</tr>");
        }

        return html.toString();
    }

%>

<%
    String sFindLastname   = checkString(request.getParameter("FindLastname")),
           sFindFirstname  = checkString(request.getParameter("FindFirstname")),
           sReturnPersonID = checkString(request.getParameter("ReturnPersonID")),
           sReturnUserID   = checkString(request.getParameter("ReturnUserID")),
           sReturnName     = checkString(request.getParameter("ReturnName")),
           sSetGreenField  = checkString(request.getParameter("SetGreenField"));

    // options
    boolean displayImmatNew = !checkString(request.getParameter("displayImmatNew")).equalsIgnoreCase("no");

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n**************** search/searchByAjax/searchUserShow.jsp ***************");
        Debug.println("sFindLastname   : "+sFindLastname);
        Debug.println("sFindFirstname  : "+sFindFirstname);
        Debug.println("sReturnPersonID : "+sReturnPersonID);
        Debug.println("sReturnUserID   : "+sReturnUserID);
        Debug.println("sReturnName     : "+sReturnName);
        Debug.println("sSetGreenField  : "+sSetGreenField);
        Debug.println("displayImmatNew : "+displayImmatNew+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////

    String selectedTab = "", sLastname, sFirstname, sServiceID;

    // clean names
    String sSelectLastname  = ScreenHelper.normalizeSpecialCharacters(sFindLastname),
           sSelectFirstname = ScreenHelper.normalizeSpecialCharacters(sFindFirstname);

    Vector vUsers = User.searchUsers(sSelectLastname,sSelectFirstname);
    Iterator userIter = vUsers.iterator();
    Hashtable usersPerDiv = new Hashtable();
    String sSearchService=checkString(request.getParameter("FindServiceID"));
    if(sSearchService.length()>0 && sSelectLastname.length()==0 && sSelectFirstname.length()==0){
    	usersPerDiv.put(sSearchService,new Vector());
    }
    else {
    	sSearchService="##??//";
    }
    usersPerDiv.put("varia",new Vector());
    // run thru found users
    Hashtable user, hUserInfo;
    while(userIter.hasNext()){
        hUserInfo = (Hashtable)userIter.next();
        
        // names
        sLastname = (String)hUserInfo.get("lastname");
        sFirstname = (String)hUserInfo.get("firstname");
        if(displayImmatNew){
            sFirstname+= " "+hUserInfo.get("immatnew");
        }
        sLastname = sLastname.replace('\'','´');
        sFirstname = sFirstname.replace('\'','´');

        // service
        sServiceID = checkString((String)hUserInfo.get("serviceid"));

        // assemble user
        user = new Hashtable();
        user.put("personId",hUserInfo.get("personid"));
        user.put("userId",hUserInfo.get("userid"));
        user.put("lastName",sLastname);
        user.put("firstName",sFirstname);
        user.put("serviceId",sServiceID);

        if(sServiceID.toUpperCase().startsWith(sSearchService.toUpperCase())){
        	((Vector)(usersPerDiv.get(sSearchService))).add(user);
        }
        else{
        	((Vector)(usersPerDiv.get("varia"))).add(user);
        }
    }

	if(usersPerDiv.get(sSearchService)!=null && !sSearchService.equalsIgnoreCase("##??//")){
        selectedTab = "tab_1";
    }
	else{
		selectedTab="tab_varia";
	}
%>

<div class="search" style="border:none;width:100%">
    <%-- TABS ---------------------------------------------------------------%>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <%
        	if(usersPerDiv.get(sSearchService)!=null){

                String serviceName = getTranNoLink("service",checkString(request.getParameter("FindServiceID")),sWebLanguage);
               	String serviceNameFull=serviceName;
               	if(serviceName.length()>20){
               		serviceName=serviceName.substring(0, 20)+"...";
               	}
		        %>
	            <td style="cursor:pointer" class="tabunselected" width="1%" title="<%=HTMLEntities.htmlentities(serviceNameFull)%>" onclick="activateTab('tab_1')" id="td1" nowrap>
	            	&nbsp;<b><%=HTMLEntities.htmlentities(serviceName)%></b>&nbsp;
	            </td>
	            
	            <%-- varia division TR --%>
	            <td class="tabs" width="5">&nbsp;</td>
	            <%
        	}
            %>
            <td style="cursor:pointer" class="tabunselected" width="1%" onclick="activateTab('tab_varia')" id="td2" nowrap>
                &nbsp;<b><%=HTMLEntities.htmlentities(getTranNoLink("web","varia",sWebLanguage))%></b>&nbsp;
            </td>
            
            <td class="tabs" width="*">&nbsp;</td>
        </tr>
    </table>
    
    <%-- TAB CONTENTS -------------------------------------------------------%>
    <table width="100%" cellspacing="0" cellpadding="0" style="border-top:none;">
        <%-- one division --%>
        <%
        	if(usersPerDiv.get(sSearchService)!=null){
        %>
	        <tr id="tr_tab1" style="display:none">
	            <td>
	                <table width="100%" cellpadding="0" cellspacing="0" class="sortable" id="searchresults1" style="border-top:none;">
	                    <%-- header --%>
	                    <tr class="admin">
	                        <td width="200"><%=HTMLEntities.htmlentities(getTran(request,"Web","name",sWebLanguage))%></td>
	                        <td width="300"><%=HTMLEntities.htmlentities(getTran(request,"Web","service",sWebLanguage))%></td>
	                    </tr>
	                    <tbody class="hand">
	                        <%=HTMLEntities.htmlentities(getHtml((Vector)(usersPerDiv.get(checkString(request.getParameter("FindServiceID")))),sWebLanguage))%>
	                    </tbody>
	                </table>
	
	                <%
	                    if(((Vector)usersPerDiv.get(checkString(request.getParameter("FindServiceID")))).size()==0){
	                        // no records found message
	                        %><div><%=HTMLEntities.htmlentities(getTran(request,"web","nousersFoundInDivision",sWebLanguage))%></div><%
	                    }
	                    else{
	                        // X records found message
			                %><div><%=((Vector)usersPerDiv.get(checkString(request.getParameter("FindServiceID")))).size()%> <%=HTMLEntities.htmlentities(getTran(request,"web","usersFoundInDivision",sWebLanguage))%></div><%
	                    }
	                %>
	            </td>
	        </tr>
        <%
        	}
        %>
        <%-- varia division TR --%>
        <tr id="tr_tabvaria" style="display:none">
            <td>
                <table width="100%" cellpadding="0" cellspacing="0" class="sortable" id="searchresults2" style="border-top:none;">
                    <%-- header --%>
                    <tr class="admin">
                        <td width="200"><%=HTMLEntities.htmlentities(getTran(request,"Web","name",sWebLanguage))%></td>
                        <td width="300"><%=HTMLEntities.htmlentities(getTran(request,"Web","service",sWebLanguage))%></td>
                    </tr>

                    <tbody class="hand">
                        <%=HTMLEntities.htmlentities(getHtml((Vector)(usersPerDiv.get("varia")),sWebLanguage))%>
                    </tbody>
                </table>

                <%
                    if(((Vector)usersPerDiv.get("varia")).size()==0){
                        // no records found message
                        %><div><%=HTMLEntities.htmlentities(getTran(request,"web","nousersFoundInDivision",sWebLanguage))%></div><%
                    }
                    else{
                        // X records found message
                        %><div><%=((Vector)usersPerDiv.get("varia")).size()%> <%=HTMLEntities.htmlentities(getTran(request,"web","usersFoundInDivision",sWebLanguage))%></div><%
                    }
                %>
            </td>
        </tr>
    </table>
</div>
<script>activateTab('<%=selectedTab%>');</script>