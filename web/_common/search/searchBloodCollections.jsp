<%@page import="be.openclinic.pharmacy.*,be.openclinic.medical.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<table width='100%'>
	<tr class='admin'>
		<td colspan="5"><%=getTran(request,"web","activecollectionsforuser",sWebLanguage) %> <%=activeUser.person.getFullName() %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","giftid",sWebLanguage) %></td>
		<td class='admin'><%=getTran(request,"web","date",sWebLanguage) %></td>
		<td class='admin'><%=getTran(request,"web","patient",sWebLanguage) %></td>
		<td class='admin'><%=getTran(request,"web","dateofbirth",sWebLanguage) %></td>
		<td class='admin'><%=getTran(request,"web","telephone",sWebLanguage) %></td>
	</tr>
<%
	String returnField = checkString(request.getParameter("ReturnField"));
	String returnFunction = checkString(request.getParameter("ReturnFunction"));

	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from OC_BLOODCOLLECTIONS where OC_BLOODCOLLECTION_USERID=? and OC_BLOODCOLLECTION_INTEGRATIONDATE is NULL and OC_BLOODCOLLECTION_DATE>? order by OC_BLOODCOLLECTION_ID DESC");
	ps.setInt(1, Integer.parseInt(activeUser.userid));
	//By default show only collections of last 3 months
	long day = 24*3600*1000;
	ps.setDate(2, new java.sql.Date(new java.util.Date().getTime()-90*day));
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		%>
		<tr>
			<td class='admin2'><a href='javascript:selectid(<%=rs.getInt("OC_BLOODCOLLECTION_ID") %>)'><%=rs.getInt("OC_BLOODCOLLECTION_ID") %></a></td>
			<td class='admin2'><%=ScreenHelper.formatDate(rs.getDate("OC_BLOODCOLLECTION_DATE")) %></td>
			<td class='admin2'><%=checkString(rs.getString("OC_BLOODCOLLECTION_PATIENTNAME")).toUpperCase()+", "+checkString(rs.getString("OC_BLOODCOLLECTION_PATIENTFIRSTNAME")) %></td>
			<td class='admin2'><%=ScreenHelper.formatDate(rs.getDate("OC_BLOODCOLLECTION_PATIENTDATEOFBIRTH")) %></td>
			<td class='admin2'><%=rs.getString("OC_BLOODCOLLECTION_PATIENTTELEPHONE") %></td>
		</tr>
		<%
	}
	rs.close();
	ps.close();
	conn.close();
%>
</table>

<script>
	function selectid(id){
		if(window.opener.<%=returnField%>){
			window.opener.<%=returnField%>.value=id;
		}
		if(window.opener.<%=returnFunction%>){
			window.opener.<%=returnFunction%>;
		}
		window.close();
	}
</script>