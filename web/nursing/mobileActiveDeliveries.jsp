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
<%@include file="/includes/validateUser.jsp"%>
<%=sCSSNORMAL %>
<title><%=getTran(request,"web","activedeliveries",sWebLanguage) %></title>
<html>
	<body>
		<table width='100%'>
			<tr>
				<td colspan='2' style='font-size:8vw;text-align: right'>
					<img onclick="window.location.reload()" src='<%=sCONTEXTPATH%>/_img/icons/mobile/refresh.png'/>
					<img onclick="window.location.href='../html5/welcome.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
				</td>
			</tr>
			<tr>
				<td colspan='2' class='mobileadmin' style='font-size:8vw;'><%=getTran(request,"web","activedeliveries",sWebLanguage) %></td>
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
					String labourbeginhour="00";
					String labourbeginminutes="00";
					String labourbegindate = transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DELIVERYDATE");
					if(labourbegindate.length()>0){
						String[] time = transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_STARTHOUR").split(":");
						if(time.length>1){
							labourbeginhour = time[0];
							labourbeginminutes = time[1];
						}
						java.util.Date labourstart = new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(labourbegindate+" "+labourbeginhour+":"+labourbeginminutes);
						if(labourstart.after(new java.util.Date(new java.util.Date().getTime()-13*hour))){
							AdminPerson patient = AdminPerson.getAdminPerson(""+MedwanQuery.getInstance().getPersonIdFromHealthrecordId(transaction.getHealthrecordId()));
							//This is an active delivery record
							out.println("<tr>");
							out.println("<td class='mobileadmin2' style='font-size:6vw;'><a style='font-size:6vw;' href='"+sCONTEXTPATH+"/nursing/mobileMeasurements.jsp?patientuid="+patient.personid+"&transactionid="+transaction.getTransactionId()+"&serverid="+transaction.getServerId()+"'>"+patient.getFullName()+"</a></td>");
							out.println("<td class='mobileadmin2' style='font-size:4vw;'>"+((new java.util.Date().getTime()-labourstart.getTime())/hour)+"h "+(((new java.util.Date().getTime()-labourstart.getTime())%hour)/minute)+"m</td>");
							out.println("</tr>");
						}
					}
				}
			%>
		</table>
	</body>
</html>