<%@page import="java.io.File"%>
<%@page import="be.openclinic.archiving.*"%>
<%
	Dcm2Jpg dcm2jpg = new Dcm2Jpg();
	dcm2jpg.convert(new File("c:/temp/test.dcm"), new File("c:/temp/test.jpg"));
	Dcm2Jpg.listSupportedFormats();
%>