<%@page import="be.dpms.medwan.common.model.vo.administration.PersonVO"%>

<!DOCTYPE html>
<head>
	<link rel="apple-touch-icon" sizes="180x180" href="/openclinic/apple-touch-icon.png">
	<link rel="icon" type="image/png" sizes="32x32" href="/openclinic/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="16x16" href="/openclinic/favicon-16x16.png">
	<link rel="manifest" href="/openclinic/site.webmanifest">
	<link rel="mask-icon" href="/openclinic/safari-pinned-tab.svg" color="#5bbad5">
	<meta name="msapplication-TileColor" content="#da532c">
	<meta name="theme-color" content="#ffffff">
</head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%@include file="/includes/validateUser.jsp"%>
<%
	int patientuid = Integer.parseInt(request.getParameter("patientuid"));
	activePatient = AdminPerson.getAdminPerson(patientuid+"");
	session.setAttribute("activePatient",activePatient);
    if(activeUser==null || activePatient==null){
        out.println("<script>window.location.href='/html5/login.jsp';</script>");
        out.flush();
    }
    else{
%>
<%=sCSSNORMAL %>
<%!
	void append(HttpServletRequest request,TransactionVO transaction,String itemType,String itemValue,long datetime){
		ItemVO item = transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+itemType);
		if(item==null){
			try{
			    SessionContainerWO sessionContainerWO = (SessionContainerWO) SessionContainerFactory.getInstance().getSessionContainerWO(request, SessionContainerWO.class.getName());
	            item = new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier())
	            , "be.mxs.common.model.vo.healthrecord.IConstants."+itemType
	            ,sessionContainerWO.getPersonVO().personId.intValue()+""
	            ,new java.util.Date(datetime)
	            ,new be.mxs.common.model.vo.healthrecord.ItemContextVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", ""));
	        	item.setValue("");
	            transaction.getItems().add(item);
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		item.setValue(item.getValue()+"|"+datetime+";"+itemValue);
		String[] values = item.getValue().split("\\|");
		SortedMap sValues = new TreeMap();
		for(int n=0;n<values.length;n++){
			if(values[n].split(";").length>1){
				sValues.put(Long.parseLong(values[n].split(";")[0]),values[n]);
			}
		}
		item.setValue("");
		Iterator iValues = sValues.values().iterator();
		while(iValues.hasNext()){
			item.setValue(item.getValue()+"|"+(String)iValues.next());
		}
	}
%>
<%
	int transactionid = Integer.parseInt(request.getParameter("transactionid"));
	int serverid = Integer.parseInt(request.getParameter("serverid"));
    PersonVO person = MedwanQuery.getInstance().getPerson(patientuid + "");
	if(checkString(request.getParameter("formaction")).equalsIgnoreCase("save")){
	    SessionContainerWO sessionContainerWO = (SessionContainerWO) SessionContainerFactory.getInstance().getSessionContainerWO(request, SessionContainerWO.class.getName());
	    sessionContainerWO.setPersonVO(person);
		long datetime = Long.parseLong(request.getParameter("datetime"));
		//First retrieve transaction
		TransactionVO transaction = MedwanQuery.getInstance().loadTransactionNoCache(serverid, transactionid);
		String v=checkString(request.getParameter("foetalheartrate"));
		if(v.length()>0){
			append(request,transaction,"ITEM_TYPE_DELIVERY_PARTOGRAMME_FHR",v,datetime);
		}
		v=checkString(request.getParameter("dilatation"));
		if(v.length()>0){
			append(request,transaction,"ITEM_TYPE_DELIVERY_PARTOGRAMME_DIL",v,datetime);
		}
		v=checkString(request.getParameter("engagement"));
		if(v.length()>0){
			append(request,transaction,"ITEM_TYPE_DELIVERY_PARTOGRAMME_ENG",v,datetime);
		}
		v=checkString(request.getParameter("contractions"));
		if(v.length()>0){
			if(checkString(request.getParameter("duration")).length()>0){
				v+=";"+request.getParameter("duration");
			}
			append(request,transaction,"ITEM_TYPE_DELIVERY_PARTOGRAMME_CONTR",v,datetime);
		}
		v=checkString(request.getParameter("oxytocin"));
		if(v.length()>0){
			append(request,transaction,"ITEM_TYPE_DELIVERY_PARTOGRAMME_OXY",v,datetime);
		}
		v=checkString(request.getParameter("drops"));
		if(v.length()>0){
			append(request,transaction,"ITEM_TYPE_DELIVERY_PARTOGRAMME_DROP",v,datetime);
		}
		v=checkString(request.getParameter("drugs"));
		if(v.length()>0){
			append(request,transaction,"ITEM_TYPE_DELIVERY_PARTOGRAMME_DRUGS1",v,datetime);
		}
		v=checkString(request.getParameter("heartfrequency"));
		if(v.length()>0){
			append(request,transaction,"ITEM_TYPE_DELIVERY_PARTOGRAMME_HR",v,datetime);
		}
		v=checkString(request.getParameter("systolic"));
		if(v.length()>0){
			append(request,transaction,"ITEM_TYPE_DELIVERY_PARTOGRAMME_BPSYS",v,datetime);
		}
		v=checkString(request.getParameter("diastolic"));
		if(v.length()>0){
			append(request,transaction,"ITEM_TYPE_DELIVERY_PARTOGRAMME_BPDIA",v,datetime);
		}
		v=checkString(request.getParameter("temperature"));
		if(v.length()>0){
			append(request,transaction,"ITEM_TYPE_DELIVERY_PARTOGRAMME_TEMP",v,datetime);
		}
		//Now save the transaction
		MedwanQuery.getInstance().updateTransaction(patientuid, transaction);
		out.println("<script>window.location.href='"+sCONTEXTPATH+"/nursing/mobileActiveDeliveries.jsp';</script>");
		out.flush();
	}
%>
<title><%=getTran(request,"web","measurements",sWebLanguage) %></title>
<html>
	<body>
		<form name='transactionForm' method='post'>
			<input type='hidden' name='patientuid' id='patientuid'/>
			<input type='hidden' name='transactionid' id='transactionid'/>
			<input type='hidden' name='serverid' id='serverid'/>
			<input type='hidden' name='formaction' id='formaction'/>
			<table width='100%'>
				<tr>
					<td colspan='2' style='font-size:8vw;text-align: right'>
						<img onclick="window.location.href='../html5/getPatient.jsp?searchpersonid=<%=person.personId %>'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/patient.png'/>
						<img onclick="window.location.href='../html5/findPatient.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/find.png'/>
						<img onclick="window.location.href='mobileMeasurements.jsp" src='<%=sCONTEXTPATH%>/_img/icons/mobile/refresh.png'/>
						<img onclick="window.location.href='../html5/welcome.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
					</td>
				</tr>
				<tr>
					<td colspan='2' class='mobileadmin' style='font-size:6vw;'>
						<%=person.getFullName()%>
					</td>
				</tr>
				<tr>
					<td colspan='2' class='mobileadmin' style='font-size:6vw;'>
						<%=getTran(request,"web","measurements",sWebLanguage) %>
						<img onclick='save();' style='max-width:10%;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/save.png'/>
					</td>
				</tr>
				<tr>
					<td colspan='2' class='mobileadmin' style='font-size:6vw;vertical-align:middle'>
						<input type='hidden' name='datetime' id='datetime'/>
						<span style='font-size:6vw;' id='datetimespan'></span>
						<img onclick='timeDown();' style='max-width:10%;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/down.png'/>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw;'><%=getTranNoLink("web","foetalheartfrequency",sWebLanguage) %></td>
					<td class='mobileadmin2'>
						<select name='foetalheartrate' style='font-size:6vw;'>
							<option/>
							<%
								for(int n=80;n<=200;n+=5){
									out.println("<option style='font-size:6vw' value='"+n+"'>"+n+"</option>");
								}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw;'><%=getTranNoLink("web","dilatation",sWebLanguage) %></td>
					<td class='mobileadmin2'>
						<select name='dilatation' style='font-size:6vw;'>
							<option/>
							<%
								for(double n=0;n<=10;n+=0.5){
									out.println("<option style='font-size:6vw' value='"+n+"'>"+n+"</option>");
								}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw;'><%=getTranNoLink("web","engagement",sWebLanguage) %></td>
					<td class='mobileadmin2'>
						<select name='engagement' style='font-size:6vw;'>
							<option/>
							<%
								for(double n=0;n<=5;n+=0.5){
									out.println("<option style='font-size:6vw' value='"+n+"'>"+n+"</option>");
								}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw;'><%=getTranNoLink("web.occup","contractions",sWebLanguage) %>/10min</td>
					<td class='mobileadmin2'>
						<select name='contractions' style='font-size:6vw;'>
							<option/>
							<%
								for(int n=0;n<=5;n+=1){
									out.println("<option style='font-size:6vw' value='"+n+"'>"+n+"</option>");
								}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw;'>&nbsp;&nbsp;&nbsp;<%=getTranNoLink("openclinic.chuk","duration",sWebLanguage) %></td>
					<td class='mobileadmin2'>
						<select name='duration' style='font-size:6vw;'>
							<option value='13' style='background-color: white;color: black;'/>
							<option value='10' style='background-color: yellow;color: black;'>&lt;20s</option>
							<option value='11' style='background-color: green;color: white;'>&lt;40s</option>
							<option value='12' style='background-color: blue;color: white;'>&gt;=40s</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw;'><%=getTranNoLink("web","oxygraph",sWebLanguage) %></td>
					<td class='mobileadmin2'>
						<select name='oxytocin' style='font-size:6vw;'>
							<option/>
							<%
								for(int n=0;n<=50;n+=5){
									out.println("<option style='font-size:6vw' value='"+n+"'>"+n+"</option>");
								}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw;'>&nbsp;&nbsp;&nbsp;<%=getTranNoLink("web","dropgraph",sWebLanguage) %></td>
					<td class='mobileadmin2'>
						<select name='drops' style='font-size:6vw;'>
							<option/>
							<%
								for(int n=0;n<=80;n+=5){
									out.println("<option style='font-size:6vw' value='"+n+"'>"+n+"</option>");
								}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw;'><%=getTranNoLink("web","druggraph",sWebLanguage) %></td>
					<td class='mobileadmin2'>
						<select name='drugs' id='drugs' style='font-size:3vw;'>
							<option/>
							<%=ScreenHelper.writeSelect(request, "partogramme.drug", "", sWebLanguage) %>
						</select>
						<script>
							var drugs=document.getElementById("drugs").options;
							for(n=0;n<drugs.length;n++){
								drugs[n].style='font-size:3vw;';
							}
						</script>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw;'><%=getTranNoLink("web","heartfrequency",sWebLanguage) %></td>
					<td class='mobileadmin2'>
						<select name='heartfrequency' style='font-size:6vw;'>
							<option/>
							<%
								for(int n=40;n<=200;n+=5){
									out.println("<option style='font-size:6vw' value='"+n+"'>"+n+"</option>");
								}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw;'><%=getTranNoLink("web","systolic",sWebLanguage) %></td>
					<td class='mobileadmin2'>
						<select name='systolic' style='font-size:6vw;'>
							<option/>
							<%
								for(int n=40;n<=200;n+=5){
									out.println("<option style='font-size:6vw' value='"+n+"'>"+n+"</option>");
								}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw;'><%=getTranNoLink("web","diastolic",sWebLanguage) %></td>
					<td class='mobileadmin2'>
						<select name='diastolic' style='font-size:6vw;'>
							<option/>
							<%
								for(int n=20;n<=180;n+=5){
									out.println("<option style='font-size:6vw' value='"+n+"'>"+n+"</option>");
								}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw;'><%=getTranNoLink("web","temperature",sWebLanguage) %></td>
					<td class='mobileadmin2'>
						<select name='temperature' style='font-size:6vw;'>
							<option/>
							<%
								for(double n=36;n<=42;n+=0.1){
									out.println("<option style='font-size:6vw' value='"+new DecimalFormat("0.0").format(n).replaceAll(",",".")+"'>"+new DecimalFormat("0.0").format(n)+"</option>");
								}
							%>
						</select>
					</td>
				</tr>
			</table>
			<script>
				d=new Date();
				document.getElementById('datetime').value=d.getTime();
				d=new Date(d.getTime());
				document.getElementById('datetimespan').innerHTML=d.getDate()+"/"+(d.getMonth()+1)+"/"+d.getFullYear()+" "+("0"+d.getHours()).substr(("0"+d.getHours()).length-2)+":"+("0"+d.getMinutes()).substr(("0"+d.getMinutes()).length-2);
				
				function timeDown(){
					document.getElementById('datetime').value=document.getElementById('datetime').value*1-60000;
					d=new Date(document.getElementById('datetime').value*1);
					d=new Date(d.getTime());
					document.getElementById('datetimespan').innerHTML=d.getDate()+"/"+(d.getMonth()+1)+"/"+d.getFullYear()+" "+("0"+d.getHours()).substr(("0"+d.getHours()).length-2)+":"+("0"+d.getMinutes()).substr(("0"+d.getMinutes()).length-2);
				}
				
				function save(){
					document.getElementById("formaction").value="save";
					transactionForm.submit();
				}
			</script>
		</form>
	</body>
</html>
<%} %>
