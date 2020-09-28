<%@page import="be.dpms.medwan.common.model.vo.administration.PersonVO"%>
<%@page import="be.dpms.medwan.common.model.vo.occupationalmedicine.ExaminationVO"%>
<%@page import="be.mxs.common.model.vo.healthrecord.*,be.mxs.common.model.vo.healthrecord.util.*"%>
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
<%
    if(activeUser==null || activeUser.person==null || activePatient==null){
        out.println("<script>window.location.href='login.jsp';</script>");
        out.flush();
    }
    else{
        SessionContainerWO sessionContainerWO= (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO( request , SessionContainerWO.class.getName() );
        PersonVO person = MedwanQuery.getInstance().getPerson(activePatient.personid);
        sessionContainerWO.setPersonVO(person);
        sessionContainerWO.setUserVO(MedwanQuery.getInstance().getUser(activeUser.userid));
    	if(checkString(request.getParameter("formaction")).equalsIgnoreCase("save")){
    		//Create a vital signs transaction
            TransactionFactoryGeneral factory = new TransactionFactoryGeneral();
            factory.setContext("","","");
            TransactionVO transactionVO = factory.createTransactionVO( sessionContainerWO.getUserVO(),"be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_VITALSIGNS",true);
			//If an active encounter exists, link it
			Encounter activeEncounter = Encounter.getActiveEncounter(activePatient.personid);
			if(activeEncounter!=null){
				ItemVO item = transactionVO.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID");
				if(item==null){
		            item  = new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier())
		        	        , "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID"
		        	        ,activeEncounter.getUid()
		        	        ,new java.util.Date()
		        	        ,new ItemContextVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", ""));
		                transactionVO.getItems().add(item);
				}
				else{
					item.setValue(activeEncounter.getUid());
				}
			}
            if(request.getParameter("temperature")!=null){
	            ItemVO item  = new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier())
	        	        , "be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE"
	        	        ,request.getParameter("temperature")
	        	        ,new java.util.Date()
	        	        ,new ItemContextVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", ""));
	                transactionVO.getItems().add(item);
            }
            if(request.getParameter("heartfrequency")!=null){
	            ItemVO item  = new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier())
	        	        , "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY"
	        	        ,request.getParameter("heartfrequency")
	        	        ,new java.util.Date()
	        	        ,new ItemContextVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", ""));
	                transactionVO.getItems().add(item);
            }
            if(request.getParameter("heartrythm")!=null){
	            ItemVO item  = new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier())
	        	        , "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH"
	        	        ,request.getParameter("heartrythm")
	        	        ,new java.util.Date()
	        	        ,new ItemContextVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", ""));
	                transactionVO.getItems().add(item);
            }
            if(request.getParameter("respiratoryfrequency")!=null){
	            ItemVO item  = new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier())
	        	        , "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_RESPIRATORY_FREQUENCY"
	        	        ,request.getParameter("respiratoryfrequency")
	        	        ,new java.util.Date()
	        	        ,new ItemContextVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", ""));
	                transactionVO.getItems().add(item);
	            item  = new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier())
	        	        , "be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY"
	        	        ,request.getParameter("respiratoryfrequency")
	        	        ,new java.util.Date()
	        	        ,new ItemContextVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", ""));
	                transactionVO.getItems().add(item);
            }
            if(request.getParameter("respiratoryrythm")!=null){
	            ItemVO item  = new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier())
	        	        , "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_RESPIRATORY_RYTMH"
	        	        ,request.getParameter("respiratoryrythm")
	        	        ,new java.util.Date()
	        	        ,new ItemContextVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", ""));
	                transactionVO.getItems().add(item);
            }
            if(request.getParameter("systolicpressure")!=null){
	            ItemVO item  = new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier())
	        	        , "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT"
	        	        ,request.getParameter("systolicpressure")
	        	        ,new java.util.Date()
	        	        ,new ItemContextVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", ""));
	                transactionVO.getItems().add(item);
            }
            if(request.getParameter("diastolicpressure")!=null){
	            ItemVO item  = new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier())
	        	        , "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT"
	        	        ,request.getParameter("diastolicpressure")
	        	        ,new java.util.Date()
	        	        ,new ItemContextVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", ""));
	                transactionVO.getItems().add(item);
            }
            if(request.getParameter("saturation")!=null){
	            ItemVO item  = new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier())
	        	        , "be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION"
	        	        ,request.getParameter("saturation")
	        	        ,new java.util.Date()
	        	        ,new ItemContextVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", ""));
	                transactionVO.getItems().add(item);
            }
            MedwanQuery.getInstance().updateTransaction(Integer.parseInt(activePatient.personid), transactionVO);
            Thread.sleep(200);
    	}
	}
%>
<%=sCSSNORMAL %>
<title><%=getTran(request,"web","vitalsigns",sWebLanguage) %></title>
<html>
	<body>
		<form name='transactionForm' method='post'>
			<input type='hidden' name='formaction' id='formaction'/>
			<table width='100%'>
				<tr>
					<td colspan='2' style='font-size:8vw;text-align: right'>
						<img onclick="window.location.href='getPatient.jsp?searchpersonid=<%=activePatient.personid %>'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/patient.png'/>
						<img onclick="window.location.href='findPatient.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/find.png'/>
						<img onclick="window.location.href='getVitalSigns.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/refresh.png'/>
						<img onclick="window.location.href='welcome.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
					</td>
				</tr>
				<tr>
					<td colspan='2' class='mobileadmin' style='font-size:6vw;'>
						<%
							out.println("["+activePatient.personid+"] "+activePatient.getFullName());
						%>
					</td>
				</tr>
				<tr>
					<td colspan='2' class='mobileadmin' style='font-size:6vw;'><%=getTran(request,"openclinic.chuk","vital.signs",sWebLanguage) %> 24h</td>
				</tr>
				<%
					long day = 24*3600*1000;
				Vector items = MedwanQuery.getInstance().getItemsFordPeriod(Integer.parseInt(activePatient.personid), "'be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE'", new java.util.Date(new java.util.Date().getTime()-day), new java.util.Date());
				if(items.size()>0){
					ItemVO item = (ItemVO)items.elementAt(items.size()-1);
					out.println("<tr>");
					out.println("<td class='mobileadmin2' style='font-size:6vw'>"+getTranNoLink("web","temperature",sWebLanguage)+"</td>");
					out.println("<td class='mobileadmin2' style='font-size:6vw;font-weight:bold'>"+item.getValue()+"<span style='font-size:4vw'>°C</span></td>");
					out.println("</tr>");
				}
				items = MedwanQuery.getInstance().getItemsFordPeriod(Integer.parseInt(activePatient.personid), "'be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY'", new java.util.Date(new java.util.Date().getTime()-day), new java.util.Date());
				if(items.size()>0){
					ItemVO item = (ItemVO)items.elementAt(items.size()-1);
					out.println("<tr>");
					out.println("<td class='mobileadmin2' style='font-size:6vw'>"+getTranNoLink("web","heartfrequency",sWebLanguage)+"</td>");
					out.println("<td class='mobileadmin2' style='font-size:6vw;font-weight:bold'>"+item.getValue()+" <span style='font-size:4vw'>"+getTranNoLink("web","bpm",sWebLanguage)+"</span></td>");
					out.println("</tr>");
					items = MedwanQuery.getInstance().getItemsFordPeriod(Integer.parseInt(activePatient.personid), "'be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH'", new java.util.Date(new java.util.Date().getTime()-day), new java.util.Date());
					if(items.size()>0){
						item = (ItemVO)items.elementAt(items.size()-1);
						out.println("<tr>");
						out.println("<td class='mobileadmin2' style='font-size:5vw'>&nbsp;&nbsp;"+getTranNoLink("web","rythm",sWebLanguage)+"</td>");
						out.println("<td class='mobileadmin2' style='font-size:6vw;font-weight:bold'>"+getTranNoLink("web.occup",item.getValue(),sWebLanguage)+"</td>");
						out.println("</tr>");
					}
				}
				items = MedwanQuery.getInstance().getItemsFordPeriod(Integer.parseInt(activePatient.personid), "'be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_RESPIRATORY_FREQUENCY'", new java.util.Date(new java.util.Date().getTime()-day), new java.util.Date());
				if(items.size()>0){
					ItemVO item = (ItemVO)items.elementAt(items.size()-1);
					out.println("<tr>");
					out.println("<td class='mobileadmin2' style='font-size:6vw'>"+getTranNoLink("openclinic.chuk","respiratory.frequency",sWebLanguage)+"</td>");
					out.println("<td class='mobileadmin2' style='font-size:6vw;font-weight:bold'>"+item.getValue()+" <span style='font-size:4vw'>"+getTranNoLink("web","bpm",sWebLanguage)+"</span></td>");
					out.println("</tr>");
					items = MedwanQuery.getInstance().getItemsFordPeriod(Integer.parseInt(activePatient.personid), "'be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_RESPIRATORY_RYTMH'", new java.util.Date(new java.util.Date().getTime()-day), new java.util.Date());
					if(items.size()>0){
						item = (ItemVO)items.elementAt(items.size()-1);
						out.println("<tr>");
						out.println("<td class='mobileadmin2' style='font-size:5vw'>&nbsp;&nbsp;"+getTranNoLink("web","rythm",sWebLanguage)+"</td>");
						out.println("<td class='mobileadmin2' style='font-size:6vw;font-weight:bold'>"+getTranNoLink("web.occup",item.getValue(),sWebLanguage)+"</td>");
						out.println("</tr>");
					}
				}
				items = MedwanQuery.getInstance().getItemsFordPeriod(Integer.parseInt(activePatient.personid), "'be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT'", new java.util.Date(new java.util.Date().getTime()-day), new java.util.Date());
				if(items.size()>0){
					ItemVO item = (ItemVO)items.elementAt(items.size()-1);
					String bp =item.getValue();
					items = MedwanQuery.getInstance().getItemsFordPeriod(Integer.parseInt(activePatient.personid), "'be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT'", new java.util.Date(new java.util.Date().getTime()-day), new java.util.Date());
					if(items.size()>0){
						item = (ItemVO)items.elementAt(items.size()-1);
						bp+="/"+item.getValue();
					}
					out.println("<tr>");
					out.println("<td class='mobileadmin2' style='font-size:6vw'>"+getTranNoLink("web","bloodpressure",sWebLanguage)+"</td>");
					out.println("<td class='mobileadmin2' style='font-size:6vw;font-weight:bold'>"+bp+" <span style='font-size:4vw'>mmHg</span></td>");
					out.println("</tr>");
				}
				else{
					items = MedwanQuery.getInstance().getItemsFordPeriod(Integer.parseInt(activePatient.personid), "'be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT'", new java.util.Date(new java.util.Date().getTime()-day), new java.util.Date());
					if(items.size()>0){
						ItemVO item = (ItemVO)items.elementAt(items.size()-1);
						String bp =item.getValue();
						items = MedwanQuery.getInstance().getItemsFordPeriod(Integer.parseInt(activePatient.personid), "'be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT'", new java.util.Date(new java.util.Date().getTime()-day), new java.util.Date());
						if(items.size()>0){
							item = (ItemVO)items.elementAt(items.size()-1);
							bp+="/"+item.getValue();
						}
						out.println("<tr>");
						out.println("<td class='mobileadmin2' style='font-size:6vw'>"+getTranNoLink("web","bloodpressure",sWebLanguage)+"</td>");
						out.println("<td class='mobileadmin2' style='font-size:6vw;font-weight:bold'>"+bp+" <span style='font-size:4vw'>mmHg</span></td>");
						out.println("</tr>");
					}
				}
				items = MedwanQuery.getInstance().getItemsFordPeriod(Integer.parseInt(activePatient.personid), "'be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION'", new java.util.Date(new java.util.Date().getTime()-day), new java.util.Date());
				if(items.size()>0){
					ItemVO item = (ItemVO)items.elementAt(items.size()-1);
					out.println("<tr>");
					out.println("<td class='mobileadmin2' style='font-size:6vw'>SaO2</td>");
					out.println("<td class='mobileadmin2' style='font-size:6vw;font-weight:bold'>"+item.getValue()+" <span style='font-size:4vw'>%</span></td>");
					out.println("</tr>");
				}
				%>
				<tr>
					<td colspan='2'><br/></td>
				</tr>
			</table>
			<table>
				<%
					Encounter activeEncounter = Encounter.getActiveEncounter(activePatient.personid);
					if(activeEncounter!=null){
				%>
				<tr>
					<td colspan='2' class='mobileadmin' style='font-size:6vw;'>
						<%=getTran(request,"web","new",sWebLanguage) %>
						<img onclick='save();' style='max-width:10%;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/save.png'/>
					</td>
				</tr>
				<%
					}
					else{
				%>
				<tr>
					<td colspan='2' class='mobileadmin' style='font-size:6vw;color:white'>
						<%=getTran(request,"web","new",sWebLanguage) %>
						<img style='opacity:0.3;max-width:10%;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/nosave.png'/>
						<span style='font-size:3vw;color:black'><br/><%=getTranNoLink("web","noactiveencounter",sWebLanguage) %></span>
					</td>
				</tr>
				<%
					}
				%>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'>Temp.</td>
					<td class='mobileadmin2' style='font-size:6vw'>
						<select name='temperature' style='font-size:6vw'>
							<option/>
							<%
								for(double n=35;n<=42;n+=0.1){
									out.println("<option style='font-size:6vw' value='"+new DecimalFormat("0.0").format(n).replaceAll(",",".")+"'>"+new DecimalFormat("0.0").format(n)+"</option>");
								}
							%>
						</select>
						<span style='font-size:4vw'>°C</span>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","heartfrequency",sWebLanguage)%></td>
					<td class='mobileadmin2' style='font-size:6vw'>
						<select name='heartfrequency' style='font-size:6vw'>
							<option/>
							<%
								for(int n=40;n<=200;n+=5){
									out.println("<option style='font-size:6vw' value='"+n+"'>"+n+"</option>");
								}
							%>
						</select>
						<select name='heartrythm' style='font-size:6vw'>
							<option/>
							<option style='font-size:6vw' value='medwan.healthrecord.cardial.regulier'><%=getTranNoLink("web.occup","medwan.healthrecord.cardial.regulier",sWebLanguage) %></option>
							<option style='font-size:6vw' value='medwan.healthrecord.cardial.irregulier'><%=getTranNoLink("web.occup","medwan.healthrecord.cardial.irregulier",sWebLanguage) %></option>
						</select>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("openclinic.chuk","respiratory.frequency",sWebLanguage)%></td>
					<td class='mobileadmin2' style='font-size:6vw'>
						<select name='respiratoryfrequency' style='font-size:6vw'>
							<option/>
							<%
								for(int n=1;n<=60;n++){
									out.println("<option style='font-size:6vw' value='"+n+"'>"+n+"</option>");
								}
							%>
						</select>
						<select name='respiratorytrythm' style='font-size:6vw'>
							<option/>
							<option style='font-size:6vw' value='medwan.healthrecord.cardial.regulier'><%=getTranNoLink("web.occup","medwan.healthrecord.cardial.regulier",sWebLanguage) %></option>
							<option style='font-size:6vw' value='medwan.healthrecord.cardial.irregulier'><%=getTranNoLink("web.occup","medwan.healthrecord.cardial.irregulier",sWebLanguage) %></option>
						</select>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","bloodpressure",sWebLanguage)%></td>
					<td class='mobileadmin2' style='font-size:6vw' nowrap>
						<select name='systolicpressure' style='font-size:6vw'>
							<option/>
							<%
								for(int n=40;n<=240;n+=5){
									out.println("<option style='font-size:6vw' value='"+n+"'>"+n+"</option>");
								}
							%>
						</select>
						/
						<select name='diastolicpressure' style='font-size:6vw'>
							<option/>
							<%
								for(int n=30;n<=200;n+=5){
									out.println("<option style='font-size:6vw' value='"+n+"'>"+n+"</option>");
								}
							%>
						</select>
						<span style='font-size:4vw'>mmHg</span>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'>SaO2</td>
					<td class='mobileadmin2' style='font-size:6vw'>
						<select name='saturation' style='font-size:6vw'>
							<option/>
							<%
								for(double n=20;n<=100;n+=2){
									out.println("<option style='font-size:6vw' value='"+n+"'>"+n+"</option>");
								}
							%>
						</select>
						<span style='font-size:4vw'>%</span>
					</td>
				</tr>
			</table>
		</form>
		<script>
			function save(){
				document.getElementById("formaction").value="save";
				transactionForm.submit();
			}
		</script>
	</body>
</html>
<script>
	window.parent.parent.scrollTo(0,0);
</script>