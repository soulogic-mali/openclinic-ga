<%@page import="pe.gob.sis.FUA"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.awt.image.BufferedImage"%>
<%
	FUA fua = FUA.get(request.getParameter("fuauid"));
	response.setContentType("image/jpeg");
    ServletOutputStream os = response.getOutputStream();
    byte[] b = fua.getPatientFingerPrint();
    for(int n=0; n<b.length; n++){
        os.write(b[n]);
    }
	os.flush();
	os.close();
%>