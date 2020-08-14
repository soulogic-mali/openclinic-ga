<%@page import="be.openclinic.adt.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	private java.util.Date roundMinutes(java.util.Date date,int n){
		long minute = 60*1000;
		date = new java.util.Date(Math.round(date.getTime()/(n*minute))*n*minute);
		return date;
	}
%>
<%
	try{
		boolean bInitialized=false;
		SimpleDateFormat ISO8601DATEFORMAT = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.ENGLISH);
		System.out.println("1: "+request.getParameter("start"));
		java.util.Date dStart = ISO8601DATEFORMAT.parse(request.getParameter("start"));
		System.out.println(2);
		java.util.Date dEnd = ISO8601DATEFORMAT.parse(request.getParameter("end"));
		System.out.println(3);
		String sType = checkString(request.getParameter("type"));
		StringBuffer sb = new StringBuffer();
		sb.append("[");
		if(sType.equalsIgnoreCase("patient")){
			//Show patient events
			Vector<Planning> appointments = Planning.getPatientPlannings(activePatient.personid,"",dStart,dEnd);
			for(int n=0;n<appointments.size();n++){
				if(bInitialized){
					sb.append(",");
				}
				bInitialized=true;
				Planning appointment = appointments.elementAt(n);
				appointment.setPlannedDate(roundMinutes(appointment.getPlannedDate(),5));
				appointment.setPlannedEndDate(roundMinutes(appointment.getPlannedEndDate(),5));
				String sTitle=checkString(appointment.getUser().getFullName()).trim();
				String sComment=checkString(appointment.getComment()).trim();
				if(sComment.length()>0){
					if(sTitle.length()>0){
						sTitle+=" ["+sComment+"]";
					}
					else{
						sTitle=sComment;
					}
				}
				sb.append("{");
				sb.append("\"id\":\""+appointment.getUid()+"\",");
				if(appointment.getPlannedEndDate().before(new java.util.Date()) || appointment.getEffectiveDate()!=null){
					if(appointment.getEffectiveDate()==null){
						sb.append("\"backgroundColor\": \"grey\",");
					}
					else{
						sb.append("\"backgroundColor\": \"#ABCDEF\",");
					}
				}
				else if(appointment.getColor().split("=").length>1){
					sb.append("\"backgroundColor\": \""+appointment.getColor().split("=")[0]+"\",");
					sb.append("\"textColor\": \""+appointment.getColor().split("=")[1]+"\",");
				}
				sb.append("\"title\":\""+sTitle+"\",");
				sb.append("\"start\":\""+new SimpleDateFormat("yyyy-MM-dd").format(appointment.getPlannedDate())+"T"+new SimpleDateFormat("HH:mm:ss").format(appointment.getPlannedDate())+"\",");
				sb.append("\"end\":\""+new SimpleDateFormat("yyyy-MM-dd").format(appointment.getPlannedEndDate())+"T"+new SimpleDateFormat("HH:mm:ss").format(appointment.getPlannedEndDate())+"\"");
				sb.append("}");
			}
		}
		else if(sType.equalsIgnoreCase("user")){
			//Show patient events
			Vector<Planning> appointments = Planning.getUserAppointmentsRemoveFreeOverlap(Integer.parseInt((String)session.getAttribute("calendarUser")),dStart,dEnd);
			for(int n=0;n<appointments.size();n++){
				Planning appointment = appointments.elementAt(n);
				System.out.println("date: "+appointment.getPlannedDate()+" - "+appointment.isFree());
				appointment.setPlannedDate(roundMinutes(appointment.getPlannedDate(),5));
				if(appointment.getFullDay().equalsIgnoreCase("1")){
					if(bInitialized){
						sb.append(",");
					}
					bInitialized=true;
					sb.append("{");
					sb.append("\"id\":\""+appointment.getUid()+"\",");
					sb.append("\"title\":\""+getTranNoLink("appointment.location",appointment.getLocation(),sWebLanguage)+"\",");
					sb.append("\"backgroundColor\": \""+(appointment.getColor().split("=").length>1?appointment.getColor().split("=")[0]:"#FCF8E3")+"\",");
					sb.append("\"textColor\": \""+(appointment.getColor().split("=").length>1?appointment.getColor().split("=")[1]:"#000000")+"\",");
					sb.append("\"allDay\": true ,");
					sb.append("\"start\":\""+new SimpleDateFormat("yyyy-MM-dd").format(appointment.getPlannedDate())+"T"+new SimpleDateFormat("HH:mm:ss").format(appointment.getPlannedDate())+"\"");
					sb.append("}");
				}
				else if(appointment.getType().equalsIgnoreCase("medwan.common.free") || (appointment.getPatient()!=null && checkString(appointment.getPatient().getFullName()).length()==0 && checkString(appointment.getComment()).length()==0)){
					if(appointment.getPlannedEndDate().after(new java.util.Date())){
						if(bInitialized){
							sb.append(",");
						}
						String sTitle="";
						if(checkString(appointment.getLocation()).length()>0){
							sTitle+=getTranNoLink("appointment.location",appointment.getLocation(),sWebLanguage);
						}
						if(checkString(appointment.getType()).length()>0){
							if(sTitle.length()>0){
								sTitle+=", ";
							}
							sTitle+=getTranNoLink("appointment.types",appointment.getType(),sWebLanguage);
						}
						bInitialized=true;
						sb.append("{");
						sb.append("\"id\":\""+appointment.getUid()+"\",");
						sb.append("\"title\":\""+sTitle+"\",");
						sb.append("\"backgroundColor\": \""+(appointment.getColor().split("=").length>1?appointment.getColor().split("=")[0]:"#FFFFFF")+"\",");
						sb.append("\"textColor\": \""+(appointment.getColor().split("=").length>1?appointment.getColor().split("=")[1]:"#000000")+"\",");
						sb.append("\"start\":\""+new SimpleDateFormat("yyyy-MM-dd").format(appointment.getPlannedDate())+"T"+new SimpleDateFormat("HH:mm:ss").format(appointment.getPlannedDate())+"\",");
						sb.append("\"end\":\""+new SimpleDateFormat("yyyy-MM-dd").format(appointment.getPlannedEndDate())+"T"+new SimpleDateFormat("HH:mm:ss").format(appointment.getPlannedEndDate())+"\"");
						sb.append("}");
					}
				}
				else{
					appointment.setPlannedEndDate(roundMinutes(appointment.getPlannedEndDate(),5));
					String sTitle=appointment.getPatient()==null || !appointment.getPatient().isNotEmpty()?"":checkString(appointment.getPatient().getFullName()).trim();
					String sComment=checkString(appointment.getComment()).trim();
					if(sComment.length()>0){
						if(sTitle.length()>0){
							sTitle+=" ["+sComment+"]";
						}
						else{
							sTitle=sComment;
						}
					}
					if(bInitialized){
						sb.append(",");
					}
					bInitialized=true;
					sb.append("{");
					sb.append("\"id\":\""+appointment.getUid()+"\",");
					if(appointment.getPlannedEndDate().before(new java.util.Date()) || appointment.getEffectiveDate()!=null){
						if(appointment.getEffectiveDate()==null){
							sb.append("\"backgroundColor\": \"grey\",");
						}
						else{
							sb.append("\"backgroundColor\": \"#ABCDEF\",");
						}
					}
					else{
						if(appointment.getColor().length()>0){
							sb.append("\"backgroundColor\": \""+appointment.getColor().split("=")[0]+"\",");
						}
						if(appointment.getColor().split("=").length>1){
							sb.append("\"textColor\": \""+appointment.getColor().split("=")[1]+"\",");
						}
					}
					sb.append("\"title\":\""+sTitle+"\",");
					sb.append("\"start\":\""+new SimpleDateFormat("yyyy-MM-dd").format(appointment.getPlannedDate())+"T"+new SimpleDateFormat("HH:mm:ss").format(appointment.getPlannedDate())+"\",");
					sb.append("\"end\":\""+new SimpleDateFormat("yyyy-MM-dd").format(appointment.getPlannedEndDate())+"T"+new SimpleDateFormat("HH:mm:ss").format(appointment.getPlannedEndDate())+"\"");
					sb.append("}");
				}
			}
		}
		sb.append("]");
		out.print(sb.toString());
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>