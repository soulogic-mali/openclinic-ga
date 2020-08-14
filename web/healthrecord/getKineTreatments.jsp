<%@include file="/includes/helper.jsp"%>
<%
	String sWebLanguage = request.getParameter("language");
%>
<table width='100%'>
	<tr class='admin'>
		<td width='50px'><img src='<%=sCONTEXTPATH %>/_img/icons/icon_new.png' onclick='addTreatmentLine()'/></td>
		<td width='15%'><%=getTran(request,"web","date",sWebLanguage) %></td>
		<td width='45%'><%=getTran(request,"cnrkr","acts",sWebLanguage) %></td>
		<td><%=getTran(request,"web","comment",sWebLanguage) %></td>
	</tr>
<%
	if(request.getParameter("treatments").length()>0){
		String[] treatments = request.getParameter("treatments").split("£");
		for(int n=0;n<treatments.length;n++){
			String acts="",comment="";
			for(int i=1;i<11;i++){
				if(treatments[n].split(";").length>i && acts.length()==0){
					String act = getTranNoLink("cnrkr.acts",treatments[n].split(";")[i],sWebLanguage);
					if(act.contains(":")){
						act=act.replace(":", "<b>")+"</b>";
					}
					acts+=act;
				}
				else if(treatments[n].split(";").length>i && treatments[n].split(";")[i].trim().length()>0){
					String act = getTranNoLink("cnrkr.acts",treatments[n].split(";")[i],sWebLanguage);
					if(act.contains(":")){
						act=act.replace(":", "<b>")+"</b>";
					}
					acts+=", "+act;
				}
			}
			if(treatments[n].split(";").length>11){
				comment=treatments[n].split(";")[11];
			}
			out.println("<tr>");
			out.println("<td class='admin2'><img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deleteTreatment("+n+")'><img src='"+sCONTEXTPATH+"/_img/icons/icon_edit.png' onclick='editTreatmentLine("+n+")'></td>");
			out.println("<td class='admin2'>"+treatments[n].split(";")[0]+"</td>");
			out.println("<td class='admin2'>"+acts+"</td>");
			out.println("<td class='admin2'>"+comment+"</td>");
			out.println("</tr>");
		}
	}
%>
