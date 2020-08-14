<%@include file="/includes/validateUser.jsp"%>
<%
	String serverid=SH.c(request.getParameter("serverid"));
	String transactionid=SH.c(request.getParameter("transactionid"));
	Vector<TransactionVO> pacstrans = MedwanQuery.getInstance().getTransactionsByType(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_PACS");
	String studies="",series="";
	for(int n=0;n<pacstrans.size();n++){
		TransactionVO tran = pacstrans.elementAt(n);
		String orderuid = tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_ORDERUID");
		if(orderuid.equalsIgnoreCase(serverid+"."+transactionid)){
			if(n>0){
				studies+="_";
				series+="_";
			}
			studies+=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID");
			series+=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID");
		}
	}
	for(int n=0;n<pacstrans.size();n++){
		TransactionVO tran = pacstrans.elementAt(n);
		String orderuid = tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_ORDERUID");
		if(orderuid.equalsIgnoreCase(serverid+"."+transactionid)){
			//This study is linked to the Imaging request. Show the thumbnail
			%>
				<img onclick='view("<%=studies%>","<%=series%>");' id='i_<%=n%>' onerror='window.setTimeout("loadunknownimage(\"i_<%=n%>\")",100);document.getElementById("img_<%=n%>").style.display="none";' style='max-width: 60px; max-height:60px;' src='<%=sCONTEXTPATH %>/pacs/getDICOMJpeg.jsp?excludeFromFilter=1&uid=<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>;<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID") %>'/>
			<%
		}
	}
%>