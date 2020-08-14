<%@include file="/includes/helper.jsp"%>

<%
    String sTmpAPPDIR   = ScreenHelper.checkString(ScreenHelper.getCookie("activeProjectDir", request)),
           sTmpAPPTITLE = ScreenHelper.checkString(ScreenHelper.getCookie("activeProjectTitle", request));
    if(sTmpAPPTITLE==null) sTmpAPPTITLE = "OpenClinic";
	if(MedwanQuery.getInstance().getConfigString("edition","openclinic").equalsIgnoreCase("mpi")){
		out.println("<script>window.location.href='"+sCONTEXTPATH+"/mpiLogin.jsp';</script>");
		out.flush();
	}
%>
    
<html>
<head>
    <META HTTP-EQUIV="Refresh" CONTENT="3600;url=<%=sCONTEXTPATH%>/<%=sTmpAPPDIR%>">
    <%=sCSSNORMAL%>
    <%=sJSCOOKIE%>
    <%=sJSDROPDOWNMENU%>
    <%=sIcon%>
    
	<script>
		(function(a,b){if(/android|avantgo|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|e\-|e\/|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|xda(\-|2|g)|yas\-|your|zeto|zte\-/i.test(a.substr(0,4)))window.location=b})(navigator.userAgent||navigator.vendor||window.opera,'html5/login.jsp');
	</script>
    <script>
      if(window.history.forward(1)!=null){
        window.history.forward(1);
      }
    
      function escBackSpace(){
        if(window.event && enterEvent(event,8)){
          window.event.keyCode = 123; // F12
        }
      }
      
      function goToLogin(){
        window.location.href = "<%=sCONTEXTPATH%>/<%=sTmpAPPDIR%>";
      }
    </script>
    
    <title><%=sWEBTITLE+" "+sTmpAPPTITLE%></title>
</head>

<body class="Geenscroll login" onkeydown="escBackSpace();if(enterEvent(event,13)){goToLogin();}">
	<%
		if(request.getRequestURL().toString().indexOf("globalhealthbarometer")>-1){
			out.print("<script>window.location.href='http://www.globalhealthbarometer.net';</script>");
		}
	
		if("openinsurance".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("edition",""))) {
			%><div id="loginopeninsurance" class="withoutfields"><%
		}
		else{
			%><div id="login" class="withoutfields"><%
		}
	%>	

    <div id="logo">
        <%
           if("datacenter".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("edition",""))){
               session.setAttribute("edition","datacenter");
               %><img src="projects/datacenter/_img/logo.jpg" border="0"><%
           }
           else if("openlab".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("edition",""))){
               session.setAttribute("edition", "openlab");
               %><img src="projects/openlab/_img/logo.jpg" border="0"><%
           }
           else if("openpharmacy".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("edition",""))){
               session.setAttribute("edition", "openlab");
               %><img src="_img/openpharmacy_logo.jpg" border="0"><%
           }
           else if("openinsurance".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("edition",""))){
               session.setAttribute("edition", "openinsurance");
               %><img src="_img/openinsurancelogo.jpg" border="0"><%
           }
           else if ("bloodbank".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("edition",""))) {
               session.setAttribute("edition", "bloodbank");
           	   %><img src="_img/logo_bloodbank.jpg" border="0"><%
           }
           else if ("gmao".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("edition",""))) {
               session.setAttribute("edition", "gmao");
           	   %><img src="_img/logo_gmao.jpg" border="0"><%
           }
           else{
               session.setAttribute("edition", "openclinic");
               %><img src="_img/logo.jpg" border="0"><%
           }
        %>
    </div>
    
    <div id="version">&nbsp;</div>
    
    <div id="fields">
        <table>
            <tr>
                <td>
                    <br><br> <b>Session expired</b> <br>
                </td>
            </tr>
            <tr>
                <td>
                    <br> Your session expired.<br>Please relogin
                    <a href="<%=sCONTEXTPATH%>/<%=sTmpAPPDIR%>" onMouseOver="window.status='';return true;">here</a>.
                </td>
            </tr>
        </table>
    </div>
    <div id="messages" class="messagesnofields">
        <%=MedwanQuery.getInstance().getConfigString("openclinicedition", "GA Open Source Edition") %> by:
        <% if (MedwanQuery.getInstance().getConfigString("mxsref", "rw").equalsIgnoreCase("rw")) { %>
	        <img src="_img/flags/rwandaflag.jpg" height="15px" width="30px" alt="Rwanda"/>
	        <a href="http://mxs.rwandamed.org" target="_new"><b>The Open-IT Group Ltd</b></a>
	        <BR/> PO Box 3242 - Kigali Rwanda Tel +250 07884 32 435 -
	        <a href="mailto:mxs@rwandamed.org">mxs@rwandamed.org</a>
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
        } else if (MedwanQuery.getInstance().getConfigString("mxsref", "rw").equalsIgnoreCase("ml")) { %>
	        <img src="_img/flags/maliflag.jpg" height="15px" width="30px" alt="Mali"/>
	        <a href="http://www.sante.gov.ml/" target="_new"><b>ANTIM</b></a> et <a href="http://www.post-factum.be" target="_new"><b>Post-Factum bvba</b></a>
	        <BR/> Hamdalaye ACI 2000, Rue 340, Porte 541, Bamako - Mali<br/>
	        <a href="mailto:info@openit-burundi.net">ousmanely@sante.gov.ml</a>
        <% } else {         	
        		%>
		        <img src="_img/flags/pf.gif" height="16px" width="20px" alt="Post-Factum"/>
		        <b>Post-Factum bvba</b>
		        <BR/> Pastoriestraat 58, 3370 Boutersem Belgium -
		        <a href="mailto:info@post-factum.be">info@post-factum.be</a>
		        <%
		 } %>
    </div>
</div>
</body>
</html>