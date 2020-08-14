<%@page import="be.openclinic.finance.*"%>
<%@page import="be.openclinic.pharmacy.*,be.mxs.common.util.system.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String productionOrderId = request.getParameter("productionOrderId");
	ProductionOrder order = ProductionOrder.get(Integer.parseInt(productionOrderId));
	Hashtable productstocks = new Hashtable();
	//First we summarize the information for this production order
	if(order!=null){
		Vector materials = order.getMaterials();
		for(int n=0;n<materials.size();n++){
			ProductionOrderMaterial material = (ProductionOrderMaterial)materials.elementAt(n);
			ProductStock productStock = ProductStock.get(material.getProductStockUid());
			if(productStock!=null && productStock.hasValidUid()){
				if(productstocks.get(productStock.getUid())==null){
					productstocks.put(productStock.getUid(),material.getQuantity());
				}
				else{
					productstocks.put(productStock.getUid(),material.getQuantity()+(Double)productstocks.get(productStock.getUid()));
				}
			}
		}
	}
	if(productstocks.size()>0){
		//Set header
		out.println("<table width='100%' style='border: 2px solid black;'>");
		out.println("<tr>");
		out.println("<td class='admin'>"+ScreenHelper.getTran(request,"web","product",sWebLanguage)+"</td>");
		out.println("<td class='admin'>"+ScreenHelper.getTran(request,"web","servicestock",sWebLanguage)+"</td>");
		out.println("<td class='admin'>"+ScreenHelper.getTran(request,"web","quantity",sWebLanguage)+"</td>");
		out.println("<td class='admin'>"+ScreenHelper.getTran(request,"web","unit",sWebLanguage)+"</td>");
		if(order.getCloseDateTime()==null){
			out.println("<td class='admin'>"+ScreenHelper.getTran(request,"web","available",sWebLanguage)+"</td>");
			if(MedwanQuery.getInstance().getConfigInt("enableCCBRTProductionOrderMecanism",0)==1 ){
				out.println("<td class='admin'>"+ScreenHelper.getTran(request,"web","linked",sWebLanguage)+"</td>");
			}
		}
		out.println("</tr>");
		ProductStock targetProductStock = ProductStock.get(order.getTargetProductStockUid());
		Enumeration eProducts = productstocks.keys();
		while(eProducts.hasMoreElements()){
			String key = (String)eProducts.nextElement();
			ProductStock productStock = ProductStock.get(key);
			String productunit=productStock.getProduct().getPackageUnits()+" "+ getTran(request,"product.unit",productStock.getProduct().getUnit(),sWebLanguage);
			double nQuantity=(Double)productstocks.get(key);
			if(nQuantity==0){
				continue;
			}
			out.println("<tr>");
			out.println("<td class='admin2'><b>"+productStock.getProduct().getName()+"</b></td>");
			out.println("<td class='admin2'>"+productStock.getServiceStock().getName()+"</td>");
			out.println("<td class='admin2'>"+nQuantity+"</td>");
			out.println("<td class='admin2'>"+productunit+"</td>");
			if(order.getCloseDateTime()==null){
				out.println("<td class='admin2'>"+productStock.getLevel()+"</td>");
				if(MedwanQuery.getInstance().getConfigInt("enableCCBRTProductionOrderMecanism",0)==1){
					int nLinked=productStock.getReceivedForProductionOrder(productionOrderId);
					out.println("<td class='admin2'>"+nLinked+(Pointer.getPointer("nowarehouseorder."+targetProductStock.getProductUid()).length()>0 || nQuantity<=nLinked?"":" <img height='12px' src='"+sCONTEXTPATH+"/_img/icons/icon_forbidden.png' title='"+getTranNoLink("web","linkedquantitytoolow",sWebLanguage)+"'/>")+"</td>");
				}
			}
			out.println("</tr>");
		}
		out.println("</table><br/>");
		Vector materials = order.getMaterials();
		if(materials.size()>0){
			//Set header
			out.println("<table width='100%'>");
			out.println("<tr>");
			out.println("<td class='admin'>"+ScreenHelper.getTran(request,"web","date",sWebLanguage)+"</td>");
			out.println("<td class='admin'>"+ScreenHelper.getTran(request,"web","product",sWebLanguage)+"</td>");
			out.println("<td class='admin'>"+ScreenHelper.getTran(request,"web","quantity",sWebLanguage)+"</td>");
			out.println("<td class='admin'>"+ScreenHelper.getTran(request,"web","unit",sWebLanguage)+"</td>");
			out.println("<td class='admin'>"+ScreenHelper.getTran(request,"web","comment",sWebLanguage)+"</td>");
			out.println("</tr>");
			for(int n=0;n<materials.size();n++){
				ProductionOrderMaterial material = (ProductionOrderMaterial)materials.elementAt(n);
				String productname="?",productunit="?";
				ProductStock productStock = ProductStock.get(material.getProductStockUid());
				if(productStock!=null && productStock.getProduct()!=null){
					productname=productStock.getProduct().getName();
					productunit=productStock.getProduct().getPackageUnits()+" "+ getTran(request,"product.unit",productStock.getProduct().getUnit(),sWebLanguage);
				}
				out.println("<tr>");
				out.println("<td class='admin2'>"+ScreenHelper.formatDate(material.getCreateDateTime())+"</td>");
				out.println("<td class='admin2'>"+productname+"</td>");
				out.println("<td class='admin2'>"+material.getQuantity()+"</td>");
				out.println("<td class='admin2'>"+productunit+"</td>");
				out.println("<td class='admin2'>"+checkString(material.getComment())+"</td>");
				out.println("</tr>");
			}
			out.println("</table>");
		}
	}
%>
</table>
