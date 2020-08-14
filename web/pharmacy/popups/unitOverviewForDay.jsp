<%@page import="be.openclinic.pharmacy.OperationDocument"%>
<%@page import="be.openclinic.pharmacy.ProductStock,
                be.openclinic.pharmacy.ProductStockOperation,
                be.openclinic.pharmacy.ServiceStock,
                java.util.Vector"%>
<%@include file="/_common/templateAddIns.jsp"%>

<%
    String date = checkString(request.getParameter("date"));
    java.util.Date dDate = ScreenHelper.parseDate(date);
    
    String sProductStockId = checkString(request.getParameter("productStockUid"));
    ProductStock productStock = ProductStock.get(sProductStockId);
    
    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("***************** pharmacy/popups/unitOverviewForDay.jsp ****************");
        Debug.println("date            : "+date);
        Debug.println("sProductStockId : "+sProductStockId+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
%>

<%=writeTableHeader("Web.manage","unitOverviewForDay",sWebLanguage," window.close();")%>
<table width="100%" cellspacing="1" cellpadding="0" class="list">    
    <%-- DAY --%>
    <tr>
        <td class="admin" width="<%=sTDAdminWidth%>">&nbsp;<%=getTran(request,"web","day",sWebLanguage)%></td>
        <td class="admin2"><%=date%></td>
    </tr>
    <%-- SERVICE STOCK --%>
    <tr>
        <td class="admin">&nbsp;<%=getTran(request,"web","serviceStock",sWebLanguage)%></td>
        <td class="admin2"><%=productStock.getServiceStock().getName()%></td>
    </tr>
    <%-- PRODUCT STOCK --%>
    <tr>
        <td class="admin">&nbsp;<%=getTran(request,"web","productStock",sWebLanguage)%></td>
        <td class="admin2"><%=productStock.getProduct().getName()%></td>
    </tr>
</table>
<br>

<div class="search" style="width:100%;height:300px;">
<table width="100%" cellspacing="1" cellpadding="0" class="list">
    <%-- HEADER --%>
    <tr class='admin'>
        <td><%=getTran(request,"web","type",sWebLanguage)%></td>
        <td><%=getTran(request,"web","quantity",sWebLanguage)%></td>
        <td><%=getTran(request,"web","batch",sWebLanguage)%></td>
        <td><%=getTran(request,"web","source",sWebLanguage)%>/<%=getTran(request,"web","destination",sWebLanguage)%></td>
        <td><%=getTran(request,"web","user",sWebLanguage)%></td>
    </tr>
    
<%
    Vector operations = ProductStockOperation.searchProductStockOperations("","",date,productStock.getUid(),"","OC_OPERATION_OBJECTID");
    for(int n=0; n<operations.size(); n++){
        ProductStockOperation operation = (ProductStockOperation) operations.elementAt(n);
        ObjectReference sourceDestination = operation.getSourceDestination();
        String sd = "", username = "", sOperation = "", sBatch="";
        UserVO user = MedwanQuery.getInstance().getUser(operation.getUpdateUser());
        if(user!=null){
            username = user.getPersonVO().getFullName();
        }
        
        if(sourceDestination!=null){
            if(sourceDestination.getObjectType().equalsIgnoreCase("patient")){
                AdminPerson patient = AdminPerson.getAdminPerson(sourceDestination.getObjectUid());
                sd = patient.personid+": "+patient.firstname+" "+patient.lastname;
            }
            else if(sourceDestination.getObjectType().equalsIgnoreCase("servicestock") ||
            		sourceDestination.getObjectType().equalsIgnoreCase("service")){
                ServiceStock serviceStock = ServiceStock.get(sourceDestination.getObjectUid());
                if(serviceStock!=null){
                	sd = serviceStock.getName();
                }
	        }
            else if(sourceDestination.getObjectType().equalsIgnoreCase("supplier")){
	            sd = sourceDestination.getObjectUid();
	            if(sd.length()==0){
	            	OperationDocument doc = OperationDocument.get(operation.getDocumentUID());
	            	if(doc!=null && doc.getSourceName(sWebLanguage)!=null){
	            		sd=doc.getSourceName(sWebLanguage);
	            	}
	            }
	        }
            else if(sourceDestination.getObjectType().equalsIgnoreCase("production")){
	            sd = getTran(request,"web","productionorder",sWebLanguage)+" #"+sourceDestination.getObjectUid();
	        }
        }

        String movement = "", sClass = "";
        
        //*** patient ***
        if(operation.getSourceDestination()!=null && operation.getSourceDestination().getObjectType().equalsIgnoreCase("patient")){
            if(operation.getDescription().indexOf("receipt") > -1){
                movement = "+";
                sClass = "list";
                sOperation = getTran(request,"productstockoperation.medicationreceipt",operation.getDescription(),sWebLanguage);
                if(checkString(operation.getReceiveComment()).length()>0 || checkString(operation.getComment()).length()>0){
                	sOperation+= " ("+(checkString(operation.getReceiveComment())+" "+checkString(operation.getComment())).trim()+")";
                }
            }
            else if(operation.getDescription().indexOf("delivery") > -1){
                movement = "-";
                sClass = "list1";
                sOperation = getTran(request,"productstockoperation.medicationdelivery",operation.getDescription(),sWebLanguage);
                if(checkString(operation.getReceiveComment()).length()>0 || checkString(operation.getComment()).length()>0){
                	sOperation+= " ("+(checkString(operation.getReceiveComment())+" "+checkString(operation.getComment())).trim()+")";
                }
            }
        } 
        //*** service stock ***
        else if(operation.getSourceDestination()!=null && operation.getSourceDestination().getObjectType().equalsIgnoreCase("servicestock")){
            if(operation.getDescription().indexOf("receipt") > -1 || operation.getDescription().indexOf("correctionin") > -1){
                movement = "+";
                sClass = "list";
                sOperation=getTran(request,"productstockoperation.medicationreceipt", operation.getDescription(), sWebLanguage);
                if(checkString(operation.getReceiveComment()).length()>0 || checkString(operation.getComment()).length()>0){
                	sOperation+= " ("+(checkString(operation.getReceiveComment())+" "+checkString(operation.getComment())).trim()+")";
                }
            } 
            else if(operation.getDescription().indexOf("delivery") > -1 || operation.getDescription().indexOf("correctionout") > -1){
                movement = "-";
                sClass = "list1";
                sOperation = getTran(request,"productstockoperation.medicationdelivery", operation.getDescription(),sWebLanguage);
                if(checkString(operation.getReceiveComment()).length()>0 || checkString(operation.getComment()).length()>0){
                	sOperation+= " ("+(checkString(operation.getReceiveComment())+" "+checkString(operation.getComment())).trim()+")";
                }
            }
        }
        //*** correction in ***
        else{
            if(operation.getDescription().indexOf("receipt") > -1 || operation.getDescription().indexOf("correctionin") > -1){
                movement = "+";
                sClass = "list";
                sOperation = getTran(request,"productstockoperation.medicationreceipt",operation.getDescription(),sWebLanguage);
                if(checkString(operation.getReceiveComment()).length()>0 || checkString(operation.getComment()).length()>0){
                	sOperation+= " ("+(checkString(operation.getReceiveComment())+" "+checkString(operation.getComment())).trim()+")";
                }
            }
            else if(operation.getDescription().indexOf("delivery") > -1 || operation.getDescription().indexOf("correctionout") > -1){
                movement = "-";
                sClass = "list1";
                sOperation = getTran(request,"productstockoperation.medicationdelivery",operation.getDescription(),sWebLanguage);
                if(checkString(operation.getReceiveComment()).length()>0 || checkString(operation.getComment()).length()>0){
                	sOperation+= " ("+(checkString(operation.getReceiveComment())+" "+checkString(operation.getComment())).trim()+")";
                }
            }
        }
        if(checkString(operation.getBatchNumber()).length()>0){
        	sBatch=operation.getBatchNumber();
        }
        else{
        	sBatch="?";
        }
        
		%>
	    <tr class="<%=sClass%>">
	        <td><%=sOperation%></td>
	        <td><%=(movement+operation.getUnitsChanged()).replaceAll("--","+")%></td>
	        <%	if(activeUser.getAccessRightNoSA("pharmacy.modifybatchoperations.select")){ %>
	        	<td><a href="javascript:correctBatch('<%=operation.getUid()%>');"><%=sBatch%></a></td>
			<%	}
	        	else{
	        %>	        	
		        <td><b><%=sBatch%></b></td>
		    <%	} %>
	        <td><b><%=sd%></b></td>
	        <td><%=username%></td>
	    </tr>
        <%
    }
%>
</table>
</div>

<script>
  <%-- SHOW UNITS FOR DAY --%>
  function showOperation(operationuid){
	    openPopup("pharmacy/manageProductStockOperations.jsp&Action=find&EditOperationUid="+operationuid+"&ts=<%=getTs()%>",700,400);
	  }
  function correctBatch(operationuid){
	    openPopup("pharmacy/popups/correctBatch.jsp&OperationUid="+operationuid+"&ts=<%=getTs()%>",400,300);
	  }
</script>