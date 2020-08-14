<%@page import="be.openclinic.common.OC_Object"%><%@ page import="be.mxs.common.util.db.*,be.mxs.common.util.system.*,java.sql.*" %><%
	response.setHeader("Cache-Control", "max-age=30");
	response.setContentType("application/x-java-wado-file WADO");
	response.setHeader("Content-disposition", "inline; filename=openclinic.WADOC");
    String server=(request.getProtocol().toLowerCase().startsWith("https")?"https":"http")+"://"+ request.getServerName()+":"+request.getServerPort();
	long sid=new java.util.Date().getTime();
	long oid=new java.util.Random().nextInt();
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("delete from oc_config where oc_key like 'wadouid.%' and updatetime<?");
	ps.setTimestamp(1, new Timestamp(new java.util.Date().getTime()-120000));
	ps.execute();
	ps.close();
	conn.close();
	MedwanQuery.getInstance().reloadConfigValues();
	String wadoid="wadouid."+sid+"."+oid;
	MedwanQuery.getInstance().setConfigString(wadoid, request.getParameter("studyuid")+"@"+request.getParameter("seriesid")+"@"+session.getId());
%>viewer-win32.exe $dicom:get -w <%=server %><%=request.getRequestURI().replaceAll(request.getServletPath(),"")%>/pacs/wadoQuery.jsp?wadouid=<%=wadoid %>
