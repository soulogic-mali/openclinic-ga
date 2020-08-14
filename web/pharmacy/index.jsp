<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%=ScreenHelper.writeTblHeader(getTran(request,"Web","pharmacy",sWebLanguage),sCONTEXTPATH)
    +writeTblChild("main.do?Page=pharmacy/manageProducts.jsp",getTran(request,"Web.Manage","manageProducts",sWebLanguage))
    +writeTblChild("main.do?Page=pharmacy/manageServiceStocks.jsp",getTran(request,"Web.Manage","manageServiceStocks",sWebLanguage))
    +writeTblChild("main.do?Page=pharmacy/drugsOut.jsp",getTran(request,"web","drugsout",sWebLanguage))
    +writeTblChild("main.do?Page=pharmacy/manageUserProducts.jsp",getTran(request,"web","manageUserProducts",sWebLanguage))
    +writeTblChild("main.do?Page=pharmacy/manageProductOrders.jsp",getTran(request,"web","manageProductOrders",sWebLanguage))
    +writeTblChild("main.do?Page=pharmacy/viewOrderTickets.jsp",getTran(request,"web","viewOrderTickets",sWebLanguage))
    +writeTblChild("main.do?Page=pharmacy/manageProductStockDocuments.jsp",getTran(request,"web","manageProductStockDocuments",sWebLanguage))
    +writeTblChild("/main.do?Page=pharmacy/manageProductionOrders.jsp&EditOpenOrdersOnly=1&autofind=1",getTran(request,"web","pharmacy.productionorders",sWebLanguage))
    +ScreenHelper.writeTblFooter()
%>