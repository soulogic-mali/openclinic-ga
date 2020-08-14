<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String sType = checkString(request.getParameter("type"));
	String sUid = checkString(request.getParameter("uid"));
	String sLabel = checkString(request.getParameter("label"));
	String sMinimum = checkString(request.getParameter("minimum"));
	String sMaximum = checkString(request.getParameter("maximum"));
	String sEquals = checkString(request.getParameter("equals"));
	String sComment = checkString(request.getParameter("comment"));
	String sEvalType="equals";
	if(sEquals.length()==0){
		sEvalType="between";
	}
	
	if(request.getParameter("saveButton")!=null){
		//Add the category combo option to the database
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("delete from OC_DHIS2CategoryComboOptions where uid=?");
		ps.setString(1,sUid);
		ps.execute();
		ps=conn.prepareStatement("insert into OC_DHIS2CategoryComboOptions(type,uid,label,minimum,maximum,equals,comment) values(?,?,?,?,?,?,?)");
		ps.setString(1, sType);
		ps.setString(2, sUid);
		ps.setString(3, sLabel);
		ps.setString(4, sMinimum);
		ps.setString(5, sMaximum);
		ps.setString(6, sEquals);
		ps.setString(7, sComment.replaceAll("'","´"));
		ps.execute();
		ps.close();
		conn.close();
	}
	else if(checkString(request.getParameter("actionfield")).equalsIgnoreCase("delete")){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("delete from OC_DHIS2CategoryComboOptions where uid=?");
		ps.setString(1,sUid);
		ps.execute();
		ps.close();
		conn.close();
		sUid="";
		sLabel="";
		sMinimum="";
		sMaximum="";
		sEquals="";
		sComment="";
	}
%>
<form name='transactionForm' method='post'>
	<input type='hidden' name='actionfield' id='actionfield'/>
	<table width='100%'>
		<tr class='admin'><td><%=getTran(request,"dhis2","managecategories",sWebLanguage) %></td></tr>
		<tr>
			<td>
				<table width='100%'>
					<tr>
						<td class='admin' width='20%'><%=getTran(request,"web","type",sWebLanguage) %> *</td>
						<td class='admin2'>
							<select class='text' name='type' id='type' onchange='transactionForm.submit();'>
								<%=ScreenHelper.writeSelect(request, "dhis2.categorycombotype", sType, sWebLanguage) %>
							</select>
						</td>
					</tr>
					<tr>
						<td class='admin'><%=getTran(request,"web","label",sWebLanguage) %></td>
						<td class='admin2'>
							<input type='text' class='text' name='label' id='label' value='<%=sLabel %>' size='80'/>
						</td>
					</tr>
					<tr>
						<td class='admin'><%=getTran(request,"web","uid",sWebLanguage) %> *</td>
						<td class='admin2'>
							<input type='text' class='text' name='uid' id='uid' value='<%=sUid %>' size='40'/>
						</td>
					</tr>
					<tr>
						<td class='admin'><%=getTran(request,"web","content",sWebLanguage) %> *</td>
						<td class='admin2'>
							<select class='text' name='evaltype' id='evaltype' onchange='showEvalFields();'>
								<%=ScreenHelper.writeSelect(request, "dhis2.evaltype", sEvalType, sWebLanguage) %>
							</select>
							<span id='contentequals'>
								<input type='text' class='text' name='equals' id='equals' value='<%=sEquals %>' size='40'/>
							</span>
							<span id='contentbetween'>
								<input type='text' class='text' name='minimum' id='minimum' value='<%=sMinimum %>' size='20'/>
								<%=getTran(request,"web","and",sWebLanguage) %>
								<input type='text' class='text' name='maximum' id='maximum' value='<%=sMaximum %>' size='20'/>
							</span>
						</td>
					</tr>
					<tr>
						<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td>
						<td class='admin2'>
							<textarea class='text' name='comment' id='comment' cols='80' rows='2'><%=sComment %></textarea>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<input type='submit' class='button' name='saveButton' value='<%=getTranNoLink("web","save",sWebLanguage) %>'/>
</form>
<table width='100%'>
	<tr class='admin'>
		<td colspan='2'><%=getTran(request,"web","label",sWebLanguage) %></td>
		<td><%=getTran(request,"web","uid",sWebLanguage) %></td>
		<td><%=getTran(request,"web","content",sWebLanguage) %></td>
		<td><%=getTran(request,"web","comment",sWebLanguage) %></td>
	</tr>
<%
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from OC_DHIS2CategoryComboOptions where type=? order by label");
	ps.setString(1,sType);
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		String type=rs.getString("type");
		String uid=rs.getString("uid");
		String label=rs.getString("label");
		String min = checkString(rs.getString("minimum"));
		String max = checkString(rs.getString("maximum"));
		String val = checkString(rs.getString("equals"));
		String comment = checkString(rs.getString("comment")).replaceAll("\n","<br/>").replaceAll("\r", "");
		out.println("<tr>");
		out.println("<td class='admin2' width='1%' nowrap>");
		out.println("<img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deleteItem(\""+uid+"\")'/>");
		out.println("<img src='"+sCONTEXTPATH+"/_img/icons/icon_edit.png' onclick='editItem(\""+type+"\",\""+uid+"\",\""+label+"\",\""+min+"\",\""+max+"\",\""+val+"\",\""+comment+"\")'/>");
		out.println("</td>");
		out.println("<td class='admin2'>"+label+"</td>");
		out.println("<td class='admin2'>"+uid+"</td>");
		if(val.length()>0){
			out.println("<td class='admin2'>="+val+"</td>");
		}
		else{
			out.println("<td class='admin2'>"+min+" =&gt; "+max+"</td>");
		}
		out.println("<td class='admin2'>"+comment+"</td>");
		out.println("</tr>");
	}
	rs.close();
	ps.close();
	conn.close();
%>
</table>

<script>
	function showEvalFields(){
		if(document.getElementById('evaltype').value=='equals'){
			document.getElementById('contentequals').style.display='';
			document.getElementById('contentbetween').style.display='none';
		}
		else if(document.getElementById('evaltype').value=='between'){
			document.getElementById('contentequals').style.display='none';
			document.getElementById('contentbetween').style.display='';
		}
	}
	
	function deleteItem(uid){
		if(window.confirm('<%=getTranNoLink("web","areyousuretodelete",sWebLanguage)%>')){
			document.getElementById('actionfield').value='delete';
			document.getElementById('uid').value=uid;
			transactionForm.submit();
		}
	}
	
	function editItem(type,uid,label,min,max,val,comment){
		document.getElementById('type').value=type;
		document.getElementById('uid').value=uid;
		document.getElementById('label').value=label;
		document.getElementById('minimum').value=min;
		document.getElementById('maximum').value=max;
		document.getElementById('equals').value=val;
		document.getElementById('comment').value=comment.replace("<br/>","\n");
	}
	
	showEvalFields();
</script>