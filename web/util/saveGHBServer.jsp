<%@page import="java.util.Hashtable,java.io.*,
                javazoom.upload.UploadFile,
                javazoom.upload.MultipartFormDataRequest"%>
<%@page import="org.dom4j.*,org.dom4j.tree.*"%><%@page import="be.openclinic.system.Encryption"%><%@page errorPage="/includes/error.jsp"%><%@include file="/includes/helper.jsp"%><%
	MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
	String sToken = checkString(mrequest.getParameter("ghb_ref_token"));
	String sCrypToken = checkString(mrequest.getParameter("ghb_ref_cryptoken"));
	String sDomain = checkString(mrequest.getParameter("ghb_ref_domain"));
	String sName = checkString(mrequest.getParameter("ghb_ref_name"));
	String sContact = checkString(mrequest.getParameter("ghb_ref_contact"));
	String sPhone = checkString(mrequest.getParameter("ghb_ref_telephone"));
	String sEmail = checkString(mrequest.getParameter("ghb_ref_email"));
	String sPubkey = checkString(mrequest.getParameter("ghb_ref_pubkey"));
	Element root = DocumentHelper.createElement("response");
	boolean bSuccess = false;

	System.out.println("Token="+sToken);
	System.out.println("Domain="+sDomain);
	Connection conn = MedwanQuery.getInstance().getStatsConnection();
	PreparedStatement ps = conn.prepareStatement("select * from GHB_TOKENS where GHB_TOKEN=? and GHB_TOKEN_COUNT>0 and ? like GHB_TOKEN_DOMAIN"+MedwanQuery.getInstance().concatSign()+"'%'");
	ps.setString(1,sToken);
	ps.setString(2,sDomain);
	ResultSet rs = ps.executeQuery();
	if(rs.next()){
		int nServerId;
		if(checkString(mrequest.getParameter("ghb_ref_serverid")).length()>0){
			nServerId=Integer.parseInt(mrequest.getParameter("ghb_ref_serverid"));
			rs.close();
			ps.close();
			ps=conn.prepareStatement("select GHB_SERVER_PUBKEY from GHB_SERVERS where GHB_SERVER_ID=?");
			ps.setInt(1,nServerId);
			rs=ps.executeQuery();
			if(rs.next()){
				String sPk = rs.getString("GHB_SERVER_PUBKEY");
				if(sToken.equals(Encryption.decryptTextWithPublicKey(sCrypToken, sPk))){
					if(checkString(mrequest.getParameter("delete")).equalsIgnoreCase("1")){
						rs.close();
						ps.close();
						ps=conn.prepareStatement("delete from GHB_SERVERS where GHB_SERVER_ID=?");
						ps.setInt(1,nServerId);
						ps.execute();
					}
					else{
						//CrypToken was encrypted with the private key for the server, so we can trust the origin
						//If the pubkey is empty, we have to create a new private/public key pair
						if(sPubkey.length()==0){
							Encryption encryption = new Encryption();
							encryption.createKeys();
							sPubkey=encryption.getPublicKeyBase64();
							String sPrivkey = encryption.getPrivateKeyBase64();
							root.addElement("pubkey").setText(sPubkey);
							root.addElement("privkey").setText(sPrivkey);
						}
						rs.close();
						ps.close();
						ps=conn.prepareStatement("update GHB_SERVERS set GHB_SERVER_DOMAIN=?,GHB_SERVER_NAME=?,GHB_SERVER_CONTACT=?,GHB_SERVER_PHONE=?,GHB_SERVER_EMAIL=?,GHB_SERVER_PUBKEY=?,GHB_SERVER_UPDATETIME=? where GHB_SERVER_ID=?");
						ps.setString(1,sDomain);
						ps.setString(2,sName);
						ps.setString(3,sContact);
						ps.setString(4,sPhone);
						ps.setString(5,sEmail);
						ps.setString(6,sPubkey);
						ps.setTimestamp(7, new Timestamp(new java.util.Date().getTime()));
						ps.setInt(8,nServerId);
						ps.execute();
					}
					bSuccess=true;
				}
				else{
					root.setAttributeValue("error", "E0: Missing or invalid encrypted token");
				}
			}
			else{
				root.setAttributeValue("error", "E2: Serverid "+nServerId+" is not a registered server");
			}
		}
		else{
			//INSERT operation
			nServerId=MedwanQuery.getInstance().getOpenclinicCounter("GHB_SERVERID");
			root.addElement("serverid").setText(nServerId+"");
			Encryption encryption = new Encryption();
			encryption.createKeys();
			sPubkey=encryption.getPublicKeyBase64();
			String sPrivkey = encryption.getPrivateKeyBase64();
			root.addElement("pubkey").setText(sPubkey);
			root.addElement("privkey").setText(sPrivkey);
			rs.close();
			ps.close();
			ps=conn.prepareStatement("insert into GHB_SERVERS(GHB_SERVER_DOMAIN,GHB_SERVER_NAME,GHB_SERVER_CONTACT,GHB_SERVER_PHONE,GHB_SERVER_EMAIL,GHB_SERVER_PUBKEY,GHB_SERVER_UPDATETIME,GHB_SERVER_ID) values(?,?,?,?,?,?,?,?)");
			ps.setString(1,sDomain);
			ps.setString(2,sName);
			ps.setString(3,sContact);
			ps.setString(4,sPhone);
			ps.setString(5,sEmail);
			ps.setString(6,sPubkey);
			ps.setTimestamp(7, new Timestamp(new java.util.Date().getTime()));
			ps.setInt(8,nServerId);
			ps.execute();
			bSuccess=true;
		}
		if(bSuccess){
			//Successfully stored server, reduce token validity by 1
			rs.close();
			ps.close();
			ps = conn.prepareStatement("update GHB_TOKENS set GHB_TOKEN_COUNT=GHB_TOKEN_COUNT-1 where GHB_TOKEN=?");
			ps.setString(1,sToken);
			ps.execute();
			root.setAttributeValue("error", "0");
		}
	}
	else{
		root.setAttributeValue("error", "E1: Missing or invalid token");
	}
	rs.close();
	ps.close();
	conn.close();
	Document document = new DefaultDocument(root);
	out.print(document.asXML());
%>