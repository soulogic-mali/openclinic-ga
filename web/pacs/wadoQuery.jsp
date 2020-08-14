<%@ page import="be.mxs.common.util.db.*,be.mxs.common.util.system.*,java.sql.*" %><?xml version="1.0" encoding="utf-8"?>
<%	
	String server=MedwanQuery.getInstance().getConfigString("PACSFileServer",(request.isSecure()?"https":"http")+"://"+ request.getServerName())+":"+MedwanQuery.getInstance().getConfigInt("PACSFileServerPort",request.getServerPort());
	String wadoid=ScreenHelper.checkString(request.getParameter("wadouid"));
	String studyuid=MedwanQuery.getInstance().getConfigString(wadoid);
	if(studyuid.split("@").length>2){
		System.out.println("sessionid = "+studyuid.split("@")[2]);
		System.out.println("session = "+MedwanQuery.getSession(studyuid.split("@")[2]));
		MedwanQuery.getSession(studyuid.split("@")[2]).setAttribute("wadoQueryStarted", "1");
	}
	if(wadoid.length()==0){
		studyuid=ScreenHelper.checkString(request.getParameter("studyuid")+"@"+ScreenHelper.checkString(request.getParameter("seriesuid")));		
	}
%>
<wado_query wadoURL="<%=server%><%=request.getRequestURI().replaceAll(request.getServletPath(),"")%>/<%=MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_url","scan")%>/<%=MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo","to")+"/"%>">
	<Patient><%
					//assemble filelist
					try{
						Connection conn=MedwanQuery.getInstance().getOpenclinicConnection();
						String[] activestudyuid=studyuid.split("@")[0].split("\\_");
						String[] activeseriesid=studyuid.split("@")[1].split("\\_");
						for(int n = 0;n<activestudyuid.length;n++){
							%>
		<Study StudyInstanceUID="<%=activestudyuid[n]%>">
			<Series SeriesInstanceUID="<%=activestudyuid[n]+"."+activeseriesid[n] %>" SeriesNumber="<%=activeseriesid[n]%>" DirectDownloadThumbnail=""><%
							Debug.println("looking for study "+activestudyuid[n]+ " / "+activeseriesid[n]);
							String sQuery="select * from OC_PACS where OC_PACS_STUDYUID=? and OC_PACS_SERIES=? order by OC_PACS_SEQUENCE";
							if(activeseriesid[n].length()==0){
								sQuery="select * from OC_PACS where OC_PACS_STUDYUID=? order by OC_PACS_SEQUENCE";
							}
							PreparedStatement ps =conn.prepareStatement(sQuery);
							ps.setString(1, activestudyuid[n]);
							if(activeseriesid[n].length()>0){
								ps.setString(2, activeseriesid[n]);
							}
							ResultSet rs =ps.executeQuery();
							int counter=0;
							while(rs.next()){%>
				<Instance SOPInstanceUID='<%=rs.getString("OC_PACS_STUDYUID")+"."+rs.getString("OC_PACS_SERIES")+"."+rs.getString("OC_PACS_SEQUENCE")+"' DirectDownloadFile='"+rs.getString("OC_PACS_FILENAME")+"' InstanceNumber='"+rs.getString("OC_PACS_SEQUENCE")%>'/><%}
							rs.close();
							ps.close();	%>
			</Series>
		</Study><%
						}
						conn.close();
					}
					catch(Exception e){
						e.printStackTrace();
					}
				%>
	</Patient>
</wado_query>
<%out.flush(); %>
