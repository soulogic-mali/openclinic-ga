<%@page import="java.io.PrintWriter"%>
<%@page import="be.openclinic.medical.ResultsProfile,
                java.util.*,
                be.openclinic.medical.LabRequest,
                be.openclinic.medical.RequestedLabAnalysis"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"labos.prepareworklists","select",activeUser)%>
<%
    String activeProfile = checkString(request.getParameter("activeProfile"));

    if(request.getParameter("save")!=null){
    	String sExportToIM="";
    	boolean bExportToIM = MedwanQuery.getInstance().getConfigInt("enableExportToIM",0)==1;
        // Save the data
        Enumeration parameters = request.getParameterNames();
        while(parameters.hasMoreElements()){
            String name = (String)parameters.nextElement();
            String fields[] = name.split("\\.");
            if(fields[0].equalsIgnoreCase("store")){
                if(fields[3].equalsIgnoreCase("worklisted")){
                    if(bExportToIM){
                    	//Add the lab analyses that have been put on the worklist to export file
				        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
                        try{
                            String sQuery="select * from RequestedLabAnalyses r,adminview a where r.patientid=a.personid and serverid=? and transactionid=? and analysiscode in ("+request.getParameter("worklistAnalyses")+") and worklisteddatetime is null";
                            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
                            ps.setInt(1,Integer.parseInt(fields[1]));
                            ps.setInt(2,Integer.parseInt(fields[2]));
                            ResultSet rs = ps.executeQuery();
                            while(rs.next()){
                            	sExportToIM+=fields[2]+";";
                            	sExportToIM+=new SimpleDateFormat("yyyyMMddHHmmss").format(rs.getTimestamp("requestdatetime"))+";";
                            	sExportToIM+=rs.getString("patientid")+";";
                            	sExportToIM+=rs.getString("gender")+";";
                            	sExportToIM+=new SimpleDateFormat("yyyyMMdd").format(rs.getDate("dateofbirth"))+";";
                            	sExportToIM+=rs.getString("analysiscode")+";\r\n";
                            }
                            rs.close();
                            ps.close();
                        }
                        catch(Exception e){
                            e.printStackTrace();
                        }
               			oc_conn.close();
                    }	
                    RequestedLabAnalysis.setWorklisted(Integer.parseInt(fields[1]),Integer.parseInt(fields[2]),request.getParameter("worklistAnalyses"));
                }
            }
            if(bExportToIM && sExportToIM.length()>0){
            	//Now write the file for IM to a shared directory
            	String sFilename=MedwanQuery.getInstance().getConfigString("OC2IMDirectory","c:/temp")+"/"+new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date())+".oc2im";
            	org.apache.commons.io.FileUtils.writeStringToFile(new java.io.File(sFilename), sExportToIM);
            }
        }
    }

%>
<form name="frmWorkLists" method="post">
    <%=writeTableHeader("Web","prepareWorklists",sWebLanguage," doBack();")%>
    
    <table width="100%" cellspacing="1" cellpadding="1" class="menu">
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","worklist",sWebLanguage)%></td>
            <td class="admin2">            
                <select class="text" name="activeProfile">
                    <%
                        Hashtable profiles = ResultsProfile.getProfiles(sWebLanguage);
                        if(profiles.size() > 0){
                            Enumeration enumeration = profiles.keys();
                            while(enumeration.hasMoreElements()){
                                String label = (String)enumeration.nextElement();
                                ResultsProfile resultsProfile = (ResultsProfile)profiles.get(label);
                                out.print("<option value='" +resultsProfile.getProfileID()+"'"+(activeProfile.equalsIgnoreCase(""+resultsProfile.getProfileID())?" selected ":"")+">"+label+"</option>");
                            }
                        }
                    %>
                </select>&nbsp;
                
                <input class="button" type="submit" name="submit" value="<%=getTranNoLink("web","find",sWebLanguage)%>"/>
            </td>
        </tr>
    </table>

<%
    if(activeProfile.length() > 0){
        // START OF WORKLIST HEADER
        %>
        <br>
        <div id='divscroll' class='tscroll'>
        <table width="100%" cellspacing="1" cellpadding="0">
           	<thead>
            <tr>
            	<td style='min-width: 300px' class='tscrollcorner'>
            		<table width='100%'>
            			<tr class='tscrolladmin'>
			                <td width='80px'><%=getTran(request,"web","ID",sWebLanguage)%><br/><%=getTran(request,"web","date",sWebLanguage)%></td>
			                <td><%=getTran(request,"web","patient",sWebLanguage)%><br/><%=getTran(request,"web","service",sWebLanguage)%></td>
			            </tr>
			        </table>
			    </td>
        <%
            // Show the selected worklist
            // Find all  analysis that are part of the active profile
            System.out.println(new SimpleDateFormat("HH:mm:ss.SSS").format(new java.util.Date())+": 1");
            Vector profileAnalysis = ResultsProfile.searchLabProfilesDataByProfileID(activeProfile,sWebLanguage);
        	
	    	//Calculate content columns
            String worklistAnalyses = "";
            for(int n=0; n<profileAnalysis.size(); n++){
                Hashtable analysis = (Hashtable)profileAnalysis.elementAt(n);
                if(n > 0){
                    worklistAnalyses+= ",";
                }
                worklistAnalyses+= "'"+analysis.get("labcode")+"'";
            }
	    	HashSet hContentColumns = new HashSet();
	        Vector results = new Vector();
            System.out.println(new SimpleDateFormat("HH:mm:ss.SSS").format(new java.util.Date())+": 2");
	        System.out.println(worklistAnalyses);
            results = LabRequest.findNotOnWorklistRequests(worklistAnalyses, sWebLanguage);
            for(int n=0; n<results.size(); n++){
                LabRequest labRequest = (LabRequest)results.elementAt(n);
                for(int i=0; i<profileAnalysis.size(); i++){
                    Hashtable analysis = (Hashtable) profileAnalysis.elementAt(i);
                    RequestedLabAnalysis requestedLabAnalysis = (RequestedLabAnalysis)labRequest.getAnalyses().get(analysis.get("labcode"));
                    if(requestedLabAnalysis != null){
                        hContentColumns.add(analysis.get("labcode"));
                    }
                }
            }
	        // Construct the results header
            for(int n=0; n<profileAnalysis.size(); n++){
                Hashtable analysis = (Hashtable)profileAnalysis.elementAt(n);
                if(hContentColumns.contains(analysis.get("labcode"))){
                	out.print("<td class='tscrollrow' style='min-width: 50px;text-align: center'>"+analysis.get("mnemonic")+"<BR/>"+checkString((String) analysis.get("unit"))+"</td>");
                }
            }
            out.print("<td class='tscrollrow'>"+getTran(request,"web","lab.setworklist",sWebLanguage)+"</td>");
			out.print("</tr>");
            String bgcolor="#fff";
            // Find all lab requests for this worklist
            for(int n=0; n<results.size(); n++){
                System.out.println(new SimpleDateFormat("HH:mm:ss.SSS").format(new java.util.Date())+": 3");
                LabRequest labRequest = (LabRequest)results.elementAt(n);
                if(bgcolor.equals("#fff")){
                	bgcolor="#eee";
                }
                else{
                	bgcolor="#fff";
                }
                out.print("<tr>");
                out.print("<td class='tscrollcol'>");
                out.print("<table width='100%'>");
                out.print("<tr>");
                out.print("<td width='80px'><a class='tscrolladmin' href='javascript:showRequest("+labRequest.getServerid()+","+labRequest.getTransactionid()+")'>"+labRequest.getTransactionid()+"</a><br/>"+ScreenHelper.formatDate(labRequest.getRequestdate())+"</td>");
                out.print("<td class='tscrolladmin'><a class='tscrolladmin' href='javascript:readBarcode3(\"0"+labRequest.getPersonid()+"\");'><b>"+labRequest.getPatientname()+"</b></a> (°"+(labRequest.getPatientdateofbirth()!=null?ScreenHelper.formatDate(labRequest.getPatientdateofbirth()):"")+" - "+labRequest.getPatientgender()+")<br/><i>"+labRequest.getServicename()+" - "+MedwanQuery.getInstance().getUserName(labRequest.getUserid())+"</i></td>");
                out.print("</tr>");
                out.print("</table>");
                out.print("</td>");
                // Add all analysis results/requests
                for(int i=0; i<profileAnalysis.size(); i++){
                    Hashtable analysis = (Hashtable) profileAnalysis.elementAt(i);
                    if(hContentColumns.contains(analysis.get("labcode"))){
                    	RequestedLabAnalysis requestedLabAnalysis = (RequestedLabAnalysis)labRequest.getAnalyses().get(analysis.get("labcode"));
	                    if(requestedLabAnalysis != null){
	                        out.print("<td style='background-color: "+bgcolor+"'><center>X</center></td>");
	                    }
	                    else{
	                        out.print("<td style='background-color: "+bgcolor+"'></td>");
	                    }
                    }
                }
                out.print("<td style='background-color: "+bgcolor+";min-width: 100px;text-align: center'><input class='checkbox' type='checkbox' name='store."+labRequest.getServerid()+"."+labRequest.getTransactionid()+".worklisted'}'/></td>");
                out.print("</tr>");
            }
        %>
        </table>
        </div>
        <input class="button" type="submit" name="save" value="<%=getTranNoLink("web","save",sWebLanguage)%>"/>
        <input type="hidden" name="worklistAnalyses" value="<%=worklistAnalyses%>"/>
        <%
    }
%>
</form>

<script>
  document.getElementById('divscroll').style.width=(document.documentElement.offsetWidth-5)+"px";
  document.getElementById('divscroll').style.height=document.documentElement.offsetHeight-document.getElementById('divscroll').getBoundingClientRect().y-38;

  function showRequest(serverid,transactionid){
    window.open("<c:url value="/popup.jsp"/>?Page=labos/manageLabResult_view.jsp&ts=<%=getTs()%>&show."+serverid+"."+transactionid+"=1","Popup"+new Date().getTime(),"toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=800,height=600,menubar=no");
  }

  function doBack(){
    window.location.href = "<c:url value='/main.do'/>?Page=labos/index.jsp";
  }
  
</script>