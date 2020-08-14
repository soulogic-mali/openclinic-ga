<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<center><img width='200px' src='<%=sCONTEXTPATH %>/_img/weasis.png'/><br/>
<font style='font-size: 14px;font-weight: bold;color: red'><%=getTran(request,"web","dicomviewermissing",sWebLanguage) %></font>
<p/>
<font style='font-size: 12px;font-weight: bold'>
<%=getTran(request,"web","downloaddicomviewer",sWebLanguage) %>
</font>
<br/><br/>
<a style='font-size: 12px;' href='<%=sCONTEXTPATH %>/pacs/Weasis-3.5.4-x86-64.msi'><%=getTran(request,"web","weasis.windows.64",sWebLanguage) %></a><br/>
<a style='font-size: 12px;' href='<%=sCONTEXTPATH %>/pacs/Weasis-3.5.4-x86.msi'><%=getTran(request,"web","weasis.windows.32",sWebLanguage) %></a>
</center>
