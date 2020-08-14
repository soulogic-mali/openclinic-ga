<%@page import="org.apache.pdfbox.util.operator.NextLine"%>
<%@page import="be.mxs.common.util.tools.sendHtmlMail"%>
<%@page import="be.openclinic.pharmacy.*,be.openclinic.knowledge.*,
                java.util.Vector,
                be.mxs.common.util.system.*,
                be.openclinic.finance.*,be.openclinic.pharmacy.*,org.dom4j.*,org.dom4j.io.*,java.text.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%!
	String fullATCName(String atccode,String sLanguage){
		ATCClass atc = ATCClass.get(atccode);
		String[] fulllabel = atc.getFullLabel(sLanguage).split(">");
		String atclabel="<table>";
		for(int n=0;n<fulllabel.length;n++){
			atclabel+="<tr style='font-weight: bolder'><td>";
			for(int i=0;i<n;i++){
				atclabel+="&nbsp;";
			}
			atclabel+=fulllabel[n]+"</td></tr>";
		}
		atclabel+="</table>";
		return atclabel;
	}

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
		s=s.replaceAll("k", "c");
		s=s.replaceAll("th", "t");
		s=s.replaceAll("-", " ");
		s=s.replaceAll("\r", "");
		s=s.replaceAll("\n", " ");
		return s;
	}
%>
<%
	String sSearchCode= checkString(request.getParameter("SearchCode"));
	String sSearchType= checkString(request.getParameter("SearchType"));
	String sSearchFamily= checkString(request.getParameter("SearchFamily"));
	String sSearchInvoiceGroup= checkString(request.getParameter("SearchInvoiceGroup"));
	String sSearchCostCenter= checkString(request.getParameter("SearchCostCenter"));
	String sSearchClass= checkString(request.getParameter("SearchClass"));
	
	if(request.getParameter("updateButton")!=null && request.getParameter("updateButton").equalsIgnoreCase("1")){
		Enumeration parnames = request.getParameterNames();
		while(parnames.hasMoreElements()){
			String parname=(String)parnames.nextElement();
			if(parname.startsWith("cb.")){
				String[] tokens = parname.split("\\.");
				MedwanQuery.getInstance().getObjectCache().removeObject("prestation", tokens[1]+"."+tokens[2]);
				Prestation prestation = Prestation.get(tokens[1]+"."+tokens[2]);
				if(prestation!=null){
					prestation.setATCCode(tokens[3]);
					prestation.store();
				}
			}
		}
	}
	
%>
<form name='transactionForm' method='post'>
	<table>
		<tr>
			<td class='admin' nowrap width='1%'><%=getTran(request,"web","code",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' name='SearchCode'/></td>
			<td class='admin' nowrap width='1%'><%=getTran(request,"web","type",sWebLanguage) %></td>
			<td class='admin2'>
				<select type='text' class='text' name='SearchType'>
					<option/>
                    <%=ScreenHelper.writeSelect(request,"prestation.type",sSearchType,sWebLanguage)%>
				</select>
			</td>
			<td class='admin' nowrap width='1%'><%=getTran(request,"web","family",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' name='SearchFamily'/></td>
		</tr>
		<tr>
			<td class='admin' nowrap width='1%'><%=getTran(request,"web","invoicegroup",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' name='SearchInvoiceGroup'/></td>
			<td class='admin' nowrap width='1%'><%=getTran(request,"web","costcenter",sWebLanguage) %></td>
			<td class='admin2'>
                <select class="text" name="SearchCostCenter">
                	<option/>
                    <%=ScreenHelper.writeSelect(request,"costcenter",sSearchCostCenter,sWebLanguage)%>
                </select>
			</td>
			<td class='admin' nowrap width='1%'><%=getTran(request,"web","class",sWebLanguage) %></td>
			<td class='admin2'>
                <select class="text" name="SearchClass">
                	<option/>
                    <%=ScreenHelper.writeSelect(request,"prestation.class",sSearchClass,sWebLanguage)%>
                </select>
			</td>
		</tr>
		<tr>
			<td colspan='3'><input class='button' name='submitButton' value='<%=getTranNoLink("web","search",sWebLanguage) %>' type='submit'/></td>
		</tr>
	</table>
	<%
		if(request.getParameter("submitButton")!=null){
	%>
	<table border=1>
	<%
			Connection conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
			String sql="select * from oc_prestations where 1=1";
			if(sSearchCode.length()>0){
				sql+=" and oc_prestation_code like '"+sSearchCode+"%'";
			}
			if(sSearchType.length()>0){
				sql+=" and oc_prestation_type = '"+sSearchType+"'";
			}
			if(sSearchFamily.length()>0){
				sql+=" and oc_prestation_reftype = '"+sSearchFamily+"'";
			}
			if(sSearchInvoiceGroup.length()>0){
				sql+=" and oc_prestation_invoicegroup = '"+sSearchInvoiceGroup+"'";
			}
			if(sSearchCostCenter.length()>0){
				sql+=" and oc_prestation_modifiers like '%;%;%;%;%;%;%;%;"+sSearchCostCenter+";%'";
			}
			if(sSearchClass.length()>0){
				sql+=" and oc_prestation_class = '"+sSearchClass+"'";
			}
			PreparedStatement ps = conn.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();
			int n=0;
			while(rs.next()){
				String modifiers = rs.getString("oc_prestation_modifiers");
				if(modifiers!=null && modifiers.split(";").length>=12 && modifiers.split(";")[11].length()>0){
					continue;
				}
				n++;
				String drugname=checkString(rs.getString("oc_prestation_description"));
				SortedMap atccodes = Utils.extractFullATCCodes(drugname);
				if(atccodes.size()==0){
					//continue;
				}
				out.println("<tr class='admin'><td colspan='4'>"+checkString(rs.getString("oc_prestation_description"))+"</td></tr>");
				Iterator i = atccodes.keySet().iterator();
				while(i.hasNext()){
					String atccode = (String)i.next();
					out.println("<tr><td><input type='checkbox' name='cb."+rs.getString("oc_prestation_serverId")+"."+rs.getString("oc_prestation_objectId")+"."+atccode.split(";")[0]+"' class='text' checked/></td><td>"+atccode.split(";")[1]+"</td><td>"+atccode.split(";")[0]+"</td><td>"+fullATCName(atccode.split(";")[0], sWebLanguage)+"</tr>");
				}
				out.flush();
				if(n%100==0){
					Thread.sleep(100);
				}
			}
			rs.close();
			ps.close();
			conn.close();
	%>
	</table>
	<input type='hidden' name='updateButton' id='updateButton' value='0'/>
	<input type='button' class='button' name='update' value='<%=getTranNoLink("web","update",sWebLanguage) %>' onclick='document.getElementById("updateButton").value="1";transactionForm.submit();'/>
	<%
		}
	%>
</form>
