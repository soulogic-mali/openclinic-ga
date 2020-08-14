<%@page import="SecuGen.FDxSDKPro.jni.*,be.openclinic.system.*"%>
<%@include file="/includes/helper.jsp"%>
<%
	Debug.println("checking fingerprint image: "+checkString((String)session.getAttribute("fingerprintimage")));
	int nSuccess=-1;
	String sUserId="-1";
	long password=0;
	String fingerprintimage = checkString((String)session.getAttribute("fingerprintimage"));
	if(fingerprintimage.length()>0){
		byte[] fingerprintdb = null;
		byte[] fingerprinttest=fingerprintimage.getBytes();
		Debug.println("FingerPrintImage for session "+session.getId()+" = "+new String(fingerprinttest));
		//Now we try to find a matching fingerprint in the database
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("select * from oc_fingerprints a,usersview b where a.personid=b.personid");
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
     		fingerprintdb = rs.getBytes("template");
    		Debug.println("FingerPrintImage from db = "+new String(fingerprintdb));
            ///////////////////////////////////
            //Match ISO19794 Templates
            Debug.println("--------");
            FingerPrint fp = new FingerPrint();
            if(fp.initLib() && fp.initDevice()){
                Debug.println("Library initialized");
            	int match = fp.matchISO(fingerprintdb, fingerprinttest);
                Debug.println("Match = "+match);
				if(match>MedwanQuery.getInstance().getConfigInt("fingerPrintAuthenticationMatchLevel",50)){
					sUserId = rs.getString("userid");
					User user = User.get(Integer.parseInt(sUserId));
					password = User.hashPassword(user.password);
					nSuccess=1;
					break;
				}
			}
		}
		rs.close();
		ps.close();
		conn.close();
		if(sUserId.equalsIgnoreCase("-1")){
			session.setAttribute("fingerprintimage", "");
			nSuccess=0;
		}
	}
	if(checkString(((String)session.getAttribute("callId"))).equalsIgnoreCase("-1")){
		session.setAttribute("fingerprintimage", "");
		session.setAttribute("callId", "");
		nSuccess=-99;
	}
	Debug.println("success="+nSuccess);
%>
{
	"success":"<%=nSuccess%>",
	"userid":"<%=sUserId %>",
	"password":"<%=password %>"
}
