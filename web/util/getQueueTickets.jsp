<%@include file="/includes/validateUser.jsp"%>
<%@ page import="java.util.*,be.mxs.common.util.db.*,be.mxs.common.util.system.*,be.openclinic.adt.Queue,net.admin.*" %>

<%
	if(request.getParameter("queueid")!=null){
		session.setAttribute("activequeue", request.getParameter("queueid"));
	}

%>
	<!-- table that shows top x tickets in the waiting queue -->
	<table width='100%' cellpadding='0' cellspacing='0'>
		<tr>
			<td width='<%=MedwanQuery.getInstance().getConfigInt("waitingQueues2columns",0)==1?"50":"100"%>%'>
				<table width='100%' cellpadding='0' cellspacing='0'>
					<%
						int counter = 0,trHeight,fontHeight1,fontHeight2,fontHeight3,fontHeight4,imgHeight;
						int maxTickets=MedwanQuery.getInstance().getConfigInt("maximumRecentQueueTickets",5);
						fontHeight4=20;
						if(checkString(request.getParameter("verticalFrames")).equalsIgnoreCase("2")){
							fontHeight4=20;
						}
						long interval = MedwanQuery.getInstance().getConfigInt("queuestats.median."+request.getParameter("queueid"),0);
						Vector queues = Queue.getActiveQueue(request.getParameter("queueid"));
						for(int n=0;n<queues.size() && n<maxTickets;n++){
							Queue queue=(Queue)queues.elementAt(n);
							if(n==0){
								out.println("<tr><td class='green' colspan='2'><span id='resizeFont.0."+queue.getId()+"' style='vertical-align: top; text-align: left; font-size: "+fontHeight4+"px;font-weight: bold;'>"+
											(n>0?"":ScreenHelper.getTranNoLink("web","next",(String)session.getAttribute((String)session.getAttribute("activeProjectTitle")+"WebLanguage")))+
											"</span></td></tr>");
							}
							String personname="?";
							AdminPerson person = AdminPerson.getAdminPerson(queue.getSubjectuid());
							if(person!=null){
								personname=person.getFullName();
							}
							if(personname.replaceAll(",", "").replaceAll(" ", "").length()==0){
								personname="";
							}
							if("1".equals(((String)session.getAttribute("showWaitingQueuePatientName")))){
								trHeight=86*5/maxTickets;
								fontHeight1=76*5/maxTickets;
								fontHeight2=60*5/maxTickets;
								fontHeight3=14*5/maxTickets;
								imgHeight=12*5/maxTickets;
								if(checkString(request.getParameter("verticalFrames")).equalsIgnoreCase("2")){
									trHeight=70*5/maxTickets;
									fontHeight1=60*5/maxTickets;
									fontHeight2=45*5/maxTickets;
									fontHeight3=13*5/maxTickets;
									imgHeight=12*5/maxTickets;
								}
								out.println("<tr><td colspan='2' "+(n>0?"":"class='green'")+
									    " style='vertical-align: middle; text-align: center; font-size: 0px;font-weight: bold;'>"+
										"<span id='resizeFont.1."+queue.getId()+"' style='vertical-align: middle; text-align: center; font-size: "+fontHeight1+"px;font-weight: bold;'>"+queue.getTicketnumber()+"</span></td></tr>");
									    out.println("<tr id='resizeTR.1."+queue.getId()+"' height='"+fontHeight3+"px'><td "+(n>0?"":"class='green'")+" style='vertical-align: middle; text-align: left; font-size: "+fontHeight3+"px;font-weight: bold;'>");
									    out.println("<a id='resizeFont.2."+queue.getId()+"' style='vertical-align: middle; text-align: center; font-size: "+fontHeight3+"px;font-weight: bold;color: darkblue' href='javascript:loadparent("+queue.getSubjectuid()+","+queue.getObjectid()+","+queue.getTicketnumber()+");'>"+personname+"</a>");
									    if(n==0){
									    	out.println("<input type='button' name='firstpatient' accesskey='F' onclick='loadparent("+queue.getSubjectuid()+","+queue.getObjectid()+","+queue.getTicketnumber()+")' style='display: none'/>");
									    }
									    out.println(" <img id='resizeImage.1."+queue.getId()+"' onclick='registerseen("+queue.getObjectid()+","+queue.getTicketnumber()+")' height='"+imgHeight+"' src='"+sCONTEXTPATH+"/_img/icons/icon_eye.png'/>");
									    out.println(" <img id='resizeImage.2."+queue.getId()+"' onclick='registeraway("+queue.getObjectid()+","+queue.getTicketnumber()+")' height='"+imgHeight+"' src='"+sCONTEXTPATH+"/_img/icons/icon_run.png'/></td><td "+(n>0?"":"class='green'")+"><span id='resizeFont.5."+queue.getId()+"' style='vertical-align: middle; text-align: right; font-size: "+fontHeight3+"px;font-weight: bold;font-style:italic;'>");
									    if(interval>0){
									    	out.println(getTran(request,"web","estimated",sWebLanguage)+": "+new SimpleDateFormat("HH:mm").format(new java.util.Date(new java.util.Date().getTime()+counter*interval)));
									    }
									    out.println("</span></td></tr>"); 
								out.println("</td></tr>");
							}
							else {
								trHeight=100*5/maxTickets;
								fontHeight1=80*5/maxTickets;
								fontHeight2=40*5/maxTickets;
								fontHeight3=12*5/maxTickets;
								imgHeight=12*5/maxTickets;
								if(checkString(request.getParameter("verticalFrames")).equalsIgnoreCase("2")){
									trHeight=45*5/maxTickets;
									fontHeight1=65*5/maxTickets;
									fontHeight2=35*5/maxTickets;
									fontHeight3=12*5/maxTickets;
									imgHeight=12*5/maxTickets;
								}
							    if(n==0){
							    	out.println("<input type='button' name='firstpatient' accesskey='F' onclick='loadparent("+queue.getSubjectuid()+","+queue.getObjectid()+","+queue.getTicketnumber()+")' style='display: none'/>");
							    }
								out.println("<tr><td "+(n>0?"":"class='green'")+
									    " style='vertical-align: middle; text-align: center; font-size: "+fontHeight2+"px;font-weight: bold;'>"+
										"<span id='resizeFont.2."+queue.getId()+"' style='vertical-align: middle; text-align: center; font-size: "+fontHeight1+"px;font-weight: bold;'>"+
									    queue.getTicketnumber()+"</span></td></tr>");
							    if(interval>0){
								    out.println("<tr id='resizeFont.3."+queue.getId()+"' height='"+fontHeight3+"'><td style='vertical-align: middle; text-align: center;' "+(n>0?"":"class='green'")+"><span id='resizeFont.3."+queue.getId()+"' style='vertical-align: middle; text-align: center; font-size: "+fontHeight3+"px;font-weight: bold;font-style:italic;'>");
							    	out.println(getTran(request,"web","estimated",sWebLanguage)+": "+new SimpleDateFormat("HH:mm").format(new java.util.Date(new java.util.Date().getTime()+counter*interval)));
								    out.println("<span></td></tr>");
							    }
							}
							counter++;
						}
					%>
				</table>
			</td> 
			<%
			if(MedwanQuery.getInstance().getConfigInt("waitingQueues2columns",0)==1){
			%>
			<td width='50%' valign='top'>
				<table width='100%' padding='0' cellspacing='0'>
					<%
						if(queues.size()>maxTickets){
							int ticketcounter=0;
							for(int n=maxTickets;n<queues.size() && (n-maxTickets)<maxTickets*4;n++){
								ticketcounter++;
								Queue queue=(Queue)queues.elementAt(n);
								String personname="?";
								AdminPerson person = AdminPerson.getAdminPerson(queue.getSubjectuid());
								if(person!=null){
									personname=person.getFullName();
								}
								if(personname.replaceAll(",", "").replaceAll(" ", "").length()==0){
									personname="";
								}
								fontHeight1=22*5/maxTickets;
								fontHeight2=14*5/maxTickets;
								if(checkString(request.getParameter("verticalFrames")).equalsIgnoreCase("2")){
									fontHeight1=22*5/maxTickets;
									fontHeight2=14*5/maxTickets;
								}
								if("1".equals(((String)session.getAttribute("showWaitingQueuePatientName")))){
									out.println("<tr><td width='20%' style='vertical-align: middle; text-align: center;'><span id='resizeFont.a."+queue.getId()+"' style='vertical-align: top; text-align: center; font-size: "+fontHeight1+"px;font-weight: bold;'>"+queue.getTicketnumber()+"</span></td><td><a href='javascript:loadparent("+queue.getSubjectuid()+","+queue.getObjectid()+","+queue.getTicketnumber()+");' style='vertical-align: middle;font-size: "+fontHeight2+"px;color: darkblue;font-weight: bold'>"+personname+"</a> ");
									out.println(" <img id='resizeImage.1."+queue.getId()+"' onclick='registerseen("+queue.getObjectid()+","+queue.getTicketnumber()+")' height='16' src='"+sCONTEXTPATH+"/_img/icons/icon_eye.png'/>");
								    out.println(" <img id='resizeImage.2."+queue.getId()+"' onclick='registeraway("+queue.getObjectid()+","+queue.getTicketnumber()+")' height='16' src='"+sCONTEXTPATH+"/_img/icons/icon_run.png'/></td>");
								    if(interval>0){
									    out.println("<td><span id='resizeFont.b."+queue.getId()+"' style='vertical-align: middle; text-align: center; font-size: "+fontHeight2+"px;font-weight: bold;font-style:italic;'>");
								    	out.println(getTran(request,"web","estimated",sWebLanguage)+": "+new SimpleDateFormat("HH:mm").format(new java.util.Date(new java.util.Date().getTime()+counter*interval)));
									    out.println("</span></td>");
								    }
									out.println("</tr>");
								}
								else {
									out.println("<tr><td width='20%' style='vertical-align: middle; text-align: center;'><span id='resizeFont.c."+queue.getId()+"' style='vertical-align: top; text-align: center; font-size: "+fontHeight1+"px;font-weight: bold;'>"+queue.getTicketnumber()+"</font></td>");
								    if(interval>0){
									    out.println("<td><span id='resizeFont.d."+queue.getId()+"' style='vertical-align: middle; text-align: center; font-size: "+fontHeight2+"px;font-weight: bold;font-style:italic;'>");
								    	out.println(getTran(request,"web","estimated",sWebLanguage)+": "+new SimpleDateFormat("HH:mm").format(new java.util.Date(new java.util.Date().getTime()+counter*interval)));
									    out.println("</span></td>");
								    }
									out.println("</tr>");
								}
								counter++;
							}
						}
					%>
				</table>
			</td>
			<%
			}
			%>
		<tr>
	</table>
