<%@include file="/includes/helper.jsp"%>
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
<%=sJSPROTOTYPE %>
<title><%=getTran(request,"web","setdate","fr") %></title>
<html>
	<body>
		<form name='transactionForm' method='post'>
			<%if(new java.util.Date().before(new SimpleDateFormat("dd/MM/yyyy").parse(be.openclinic.system.SH.cs("minimumSystemDate","01/01/2021")))){ %>
			<center style='font-size: 5vw;text-align:center;padding=10px;font-family: Raleway, Geneva, sans-serif;'><%=getTranNoLink("web","wrongdate","fr") %></center>
			<%} %>
			<br/>
			<table width='100%'>
				<tr>
					<td width='30%' style='font-size: 5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<%=getTranNoLink("web","date","fr") %>:&nbsp;
					</td>
					<td width='70%' style='font-size: 5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<input style='padding:5px; font-size: 5vw;border: 1px solid #cccccc;background-color: #ffffe6' type='date' name='date' id='date' value='<%=new SimpleDateFormat("yyyy-dd-MM").format(new java.util.Date()) %>' size='10'/>
					</td>
				</tr>
				<tr>
					<td width='30%' style='font-size: 5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<%=getTranNoLink("web","hour","fr") %>:&nbsp;
					</td>
					<td width='70%' style='font-size: 5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<select style='padding:5px; font-size: 5vw;border: 1px solid #cccccc;background-color: #ffffe6' name='hour' id='hour'>
						<%
							for(int n=0;n<24;n++){
								out.println("<option style='padding:5px; font-size: 5vw;' "+(new SimpleDateFormat("HH").format(new java.util.Date()).equalsIgnoreCase(SH.padLeft(n+"", "0", 2))?"selected":"")+">"+SH.padLeft(n+"", "0", 2)+"</option>");
							}
						%>
						</select> :
						<select style='padding:5px; font-size: 5vw;border: 1px solid #cccccc;background-color: #ffffe6' name='minutes' id='minutes'>
						<%
							for(int n=0;n<60;n++){
								out.println("<option style='padding:5px; font-size: 5vw;' "+(new SimpleDateFormat("mm").format(new java.util.Date()).equalsIgnoreCase(SH.padLeft(n+"", "0", 2))?"selected":"")+">"+SH.padLeft(n+"", "0", 2)+"</option>");
							}
						%>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan='2' style='font-size: 5vw;text-align:center;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<br/><input style='font-size: 5vw;height: 8vw;padding=10px;font-family: Raleway, Geneva, sans-serif;' type='button' onclick='setDate();' name='setDateButton' value='<%=getTran(request,"web","update","fr") %>'/>
						<br/><br/><div id='ajaxloader' style='display:none;text-align:center;'><img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/></div>
					</td>
				</tr>
			</table>
		</form>
		
		<script>
			function setDate(){
			     var params = "date="+document.getElementById('date').value+
                 "&hour="+document.getElementById('hour').value+
                 "&minutes="+document.getElementById('minutes').value;
			     var url = '<c:url value="/system/setDate.jsp"/>?ts='+new Date().getTime();
			     new Ajax.Request(url,{
			       method: "POST",
			       parameters: params,
			       onSuccess: function(resp){
  					 	document.getElementById('ajaxloader').style.display='';
			         	checkDate();
			       }
			     });
			}
			
			function checkDate(){
			     var url = '<c:url value="/system/checkDate.jsp"/>?ts='+new Date().getTime();
			     new Ajax.Request(url,{
			       method: "POST",
			       parameters: "",
			       onSuccess: function(resp){
			    	   if(resp.responseText.indexOf('<OK>')>-1){
				         	window.parent.location.href='login.jsp';
			    	   }
			    	   else{
			    		   window.setTimeout("checkDate();",5000);
			    	   }
			       }
			     });
			}
			window.parent.parent.scrollTo(0,0);
		</script>
	</body>
</html>
