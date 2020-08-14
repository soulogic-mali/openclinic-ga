<%@page import="ocdhis2.*,be.mxs.common.util.system.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<style>
	.progress_bar {
	  position:fixed;
	  top: 0;
	  height: 6px;
	  background:url(../../_img/themes/default/tradmin_bg.gif) no-repeat #4975A7;
	  width: 0%;
	  -moz-transition: all 4s ease;
	  -moz-transition-delay: 1s;
	  -webkit-transition: all 4s ease;
	  -webkit-transition-delay: 1s;
	  transition: all 4s ease;
	  transition-delay: 1s;
	}
	
	body {
	     padding-top: 10px; 
	}
</style>
<%
	String uids = checkString(request.getParameter("uids"));
	try{
		long day = 24*3600*1000;
		long month=32*day;
		DHIS2Exporter exporter = new DHIS2Exporter(uids);
		
		String format = checkString(request.getParameter("format"));
		if(ScreenHelper.parseDate(request.getParameter("begin"))!=null && ScreenHelper.parseDate(request.getParameter("end"))!=null){
			exporter.setBegin(ScreenHelper.parseDate(request.getParameter("begin")));
			exporter.setEnd(ScreenHelper.parseDate(request.getParameter("end")));
		}
		else{
			exporter.setBegin(new SimpleDateFormat("yyyyMMdd").parse(request.getParameter("period")+"01"));
			exporter.setEnd(new SimpleDateFormat("yyyyMMdd").parse(new SimpleDateFormat("yyyyMM").format(new java.util.Date(exporter.getBegin().getTime()+month))+"01"));
		}
		exporter.setDhis2document(MedwanQuery.getInstance().getConfigString("templateDirectory","/var/tomcat/webapps/openclinic/_common_xml")+"/"+MedwanQuery.getInstance().getConfigString("dhis2document","dhis2.bi.xml"));
		exporter.setLanguage(sWebLanguage);
		if(format.equalsIgnoreCase("html") && exporter.export("html")){
			out.println(exporter.getHtml());
		}
		else if(format.equalsIgnoreCase("dhis2server")){
			exporter.setJspWriter(out);
			out.println("<div id='progressBar' class='progress_bar'></div><script>document.getElementById('progressBar').style.width='0%';</script>");
			out.flush();
			
			if(exporter.export("dhis2server")){
				Thread.sleep(4000);
				out.println("<font style='font-size: 16px; font-weight: bold'><br/>"+getTran(request,"web","successfultransmission",sWebLanguage)+"</font><script>document.body.scrollTop = document.body.scrollHeight;</script>");
			}
			else{
				out.println("Error sending data to DHIS2!<p/>"+DHIS2Helper.sError+"<script>document.body.scrollTop = document.body.scrollHeight;</script>");
			}
		}
		else if(format.equalsIgnoreCase("dhis2serverdelete")){
			exporter.setJspWriter(out);
			out.println("<div id='progressBar' class='progress_bar'></div>");
			if(exporter.export("dhis2serverdelete")){
				Thread.sleep(5000);
				out.println("<font style='font-size: 16px; font-weight: bold'>"+getTran(request,"web","successfultransmission",sWebLanguage)+"</font><script>document.body.scrollTop = document.body.scrollHeight;</script>");
			}
			else{
				out.println("Error sending data to DHIS2!<p/>"+DHIS2Helper.sError+"<script>document.body.scrollTop = document.body.scrollHeight;</script>");
			}
		}
		else{
			out.println("Error sending data to DHIS2!<p/>"+DHIS2Helper.sError);
		}
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>

<script>
	function showRecords(dataset,dataelement,option,attributeoption,datasettitle){
		var URL="/statistics/showDHIS2Records.jsp&datasettitle="+datasettitle+"&dataset="+dataset+"&dataelement="+dataelement+"&option="+option+"&attributeoption="+attributeoption+"&period=<%=request.getParameter("period")%>&end=<%=request.getParameter("end")%>&begin=<%=request.getParameter("begin")%>";
		openPopup(URL,800,600,"OpenClinic-DHIS2-Records");
	}
</script>
