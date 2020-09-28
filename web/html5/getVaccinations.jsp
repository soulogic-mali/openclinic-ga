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
    if(activeUser==null || activeUser.person==null){
        out.println("<script>window.location.href='login.jsp';</script>");
        out.flush();
    }
    else{
    SessionContainerWO sessionContainerWO= (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO( request , SessionContainerWO.class.getName() );
    PersonVO person = MedwanQuery.getInstance().getPerson(activePatient.personid);
    sessionContainerWO.setPersonVO(person);
    sessionContainerWO.setUserVO(MedwanQuery.getInstance().getUser(activeUser.userid));
	if(checkString(request.getParameter("formaction")).equalsIgnoreCase("save")){
		java.util.Date date = new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("vaccindate"));
		//Save the vaccination transaction
        TransactionFactoryGeneral factory = new TransactionFactoryGeneral();
        factory.setContext("","","");
        TransactionVO transactionVO = factory.createTransactionVO( sessionContainerWO.getUserVO(),"be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_VACCINATION",true);
        ItemVO item  = new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier())
    	        , "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VACCINATION_TYPE"
    	        ,request.getParameter("vaccintype").split("\\_")[0]
    	        ,date
    	        ,new ItemContextVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", ""));
            transactionVO.getItems().add(item);
            item  = new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier())
        	        , "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VACCINATION_DATE"
        	        ,ScreenHelper.formatDate(date)
        	        ,date
        	        ,new ItemContextVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", ""));
            transactionVO.getItems().add(item);
            //calculate next vaccination date
            java.util.Date nextdate = MedwanQuery.getInstance().calculateNextVaccination(request.getParameter("vaccintype").split("\\_")[0], request.getParameter("vaccinstatus"), date);
            item  = new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier())
        	        , "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VACCINATION_NEXTDATE"
        	        ,ScreenHelper.formatDate(nextdate)
        	        ,date
        	        ,new ItemContextVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", ""));
            transactionVO.getItems().add(item);
            item  = new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier())
        	        , "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VACCINATION_STATUS"
        	        ,request.getParameter("vaccinstatus")
        	        ,date
        	        ,new ItemContextVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", ""));
            transactionVO.getItems().add(item);
            MedwanQuery.getInstance().updateTransaction(Integer.parseInt(activePatient.personid), transactionVO);
	}
    sessionContainerWO.setPersonalVaccinationsInfoVO(MedwanQuery.getInstance().getPersonalVaccinationsInfo(person, sWebLanguage));
    
%>
<%=sCSSNORMAL %>
<title><%=getTran(request,"web","patientfile",sWebLanguage) %></title>
<html>
	<body>
		<form name='transactionForm' method='post'>
			<input type='hidden' name='formaction' id='formaction'/>
			<table width='100%'>
				<tr>
					<td style='font-size:8vw;text-align: left'></td>
					<td style='font-size:8vw;text-align: right'>
						<img onclick="window.location.href='getPatient.jsp?searchpersonid=<%=activePatient.personid %>'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/patient.png'/>
						<img onclick="window.location.href='findPatient.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/find.png'/>
						<img onclick="window.location.href='getVaccinations.jsp" src='<%=sCONTEXTPATH%>/_img/icons/mobile/refresh.png'/>
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
					<td style='font-size:6vw;font-weight: bolder;align: left;background-color:#C3D9FF;padding:10px'><%=getTranNoLink("web","vaccination",sWebLanguage) %></td>
					<td style='font-size:6vw;font-weight: bolder;align: left;background-color:#C3D9FF;padding:10px'><%=getTranNoLink("web","next",sWebLanguage) %></td>
				</tr>
				<%
		        	PersonalVaccinationsInfoVO vaccinfo = sessionContainerWO.getPersonalVaccinationsInfoVO();
			        if (vaccinfo!=null){
			        	Collection vaccinations = vaccinfo.getVaccinationsInfoVO();
			        	Iterator iVaccinations = vaccinations.iterator();
			        	while(iVaccinations.hasNext()){
			        		VaccinationInfoVO vaccination = (VaccinationInfoVO)iVaccinations.next();
			        		String s = vaccination.getType();
			        		if(s.length()>0){
			        			out.println("<tr>");
			        			out.println("<td style='font-size:6vw;align: left;background-color:#DEEAFF;padding:10px'>"+getTranNoLink("web.occup",s,sWebLanguage)+
					        			"<span style='font-size:4vw'><br/>"+vaccination.getTransactionVO().getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VACCINATION_DATE")+"</span></td>");
				        		s = vaccination.getTransactionVO().getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VACCINATION_NEXTDATE");
			        			out.println("<td style='font-size:6vw;align: left;background-color:"+vaccination.getColor()+";padding:10px'>"+s+"</td>");
			        			out.println("</tr>");
			        		}
			        	}
			        }
				%>
				<tr>
					<td colspan='2'><br/></td>
				</tr>
				<tr>
					<td colspan='2' class='mobileadmin' style='font-size:6vw'>
						<%=getTranNoLink("web","newvaccination",sWebLanguage) %>
						<img onclick='save();' style='max-width:10%;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/save.png'/>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","type",sWebLanguage) %></td>
					<td class='mobileadmin2' style='font-size:6vw'>
						<select name='vaccintype' id='vaccintype' style='font-size:6vw' onchange='updatestatus();'>
							<option/>
							<%
								if(vaccinfo!=null){
						        	Collection vaccinations = vaccinfo.getVaccinationsInfoVO();
						        	Iterator iVaccinations = vaccinations.iterator();
						        	while(iVaccinations.hasNext()){
						        		VaccinationInfoVO vaccination = (VaccinationInfoVO)iVaccinations.next();
						        		out.println("<option style='font-size:6vw' value='"+vaccination.getType()+"_"+vaccination.getNextStatus()+"_"+getTranNoLink("web.occup",vaccination.getNextStatus(),sWebLanguage)+"'>"+getTranNoLink("web.occup",vaccination.getType(),sWebLanguage)+"</option>");
						        	}
									vaccinations=vaccinfo.getOtherVaccinations();
						        	iVaccinations = vaccinations.iterator();
						        	while(iVaccinations.hasNext()){
						        		ExaminationVO examination = (ExaminationVO)iVaccinations.next();
						        		out.println("<option style='font-size:6vw' value='"+examination.getMessageKey()+"_be.mxs.healthrecord.vaccination.subtype.first_"+getTranNoLink("web.occup","be.mxs.healthrecord.vaccination.subtype.first",sWebLanguage)+"'>"+getTranNoLink("web.occup",examination.getMessageKey(),sWebLanguage)+"</option>");
						        	}
								}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web.occup","be.mxs.healthrecord.vaccination.status",sWebLanguage) %></td>
					<td class='mobileadmin2' style='font-size:6vw'>
						<input type='hidden' name='vaccinstatus' id='vaccinstatus'/>
						<span id='vaccinstatustext' style='font-size:6vw'></span>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'>
						<%=getTranNoLink("web","date",sWebLanguage) %>
					</td>
					<td class='mobileadmin2' style='font-size:6vw'>
						<input class='mobileadmin2' style='font-size:5vw;height: 8vw;width:200px' type='date' name='vaccindate' id='vaccindate' value='<%=new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>'/>
					</td>
				</tr>
			</table>
		</form>
		
		<script>
			function updatestatus(){
				document.getElementById('vaccinstatustext').innerHTML=document.getElementById('vaccintype').value.split('_')[2];
				document.getElementById('vaccinstatus').value=document.getElementById('vaccintype').value.split('_')[1];
			}
			function save(){
				if(document.getElementById('vaccinstatus').value.length*document.getElementById('vaccindate').value.length==0){
					alert('<%=getTranNoLink("web","somedataismissing",sWebLanguage)%>');
				}
				else{
					document.getElementById("formaction").value="save";
					transactionForm.submit();
				}
			}
		</script>
		<%
    }
		%>
	</body>
</html>
<script>
	window.parent.parent.scrollTo(0,0);
</script>