<%@page import="be.openclinic.pharmacy.*,
                be.openclinic.medical.Prescription,
                java.util.Vector,be.mxs.common.util.system.*,
                be.openclinic.pharmacy.ProductOrder"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String personid=checkString(request.getParameter("personid"));
	String productstockuid=request.getParameter("productstockuid");
	String totalBatches="";
	//First find all active batches for this product stock
	Vector batches = Batch.getBatches(productstockuid);
	if(personid.length()>0){
		Vector bloodgifts = MedwanQuery.getInstance().getTransactionsByType(Integer.parseInt(personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_CNTS_BLOODGIFT");
		for(int n=0;n<bloodgifts.size();n++){
			TransactionVO bloodgift = (TransactionVO)bloodgifts.elementAt(n);
			//Check if there is quantity available for this batchnumber in this productstock
			for(int i=0;i<batches.size();i++){
				Batch batch = (Batch)batches.elementAt(i);
				if(checkString(batch.getBatchNumber()).startsWith(bloodgift.getTransactionId()+".")){
					//Yes we have a match, add it to the available batches
					totalBatches+= productstockuid+"$"+batch.getUid()+";"+batch.getBatchNumber()+";"+batch.getLevel()+";"+(batch.getEnd()==null?"":ScreenHelper.stdDateFormat.format(batch.getEnd()))+";"+batch.getComment()+";";
				}
			}
		}
	}
	else {
		for(int i=0;i<batches.size();i++){
			Batch batch = (Batch)batches.elementAt(i);
			totalBatches+= productstockuid+"$"+batch.getUid()+";"+batch.getBatchNumber()+";"+batch.getLevel()+";"+(batch.getEnd()==null?"":ScreenHelper.stdDateFormat.format(batch.getEnd()))+";"+batch.getComment()+";";
		}
	}
%>
{
"batches":"<%=totalBatches%>"
}