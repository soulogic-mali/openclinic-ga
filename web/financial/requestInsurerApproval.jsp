<%@ page import="be.openclinic.finance.*,be.openclinic.adt.Encounter,java.text.*,be.mxs.common.util.system.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sInsurerType = request.getParameter("insurertype");

	if(request.getParameter("requestButton")!=null){
		//Send a request for approval
		String mailserver = MedwanQuery.getInstance().getConfigString("PatientEdit.MailServer");
		String sender = MedwanQuery.getInstance().getConfigString("SA.MailAddress");
		if(activeUser.person.getActivePrivate()!=null && checkString(activeUser.person.getActivePrivate().email).length()>0){
			sender=activeUser.person.getActivePrivate().email;
		}
		String destination = MedwanQuery.getInstance().getConfigString("insurarApprovalEmailAddress");
		String title=getTranNoLink("web","insurerapprovalrequest",sWebLanguage);
		String content = getTranNoLink("web","approvalrequest",sWebLanguage);
		Insurar insurer = Insurar.get(request.getParameter("insurer"));
		if(insurer!=null){
			content=content.replaceAll("#patientid#",activePatient.personid);
			content=content.replaceAll("#patientname#",activePatient.getFullName());
			content=content.replaceAll("#username#",activeUser.person.getFullName());
			content=content.replaceAll("#insurerid#",insurer.getUid());
			content=content.replaceAll("#insurername#",insurer.getName());
			content=content.replaceAll("#reason#",getTranNoLink("insurerapprovalreason",request.getParameter("reason"),sWebLanguage));
			if(sInsurerType.equalsIgnoreCase("patientsharecoverageinsurance")){
				content=content.replaceAll("#insurertype#",getTranNoLink("web","complementarycoverage",sWebLanguage));
			}
			else{
				content=content.replaceAll("#insurertype#",getTranNoLink("web","complementarycoverage2",sWebLanguage));
			}
			try{
				Mail.sendMail(mailserver, 
						sender, 
						destination, 
						title, 
						content,
						new Vector());
				//Successful, show message
				%>
					<script>
						alert('<%=getTranNoLink("web","requestsuccessfullysent",sWebLanguage)%>');
						window.close();
					</script>
				<%
				out.flush();
			}
			catch(Exception e){}
		}		
		%>
		<script>
			alert('<%=getTranNoLink("web","errorsendingrequest",sWebLanguage)%>');
			window.close();
		</script>
		<%
		out.flush();
	}

%>

<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web","requestapproval",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","insurar",sWebLanguage) %></td>
			<td class='admin2'>
                <select class="text" name="insurer" id="insurer">
					<%
						Hashtable extrainsurars = (Hashtable)((Hashtable)MedwanQuery.getInstance().getLabels().get(sWebLanguage.toLowerCase())).get(sInsurerType);
						Enumeration eExtrainsurars = extrainsurars.keys();
						while(eExtrainsurars.hasMoreElements()){
							String key = (String)eExtrainsurars.nextElement();
							//Check if the insurer needs approval
							Insurar insr = Insurar.get(key);
							if(insr!=null && insr.getNeedsApproval()==1){
								out.println("<option value='"+key+"'>"+getTran(request,sInsurerType,key,sWebLanguage)+"</option>");								
							}
						}
					%>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","reason",sWebLanguage) %></td>
			<td class='admin2'>
                <select class="text" name="reason" id="reason">
                	<%=ScreenHelper.writeSelect(request,"insurerapprovalreason","",sWebLanguage) %>
                </select>
		</tr>
	</table>
	<input type='submit' class='button' name='requestButton' value='<%=getTranNoLink("web","send",sWebLanguage)%>'%>
</form>