<%@ page import="java.util.*,be.mxs.common.util.system.HTMLEntities" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
    String sFindDistrict = checkString(request.getParameter("FindDistrict"));
	String sFindCity = checkString(request.getParameter("FindCity"));
	String sFindRegion = checkString(request.getParameter("FindRegion"));
	String sFindSector = checkString(request.getParameter("FindQuarter"));

    String sZipcode = Zipcode.getZipcode(sFindRegion,sFindDistrict,sFindCity,sFindSector,MedwanQuery.getInstance().getConfigString("zipcodetable","RwandaZipcodes"));
	Hashtable labels=(Hashtable)((Hashtable)(MedwanQuery.getInstance().getLabels())).get(sWebLanguage.toLowerCase());
	if(labels!=null) labels=(Hashtable)labels.get("subquarter."+sFindSector.toLowerCase().split(" ")[0]);
    String sSubQuarters="";
	if(labels!=null){
		Enumeration en = labels.keys();
		while(en.hasMoreElements()){
			String key = (String)en.nextElement();
			sSubQuarters+=((Label)labels.get(key)).value+"$";
		}
	}

%>
{
"zipcode":"<%=sZipcode %>",
"subquarters":"<%=sSubQuarters %>"
}
