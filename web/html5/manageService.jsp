<%@page import="com.google.zxing.common.StringUtils"%>
<%@page import="ca.uhn.hl7v2.util.StringUtil"%>
<%@include file="/includes/validateUser.jsp"%>
<!DOCTYPE html>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<head>
	<link rel="apple-touch-icon" sizes="180x180" href="/openclinic/apple-touch-icon.png">
	<link rel="icon" type="image/png" sizes="32x32" href="/openclinic/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="16x16" href="/openclinic/favicon-16x16.png">
	<link rel="manifest" href="/openclinic/site.webmanifest">
	<link rel="mask-icon" href="/openclinic/safari-pinned-tab.svg" color="#5bbad5">
	<meta name="msapplication-TileColor" content="#da532c">
	<meta name="theme-color" content="#ffffff">
</head>
<%=sCSSNORMAL %>
<html>
	<body onresize='window.parent.document.getElementById("ocframe").style.height=screen.height;'>
		<div>
			<form name='transactionForm' method='post'>
				<input type='hidden' name='searchService' id='searchService' value='<%=SH.p(request,"searchService")%>'/>
				<input type='hidden' name='action' id='action' value=''/>
				<table width='100%'>
					<%
						String activeService = SH.p(request,"searchService");
						if(SH.p(request,"action").equals("save")){
							session.setAttribute("activeService", activeService);
							out.println("<script>window.location.href='welcomegmao.jsp';</script>");
							out.flush();
						}
						if(activeService.length()==0){
							activeService=SH.c((String)session.getAttribute("activeService"));
						}
					%>
					<tr>
						<td style='font-size:4vw;text-align: left' nowrap>
							<%=SH.c((String)session.getAttribute("activeService")).toUpperCase() %><br/>
							<b style='font-size:4vw;text-align: left'><%=getTranNoLink("service",SH.c((String)session.getAttribute("activeService")),sWebLanguage) %></b>
						</td>
						<td style='font-size:8vw;text-align: right' nowrap>
							<img onclick="window.location.href='welcomegmao.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
						</td>
					</tr>
				</table>
				<table width='100%'>
					<tr>
						<td colspan='2' class='mobileadmin' style='font-size:6vw;'>
							<%
								out.println(getTranNoLink("web","healthstructure",sWebLanguage));
								if(SH.p(request,"searchService").length()>0 && !SH.p(request,"searchService").equalsIgnoreCase(SH.c((String)session.getAttribute("activeService"))) && Service.getService(SH.p(request,"searchService")).isAuthorizedUser(activeUser.userid)){
							%>
								<img onclick='save();' style='max-width:10%;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/save.png'/>
							<%	
								}
							%>	
						</td>
					</tr>
					<%
						//First show all parents
						Vector parents = Service.getParentIds(activeService);
						for(int n=0;n<parents.size();n++){
							String parentCode = (String)parents.elementAt(n);
							out.println("<tr><td class='mobileadmin2' style='font-size:3vw;text-align: left;width: 1%' nowrap>"+(n==0?parentCode:org.apache.commons.lang3.StringUtils.repeat("&nbsp;",n)+"."+parentCode.split("\\.")[parentCode.split("\\.").length-1].toUpperCase())+"</td><td class='mobileadmin2'><a style='font-weight: bold;font-size:4vw;text-align: left' href='javascript:selectService(\""+parentCode+"\")'>"+getTranNoLink("service",parentCode,sWebLanguage).toUpperCase()+"</a></td></tr>");
						}
						//Then show the active service
						out.println("<tr><td class='mobileadmin' style='font-size:3vw;text-align: left;width: 1%' nowrap>"+org.apache.commons.lang3.StringUtils.repeat("&nbsp;",parents.size())+"."+activeService.split("\\.")[activeService.split("\\.").length-1].toUpperCase()+"</td><td class='mobileadmin' style='font-weight: bold;font-size:4vw;text-align: left'>"+getTranNoLink("service",activeService,sWebLanguage).toUpperCase()+"</td></tr>");
						//Then show the children
						Vector children = Service.getServiceIDsByParentID(activeService);
						SortedMap sortedChildren = new TreeMap();
						for(int n=0;n<children.size();n++){
							String childCode=(String)children.elementAt(n);
							sortedChildren.put(getTranNoLink("service",childCode,sWebLanguage).toUpperCase()+"."+children.elementAt(n),children.elementAt(n));
						}
						Iterator i = sortedChildren.keySet().iterator();
						while(i.hasNext()){
							String key = (String)i.next();
							String childCode=(String)sortedChildren.get(key);
							out.println("<tr><td class='mobileadmin2' style='font-size:3vw;text-align: left;width: 1%' nowrap>"+org.apache.commons.lang3.StringUtils.repeat("&nbsp;",parents.size()+1)+"."+childCode.split("\\.")[childCode.split("\\.").length-1].toUpperCase()+"</td><td class='mobileadmin2'><a style='font-weight: bold;font-size:4vw;text-align: left' href='javascript:selectService(\""+childCode+"\")'>"+getTranNoLink("service",childCode,sWebLanguage).toUpperCase()+"</a></td></tr>");
						}
					%>
				</table>
			</form>
		</div>
		<script>
			function selectService(uid){
				document.getElementById("searchService").value=uid;
				transactionForm.submit();
			}
			function save(){
				document.getElementById("action").value='save';
				transactionForm.submit();
			}
		</script>
		<script>
			window.parent.parent.scrollTo(0,0);
		</script>
	</body>
</html>