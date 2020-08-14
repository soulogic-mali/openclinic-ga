<%@ page import="java.util.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%!
	private String getRow(String name, String type, String id,String language){
		return "<tr><td class='admin2'><input type='checkbox' value='1' name='"+name+"' "+(MedwanQuery.getInstance().getConfigInt(name,1)==1?"checked":"")+"/>"+getTran(null,type,id,language)+"</td></tr>";
	}

	private void setConfig(String name, HttpServletRequest request){
		if(request.getParameter(name)==null){
			MedwanQuery.getInstance().setConfigString(name, "0");
		}
		else {
			MedwanQuery.getInstance().setConfigString(name, "1");
		}
	}
%>

<%
	if(request.getParameter("submit")!=null){
		setConfig("showAdminLastname",request);
		setConfig("showAdminFirstname",request);
		setConfig("showAdminDateOfBirth",request);
		setConfig("showAdminNativeTown",request);
		setConfig("showAdminNativeCountry",request);
		setConfig("showAdminPersonId",request);
		setConfig("showAdminImmatNew",request);
		setConfig("showAdminArchiveFileCode",request);
		setConfig("showAdminNatReg",request);
		setConfig("showAdminLanguage",request);
		setConfig("showAdminGender",request);
		setConfig("showAdminTracnetID",request);
		setConfig("showAdminComment",request);
		setConfig("showAdminComment1",request);
		setConfig("showAdminComment2",request);
		setConfig("showAdminComment3",request);
		setConfig("showAdminComment4",request);
		setConfig("showAdminComment5",request);
		setConfig("showAdminDeathCertificate",request);
		setConfig("showAdminPrivateDistrict",request);
		setConfig("showAdminPrivateSanitaryDistrict",request);
		setConfig("showAdminPrivateSector",request);
		setConfig("showAdminPrivateCell",request);
		setConfig("showAdminPrivateCountry",request);
		setConfig("showAdminPrivateProvince",request);
		setConfig("showAdminPrivateCity",request);
		setConfig("showAdminPrivateZipcode",request);
		setConfig("showAdminPrivateAddress",request);
		setConfig("showAdminPrivateEmail",request);
		setConfig("showAdminPrivateTelephone",request);
		setConfig("showAdminPrivateMobile",request);
		setConfig("showAdminPrivateFunction",request);
		setConfig("showAdminPrivateBusiness",request);
		setConfig("showAdminPrivateComment",request);
		setConfig("showAdminPrivateHSRegion",request);
		setConfig("showAdminPrivateHSDistrict",request);
		setConfig("showAdminPrivateHSPost",request);
		setConfig("showAdminPrivateHSVillage",request);
	}
%>

<%=checkPermission(out,"system.management","all",activeUser)%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'><td colspan='2'><%=getTran(request,"web","managevisiblefields",sWebLanguage) %></td></tr>
		<tr valign='top'><td><table width='100%'><tr><td class='admin'><%=getTran(request,"web","actualpersonaldata",sWebLanguage) %></td></tr>
		<%=getRow("showAdminLastname","web","lastname",sWebLanguage) %>
		<%=getRow("showAdminFirstname","web","firstname",sWebLanguage) %>
		<%=getRow("showAdminDateOfBirth","web","dateofbirth",sWebLanguage) %>
		<%=getRow("showAdminNativeTown","web","nativetown",sWebLanguage) %>
		<%=getRow("showAdminNativeCountry","web","nativecountry",sWebLanguage) %>
		<%=getRow("showAdminPersonId","web","personid",sWebLanguage) %>
		<%=getRow("showAdminImmatNew","web","immatnew",sWebLanguage) %>
		<%=getRow("showAdminArchiveFileCode","web","archivefilecode",sWebLanguage) %>
		<%=getRow("showAdminNatReg","web","natreg",sWebLanguage) %>
		<%=getRow("showAdminLanguage","web","language",sWebLanguage) %>
		<%=getRow("showAdminGender","web","gender",sWebLanguage) %>
		<%=getRow("showAdminTracnetID","web","tracnetid",sWebLanguage) %>
		<%=getRow("showAdminComment","web","comment",sWebLanguage) %>
		<%=getRow("showAdminComment1","web","comment1",sWebLanguage) %>
		<%=getRow("showAdminComment2","web","comment2",sWebLanguage) %>
		<%=getRow("showAdminComment3","web","comment3",sWebLanguage) %>
		<%=getRow("showAdminComment4","web","comment4",sWebLanguage) %>
		<%=getRow("showAdminComment5","web","comment5",sWebLanguage) %>
		<%=getRow("showAdminDeathCertificate","web","deathcertificate",sWebLanguage) %></td></table></td>
		<td><table width='100%'><tr><td class='admin'><%=getTran(request,"web","private",sWebLanguage) %></td></tr>
		<%=getRow("showAdminPrivateSanitaryDistrict","web","region",sWebLanguage) %>
		<%=getRow("showAdminPrivateDistrict","web","district",sWebLanguage) %>
		<%=getRow("showAdminPrivateSector","web","sector",sWebLanguage) %>
		<%=getRow("showAdminPrivateCell","web","cell",sWebLanguage) %>
		<%=getRow("showAdminPrivateCountry","web","country",sWebLanguage) %>
		<%=getRow("showAdminPrivateProvince","web","province",sWebLanguage) %>
		<%=getRow("showAdminPrivateCity","web","city",sWebLanguage) %>
		<%=getRow("showAdminPrivateZipcode","web","zipcode",sWebLanguage) %>
		<%=getRow("showAdminPrivateAddress","web","address",sWebLanguage) %>
		<%=getRow("showAdminPrivateEmail","web","email",sWebLanguage) %>
		<%=getRow("showAdminPrivateTelephone","web","telephone",sWebLanguage) %>
		<%=getRow("showAdminPrivateMobile","web","mobile",sWebLanguage) %>
		<%=getRow("showAdminPrivateFunction","web","function",sWebLanguage) %>
		<%=getRow("showAdminPrivateBusiness","web","business",sWebLanguage) %>
		<%=getRow("showAdminPrivateComment","web","comment",sWebLanguage) %>
		<%=getRow("showAdminPrivateHSRegion","web","healthregion",sWebLanguage) %>
		<%=getRow("showAdminPrivateHSDistrict","web","healthdistrict",sWebLanguage) %>
		<%=getRow("showAdminPrivateHSPost","web","healthpost",sWebLanguage) %>
		<%=getRow("showAdminPrivateHSVillage","web","healthvillage",sWebLanguage) %>
		</table></td></tr>
		<tr><td colspan='2'><input type='submit' name='submit' value='<%=getTran(null,"web","save",sWebLanguage) %>'/></td></tr>
	</table>
</form>