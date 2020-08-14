<!DOCTYPE html>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="refresh" content="10" >
<head>
	<link rel="apple-touch-icon" sizes="180x180" href="/openclinic/apple-touch-icon.png">
	<link rel="icon" type="image/png" sizes="32x32" href="/openclinic/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="16x16" href="/openclinic/favicon-16x16.png">
	<link rel="manifest" href="/openclinic/site.webmanifest">
	<link rel="mask-icon" href="/openclinic/safari-pinned-tab.svg" color="#5bbad5">
	<meta name="msapplication-TileColor" content="#da532c">
	<meta name="theme-color" content="#ffffff">
	<script>
	window.onload = function() {
	  var context = new AudioContext();
	}
	</script>
</head>
<%@include file="/includes/validateUser.jsp"%>
<%=sCSSNORMAL %>
<title><%=getTran(request,"web","activetriage",sWebLanguage) %></title>
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
				<td colspan='2' class='mobileadmin' style='font-size:8vw;'><%=getTran(request,"web","activetriage",sWebLanguage) %></td>
			</tr>
			<%
			boolean bBeep=false;
				long minute=60*1000;
				long hour=60*minute;
				long day=24*hour;
				Vector transactions = MedwanQuery.getInstance().getTransactionsByTypeBetween("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_PEDIATRIC_TRIAGE", new java.util.Date(new java.util.Date().getTime()-7*day), new java.util.Date());
				for(int n=0;n<transactions.size();n++){
					TransactionVO transaction = (TransactionVO)transactions.elementAt(n);
					if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_CLOSED").equalsIgnoreCase("medwan.common.true")){
						continue;
					}
					Encounter encounter = transaction.getEncounter();
					if(encounter==null){
						continue;
					}
					else if(encounter.getEnd()!=null && encounter.getEnd().before(new java.util.Date())){
						continue;
					}
					try{
						java.util.Date start = new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(new SimpleDateFormat("dd/MM/yyyy").format(transaction.getUpdateDateTime())+" "+transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HOUR")+":"+transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MINUTES"));
						java.util.Date last = start;
						TransactionVO lastVitalSigns = MedwanQuery.getInstance().getLastModifiedTransactionByType(MedwanQuery.getInstance().getPersonIdFromHealthrecordId(transaction.getHealthrecordId()), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_VITALSIGNS");
						if(lastVitalSigns!=null && lastVitalSigns.getCreationDate().after(start)){
							last=lastVitalSigns.getCreationDate();
						}
						String theclass="mobileadmin2";
						try{
							if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PRIORITY").equalsIgnoreCase("1")){
								theclass="mobileadmin2red";
							}
							else if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PRIORITY").equalsIgnoreCase("2") && new java.util.Date().getTime()-last.getTime()>15*minute){
								theclass="mobileadmin2red";
								bBeep=true;
							}
							else if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PRIORITY").equalsIgnoreCase("3") && new java.util.Date().getTime()-last.getTime()>30*minute){
								theclass="mobileadmin2red";
								bBeep=true;
							}
							else if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PRIORITY").equalsIgnoreCase("4") && new java.util.Date().getTime()-last.getTime()>60*minute){
								theclass="mobileadmin2red";
								bBeep=true;
							}
							else if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PRIORITY").equalsIgnoreCase("5") && new java.util.Date().getTime()-last.getTime()>120*minute){
								theclass="mobileadmin2red";
								bBeep=true;
							}
						}
						catch(Exception e){
							e.printStackTrace();
						}
						if(start.after(new java.util.Date(new java.util.Date().getTime()-36*hour))){
							AdminPerson patient = AdminPerson.getAdminPerson(""+MedwanQuery.getInstance().getPersonIdFromHealthrecordId(transaction.getHealthrecordId()));
							//This is an active triage record
							out.println("<tr>");
							out.println("<td class='"+theclass+"' style='font-size:6vw;'><a style='"+(theclass.equalsIgnoreCase("mobileadmin2red")?"color: white;":"")+"font-size:6vw;' href='"+sCONTEXTPATH+"/html5/getVitalSignsTriage.jsp?patientuid="+patient.personid+"&transactionid="+transaction.getTransactionId()+"&serverid="+transaction.getServerId()+"'>"+patient.getFullName()+"</a> ["+getTran(request,"web","priority",sWebLanguage)+" "+transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PRIORITY")+"]</td>");
							out.println("<td class='"+theclass+"' style='font-size:4vw;'>"+((new java.util.Date().getTime()-last.getTime())/hour)+"h "+(((new java.util.Date().getTime()-last.getTime())%hour)/minute)+"m</td>");
							out.println("</tr>");
						}
					}
					catch(Exception e){
						e.printStackTrace();
					}
				}
			%>
		</table>
		<%if(bBeep){ %>
			<audio style='visibility: hidden' controls id='mybeep' autoplay>
				<source src="<%=sCONTEXTPATH %>/_sound/beep.mp3" type="audio/mpeg">
			</audio>
		<%} %>
	</body>
</html>