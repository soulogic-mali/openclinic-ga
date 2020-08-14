<%@page import="net.admin.*,be.openclinic.adt.*,java.sql.*,be.mxs.common.util.db.*,be.mxs.common.util.system.*,org.apache.poi.xwpf.usermodel.*,org.apache.poi.openxml4j.opc.*,java.util.*,java.io.*,org.apache.xmlbeans.*,be.mxs.common.util.io.*"%>
<%
	String docname = request.getParameter("name");
	Connection conn = MedwanQuery.getInstance().getAdminConnection();
	PreparedStatement ps = conn.prepareStatement("select * from WordDocuments where name=?");
	ps.setString(1,docname);
	ResultSet rs = ps.executeQuery();
	if(rs.next()){
		DocxManager docx= new DocxManager(new ByteArrayInputStream(rs.getBytes("document")));
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
		docx.replaceText("${patient_comment5}",ScreenHelper.getTranNoLink("comment5.options",patient.comment5,language));
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
		//Clinical
		String firstencounterdate="?";
		try{
			firstencounterdate=ScreenHelper.formatDate(Encounter.getFirstEncounter(patient.personid).getBegin());
		}
		catch(Exception e){};
		docx.replaceText("${patient_1stencounterdate}",firstencounterdate);

		
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