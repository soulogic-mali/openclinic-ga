<%@page import="be.mxs.common.model.vo.healthrecord.VaccinationInfoVO"%>
<%@page import="be.mxs.common.model.vo.healthrecord.util.TransactionFactoryGeneral"%>
<%@page import="be.mxs.common.model.vo.healthrecord.ItemContextVO"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%
String transactionType="",sPage="",sModifier="";	
Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from examinations where id=?");
	ps.setInt(1,Integer.parseInt(request.getParameter("examid")));
	ResultSet rs=ps.executeQuery();
	if(rs.next()){
		transactionType=rs.getString("transactionType").split("&")[0];
		if(rs.getString("transactionType").split("&").length>1){
			sModifier=rs.getString("transactionType").split("&")[1];
		}
	}
	rs.close();
	ps.close();
	conn.close();
	if(activePatient==null){
		//If no patient was selected, select an empty dummy patient in order to avoid references
		//to a null patient object in some clinical screens
		activePatient= new AdminPerson();
		activePatient.personid="-1";
		session.setAttribute("activePatient",activePatient);
	}
	//Now find the page in forwards.xml that matches this transactyionType
    SAXReader reader = new SAXReader(false);
    String sDoc = MedwanQuery.getInstance().getConfigString("templateSource")+"forwards.xml";
    Document document = reader.read(new URL(sDoc));
	Element root = document.getRootElement();
	Iterator mappings = root.elementIterator("mapping");
	while(mappings.hasNext()){
		Element mapping = (Element)mappings.next();
		if(mapping.attributeValue("id").equalsIgnoreCase(transactionType)){
			sPage=mapping.attributeValue("path");
		}
	}
    SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO( request , SessionContainerWO.class.getName() );
    if((sessionContainerWO.getUserVO()==null || sessionContainerWO.getUserVO().getUserId()==null) && request.getSession().getAttribute("activeUser")!=null){
    	User user = (User)(request.getSession().getAttribute("activeUser"));
    	UserVO userVO = MedwanQuery.getInstance().getUser(user.userid);
    	sessionContainerWO.setUserVO((userVO));
    }
    TransactionFactoryGeneral tf = new TransactionFactoryGeneral();
    TransactionVO transactionVO = tf.createTransactionVO(sessionContainerWO.getUserVO(), transactionType);
    sessionContainerWO.setCurrentTransactionVO(transactionVO);
    sessionContainerWO.setCurrentVaccinationInfoVO(new VaccinationInfoVO());
    if(transactionType.toUpperCase().contains("VACCINATION")){
    	sPage="/main.do?Page=/healthrecord/manageVaccination_view.jsp?"+sModifier;
    }
%>
<script>
	window.location.href='<%=sCONTEXTPATH+sPage.replace("main.do", "popup.jsp")%>&PopupHeight=768&PopupWidth=1024&nobuttons=1';
</script>
