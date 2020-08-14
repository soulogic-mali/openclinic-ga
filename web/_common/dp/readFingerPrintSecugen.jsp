<%@page import="SecuGen.FDxSDKPro.jni.*,be.openclinic.system.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	Debug.println("checking fingerprint image: "+checkString((String)session.getAttribute("fingerprintimage")));
	int nSuccess=-1;
	String fingerprintimage = checkString((String)session.getAttribute("fingerprintimage"));
	if(fingerprintimage.length()>0){
		if(request.getParameter("noverify")==null){
			byte[] fingerprintdb = null;
			byte[] fingerprinttest=fingerprintimage.getBytes();
			Debug.println("FingerPrintImage for session "+session.getId()+" = "+new String(fingerprinttest));
			//Now we try to find a matching fingerprint in the database
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("select * from oc_fingerprints where personid=?");
			ps.setInt(1,Integer.parseInt(activePatient.personid));
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
						nSuccess=1;
						break;
					}
				}
			}
			rs.close();
			ps.close();
			conn.close();
			if(nSuccess==-1){
				session.setAttribute("fingerprintimage", "");
				nSuccess=0;
			}
		}
		else{
			nSuccess=1;
		}
	}
%>
{
	"success":"<%=nSuccess%>"
}
