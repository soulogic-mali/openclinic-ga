<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%
	if(request.getParameter("submitButton")!=null){
		Enumeration pars = request.getParameterNames();
		while(pars.hasMoreElements()){
			String parname = (String)pars.nextElement();
			if(parname.startsWith("cp_")){
				MedwanQuery.getInstance().setConfigString(parname.substring(3),request.getParameter(parname));
			}
		}
		if(checkString(request.getParameter("newqueue")).length()>0){
			MedwanQuery.getInstance().updateLabel("queue", "Q_"+MedwanQuery.getInstance().getOpenclinicCounter("QUEUE"), sWebLanguage, request.getParameter("newqueue"));
		}
	}
	if(checkString(request.getParameter("deleteQueue")).length()>0){
		Label.delete("queue", request.getParameter("deleteQueue"));
	}
%>
<form name="transactionForm" method="post">
	<table width='100%'>
		<tr class='admin'><td colspan='2'><%=getTran(request,"web","managequeues",sWebLanguage) %></td></tr>
		<%
			Vector queues = Label.getLabelsExact("queue", "", "", sWebLanguage, "OC_LABEL_VALUE");
			for(int n=0;n<queues.size();n++){
				Label label = (Label)queues.elementAt(n);
				out.println("<tr>");
				out.println("<td class='admin'><img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deleteQueueFunction(\""+label.id+"\");'/> "+label.value+"</td>");
				out.println("<td class='admin2'><table width='100%'><tr>");
				out.println("<td>"+getTran(request,"web","maxpatients",sWebLanguage)+": <input type='text' size='5' class='text' name='cp_queueLimit."+label.id+"' value='"+MedwanQuery.getInstance().getConfigString("queueLimit."+label.id,"")+"'/></td>");
				out.println("<td>"+getTran(request,"web","requiresactiveencounter",sWebLanguage)+" <input type='radio' class='text' name='cp_queueActiveEncounter."+label.id+"' value='1' "+(MedwanQuery.getInstance().getConfigInt("queueActiveEncounter."+label.id,0)==1?"checked":"")+"/>"+getTran(request,"web","yes",sWebLanguage)+" <input type='radio' class='text' name='cp_queueActiveEncounter."+label.id+"' value='0' "+(MedwanQuery.getInstance().getConfigInt("queueActiveEncounter."+label.id,0)==0?"checked":"")+"/>"+getTran(request,"web","no",sWebLanguage)+"</td>");
				out.println("</tr></table></td>");
				out.println("</tr>");
			}
		%>
		<tr>
			<td class='admin'><%=getTran(request,"web","newqueue",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' size='60' name='newqueue'/></td>
		</tr>
	</table>
	<center><input type='submit' class='button' name='submitButton' value='<%=getTran(request,"web","save",sWebLanguage) %>'/></center>
	<input type='hidden' name='deleteQueue' id='deleteQueue'/>
</form>

<script>
	function deleteQueueFunction(id){
		if(window.confirm("<%=getTranNoLink("web","areyousure",sWebLanguage)%>")){
			document.getElementById('deleteQueue').value=id;
			transactionForm.submit();
		}
	}
</script>