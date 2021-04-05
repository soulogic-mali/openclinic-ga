<%@page import="be.openclinic.pharmacy.Batch"%>
<%@page import="be.openclinic.pharmacy.BatchOperation"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String giftid = SH.c(request.getParameter("giftid"));
	String type = SH.c(request.getParameter("type"));
	String end = SH.c(request.getParameter("end"));
	int quantity = Integer.parseInt(request.getParameter("quantity"));
	
	//CHeck if a batch exists for this type of blood product
	int pocketsReceived=0;
	Vector batches = Batch.getByBatchNumber(giftid+"."+type);
	for(int i=0;i<batches.size();i++){
		Batch batch = (Batch)batches.elementAt(i);
		Vector operations = Batch.getBatchOperations(batch.getUid(), sWebLanguage);
		for(int n=0;n<operations.size();n++){
			BatchOperation operation = (BatchOperation)operations.elementAt(n);
			if(operation.getType().equalsIgnoreCase("receipt") && SH.c(operation.getProductStockOperation().getReceiveComment()).equalsIgnoreCase("BloodBank Production")){
				pocketsReceived+=operation.getQuantity();
			}
		}
	}
	if(pocketsReceived<quantity){
		out.println(getTran(request,"web","productstobetransferred",sWebLanguage)+": "+(quantity-pocketsReceived)+" ");
		out.println("<a href=\"javascript:transferProducts('"+giftid+"','"+type+"',"+(quantity-pocketsReceived)+")\"><img style='height: 14px;vertical-align: middle' src='"+sCONTEXTPATH+"/_img/icons/icon_upload.gif'/></a>");
	}
	else{
		out.println("<img style='vertical-align: middle;height: 14px' src='"+sCONTEXTPATH+"/_img/icons/icon_ok.gif'/>");
	}
%>
