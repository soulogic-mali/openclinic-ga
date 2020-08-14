<%@page import="be.dpms.medwan.common.model.vo.authentication.*,be.mxs.common.model.vo.*,be.mxs.common.model.vo.healthrecord.*,be.mxs.common.model.vo.healthrecord.util.*,java.sql.*,java.text.*,java.util.*,org.dom4j.*,be.mxs.common.util.system.*,net.admin.*,be.mxs.common.util.db.*"%><%
	String key = ScreenHelper.checkString(request.getParameter("key"));
	String natreg = ScreenHelper.checkString(request.getParameter("natreg"));
	String personid = ScreenHelper.checkString(request.getParameter("personid"));
	String orderuid = ScreenHelper.checkString(request.getParameter("orderuid"));
	String examtype = ScreenHelper.checkString(request.getParameter("examtype"));
	String urgency = ScreenHelper.checkString(request.getParameter("urgency"));
	
	Vector<String> errors = new Vector<String>();
	Vector<String> warnings = new Vector<String>();
	if(key.length()==0 || MedwanQuery.getInstance().getConfigInt("restKey."+key,0)==0){
		errors.add("InvalidKey");
	}
	if(natreg.length()==0 && personid.length()==0){
		errors.add("MissingPatientIdentification");
	}
	if(urgency.length()>0 && !"01".contains(urgency)){
		errors.add("WrongUrgencyFormat");
	}
	else{
		urgency="1".equalsIgnoreCase(urgency)?"medwan.common.true":"medwan.common.false";
	}
	if(personid.length()>0){
		AdminPerson person = AdminPerson.getAdminPerson(personid);
		if(!person.isNotEmpty()){
			errors.add("InvalidPersonId");
		}
	}
	if(orderuid.length()==0){
		errors.add("MissingOrderUid");
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
		int serverid=MedwanQuery.getInstance().getConfigInt("serverId"),transactionid=-1;
		//Search for existing Imaging order with this id
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("select t.serverid,t.transactionid from healthrecord h,transactions t,items i where h.personid=? and h.healthrecordid=t.healthrecordid and t.serverid=i.serverid and t.transactionid=i.transactionid and i.type='be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_IDENTIFICATION_RX' and i.value=?");
		ps.setString(1,personid);
		ps.setString(2,orderuid);
		ResultSet rs = ps.executeQuery();
		if(rs.next()){
			warnings.add("ImagingOrderExists");
			serverid=rs.getInt("serverid");
			transactionid=rs.getInt("transactionid");
		}
		rs.close();
		ps.close();
		conn.close();
		TransactionVO transaction;
		if(transactionid!=-1){
			transaction = MedwanQuery.getInstance().loadTransaction(serverid, transactionid);
		}
		else{
			transaction = new TransactionFactoryGeneral().createTransactionVO(MedwanQuery.getInstance().getUser(MedwanQuery.getInstance().getConfigString("defaultPACSuser","4")),"be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_MIR2",false); 
			transaction.setCreationDate(new java.util.Date());
			transaction.setStatus(1);
			transaction.setTransactionId(MedwanQuery.getInstance().getOpenclinicCounter("TransactionID"));
			transaction.setServerId(MedwanQuery.getInstance().getConfigInt("serverId",1));
			transaction.setTransactionType("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_MIR2");
			transaction.setUpdateTime(new java.util.Date());
			UserVO user = MedwanQuery.getInstance().getUser(MedwanQuery.getInstance().getConfigString("defaultPACSuser","4"));
			if(user==null){
				MedwanQuery.getInstance().getUser("4");
			}
			transaction.setUser(user);
			transaction.setVersion(1);
			transaction.setItems(new Vector<ItemVO>());
			ItemContextVO itemContextVO = new ItemContextVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", "");
			transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
					"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_IDENTIFICATION_RX",orderuid,new java.util.Date(),itemContextVO));
		}
		if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_TYPE")==null){
			ItemContextVO itemContextVO = new ItemContextVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", "");
			transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
					"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_TYPE",examtype,new java.util.Date(),itemContextVO));
		}
		else{
			transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_TYPE").setValue(examtype);
		}
		if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OTHER_REQUESTS_URGENT")==null){
			ItemContextVO itemContextVO = new ItemContextVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", "");
			transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
					"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OTHER_REQUESTS_URGENT",urgency,new java.util.Date(),itemContextVO));
		}
		else{
			transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OTHER_REQUESTS_URGENT").setValue(urgency);
		}
		MedwanQuery.getInstance().updateTransaction(Integer.parseInt(personid), transaction);
		org.dom4j.Document document = DocumentHelper.createDocument();
		Element root = document.addElement("patient");
		root.addAttribute("personid", personid);
		for(int n=0;n<warnings.size();n++){
			root.addElement("warning").setText(warnings.elementAt(n));
		}
		root.addElement("transaction").addAttribute("uid", serverid+"."+transaction.getTransactionId());
		out.println(be.openclinic.api.API.prettyPrintXml(document.asXML()));
	}
%>