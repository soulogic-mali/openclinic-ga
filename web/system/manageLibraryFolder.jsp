<%@page import="be.openclinic.util.Nomenclature"%>
<%@ page errorPage="/includes/error.jsp" %>
<%@ include file="/includes/validateUser.jsp" %>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%
	String sAction = checkString(request.getParameter("action"));
	String sParentFolderName = checkString(request.getParameter("parentFolderName"));
	String sParentFolderCode = checkString(request.getParameter("parentFolderCode"));
	String sFolderName = checkString(request.getParameter("folderName"));
	String sFolderCode = checkString(request.getParameter("folderCode"));
	String sFolderNameInit = checkString(request.getParameter("folderNameInit"));
	String sFolderCodeInit = checkString(request.getParameter("folderCodeInit"));
	String sReturnFolderCode = checkString(request.getParameter("returnFolderCode"));
	String sReturnFolderName = checkString(request.getParameter("returnFolderName"));
	String sReturnFunction = checkString(request.getParameter("returnFunction"));
	
	if(sFolderName.length()==0){
		sFolderName=sFolderNameInit;
	}
	if(sFolderCode.length()==0){
		sFolderCode=sFolderCodeInit;
	}
	if(sAction.equalsIgnoreCase("new") && sFolderCode.length()==0){
		sFolderCode=MedwanQuery.getInstance().getOpenclinicCounter("LIBRARY")+"";
	}
	else if(sFolderCode.length()==0){
		out.println("<script>window.close();</script>");
		out.flush();
	}
	else if(sParentFolderCode.length()==0){
		Nomenclature nomenclature = Nomenclature.get("library",sFolderCode);
		if(nomenclature!=null){
			sParentFolderCode = checkString(nomenclature.getParentId());
			sParentFolderName = getTranNoLink("library",sParentFolderCode,sWebLanguage);
		}
	}
	if(request.getParameter("submitButton")!=null && sFolderCode.length()>0 && sFolderName.length()>0){
		//Save this folder
		Nomenclature nomenclature = new Nomenclature();
		nomenclature.setId(sFolderCode);
		nomenclature.setInactive(0);
		nomenclature.setParentId(sParentFolderCode);
		nomenclature.setType("library");
		nomenclature.setUpdateTime(new java.util.Date());
		nomenclature.setUpdatetUserId(Integer.parseInt(activeUser.userid));
		nomenclature.store();
		//Store the foldername as a label
		Label label = new Label();
		label.type="library";
		label.id=sFolderCode;
		label.language=sWebLanguage;
		label.showLink="1";
		label.updateUserId=activeUser.userid;
		label.value=sFolderName;
		label.saveToDB();
		//Update the calling window
		out.println("<script>");
		if(sReturnFolderCode.length()>0){
			out.println("window.opener.document.getElementById('"+sReturnFolderCode+"').value='"+sFolderCode+"';");
		}
		if(sReturnFolderName.length()>0){
			out.println("window.opener.document.getElementById('"+sReturnFolderName+"').value='"+sFolderName+"';");
		}
		if(sReturnFunction.length()>0){
			out.println("window.opener."+sReturnFunction+";");
		}
		out.println("	window.close();");
		out.println("</script>");
		out.flush();
	}
	else if(request.getParameter("deleteButton")!=null && sFolderCode.length()>0){
		Nomenclature.delete("library", sFolderCode);
		//Update the calling window
		out.println("<script>");
		if(sReturnFolderCode.length()>0){
			out.println("window.opener.document.getElementById('"+sReturnFolderCode+"').value='"+sParentFolderCode+"';");
		}
		if(sReturnFolderName.length()>0){
			out.println("window.opener.document.getElementById('"+sReturnFolderName+"').value='"+getTranNoLink("library",sParentFolderCode,sWebLanguage)+"';");
		}
		if(sReturnFunction.length()>0){
			out.println("window.opener."+sReturnFunction+";");
		}
		out.println("	window.close();");
		out.println("</script>");
		out.flush();
	}
%>

<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'><td colspan='2'><%=getTran(request,"web","managefolder",sWebLanguage) %></td></tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","parent",sWebLanguage) %></td>
			<td class='admin2'>
				<input type='hidden' name='parentFolderCode' id='parentFolderCode' value='<%=sParentFolderCode %>'/>
				<input type='hidden' name='parentFolderName' id='parentFolderName' value='<%=sParentFolderName %>'/>
				<%=sParentFolderName %>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","name",sWebLanguage) %></td>
			<td class='admin2'>
				<input type='hidden' name='folderCode' id='folderCode' value='<%=sFolderCode %>'/>
				<input type='text' class='text' name='folderName' id='folderName' value='<%=sFolderName %>' size='50'/>
			</td>
		</tr>
		<tr>
			<td class='admin2'/>
			<td class='admin2'>
				<input type='submit' name='submitButton' value='<%=getTranNoLink("web","save",sWebLanguage) %>'/>
				<input type='button' onclick='window.close();' name='cancelButton' value='<%=getTranNoLink("web","cancel",sWebLanguage) %>'/>
				<%
					if(!checkString(request.getParameter("action")).equalsIgnoreCase("new") && sFolderCode.length()>0){
				%>
					<input type='submit' name='deleteButton' value='<%=getTranNoLink("web","delete",sWebLanguage) %>'/>
				<%
					}
				%>
			</td>
		</tr>
	</table>
</form>

<script>
	document.getElementById("folderName").focus();
</script>