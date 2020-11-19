<%@page import="be.mxs.common.util.io.UpdateService,
                be.mxs.common.util.io.LabelSyncService,
                be.mxs.common.util.io.TransactionItemSyncService,
                be.openclinic.medical.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
    String sCheckService = checkString(request.getParameter("CheckService"));

    StringBuffer requestURL = request.getRequestURL();

    //--- 1 - check for program updates -----------------------------------------------------------
    // only perform program update if on localhost
    if(requestURL.indexOf("://localhost") > -1){
        UpdateService updService = UpdateService.getInstance();
        boolean updateCheckNeeded = updService.isUpdateCheckNeeded();

        if(updateCheckNeeded){
            %><script>window.status='<%=getTranNoLink("web.manage","checkingForUpdate",sWebLanguage)%>';</script><%
            out.flush();

            Debug.println("\n*** Checking for updates ***");

            try{
                boolean updateNeeded = updService.isUpdateNeeded("openclinic");

                if(updateNeeded){
                    Debug.println("\nUpdate needed to version "+updService.getNewVersionId());
                    
                    String msg = getTranNoLink("web.manage","doyouwantotupdateprogram",sWebLanguage);
                    msg = msg.replaceAll("#version#","\""+updService.getNewVersionId()+"\"");

                    %>
                      <script>
                        if(confirm('<%=msg%>')){
                          window.location.href = '<%=updService.getPathToUpdateFile()%>';
                        }
                      </script>
                    <%
                }
                else{
                    Debug.println("\nNo update needed or available");
                    out.flush();
                }
            }
            catch(Exception e){
                e.printStackTrace();
            }

            Debug.println("*********** done ***********\n");
        }
    }

    //--- 2 - sync ini files ----------------------------------------------------------------------
    // only on local machine
    if(requestURL.indexOf("://localhost") > -1){
        // sync labels file
        LabelSyncService labelSyncService = LabelSyncService.getInstance();
        labelSyncService.setDebug(true);
        labelSyncService.setOut(out);

        TransactionItemSyncService itemSyncService = TransactionItemSyncService.getInstance();
        itemSyncService.setDebug(true);
        itemSyncService.setOut(out);

        if(itemSyncService.isSyncNeeded()){
            labelSyncService.updateDB(); // INI >> DB
            itemSyncService.updateDB();
        }

        // update done, no need to do it again until configString "autoSyncIniFiles" is set to "1"
        itemSyncService.updateAutoSyncIniFileValue("0");
    }

    // controls DOB of user and shows happy birthday
    if(checkString(activeUser.person.dateOfBirth).length() > 0){
        String sDOB = activeUser.person.dateOfBirth;
        sDOB = sDOB.substring(0,sDOB.lastIndexOf("/"));
       
        String sNow = getDate();
        sNow = sNow.substring(0,sNow.lastIndexOf("/"));

        if(sDOB.equals(sNow)){
            %><script>alertDialogDirectText("Happy birthday!");</script><%
        }
    }

    // user must select a service when he works in more than one service
    if(!"datacenter".equalsIgnoreCase((String)session.getAttribute("edition"))){
	    if(activeUser.vServices.size() > 1 && sCheckService.equals("true")){
	        ScreenHelper.setIncludePage("startChangeService.jsp?NextPage=_common/start.jsp", pageContext);
	    }
	    
	    if(MedwanQuery.getInstance().getConfigString("globalHealthBarometerCenterCountry","").length()==0 ||
	       MedwanQuery.getInstance().getConfigString("globalHealthBarometerCenterCity","").length()==0){
	        out.println("<script>window.open('popup.jsp?Page=system/manageGlobalHealthBarometerData.jsp&PopupWidth=800&PopupHeight=600&AutoClose=1','GlobalHealthBarometer', 'toolbar=no, status=yes, scrollbars=yes, resizable=yes, width=1, height=1, menubar=no');</script>");
	    }
	    
	    // show welcome message
        out.print("<center><h4>"+getTran(request,"Web","welcome",sWebLanguage)+" "+activeUser.person.firstname+" "+activeUser.person.lastname+"</h4></center>");
        session.setAttribute("activeMedicalCenter",activeUser.activeService.code);
        
        if(MedwanQuery.getInstance().getConfigInt("showMostRecentHealthrecords",1)==1){
        	long day=24*3600*1000;
        	out.println("<p/><p/><table width='100%'>");
        	out.println("<tr class='admin'>");
    		if(activeUser.getAccessRight("diagnoses.select")){
    			out.println("<td colspan='8'>"+MedwanQuery.getInstance().getConfigInt("maxMostRecentHealthrecords",20)+" "+getTran(request,"web","last7daysrecords",sWebLanguage)+"</td>");
    		}
    		else{
    			out.println("<td colspan='7'>"+MedwanQuery.getInstance().getConfigInt("maxMostRecentHealthrecords",20)+" "+getTran(request,"web","last7daysrecords",sWebLanguage)+"</td>");
    		}
        	out.println("</tr>");
    		out.println("<tr class='admin'>");
    		out.println("<td>"+getTran(request,"web","personid",sWebLanguage)+"</td>");
    		out.println("<td>"+getTran(request,"web","patient",sWebLanguage)+"</td>");
    		out.println("<td>"+getTran(request,"web","dateofbirth",sWebLanguage)+"</td>");
    		out.println("<td>"+getTran(request,"web","gender",sWebLanguage)+"</td>");
        	out.println("<td>"+getTran(request,"web","service",sWebLanguage)+"</td>");
    		if(activeUser.getAccessRight("diagnoses.select")){
        		out.println("<td>"+getTran(request,"web","diagnosis",sWebLanguage)+"</td>");
    		}
    		out.println("<td>"+getTran(request,"web","lastaccess",sWebLanguage)+"</td>");
    		out.println("<td>#</td>");
    		out.println("</tr>");
        	Connection conn = MedwanQuery.getInstance().getAdminConnection();
        	PreparedStatement ps = conn.prepareStatement("select accesscode, max(accesstime) accesstime, count(*) number from accesslogs where userid=? and accesscode like 'A.%' and accesstime>? group by accesscode order by max(accesstime) desc");
        	ps.setInt(1,Integer.parseInt(activeUser.userid));
        	ps.setTimestamp(2,new Timestamp(new java.util.Date().getTime()-7*day));
        	ResultSet rs = ps.executeQuery();
        	int counter=0;
			try{
	        	while(rs.next() && counter<MedwanQuery.getInstance().getConfigInt("maxMostRecentHealthrecords",20)){
	        		String patientid = rs.getString("accesscode").replaceAll("A.", "");
	        		AdminPerson patient = AdminPerson.getAdminPerson(patientid);
	        		if(patient!=null && patient.lastname!=null && patient.lastname.length()>0){
	            		counter++;
	            		String cls = "admin2";
	            		java.sql.Timestamp lastaccess = rs.getTimestamp("accesstime");
	            		if(new java.util.Date().getTime()-lastaccess.getTime()>day){
	            			out.println("<tr class='listText'>");
	            		}else {
	            			out.println("<tr class='list'>");
	            			cls="admin";
	            		}
		        		out.println("<td class='admin'><a href='"+sCONTEXTPATH+"/patientslist.do?findPersonID="+patient.personid+"'>"+patient.personid+"</a></td>");
		        		out.println("<td class='"+cls+"'><b>"+patient.getFullName()+"</b></td>");
		        		out.println("<td class='"+cls+"'>"+patient.dateOfBirth+"</td>");
		        		out.println("<td class='"+cls+"'>"+patient.gender+"</td>");
		        		Encounter encounter=Encounter.getActiveEncounter(patient.personid);
		        		if(encounter!=null){
			        		out.println("<td class='"+cls+"'><a href='"+sCONTEXTPATH+"/patientslist.do?findUnit="+encounter.getServiceUID()+"'>"+(encounter.getService()==null?"":encounter.getService().getLabel(sWebLanguage))+"</a></td>");
			        		if(activeUser.getAccessRight("diagnoses.select")){
			        			String sDiagnoses = "<table>";
				        		Vector diagnoses = Diagnosis.selectDiagnoses("", "", encounter.getUid(), "", "", "", "", "", "", "", "", "", "");
				        		if(diagnoses.size()>0){
				        			for(int n=0;n<diagnoses.size();n++){
				        				Diagnosis diag = (Diagnosis)diagnoses.elementAt(n);
			        					sDiagnoses+="<tr><td>"+diag.getCode()+"</td><td><b>"+diag.getLabel(sWebLanguage)+"</b></td></tr>";
				        			}
				        		}
				        		out.println("<td class='"+cls+"'>"+sDiagnoses+"</table></td>");
			        		}
		        		}
		        		else{
			        		out.println("<td class='"+cls+"'></td><td class='"+cls+"'></td>");
		        		}
		        		out.println("<td class='"+cls+"'>"+new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(lastaccess)+" <img  style='vertical-align: middle' src='"+sCONTEXTPATH+"/_img/icons/icon_history2.gif' onclick='javascript:getAccessHistory(20,"+patient.personid+")'/></td>");
		        		out.println("<td class='"+cls+"'>"+rs.getInt("number")+"</td>");
		        		out.println("</tr>");
	        		}
	        	}
			}
			catch(Exception e){
				e.printStackTrace();
			}
        	rs.close();
        	ps.close();
        	conn.close();
        	if(counter==0){
        		if(activeUser.getAccessRight("diagnoses.select")){
        			out.println("<td colspan='8'>"+getTran(request,"web","norecordsfound",sWebLanguage)+"</td>");
        		}
        		else{
        			out.println("<td colspan='7'>"+getTran(request,"web","norecordsfound",sWebLanguage)+"</td>");
        		}
        	}
        	out.println("</table>");
        }
    }
    else{
    	ScreenHelper.setIncludePage("../datacenterstatistics/index.jsp",pageContext);
    }
%>
<script>
function getAccessHistory(nb,personid){
	var url = "<c:url value='/curative/ajax/getHistoryAccess.jsp'/>?nb="+nb+"&personid="+personid+"&ts="+new Date().getTime();
    Modalbox.show(url,{title:'<%=getTranNoLink("web","history",sWebLanguage)%>',width:420,height:370},{evalScripts:true});
  }
</script>