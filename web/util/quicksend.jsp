<%@include file="/includes/helper.jsp"%>
<%@page import="be.openclinic.finance.*,org.dom4j.*,be.openclinic.system.OCHttpClient,org.apache.http.*,org.apache.http.client.entity.*,org.apache.http.message.*,org.apache.http.impl.client.*,org.apache.http.client.methods.*,java.text.*,be.mxs.common.util.db.*"%>
<%
	Connection conn = SH.getOpenClinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from oc_patientinvoices");
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		CloseableHttpClient client = HttpClients.createDefault();
		HttpPost httpPost = new HttpPost("http://192.168.88.106:3000/openclinic");
		//HttpPost httpPost = new HttpPost("http://localhost/openclinic/util/rcv.jsp");
		List<org.apache.http.NameValuePair> params = new ArrayList<org.apache.http.NameValuePair>();
		Document document = DocumentHelper.createDocument();
		Element eInvoice =document.addElement("invoice");
		PatientInvoice invoice = PatientInvoice.get(rs.getString("oc_patientinvoice_serverid")+"."+rs.getString("oc_patientinvoice_objectid"));
		eInvoice.addAttribute("id", invoice.getObjectId()+"");
		Element cl = eInvoice.addElement("client");
		cl.addAttribute("code", SH.cs("qsPatientAccount","0"));
		cl.addAttribute("name", "patient");
		eInvoice.addElement("date").setText(SH.formatDate(invoice.getDate()));
		Element user = eInvoice.addElement("user");
		user.addAttribute("code", invoice.getUpdateUser());
		user.addAttribute("name", User.getFullUserName(invoice.getUpdateUser()));
		eInvoice.addElement("reference").setText(invoice.getInsurarreference());
		Element ePrestations = eInvoice.addElement("prestations");
		for(int n=0;n<invoice.getDebets().size();n++){
			Element ePrestation = ePrestations.addElement("prestation");
			Debet debet = (Debet)invoice.getDebets().elementAt(n);
			ePrestation.addAttribute("id", debet.getObjectId()+"");
			ePrestation.addAttribute("code", debet.getPrestation().getCode());
			Element service = ePrestation.addElement("service");
			service.addAttribute("code", debet.getServiceUid());
			service.addAttribute("name", debet.getService().getLabel("fr"));
			ePrestation.addElement("label").setText(debet.getPrestation().getDescription());
			Element eInsurance = ePrestation.addElement("insurance");
			eInsurance.addAttribute("code", debet.getInsurance().getObjectId()+"");
			eInsurance.addAttribute("name", debet.getInsurance().getInsurar().getName());
			Element eAmount = ePrestation.addElement("amount");
			eAmount.addAttribute("patient", debet.getAmount()+"");
			eAmount.addAttribute("insurer", debet.getInsurarAmount()+"");
			eAmount.addAttribute("currency", "BIF");
		}
		params.add(new BasicNameValuePair("findata",org.json.XML.toJSONObject(document.asXML()).toString(4)));
		httpPost.setEntity(new UrlEncodedFormEntity(params));	
		HttpResponse r = client.execute(httpPost);
		String sResponse =new BasicResponseHandler().handleResponse(r);
		out.println(sResponse);
		if(sResponse.contains("<OK>")){
			out.println("Well received!!");
		}
	}
	rs.close();
	ps.close();
	ps = conn.prepareStatement("select * from oc_wicket_credits where oc_wicket_credit_type='patient.payment'");
	rs = ps.executeQuery();
	while(rs.next()){
		CloseableHttpClient client = HttpClients.createDefault();
		HttpPost httpPost = new HttpPost("http://192.168.88.106:3000/openclinic");
		//HttpPost httpPost = new HttpPost("http://localhost/openclinic/util/rcv.jsp");
		List<org.apache.http.NameValuePair> params = new ArrayList<org.apache.http.NameValuePair>();
		Document document = DocumentHelper.createDocument();
		Element ePayment =document.addElement("payment");
		WicketCredit credit = WicketCredit.get(rs.getString("oc_wicket_credit_serverid")+"."+rs.getString("oc_wicket_credit_objectid"));
		ePayment.addAttribute("id", credit.getObjectId()+"");
		ePayment.addAttribute("invoiceid", (credit.getInvoiceUID()+"").split("\\.")[1]);
		Element eClient = ePayment.addElement("client");
		PatientInvoice invoice = PatientInvoice.get(credit.getInvoiceUID());
		eClient.addAttribute("code", "0");
		eClient.addAttribute("name", "patient");
		ePayment.addElement("paymenttype").setText(credit.getOperationType());
		Element amount = ePayment.addElement("amount");
		amount.addAttribute("value",credit.getAmount()+"");
		amount.addAttribute("currency", credit.getCurrency());
		ePayment.addElement("date").setText(SH.formatDate(credit.getOperationDate()));
		Element user = ePayment.addElement("user");
		user.addAttribute("code", credit.getUpdateUser());
		user.addAttribute("name", User.getFullUserName(credit.getUpdateUser()));
		Element cashdesk = ePayment.addElement("cashdesk");
		cashdesk.addAttribute("code", credit.getWicketUID().split("\\.")[1]);
		cashdesk.addAttribute("name", Wicket.getWicketName(credit.getWicketUID()));

		params.add(new BasicNameValuePair("findata",org.json.XML.toJSONObject(document.asXML()).toString(4)));
		httpPost.setEntity(new UrlEncodedFormEntity(params));	
		HttpResponse r = client.execute(httpPost);
		String sResponse =new BasicResponseHandler().handleResponse(r);
		out.println(sResponse);
		if(sResponse.contains("<OK>")){
			out.println("Well received!!");
		}
	}
	rs.close();
	ps.close();
	conn.close();
%>