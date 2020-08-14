<%@include file="/includes/validateUser.jsp"%>

<%
	String sPage = checkString(request.getParameter("Page"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <%=sKHINFAVICON %>
  <%=sCSSNAV%>
</head>

<body>
<!-- Navigation / nav-wrapper component -->
<header class="nav-wrapper -sticky">
  <nav class="nav">
    <button class="toggle-nav" type="button">
      <div class="burger -squeeze" type="button">
        <span class="burger-lines"></span>
      </div>
    </button>
    <a class="logo-link" href="#">
      <img height='50px' id="logo" src="<%=MedwanQuery.getInstance().getConfigString("mpiMiniLogo","https://khin.rw/khin/projects/khin/_img/small.png") %>" alt="Logo">
    </a>
    <ul class="nav-list" role="navigation">
      <div class="list -left">
      	<%if(activeUser.getParameter("patientid").length()==0){ %>
        <li class="item">
          <a style='text-decoration: none;font-family: Raleway, Geneva, sans-serif;' class="link" href="mpiMain.jsp?Page=mpi/patients.jsp"><img height='24px' style='vertical-align: middle' src='<%=sCONTEXTPATH%>/_img/icons/mobile/patient.png'/> <%=getTranNoLink("web","patients",sWebLanguage) %></a>
        </li>
        <%} %>
        <li class="item" id='menu_pacs' style='display: <%=activeUser.getParameter("patientid").length()==0?"none":""%>'>
          <a style='text-decoration: none;font-family: Raleway, Geneva, sans-serif;' class="link" href="mpiMain.jsp?Page=mpi/pacs.jsp"><img height='32px' style='vertical-align: middle' src='<%=sCONTEXTPATH%>/_img/icons/mobile/xray.png'/> <%=getTranNoLink("web","PACS",sWebLanguage) %></a>
        </li>
        <li class="item"  style='display: <%=activeUser.getParameter("onetime").length()>0?"none":""%>'>
          <a style='text-decoration: none;font-family: Raleway, Geneva, sans-serif;' class="link" href="mpiMain.jsp?Page=mpi/<%=activeUser.getParameter("patientid").length()==0?"myprofile":"patientprofile"%>.jsp"><img height='24px' style='vertical-align: middle' src='<%=sCONTEXTPATH%>/_img/icons/mobile/badge.png'/> <%=getTranNoLink("web","myprofile",sWebLanguage) %></a>
        </li>
        <li class="item">
          <a style='text-decoration: none;font-family: Raleway, Geneva, sans-serif;' class="link" href="logout.jsp"><img height='24px' style='vertical-align: middle' src='<%=sCONTEXTPATH%>/_img/icons/mobile/logout.png'/> <%=getTranNoLink("web","logout",sWebLanguage) %></a>
        </li>
      </div>
      <div class="list -right">
        <div class="overlay"></div>
      </div>
    </ul>
  </nav>
</header>
<main>
<%
	if(sPage.length() > 0 && !sPage.equalsIgnoreCase("null")){
	    ScreenHelper.setIncludePage(customerInclude("/"+sPage),pageContext);
	} 
	else{
	    ScreenHelper.setIncludePage(customerInclude("/mpi/start.jsp"),pageContext);
	}
%>
</main>
<%=sJSNAV%>
<%=sJSDATE %>
<footer class="footer">
</footer>

<script>
dateFormat = "<%=ScreenHelper.stdDateFormat.toPattern()%>";

function openPopup(page,width,height,title,parameters){
    var url = "<c:url value='/popup.jsp'/>?Page="+page;
    if(width!=undefined){
    	url+= "&PopupWidth="+width;
    }
    else{
   		width=1;
    }
    if(height!=undefined){
    	url+= "&PopupHeight="+height;
    }
    else{
   		height=1;
    }
    if(!title){
      if(page.indexOf("&") < 0){
        title = page.replace("/","_");
        title = replaceAll(title,".","_");
      }
      else{
        title = replaceAll(page.substring(1,page.indexOf("&")),"/","_");
        title = replaceAll(title,".","_");
      }
    }
    if(!parameters || parameters.length==0){
    	parameters="toolbar=no,status=yes,scrollbars=yes,resizable=yes,width="+width+",height="+height+",menubar=no";
    }
    popup = window.open(url,title,parameters);
    if(width && height){
    	popup.resizeTo(width,height);
    }
    popup.moveBy(2000,2000);
    return popup;
  }
  
	<%-- REPLACE ALL --%>
	function replaceAll(s,s1,s2){
	  while(s.indexOf(s1) > -1){
	    s = s.replace(s1,s2);
	  }
	  return s;
	}

	document.onmousedown = function(e){
	    var n = !e?self.event.srcElement.name:e.target.name;

	    if(document.layers){
	      with(gfPop) var l = pageX, t = pageY, r = l+clip.width, b = t+clip.height;
	      if(n!="popcal" && (e.pageX > r || e.pageX < l || e.pageY > b || e.pageY < t)){
	        gfPop1.fHideCal();
	        gfPop2.fHideCal();
	        gfPop3.fHideCal();
	      }
	      return routeEvent(e);
	    }
	    else if(n!="popcal"){
	      gfPop1.fHideCal();
	      gfPop2.fHideCal();
	      gfPop3.fHideCal();
	    }
	}

</script>
<% String sDateType = MedwanQuery.getInstance().getConfigString("dateType","eu"); // eu/us %>

<iframe width=174 height=189 name="gToday:normal1_<%=sDateType%>:agenda.js:gfPop1" id="gToday:normal1_<%=sDateType%>:agenda.js:gfPop1"
  src="<c:url value='/_common/_script/ipopeng.htm'/>" scrolling="no" frameborder="0"
  style="visibility:visible; z-index:9999999999; position:absolute; top:-500px; left:-500px;">
</iframe>

<iframe width=174 height=189 name="gToday:normal2_<%=sDateType%>:agenda.js:gfPop2" id="gToday:normal2_<%=sDateType%>:agenda.js:gfPop2"
  src="<c:url value='/_common/_script/ipopeng.htm'/>" scrolling="no" frameborder="0"
  style="visibility:visible; z-index:9999999999; position:absolute; top:-500px; left:-500px;">
</iframe>

<iframe width=174 height=189 name="gToday:normal3_<%=sDateType%>:agenda.js:gfPop3" id="gToday:normal3_<%=sDateType%>:agenda.js:gfPop3"
  src="<c:url value='/_common/_script/ipopeng.htm'/>" scrolling="no" frameborder="0"
  style="visibility:visible; z-index:9999999999; position:absolute; top:-500px; left:-500px;">
</iframe>

</body>
</html>
