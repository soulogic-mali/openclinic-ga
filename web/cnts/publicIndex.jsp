<%@include file="/includes/validateUser.jsp"%>
<head>
  <%=sCSSNORMAL%>
  <%=sCSSMODALBOX%>
  <%=sJSTOGGLE%>
  <%=sJSFORM%>
  <%=sJSPOPUPMENU%>
  <%=sJSPROTOTYPE%>
  <%=sJSSCRPTACULOUS%>
  <%=sJSMODALBOX%>
  <%=sIcon%>
  <%=sJSSCRIPTS%>
  <%=sJSSTRINGFUNCTIONS%>
</head>
<%@page errorPage="/includes/error.jsp"%>
<%
	
%>
	<table width='100%'>
		<tr>
			<td style='text-align: left'><img height='70px' src="<c:url value="/"/><%=sAPPDIR%>_img/logo_cnts.gif" border="0"></td>
			<td style='text-align: right'>
				<img src="<c:url value="/"/>_img/logo_main.jpg" border="0">
				<img height='50px' src="<c:url value="/"/>_img/antim.jpg" border="0">			
				<img height='50px' src="<c:url value="/"/>_img/post-factum.png" border="0">			
				<img height='50px' src="<c:url value="/"/>_img/vub.png" border="0">			
			</td>
		</tr>
	</table>
    
    
	<hr/>
	<table width='100%'>
		<tr class='admin'>
			<td><%=getTran(request,"cnts","bloodbankoperations",sWebLanguage) %></td>
		</tr>
		<tr>
			<td><a href='javascript:validateDonorEligibility()'><%=getTran(request,"cnts","validatedonoreligibility",sWebLanguage) %></a></td>
		</tr>
		<tr>
			<td><a href='javascript:registerBloodCollection()'><%=getTran(request,"cnts","registerbloodcollection",sWebLanguage) %></a></td>
		</tr>
		<tr>
			<td><a href='javascript:registerBloodDelivery()'><%=getTran(request,"cnts","registerblooddelivery",sWebLanguage) %></a></td>
		</tr>
	</table>

<script>
	function registerBloodCollection(){
	    openPopup("/cnts/registerBloodProductCollection.jsp&ts=<%=getTs()%>&PopupHeight=400&PopupWidth=600");
	}
	
	function registerBloodDelivery(){
	    openPopup("/cnts/registerBloodProductDelivery.jsp&ts=<%=getTs()%>&PopupHeight=400&PopupWidth=600");
	}
	
	function validateDonorEligibility(){
	    openPopup("/cnts/validateDonorEligibility.jsp&ts=<%=getTs()%>&PopupHeight=400&PopupWidth=600");
	}
	
	
	function openPopup(page,width,height,title){
	   	var url = "<c:url value='/popup.jsp'/>?Page="+page;
	   	if(width!=undefined) url+= "&PopupWidth="+width;
	   	if(height!=undefined) url+= "&PopupHeight="+height;
	   	if(title==undefined){
		   	if(page.indexOf("&") < 0){
		       	title = page.replace("/","_");
		       	title = replaceAll(title,".","_");
		    }
		    else{
		       title = replaceAll(page.substring(1,page.indexOf("&")),"/","_");
		       title = replaceAll(title,".","_");
		    }
	 	}
	   	var w = window.open(url,title,"toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=1,height=1,menubar=no");
	   	w.moveBy(2000,2000);
	 }

	  <%-- REPLACE ALL --%>
	 function replaceAll(s,s1,s2){
	 	while(s.indexOf(s1) > -1){
	    	s = s.replace(s1,s2);
	    }
	    return s;
	 }

</script>