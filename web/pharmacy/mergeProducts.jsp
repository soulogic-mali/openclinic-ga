<%@page import="be.openclinic.pharmacy.*"%>
<%@page import="java.util.Vector"%>
<%@include file="/_common/templateAddIns.jsp"%>
<%!
	void updateId(String sql,String keepid,String deleteid){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps=conn.prepareStatement(sql);
			ps.setString(1, keepid);
			ps.setString(2, deleteid);
			ps.execute();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
%>
<form name='transactionForm' method='post'>
<%
	String sProductUid= request.getParameter("productUid");
	String sAction = checkString(request.getParameter("action"));
	Product product = Product.get(sProductUid);
	if(product!=null && sAction.equalsIgnoreCase("merge")){
		String sCode = product.getCode();
		//Now we look for all products that have the same code
		Vector products = Product.findWithCode(sCode, "", "", "", "", "", "", "", "", "OC_PRODUCT_CODE", "ASC");
		for(int n=0;n<products.size();n++){
			Product p = (Product)products.elementAt(n);
			if(!sProductUid.equalsIgnoreCase(p.getUid())){
				String sDeleteProductUid=p.getUid();
				updateId("update oc_productstocks set oc_stock_productuid=? where oc_stock_productuid=?",sProductUid,sDeleteProductUid);
				updateId("update OC_CHRONICMEDICATIONS set OC_CHRONICMED_PRODUCTUID=? where OC_CHRONICMED_PRODUCTUID=?",sProductUid,sDeleteProductUid);
				updateId("update OC_PRESCRIPTIONS set OC_PRESCR_PRODUCTUID=? where OC_PRESCR_PRODUCTUID=?",sProductUid,sDeleteProductUid);
				updateId("update OC_USERPRODUCTS set OC_PRODUCT_PRODUCTUID=? where OC_PRODUCT_PRODUCTUID=?",sProductUid,sDeleteProductUid);
				Product.moveToHistory(sDeleteProductUid);
			}
		}
		if(products.size()>1){
			ProductStock.mergeProducts();
		}
		out.println("<script>window.opener.location.reload();window.close();</script>");
		out.flush();
	}
	else if(product!=null){
		%>
		<%=getTran(request,"web","followingproductswillbemergedinto",sWebLanguage)+" <b>"+product.getUid()+" "+product.getName() %>:</b><p/>:
		<input type='hidden' name='action' id='action' value=''/>
		<table width='100%'>
		<%
		String sCode = product.getCode();
		Vector products = Product.findWithCode(sCode, "", "", "", "", "", "", "", "", "OC_PRODUCT_CODE", "ASC");
		for(int n=0;n<products.size();n++){
			Product p = (Product)products.elementAt(n);
			if(!sProductUid.equalsIgnoreCase(p.getUid())){
				out.println("<tr><td class='admin'>"+p.getUid()+"</td><td class='admin2'>"+p.getName()+"</td></tr>");
			}
		}
		%>
		</table>
		<center><input type='button' name='submitButton' value='<%=getTranNoLink("web","merge",sWebLanguage)%>' onclick='domerge()'/></center>
		<%
	}
%>
</form>
<script>
	function domerge(){
		if(window.confirm('<%=getTranNoLink("web","areyousure",sWebLanguage)%>')){
			document.getElementById("action").value="merge";
			transactionForm.submit();
		}
	}
</script>