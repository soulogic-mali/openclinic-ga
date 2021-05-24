<%@page import="be.openclinic.assets.MaintenancePlan,
               java.text.*,be.openclinic.util.*,be.openclinic.assets.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String name = checkString(request.getParameter("name"));
	String startDate = checkString(request.getParameter("startDate"));
	String endDate = checkString(request.getParameter("endDate"));
	String frequency = checkString(request.getParameter("frequency"));
	String nomenclaturecode = checkString(request.getParameter("nomenclaturecode"));
	String operator = checkString(request.getParameter("operator"));
	String planManager = checkString(request.getParameter("planManager"));
	String type = checkString(request.getParameter("type"));
	String comment1 = checkString(request.getParameter("comment1"));
	String comment2 = checkString(request.getParameter("comment2"));
	String comment3 = checkString(request.getParameter("comment3"));
	String comment4 = checkString(request.getParameter("comment4"));
	String comment5 = checkString(request.getParameter("comment5"));
	String comment6 = checkString(request.getParameter("comment6"));
	String comment7 = checkString(request.getParameter("comment7"));
	String comment8 = checkString(request.getParameter("comment8"));
	String comment9 = checkString(request.getParameter("comment9"));
	String comment10 = checkString(request.getParameter("comment10"));
	String instructions = checkString(request.getParameter("instructions"));
	
	if(nomenclaturecode.length()>0){
		try{
			Connection conn = SH.getOpenClinicConnection();
			PreparedStatement ps = conn.prepareStatement("select * from oc_defaultmaintenanceplans where oc_maintenanceplan_nomenclature=? and oc_maintenanceplan_name=? and oc_maintenanceplan_frequency=?");
			ps.setString(1,nomenclaturecode);
			ps.setString(2,name);
			ps.setString(3,frequency);
			ResultSet rs = ps.executeQuery();
			if(!SH.c(request.getParameter("overwrite")).equalsIgnoreCase("1") && rs.next()){
				out.println("NOK-400");
			}
			else{
				MaintenancePlan plan = new MaintenancePlan();
				plan.setName(name);
				try{
					plan.setStartDate(ScreenHelper.parseDate(startDate));
				}
				catch(Exception e){};
				try{
					plan.setEndDate(ScreenHelper.parseDate(endDate));
				}
				catch(Exception e){};
				plan.setFrequency(frequency);
				plan.setOperator(operator);
				plan.setPlanManager(planManager);
				plan.setType(type);
				plan.setInstructions(instructions);
				plan.setComment1(comment1);
				plan.setComment2(comment2);
				plan.setComment3(comment3);
				plan.setComment4(comment4);
				plan.setComment5(comment5);
				plan.setComment6(comment6);
				plan.setComment7(comment7);
				plan.setComment8(comment8);
				plan.setComment9(comment9);
				plan.setComment10(comment10);
				plan.copyToDefault(nomenclaturecode);
				out.println("OK-200");
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception i){
			i.printStackTrace();
		}
	}
	else{
		out.println("NOK-300");
	}
%>