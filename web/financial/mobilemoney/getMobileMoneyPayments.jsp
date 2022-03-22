<%@include file="/includes/validateUser.jsp"%>
<%
	String begin = SH.c(request.getParameter("begin"));
	String end = SH.c(request.getParameter("end"));
	String operator = SH.c(request.getParameter("operator"));
	String cashier = SH.c(request.getParameter("cashier"));
	String activepatient = SH.c(request.getParameter("activepatient"));
%>
<table width='100%'>
	<tr class='admin'>
		<td><%=getTran(request,"web","momotransactionid",sWebLanguage) %></td>
		<td><%=getTran(request,"web","created",sWebLanguage) %></td>
		<td><%=getTran(request,"web","invoice",sWebLanguage) %></td>
		<td><%=getTran(request,"web","patient",sWebLanguage) %></td>
		<td><%=getTran(request,"web","amount",sWebLanguage) %></td>
		<td><%=getTran(request,"momo","status",sWebLanguage) %></td>
		<td><%=getTran(request,"web","updated",sWebLanguage) %></td>
		<td><%=getTran(request,"web","operator",sWebLanguage) %></td>
		<td><%=getTran(request,"web","telephone",sWebLanguage) %></td>
		<td><%=getTran(request,"web","cashier",sWebLanguage) %></td>
	</tr>
	<%
		Connection conn= MedwanQuery.getInstance().getOpenclinicConnection();
		String sSql="select * from oc_momo,adminview where oc_momo_patientuid=personid and oc_momo_amount>0";
		if(begin.length()>0){
			sSql+=" and oc_momo_createdatetime>=?";
		}
		if(end.length()>0){
			sSql+=" and oc_momo_createdatetime<?";
		}
		if(operator.length()>0){
			sSql+=" and oc_momo_operator=?";
		}
		if(cashier.length()>0){
			sSql+=" and oc_momo_updateuid=?";
		}
		if(activepatient.equalsIgnoreCase("true")){
			sSql+=" and oc_momo_patientuid='"+activePatient.personid+"'";
		}
		sSql+=" order by oc_momo_createdatetime desc";
		PreparedStatement ps = conn.prepareStatement(sSql);
		int index=1;
		long day = 24*3600*1000;
		if(begin.length()>0){
			ps.setDate(index++,new java.sql.Date(SH.parseDate(begin).getTime()));
		}
		if(end.length()>0){
			ps.setDate(index++,new java.sql.Date(SH.parseDate(end).getTime()+day));
		}
		if(operator.length()>0){
			ps.setString(index++,operator);
		}
		if(cashier.length()>0){
			ps.setString(index++,cashier);
		}
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			boolean bCredited=SH.c(rs.getString("oc_momo_credittransactionid")).length()>0;
			String tranid=rs.getString("oc_momo_financialtransactionid");
			if(SH.c(tranid).length()==0){
				tranid="<i>"+rs.getString("oc_momo_transactionid")+"</i>";
			}
			else{
				if(!bCredited && activeUser.getAccessRight("financial.disbursemomo.select") && SH.c(rs.getString("oc_momo_status")).equalsIgnoreCase("successful")){
					tranid="<img id='img_"+rs.getString("oc_momo_financialtransactionid")+"' style='vertical-align: middle' onclick='reimbursePayment(\""+rs.getString("oc_momo_financialtransactionid")+"\")' src='"+sCONTEXTPATH+"/_img/icons/icon_erase.gif'/> "+tranid;
				} 
				tranid="<b>"+tranid+"</b>";
			}
			%>
			<tr>
				<td height='22px' class='admin2'><%=tranid%></td>
				<td class='admin2'><%=new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(rs.getTimestamp("oc_momo_createdatetime")) %></td>
				<% 	try{
						int i = Integer.parseInt(rs.getString("oc_momo_invoiceuid"));
						%><td class='admin2'><a href='javascript:openInvoice("<%=rs.getString("oc_momo_invoiceuid") %>")'><%=rs.getString("oc_momo_invoiceuid") %></a></td><%
					}
					catch(Exception e){
						%><td class='admin2'><%=rs.getString("oc_momo_invoiceuid") %></td><%
					}
				%>
				<%if(activePatient!=null && SH.c(rs.getString("personid")).equalsIgnoreCase(activePatient.personid)){ %>
					<td class='admin'><%=SH.c(rs.getString("lastname")).toUpperCase()+", "+SH.c(rs.getString("firstname")) %></td>
				<%}else{ %>
					<td class='admin2'><a href='<%=sCONTEXTPATH%>/main.do?Page=curative/index.jsp&PersonID=<%=rs.getString("personid")%>'><%=rs.getString("personid")+" - "+SH.c(rs.getString("lastname")).toUpperCase()+", "+SH.c(rs.getString("firstname")) %></a></td>
				<%} %>
				<td  id='td_<%=rs.getString("oc_momo_financialtransactionid") %>' class='<%=!bCredited?"admin2":"red"%>'><font id='font_<%=rs.getString("oc_momo_financialtransactionid") %>' <%=!bCredited?"":"style='text-decoration: line-through" %>'><%=rs.getString("oc_momo_amount")+" "+rs.getString("oc_momo_currency") %></font></td>
				<td class='<%=SH.c(rs.getString("oc_momo_status")).equalsIgnoreCase("failed")?"red":SH.c(rs.getString("oc_momo_status")).equalsIgnoreCase("successful")?"green":"admin2" %>'><%=rs.getString("oc_momo_status") %>
				<%	if(SH.c(rs.getString("oc_momo_status")).equalsIgnoreCase("pending")){ %>
					<img id='image_<%=rs.getString("oc_momo_transactionid")%>' src='<%=sCONTEXTPATH %>/_img/icons/icon_reload.png' onclick="checkPaymentStatus('<%=rs.getString("oc_momo_transactionid")%>')"/>
				<%	} %>
				</td>
				<td class='admin2'><%=new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(rs.getTimestamp("oc_momo_updatetime")) %></td>
				<td class='admin2'><%=rs.getString("oc_momo_operator") %></td>
				<td class='admin2'><%=rs.getString("oc_momo_payerphone") %></td>
				<td class='admin2'><%=rs.getString("oc_momo_updateuid") %></td>
			</tr>
			<%
		}
		rs.close();
		ps.close();
		conn.close();
	%>
</table>