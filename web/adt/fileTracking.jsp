<%@page import="be.mxs.common.util.system.Miscelaneous"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	java.util.Date begin = Miscelaneous.addMonthsToDate(new java.util.Date(), -3);
	java.util.Date end = new java.util.Date();
	if(checkString(request.getParameter("begindate")).length()>0){
		begin = ScreenHelper.parseDate(request.getParameter("begindate"));
	}
	if(checkString(request.getParameter("enddate")).length()>0){
		end = ScreenHelper.parseDate(request.getParameter("enddate"));
	}
	if(request.getParameter("saveButton")!=null){
		try{
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("insert into OC_FILETRACKING(OC_FILETRACKING_PERSONID,OC_FILETRACKING_DATE,OC_FILETRACKING_INOUT,OC_FILETRACKING_FROM,OC_FILETRACKING_TO,OC_FILETRACKING_USERID,OC_FILETRACKING_ID) values(?,?,?,?,?,?,?)");
			ps.setInt(1,Integer.parseInt(activePatient.personid));
			ps.setDate(2,new java.sql.Date(ScreenHelper.parseDate(request.getParameter("fileDate")).getTime()));
			ps.setString(3,checkString(request.getParameter("fileInOut")));
			ps.setString(4,checkString(request.getParameter("fileFrom")));
			ps.setString(5,checkString(request.getParameter("fileTo")));
			ps.setString(6,checkString(request.getParameter("fileUser")));
			ps.setInt(7,MedwanQuery.getInstance().getOpenclinicCounter("OC_FILETRACKING_ID"));
			ps.execute();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	if(checkString(request.getParameter("actionfield")).startsWith("delete")){
		try{
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("delete from OC_FILETRACKING where OC_FILETRACKING_ID=?");
			ps.setInt(1,Integer.parseInt(request.getParameter("actionfield").split(";")[1]));
			ps.execute();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
%>
<form name='transactionForm' method='post'>
	<input type='hidden' name='actionfield' id='actionfield'/>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='5'><%=getTran(request,"web","filetracking",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","date",sWebLanguage) %></td>
			<td class='admin'><%=getTran(request,"web","operation",sWebLanguage) %></td>
			<td class='admin'><%=getTran(request,"web","from",sWebLanguage) %></td>
			<td class='admin'><%=getTran(request,"web","to",sWebLanguage) %></td>
			<td class='admin'><%=getTran(request,"web","user",sWebLanguage) %></td>
		</tr>
		<!-- Add new operation -->
		<%
			String sServiceInout="",sServiceFrom="",sServiceTo="";
			try{
				Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
				PreparedStatement ps = conn.prepareStatement("select * from OC_FILETRACKING where OC_FILETRACKING_PERSONID=? order by OC_FILETRACKING_DATE DESC,OC_FILETRACKING_ID DESC");
				ps.setInt(1,Integer.parseInt(activePatient.personid));
				ResultSet rs = ps.executeQuery();
				if(rs.next()){
					String sInOut = rs.getString("OC_FILETRACKING_INOUT");
					if(sInOut.equalsIgnoreCase("IN")){
						sServiceInout="OUT";
						sServiceFrom=rs.getString("OC_FILETRACKING_TO");
					}
					else{
						sServiceInout="IN";
						sServiceFrom=rs.getString("OC_FILETRACKING_FROM");
						sServiceTo=rs.getString("OC_FILETRACKING_TO");
					}
				}
				rs.close();
				ps.close();
				conn.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		%>
		<tr>
			<td class='admin2'><%=ScreenHelper.writeDateField("fileDate", "transactionForm", ScreenHelper.formatDate(new java.util.Date()), true, false, sWebLanguage, sCONTEXTPATH)%></td>
			<td class='admin2'>
				<select class='text' name='fileInOut'>
					<option value='in' <%=sServiceInout.equalsIgnoreCase("in")?"selected":"" %>>IN</option>
					<option value='out' <%=sServiceInout.equalsIgnoreCase("out")?"selected":"" %>>OUT</option>
				</select>
			</td>
			<td class='admin2'>
	            <input type='hidden' name='fileFrom' id='fileFrom' value='<%=sServiceFrom%>'>
	            <input class='text' type='text' name='fileFromName' id='fileFromName' readonly size='35' value='<%=getTranNoLink("service",sServiceFrom,sWebLanguage)%>'>&nbsp;
	            <img src='_img/icons/icon_search.png' class='link' alt='<%=getTranNoLink("Web","select",sWebLanguage)%>' onclick='searchService("fileFrom","fileFromName");'>&nbsp;
	            <img src='_img/icons/icon_delete.png' class='link' alt='<%=getTranNoLink("Web","clear",sWebLanguage)%>' onclick='fileFrom.value="";fileFromName.value="";'>
			</td>
			<td class='admin2'>
	            <input type='hidden' name='fileTo' id='fileTo' value='<%=sServiceTo%>'>
	            <input class='text' type='text' name='fileToName' id='fileToName' readonly size='35' value='<%=getTranNoLink("service",sServiceTo,sWebLanguage)%>'>&nbsp;
	            <img src='_img/icons/icon_search.png' class='link' alt='<%=getTranNoLink("Web","select",sWebLanguage)%>' onclick='searchService("fileTo","fileToName");'>&nbsp;
	            <img src='_img/icons/icon_delete.png' class='link' alt='<%=getTranNoLink("Web","clear",sWebLanguage)%>' onclick='fileTo.value="";fileToName.value="";'>
			</td>
			<td class='admin2'>
                <input type="hidden" name="fileUser" value="<%=activeUser.userid%>">
                <input class="text" type="text" name="fileUserName" readonly size="35" value="<%=activeUser.person.getFullName()%>">
                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(request,"web","select",sWebLanguage)%>" onclick="searchManager('fileUser','fileUserName');">
                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTran(request,"web","clear",sWebLanguage)%>" onclick="fileUser.value='';fileUserName.value='';">
                <input type='submit' class='button' name='saveButton' value='<%=getTran(request,"web","add",sWebLanguage) %>'/>
			</td>
		</tr>
		<tr><td colspan='5'><hr/></td></tr>
		<tr>
			<td class='admin' colspan='5'>
				<%=getTran(request,"web","from",sWebLanguage) %>
				<%=ScreenHelper.writeDateField("begindate", "transactionForm", ScreenHelper.formatDate(begin), true, false, sWebLanguage, sCONTEXTPATH) %>
				<%=getTran(request,"web","to",sWebLanguage) %>
				<%=ScreenHelper.writeDateField("enddate", "transactionForm", ScreenHelper.formatDate(end), true, false, sWebLanguage, sCONTEXTPATH) %>
				<input type='submit' class='button' name='findButton' value='<%=getTran(request,"web","find",sWebLanguage) %>'/>
			</td>
		<tr>
		<%
			long day = 24*3600*100;
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("select * from OC_FILETRACKING where OC_FILETRACKING_PERSONID=? and OC_FILETRACKING_DATE>=? and OC_FILETRACKING_DATE<=? order by OC_FILETRACKING_DATE DESC,OC_FILETRACKING_ID DESC");
			ps.setInt(1,Integer.parseInt(activePatient.personid));
			ps.setDate(2,new java.sql.Date(begin.getTime()));
			ps.setTimestamp(3,new java.sql.Timestamp(end.getTime()+day-1));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				String operation=rs.getString("OC_FILETRACKING_INOUT").toUpperCase();
				String delete="";
				if(activeUser.getAccessRight("add.filetracking.delete")){
					delete="<img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deleteFileTracking("+rs.getInt("OC_FILETRACKING_ID")+")'/>";
				}
				out.println("<tr>");
				out.println("<td class='admin2'>"+delete+ScreenHelper.formatDate(rs.getDate("OC_FILETRACKING_DATE"))+"</td>");
				out.println("<td class='admin2'>"+operation+"</td>");
				if(operation.equalsIgnoreCase("in")){
					out.println("<td class='admin2' colspan='2'>"+getTran(request,"web","receivedby",sWebLanguage)+" <b>"+getTran(request,"service",rs.getString("OC_FILETRACKING_TO"),sWebLanguage)+"</b> "+getTran(request,"web","from",sWebLanguage)+" "+getTran(request,"service",rs.getString("OC_FILETRACKING_FROM"),sWebLanguage)+"</td>");
				}
				else{
					out.println("<td class='admin2' colspan='2'>"+getTran(request,"web","sentby",sWebLanguage)+" <b>"+getTran(request,"service",rs.getString("OC_FILETRACKING_FROM"),sWebLanguage)+"</b> "+getTran(request,"web","to",sWebLanguage)+" "+getTran(request,"service",rs.getString("OC_FILETRACKING_TO"),sWebLanguage)+"</td>");
				}
				out.println("<td class='admin2'>"+User.getFullUserName(rs.getString("OC_FILETRACKING_USERID"))+"</td>");
				out.println("</tr>");
			}
			rs.close();
			ps.close();
			conn.close();
		%>
	</table>
</form>

<script>
	function searchManager(managerUidField,managerNameField){
	    openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+managerUidField+"&ReturnName="+managerNameField+"&displayImmatNew=no");
	    fileUserName.focus();
	}

	function searchService(serviceUidField,serviceNameField){
	   	openPopup("_common/search/searchService.jsp&ts=<%=getTs()%>&showinactive=0&VarCode="+serviceUidField+"&VarText="+serviceNameField);
	   	document.getElementsByName(serviceNameField)[0].focus();
	}
	function deleteFileTracking(id){
		if(confirm("<%=getTranNoLink("web","areyousure",sWebLanguage)%>")){
			document.getElementById('actionfield').value='delete;'+id;
			transactionForm.submit();
		}
	}
</script>