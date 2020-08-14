<%@page import="org.apache.pdfbox.util.operator.NextLine"%>
<%@page import="be.mxs.common.util.tools.sendHtmlMail"%>
<%@page import="be.openclinic.pharmacy.*,
                java.util.Vector,
                be.mxs.common.util.system.*,
                be.openclinic.finance.*,be.openclinic.pharmacy.*,org.dom4j.*,org.dom4j.io.*,java.text.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	String normalizeString(String s){
		s=ScreenHelper.checkString(s).toLowerCase();
		s=s.replaceAll("0", "");
		s=s.replaceAll("1", "");
		s=s.replaceAll("2", "");
		s=s.replaceAll("3", "");
		s=s.replaceAll("4", "");
		s=s.replaceAll("5", "");
		s=s.replaceAll("6", "");
		s=s.replaceAll("7", "");
		s=s.replaceAll("8", "");
		s=s.replaceAll("9", "");
		s=s.replaceAll("é", "e");
		s=s.replaceAll("è", "e");
		s=s.replaceAll("ê", "e");
		s=s.replaceAll("ë", "e");
		s=s.replaceAll("à", "a");
		s=s.replaceAll("â", "a");
		s=s.replaceAll("û", "u");
		s=s.replaceAll("ü", "u");
		s=s.replaceAll("ç", "c");
		s=s.replaceAll("/", " ");
		s=s.replaceAll("\\+", " ");
		s=s.replaceAll("\\.", " ");
		s=s.replaceAll(",", " ");
		s=s.replaceAll(";", " ");
		s=s.replaceAll("'", "");
		s=s.replaceAll("y", "i");
		s=s.replaceAll("ph", "f");
		s=s.replaceAll("ck", "k");
		s=s.replaceAll("qu", "k");
		s=s.replaceAll("q", "k");
		s=s.replaceAll("ks", "x");
		s=s.replaceAll("-", " ");
		s=s.replaceAll("\r", "");
		s=s.replaceAll("\n", " ");
		return s;
	}
%>
<%
	String sql="oc_prestation_type='med'";
	if(checkString(request.getParameter("sql")).length()>0){
		sql=checkString(request.getParameter("sql"));
	}
%>
<form name='transactionForm' method='post'>
	<table>
		<tr>
			<td><textarea name='sql' cols='160' rows='5'><%=sql %></textarea></td>
		</tr>
		<tr>
			<td><input name='submit' type='submit'/></td>
		</tr>
	</table>
</form>
<table border=1>
<%
	if(request.getParameter("submit")!=null){
		Connection conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("select * from oc_prestations where "+sql);
		ResultSet rs = ps.executeQuery();
		int n=0;
		while(rs.next()){
			n++;
			System.out.print(".");
			//SortedMap atccodes = Utils.extractATCCodes(checkString(request.getParameter("drugs")));
			String drugname=checkString(rs.getString("oc_prestation_description"));
			SortedMap atccodes = Utils.extractATCCodes(drugname);
			if(atccodes.size()==0){
				//continue;
			}
			out.println("<tr class='admin'><td colspan='3'>"+checkString(rs.getString("oc_prestation_description"))+"</td></tr>");
			Iterator i = atccodes.keySet().iterator();
			while(i.hasNext()){
				String atccode = (String)i.next();
				out.println("<tr><td>"+atccode.split(";")[1]+"</td><td>"+atccode.split(";")[0]+"</td><td>"+atccodes.get(atccode)+"</tr>");
			}
			out.flush();
			if(n%100==0){
				Thread.sleep(100);
			}
		}
		rs.close();
		ps.close();
		conn.close();
	}
		
%>
</table>
