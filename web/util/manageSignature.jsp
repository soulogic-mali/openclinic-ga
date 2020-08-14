<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sSignatureUid=checkString(request.getParameter("signatureuid"));
	String sMessage=checkString(request.getParameter("message"));
	
	if(request.getParameter("submitbutton")!=null){
		String sSignature = request.getParameter("drawingContent");
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("delete from OC_DRAWINGS where OC_DRAWING_SERVERID=? and OC_DRAWING_TRANSACTIONID=? and OC_DRAWING_ITEMTYPE=?");
		ps.setInt(1, Integer.parseInt(sSignatureUid.split("\\.")[0]));
		ps.setInt(2, Integer.parseInt(sSignatureUid.split("\\.")[1]));
		ps.setString(3,sSignatureUid.split("\\.")[2]);
		ps.execute();
		ps.close();
		ps = conn.prepareStatement("insert into OC_DRAWINGS(OC_DRAWING_SERVERID,OC_DRAWING_TRANSACTIONID,OC_DRAWING_ITEMTYPE,OC_DRAWING_DRAWING,OC_DRAWING_DATE) values(?,?,?,?,?)");
		ps.setInt(1, Integer.parseInt(sSignatureUid.split("\\.")[0]));
		ps.setInt(2, Integer.parseInt(sSignatureUid.split("\\.")[1]));
		ps.setString(3,sSignatureUid.split("\\.")[2]);
		ps.setBytes(4, ScreenHelper.base64Compress(sSignature));
		ps.setTimestamp(5, new Timestamp(new java.util.Date().getTime()));
		ps.execute();
		ps.close();
		conn.close();
	}
%>
<form name="transactionForm" method="post">
	<table width='100%'>
	    <tr>
	    	<td class='admin'><center><%=sMessage %></center></td>
	    </tr>
	    <tr>
	    	<td class='admin2'>
	    		<img src='<%=sCONTEXTPATH%>/_img/themes/default/erase.png' width='14px' onclick='canvasLoadImage("<%=sCONTEXTPATH%>/_img/signature.png")'/>
				<center><%=ScreenHelper.createSignatureDiv(request, "canvasDiv", "signature", sSignatureUid,"/_img/signature.png") %></center>
	    	</td>
	    </tr>
	    <tr>
	    	<td><center><input type='submit' class='button' name='submitbutton' value='<%=getTran(null,"web","save",sWebLanguage)%>'/>
	    	<input type='button' class='button' name='closebutton' value='<%=getTran(null,"web","close",sWebLanguage)%>' onclick='window.close();'/></center></td>
	    </tr>
	</table>
</form>

<script>
	canvasSetRadius(1);
</script>