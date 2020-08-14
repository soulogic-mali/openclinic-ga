<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<table width='100%'>
	<tr class='admin'>
		<td colspan='6'>
			<%=getTran(request,"web","activedeliveries",sWebLanguage) %>
		</td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","entrydate",sWebLanguage) %></td>
		<td class='admin'><%=getTran(request,"web","patientid",sWebLanguage) %></td>
		<td class='admin'><%=getTran(request,"web","patient",sWebLanguage) %></td>
		<td class='admin'><%=getTran(request,"web","age",sWebLanguage) %></td>
		<td class='admin'><%=getTran(request,"web","beginlabor",sWebLanguage) %></td>
		<td class='admin'><%=getTran(request,"web","durationlabor",sWebLanguage) %></td>
	</tr>
<%
	long minute=60*1000;
	long hour=60*minute;
	long day=24*hour;
	Vector transactions = MedwanQuery.getInstance().getTransactionsByTypeBetween("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_DELIVERY_MSPLS", new java.util.Date(new java.util.Date().getTime()-7*day), new java.util.Date());
	for(int n=0;n<transactions.size();n++){
		TransactionVO transaction = (TransactionVO)transactions.elementAt(n);
		//First check if labor is not finished yet
		if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_DATE").length()>0){
			continue;
		}
		if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_DATE2").length()>0){
			continue;
		}
		if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_GENDER").length()>0){
			continue;
		}
		if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_GENDER2").length()>0){
			continue;
		}
		String labourbeginhour="0";
		String labourbeginminutes="0";
		String labourbegindate = transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DELIVERYDATE");
		if(labourbegindate.length()>0){
			String[] time = transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_STARTHOUR").split(":");
			if(time.length>1){
				labourbeginhour = time[0];
				labourbeginminutes = time[1];
			}
		}
		java.util.Date labourstart = new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(labourbegindate+" "+labourbeginhour+":"+labourbeginminutes);
		if(labourstart.after(new java.util.Date(new java.util.Date().getTime()-day))){
			AdminPerson patient = AdminPerson.getAdminPerson(""+MedwanQuery.getInstance().getPersonIdFromHealthrecordId(transaction.getHealthrecordId()));
			//This is an active delivery record
			out.println("<tr>");
			out.println("<td>"+ScreenHelper.formatDate(transaction.getUpdateTime())+"</td>");
			out.println("<td><a href='"+sCONTEXTPATH+"/nursing/openDelivery.jsp?patientuid="+patient.personid+"&transactionid="+transaction.getTransactionId()+"&serverid="+transaction.getServerId()+"'>"+patient.personid+"</a></td>");
			out.println("<td>"+patient.getFullName()+"</td>");
			out.println("<td>"+patient.getAge()+"</td>");
			out.println("<td>"+ScreenHelper.formatDate(labourstart)+" <b>"+labourbeginhour+":"+labourbeginminutes+"</b></td>");
			out.println("<td><b>"+((new java.util.Date().getTime()-labourstart.getTime())/hour)+"h "+(((new java.util.Date().getTime()-labourstart.getTime())%hour)/minute)+"m</b></td>");
			out.println("</tr>");
		}
	}
%>
</table>