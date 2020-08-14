<%@page import="org.apache.commons.httpclient.HttpClient,
		org.apache.commons.httpclient.NameValuePair,
		org.apache.commons.httpclient.methods.GetMethod,
		org.apache.commons.httpclient.methods.PostMethod,com.digitalpersona.uareu.*"%>
<%@include file="/includes/helper.jsp"%>
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
	String sPageContent = "";
	HttpClient client = new HttpClient();
	String url = MedwanQuery.getInstance().getConfigString("readFingerPrint.jsp","http://localhost/openclinic/_common/dp/readFingerPrintRemote.jsp");
	GetMethod method = new GetMethod(url);
	client.executeMethod(method);
	//out.print(method.getResponseBodyAsString());
	String sSuccess="0";
	String sPersonId="-1";
	String[] results = method.getResponseBodyAsString().split(";");
	if(results.length>1 && results[1].length()>0){
		byte[] fingerprint = null;
		Fmd[] dbFmd = new Fmd[1];
		UareUGlobal.DestroyReaderCollection();
		Engine engine = UareUGlobal.GetEngine();
		Importer importer = UareUGlobal.GetImporter();
		Engine.Candidate[] candidates = null;
		sSuccess="1";
		//Now we try to find a matching fingerprint in the database
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("select * from oc_fingerprints");
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
     		fingerprint = rs.getBytes("template");
     		try{
				dbFmd[0] = importer.ImportFmd(fingerprint,Fmd.Format.ANSI_378_2004,Fmd.Format.ANSI_378_2004);
				Fid fid = importer.ImportFid(hexStringToByteArray(results[1]), Fid.Format.ANSI_381_2004);
				Fmd fmd = engine.CreateFmd(fid,Fmd.Format.ANSI_378_2004);
				candidates = engine.Identify(fmd,0,dbFmd,2147,1);
				if(candidates.length > 0){
					sPersonId = rs.getString("personid");
					break;
				}
			}
			catch(Exception e2){
				e2.printStackTrace();
			}
		}
		rs.close();
		ps.close();
		conn.close();
	}
%>
{
	"success":"<%=sSuccess%>",
	"personid":"<%=sPersonId %>"
}