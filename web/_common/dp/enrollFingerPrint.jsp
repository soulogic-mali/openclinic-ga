<%@page import="org.apache.commons.httpclient.HttpClient,
		org.apache.commons.httpclient.NameValuePair,
		org.apache.commons.httpclient.methods.GetMethod,
		org.apache.commons.httpclient.methods.PostMethod"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	private static byte[] hexStringToByteArray(String s) {
	    int len = s.length();
	    byte[] data = new byte[len / 2];
	    for (int i = 0; i < len; i += 2) {
	        data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
	                             + Character.digit(s.charAt(i+1), 16));
	    }
	    return data;
	}
	private String ByteArrayToString(byte[] ba)
	{
	        StringBuilder strBuilder=new StringBuilder();
	        int ibyte;
	        for(int i=0;i<ba.length;i++)
	        {
	            ibyte= ba[i] & 0xFF;
	            if(ibyte<16)
	                strBuilder.append("0");
	            strBuilder.append(Integer.toHexString(ibyte));
	        }
	        return strBuilder.toString();
	}
%>
<%
	String 	rightleft = checkString(request.getParameter("rightleft")),
	finger    = checkString(request.getParameter("finger"));
	HttpClient client = new HttpClient();
	String url = MedwanQuery.getInstance().getConfigString("enrollFingerPrint.jsp","http://localhost/openclinic/_common/dp/enrollFingerPrintRemote.jsp");
	GetMethod method = new GetMethod(url);
	client.executeMethod(method);
	//out.print(method.getResponseBodyAsString());
	String sSuccess="Failed";
	String[] results = method.getResponseBodyAsString().split(";");
	if(results.length>1 && results[1].length()>0){
		sSuccess="1";
		try{		
			// delete existing prints for person
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("delete from OC_FINGERPRINTS where personid=? and finger=?");
			ps.setInt(1,Integer.parseInt(activePatient.personid));
			ps.setString(2,rightleft+finger);
			ps.execute();
			ps.close();		
			
			// store new print
			ps = conn.prepareStatement("insert into OC_FINGERPRINTS(personid,finger,template) values(?,?,?)");
			ps.setInt(1,Integer.parseInt(activePatient.personid));
			ps.setString(2,rightleft+finger);
			ps.setBytes(3,hexStringToByteArray(results[1]));
			ps.execute();
			ps.close();		
			
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
%>
{
	"success":"<%=sSuccess%>"
}