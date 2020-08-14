<%=sCANVAS %>
<script>
    <!-- Initialize canvas -->
    if(transactionId<0){
		context = initCanvas('canvasDiv',100,100,'<c:url value='/_img/mammae.png'/>');
	}else{}
		context = initCanvas('canvasDiv',100,100,'<%=ScreenHelper.getDrawing(((TransactionVO)transaction).getServerId(),((TransactionVO)transaction).getTransactionId(),"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OCDRAWING")%>');
	}
</script>