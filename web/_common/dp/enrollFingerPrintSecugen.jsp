<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="SecuGen.FDxSDKPro.jni.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	if(checkString(request.getParameter("init")).equalsIgnoreCase("true")){
		session.removeAttribute("fingerprintimage");
		session.removeAttribute("fingerprintjpg");
	}
	Debug.println("checking fingerprint image: "+checkString((String)session.getAttribute("fingerprintimage")));
	int nSuccess=-1;
	String fingerprintimage = checkString((String)session.getAttribute("fingerprintimage"));
	BufferedImage fingerprintjpg = (BufferedImage)session.getAttribute("fingerprintjpg");
	if(fingerprintimage.length()>0){
		Debug.println("fingerprintimage = "+fingerprintimage.length());
		Debug.println("fingerprintjpg = "+fingerprintjpg.getData().getDataBuffer().getSize());
	    String rightleft = checkString(request.getParameter("rightleft")),
	            finger    = checkString(request.getParameter("finger"));
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("delete from OC_FINGERPRINTS where personid=? and finger=?");
		ps.setInt(1,Integer.parseInt(activePatient.personid));
		ps.setString(2,rightleft+finger);
		ps.execute();
		ps.close();		
		ps = conn.prepareStatement("insert into OC_FINGERPRINTS(personid,finger,template,jpg) values(?,?,?,?)");
		ps.setInt(1,Integer.parseInt(activePatient.personid));
		ps.setString(2,rightleft+finger);
		ps.setBytes(3,fingerprintimage.getBytes());
		java.io.ByteArrayOutputStream baos = new ByteArrayOutputStream();
		javax.imageio.ImageIO.write( fingerprintjpg, "jpg", baos );
		baos.flush();
		ps.setBytes(4, baos.toByteArray());
		baos.close();
		ps.execute();
		ps.close();		
		conn.close();
		nSuccess=1;
		javax.imageio.ImageIO.write( fingerprintjpg, "jpg", new java.io.File(MedwanQuery.getInstance().getConfigString("tempDirectory","c:/temp")+"/nfp.jpg") );
	}
%>
{
	"success":"<%=nSuccess%>",
}
