<%@page import="java.text.SimpleDateFormat,
                be.openclinic.pharmacy.Product,
                be.openclinic.medical.Prescription,
                java.text.DecimalFormat,
                be.openclinic.pharmacy.ServiceStock,
                be.openclinic.common.KeyValue,
                be.openclinic.pharmacy.PrescriptionSchema,
                be.openclinic.pharmacy.ProductSchema,
                java.util.Vector"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String sKey = checkString(request.getParameter("key"));
	String sEditPrestationCode = checkString(request.getParameter("EditPrestationCode"));
	int nEditPrestationQuantity = 0;
	try{
		nEditPrestationQuantity=Integer.parseInt(request.getParameter("EditPrestationQuantity"));
	}
	catch(Exception e){
		e.printStackTrace();
	}
	if(nEditPrestationQuantity>0){
		java.util.Date dEditPrestationDate = ScreenHelper.parseDate(request.getParameter("EditPrestationDate"));
		String sEditPrestationHour = checkString(request.getParameter("EditPrestationHour"));
		Connection conn=MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps=conn.prepareStatement("insert into OC_NURSINGDEBETS(OC_NURSINGDEBET_SERVERID,OC_NURSINGDEBET_OBJECTID,OC_NURSINGDEBET_KEY,OC_NURSINGDEBET_PRESTATIONUID,OC_NURSINGDEBET_QUANTITY,OC_NURSINGDEBET_DATE,OC_NURSINGDEBET_USERUID) values(?,?,?,?,?,?,?)");
		ps.setInt(1,MedwanQuery.getInstance().getServerId());
		ps.setInt(2,MedwanQuery.getInstance().getOpenclinicCounter("OC_NURSINGDEBETS"));
		ps.setString(3,sKey);
		ps.setString(4,sEditPrestationCode);
		ps.setInt(5,nEditPrestationQuantity);
		ps.setDate(6,new java.sql.Date(dEditPrestationDate.getTime()));
		ps.setString(7,activeUser.userid);
		ps.execute();
		ps.close();
		conn.close();
	}
%>