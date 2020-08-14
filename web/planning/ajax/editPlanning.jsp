<%@page import="be.openclinic.finance.*"%>
<%@ page import="be.openclinic.adt.Planning,be.dpms.medwan.common.model.vo.occupationalmedicine.ExaminationVO" %>
<%@ page import="java.util.*" %>
<%@ page import="be.mxs.common.util.system.HTMLEntities" %>
<%@ page import="java.util.Date" %>
<%@ page import="be.openclinic.pharmacy.Product" %>
<%@include file="/includes/validateUser.jsp" %>
<%=checkPermission(out,"planning", "select", activeUser)%><%!
    //--- INITIALIZE CALENDAR ---------------------------------------------------------------------
    private Calendar initializeCalendar(String sDate, int iHour){
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(ScreenHelper.getSQLDate(sDate));
        calendar.set(Calendar.HOUR_OF_DAY, iHour);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 00);
        calendar.set(Calendar.MILLISECOND, 00);
        return calendar;
    }
    private boolean setDates(Planning planning, HttpServletRequest request, int[]defaultDates) throws Exception {
       boolean bRefresh = false; // variable to refresh if fout with date
       try{
            String sPlanningDateDay = checkString(request.getParameter("appointmentDateDay")),
                   sPlanningDateHour = checkString(request.getParameter("appointmentDateHour")),
                   sPlanningDateMinutes = checkString(request.getParameter("appointmentDateMinutes"));
            
            // set appointment End date
            String sPlanningDateEndDay = checkString(request.getParameter("appointmentDateEndDay")),
                   sPlanningDateEndHour = checkString(request.getParameter("appointmentDateEndHour")),
                   sPlanningDateEndMinutes = checkString(request.getParameter("appointmentDateEndMinutes"));

            int defaultBeginHour = defaultDates[0];
            int defaultBeginMin = defaultDates[1];
            int defaultEndHour = defaultDates[2];
            int defaultEndMin = defaultDates[3];

            // date control
            if(Integer.parseInt(sPlanningDateEndHour)>defaultEndHour){
                sPlanningDateEndHour = defaultEndHour+"";
                sPlanningDateEndMinutes = defaultEndMin+"";
                bRefresh = true;
            }else if((Integer.parseInt(sPlanningDateEndHour)==defaultEndHour)&&(Integer.parseInt(sPlanningDateEndMinutes)>0 && defaultEndMin==0)){
                sPlanningDateEndMinutes = "0";
                bRefresh = true;
            }else if((Integer.parseInt(sPlanningDateEndHour)==defaultEndHour) && (Integer.parseInt(sPlanningDateEndMinutes) >defaultEndMin )){
                sPlanningDateEndMinutes = defaultEndMin+"";
                bRefresh = true;
            }

            if((Integer.parseInt(sPlanningDateHour)==defaultBeginHour)&& Integer.parseInt(sPlanningDateMinutes)<defaultBeginMin){
                sPlanningDateMinutes = defaultBeginMin+"";
                bRefresh = true;
            }

            Date beginDate = ScreenHelper.fullDateFormat.parse(sPlanningDateDay+" "+sPlanningDateHour+":"+sPlanningDateMinutes),
                 endDate = ScreenHelper.fullDateFormat.parse(sPlanningDateDay+" "+sPlanningDateEndHour+":"+sPlanningDateEndMinutes);
                 
            if(beginDate.compareTo(endDate)>-1){
                // set begin date -5 min of end date if begin date is after the default end date
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(endDate);
                calendar.add(Calendar.MINUTE,-5);
                beginDate = calendar.getTime();
            }
            planning.setPlannedDate(beginDate);
            planning.setPlannedEndDate(endDate);

            long minutes = ((endDate.getTime()-planning.getPlannedDate().getTime())/1000)/60;
            if(minutes>55){
                  planning.setEstimatedtime((minutes/60+":"+(minutes-((minutes/60)*60))));
            }else{
                   planning.setEstimatedtime("00:"+minutes);
           }
       }catch(Exception e){
    	   e.printStackTrace();
           Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
       }
       return bRefresh;
    }
%>
<%
	try{
    String sAction = checkString(request.getParameter("Action"));
    String sFindPlanningUID = checkString(request.getParameter("FindPlanningUID"));
    String sPage = checkString(request.getParameter("Page"));
    String sFindUserUID = checkString(request.getParameter("FindUserUID"));
    String sFindServiceUID = checkString(request.getParameter("FindServiceUID"));
    String sEstimatedTime = "";
    boolean show = false;
    String appointmentDateDay = "", appointmentDateHour = "", appointmentDateMinutes = "",
            appointmentDateEndDay = "", appointmentDateEndHour = "", appointmentDateEndMinutes = "";
    Planning planning = null;
    String sInterval = checkString(activeUser.getParameter("PlanningFindInterval"));
    if (sInterval.length() == 0){
        sInterval = 30+"";
    }
    String sFrom = checkString(activeUser.getParameter("PlanningFindFrom"));
    if (sFrom.length() == 0){
        sFrom = "8";
    }
    String sUntil = checkString(activeUser.getParameter("PlanningFindUntil"));
    if (sUntil.length() == 0){
        sUntil = "20";
    }

    int startHourOfWeekPlanner = Double.valueOf(Math.floor(Float.parseFloat(sFrom.replace(",",".")))).intValue();    // Start hour of week planner
    int endHourOfWeekPlanner = Double.valueOf(Math.floor(Float.parseFloat(sUntil.replace(",",".")))).intValue();    // End hour of weekplanner.
    int startMinOfWeekPlanner = (sFrom.split("\\.").length>1)?Integer.parseInt(sFrom.split("\\.")[1]):0;
    int endMinOfWeekPlanner = (sUntil.split("\\.").length>1)?Integer.parseInt(sUntil.split("\\.")[1]):0;


    if (sAction.equalsIgnoreCase("save")){
    	//First check if overlap is allowed
        String sEditUserUID = checkString(request.getParameter("EditUserUID123"));
        String sEditPlanningUID = checkString(request.getParameter("EditPlanningUID"));
    	boolean bOverlapProhibited=false;
    	if(checkString(activeUser.getParameter("PlanningDoubleBookingProhibited")).equalsIgnoreCase("1")){
    		java.util.Date start = new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(request.getParameter("appointmentDateDay")+" "+request.getParameter("appointmentDateHour")+":"+request.getParameter("appointmentDateMinutes"));
    		java.util.Date end = new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(request.getParameter("appointmentDateDay")+" "+request.getParameter("appointmentDateEndHour")+":"+request.getParameter("appointmentDateEndMinutes"));
    		bOverlapProhibited=!Planning.isAvailablePlannedDate(sEditUserUID, start,end,sEditPlanningUID);
    	}
    	if(!bOverlapProhibited){
	        try {
	            //####################### IF APPOINTMENT TO SAVE ###################################//
	            String sEditEstimatedtime = checkString(request.getParameter("EditEstimatedtime"));
	            String sEditConfirmationDate = checkString(request.getParameter("EditConfirmationDate"));
	            String sEditEffectiveDate = checkString(request.getParameter("EditEffectiveDate"))+" "+checkString(request.getParameter("EditEffectiveDateTime"));
	            String sEditCancelationDate = checkString(request.getParameter("EditCancelationDate"))+" "+checkString(request.getParameter("EditCancelationDateTime"));
	            String sEditPatientUID = checkString(request.getParameter("EditPatientUID"));
	            String sEditTransactionUID = checkString(request.getParameter("EditTransactionUID"));
	            String sEditContactType = checkString(request.getParameter("EditContactType"));
	            String sEditContactUID = checkString(request.getParameter("EditContactUID"));
	            String sEditDescription = checkString(request.getParameter("EditDescription"));
	            String sEditComment = checkString(request.getParameter("EditComment"));
	            String sEditContext = checkString(request.getParameter("EditContext"));
	            String sEditServiceUID = checkString(request.getParameter("EditServiceUID"));
	            String tempplanninguid = checkString(request.getParameter("tempplanninguid"));
	            String sEditRepeatUntil = checkString(request.getParameter("appointmentRepeatUntil"));
	            String sEditPreparationDate = checkString(request.getParameter("EditPreparationDate"));
	            String sEditAdmissionDate = checkString(request.getParameter("EditAdmissionDate"));
	            String sEditOperationDate = checkString(request.getParameter("EditOperationDate"));
	            String sEditReportingPlace = checkString(request.getParameter("EditReportingPlace"));
	            String sEditSurgeon = checkString(request.getParameter("EditSurgeon"));
	            String sEditNoshow=checkString(request.getParameter("EditNoshow"));
	            java.util.Date dRepeatUntil = null;
	            try{
	            	if(sEditRepeatUntil.length()>0){
	            		dRepeatUntil=ScreenHelper.parseDate(sEditRepeatUntil);
	            	}
	            }
	            catch(Exception e){
	            	e.printStackTrace();
	            }
	            if(sEditPlanningUID.length()>0 && sEditPlanningUID.split("\\.").length==2){
	            	planning=Planning.get(sEditPlanningUID);
	            }
	            else{
		            planning = new Planning();
	            }
	            planning.setUid(sEditPlanningUID);
	            planning.setEstimatedtime(sEditEstimatedtime);
				try{
		            planning.setEffectiveDate(ScreenHelper.fullDateFormat.parse(sEditEffectiveDate));
				}
				catch(Exception e){};
				try{
		            planning.setCancelationDate(ScreenHelper.fullDateFormat.parse(sEditCancelationDate));
				}
				catch(Exception e){};
				try{
		            planning.setConfirmationDate(ScreenHelper.parseDate(sEditConfirmationDate));
				}
				catch(Exception e){};
	            planning.setUserUID(sEditUserUID);
				planning.setUpdateUser(activeUser.userid);
	            planning.setPatientUID(sEditPatientUID);
	            planning.setTransactionUID(sEditTransactionUID);
	            planning.setContextID(sEditContext);
	            setDates(planning, request,new int[]{startHourOfWeekPlanner,startMinOfWeekPlanner,endHourOfWeekPlanner,endMinOfWeekPlanner});
	            ObjectReference orContact = new ObjectReference();
	            orContact.setObjectType(sEditContactType);
	            orContact.setObjectUid(sEditContactUID);
	            planning.setContact(orContact);
	            planning.setDescription(sEditDescription);
	            planning.setComment(sEditComment);
	            planning.setTempPlanningUid(tempplanninguid);
            	planning.setServiceUid(sEditServiceUID);
            	planning.setPreparationDate(sEditPreparationDate);
            	planning.setAdmissionDate(sEditAdmissionDate);
            	planning.setOperationDate(sEditOperationDate);
            	planning.setReportingPlace(sEditReportingPlace);
            	planning.setSurgeon(sEditSurgeon);
            	if(sEditNoshow.equalsIgnoreCase("true")){
            		planning.setNoshow("1");
            	}
            	else{
            		planning.setNoshow("0");
            	}
	            boolean bError=false;
	            if(dRepeatUntil!=null && dRepeatUntil.after(planning.getPlannedDate())){
	            	//Repeatedly store this planning for each day in the period
	            	while(!ScreenHelper.parseDate(ScreenHelper.formatDate(planning.getPlannedDate())).after(dRepeatUntil)){
	            		planning.setUid(null);
	            		bError=!planning.store();
	            		if(bError){
	            			break;
	            		}
	            		else{
	            			planning.setPlannedDate(new java.util.Date(planning.getPlannedDate().getTime()+24*3600*1000));
	            		}
	            	}
	            }
	            else{
	            	bError=!planning.store();
	            }
	            if(!bError){
	            	//Also 
	                if(sPage.length()==0){
	                    out.write("<script>clientMsg.setValid('"+HTMLEntities.htmlentities(getTranNoLink("web.control","dataissaved",sWebLanguage))+"',null,500);doClose();</script>");
	                }
	                else{
	                    out.write("<script>window.location.reload(true);Modalbox.hide();</script>");
	                }
	            }
	            else{
	                if(sPage.length()==0){
	                    out.write("<script>clientMsg.setError('"+HTMLEntities.htmlentities(getTranNoLink("web.control","dberror",sWebLanguage))+"');</script>");
	                }
	                else{
	                    if(sPage.length()==0){
	                        out.write("<script>alert('"+HTMLEntities.htmlentities(getTranNoLink("web.control","dberror",sWebLanguage))+"');</script>");                        
	                    }
	                }
	            }
	
	        }
	        catch (Exception e2){
	            Debug.printProjectErr(e2, Thread.currentThread().getStackTrace());
	        }
    	}
    	else{
    		out.println("<script>alert('"+getTran(request,"web","overlapnotallowed",sWebLanguage)+"');</script>");
    	}
    } 
    else if (sAction.equalsIgnoreCase("delete")){
        String sEditPlanningUID = checkString(request.getParameter("AppointmentID"));
        Planning.delete(sEditPlanningUID);
        if(sPage.length()==0){
            out.write("<script>clientMsg.setValid('"+HTMLEntities.htmlentities(getTranNoLink("web","dataisdeleted",sWebLanguage))+"',null,1000);doClose();</script>");
        }else{
            out.write("<script>doClose();window.location.reload(true);</script>");
        }
    } 
    else if (sAction.equalsIgnoreCase("update")){
        String sEditPlanningUID = checkString(request.getParameter("AppointmentID"));
        Planning p = Planning.get(sEditPlanningUID);
        planning = new Planning();
        // set appointment date
        boolean bRefresh = setDates(planning, request,new int[]{startHourOfWeekPlanner,startMinOfWeekPlanner,endHourOfWeekPlanner,endMinOfWeekPlanner});
    	boolean bOverlapProhibited=false;
    	if(checkString(activeUser.getParameter("PlanningDoubleBookingProhibited")).equalsIgnoreCase("1")){
    		bOverlapProhibited=!Planning.isAvailablePlannedDate(p.getUserUID(), planning.getPlannedDate(),planning.getPlannedEndDate(),sEditPlanningUID);
    	}
    	if(!bOverlapProhibited){
	        //####################### IF TO APPOINTMENT DATE UPDATE ###################################//
	        try {
	            if(planning.updateDate(sEditPlanningUID)){
	                out.write("<script>clientMsg.setValid('"+HTMLEntities.htmlentities(getTranNoLink("web.control","dataissaved",sWebLanguage))+"',null,1000);"+((bRefresh)?"refreshAppointments();":"")+"</script>");
	            }
	        }
	        catch (Exception e){
	            out.write("<script>clientMsg.setError('"+HTMLEntities.htmlentities(getTranNoLink("web.control","dberror",sWebLanguage))+"');</script>");
	            Debug.printProjectErr(e, Thread.currentThread().getStackTrace());
	        }
    	}
    	else{
    		out.println("<script>alert('"+getTran(request,"web","overlapnotallowed",sWebLanguage)+"');refreshAppointments();</script>");
    	}
    } 
    else if (sAction.equalsIgnoreCase("new")){
    	boolean bAllowed=true;
    	if(MedwanQuery.getInstance().getConfigInt("negativePatientBalanceAllowedForAppointments",1)==0){
			if(activePatient!=null){
	    		Balance balance = Balance.getActiveBalance(activePatient.personid);
	    		double saldo = Balance.getPatientBalance(activePatient.personid);
	    		if(saldo<balance.getMinimumBalance()){
	    			out.println("<script>alert('"+getTranNoLink("web","notpermittedwithnegativebalance",sWebLanguage)+"');doClose();</script>");
	    			out.flush();
	    			bAllowed=false;
	    		}
			}
    	}
		if(bAllowed){
	        //####################### IF NEW APPOINTMENT ###################################//
	        planning = new Planning();
	        planning.setServiceUid(sFindServiceUID);
	        if(activePatient!=null){
	            planning.setPatientUID(activePatient.personid);
	            planning.setPatient(activePatient);
	        }
	        planning.setUserUID(sFindUserUID);
	
	        if(Integer.parseInt(planning.getUserUID())<=0){
	            planning.setUserUID(activeUser.userid);
	        }
	        setDates(planning, request,new int[]{startHourOfWeekPlanner,startMinOfWeekPlanner,endHourOfWeekPlanner,endMinOfWeekPlanner});
	     
	        // appointment date
	        if (planning.getPlannedDate()!=null){
	            appointmentDateDay = ScreenHelper.formatDate(planning.getPlannedDate());
	            appointmentDateHour = new SimpleDateFormat("HH").format(planning.getPlannedDate());
	            appointmentDateMinutes = new SimpleDateFormat("mm").format(planning.getPlannedDate());
	        } else {
	            appointmentDateDay = "";
	            appointmentDateHour = new SimpleDateFormat("HH").format(sFrom+"");
	            appointmentDateMinutes = "";
	        }
	        // appointment edn date
	        planning.setPlannedEndDate();
	        if (planning.getPlannedEndDate()!=null){
	            appointmentDateEndDay = ScreenHelper.formatDate(planning.getPlannedEndDate());
	            appointmentDateEndHour = new SimpleDateFormat("HH").format(planning.getPlannedEndDate());
	            appointmentDateEndMinutes = new SimpleDateFormat("mm").format(planning.getPlannedEndDate());
	        }
	        else {
	            appointmentDateEndDay = appointmentDateDay;
	            appointmentDateEndHour = appointmentDateHour;
	            appointmentDateEndMinutes = appointmentDateMinutes;
	        }
	
	        show = true;
		}
    } 
    else if (sFindPlanningUID.length() > 0){
        //####################### IF EXISTS APPOINTMENT ###################################//
        planning = Planning.get(sFindPlanningUID);
        // appointment date
        if (planning.getPlannedDate()!=null){
            appointmentDateDay = ScreenHelper.formatDate(planning.getPlannedDate());
            appointmentDateHour = new SimpleDateFormat("HH").format(planning.getPlannedDate());
            appointmentDateMinutes = new SimpleDateFormat("mm").format(planning.getPlannedDate());
        }
        else {
            appointmentDateDay = "";
            appointmentDateHour = new SimpleDateFormat("HH").format(sFrom+"");
            appointmentDateMinutes = "";
        }
        // appointment edn date
        if (planning.getPlannedEndDate()!=null){
            appointmentDateEndDay = ScreenHelper.formatDate(planning.getPlannedEndDate());
            appointmentDateEndHour = new SimpleDateFormat("HH").format(planning.getPlannedEndDate());
            appointmentDateEndMinutes = new SimpleDateFormat("mm").format(planning.getPlannedEndDate());
        }
        else {
            appointmentDateEndDay = appointmentDateDay;
            appointmentDateEndHour = appointmentDateHour;
            appointmentDateEndMinutes = appointmentDateMinutes;
        }
        
        show = true;
    }
    
    if (show){
%>

<%-- TABS ---------------------------------------------------------------------------%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2('Main')" id="td0_1" nowrap>&nbsp;<b><%=getTran(request,"Web","main",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2('Extended')" id="td1_1" nowrap>&nbsp;<b><%=getTran(request,"Web","extended",sWebLanguage)%></b>&nbsp;</td>
        <td width="*" class='tabs'>&nbsp;</td>
    </tr>
</table>

<table style="vertical-align:top;" width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr id="tr0_1-view" style="display:none">
    	<td>
			<!-- TAB 1: Main screen -->
			<table class='list' border='0' width='630' cellspacing='1'>
			    <tr>
			        <td width="<%=sTDAdminWidth%>" class="admin"><%=HTMLEntities.htmlentities(getTran(request,"planning", "planneddate", sWebLanguage))%>*</td>
			        <td class="admin2">
			            <%-- hour --%> <select id="appointmentDateHour" name="appointmentDateHour" class="text" onchange="updateSelect();">
			            <%
			                for (int n = startHourOfWeekPlanner; n <= endHourOfWeekPlanner; n++){
			                out.print("<option value='"+(n < 10 ? "0"+n : ""+n)+"' ");
			                if (appointmentDateHour.length() > 0 && n == Integer.parseInt(appointmentDateHour)){
			                    out.print("selected");
			                }
			                out.print(">"+(n < 10 ? "0"+n : ""+n)+"</option>");
			            }%>
			        </select> <%-- minutes --%>
			         <select id="appointmentDateMinutes" name="appointmentDateMinutes" class="text">
			            <%for (int n = 0; n < 60; n=n+5){
			                out.print("<option value='"+(n < 10 ? "0"+n : ""+n)+"' ");
			                if (appointmentDateMinutes.length() > 0 && n == Integer.parseInt(appointmentDateMinutes)){
			                    out.print("selected");
			                }
			                out.print(">"+(n < 10 ? "0"+n : ""+n)+"</option>");
			            }%>
			        </select><%=getTran(request,"Web.occup", "medwan.common.hour", sWebLanguage)%>&nbsp;<%=ScreenHelper.planningDateTimeField("appointmentDateDay", appointmentDateEndDay, sWebLanguage, sCONTEXTPATH)%>
			        </td>
			    </tr>
			   <tr>
			        <td class="admin"><%=HTMLEntities.htmlentities(getTran(request,"web.hrm", "until", sWebLanguage))%>
			        </td>
			        <td class="admin2">
			            <%-- hour --%> <select id="appointmentDateEndHour" name="appointmentDateEndHour" class="text" onchange="updateSelect();">
			            <%for (int n = startHourOfWeekPlanner; n <= endHourOfWeekPlanner; n++){
			                out.print("<option value='"+(n < 10 ? "0"+n : ""+n)+"' ");
			                if (appointmentDateEndHour.length() > 0 && n == Integer.parseInt(appointmentDateEndHour)){
			                    out.print("selected");
			                }
			                out.print(">"+(n < 10 ? "0"+n : ""+n)+"</option>");
			            }%>
			        </select> <%-- minutes --%>
			            <select id="appointmentDateEndMinutes" name="appointmentDateEndMinutes" class="text">
			                <%for (int n = 0; n < 60; n=n+5){
			                    out.print("<option value='"+(n < 10 ? "0"+n : ""+n)+"' ");
			                    if (appointmentDateEndMinutes.length() > 0 && n == Integer.parseInt(appointmentDateEndMinutes)){
			                        out.print("selected");
			                    }
			                    out.print(">"+(n < 10 ? "0"+n : ""+n)+"</option>");
			                }%>
			            </select><%=HTMLEntities.htmlentities(getTran(request,"Web.occup", "medwan.common.hour", sWebLanguage))%>&nbsp;
			
			        </td>
			    </tr>
			    <tr>
			        <td class="admin"><%=HTMLEntities.htmlentities(getTran(request,"planning", "effectivedate", sWebLanguage))%>
			        </td>
			        <td class="admin2">
			        	<%=ScreenHelper.newWriteDateTimeField("EditEffectiveDate", planning.getEffectiveDate(), sWebLanguage, sCONTEXTPATH)%>
			        	<input type='checkbox' name='EditNoshow' id='EditNoshow' <%=checkString(planning.getNoshow()).equalsIgnoreCase("1")?"checked":""%> onclick='validateNoShow();'/>
			        	<%=getTran(request,"web","noshow",sWebLanguage) %>
			        </td>
			    </tr>
			    <tr>
			        <td class="admin"><%=HTMLEntities.htmlentities(getTran(request,"planning", "cancelationdate", sWebLanguage))%>
			        </td>
			        <td class="admin2"><%=ScreenHelper.newWriteDateTimeField("EditCancelationDate", planning.getCancelationDate(), sWebLanguage, sCONTEXTPATH)%>
			        </td>
			    </tr>
			    <tr>
			        <td class="admin"><%=HTMLEntities.htmlentities(getTran(request,"planning", "provisionalbooking", sWebLanguage))%></td>
			        <td class="admin2">
			        	<%=ScreenHelper.newWriteDateField("EditConfirmationDate", planning.getConfirmationDate(), sWebLanguage, sCONTEXTPATH,"document.getElementById(\"checkConfirmationDate\").checked=false")%>
			        	<input type='checkbox' id='checkConfirmationDate' <%=ScreenHelper.formatDate(planning.getConfirmationDate()).length()==0?"checked":""%> onclick='if(this.checked){document.getElementById("EditConfirmationDate").value=""}'/> <%=HTMLEntities.htmlentities(getTran(request,"planning", "planningconfirmed", sWebLanguage))%>
			        </td>
			    </tr>
			    <tr>
			        <td class='admin'><%=HTMLEntities.htmlentities(getTran(request,"web", "service", sWebLanguage))%>*</td>
			        <td class='admin2'>
			            <input type="hidden" id="EditServiceUID" name="EditServiceUID" value="<%=planning.getServiceUid()%>">
			            <input class="text" type="text" id="EditServiceName" name="EditServiceName" readonly size="60" value="<%=getTranNoLink("service",planning.getServiceUid(),sWebLanguage)%>">
			            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchService('EditServiceUID','EditServiceName');">
			            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="$('EditServiceUID').clear();$('EditServiceName').clear();">
			        </td>
			    </tr>
			    <tr>
			        <td class='admin'><%=HTMLEntities.htmlentities(getTran(request,"planning", "user", sWebLanguage))%>*</td>
			        <td class='admin2'>
			            <input type="hidden" id="EditUserUID123" name="EditUserUID123" value="<%=planning.getUserUID()%>">
			            <input class="text" type="text" id="EditUserName" name="EditUserName" readonly size="60" value="<%=HTMLEntities.htmlentities(ScreenHelper.getFullUserName(planning.getUserUID()))%>">
			            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchUser('EditUserUID123','EditUserName');">
			            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="$('EditUserUID123').clear();$('EditUserName').clear();">
			        </td>
			    </tr>
			    <tr>
			        <td class='admin'><%=HTMLEntities.htmlentities(getTran(request,"planning", "patient", sWebLanguage))%>*</td>
			        <td class='admin2'>
			            <input type="hidden" id="EditPatientUID" name="EditPatientUID" value="<%=(planning.getPatientUID()==null)?"":planning.getPatientUID()%>">
			            <input class="text" id="EditPatientName" type="text" name="EditPatientName" readonly size="60" value="<%=HTMLEntities.htmlentities(ScreenHelper.getFullPersonName(planning.getPatientUID()))%>">
			            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchMyPatient('EditPatientUID','EditPatientName');">
			            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="$('EditPatientUID').clear();$('EditPatientName').clear();">
			        </td>
			    </tr>
			    <%
			        if(checkString(planning.getTransactionUID()).length() > 0){
			            TransactionVO transaction = planning.getTransaction();
			            String sTransactionType = "";
			            if(transaction!=null){
			                sTransactionType = getTran(request,"web.occup",transaction.getTransactionType(),sWebLanguage);
			            }
			    %>
			    <tr>
			        <td class='admin'><%=getTran(request,"planning","transaction",sWebLanguage)%></td>
			        <td class='admin2'>
			            <input type="text" id="EditTransactionUID" name="EditTransactionUID" value="<%=planning.getTransactionUID()%>"/>
			            <input class="text" type="text" readonly size="<%=sTextWidth%>" value="<%=ScreenHelper.formatDate(transaction.getUpdateTime())+": "+sTransactionType%>"/>
			        </td>
			    </tr>
			    <%}%>
			    <tr>
			        <td class='admin'><%=getTran(request,"web","prestation",sWebLanguage)%></td>
					<% 	if(MedwanQuery.getInstance().getConfigInt("enableCCBRT",0)==1){ %>
			        <td class='admin2'>
			            <input type='hidden' name='EditContactType' id='ContactPrestation' value='prestation'/>
			            <input type="hidden" id="EditEffectiveDateTime" value="" />
			            <input type="hidden" id="EditCancelationDateTime" value="" />
			            <input type="hidden" id="EditContactUID" name="EditContactUID" value="<%=planning.getContact()==null?"":planning.getContact().getObjectUid() %>" />
			            <%
			            	String sActivity = "";
			            	if(planning.getContact()!=null){
			            		Prestation p = Prestation.get(planning.getContact().getObjectUid());
			            		if(p!=null && ScreenHelper.checkString(p.getCode()).length()>0){
			            			sActivity=ScreenHelper.checkString(p.getCode()).toUpperCase()+" - "+p.getDescription();
			            		}
			            	}
			            %>
			            <input class='text' type='text' id="EditContactName" name="EditContactName" size="60" value="<%=sActivity %>">
						<div id="autocomplete_activity" class="autocomple"></div>
<script>
	new Ajax.Autocompleter('EditContactName','autocomplete_activity','planning/ajax/getActivities.jsp?',{
		minChars:1,
		method:'post',
		afterUpdateElement:afterAutoComplete,
		callback:composeCallbackURL
	});
	
	function afterAutoComplete(field,item){
		var regex = new RegExp('[-0123456789.]*-idcache','i');
		var nomimage = regex.exec(item.innerHTML);
		var id = nomimage[0].replace('-idcache','');
		document.getElementById("EditContactName").value=document.getElementById("EditContactName").value.split('|')[0];
		document.getElementById("EditContactUID").value = id;
		selectTimeSlot();
	}
	
	function composeCallbackURL(field,item){
		var url = "";
		if(field.id=="EditContactName"){
			url = "field=findActivityName&findActivityName="+field.value;
		}
		return url;
	}

</script>
			        </td>
					<%
						}
						else {
					%>
			        <td class='admin2'>
			            <%
			                String sEditCheckProduct = "", sEditCheckExamination = "", sEditContactName = "";
			                ObjectReference orContact = planning.getContact();
			                if(orContact!=null){
			                    if(orContact.getObjectType().equalsIgnoreCase("examination")){
			                        sEditCheckExamination = " checked";
			
			                        ExaminationVO examination = MedwanQuery.getInstance().getExamination(orContact.getObjectUid(), sWebLanguage);
			                        if(examination!=null){
			                            sEditContactName = HTMLEntities.htmlentities(getTran(request,"web.occup", examination.getTransactionType(), sWebLanguage));
			                        }
			                    } 
			                    else if(orContact.getObjectType().equalsIgnoreCase("product")){
			                        Product p = Product.get(orContact.getObjectUid());
			                        if(p!=null){
			                            sEditContactName = p.getName();
			                        }
			                        sEditCheckProduct = " checked";
			                    }
			                } 
			                else{
			                    orContact = new ObjectReference();
			                }
			            %>
			            <input type='radio' name='EditContactType' id='ContactProduct' value='Product' onclick='changeContactType();' onDblClick="uncheckRadio(this);" <%=sEditCheckProduct%>>
			            <label for='ContactProduct'><%=getTran(request,"planning", "product", sWebLanguage)%></label>
			            <input type='radio' name='EditContactType' id='ContactExamination' value='Examination' onclick='changeContactType();' onDblClick="uncheckRadio(this);" <%=sEditCheckExamination%>>
			            <label for='ContactExamination'><%=getTran(request,"planning", "examination", sWebLanguage)%></label><br>
			            <input type="hidden" id="EditEffectiveDateTime" value="" />
			            <input type="hidden" id="EditCancelationDateTime" value="" />
			            <input type="hidden" id="EditContactUID" name="EditContactUID" value="<%=orContact.getObjectUid()%>">
			            <input class="text" type="text" id="EditContactName" name="EditContactName" readonly size="<%=sTextWidth%>" value="<%=sEditContactName%>">
			            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchPrestation('EditContactUID','EditContactName');">
			            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="$('EditContactUID').clear();$('EditContactName').clear();">
			        </td>
			        <%
						}
			        %>
			    </tr>
			    <tr>
			        <td class='admin'><%=getTran(request,"planning","resource",sWebLanguage)%></td>
			        <td class='admin2'>
			        <% if(!checkString(request.getParameter("readonly")).equalsIgnoreCase("true")){ %>
			        	<a href="javascript:openPopup('/planning/manageResources.jsp&planninguid=<%=sFindPlanningUID%>&tempplanninguid='+document.getElementById('tempplanninguid').value+'&date='+document.getElementById('appointmentDateDay').value+'&begin='+(document.getElementById('appointmentDateHour').value*60+document.getElementById('appointmentDateMinutes').value*1)*60000+'&end='+(document.getElementById('appointmentDateEndHour').value*60+document.getElementById('appointmentDateEndMinutes').value*1)*60000+'&PopupWidth=800&PopupHeight=600&ts=<%=getTs()%>&patientuid='+document.getElementById('EditPatientUID').value);void(0);"><%=getTran(request,"web","edit.resources",sWebLanguage) %></a>
			        <%} %>
			            <span id='resources'></span>
			            <input type='hidden' name='tempplanninguid' id='tempplanninguid'/>
			        </td>
			    </tr>
			    <div id="trContext">
			        <tr>
			            <td class='admin'><%=getTran(request,"web","context",sWebLanguage)%></td>
			            <td class='admin2'>
			                <select class="text" name="EditContext" id="EditContext">
			                    <option value=""/>
			                    <%
			                        // list possible contexts from XML-file
			                        String sDoc = MedwanQuery.getInstance().getConfigString("templateSource")+"contexts.xml";
			                        if(sDoc.length() > 0){
			                            SAXReader reader = new SAXReader(false);
			                            Document document = reader.read(new URL(sDoc));
			                            Iterator elements = document.getRootElement().elementIterator("context");
			
			                            // put context-elements in hash
			                            Element contextElement;
			                            String contextName;
			                            Hashtable contexts = new Hashtable();
			                            while(elements.hasNext()){
			                                contextElement = (Element)elements.next();
			                                contextName = getTran(request,"Web.Occup",contextElement.attribute("id").getValue(),sWebLanguage);
			                                contexts.put(contextName,contextElement);
			                            }
			
			                            // sort hash on context-name
			                            Vector contextNames = new Vector(contexts.keySet());
			                            Collections.sort(contextNames);
			                            Iterator contextIter = contextNames.iterator();
			                            while(contextIter.hasNext()){
			                                contextName = (String)contextIter.next();
			                                contextElement = (Element)contexts.get(contextName);
			                                out.print("<option value='"+contextElement.attribute("id").getValue()+"' "+(contextElement.attribute("id").getValue().equalsIgnoreCase(planning.getContextID()) ? "selected" : "")+">"+HTMLEntities.htmlentities(contextName)+"</option>");
			                            }
			                        }
			                    %>
			                </select>
			            </td>
			        </tr>
			    </div>
			    <tr>
			        <td class='admin'><%=HTMLEntities.htmlentities(getTran(request,"planning","description",sWebLanguage))%></td>
			        <td class='admin2'><%=writeTextarea("EditDescription","60","","",HTMLEntities.htmlentities(checkString(planning.getDescription())))%></td>
			    </tr>
			    <tr>
			        <td class='admin'><%=HTMLEntities.htmlentities(getTran(request,"planning","remark",sWebLanguage))%></td>
			        <td class='admin2'><%=writeTextarea("EditComment","60","","",HTMLEntities.htmlentities(checkString(planning.getComment())))%></td>
			    </tr>
			    <%
			    	if(planning!=null && planning.hasValidUid()){ 
			    %>
			    <tr>
			        <td class='admin'><%=HTMLEntities.htmlentities(getTran(request,"web","lastmodifiedby",sWebLanguage))%></td>
			        <td class='admin2'><%=User.getFullUserName(planning.getUpdateUser())+" "+getTran(request,"web","on",sWebLanguage)+" "+new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(planning.getUpdateDateTime()) %></td>
			    </tr>
			    <tr>
			        <td class='admin'><%=HTMLEntities.htmlentities(getTran(request,"web","createdby",sWebLanguage))%></td>
			        <td class='admin2'><%=User.getFullUserName(planning.getCreateUser())+" "+getTran(request,"web","on",sWebLanguage)+" "+new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(planning.getCreateDateTime()) %></td>
			    </tr>
			    <%
			    }
			    	if(sFindPlanningUID.length()==0){
			    %>
				    <tr>
				        <td class="admin"><%=HTMLEntities.htmlentities(getTran(request,"web", "repeatuntil", sWebLanguage))%>
				        </td>
				        <td class="admin2"><%=ScreenHelper.planningDateTimeField("appointmentRepeatUntil", "", sWebLanguage, sCONTEXTPATH)%>
				        </td>
				    </tr>
			    <%
			    	}
			    	else{
			    %>
			    	<input type="hidden" id="appointmentRepeatUntil" name="appointmentRepeatUntil" value="" />
			    <%
			    	}
			    %>
			</table>
		</td>
	</tr>
	<tr id="tr1_1-view" style="display:none">
		<td>
			<!-- TAB 2: Extended screen -->
			<table class='list' border='0' width='630' cellspacing='1'>
			    <tr>
			        <td class="admin" width="<%=sTDAdminWidth%>"><%=HTMLEntities.htmlentities(getTran(request,"planning", "preparationdate", sWebLanguage))%></td>
			        <td class="admin2"><%=ScreenHelper.newWriteDateTimeField("EditPreparationDate", ScreenHelper.parseDate(planning.getPreparationDate()), sWebLanguage, sCONTEXTPATH)%></td>
			    </tr>
			    <tr>
			        <td class="admin"><%=HTMLEntities.htmlentities(getTran(request,"planning", "admissiondate", sWebLanguage))%></td>
			        <td class="admin2"><%=ScreenHelper.newWriteDateTimeField("EditAdmissionDate", ScreenHelper.parseDate(planning.getAdmissionDate()), sWebLanguage, sCONTEXTPATH)%></td>
			    </tr>
			    <tr>
			        <td class="admin"><%=HTMLEntities.htmlentities(getTran(request,"planning", "operationdate", sWebLanguage))%></td>
			        <td class="admin2"><%=ScreenHelper.newWriteDateTimeField("EditOperationDate", ScreenHelper.parseDate(planning.getOperationDate()), sWebLanguage, sCONTEXTPATH)%></td>
			    </tr>
			    <tr>
			        <td class='admin'><%=HTMLEntities.htmlentities(getTran(request,"planning","reportingplace",sWebLanguage))%></td>
			        <td class='admin2'><%=writeTextarea("EditReportingPlace","60","","",HTMLEntities.htmlentities(checkString(planning.getReportingPlace())))%></td>
			    </tr>
			    <tr>
			        <td class='admin'><%=HTMLEntities.htmlentities(getTran(request,"planning","surgeon",sWebLanguage))%></td>
			        <td class='admin2'><%=writeTextarea("EditSurgeon","60","","",HTMLEntities.htmlentities(checkString(planning.getSurgeon())))%></td>
			    </tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table class='list' border='0' width='630' cellspacing='1'>
			    <tr>
			        <td class="admin" width="<%=sTDAdminWidth%>"/>
			        <td class="admin2">
			            <input type="hidden" id="EditPage" value="<%=sPage%>" />
			            <%-- Buttons --%>
			            <%if(!checkString(request.getParameter("readonly")).equalsIgnoreCase("true") &&(activeUser.getAccessRight("planning.add") || activeUser.getAccessRight("planning.edit"))){%>
			            <input class='button' type="button" name="buttonSave" id="buttonSaveEditPlanning" value='<%=getTranNoLink("Web","save",sWebLanguage)%>' onclick="saveAppointment();">&nbsp;
			            <%}
			            if(!checkString(request.getParameter("readonly")).equalsIgnoreCase("true") && ((sFindPlanningUID.length() > 0) && (activeUser.getAccessRight("planning.delete")))){%>
			            <input class='button' type="button" name="buttonDelete" value='<%=getTranNoLink("Web","delete",sWebLanguage)%>' onclick="deleteAppointment2();">&nbsp;<%}%>
			            <input class='button' type="button" name="buttonBack" value='<%=getTranNoLink("Web","Back",sWebLanguage)%>' onclick="doClose();">
			            <input class='button' type="button" name="buttonPrint" value='<%=getTranNoLink("Web","print",sWebLanguage)%>' onclick="printAppointment();">
			        </td>
			    </tr>
			    <tr>
			        <td class="admin"/>
			        <td class="admin2">
			            <%=getTran(request,"Web","colored_fields_are_obligate",sWebLanguage)%> <input type="hidden" name="Action"/>
			        </td>
			    </tr>
			</table>
		</td>
	</tr>
</table>
<div>
<script>

	activateTab2('Main');

  	function findResources(){
		var today = new Date();
		var url= '<c:url value="/planning/ajax/getResourcesForPlanning.jsp"/>?planninguid=<%=sFindPlanningUID%>&tempplanninguid='+document.getElementById('tempplanninguid').value+'&language=<%=sWebLanguage%>&ts='+today;
		new Ajax.Request(url,{
		method: "POST",
		   parameters: "",
		   onSuccess: function(resp){
			   $('resources').innerHTML=resp.responseText;
			}
		});
	}
	
	findResources();
	
	
</script>
</div>
<input type="hidden" id="EditPlanningUID" name="EditPlanningUID" value="<%=sFindPlanningUID%>"/>
<script>
  checkContext();
  changeInputColor();
  
  function updateSelect(){
    setCorrectAppointmentDate(<%=startHourOfWeekPlanner+","+startMinOfWeekPlanner+","+endHourOfWeekPlanner+","+endMinOfWeekPlanner%>);
  }
  
  updateSelect();
</script>
<%}
	}
catch(Exception e){
	e.printStackTrace();
}

%>          