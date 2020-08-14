<%@include file="/includes/validateUser.jsp"%>
<%@page import="be.openclinic.datacenter.DatacenterHelper,be.mxs.common.util.db.MedwanQuery" %>
<%!
	private String getValue(Hashtable h,String key){
		String value = (String)h.get(key);
		if(value!=null){
			return "<a href='javascript:vaccinationsGraph(\""+key+"\")'>"+Integer.parseInt(value)+"</a>";
		}
		else {
			return "<a href='javascript:vaccinationsGraph(\""+key+"\")'>0</a>";
		}
	}
	private int getIntValue(Hashtable h,String key){
		String value = (String)h.get(key);
		if(value!=null){
			return Integer.parseInt(value);
		}
		else {
			return 0;
		}
	}
%>
<div >
    <table width='100%'>
    <%
    String serverid=request.getParameter("serverid");
    String period=request.getParameter("period");
	Connection conn = MedwanQuery.getInstance().getStatsConnection();
    PreparedStatement ps = conn.prepareStatement("select * from DC_VACCINATIONS where DC_VACCINATION_SERVERUID=? and DC_VACCINATION_MODEL='mali' limit 1");
    ps.setString(1, serverid);
    ResultSet rs = ps.executeQuery();
    if(rs.next()){
    	//Mali model results
	    try{
	    	Hashtable hVaccinations = new Hashtable();
	        java.util.Vector vaccinations = DatacenterHelper.getVaccinations(Integer.parseInt(serverid),period);
	        for(int n=0;n<vaccinations.size();n++){
	            String vaccination=(String)vaccinations.elementAt(n);
	            hVaccinations.put(vaccination.split(";")[0],vaccination.split(";")[1]);
	        }
	        out.println("<tr><td rowspan='2'>"+getTran(request,"web","birth",sWebLanguage)+"</td><td>"+getTran(request,"web","BCG",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"bcg")+"</b></td></tr>");
	        out.println("<tr><td>"+getTran(request,"web","polio0",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"polio0")+"</b></td></tr>");
	        out.println("<tr><td rowspan='4'>"+getTran(request,"web","6weeks",sWebLanguage)+"</td><td>"+getTran(request,"web","polio1",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"polio1")+"</b></td></tr>");
	        out.println("<tr><td>"+getTran(request,"web","penta1",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"penta1")+"</b></td></tr>");
	        out.println("<tr><td>"+getTran(request,"web","pneumo1",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"pneumo1")+"</b></td></tr>");
	        out.println("<tr><td>"+getTran(request,"web","rota1",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"rota1")+"</b></td></tr>");
	        out.println("<tr><td rowspan='4'>"+getTran(request,"web","10weeks",sWebLanguage)+"</td><td>"+getTran(request,"web","polio2",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"polio2")+"</b></td></tr>");
	        out.println("<tr><td>"+getTran(request,"web","penta2",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"penta2")+"</b></td></tr>");
	        out.println("<tr><td>"+getTran(request,"web","pneumo2",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"pneumo2")+"</b></td></tr>");
	        out.println("<tr><td>"+getTran(request,"web","rota2",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"rota2")+"</b></td></tr>");
	        out.println("<tr><td rowspan='4'>"+getTran(request,"web","14weeks",sWebLanguage)+"</td><td>"+getTran(request,"web","polio3",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"polio3")+"</b></td></tr>");
	        out.println("<tr><td>"+getTran(request,"web","penta3",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"penta3")+"</b></td></tr>");
	        out.println("<tr><td>"+getTran(request,"web","pneumo3",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"pneumo3")+"</b></td></tr>");
	        out.println("<tr><td>"+getTran(request,"web","rota3",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"rota3")+"</b></td></tr>");
	        out.println("<tr><td rowspan='3'>"+getTran(request,"web","9months",sWebLanguage)+"</td><td>"+getTran(request,"web","measles",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"measles")+"</b></td></tr>");
	        out.println("<tr><td>"+getTran(request,"web","yellowfever",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"yellowfever")+"</b></td></tr>");
	        out.println("<tr><td>"+getTran(request,"web","meningitisa",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"meningitisa")+"</b></td></tr>");
	        out.println("<tr class='admin'><td>"+getTran(request,"web","6to11months",sWebLanguage)+"</td><td>"+getTran(request,"web","vita100",sWebLanguage)+"</td><td><b><a href='javascript:vaccinationsGraph(\"vita100\")'>"+(getIntValue(hVaccinations,"vita100")+getIntValue(hVaccinations,"vita100a"))+"</a></b></td></tr>");
	        out.println("<tr class='admin'><td rowspan='2'>"+getTran(request,"web","12to23months",sWebLanguage)+"</td><td>"+getTran(request,"web","vita200.1",sWebLanguage)+"</td><td><b><a href='javascript:vaccinationsGraph(\"vita200.1\")'>"+(getIntValue(hVaccinations,"vita200.1")+getIntValue(hVaccinations,"vita200.1a")+getIntValue(hVaccinations,"vita200.1b"))+"</a></b></td></tr>");
	        out.println("<tr><td>"+getTran(request,"web","alben200.1",sWebLanguage)+"</td><td><b><a href='javascript:vaccinationsGraph(\"alben200.1\")'>"+(getIntValue(hVaccinations,"alben200.1")+getIntValue(hVaccinations,"alben200.1a")+getIntValue(hVaccinations,"alben200.1b"))+"</a></b></td></tr>");
	        out.println("<tr class='admin'><td rowspan='2'>"+getTran(request,"web","24to59months",sWebLanguage)+"</td><td>"+getTran(request,"web","vita200.2",sWebLanguage)+"</td><td><b><a href='javascript:vaccinationsGraph(\"vita200.2\")'>"+(getIntValue(hVaccinations,"vita200.2")+getIntValue(hVaccinations,"vita200.2a")+getIntValue(hVaccinations,"vita200.2b")+getIntValue(hVaccinations,"vita200.2c")+getIntValue(hVaccinations,"vita200.2d"))+"</a></b></td></tr>");
	        out.println("<tr><td>"+getTran(request,"web","alben400.1",sWebLanguage)+"</td><td><b><a href='javascript:vaccinationsGraph(\"alben400.1\")'>"+(getIntValue(hVaccinations,"alben400.1")+getIntValue(hVaccinations,"alben400.1a")+getIntValue(hVaccinations,"alben400.1b")+getIntValue(hVaccinations,"alben400.1c")+getIntValue(hVaccinations,"alben400.1d"))+"</a></b></td></tr>");
	        out.println("<tr class='admin'><td rowspan='5'>"+getTran(request,"web","15to49years",sWebLanguage)+"</td><td>"+getTran(request,"web","vat1",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"vat1")+"</b></td></tr>");
	        out.println("<tr><td>"+getTran(request,"web","vat2",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"vat2")+"</b></td></tr>");
	        out.println("<tr><td>"+getTran(request,"web","vatr1",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"vatr1")+"</b></td></tr>");
	        out.println("<tr><td>"+getTran(request,"web","vatr2",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"vatr2")+"</b></td></tr>");
	        out.println("<tr><td>"+getTran(request,"web","vatr3",sWebLanguage)+"</td><td><b>"+getValue(hVaccinations,"vatr3")+"</b></td></tr>");
	    }
	    catch(Exception e){
	    	e.printStackTrace();
	    }
    }
   	rs.close();
   	ps.close();
   	conn.close();
    %>
    </table>
</div>