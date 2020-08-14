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
	String sUid = checkString(request.getParameter("uid"));
	Connection conn=MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps=conn.prepareStatement("delete from OC_NURSINGDEBETS where OC_NURSINGDEBET_SERVERID=? and OC_NURSINGDEBET_OBJECTID=?");
	ps.setInt(1,Integer.parseInt(sUid.split("\\.")[0]));
	ps.setInt(2,Integer.parseInt(sUid.split("\\.")[1]));
	ps.execute();
	ps.close();
	conn.close();
%>
