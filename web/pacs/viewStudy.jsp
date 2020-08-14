<%@page import="be.openclinic.common.OC_Object"%>
<%@ page import="be.mxs.common.util.db.*,be.mxs.common.util.system.*,java.sql.*" %>
<%
    // prepare response
    response.setHeader("Cache-Control", "max-age=30");
    response.setContentType("application/x-java-jnlp-file JNLP");
    response.setHeader("Content-disposition", "inline; filename="+MedwanQuery.getInstance().getConfigString("weasisJnlpFile","Weasis.jnlp"));
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
%>
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE jnlp PUBLIC "-//Sun Microsystems, Inc//DTD JNLP Descriptor 6.0//EN" "<%=MedwanQuery.getInstance().getConfigString("templateSource")%>JNLP-6.0.dtd">
  <jnlp spec="1.6+" codebase="<%=server+request.getRequestURI().replaceAll(request.getServletPath(),"")%>/weasis" href="">
  <information>
    <title>Weasis</title>
    <vendor>Weasis Team</vendor>
    <description>DICOM images viewer</description>
    <description kind="short">An application to visualize and analyze DICOM images.</description>
    <description kind="one-line">DICOM images viewer</description>
    <description kind="tooltip">Weasis</description>
  </information>
  <security>
    <all-permissions />
  </security>

  <resources>
    <!-- Requires Java SE 6 update 10 release for jnlp extension without codebase (substance.jnlp) -->
    <j2se version="1.6.0_10+" href="http://java.sun.com/products/autodl/j2se" initial-heap-size="128m" max-heap-size="512m" />
    <j2se version="1.6.0_10+" initial-heap-size="128m" max-heap-size="512m" />

    <jar href="<%=server+request.getRequestURI().replaceAll(request.getServletPath(),"")%>/weasis/weasis-launcher.jar" main="true" />
    <jar href="<%=server+request.getRequestURI().replaceAll(request.getServletPath(),"")%>/weasis/felix.jar" />

    <!-- Optional library (Substance Look and feel, only since version 1.0.8). Requires the new Java Plug-in introduced in the Java SE 6 update 10 release.For previous JRE 6, substance.jnlp needs a static codebase URL -->
    <extension href="<%=server+request.getRequestURI().replaceAll(request.getServletPath(),"")%>/weasis/substance.jnlp" />

    <!-- Allows to get files in pack200 compression, only since Weasis 1.1.2 -->
    <property name="jnlp.packEnabled" value="true" />

    <!-- ================================================================================================================= -->
    <!-- Security Workaround. Add prefix "jnlp.weasis" for having a fully trusted application without signing jnlp (only since weasis 1.2.9), http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6653241 -->
    <!-- Required parameter. Define the location of config.properties (the OSGI configuration and the list of plug-ins to install/start) -->
    <property name="jnlp.weasis.felix.config.properties" value="<%=server+request.getRequestURI().replaceAll(request.getServletPath(),"")%>/weasis/conf/config.properties" />
    <!-- Optional parameter. Define the location of ext-config.properties (extend/override config.properties) -->
    <property name="jnlp.weasis.felix.extended.config.properties" value="<%=server+request.getRequestURI().replaceAll(request.getServletPath(),"")%>/weasis-ext/conf/ext-config.properties" />
    <!-- Required parameter. Define the code base of Weasis for the JNLP -->
    <property name="jnlp.weasis.weasis.codebase.url" value="<%=server+request.getRequestURI().replaceAll(request.getServletPath(),"")%>/weasis" />
    <!-- Optional parameter. Define the code base ext of Weasis for the JNLP -->
    <property name="jnlp.weasis.weasis.codebase.ext.url" value="<%=server+request.getRequestURI().replaceAll(request.getServletPath(),"")%>/weasis-ext" />
    <!-- Required parameter. OSGI console parameter -->
    <property name="jnlp.weasis.gosh.args" value="-sc telnetd -p 17179 start" />
    <!-- Optional parameter. Allows to have the Weasis menu bar in the top bar on Mac OS X (works only with the native Aqua look and feel) -->
    <property name="jnlp.weasis.apple.laf.useScreenMenuBar" value="true" />
    <!-- Optional parameter. Allows to get plug-ins translations -->
    <property name="jnlp.weasis.weasis.i18n" value="<%=server+request.getRequestURI().replaceAll(request.getServletPath(),"")%>/weasis-i18n" />
    <!-- Optional Weasis Documentation -->
    <!-- <property name="jnlp.weasis.weasis.help.url" value="${cdb}/../weasis-doc" /> -->
    <!-- ================================================================================================================= -->
  </resources>
  <application-desc main-class="org.weasis.launcher.WebstartLauncher">
    <argument>$dicom:get -w <%=server %><%=request.getRequestURI().replaceAll(request.getServletPath(),"")%>/pacs/wadoQuery.jsp?wadouid=<%=wadoid %></argument>
  </application-desc>
  </jnlp>