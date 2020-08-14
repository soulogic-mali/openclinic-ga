<%@page import="be.mxs.common.model.vo.healthrecord.TransactionVO"%>
<%@page import="org.dom4j.Element"%>
<%@page import="java.net.URL"%>
<%@page import="org.dom4j.io.SAXReader"%>
<%@page import="org.dom4j.Document"%>
<%@page import="net.admin.*,be.openclinic.finance.*,java.sql.*,be.openclinic.assets.*,be.openclinic.adt.*,be.mxs.common.util.db.*,be.mxs.common.util.system.*,org.apache.poi.xwpf.usermodel.*,org.apache.poi.openxml4j.opc.*,java.util.*,java.io.*,org.apache.xmlbeans.*,be.mxs.common.util.io.*"%>
<%@include file="/includes/helper.jsp"%>
<%!
	private String writeItem(org.dom4j.Element reportCell,TransactionVO transaction,String sPrintLanguage){
		String s="";		
		String itemType = reportCell.getText();
		if(!itemType.startsWith("be.mxs.common.model.vo.healthrecord.IConstants.")){
			itemType = "be.mxs.common.model.vo.healthrecord.IConstants."+itemType;
		}
		if(checkString(reportCell.attributeValue("translate")).length()==0){
			s=checkString(transaction.getItemValue(itemType));
		}
		else if(checkString(reportCell.attributeValue("translate")).startsWith("translate")){
			String[] ss = transaction.getItemValue(itemType).split(";");
			for(int n=0;n<ss.length;n++){
				if(s.length()>0){
					s+=", ";
				}
				s+=ScreenHelper.uppercaseFirstLetter(ScreenHelper.getTranNoLink(reportCell.attributeValue("translate").split(";")[1],ss[n],sPrintLanguage));
			}
		}
		else if(checkString(reportCell.attributeValue("translate")).startsWith("multitranslate")){
			String[] ss = transaction.getItemValue(itemType).split(";");
			for(int n=0;n<ss.length;n++){
				if(s.length()>0){
					s+=", ";
				}
				s+=ScreenHelper.uppercaseFirstLetter(ScreenHelper.getTranNoLink(reportCell.attributeValue("translate").split(";")[1],ss[n].split(":")[0],sPrintLanguage))+(ss[n].split(":").length>1?" = "+ss[n].split(":")[1]:"");
			}
		}
		else if(checkString(reportCell.attributeValue("translate")).equalsIgnoreCase("keywords")){
			String[] ss = transaction.getItemValue(itemType).split(";");
			for(int n=0;n<ss.length;n++){
				if(ss[n].contains("$")){
					if(s.length()>0){
						s+=", ";
					}
					s+=ScreenHelper.uppercaseFirstLetter(ScreenHelper.getTranNoLink(ss[n].split("\\$")[0],ss[n].split("\\$")[1],sPrintLanguage));
				}
			}
		}
		return s;
	}

%>
<%
	TransactionVO transaction = null;
	String transactionuid=request.getParameter("transactionuid");
	if(request.getParameter("be.mxs.healthrecord.transaction_id")!=null && request.getParameter("be.mxs.healthrecord.server_id")!=null){
		transactionuid=request.getParameter("be.mxs.healthrecord.server_id")+"."+request.getParameter("be.mxs.healthrecord.transaction_id");
	}
	if(checkString(transactionuid).length()>0){
		transaction = MedwanQuery.getInstance().loadTransaction(Integer.parseInt(transactionuid.split("\\.")[0]), Integer.parseInt(transactionuid.split("\\.")[1]));
	}
	String docname = new String(Base64.getDecoder().decode(checkString(request.getParameter("name")).getBytes()));
	String sWebLanguage = request.getParameter("language");
	Connection conn = MedwanQuery.getInstance().getAdminConnection();
	PreparedStatement ps = conn.prepareStatement("select * from WordDocuments where name=?");
	ps.setString(1,docname);
	ResultSet rs = ps.executeQuery();
	if(rs.next()){
		DocxManager docx= new DocxManager(new ByteArrayInputStream(rs.getBytes("document")));
		//First check if additional content was specified through an xml file
		String sXml = checkString(rs.getString("xml"));
		if(sXml.length()>0){
			String sDoc = MedwanQuery.getInstance().getConfigString("reportSource",MedwanQuery.getInstance().getConfigString("templateSource")) + sXml;
			SAXReader reader = new SAXReader(false);
	        Document doc = reader.read(new URL(sDoc));
			Element root = doc.getRootElement();
			Iterator items = root.elementIterator();
			while(items.hasNext()){
				Element item = (Element)items.next();
				String itemId = item.attributeValue("id");
				System.out.println("replace ${"+itemId+"} with "+writeItem(item, transaction, sWebLanguage));
				docx.replaceText("${"+itemId+"}",writeItem(item, transaction, sWebLanguage));
			}
		}

		//System parameters
		docx.replaceText("${today}",ScreenHelper.formatDate(new java.util.Date()));
		docx.replaceText("${time}",new SimpleDateFormat("HH:mm").format(new java.util.Date()));
		//User parameters
		User user=(User)session.getAttribute("activeUser");
		String language = user.person.language;
		docx.replaceText("${user_fullname}",user.person.lastname.toUpperCase()+", "+user.person.firstname);
		docx.replaceText("${user_lastname}",user.person.lastname.toUpperCase());
		docx.replaceText("${user_firstname}",user.person.firstname);
		AdminPrivateContact uapc = user.person.getActivePrivate();
		docx.replaceText("${user_address}",uapc.address);
		docx.replaceText("${user_zipcode}",uapc.zipcode);
		docx.replaceText("${user_city}",uapc.city);
		docx.replaceText("${user_country}",uapc.country);
		docx.replaceText("${user_telephone}",uapc.telephone);
		docx.replaceText("${user_mobile}",uapc.mobile);
		docx.replaceText("${user_email}",uapc.email);
		docx.replaceText("${user_profid}",checkString(user.getParameter("organisationid")));
		
		//Call parameters
		Enumeration parameters = request.getParameterNames();
		while(parameters.hasMoreElements()){
			String parname = (String)parameters.nextElement();
			if(parname.startsWith("owp_")){
				docx.replaceText("${"+parname+"}",request.getParameter(parname));
			}
		}
		//Patientparameters
		AdminPerson patient=(AdminPerson)session.getAttribute("activePatient");
		if(patient==null){
			patient=new AdminPerson();
		}
		docx.replaceText("${patient_fullname}",patient.lastname.toUpperCase()+", "+patient.firstname);
		docx.replaceText("${patient_lastname}",patient.lastname.toUpperCase());
		docx.replaceText("${patient_firstname}",patient.firstname);
		docx.replaceText("${patient_dateofbirth}",patient.dateOfBirth);
		docx.replaceText("${patient_age}",patient.getAge()+"");
		docx.replaceText("${patient_age_ext}",patient.getAgeInMonths()/12+" "+ScreenHelper.getTran(request,"web","years",language).toLowerCase()+ " "+ patient.getAgeInMonths()%12+" "+ScreenHelper.getTran(request,"web","months",language).toLowerCase());
		docx.replaceText("${patient_gender}",patient.gender);
		docx.replaceText("${patient_personid}",patient.personid);
		docx.replaceText("${patient_immatnew}",patient.getID("immatnew"));
		docx.replaceText("${patient_immatold}",patient.getID("immatold"));
		docx.replaceText("${patient_natreg}",patient.getID("natreg"));
		docx.replaceText("${patient_comment}",patient.comment);
		docx.replaceText("${patient_comment1}",patient.comment1);
		docx.replaceText("${patient_comment2}",patient.comment2);
		docx.replaceText("${patient_comment3}",patient.comment3);
		docx.replaceText("${patient_comment4}",patient.comment4);
		docx.replaceText("${patient_comment5}",patient.comment5);
		AdminPrivateContact apc = patient.getActivePrivate();
		docx.replaceText("${patient_address}",apc.address);
		docx.replaceText("${patient_zipcode}",apc.zipcode);
		docx.replaceText("${patient_city}",apc.city);
		docx.replaceText("${patient_country}",apc.country);
		docx.replaceText("${patient_telephone}",apc.telephone);
		docx.replaceText("${patient_mobile}",apc.mobile);
		docx.replaceText("${patient_email}",apc.email);
		docx.replaceText("${patient_district}",apc.district);
		docx.replaceText("${patient_sector}",apc.sector);
		docx.replaceText("${patient_quarter}",apc.quarter);
		docx.replaceText("${patient_business}",apc.business);
		docx.replaceText("${patient_businessfunction}",apc.businessfunction);
		
		//Encounter
		Encounter encounter = Encounter.getLastEncounter(patient.personid);
		if(encounter!=null && encounter.hasValidUid()){
			docx.replaceText("${encounteruid}",encounter.getUid());
			docx.replaceText("${encounterobjectid}",encounter.getUid().split("\\.")[1]);
			docx.replaceText("${admissiondate}",ScreenHelper.formatDate(encounter.getBegin()));
			docx.replaceText("${dischargedate}",ScreenHelper.formatDate(encounter.getEnd()));
			docx.replaceText("${encounterdept}",encounter.getService().getFullyQualifiedName(sWebLanguage, " | "));
		}
		else{
			docx.replaceText("${admissiondate}","");
			docx.replaceText("${dischargedate}","");
			docx.replaceText("${encounteruid}","");
			docx.replaceText("${encounterobjectid}","");
			docx.replaceText("${encounterdept}","");
		}
		
		//Insurance
		Insurance insurance = Insurance.getDefaultInsuranceForPatient(patient.personid);
		if(insurance!=null && insurance.hasValidUid()){
			docx.replaceText("${insuranceimmat}",insurance.getMemberImmat());
			if(insurance.getInsurarUid().equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("MFP","@(())"))){
				docx.replaceText("${mfpcard}",insurance.getInsuranceNr());
			}
			else{
				docx.replaceText("${mfpcard}","");
			}
		}
		else{
			docx.replaceText("${mfpcard}","");
			docx.replaceText("${insuranceimmat}","");
		}
		
		//Clinical
		String firstencounterdate="?";
		try{
			firstencounterdate=ScreenHelper.formatDate(Encounter.getFirstEncounter(patient.personid).getBegin());
		}
		catch(Exception e){};
		docx.replaceText("${patient_1stencounterdate}",firstencounterdate);
		//Assets
		Asset asset = (Asset)session.getAttribute("activeAsset");
		if(asset!=null){
			docx.replaceText("${asset_annuity}",asset.annuity);
			docx.replaceText("${asset_assettype}",asset.assetType);
			docx.replaceText("${asset_characteristics}",asset.characteristics);
			docx.replaceText("${asset_code}",asset.code);
			docx.replaceText("${asset_cenorm}",asset.comment1);
			docx.replaceText("${asset_brand}",asset.comment2);
			docx.replaceText("${asset_othernorm}",asset.comment3);
			docx.replaceText("${asset_voltage}",asset.comment4);
			docx.replaceText("${asset_intensity}",asset.comment5);
			docx.replaceText("${asset_fundingsource}",ScreenHelper.getTranNoLink("assets.fundingsource",asset.comment6,user.person.language));
			docx.replaceText("${asset_functionality}",ScreenHelper.getTranNoLink("assets.functionality",asset.comment7,user.person.language));
			docx.replaceText("${asset_details}",asset.comment8);
			docx.replaceText("${asset_status}",ScreenHelper.getTranNoLink("assets.status",asset.comment9,user.person.language));
			docx.replaceText("${asset_model}",asset.comment10);
			docx.replaceText("${asset_productiondate}",asset.comment11);
			docx.replaceText("${asset_deliverydate}",asset.comment12);
			docx.replaceText("${asset_firstusagedate}",asset.comment13);
			docx.replaceText("${asset_endofwarantydate}",asset.comment14);
			docx.replaceText("${asset_components}",asset.getComponentsString(user.person.language));
			docx.replaceText("${asset_unused}",asset.comment16);
			docx.replaceText("${asset_unused}",asset.comment17);
			docx.replaceText("${asset_unused}",asset.comment18);
			docx.replaceText("${asset_unused}",asset.comment19);
			docx.replaceText("${asset_unused}",asset.comment20);
			docx.replaceText("${asset_description}",asset.description);
			docx.replaceText("${asset_gmdncode}",asset.gmdncode);
			docx.replaceText("${asset_loancomment}",asset.loanComment);
			docx.replaceText("${asset_loaninterestrate}",asset.loanInterestRate);
			docx.replaceText("${asset_nomenclaturecode}",asset.nomenclature);
			docx.replaceText("${asset_nomenclaturename}",ScreenHelper.getTranNoLink("admin.nomenclature.asset",asset.nomenclature,user.person.language));
			docx.replaceText("${asset_receiptby}",asset.receiptBy);
			docx.replaceText("${asset_salesclient}",asset.saleClient);
			docx.replaceText("${asset_serialnumber}",asset.serialnumber);
			docx.replaceText("${asset_serviceuid}",asset.serviceuid);
			if(asset.getService()!=null){
				docx.replaceText("${asset_servicename}",asset.getService().getLabel(user.person.language));
			}
			docx.replaceText("${asset_supplieruid}",asset.supplierUid);
			docx.replaceText("${asset_suppliername}",asset.getSupplierName());
			docx.replaceText("${asset_uid}",asset.getUid());
		}
		MaintenancePlan plan = (MaintenancePlan)session.getAttribute("activeMaintenancePlan");
		if(plan!=null){
			docx.replaceText("${plan_uid}",plan.getUid());
			docx.replaceText("${plan_transportcosts}",plan.comment1);
			docx.replaceText("${plan_consumablescost}",plan.comment2);
			docx.replaceText("${plan_othercosts}",plan.comment3);
			docx.replaceText("${plan_supplieruid}",plan.comment4);
			Supplier supplier = Supplier.get(ScreenHelper.checkString(plan.comment4));
			if(supplier!=null){
				docx.replaceText("${plan_suppliername}",supplier.getName());
			}
			docx.replaceText("${plan_unused}",plan.comment5);
			docx.replaceText("${plan_unused}",plan.comment6);
			docx.replaceText("${plan_unused}",plan.comment7);
			docx.replaceText("${plan_unused}",plan.comment8);
			docx.replaceText("${plan_unused}",plan.comment9);
			docx.replaceText("${plan_unused}",plan.comment10);
			docx.replaceText("${plan_frequency}",plan.frequency);
			docx.replaceText("${plan_instructions}",plan.instructions);
			docx.replaceText("${plan_name}",plan.name);
			docx.replaceText("${plan_operator}",plan.operator);
			docx.replaceText("${plan_manager}",plan.planManager);
			docx.replaceText("${plan_type}",ScreenHelper.getTranNoLink("maintenanceplan.type",plan.type,user.person.language));
		}
		MaintenanceOperation operation = (MaintenanceOperation)session.getAttribute("activeMaintenanceOperation");
		if(operation!=null){
			docx.replaceText("${operation_uid}",operation.getUid());
			docx.replaceText("${operation_comment}",operation.comment);
			docx.replaceText("${operation_operator}",operation.operator);
			docx.replaceText("${operation_result}",ScreenHelper.getTranNoLink("assets.maintenanceoperations.result",operation.result,user.person.language));
			docx.replaceText("${operation_supplieruid}",operation.supplier);
			Supplier supplier = Supplier.get(ScreenHelper.checkString(operation.supplier));
			if(supplier!=null){
				docx.replaceText("${operation_suppliername}",supplier.getName());
			}
		}
	    response.setContentType("application/msword");
	    response.setHeader("Content-disposition","inline; filename=tmp_"+System.currentTimeMillis()+".docx");
	    ServletOutputStream sos = response.getOutputStream();
	    rs.close();
	    ps.close();
	    docx.writeDocument(sos);
	    sos.flush();
	}
	else{
	    rs.close();
	    ps.close();
	    out.println("Document does not exist");
	}
%>