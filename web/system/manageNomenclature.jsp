<%@page import="java.util.*,be.openclinic.util.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%
	String sAction=checkString(request.getParameter("action"));
	String sFindText=checkString(request.getParameter("FindText"));
	String sFindNomenclatureCode =checkString(request.getParameter("FindNomenclatureCode"));
	String sType=checkString(request.getParameter("type"));

    String supportedLanguages = MedwanQuery.getInstance().getConfigString("supportedLanguages");
    if(supportedLanguages.length()==0) supportedLanguages = "nl,fr";
    supportedLanguages = supportedLanguages.toLowerCase();
    
    if(sAction.equalsIgnoreCase("save")){
    	Nomenclature nomenclature = new Nomenclature();
    	nomenclature.setType(request.getParameter("type"));
    	nomenclature.setId(checkString(request.getParameter("code")));
    	nomenclature.setParentId(checkString(request.getParameter("parentcode")));
    	nomenclature.store();
    	Enumeration parnames = request.getParameterNames();
    	while(parnames.hasMoreElements()){
    		String parname = (String)parnames.nextElement();
    		if(parname.startsWith("label.")){
    			Label label = new Label();
    			label.type=request.getParameter("type");
    			label.id=request.getParameter("code");
    			label.language=parname.split("\\.")[1];
    			label.value=request.getParameter(parname)+(checkString(request.getParameter(parname.replaceAll("label", "mode"))).length()>0?";"+request.getParameter(parname.replaceAll("label", "mode")):"");
    			label.updateUserId=activeUser.userid;
    			label.saveToDB();
    		}
    	}
    }
    else if(sAction.equalsIgnoreCase("delete")){
    	Nomenclature.delete(request.getParameter("type"),checkString(request.getParameter("code")));
    	Label.delete(request.getParameter("type"), checkString(request.getParameter("code")));
    	sFindText="";
    }
%>

<form name="transactionForm" method="post">
	<input type="hidden" name="action" id="action"/>
	<input type="hidden" name="editcode" id="editcode"/>
	<table width="100%">
		<tr class="admin">
			<td colspan="2"><%=getTran(request,"web","managenomenclature",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","nomenclature",sWebLanguage) %></td>
			<td class='admin2'>
				<select name="type" id="type" class="text">
					<%=ScreenHelper.writeSelect(request, "nomenclature.types", sType, sWebLanguage) %>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","search",sWebLanguage) %></td>
			<td class='admin2'>
                <input class="text" type="text" name="FindText" id="FindText" READONLY size="<%=sTextWidth%>" title="<%=sFindText%>" value="<%=sFindText%>">
                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchNomenclature('FindNomenclatureCode','FindText');">
                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.FindNomenclatureCode.value='';transactionForm.FindText.value='';">
                <input type="hidden" name="FindNomenclatureCode" id="FindNomenclatureCode" value="<%=sFindNomenclatureCode%>" onchange='edit(this.value)'>&nbsp;
				<input type='button' class='button' name='editButton' value='<%=getTran(request,"web","edit",sWebLanguage) %>' onclick='edit("");'/>
				<input type='button' class='button' name='newButton' value='<%=getTran(request,"web","new",sWebLanguage) %>' onclick='newNomenclature();'/>
			</td>
		</tr>
	</table>

	<table width="100%">
	<%
		Nomenclature nomenclature = null;
		if(sAction.equalsIgnoreCase("find")){
			Vector nomenclatureIDs = Nomenclature.getNomenclatureIDsByText(sType, sWebLanguage, sFindText);
			boolean bInitialized=false;
			for(int n=0;n<nomenclatureIDs.size();n++){
				bInitialized=true;
				String id = (String)nomenclatureIDs.elementAt(n);
				out.println("<tr><td class='admin'><a href='javascript:edit(\""+id+"\")'>"+id+"</a></td><td class='admin2'>"+getTran(request,sType,id,sWebLanguage)+"</td></tr>");
			}
			if(!bInitialized){
				out.println("<tr><td colspan='2'>"+getTran(request,"web","norecordsfound",sWebLanguage)+"</td></tr>");
			}
		}
		else if(sAction.equalsIgnoreCase("new")){
			nomenclature = new Nomenclature();
		}
		else if(sAction.equalsIgnoreCase("edit")){
			nomenclature=Nomenclature.get(sType,checkString(request.getParameter("editcode")));
		}
		if(nomenclature!=null){
		%>
			<tr>
				<td class='admin'><%=getTran(request,"web","code",sWebLanguage) %></td>
				<td class='admin2'><input type='text' class='text' size='40' id='code' name='code' value='<%=nomenclature.getId()%>'/></td>
			</tr>
			<tr>
				<td class='admin'><%=getTran(request,"web","parent",sWebLanguage) %></td>
				<td class='admin2'>
	                <input type="text" class="text" READONLY name="parentcode" id="parentcode" value="<%=nomenclature.getParentId()%>">
	                <input class="text" type="text" name="FindParentText" id="FindParentText" READONLY size="<%=sTextWidth%>" title="<%=getTranNoLink(sType,nomenclature.getParentId(),sWebLanguage)%>" value="<%=getTranNoLink(sType,nomenclature.getParentId(),sWebLanguage)%>">
	                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchNomenclature('parentcode','FindParentText');">
	                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.parentcode.value='';transactionForm.FindParentText.value='';">
				</td>
			</tr>
			<%
			    // display input field for each of the supported languages
			    StringTokenizer tokenizer = new StringTokenizer(supportedLanguages,",");
			    while(tokenizer.hasMoreTokens()){
			        String tmpLang = tokenizer.nextToken();
			        %>
			            <tr>
			                <td class="admin"> <%=getTran(request,"Web","Description",sWebLanguage)%> <%=tmpLang%> *</td>
			                <td class="admin2">
			                    <input type="text" class="text" name="label.<%=tmpLang%>" value="<%=getTranNoLink(sType,nomenclature.getId(),tmpLang).split(";")[0]%>" size="80">
				                &nbsp;
								<select name="mode.<%=tmpLang%>" id="mode.<%=tmpLang%>" class="text">
									<option/>
									<%=ScreenHelper.writeSelect(request, "nomenclature.modes", getTranNoLink(sType,nomenclature.getId(),tmpLang).split(";").length<=1?"":getTranNoLink(sType,nomenclature.getId(),tmpLang).split(";")[1], sWebLanguage) %>
								</select>
			                </td>
			            </tr>
			        <%
			    }
			out.println("<tr><td colspan='2'><input type='button' class='button' name='saveButton' value='"+getTranNoLink("web","save",sWebLanguage)+"' onclick='save()'/><input type='button' class='button' name='deleteButton' value='"+getTranNoLink("web","delete",sWebLanguage)+"' onclick='deleteNomenclature()'/></td></tr>");
		}
		%>
	</table>
</form>

<script>
	function find(){
		document.getElementById("action").value="find";
		transactionForm.submit();
	}
	function edit(code){
		document.getElementById("action").value="edit";
		if(code==""){
			document.getElementById("editcode").value=document.getElementById("FindNomenclatureCode").value;
		}
		else{
			document.getElementById("editcode").value=code;
		}
		transactionForm.submit();
	}
	function save(){
		document.getElementById("action").value="save";
		transactionForm.submit();
	}
	function deleteNomenclature(){
	    if(confirm("<%=getTran(null,"Web","AreYouSure",sWebLanguage)%>")){
			document.getElementById("action").value="delete";
			transactionForm.submit();
		}
	}
	function newNomenclature(){
		document.getElementById("action").value="new";
		transactionForm.submit();
	}
    function searchNomenclature(CategoryUidField,CategoryNameField){
	    openPopup("/_common/search/searchNomenclatureGeneral.jsp&ts=<%=getTs()%>&Mode=manage&FindType="+document.getElementById("type").value+"&VarCode="+CategoryUidField+"&VarText="+CategoryNameField);
	}

</script>
