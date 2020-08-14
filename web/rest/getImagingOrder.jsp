<%@page import="be.dpms.medwan.common.model.vo.authentication.*,be.mxs.common.model.vo.*,be.mxs.common.model.vo.healthrecord.*,be.mxs.common.model.vo.healthrecord.util.*,java.sql.*,java.text.*,java.util.*,org.dom4j.*,be.mxs.common.util.system.*,net.admin.*,be.mxs.common.util.db.*"%><%@include file="/includes/helper.jsp"%><%
	String key = ScreenHelper.checkString(request.getParameter("key"));
	String natreg = ScreenHelper.checkString(request.getParameter("natreg"));
	String personid = ScreenHelper.checkString(request.getParameter("personid"));
	String orderuid = ScreenHelper.checkString(request.getParameter("orderuid"));

	Vector<String> errors = new Vector<String>();
	Vector<String> warnings = new Vector<String>();
	if(key.length()==0 || MedwanQuery.getInstance().getConfigInt("restKey."+key,0)==0){
		errors.add("InvalidKey");
	}
	if(natreg.length()==0 && personid.length()==0){
		errors.add("MissingPatientIdentification");
	}
	if(personid.length()>0){
		AdminPerson person = AdminPerson.getAdminPerson(personid);
		if(!person.isNotEmpty()){
			errors.add("InvalidPersonId");
		}
	}
	if(natreg.length()>0){
		String pid = AdminPerson.getPersonIdByNatReg(natreg);
		if(pid==null || (personid.length()>0 && !pid.equalsIgnoreCase(personid))){
			errors.add("InvalidNatreg");
		}
		else{
			personid=pid;
		}
	}
	if(errors.size()>0){
		org.dom4j.Document document = DocumentHelper.createDocument();
		for(int n=0;n<errors.size();n++){
			document.addElement("error").setText(errors.elementAt(n));
		}
		out.println(document.asXML());
	}
	else{
		Vector<String> orders = new Vector();
		//Search for existing Imaging order with this id
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		String sSql="select distinct t.serverid,t.transactionid,i.value from healthrecord h,transactions t,items i where h.personid=? and h.healthrecordid=t.healthrecordid and t.serverid=i.serverid and t.transactionid=i.transactionid and i.type='be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_IDENTIFICATION_RX' and i.value=?";
		if(orderuid.length()==0){
			sSql="select distinct t.serverid,t.transactionid,i.value from healthrecord h,transactions t,items i where h.personid=? and h.healthrecordid=t.healthrecordid and t.serverid=i.serverid and t.transactionid=i.transactionid and i.type='be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_IDENTIFICATION_RX'";
		}
		PreparedStatement ps = conn.prepareStatement(sSql);
		ps.setString(1,personid);
		if(orderuid.length()>0){
			ps.setString(2,orderuid);
		}
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			orders.add(rs.getInt("serverid")+"."+rs.getInt("transactionid")+";"+rs.getString("value"));
		}
		rs.close();
		ps.close();
		conn.close();
		TransactionVO transaction;
		if(orders.size()>0){
			org.dom4j.Document document = DocumentHelper.createDocument();
			Element root = document.addElement("patient");
			root.addAttribute("personid", personid);
			root.addAttribute("natreg", AdminPerson.getAdminPerson(personid).getID("natreg"));
			for(int n=0;n<orders.size();n++){
				String uid=orders.elementAt(n).split(";")[0];
				transaction = MedwanQuery.getInstance().loadTransaction(uid);
				Element tran = root.addElement("transaction");
				tran.addAttribute("uid", uid);
				tran.addAttribute("orderuid", orders.elementAt(n).split(";")[1]);
				tran.addAttribute("lastupdate", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(transaction.getTimestamp()));
				Element report = tran.addElement("report");
				report.addCDATA(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_PROTOCOL"));
				Element pdf = tran.addElement("pdf");
				String docuid= com.itextpdf.xmp.impl.Base64.encode("key="+key+"&personid="+personid+"&language="+SH.cs("DefaultLanguage","en")+"&documentuid="+transaction.getServerId()+"_"+transaction.getTransactionId());
				pdf.setText("http://"+request.getServerName()+":"+request.getServerPort()+"/"+sCONTEXTPATH+"/rest/getImagingOrderPDF.jsp?docuid="+docuid);
				//We also add a url to view the images with weasis
				Element weasis = tran.addElement("weasis");
				docuid=com.itextpdf.xmp.impl.Base64.encode("documentuid="+transaction.getServerId()+"."+transaction.getTransactionId()+"&key="+key);
				weasis.setText("http://"+request.getServerName()+":"+request.getServerPort()+"/"+sCONTEXTPATH+"/pacs/viewStudyRemote.jsp?docuid="+docuid);
			}
			out.println(be.openclinic.api.API.prettyPrintXml(document.asXML()));
		}
		else{
			org.dom4j.Document document = DocumentHelper.createDocument();
			document.addElement("error").setText("OrderDoesNotExist");
			out.println(document.asXML());
		}
	}
%>