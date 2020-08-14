<%@page import="be.mxs.common.util.system.HTMLEntities"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<ul id="autocompletion">
    <%
	    String sActivityName = checkString(request.getParameter("findActivityName")).toUpperCase();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("select * from OC_PRESTATIONS where OC_PRESTATION_INVOICEGROUP in ("+MedwanQuery.getInstance().getConfigString("ccbrtProcedureGroupForCalendar","'sl 001 003'")+") AND"+
				" (OC_PRESTATION_INACTIVE is null OR OC_PRESTATION_INACTIVE=0) AND"+
				" (OC_PRESTATION_MODIFIERS like ? or OC_PRESTATION_MODIFIERS like '%;%;%;%;%;%;%;;%' ) AND"+
				" (OC_PRESTATION_CODE"+MedwanQuery.getInstance().concatSign()+"' - '"+MedwanQuery.getInstance().concatSign()+"OC_PRESTATION_DESCRIPTION) like ?"+
				" ORDER BY OC_PRESTATION_CODE");
		String clinic = "%";
		if(activePatient!=null){
			Encounter encounter = Encounter.getActiveEncounter(activePatient.personid);
			if(encounter!=null && encounter.getService()!=null && encounter.getService().code3!=null){
				clinic=encounter.getService().code3;
			}
		}
		ps.setString(1,"%;%;%;%;%;%;%;"+clinic+";%");
		ps.setString(2, "%"+sActivityName+"%");
		ResultSet rs = ps.executeQuery();
		int rows=0;
		while(rs.next()){
			String uid=rs.getString("OC_PRESTATION_SERVERID")+"."+rs.getString("OC_PRESTATION_OBJECTID");
			String descr=checkString(rs.getString("OC_PRESTATION_DESCRIPTION")).toUpperCase();
        	out.write("<li><b>"+HTMLEntities.htmlentities((checkString(rs.getString("OC_PRESTATION_CODE")).toUpperCase()+" -          ").substring(0,10)+""+descr)+"</b>");
            out.write("<span style='display:none'>|"+uid+"-idcache</span>");
            out.write("</li>");
    	    boolean hasMoreResults = (rows >= 10);
    	    if(hasMoreResults){
    	        out.write("<ul id='autocompletion'><li>...</li></ul>");
    	        break;
    	    }
		}
		rs.close();
		ps.close();
		conn.close();
    %>
</ul>
