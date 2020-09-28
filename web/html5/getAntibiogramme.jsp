<%@page import="be.openclinic.medical.*"%>
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
	String uid=request.getParameter("uid");
	String serverid = uid.split("\\.")[0];
	String transactionid = uid.split("\\.")[1];
	String labcode = uid.split("\\.")[2];
    if(activeUser==null || activeUser.person==null){
        out.println("<script>window.location.href='login.jsp';</script>");
        out.flush();
    }
    else{
    	TransactionVO transactionVO = MedwanQuery.getInstance().loadTransaction(Integer.parseInt(uid.split("\\.")[0]), Integer.parseInt(uid.split("\\.")[1]));
%>
<%=sCSSNORMAL %>
<title><%=getTran(request,"web","labresults",sWebLanguage) %></title>
<html>
	<body>
		<form name='transactionForm' method='post'>
			<input type='hidden' name='formaction' id='formaction'/>
			<table width='100%'>
				<tr>
					<td colspan='2' style='font-size:8vw;text-align: right'>
						<img onclick="window.location.href='getLabResults.jsp?uid=<%=serverid %>.<%=transactionid %>'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/back.png'/>
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
					<%
						LabAnalysis labanalysis = LabAnalysis.getLabAnalysisByLabcode(labcode);
					%>
					<td colspan='2' class='mobileadmin' style='font-size:6vw;'><%=getTranNoLink("labanalysis",labanalysis.getLabId()+"",sWebLanguage) %> <span style='font-size: 4vw;font-weight: normal'>[<%=ScreenHelper.formatDate(transactionVO.getUpdateTime()) %>]</span></td>
				</tr>
				<%
					String antibiotics="pen,oxa,amp,amc,czo,mec,ctx,gen,amk,chl,tcy,col,ery,lin,pri,sxt,nit,nal,cip,ipm";
					String[] extraAntibiotics=MedwanQuery.getInstance().getConfigString("extraAntibiotics","").split(";");
					for(int n=0;n<extraAntibiotics.length;n++){
						antibiotics+=","+extraAntibiotics[n];
					}
					Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
					PreparedStatement ps = conn.prepareStatement("select * from oc_antibiograms where oc_ab_requestedlabanalysisuid=?");
					ps.setString(1,uid);
					ResultSet rs = ps.executeQuery();
					while(rs.next()){
						String germ = checkString(rs.getString("oc_ab_germ1"));
						if(germ.length()>0){
							out.println("<tr>");
							out.println("<td colspan='2' class='mobileadmin' style='font-size:6vw;'><img src='"+sCONTEXTPATH+"/_img/icons/mobile/germ.png'/>"+germ+"</td>");
							out.println("</tr>");
						}
						String[] ab = checkString(rs.getString("oc_ab_antibiogramme1")).split(",");
						for(int n=0;n<ab.length;n++){
							if(ab[n].split("=").length>1){
								out.println("<tr>");
								out.println("<td class='mobileadmin2' style='"+(ab[n].split("=")[1].equalsIgnoreCase("1")?"background-color:#99cc99;":"")+"text-align: center;font-weight: bold;font-size:6vw;'>"+"S,R,I".split(",")[Integer.parseInt(ab[n].split("=")[1])-1]+"</td>");
								out.println("<td class='mobileadmin2' style='"+(ab[n].split("=")[1].equalsIgnoreCase("1")?"background-color:#99cc99;":"")+"font-size:6vw;'>"+ScreenHelper.capitalize(getTranNoLink("antibiotics",antibiotics.split(",")[Integer.parseInt(ab[n].split("=")[0])-1],sWebLanguage))+"</td>");
								out.println("</tr>");
							}
						}
						germ = checkString(rs.getString("oc_ab_germ2"));
						if(germ.length()>0){
							out.println("<tr>");
							out.println("<td colspan='2' class='mobileadmin' style='font-size:6vw;'><img src='"+sCONTEXTPATH+"/_img/icons/mobile/germ.png'/>"+germ+"</td>");
							out.println("</tr>");
						}
						ab = checkString(rs.getString("oc_ab_antibiogramme2")).split(",");
						for(int n=0;n<ab.length;n++){
							if(ab[n].split("=").length>1){
								out.println("<tr>");
								out.println("<td class='mobileadmin2' style='"+(ab[n].split("=")[1].equalsIgnoreCase("1")?"background-color:#99cc99;":"")+"text-align: center;font-weight: bold;font-size:6vw;'>"+"S,R,I".split(",")[Integer.parseInt(ab[n].split("=")[1])-1]+"</td>");
								out.println("<td class='mobileadmin2' style='"+(ab[n].split("=")[1].equalsIgnoreCase("1")?"background-color:#99cc99;":"")+"font-size:6vw;'>"+ScreenHelper.capitalize(getTranNoLink("antibiotics",antibiotics.split(",")[Integer.parseInt(ab[n].split("=")[0])-1],sWebLanguage))+"</td>");
								out.println("</tr>");
							}
						}
						germ = checkString(rs.getString("oc_ab_germ3"));
						if(germ.length()>0){
							out.println("<tr>");
							out.println("<td colspan='2' class='mobileadmin' style='font-size:6vw;'><img src='"+sCONTEXTPATH+"/_img/icons/mobile/germ.png'/>"+germ+"</td>");
							out.println("</tr>");
						}
						ab = checkString(rs.getString("oc_ab_antibiogramme3")).split(",");
						for(int n=0;n<ab.length;n++){
							if(ab[n].split("=").length>1){
								out.println("<tr>");
								out.println("<td class='mobileadmin2' style='"+(ab[n].split("=")[1].equalsIgnoreCase("1")?"background-color:#99cc99;":"")+"text-align: center;font-weight: bold;font-size:6vw;'>"+"S,R,I".split(",")[Integer.parseInt(ab[n].split("=")[1])-1]+"</td>");
								out.println("<td class='mobileadmin2' style='"+(ab[n].split("=")[1].equalsIgnoreCase("1")?"background-color:#99cc99;":"")+"font-size:6vw;'>"+ScreenHelper.capitalize(getTranNoLink("antibiotics",antibiotics.split(",")[Integer.parseInt(ab[n].split("=")[0])-1],sWebLanguage))+"</td>");
								out.println("</tr>");
							}
						}
					}
					rs.close();
					ps.close();
					conn.close();
				%>
			</table>
		</form>
	</body>
</html>
<script>
	window.parent.parent.scrollTo(0,0);
</script>
<%
	}
%>