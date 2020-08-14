<%@page import="be.openclinic.adt.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%=sJSPROTOTYPE %>
<%
	String id = checkString(request.getParameter("id"));
	String begindate = checkString(request.getParameter("begindate"));
	String begin = checkString(request.getParameter("begin"));
	String beginhour = checkString(request.getParameter("beginhour"));
	String beginminutes = checkString(request.getParameter("beginminutes"));
	String enddate = checkString(request.getParameter("enddate"));
	String end = checkString(request.getParameter("end"));
	String endhour = checkString(request.getParameter("endhour"));
	String endminutes = checkString(request.getParameter("endminutes"));
	String visited = checkString(request.getParameter("visited"));
	String visitedhour = checkString(request.getParameter("visitedhour"));
	String visitedminutes = checkString(request.getParameter("visitedminutes"));
	String patientid = checkString(request.getParameter("patientid"));
	String patientname = checkString(request.getParameter("patientname"));
	String userid = checkString(request.getParameter("userid"));
	String username = checkString(request.getParameter("username"));
	String comment = checkString(request.getParameter("comment"));
	String type = checkString(request.getParameter("type"));
	String fullDay = checkString(request.getParameter("fullDay"));
	String location = checkString(request.getParameter("location"));
	String createfreeslots = checkString(request.getParameter("createfreeslots"));
	String slotduration = checkString(request.getParameter("slotduration"));
	String setseen = checkString(request.getParameter("setseen"));
	String color = checkString(request.getParameter("color"));
	String calendarType = checkString(request.getParameter("calendartype"));
	String resourceid = checkString(request.getParameter("resourceid"));
	String resourcename = checkString(request.getParameter("resourcename"));
	if(resourcename.length()==0 && resourceid.length()>0){
		resourcename=getTranNoLink("calendarresource",resourceid,sWebLanguage);
	}
	
	if(id.length()==0 || id.split("\\.").length<2){
		//First check if the user has the necessary accessrights
		boolean bHasRight = false;
		if(Integer.parseInt((String)session.getAttribute("calendarUser"))==Integer.parseInt(activeUser.userid)){
			//The user can modify his own appointments
			bHasRight=true;
		}
		else{
			//Get allowed users
			User user = new User();
			user.initialize(Integer.parseInt((String)session.getAttribute("calendarUser")));
			
			String[] users = user.getParameter("agenda_users").split(";");
			for(int n=0;n<users.length;n++){
				if(users[n].split("=").length>1){
					if(activeUser.userid.equalsIgnoreCase(users[n].split("=")[0]) && users[n].split("=")[1].length()>0 && users[n].split("=")[1].contains("c")){
						bHasRight=true;
					}
				}
			}
		}
		
		if(!bHasRight){
			out.println("<script>window.opener.alert('"+getTranNoLink("web","wrongpermission",sWebLanguage)+"');window.close();</script>");
			out.flush();
		}
		else if(calendarType.equalsIgnoreCase("user") && begindate.split("T").length==2 && !begindate.contains("T00:00:00")){
			//Now check if there are existing appointments in the selection that was made
			Vector<Planning> appointments = Planning.getUserPlannings((String)session.getAttribute("calendarUser"), new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(begindate), new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(enddate));
			if(appointments.size()==1){
				out.println("<script>window.location.href='"+sCONTEXTPATH+"/popup.jsp?Page=calendar/overlapSingleAppointment.jsp&begindate="+begindate+"&enddate="+enddate+"&id="+appointments.elementAt(0).getUid()+"';</script>");
				out.flush();
			}
			else if(appointments.size()>1){
				out.println("<script>window.location.href='"+sCONTEXTPATH+"/popup.jsp?Page=calendar/overlapMultipleAppointments.jsp&begindate="+begindate+"&enddate="+enddate+"';</script>");
				out.flush();
			}
		}
	}
	if(setseen.length()>0){
		Planning appointment = Planning.get(setseen);
		if(appointment!=null && appointment.getEffectiveDate()==null){
			appointment.setEffectiveDate(new java.util.Date());
			appointment.store();
		}
		out.println("<script>window.close();</script>");
		out.flush();
	}
	
	if(fullDay.length()==0){
		fullDay="-1";
	}
	
	if(begindate.equalsIgnoreCase("undefined")){
		begindate="";
	}
	if(enddate.equalsIgnoreCase("undefined")){
		enddate="";
	}
	int defaultduration = Integer.parseInt(checkString(activeUser.getParameter("PlanningExamDuration"),"15"));
	
	if(id.equalsIgnoreCase("-2") && begindate.split("T").length>1){
		//Create appointment with default 15 minutes slot
		begin=begindate.split("T")[0];
		beginhour=begindate.split("T")[1].split(":")[0];
		beginminutes=begindate.split("T")[1].split(":")[1];
		int minutes = new Double(Math.floor(Integer.parseInt(beginminutes)/defaultduration)*defaultduration).intValue();
		begindate=begin+"T"+beginhour+":"+ScreenHelper.padLeft(minutes+"","0",2);
		enddate=begin+"T"+beginhour+":"+ScreenHelper.padLeft((minutes+defaultduration)+"","0",2);
	}
	if(id.equalsIgnoreCase("-2")){
		id="";
	}

	Planning appointment = null;
	if(id.length()>0){
		appointment=Planning.get(id);
	}
	if(appointment==null || appointment.getPlannedDate()==null){
		appointment=new Planning();
		appointment.setUid(SH.sid()+"."+MedwanQuery.getInstance().getOpenclinicCounter("OC_PLANNING"));
		appointment.setComment("");
		appointment.setContextID("");
		appointment.setUserUID((String)session.getAttribute("calendarUser"));
		if(activePatient!=null){
			appointment.setPatientUID(activePatient.personid);
			appointment.setPatient(activePatient);
		}
		else{
			appointment.setPatientUID("-1");
			appointment.setPatient(null);
		}
		if(begindate.length()>0){
			begin=begindate.split("T")[0];
			if(begindate.split("T").length<2){
				appointment.setPlannedDate(new SimpleDateFormat("yyyy-MM-dd").parse(begin));
				appointment.setFullDay("1"); //Full day
				if(beginhour.length()==0){
					beginhour="00";
				}
				if(beginminutes.length()==0){
					beginminutes="00";
				}
			}
			else{
				if(beginhour.length()==0){
					beginhour=begindate.split("T")[1].split(":")[0];
				}
				if(beginminutes.length()==0){
					beginminutes=begindate.split("T")[1].split(":")[1];
				}
				appointment.setPlannedDate(new SimpleDateFormat("yyyy-MM-dd HH:mm").parse(begindate.replaceAll("T"," ")));
				if(begindate.contains("T00:00:00")){
					appointment.setFullDay("1"); //Full day
				}
			}
		}
		if(enddate.length()>0){
			end=enddate.split("T")[0];
			if(endhour.length()==0){
				endhour=enddate.split("T")[1].split(":")[0];
			}
			if(endminutes.length()==0){
				endminutes=enddate.split("T")[1].split(":")[1];
			}
			enddate=end+"T"+ScreenHelper.padLeft(endhour, "0", 2)+":"+ScreenHelper.padLeft(endminutes,"0",2);
			appointment.setPlannedEndDate(new SimpleDateFormat("yyyy-MM-dd HH:mm").parse(enddate.replaceAll("T"," ")));
		}
		else if(begindate.length()>0){
			end=begin;
			if(endhour.length()==0){
				endhour="23";
			}
			if(endminutes.length()==0){
				endminutes="50";
			}
			enddate=begin+"T"+endhour+":"+endminutes;
			appointment.setPlannedEndDate(new SimpleDateFormat("yyyy-MM-dd HH:mm").parse(enddate.replaceAll("T"," ")));
		}
	}
	/*******************************************************
	* Initialize some appointment data with parameter values
	*******************************************************/
	if(type.length()>0){
		appointment.setType(type);
	}
	System.out.println("AAAAAAA: "+request.getParameter("actionField"));
	
	if(request.getParameter("deleteButton")!=null){
		if(id.length()>0){
			Planning.delete(id);
		}
		out.println("<script>window.opener.renderEvents();window.close();</script>");
		out.flush();
	}
	else if(checkString(request.getParameter("actionField")).equalsIgnoreCase("save")){
		if(createfreeslots.equalsIgnoreCase("1")){
			Vector appointments = Planning.getUserPlannings((String)session.getAttribute("calendarUser"),appointment.getPlannedDate(),appointment.getPlannedEndDate());
			java.util.Date blockStart = new SimpleDateFormat("dd/MM/yyyy").parse(new SimpleDateFormat("dd/MM/yyyy").format(appointment.getPlannedDate()));
			long minute = 60000;
			long hour = 60*minute;
			for(long n=blockStart.getTime()+Integer.parseInt(beginhour)*hour+Integer.parseInt(beginminutes)*minute;n<=blockStart.getTime()+Integer.parseInt(endhour)*hour+(Integer.parseInt(endminutes)*minute)-(Integer.parseInt(slotduration)*minute);n+=Integer.parseInt(slotduration)*minute){
				java.util.Date slotStart = new java.util.Date(n);
				java.util.Date slotEnd = new java.util.Date(slotStart.getTime()+Integer.parseInt(slotduration)*minute);
				boolean bSlotExists=false;
				for(int i=0;i<appointments.size();i++){
					Planning app = (Planning)appointments.elementAt(i);
					if(slotStart.before(app.getPlannedEndDate()) && slotEnd.after(app.getPlannedDate()) && !app.getFullDay().equalsIgnoreCase("1")){
						bSlotExists=true;
						break;
					}
				}
				if(!bSlotExists){
					//Create free slot in database
					Planning freeSlot = new Planning();
					freeSlot.setPlannedDate(slotStart);
					freeSlot.setPlannedEndDate(new java.util.Date(slotStart.getTime()+Integer.parseInt(slotduration)*minute));
					freeSlot.setUserUID((String)session.getAttribute("calendarUser"));
					freeSlot.setType("medwan.common.free");
					freeSlot.setLocation(location);
					freeSlot.store();
				}
			}
		}
		//Save the appointment
		if(id.equalsIgnoreCase("-1")){
			id="";
		}
		if(id.equalsIgnoreCase("-2")){
			id="";
			end=begin;
			endhour="23";
			endminutes="50";
		}
		appointment.setUid(id);
		try{
			appointment.setPlannedDate(new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(begin+" "+beginhour+":"+beginminutes));
		} catch(Exception e){}
		try{
			appointment.setPlannedEndDate(new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(end+" "+endhour+":"+endminutes));
		} catch(Exception e){
		}
		try{
			appointment.setEffectiveDate(null);
			appointment.setEffectiveDate(new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(visited+" "+visitedhour+":"+visitedminutes));
		} catch(Exception e){}
		if(patientid.length()>0){
			appointment.setPatientUID(patientid);
		}
		else{
			appointment.setPatientUID("-1");
		}
		if(userid.length()>0){
			appointment.setUserUID(userid);
		}
		else{
			appointment.setUserUID("-1");
		}
		appointment.setColor(color);
		appointment.setComment(comment);
		appointment.setType(type);
		appointment.setLocation(location);
		appointment.setFullDay(fullDay);
		if(appointment.getUid()==null || appointment.getUid().split("\\.").length<2){
			appointment.setUid("");
		}
		appointment.store();
		out.println("<script>if(window.opener.renderEvents) window.opener.renderEvents();window.close();</script>");
		out.flush();
	}
%>
<%=sJSDATE %>
<%=sCSSNORMAL %>
<%
	if(appointment.getFullDay().equalsIgnoreCase("1")){
%>
	<form name='transactionForm' id='transactionForm' method='POST'>
		<input type='hidden' name='userid' id='userid' value='<%=(String)session.getAttribute("calendarUser") %>'/>
		<input type='hidden' name='fullDay' id='fullDay' value='1'/>
		<input type='hidden' name='id' id='id' value='<%=appointment.getUid()%>'/>
		<table width='100%'>
			<tr class='admin'>
				<td colspan='2'><%=getTran(request,"web","appointment",sWebLanguage) %></td>
			</tr>
			<tr>
				<td class='admin'><%=getTran(request,"web","date",sWebLanguage) %></td>
				<td class='admin2'>
					<%=ScreenHelper.writeDateField("begin","transactionForm",ScreenHelper.formatDate(appointment.getPlannedDate()),false,true,sWebLanguage,sCONTEXTPATH) %>
				</td>
			</tr>
			<tr>
				<td class='admin'><%=getTran(request,"web","location",sWebLanguage) %></td>
				<td class='admin2'>
					<select class='text' name='location' id='location'>
						<option/>
						<%=ScreenHelper.writeSelect(request,"appointment.location",appointment.getLocation(),sWebLanguage) %>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan='2' class='admin'><input type='checkbox' name='createfreeslots' value='1'/><%=getTran(request,"web","createfreeslots",sWebLanguage) %></td>
			</tr>
			<tr>
				<td class='admin'><%=getTran(request,"web","begin",sWebLanguage) %></td>
				<td class='admin2'>
					<select class='text' name='beginhour' id='beginhour'>
						<%
							for(int n=0;n<24;n++){
								out.println("<option value='"+n+"' "+(9==n?"selected":"")+">"+ScreenHelper.padLeft(n+"","0",2)+"</option>");
							}
						%>
					</select>:
					<select class='text' name='beginminutes' id='beginminutes'>
						<%
							for(int n=0;n<60;n+=5){
								out.println("<option value='"+n+"' "+(0==n?"selected":"")+">"+ScreenHelper.padLeft(n+"","0",2)+"</option>");
							}
						%>
					</select>
				</td>
			</tr>
			<tr>
				<td class='admin'><%=getTran(request,"web","end",sWebLanguage) %></td>
				<td class='admin2'>
					<select class='text' name='endhour' id='endhour'>
						<%
							for(int n=0;n<24;n++){
								out.println("<option value='"+n+"' "+(Integer.parseInt(checkString(activeUser.getParameter("agenda_end"),"18"))==n?"selected":"")+">"+ScreenHelper.padLeft(n+"","0",2)+"</option>");
							}
						%>
					</select>:
					<select class='text' name='endminutes' id='endminutes'>
						<%
							for(int n=0;n<60;n+=5){
								out.println("<option value='"+n+"' "+(0==n?"selected":"")+">"+ScreenHelper.padLeft(n+"","0",2)+"</option>");
							}
						%>
					</select>
				</td>
			</tr>
			<tr>
				<td class='admin'><%=getTran(request,"web","duration",sWebLanguage) %></td>
				<td class='admin2'>
					<select class='text' name='slotduration' id='endminutes'>
						<%
							for(int n=5;n<=60;n+=5){
								out.println("<option value='"+n+"' "+(defaultduration==n?"selected":"")+">"+ScreenHelper.padLeft(n+"","0",2)+"</option>");
							}
						%>
					</select>
					<%=getTran(request,"web","minutes",sWebLanguage) %>
				</td>
			</tr>
			<tr>
				<td class='admin'><%=getTran(request,"web","color",sWebLanguage) %></td>
				<td class='admin2'>
					<select class='minitext' name='color' id='color' onchange='this.style.backgroundColor=this.options[this.selectedIndex].style.backgroundColor;this.style.color=this.options[this.selectedIndex].style.color;'>
						<option style='background-color: #FFFFFF; color: #000000'>Auto</option>
						<%
							String[] colors = MedwanQuery.getInstance().getConfigString("agendaColors","E6C79C=000000;CDDFA0=000000;6FD08C=000000;7B9EA8=FFFFFF;78586F=FFFFFF;C8FFBE=000000;EDFFAB=000000;BA9593=FFFFFF;EBEBD3=000000;DA4167=FFFFFF;F78764=FFFFFF").split(";");
							for(int n=0;n<colors.length;n++){
								out.println("<option "+((colors[n]).equalsIgnoreCase(appointment.getColor())?"selected":"")+" value='"+colors[n]+"' style='background-color: #"+colors[n].split("=")[0]+";color: #"+colors[n].split("=")[1]+"'>"+ScreenHelper.padLeft(n+"", "&nbsp;", 6)+"</option>");
							}
						%>
					</select>
				</td>
			</tr>
		</table>
		<center>
			<input type='button' onclick='window.close()' name='closeButton' class='button' value='<%=getTranNoLink("web","cancel",sWebLanguage) %>'/>
			<input type='button' onclick='doSave();' name='saveButton' class='button' value='<%=getTranNoLink("web","save",sWebLanguage) %>'/>
			<input type='submit' name='deleteButton' class='button' value='<%=getTranNoLink("web","delete",sWebLanguage) %>'/>
			<input type='hidden' name='actionField' id='actionField'/>
		</center>
	</form>
<%
	}
	else{
%>
<%-- TABS ---------------------------------------------------------------------------%>
	<form name='transactionForm' id='transactionForm' action="<%=sCONTEXTPATH %>/popup.jsp?Page=calendar/editEvent.jsp" method='POST'>
		<input type='hidden' name='setseen' id='setseen' value=''/>
		<input type='hidden' name='fullDay' id='fullDay' value='<%=appointment.getFullDay() %>'/>
		<input type='hidden' name='id' id='id' value='<%=appointment.getUid()%>'/>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		    <tr>
		        <td class='tabs' width='5'>&nbsp;</td>
		        <td class='tabselected' width="1%" onclick="activateTab2('Main')" id="td0_1" nowrap>&nbsp;<b><%=getTran(request,"web","main",sWebLanguage)%></b>&nbsp;</td>
		        <td class='tabs' width='5'>&nbsp;</td>
		        <td class='tabunselected' width="1%" onclick="activateTab2('Extended')" id="td1_1" nowrap>&nbsp;<b><%=getTran(request,"web","resources",sWebLanguage)%></b>&nbsp;</td>
		        <td width="*" class='tabs'>&nbsp;</td>
		    </tr>
		</table>
		<table style="vertical-align:top;" width="100%" border="0" cellspacing="0" cellpadding="0">
		    <tr id="tr0_1-view" style="display:">
		    	<td>
					<!-- TAB 1: Main screen -->
					<table width='100%'>
						<tr class='admin'>
							<td colspan='2'><%=getTran(request,"web","appointment",sWebLanguage) %></td>
						</tr>
						<tr>
							<td class='admin'><%=getTran(request,"web","begin",sWebLanguage) %></td>
							<td class='admin2'>
								<%=ScreenHelper.writeDateField("begin","transactionForm",ScreenHelper.formatDate(appointment.getPlannedDate()),false,true,sWebLanguage,sCONTEXTPATH) %>
								<select class='text' name='beginhour' id='beginhour'>
									<%
										for(int n=0;n<24;n++){
											out.println("<option value='"+n+"' "+(appointment.getPlannedDate().getHours()==n?"selected":"")+">"+ScreenHelper.padLeft(n+"","0",2)+"</option>");
										}
									%>
								</select>:
								<select class='text' name='beginminutes' id='beginminutes'>
									<%
										for(int n=0;n<60;n+=5){
											out.println("<option value='"+n+"' "+(appointment.getPlannedDate().getMinutes()==n?"selected":"")+">"+ScreenHelper.padLeft(n+"","0",2)+"</option>");
										}
									%>
								</select>
							</td>
						</tr>
						<tr>
							<td class='admin'><%=getTran(request,"web","end",sWebLanguage) %></td>
							<td class='admin2'>
								<%=ScreenHelper.writeDateField("end","transactionForm",ScreenHelper.formatDate(appointment.getPlannedEndDate()),false,true,sWebLanguage,sCONTEXTPATH) %>
								<select class='text' name='endhour' id='endhour'>
									<%
										for(int n=0;n<24;n++){
											out.println("<option value='"+n+"' "+(appointment.getPlannedEndDate()!=null && appointment.getPlannedEndDate().getHours()==n?"selected":"")+">"+ScreenHelper.padLeft(n+"","0",2)+"</option>");
										}
									%>
								</select>:
								<select class='text' name='endminutes' id='endminutes'>
									<%
										for(int n=0;n<60;n+=5){
											out.println("<option value='"+n+"' "+(appointment.getPlannedEndDate()!=null && appointment.getPlannedEndDate().getMinutes()==n?"selected":"")+">"+ScreenHelper.padLeft(n+"","0",2)+"</option>");
										}
									%>
								</select>
							</td>
						</tr>
						<tr>
							<td class='admin'><%=getTran(request,"web.occup","medwan.common.seen",sWebLanguage) %></td>
							<td class='admin2'>
								<%=ScreenHelper.writeDateField("visited","transactionForm",ScreenHelper.formatDate(appointment.getEffectiveDate()),false,true,sWebLanguage,sCONTEXTPATH) %>
								<select class='text' name='visitedhour' id='visitedhour'>
									<option/>
									<%
										for(int n=0;n<24;n++){
											out.println("<option value='"+n+"' "+(appointment.getEffectiveDate()!=null && appointment.getEffectiveDate().getHours()==n?"selected":"")+">"+ScreenHelper.padLeft(n+"","0",2)+"</option>");
										}
									%>
								</select>:
								<select class='text' name='visitedminutes' id='visitedminutes'>
									<option/>
									<%
										for(int n=0;n<60;n++){
											out.println("<option value='"+n+"' "+(appointment.getEffectiveDate()!=null && appointment.getEffectiveDate().getMinutes()==n?"selected":"")+">"+ScreenHelper.padLeft(n+"","0",2)+"</option>");
										}
									%>
								</select>
								<img style='vertical-align: -3px' src='<%=sCONTEXTPATH %>/_img/icons/icon_compose.png' onclick='setVisitNow()'/>
							</td>
						</tr>
						<tr>
							<td class='admin'><%=getTran(request,"web","patient",sWebLanguage) %></td>
							<td class='admin2'>
								<input type='hidden' name='patientid' id='patientid' value='<%=appointment.getPatientUID() %>'/>
								<input type='text' class='text' size='30' name='patientname' id='patientname' readonly value='<%=appointment.getPatient()==null?"":appointment.getPatient().getFullName()%>'/>
								<img style='vertical-align: middle' src='<%=sCONTEXTPATH %>/_img/icons/icon_search.png' onclick='showSearchPatientPopup("patientid","patientname")'/>
								<img style='vertical-align: middle' src='<%=sCONTEXTPATH %>/_img/icons/icon_delete.png' onclick='document.getElementById("patientid").value="";document.getElementById("patientname").value="";checkOpenRecordButton();'/>
								<img style='vertical-align: middle' height='16px' src='<%=sCONTEXTPATH %>/_img/icons/mobile/admin.png' onclick='document.getElementById("patientid").value="<%=activePatient==null?"":activePatient.personid %>";document.getElementById("patientname").value="<%=activePatient==null?"":activePatient.getFullName() %>";document.getElementById("openButton").style.display="none";setOccupied();'/>
								<%
									String sPhone = "";
									if(appointment.getPatient()!=null && appointment.getPatient().isNotEmpty()){
										AdminPerson p = appointment.getPatient();
										if(p.getActivePrivate()!=null){
											sPhone=checkString(p.getActivePrivate().telephone);
											if(sPhone.length()==0 && checkString(p.getActivePrivate().mobile).length()>0){
												sPhone=checkString(p.getActivePrivate().mobile);
											}
											else if(checkString(p.getActivePrivate().mobile).length()>0){
												sPhone+=" - "+checkString(p.getActivePrivate().mobile);
											}
										}
									}
								%>
								<br/><span id='telephone'><b><%=sPhone %></b></span>
							</td>
						</td>
						<tr>
							<td class='admin'><%=getTran(request,"appointment","comment",sWebLanguage) %></td>
							<td class='admin2'>
								<input type='text' class='text' name='comment' id='comment' size="30" maxlength="255" value='<%=checkString(appointment.getComment())%>'/>
							</td>
						</tr>
						<tr>
							<td class='admin'><%=getTran(request,"web","user",sWebLanguage) %></td>
							<td class='admin2'>
								<input type='hidden' name='userid' id='userid' value='<%=appointment.getUserUID() %>'/>
								<input type='text' class='text' size='30' name='username' id='username' readonly value='<%=appointment.getUser().getFullName()%>'/>
								<img style='vertical-align: middle' src='<%=sCONTEXTPATH %>/_img/icons/icon_search.png' onclick='showSearchUserPopup("userid","username")'/>
								<img style='vertical-align: middle' src='<%=sCONTEXTPATH %>/_img/icons/icon_delete.png' onclick='document.getElementById("userid").value="";document.getElementById("username").value="";'/>
							</td>
						</td>
						<tr>
							<td class='admin'><%=getTran(request,"web","type",sWebLanguage) %></td>
							<td class='admin2'>
								<select class='text' name='type' id='type'>
									<option/>
									<%=ScreenHelper.writeSelect(request,"appointment.types",appointment.getType(),sWebLanguage) %>
								</select>
							</td>
						</tr>
						<tr>
							<td class='admin'><%=getTran(request,"web","location",sWebLanguage) %></td>
							<td class='admin2'>
								<select class='text' name='location' id=location>
									<option/>
									<%=ScreenHelper.writeSelect(request,"appointment.location",appointment.getLocation(),sWebLanguage) %>
								</select>
							</td>
						</tr>
						<tr>
							<td class='admin'><%=getTran(request,"web","color",sWebLanguage) %></td>
							<td class='admin2'>
								<select class='minitext' name='color' id='color' onchange='this.style.backgroundColor=this.options[this.selectedIndex].style.backgroundColor;this.style.color=this.options[this.selectedIndex].style.color;'>
									<option style='background-color: #FFFFFF; color: #000000'>Auto</option>
									<%
										String[] colors = MedwanQuery.getInstance().getConfigString("agendaColors","E6C79C=000000;CDDFA0=000000;6FD08C=000000;7B9EA8=FFFFFF;78586F=FFFFFF;C8FFBE=000000;EDFFAB=000000;BA9593=FFFFFF;EBEBD3=000000;DA4167=FFFFFF;F78764=FFFFFF").split(";");
										for(int n=0;n<colors.length;n++){
											out.println("<option "+((colors[n]).equalsIgnoreCase(appointment.getColor())?"selected":"")+" value='"+colors[n]+"' style='background-color: #"+colors[n].split("=")[0]+";color: #"+colors[n].split("=")[1]+"'>"+ScreenHelper.padLeft(n+"", "&nbsp;", 6)+"</option>");
										}
									%>
								</select>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr id="tr1_1-view" style="display:none">
				<!-- TAB 2: Extended screen -->
				<td>
					<table width='100%'>
						<tr>
							<td class='admin'><%=getTran(request,"web","resource",sWebLanguage) %></td>
							<td class='admin2'>
								<input type='hidden' name='resourceid' id='resourceid' value='<%=resourceid%>'/>
								<input type='text' class='text' name='resourcename' id='resourcename' value='<%=resourcename%>' size='30' readonly/>
				                <img style='vertical-align: middle' src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchNomenclature('resourceid','resourcename');">
				                <img style='vertical-align: middle' src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="document.getElementById('resourceid').value='';document.getElementById('resourcename').value='';">
								<input type='button' class='button' name='addResourceButton' value='<%=getTran(request,"web","add",sWebLanguage) %>' onclick='addResource();'/>
							</td>
						</tr>
						<tr>
							<td colspan='2'>
								<div id='resourcelist'></div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		
		<center>
			<input type='button' onclick='window.close()' name='closeButton' class='button' value='<%=getTranNoLink("web","cancel",sWebLanguage) %>'/>
			<input type='button' onclick='doSave();' name='saveButton' class='button' value='<%=getTranNoLink("web","save",sWebLanguage) %>'/>
			<input type='submit' name='deleteButton' class='button' value='<%=getTranNoLink("web","delete",sWebLanguage) %>'/>
			<input style='display: none' type='button' onclick='openRecord()' name='openButton' id='openButton' class='button' value='<%=getTranNoLink("web","dossier",sWebLanguage) %>'/>
			<input type='hidden' name='actionField' id='actionField'/>
		</center>
		<p/>
		<center><div id='waiter'></div></center>
	</form>
<%
	}
%>

<script>
	function doSave(){
		document.getElementById('actionField').value='save';
		if(document.getElementById('resourceid') && document.getElementById('resourceid').value.length>0){
			addResource(true); //true means that after adding the resource, the form is submitted
		}
		else{
			transactionForm.submit();
		}
	}

	function activateTab2(sTab){
	
	    document.getElementById('tr0_1-view').style.display = 'none';
	    td0_1.className="tabunselected";
	    if(sTab=='Main'){
	      document.getElementById('tr0_1-view').style.display = '';
	      td0_1.className="tabselected";
	    }
	
	    document.getElementById('tr1_1-view').style.display = 'none';
	    td1_1.className="tabunselected";
	    if(sTab=='Extended'){
	      document.getElementById('tr1_1-view').style.display = '';
	      td1_1.className="tabselected";
	    }
	}
	
	function openRecord(){
		if(document.getElementById('visited').value.length==0 && window.confirm('<%=getTranNoLink("web","registerappointmentasseen",sWebLanguage)%>')){
			window.opener.parent.location.href='<%=sCONTEXTPATH%>/main.do?Page=curative/index.jsp&PersonID='+document.getElementById('patientid').value;
			document.getElementById('setseen').value=document.getElementById('id').value;
			document.getElementById('waiter').innerHTML='<img height="14px" src="<%=sCONTEXTPATH%>/_img/themes/default/ajax-loader.gif"/>';
			window.setTimeout('transactionForm.submit();',1000);
		}
		else{
			window.opener.parent.location.href='<%=sCONTEXTPATH%>/main.do?Page=curative/index.jsp&PersonID='+document.getElementById('patientid').value;
			window.close();
		}
	}

	function checkOpenRecordButton(){
		if(document.getElementById('id').value*1>0 && document.getElementById('patientid').value.length>0 && document.getElementById('patientid').value*1>0){
			document.getElementById('openButton').style.display='';
		}
		else{
			document.getElementById('openButton').style.display='none';
		}
		setOccupied();
	}
	
	function setOccupied(){
		if(document.getElementById('patientid').value*1>0 && document.getElementById('type').value=='medwan.common.free'){
			document.getElementById('type').selectedIndex=0;
		}
	}
	
	function setVisitNow(){
		var date = new Date();
		document.getElementById('visited').value=date.getDate()+"/"+(date.getMonth()+1)+"/"+date.getFullYear();
		var hours = date.getHours();
		if(hours.length<2){
			hours="0"+hours;
		}
		document.getElementById('visitedhour').value=hours;
		var minutes = date.getMinutes();
		if(minutes.length<2){
			minutes="0"+minutes;
		}
		document.getElementById('visitedminutes').value=minutes;
	}
	
	function showSearchPatientPopup(pid,personName){
	  	var url = "<c:url value="/popup.jsp?Page=_common/search/searchPatient.jsp"/>&ts=<%=getTs()%>&PopupWidth=600&PopupHeight=400"+
	            "&ReturnPersonID="+pid+
	            "&ReturnName="+personName+
	            "&displayImmatNew=yes"+
	            "&isUser=false"+
	            "&ReturnFunction=checkOpenRecordButton()"+
	            "&IncludedDossiersSelectable=false";
	
	  	window.open(url,"searchPatientPopup","height=1,width=1,toolbar=no,status=no,scrollbars=no,resizable=no,menubar=no");
	}

	function showSearchUserPopup(pid,personName){
	  	var url = "<c:url value="/popup.jsp?Page=_common/search/searchUser.jsp"/>&ts=<%=getTs()%>&PopupWidth=600&PopupHeight=400"+
	              "&ReturnUserID="+pid+
	              "&ReturnName="+personName;
	
	  	window.open(url,"searchUserPopup","height=1,width=1,toolbar=no,status=no,scrollbars=no,resizable=no,menubar=no");
	}

	if(document.getElementById('tr1_1-view')){
		loadResourceList();
	}
	
    function searchNomenclature(CategoryUidField,CategoryNameField){
	    openPopup("/_common/search/searchCalendarResource.jsp&ts=<%=getTs()%>&begin=<%=new SimpleDateFormat("yyyyMMddHHmmss").format(appointment.getPlannedDate())%>&end=<%=new SimpleDateFormat("yyyyMMddHHmmss").format(appointment.getPlannedEndDate())%>&FindType=calendarresource&VarCode="+CategoryUidField+"&VarText="+CategoryNameField);
	}
    
    function loadResourceList(){
    	document.getElementById('resourcelist').innerHTML="<img height='14px' src='<%=sCONTEXTPATH%>/_img/themes/default/ajax-loader.gif'/>";
	    var params = "id=<%=appointment.getUid()%>";
		var url = "<%=sCONTEXTPATH%>/calendar/loadResources.jsp";
		new Ajax.Request(url,{
		method: "POST",
		parameters: params,
		onSuccess: function(resp){
			document.getElementById('resourcelist').innerHTML=resp.responseText;
		}
		});
    }
    
    function addResource(bSubmit){
    	if(document.getElementById('resourceid').value.length>0){
    	    var params = "id=<%=appointment.getUid()%>&resourceid="+document.getElementById('resourceid').value;
    		var url = "<%=sCONTEXTPATH%>/calendar/addResource.jsp";
    		new Ajax.Request(url,{
    		method: "POST",
    		parameters: params,
    		onSuccess: function(resp){
    			document.getElementById('resourceid').value='';
    			document.getElementById('resourcename').value='';
    			loadResourceList();
    			if(bSubmit){
    				transactionForm.submit();
    			}
    		}
    		});
    	}
    }

    function removeResource(resourceid,id){
   	    var params = "id="+id+"&resourceid="+resourceid;
   		var url = "<%=sCONTEXTPATH%>/calendar/deleteResource.jsp";
   		new Ajax.Request(url,{
   		method: "POST",
   		parameters: params,
   		onSuccess: function(resp){
   			loadResourceList();
   		}
   		});
    }


	document.getElementById('color').onchange();
	checkOpenRecordButton();
</script>