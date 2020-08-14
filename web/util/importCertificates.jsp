<%@page import="java.io.*,java.nio.file.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	File dir = new File("/etc/openvpn/easy-rsa/keys");

	System.out.println("Searching for matches for "+dir.getAbsolutePath());
	
	File[] matches = dir.listFiles(new FilenameFilter()
	{
	  public boolean accept(File dir, String name)
	  {
	     return name.startsWith("gen.pibox.") && name.endsWith(".crt");
	  }
	});
	for(int n=0;n<matches.length;n++){
		System.out.println(matches[n].getPath());
		byte[] fileContent = Files.readAllBytes(matches[n].toPath());
		File keyFile = new File(matches[n].getPath().replaceAll("\\.crt", ".key"));
		byte[] keyContent = Files.readAllBytes(keyFile.toPath());
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("select * from oc_certificates where oc_certificate_id=?");
		ps.setString(1,matches[n].getName());
		ResultSet rs = ps.executeQuery();
		if(!rs.next()){
			rs.close();
			ps.close();
			ps=conn.prepareStatement("insert into oc_certificates(oc_certificate_id,oc_certificate_certificate,oc_certificate_key) values(?,?,?)");
			ps.setString(1,matches[n].getName());
			ps.setBytes(2, fileContent);
			ps.setBytes(3,keyContent);
			ps.execute();
			System.out.println("Inserted certificate "+matches[n].getName());
		}
		rs.close();
		ps.close();
		conn.close();
	}
%>