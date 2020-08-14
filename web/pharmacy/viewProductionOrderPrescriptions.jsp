<%@page import="be.openclinic.finance.*,be.dpms.medwan.common.model.vo.occupationalmedicine.*"%>
<%@page import="be.openclinic.pharmacy.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<table width="100%">
	<tr class='admin'>
		<td><%=getTran(request,"web","date",sWebLanguage) %></td>
		<td><%=getTran(request,"web","prescription",sWebLanguage) %></td>
		<td><%=getTran(request,"web","user",sWebLanguage) %></td>
	</tr>
	<%
		String examinationid = request.getParameter("examinationid");
		ExaminationVO examination = MedwanQuery.getInstance().getExamination(examinationid, sWebLanguage);
		Vector transactions = MedwanQuery.getInstance().getTransactionsByType(Integer.parseInt(activePatient.personid), examination.transactionType.split("\\&")[0]);
		for(int n=0;n<transactions.size();n++){
			TransactionVO transaction = (TransactionVO)transactions.elementAt(n);
			%>
				<tr>
					<td class='admin'><%=ScreenHelper.formatDate(transaction.getUpdateTime()) %></td>
					<td class='admin'><a href="javascript:openPrescription(<%=transaction.getServerId()%>,<%=transaction.getTransactionId()%>);"><%=getTran(request,"examination",examinationid,sWebLanguage) %></a></td>
					<td class='admin'><%=User.getFullUserName(""+transaction.getUser().userId) %></td>
				</tr>
			<%
		}
	%>
</table>

<script>
	function openPrescription(serverid,transactionid){
		 openPopup("/healthrecord/showPopupTransaction.jsp&be.mxs.healthrecord.transaction_id="+transactionid+"&be.mxs.healthrecord.server_id="+serverid+"&PopupHeight=600&PopupWidth=800&nobuttons=1");
	}
</script>