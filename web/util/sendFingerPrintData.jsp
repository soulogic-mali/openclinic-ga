<%@page import="java.awt.image.BufferedImage"%>
<%@page import="be.openclinic.system.FingerPrint"%>
<%@page import="java.util.Hashtable,java.io.*,
                javazoom.upload.UploadFile,
                javazoom.upload.MultipartFormDataRequest"%>
<%@page import="org.dom4j.*,java.io.*"%>
<%@include file="/includes/helper.jsp"%>
<%
	String serial = "", data="";
	if(MultipartFormDataRequest.isMultipartFormData(request)){
        MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
        try{
        	data=mrequest.getParameter("data");
        }
        catch(Exception e){
        	e.printStackTrace();
        }
	}

	SAXReader reader = new SAXReader(false);
	Document document = reader.read(new StringReader(data));
	Element root = document.getRootElement();
	if(root.attributeValue("command").equalsIgnoreCase("checkReady")){
		Element deviceInfo = root.element("deviceInfo");
		if(deviceInfo!=null){
			System.out.println("received deviceInfo");
			if(deviceInfo.element("Error")==null){
				serial=deviceInfo.elementText("DeviceSN");
				System.out.println("callId="+deviceInfo.attributeValue("callId"));
				System.out.println("serial="+serial);
				Enumeration sessions = MedwanQuery.getSessions().keys();
				while(sessions.hasMoreElements()){
					HttpSession s = (HttpSession)sessions.nextElement();
					if(s.getId().equalsIgnoreCase(deviceInfo.attributeValue("callId"))){
						System.out.println(s.getId()+" = "+deviceInfo.attributeValue("callId"));
						s.setAttribute("fingerprintid", serial);
					}
					else{
						System.out.println("E1 - "+s.getId()+" <> "+deviceInfo.attributeValue("callId"));
						s.setAttribute("fingerprintid", "-1");
					}
				}
			}
		}
	}
	else if(root.attributeValue("command").equalsIgnoreCase("getFingerPrint")){
		Element fingerPrintInfo = root.element("fingerPrintInfo");
		if(fingerPrintInfo!=null){
			System.out.println("received fingerPrintInfo");
			if(fingerPrintInfo.element("Error")==null){
				String iso = fingerPrintInfo.elementText("iso");
				byte[] raw = org.apache.commons.codec.binary.Base64.decodeBase64(fingerPrintInfo.elementText("raw"));
				System.out.println("callId="+fingerPrintInfo.attributeValue("callId"));
				Enumeration sessions = MedwanQuery.getSessions().keys();
				while(sessions.hasMoreElements()){
					HttpSession s = (HttpSession)sessions.nextElement();
					if(s.getId().equalsIgnoreCase(fingerPrintInfo.attributeValue("callId"))){
						System.out.println(s.getId()+" = "+fingerPrintInfo.attributeValue("callId"));
						String ib = new String(org.apache.commons.codec.binary.Base64.decodeBase64(iso));
						if(ib.length()==0){
							ib="0";
						}
						s.setAttribute("fingerprintimage", ib);
						BufferedImage jpg = FingerPrint.toImage(raw, Integer.parseInt(fingerPrintInfo.elementText("width")), Integer.parseInt(fingerPrintInfo.elementText("height")));
						s.setAttribute("fingerprintjpg", jpg);
					}
					else{
						System.out.println("E2 - "+s.getId()+" <> "+fingerPrintInfo.attributeValue("callId"));
						s.setAttribute("callId", "-1");
						session.setAttribute("fingerprintid", "");
						session.setAttribute("fingerprintimage", "");
					}
				}
			}
		}
	}
%>