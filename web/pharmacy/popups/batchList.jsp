<%@ page import="be.openclinic.pharmacy.ServiceStock,
                 be.openclinic.pharmacy.Batch,
                 java.util.Vector,
                 be.mxs.common.util.system.HTMLEntities" %>
<%@ page import="be.openclinic.pharmacy.ProductStock" %>
<%@ page errorPage="/includes/error.jsp" %>
<%@ include file="/includes/validateUser.jsp" %>
<form name="transactionForm" id="transactionForm" method="post">
	<%
		String productStockUid=checkString(request.getParameter("EditProductStockUid"));
		ProductStock productStock=ProductStock.get(productStockUid);
		Vector batches = Batch.getAllBatches(productStockUid);
		StringBuffer sActiveBatches = new StringBuffer();
		StringBuffer sExpiredBatches = new StringBuffer();
		StringBuffer sUsedBatches = new StringBuffer();
		int totalStock=productStock.getLevel();
		int totalActive=0;
		int totalUsed=0;
		int totalExpired=0;
		for(int n=0;n<batches.size();n++){
			Batch batch = (Batch)batches.elementAt(n);
			if(batch!=null){
				if(batch.getLevel()>0 && (batch.getEnd()==null || !batch.getEnd().before(new java.util.Date()))){
					sActiveBatches.append("<tr><td class='admin2'>");
					if(activeUser.getAccessRight("pharmacy.modifybatch.select")){
						sActiveBatches.append("<img src='"+sCONTEXTPATH+"/_img/icons/icon_edit.png' onclick='editbatch(\""+batch.getUid()+"\")'/>");
					}
					sActiveBatches.append("<a href='javascript:showBatchOperations(\""+batch.getUid()+"\");'>"+batch.getBatchNumber()+"</a></td><td class='admin2right'>"+batch.getLevel()+"</td><td class='admin2'>"+(batch.getEnd()==null?"":ScreenHelper.formatDate(batch.getEnd()))+"</td><td class='admin2'>"+SH.c(batch.getComment())+"</td></tr>");
					totalActive+=batch.getLevel();
				}
				else if(batch.getLevel()<=0){
					sUsedBatches.append("<tr><td class='admin2'>");
					if(activeUser.getAccessRight("pharmacy.modifybatch.select")){
						sUsedBatches.append("<img src='"+sCONTEXTPATH+"/_img/icons/icon_edit.png' onclick='editbatch(\""+batch.getUid()+"\")'/>");
					}
					sUsedBatches.append("<a href='javascript:showBatchOperations(\""+batch.getUid()+"\");'>"+batch.getBatchNumber()+"</a></td><td class='admin2right'>"+batch.getLevel()+"</td><td class='admin2'>"+(batch.getEnd()==null?"":ScreenHelper.formatDate(batch.getEnd()))+"</td><td class='admin2'>"+SH.c(batch.getComment())+"</td></tr>");
					totalUsed+=batch.getLevel();
				}
				else {
					sExpiredBatches.append("<tr><td class='admin2'>");
					if(activeUser.getAccessRight("pharmacy.modifybatch.select")){
						sExpiredBatches.append("<img src='"+sCONTEXTPATH+"/_img/icons/icon_edit.png' onclick='editbatch(\""+batch.getUid()+"\")'/>");
					}
					sExpiredBatches.append("<a href='javascript:showBatchOperations(\""+batch.getUid()+"\");'>"+batch.getBatchNumber()+"</a></td><td class='admin2right'>"+batch.getLevel()+"</td><td class='admin2'>"+(batch.getEnd()==null?"":ScreenHelper.formatDate(batch.getEnd()))+"</td><td class='admin2'>"+SH.c(batch.getComment())+"</td></tr>");
					totalExpired+=batch.getLevel();
				}
				totalStock-=batch.getLevel();
			}
		}
		if(totalActive>0){
			out.println(getTran(request,"web","active.batches",sWebLanguage)+":");
			out.println("<table width='100%'><tr class='admin'><th>"+getTran(request,"web","batchnumber",sWebLanguage)+"</th><th>"+getTran(request,"web","level",sWebLanguage)+"</th><th>"+
					getTran(request,"web","expires",sWebLanguage)+"</th><th>"+getTran(request,"web","comment",sWebLanguage)+"</th></tr>");
			out.println(sActiveBatches.toString());
			out.println("<tr><td class='admin2'><i>?</i></td><td class='admin2right'><i>"+totalStock+"</i></td></tr>");
			out.println("<tr><td>"+getTran(request,"web","total",sWebLanguage)+"</td><td class='admin2right'><b>"+(totalActive+totalStock)+"</b></td></tr>");
			out.println("</table><hr/>");
		}
		if(totalStock>0){
			//There is remaining unbatched stock
			out.println(getTran(request,"web","unbatched.stock",sWebLanguage)+":");
			if(activeUser.getAccessRight("pharmacy.modifybatchoperations.select")){
				out.println("<table width='100%'><tr><td class='admin2'>"+getTran(request,"web","total",sWebLanguage)+"</td><td class='admin2right'><b><a href='javascript:createBatch(\""+productStockUid+"\")'>"+totalStock+"</a></b></td></tr>");
			}
			else{
				out.println("<table width='100%'><tr><td class='admin2'>"+getTran(request,"web","total",sWebLanguage)+"</td><td class='admin2right'><b>"+totalStock+"</b></td></tr>");
			}
			out.println("</table><hr/>");
		}
		if(sExpiredBatches.length()>0){
			out.println("<font color='red'><b>"+getTran(request,"web","expired.batches",sWebLanguage)+"</b></font>:");
			out.println("<table width='100%'><tr class='admin'><th>"+getTran(request,"web","batchnumber",sWebLanguage)+"</th><th>"+getTran(request,"web","level",sWebLanguage)+"</th><th>"+
					getTran(request,"web","expires",sWebLanguage)+"</th><th>"+getTran(request,"web","comment",sWebLanguage)+"</th></tr>");
			out.println(sExpiredBatches.toString());
			out.println("<tr><td>"+getTran(request,"web","total",sWebLanguage)+"</td><td class='admin2right'><b>"+totalExpired+"</b></td></tr>");
			out.println("</table><hr/>");
		}
		if(request.getParameter("showused")!=null && sUsedBatches.length()>0){
			out.println(getTran(request,"web","used.batches",sWebLanguage)+":");
			out.println("<table width='100%'><tr class='admin'><th>"+getTran(request,"web","batchnumber",sWebLanguage)+"</th><th>"+getTran(request,"web","level",sWebLanguage)+"</th><th>"+
					getTran(request,"web","expires",sWebLanguage)+"</th><th>"+getTran(request,"web","comment",sWebLanguage)+"</th></tr>");
			out.println(sUsedBatches.toString());
			if(totalUsed!=0){
				out.println("<tr><td>"+getTran(request,"web","total",sWebLanguage)+"</td><td class='admin2right'><b>"+totalUsed+"</b></td></tr>");
			}
			out.println("</table><hr/>");
		}
		else if (sUsedBatches.length()>0){
			out.println("<a href='javascript:showUsedBatches();'/>"+getTran(request,"web","show.used",sWebLanguage)+"</a>");
		}
	%>
	<input type='hidden' name='showused' id='showused' value=''/>	
</form>
<script>
	function showUsedBatches(){
		document.getElementById("showused").value="true";
		document.getElementById("transactionForm").submit();
	}

	function editbatch(batchUid){
	    openPopup("pharmacy/popups/batchedit.jsp&batchUid="+batchUid+"&productStockUid=<%=productStockUid%>&ts=<%=getTs()%>",10,60);
	}

	function showBatchOperations(batchUid){
	    openPopup("pharmacy/popups/batchOperationList.jsp&batchUid="+batchUid+"&productStockUid=<%=productStockUid%>&ts=<%=getTs()%>",800,400);
	}
	
	function refreshlist(){
		transactionForm.submit();
	}
	  function createBatch(productstockuid){
		    openPopup("pharmacy/popups/createBatch.jsp&productStockUid="+productstockuid+"&ts=<%=getTs()%>",400,300);
		  }
</script>
