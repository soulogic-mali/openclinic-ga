<%@page import="java.util.*,be.openclinic.pharmacy.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"pharmacy","select",activeUser)%>
<%=sJSSORTTABLE%>

<%
    //*** DELETE ******************************************
	if(request.getParameter("deleteoperation")!=null){
		ProductStockOperation operation = ProductStockOperation.get(request.getParameter("deleteoperation"));
		if(operation!=null){
			ProductStock productStock = operation.getProductStock();
			String batchuid=operation.getBatchUid();
			operation.delete(request.getParameter("deleteoperation"));
			if(batchuid!=null){
				Batch.calculateBatchLevel(batchuid);
			}
			productStock.setLevel(productStock.getLevel(new java.util.Date()));
			productStock.store();
		}
	}

if(request.getParameter("modifydateoperation")!=null){
	ProductStockOperation operation = ProductStockOperation.get(request.getParameter("modifydateoperation").split(";")[0]);
	if(operation!=null){
		try{
			operation.setDate(ScreenHelper.getSQLDate(request.getParameter("modifydateoperation").split(";")[1]));
			operation.store();
		}
		catch(Exception e){
			
		}
	}
}

if(request.getParameter("modifyquantityoperation")!=null){
	ProductStockOperation operation = ProductStockOperation.get(request.getParameter("modifyquantityoperation").split(";")[0]);
	if(operation!=null){
		try{
			ProductStock productStock = operation.getProductStock();
			operation.setUnitsChanged(Math.abs(Integer.parseInt(request.getParameter("modifyquantityoperation").split(";")[1])));
			operation.store();
			productStock.setLevel(productStock.getLevel(new java.util.Date()));
			productStock.store();
		}
		catch(Exception e){
			
		}
	}
}

    // expiry date
	long hour = 1000*3600;
	long n3months = hour*24*92;
	
	String sExpiryDate = ScreenHelper.formatDate(new java.util.Date(new java.util.Date().getTime()-n3months));
	String sBeforeDate = ScreenHelper.formatDate(new java.util.Date(new java.util.Date().getTime()));
	Encounter er = Encounter.getActiveEncounter(activePatient.personid);
	if(er!=null && er.getBegin()!=null){
		sExpiryDate = ScreenHelper.formatDate(new java.util.Date(er.getBegin().getTime()-(24*hour)));
	}
	if(request.getParameter("search")!=null){
		sExpiryDate = request.getParameter("expirydate");
		sBeforeDate = request.getParameter("beforedate");
	}
	
	/// DEBUG /////////////////////////////////////////////////////////////////////////////////////
	if(Debug.enabled){
		Debug.println("\n********************* pharmacy/patientDeliveries.jsp ******************");
		Debug.println("sExpiryDate : "+sExpiryDate+"\n");
	}
	///////////////////////////////////////////////////////////////////////////////////////////////
%>
<form name="transactionForm" id="transactionForm" method="post">
	<table width="100%" class="list" cellpadding="0" cellspacing="1">
	    <%-- TITLE --%>
	    <tr class="gray">
	        <td colspan="2"><%=getTranNoLink("web","patientDrugDeliveries",sWebLanguage)%></td>
	    </tr>
	    
		<tr>
		    <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","deliveries.between",sWebLanguage)%></td>
		    <td class="admin2"><%=writeDateField("expirydate","transactionForm",sExpiryDate,sWebLanguage)%>
		    &nbsp;&nbsp;<%=getTran(request,"web","and",sWebLanguage) %>&nbsp;&nbsp;
		    <%=writeDateField("beforedate","transactionForm",sBeforeDate,sWebLanguage)%></td>
		</tr>
		
		<%-- BUTTONS --%>
		<tr>
		    <td class="admin">&nbsp;</td>
		    <td class="admin2"><input type="submit" class="button" name="search" value="<%=getTranNoLink("web","find",sWebLanguage)%>"/></td>
		</tr>
	</table>
	<input type='hidden' name='deleteoperation' id='deleteoperation' value=''/>
	<input type='hidden' name='modifydateoperation' id='modifydateoperation' value=''/>
	<input type='hidden' name='modifyquantityoperation' id='modifyquantityoperation' value=''/>
</form>
	
<%
    int recCount = 0;
	long day = 24*3600*1000;

	try{
		java.util.Date dDate = ScreenHelper.parseDate(sExpiryDate);
		java.util.Date dDate2 = ScreenHelper.parseDate(sBeforeDate);
		String sQuery = " select oc_stock_productuid,sum(quantity) quantity from ("+
						" select oc_operation_objectid,c.oc_stock_name,oc_stock_productuid,oc_operation_unitschanged quantity from oc_productstockoperations a,oc_productstocks b,oc_servicestocks c"+
		                " where oc_operation_srcdesttype='patient'"+
		                "  and oc_operation_date>?"+
		                "  and oc_operation_date<=?"+
		                "  and oc_operation_description like '%delivery%'"+
		                "  and oc_operation_srcdestuid=?"+
		                "  and b.oc_stock_objectid=replace(a.oc_operation_productstockuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','')"+
		                "  and c.oc_stock_objectid=replace(b.oc_stock_servicestockuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','')"+
		                " union"+
		                " select oc_operation_objectid,c.oc_stock_name,oc_stock_productuid,-oc_operation_unitschanged quantity from oc_productstockoperations a,oc_productstocks b,oc_servicestocks c"+
		                " where oc_operation_srcdesttype='patient'"+
		                "  and oc_operation_date>?"+
		                "  and oc_operation_date<=?"+
		                "  and oc_operation_description like '%receipt%'"+
		                "  and oc_operation_srcdestuid=?"+
		                "  and b.oc_stock_objectid=replace(a.oc_operation_productstockuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','')"+
		                "  and c.oc_stock_objectid=replace(b.oc_stock_servicestockuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','')) q"+
		                " group by oc_stock_productuid";
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement(sQuery);
		ps.setDate(1,new java.sql.Date(dDate.getTime()));
		ps.setTimestamp(2,new java.sql.Timestamp(dDate2.getTime()+day-1));
		ps.setString(3,activePatient.personid);
		ps.setDate(4,new java.sql.Date(dDate.getTime()));
		ps.setTimestamp(5,new java.sql.Timestamp(dDate2.getTime()+day-1));
		ps.setString(6,activePatient.personid);
		
		ResultSet rs = ps.executeQuery();
		%>			
			<table width="100%" class="sortable" id="searchresultssummary" cellpadding="0" cellspacing="1">    
			    <%-- HEADER --%>
				<tr class='admin'>
					<td width="150"><%=getTran(request,"web","productstock",sWebLanguage)%></td>
					<td width="100"><%=getTran(request,"web","quantity",sWebLanguage)%></td>
					<td width="100"><%=getTran(request,"web","packageunits",sWebLanguage)%></td>
				</tr>
        <%

		Product product;
		String sClass = "1";
		
		while(rs.next()){
			product = Product.get(rs.getString("oc_stock_productuid"));
			if(product!=null){
				// alternate row-style
				if(sClass.length()==0) sClass = "1";
				else                   sClass = ""; 
				
				out.print("<tr class='list"+sClass+"'>"+
			               "<td>"+product.getName()+"</td>"+
			               "<td>"+rs.getInt("quantity")+"</td>"+
			               "<td>"+product.getPackageUnits()+" "+getTran(request,"product.unit",product.getUnit(),sWebLanguage)+"</td>"+
			              "</tr>");
				
				recCount++;
			}
		}
		
		rs.close();
		ps.close();
		conn.close();
		
		%>
               </table>
		<%
	}		
	catch(Exception e){
		e.printStackTrace();
	}
	
    if(recCount > 0){
        %><%=recCount%> <%=getTran(request,"web","recordsFound",sWebLanguage)%><%
    }
    else{
    	%><%=getTran(request,"web","noRecordsFound",sWebLanguage)%><%
    }
%>
<%
    recCount = 0;

	try{
		java.util.Date dDate = ScreenHelper.parseDate(sExpiryDate);
		java.util.Date dDate2 = ScreenHelper.parseDate(sBeforeDate);
		String sQuery = "select * from oc_productstockoperations"+
		                " where oc_operation_srcdesttype='patient'"+
		                "  and oc_operation_date>?"+
		                "  and oc_operation_date<=?"+
		                "  and oc_operation_srcdestuid=?"+
		                " order by oc_operation_date desc";
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement(sQuery);
		ps.setDate(1,new java.sql.Date(dDate.getTime()));
		ps.setTimestamp(2,new java.sql.Timestamp(dDate2.getTime()+day-1));
		ps.setString(3,activePatient.personid);
		
		ResultSet rs = ps.executeQuery();
		%>			
			<table width="100%" class="sortable" id="searchresults" cellpadding="0" cellspacing="1">    
			    <%-- HEADER --%>
				<tr class='admin'>
				    <td width="25">&nbsp;</td>
					<td><%=getTran(request,"web","date",sWebLanguage)%></td>
					<td><%=getTran(request,"web","servicestock",sWebLanguage)%></td>
					<td><%=getTran(request,"web","productstock",sWebLanguage)%></td>
					<td><%=getTran(request,"web","quantity",sWebLanguage)%></td>
					<td><%=getTran(request,"web","packageunits",sWebLanguage)%></td>
					<td><%=getTran(request,"web","batch.number",sWebLanguage)%></td>
					<td><%=getTran(request,"web","batch.expiration",sWebLanguage)%></td>
					<td><%=getTran(request,"web","comment",sWebLanguage)%></td>
				    <td>&nbsp;</td>
				</tr>
        <%

		ProductStockOperation operation;
		String sClass = "1";
		
		while(rs.next()){
			operation = ProductStockOperation.get(rs.getString("oc_operation_serverid")+"."+rs.getString("oc_operation_objectid"));
			if(operation!=null && operation.getProductStock()!=null && operation.getProductStock().getProduct()!=null){
				// alternate row-style
				if(sClass.length()==0) sClass = "1";
				else                   sClass = ""; 
				
				out.print("<tr class='list"+sClass+"'>"+
			               "<td>"+(operation.getUnitsChanged()!=0 && activeUser.getAccessRightNoSA("patient.modifypharmacydelivery.delete")?"<a href='javascript:cancelOperation(\""+operation.getUid()+"\");'><img src='"+sCONTEXTPATH+"/_img/icons/icon_erase.gif' class='link' title='"+getTranNoLink("web","cancel",sWebLanguage)+"'/></a>":"")+"</td>"+
			               (activeUser.getAccessRight("patient.modifypharmacydelivery.select")?
			            		   "<td><a href=\"javascript:modifydate('"+operation.getUid()+"','"+ScreenHelper.formatDate(operation.getDate())+"')\">"+ScreenHelper.formatDate(operation.getDate())+"</a></td>"
			            		   :"<td>"+ScreenHelper.formatDate(operation.getDate())+"</td>"
			               )+
			               "<td>"+operation.getProductStock().getServiceStock().getName()+"</td>"+
			               "<td>"+operation.getProductStock().getProduct().getName()+"</td>"+
			               (activeUser.getAccessRight("patient.modifypharmacydelivery.select")?
			            		   "<td><a href=\"javascript:modifyquantity('"+operation.getUid()+"',"+operation.getUnitsChanged()+")\">"+(operation.getDescription().indexOf("delivery")==-1?"-":"")+operation.getUnitsChanged()+"</a></td>"
			            		   :"<td>"+(operation.getDescription().indexOf("delivery")==-1?"-":"")+operation.getUnitsChanged()+"</td>"
			               )+
			               "<td>"+operation.getProductStock().getProduct().getPackageUnits()+" "+getTran(request,"product.unit",operation.getProductStock().getProduct().getUnit(),sWebLanguage)+"</td>"+
			               "<td>"+(operation.getBatchNumber()!=null?operation.getBatchNumber():"?")+"</td>"+
			               "<td>"+(operation.getBatchEnd()!=null?ScreenHelper.formatDate(operation.getBatchEnd()):"?")+"</td>"+
			               (operation.getDescription().equalsIgnoreCase("medicationdelivery.1") && (operation.getPrescription()==null || operation.getPrescription().getDeliveredQuantity()>0)?
			               "<td>"+checkString(operation.getComment())+"</td>"+
			               "<td><input type='button' class='button' value='"+getTranNoLink("web","returnproduct",sWebLanguage)+"' onclick='returnProduct(\""+operation.getUid()+"\");'/> <input type='button' name='printItemButton' class='button' value='"+getTranNoLink("web","print",sWebLanguage)+"' onclick='printitem(\""+operation.getUid()+"\");'></td>":"<td/>")+
			              "</tr>");
				
				recCount++;
			}
		}
		rs.close();
		ps.close();
		conn.close();
		
		%>
               </table>
		<%
	}
	catch(Exception e){
		e.printStackTrace();
	}
	
    if(recCount > 0){
        %><%=recCount%> <%=getTran(request,"web","recordsFound",sWebLanguage)%><%
    }
    else{
    	%><%=getTran(request,"web","noRecordsFound",sWebLanguage)%><%
    }
%>

<%=ScreenHelper.alignButtonsStart()%>
    <input type="button" name="printButton" class="button" value="<%=getTranNoLink("web","print",sWebLanguage)%>" onclick="printlist();">
<%=ScreenHelper.alignButtonsStop()%>

<script>
	function printlist(){
		  window.open("<c:url value="pharmacy/printPatientDeliveries.jsp"/>?ts=<%=getTs()%>&offsetdate=<%=sExpiryDate%>");
	}
		
	function printitem(uid){
		  window.open("<c:url value="pharmacy/printPatientDeliveries.jsp"/>?ts=<%=getTs()%>&operation="+uid);
	}
		
  function cancelOperation(uid){
      if(yesnoDeleteDialog()){
      document.getElementById('deleteoperation').value = uid;
      document.transactionForm.submit();
    }
  }
  
  function modifydate(uid,date){
	  var d = prompt("<%=getTran(null,"web","date",sWebLanguage)%>",date);
	  document.getElementById('modifydateoperation').value=uid+";"+d;
	  if(date!=d){
	  	transactionForm.submit();
	  }
  }
  function modifyquantity(uid,quantity){
	  var d = prompt("<%=getTran(null,"web","quantity",sWebLanguage)%>",quantity);
	  document.getElementById('modifyquantityoperation').value=uid+";"+d;
	  if(quantity!=d){
		  transactionForm.submit();
	  }
  }
  
  function returnProduct(uid){
	  openPopup("pharmacy/medication/popups/receiveMedicationPopup.jsp&EditReferenceOperationUid="+uid+"&forcenew=1&ts=<%=getTs()%>",750,400);
  }
</script>