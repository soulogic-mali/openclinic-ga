<%@page import="be.openclinic.pharmacy.*,be.openclinic.medical.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<table width="100%">
<%
	String sPatientUid=checkString(request.getParameter("PatientUid"));
	String sProductStockUid=checkString(request.getParameter("ProductStockUid"));
	String sReturnNumber=checkString(request.getParameter("ReturnNumber"));
	String sReturnEnd=checkString(request.getParameter("ReturnEnd"));
	String sReturnQuantity=checkString(request.getParameter("ReturnQuantity"));

	String sRefABO="";
	ProductStock productStock = ProductStock.get(sProductStockUid);
	if(productStock!=null){
		Product product = productStock.getProduct();
		if(product!=null){
			sRefABO=product.getAtccode();
		}
	}
	//Find all existing bloodgifts with expirydate in the future
    String sObjectId = "";
	Vector bloodgifts = MedwanQuery.getInstance().getTransactionsByType(Integer.parseInt(sPatientUid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_CNTS_BLOODGIFT");
	for(int n=0;n<bloodgifts.size();n++){
		int nPockets=0;
		TransactionVO bloodgift = (TransactionVO)bloodgifts.elementAt(n);
		String abo="",bloodgroup="",rhesus="";
		boolean bRejected = bloodgift.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_PERMANENTREJECTION").equalsIgnoreCase("medwan.common.true");
		if(!bRejected){
			bRejected = bloodgift.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA").replaceAll("\\*","").trim().length()>0;
		}
		if(!bRejected){
			//Now find out how many pockets have already been received
			try{
				nPockets=Integer.parseInt(bloodgift.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_POCKETS"));
			}
			catch(Exception z){}
			int alreadyreceived = ProductStockOperation.getReceiptsForBatchnumber(sProductStockUid, bloodgift.getTransactionId()+"");
			nPockets=nPockets-alreadyreceived;
			bRejected=nPockets<=0;
		}
		if(!bRejected){
			//Check if the bloodgroup is compatible
			//First find ABO + Rhesus for this bloodgift
        	RequestedLabAnalysis analysis = RequestedLabAnalysis.getByObjectid(bloodgift.getTransactionId(), MedwanQuery.getInstance().getConfigString("cntsBloodgroupCode","ABO"));
        	if(analysis!=null) {
        		abo=analysis.getResultValue().trim();
        		bloodgroup=abo+"";
        	}
        	analysis = RequestedLabAnalysis.getByObjectid(bloodgift.getTransactionId(), MedwanQuery.getInstance().getConfigString("cntsRhesusCode","Rh"));
        	if(analysis!=null){
        		rhesus=analysis.getResultValue().trim();
        		abo+=rhesus.replaceAll("\\+", "");
        	}
		}
		if(!bRejected){
			String expirydate=bloodgift.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_EXPIRYDATE");
			if(expirydate.length()==10){
				try{
					java.util.Date expdate = ScreenHelper.parseDate(expirydate);
					if(expdate.after(new java.util.Date())){
						if(!sRefABO.equalsIgnoreCase(abo)){
						%>
							<tr>
								<td class='admin'><%=bloodgift.getTransactionId()%></td>
								<td class='admin2'><%=ScreenHelper.stdDateFormat.format(expdate) %></td>
								<td class='admin2'><img src='<c:url value="/_img/icons/icon_error.gif"/>'/><font style='font-size: 14px;font-weight: bold;color:red'><%=bloodgroup+rhesus %></font></td>
							</tr>
						<%
						}
						else {
						%>
							<tr>
								<td class='admin'><a href="javascript:selectbatch('<%=bloodgift.getTransactionId()%>','<%=ScreenHelper.stdDateFormat.format(expdate)%>','<%=nPockets %>')"><%=bloodgift.getTransactionId()%></a></td>
								<td class='admin2'><%=ScreenHelper.stdDateFormat.format(expdate) %></td>
								<td class='admin2'># <%=nPockets %></td>
							</tr>
						<%
						}
					}
				}
				catch(Exception e){}
			}
		}
	}
%>
</table>
<input type='button' class='button' value='<%=getTranNoLink("web","close",sWebLanguage)%>' onclick='window.close();'/>
<script>
	function selectbatch(number,enddate,maxquantity){
		if(window.opener.<%=sReturnNumber%>){
			window.opener.<%=sReturnNumber%>.value=number;
		}
		if(window.opener.<%=sReturnEnd%>){
			window.opener.<%=sReturnEnd%>.value=enddate;
		}
		if(window.opener.<%=sReturnQuantity%> && window.opener.<%=sReturnQuantity%>.value*1>maxquantity*1){
			window.opener.<%=sReturnQuantity%>.value=maxquantity;
		}
		window.close();
	}
</script>