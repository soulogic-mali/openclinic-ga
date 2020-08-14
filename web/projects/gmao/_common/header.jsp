<%@page import="be.openclinic.id.FingerPrint,
                be.mxs.common.util.system.Picture,
                be.openclinic.id.Barcode"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<script>    
  function checkDropdown(evt){
    if(window.myButton){
      lastevt = evt || window.event;
      var target;
      if(lastevt.target){
        target = lastevt.target;
      }
      else{
        target = lastevt.srcElement;
      }
      
      if(target.id.indexOf("menu") > -1 || target.id.indexOf("ddIcon") > -1){
    	return checkSaveButton();
      }
    }
  }
</script>

<table width="100%" cellspacing="0" cellpadding="0" class="topline">
    <tr>
        <%-- ADMIN HEADER --%>
        <td width="100%" valign="top" align="left">
            <table width="100%" cellspacing="0" cellpadding="0" border="0">
                <%
                    if(!"datacenter".equalsIgnoreCase((String)session.getAttribute("edition"))){
                        %>
			                <tr onmousedown="checkDropdown(event);">
			                    <td class="menu_bar" style="vertical-align:top;" colspan="3">
			                        <%ScreenHelper.setIncludePage(customerInclude("/_common/dropdownmenu.jsp"),pageContext);%>
			                    </td>			
			                </tr>
			                <tr>
			                    <td align="left">
			                        <%ScreenHelper.setIncludePage(customerInclude("/_common/searchPatient.jsp"),pageContext);%>
			                    </td>
			                </tr>
	                    <%
	                }
	            %>
            </table>
        </td>
    </tr>
</table>
<div style="position:absolute;right:5px;top:5px;width:400px">
	<div class="logogmao" style="background:url('<c:url value="/_img/themes/default/"/><%=MedwanQuery.getInstance().getConfigInt("TestEdition",0)==0?"logo_gmao.png":"logo_gmao_test.png"%>');">
</div>
