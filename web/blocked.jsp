<%@include file="/includes/helper.jsp"%>

<html>
<head>
     <%=sCSSNORMAL%>
    <%=sJSCOOKIE%>
    <%=sJSDROPDOWNMENU%>
    <%=sIcon%>
    
    <script>
      function escBackSpaceAndRefresh(){
        if(window.event && (enterEvent(event,8) ||enterEvent(event,116))){
          window.event.keyCode = 123; // F12
        }
      }

      function closeWindow(){
        window.opener = null;
        window.close();
      }

    </script>

    <%
        // title
        String sTmpAPPDIR   = ScreenHelper.getCookie("activeProjectDir",request),
               sTmpAPPTITLE = ScreenHelper.getCookie("activeProjectTitle",request);

        if(sTmpAPPTITLE==null) sTmpAPPTITLE = "OpenClinic";
    %>
	<title><%=sWEBTITLE+" "+sTmpAPPTITLE%></title>
</head>

<body class="Geenscroll login" onkeydown="escBackSpaceAndRefresh();if(enterEvent(event,13)){goToLogin();}" >
<%
	if("openinsurance".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("edition",""))){
        %><div id="loginopeninsurance" class="withoutfields"><%
	}
	else{
        %><div id="login" class="withoutfields"><%
	}
%>

    <div id="logo">
        <%if("datacenter".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("edition",""))){
            session.setAttribute("edition", "datacenter");%>
        <img src="projects/datacenter/_img/logo.jpg" border="0">
        <%}else if("openlab".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("edition",""))){
            session.setAttribute("edition", "openlab");%>
        <img src="projects/openlab/_img/logo.jpg" border="0">
        <%}else if("openpharmacy".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("edition",""))){
            session.setAttribute("edition", "openlab");%>
        <img src="_img/openpharmacy_logo.jpg" border="0">
        <%}else if("openinsurance".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("edition",""))){
            session.setAttribute("edition", "openinsurance");%>
        <img src="_img/openinsurancelogo.jpg" border="0">
        <%}else{
            session.setAttribute("edition", "openclinic");%>
        <img src="<%=sCONTEXTPATH%>/_img/logo.jpg" border="0">
        <%}%>
    </div>
      
    <div id="version">&nbsp;</div>
    <div id="fields" >
        <table width="170" cellspacing="0" cellpadding="0" align="left">
            <tr><td>Accesss denied&nbsp;</td></tr>
            <tr>
                <td>
                    <%
                        String sDuration = checkString(request.getParameter("duration"));

                        if(sDuration.length() > 0){
                            %>Access denied<%
                            if(sDuration.equals("0")){ %> permanently<% }
                            else{
                                %> for <%
                                int mins  = Integer.parseInt(sDuration);

                                int days  = mins/1440;
                                mins = mins%1440;
                                if(days > 0){ %><%=days%> day(s)<% }

                                int hours = mins/60;
                                mins = mins%60;
                                if(hours > 0){
                                  if(days > 0){ %> and<% }
                                  %><%=hours%> hour(s)<%
                                }

                                if(mins > 0){
                                  if(hours > 0){ %> and<% }
                                  %><%=mins%> minute(s)<%
                                }
                            }
                        }
                        else{
                            %>Your IP is blocked<%
                        }
                    %>.<br>Please contact your system administrator.
                        <br><br>
                        <a href="javascript:closeWindow();" onMouseOver="window.status='';return true;">close window</a>
                   </td>
               </tr>
           </table>
       </div>
       <div id="messages" class="messagesnofields">
	        <center><%=MedwanQuery.getInstance().getConfigString("openclinicedition", "GA Open Source Edition") %> by:
	        <% if (MedwanQuery.getInstance().getConfigString("mxsref", "rw").equalsIgnoreCase("rw")){ %>
	        <img src="_img/flags/rwandaflag.jpg" height="15px" width="30px" alt="Rwanda"/>
	        <a href="http://mxs.rwandamed.org" target="_new"><b>The Open-IT Group Ltd</b></a>
	        <BR/> PO Box 3242 - Kigali Rwanda Tel +250 07884 32 435 -
	        <a href="mailto:mxs@rwandamed.org">openit@rwandamed.org</a>
	        <% } else if (MedwanQuery.getInstance().getConfigString("mxsref", "rw").equalsIgnoreCase("bi")){ 
	        	if(MedwanQuery.getInstance().getConfigString("projectref","").equalsIgnoreCase("paiss")){
		        %>
			        <img src="_img/flags/enabel.png" height="20px" alt="Enabel Burundi"/>
			        <a href="http://www.enabel.be" target="_new"><b>Enabel Burundi - PAISS</b></a>
			        <BR/> Avenue de la Croix Rouge, BP 6708 - Bujumbura +257 222 775 48<br/>
		        <% 
	        	}
	        	else {
	    	        %>
			        <img src="_img/flags/burundiflag.jpg" height="15px" width="30px" alt="Burundi"/>
			        <a href="http://www.openit-burundi.net" target="_new"><b>Open-IT Burundi SPRL</b></a>
			        <BR/> Avenue de l'ONU 6, BP 7205 - Bujumbura +257 78 837 342<br/>
			        <a href="mailto:info@openit-burundi.net">info@openit-burundi.net</a>
		        <% 
	        	}
	        } else if (MedwanQuery.getInstance().getConfigString("mxsref", "rw").equalsIgnoreCase("ml")){ %>
	        <img src="_img/flags/maliflag.jpg" height="15px" width="30px" alt="Mali"/>
	        <a href="http://www.sante.gov.ml/" target="_new"><b>ANTIM</b></a> et <a href="http://www.mxs.be" target="_new"><b>Post-Factum</b></a>
	        <BR/> Hamdalaye ACI 2000, Rue 340, Porte 541, Bamako - Mali<br/>
	        <a href="mailto:info@openit-burundi.net">antim@sante.gov.ml</a>
	        <% } else { 
	        	if(MedwanQuery.getInstance().getConfigString("projectref","").equalsIgnoreCase("vub")){
		        %>
			        <img src="_img/flags/vub.png" height="20px" alt="Vrije Universiteit Brussel"/>
			        <a href="http://bisi.vub.ac.be" target="_new"><b>VUB - ICT4Development</b></a>
			        <BR/>Laarbeeklaan 103, B-1090 Brussel, +32(2)477.44.30 <a href="mailto:info@ict4development.org">info@ict4development.org</a>
		        <% 
	        	}
	        	else {
	        		%>
			        <img src="_img/flags/belgiumflag.jpg" height="10px" width="20px" alt="Belgium"/>
			        <b>Post-Factum bvba</b>
			        <BR/> Pastoriestraat 58, 3370 Boutersem Belgium Tel: +32 16 721047 -
			        <a href="mailto:info@post-factum.be">info@post-factum.be</a>
			        <%
	        	}
	         } %>
	        </center>
       </div>
    </div>
</body>
</html>