 <%@page import="be.openclinic.archiving.*"%>
<%@page import="be.mxs.common.util.db.MedwanQuery"%>
<%@page import="pe.gob.sis.*,java.util.*,javax.xml.soap.*,org.dom4j.*,org.dom4j.io.*,java.io.*"%>
<%@page import="java.util.TimeZone"%>
<%
	ScanDirectoryMonitor.bulkLoadDICOM();
 %>