<%@page import="be.openclinic.archiving.Dicom"%>
<%@page import="java.io.File"%>
<%@page import="org.dcm4che2.data.*"%>
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
%>
<%=sCSSNORMAL %>
<title><%=getTran(request,"web","labresults",sWebLanguage) %></title>
<html>
	<body>
		<form name='transactionForm' method='post'>
			<input type='hidden' name='formaction' id='formaction'/>
			<table width='100%' cellpadding='0' cellspacing='0'>
			<%
			
			%>
				<tr>
					<td colspan='2' style='font-size:8vw;text-align: right'>
						<img onclick="window.location.href='getImaging.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/back.png'/>
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
					<td colspan='2' style='font-size:6vw;'>
					<%
						int total=0;
						String uid = request.getParameter("uid");
						Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
						PreparedStatement ps = conn.prepareStatement("select count(*) total from OC_PACS where OC_PACS_STUDYUID=? and OC_PACS_SERIES=?");
						ps.setString(1,uid.split(";")[0]);
						ps.setString(2,uid.split(";")[1]);
						ResultSet rs = ps.executeQuery();
						if(rs.next()){
							total=rs.getInt("total");
						}
						rs.close();
						ps.close();
						ps = conn.prepareStatement("select * from OC_PACS where OC_PACS_STUDYUID=? and OC_PACS_SERIES=? order by OC_PACS_SEQUENCE*1");
						ps.setString(1,uid.split(";")[0]);
						ps.setString(2,uid.split(";")[1]);
						rs = ps.executeQuery();
						int skipImages = 0;
						if(request.getParameter("skipImages")!=null){
							try{
								skipImages=Integer.parseInt(request.getParameter("skipImages"));
							}
							catch(Exception e){
								e.printStackTrace();
							}
						}
						for(int n=0;n<skipImages;n++){
							rs.next();
						}
						if(rs.next()){
							String filename = activeUser.userid+".mobilepacs.jpg";
							try{
								String dicomfile=MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_basePath","/var/tomcat/webapps/openclinic/scan")+"/"+MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo","to")+"/"+rs.getString("OC_PACS_FILENAME");
								File dicomFile = new File(dicomfile);								
								DicomObject obj = be.openclinic.archiving.Dicom.getDicomObjectNoPixels(dicomFile);
								if(obj!=null){
					    			String sDescription=ScreenHelper.checkString(obj.getString(Tag.StudyDescription));
					    			if(sDescription.trim().length()==0){
						    			sDescription=ScreenHelper.checkString(obj.getString(Tag.AcquisitionDeviceProcessingDescription));
					    			}
					    			if(sDescription.trim().length()==0){
						    			sDescription=ScreenHelper.checkString(obj.getString(Tag.CodeMeaning));
					    			}
									out.println("<tr><td colspan='2' class='mobileadmin2'><table width='100%'><tr>");
									out.println("<td style='text-align: center;font-size: 6vw;'><img src='"+sCONTEXTPATH+"/_img/icons/mobile/left.png' onclick='loadImage(document.getElementById(\"skipImages\").value*1-1);'/></td>");
									out.println("<td style='text-align: center;font-size: 6vw;'>"+uid.split(";")[2]+" - "+sDescription.replaceAll("\\_"," ").replaceAll("\\^"," ")+" <span id='progressSpan' style='font-size:6vw'>["+(skipImages+1)+"/"+total+"]</span></td>");
									out.println("<td style='text-align: center;font-size: 6vw;'><img src='"+sCONTEXTPATH+"/_img/icons/mobile/right.png' onclick='loadImage(document.getElementById(\"skipImages\").value*1+1);'/></td>");
									out.println("</tr>");
									if(total>1){
										out.println("<tr><td class='mobileadmin2'><center><input style='width: 80%' id='skipImages' type='range' min='0' max='"+(total-1)+"' step='1' value='"+(skipImages)+"' onmouseup='loadImage(this.value*1);' ontouchend='loadImage(this.value*1);'/></center></td><td><img id='playimage' src='"+sCONTEXTPATH+"/_img/icons/mobile/play.png' onclick='activeimage=document.getElementById(\"skipImages\").value;togglePlay();'/></td></tr>");
									}
									out.println("</table></td></tr>");
									out.println("<tr>");
									out.println("<td colspan='2' style='text-align: center;'><img id='imagetag' style='max-width: 100%' src='"+sCONTEXTPATH+"/pacs/getDICOMJpeg.jsp?excludeFromFilter=1&uid="+uid+"'/></td>");
									out.println("</tr>");
									out.println("<tr>");
									out.println("<td colspan='2' class='mobileadmin2' style='text-align: left;font-size: 3vw'>"+getTran(request,"web","studyuid",sWebLanguage)+": "+rs.getString("OC_PACS_STUDYUID")+"</td>");
									out.println("</tr>");
								}
							}
							catch(Exception e){}
						}
						rs.close();
						ps.close();
						conn.close();
					%>
					</td>
				</tr>
			</table>
		</form>
		<script>
			var activeimage=0;
			var play=0;
			
			function togglePlay(){
				if(play==0){
					document.getElementById("playimage").src='<%=sCONTEXTPATH%>/_img/icons/mobile/stop.png';
					play=1;
					doPlay();
				}
				else{
					play=0;
					document.getElementById("playimage").src='<%=sCONTEXTPATH%>/_img/icons/mobile/play.png';
				}
			}
			
			function doPlay(){
				if(play==1){
					var cmd="doPlay();";
					if(document.getElementById('imagetag').complete){
						activeimage++;
						if(activeimage>document.getElementById("skipImages").max){
							activeimage=0;
						}
						document.getElementById("skipImages").value=activeimage;
						document.getElementById("progressSpan").innerHTML="["+(activeimage+1)+"/<%=total%>]";
						cmd="document.getElementById('imagetag').src='<%=sCONTEXTPATH%>/pacs/getDICOMJpeg.jsp?skipImages="+activeimage+"&uid=<%=uid%>&dummy='+new Date().getTime();doPlay();";
					}
					window.setTimeout(cmd,500);
				}
			}
			
			function loadImage(n){
				play=0;
				document.getElementById("playimage").src='<%=sCONTEXTPATH%>/_img/icons/mobile/play.png';
				if(n<=document.getElementById("skipImages").max && n>=0){
					document.getElementById("skipImages").value=n;
					document.getElementById("progressSpan").innerHTML="["+(n+1)+"/<%=total%>]";
					document.getElementById('imagetag').src='<%=sCONTEXTPATH%>/pacs/getDICOMJpeg.jsp?skipImages='+n+'&uid=<%=uid%>&dummy='+new Date().getTime();
				}
			}
			
		</script>
	</body>
</html>
<script>
	window.parent.parent.scrollTo(0,0);
</script>
<%
	}
%>