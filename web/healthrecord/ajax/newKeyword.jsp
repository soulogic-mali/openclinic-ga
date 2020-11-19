<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	if(SH.c(request.getParameter("saveAction")).equalsIgnoreCase("1")){
		String labeltype=SH.c(request.getParameter("labeltype"));
		String labelid=SH.c(request.getParameter("labelid"));
		if(SH.c(request.getParameter("ikirezicode")).length()>0){
			labelid+="."+request.getParameter("ikirezicode");
		}
		String keyword=SH.c(request.getParameter("keyword"));
		String language=SH.c(request.getParameter("language"));
		Label label = new Label();
		label.type=labeltype;
		label.id=labelid;
		label.language=language;
		label.showLink="1";
		label.updateUserId=activeUser.userid;
		label.value=keyword;
		label.saveToDB();
		out.println("<script>if(window.opener.refreshKeywords){window.opener.refreshKeywords();} window.close();</script>");
		out.flush();
	}
	String labeltype=request.getParameter("labeltype");
	String labelid="A"+MedwanQuery.getInstance().getOpenclinicCounter("keywords");
%>
<form name='transactionForm' id='transactionForm' method='POST'>
	<input type='hidden' name='labeltype' value='<%=labeltype %>'/>
	<input type='hidden' name='labelid' value='<%=labelid %>'/>
	<input type='hidden' name='saveAction' id='saveAction' value=''/>
	<table width='100%'>
		<tr class='admin'><td colspan='2'><%=getTran(request,"web","addnewkeyword",sWebLanguage) %></td></tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","labeltype",sWebLanguage) %></td>
			<td class='admin2'><%=labeltype %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","labelid",sWebLanguage) %></td>
			<td class='admin2'>
				<%=labelid %>
			</td>
		</tr>
		<tr>
			<td class='admin'>Ikirezi</td>
			<td class='admin2'>
				<select name='ikirezicode' id='ikirezicode' class='text'>
					<option/>
					<%
						Connection iconn = MedwanQuery.getInstance().getIkireziConnection();
						String sLanguage="sympf";
						if(sWebLanguage.equalsIgnoreCase("en")){
							sLanguage="sympe";
						}
						else if(sWebLanguage.equalsIgnoreCase("es")){
							sLanguage="symps";
						}
						else if(sWebLanguage.equalsIgnoreCase("pt")){
							sLanguage="sympp";
						}
						else if(sWebLanguage.equalsIgnoreCase("nl")){
							sLanguage="sympn";
						}
						PreparedStatement ps = iconn.prepareStatement("select * from sym_lang order by "+sLanguage);
						ResultSet rs = ps.executeQuery();
						while(rs.next()){
							out.println("<option value ='"+rs.getString("nrs")+"'>"+SH.capitalizeFirst(rs.getString(sLanguage))+"</option>");
						}
						rs.close();
						ps.close();
						iconn.close();
					%>					
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","language",sWebLanguage) %></td>
			<td class='admin2'>
		          <select id="language" name="language" class="text">
		              <option value=""></option>
		              <%
		                  String tmpLang;
		                  StringTokenizer tokenizer = new StringTokenizer(SH.cs("supportedLanguages","en"),",");
		                  while(tokenizer.hasMoreTokens()){
		                      tmpLang = tokenizer.nextToken();
		                      %><option value="<%=tmpLang%>" <%=(sWebLanguage.equals(tmpLang)?"selected":"")%>><%=getTranNoLink("web.language",tmpLang,sWebLanguage)%></option><%
		                  }
		              %>
		          </select>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"ikirezi","keyword",sWebLanguage) %></td>
			<td class='admin2'>
				<input type='text' class='text' name='keyword' size='60'/>
			</td>
		</tr>
	</table>
	<center><input type='button' class='button' name='saveButton' value='<%=getTranNoLink("web","save",sWebLanguage) %>' onclick='doSave();'/></center>
</form>

<script>
	function doSave(){
		document.getElementById('saveAction').value='1';
		document.getElementById('transactionForm').submit();
	}
</script>