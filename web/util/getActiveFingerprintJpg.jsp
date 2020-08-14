<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.awt.image.BufferedImage"%>
<%
	response.setContentType("image/jpeg");
	ImageIO.write( (BufferedImage)session.getAttribute("fingerprintjpg"), "jpg", response.getOutputStream() );
	response.getOutputStream().close();
%>