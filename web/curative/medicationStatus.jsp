<%@page import="be.openclinic.medical.Prescription,
                be.openclinic.medical.ChronicMedication,
                be.openclinic.medical.PaperPrescription,
                be.openclinic.pharmacy.*,
                java.util.Vector"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<div id="patientmedicationsummary"/>
<table width="100%" class="list" height="100%" cellspacing="0" cellpadding="0">
    <tr class="admin">
    	<td colspan="1"><%=getTran(request,"curative","pharmacy.status.title",sWebLanguage)%></td>
    	<td colspan="3"><span id="interactionswarning">&nbsp;</span></td>
    </tr>
    <tr style="vertical-align:top;">
    <%
        Vector productionOrders = ProductionOrder.getProductionOrders(Integer.parseInt(activePatient.personid));
		//--- Open Production Orders ---//
    	Vector openOrders = new Vector();
    	for(int n=0;n<productionOrders.size();n++){
    		ProductionOrder order = (ProductionOrder)productionOrders.elementAt(n);
    		if(order.getCloseDateTime()==null){
    			openOrders.add(order);
    		}
    	}
    	if(openOrders.size()>0){
            %>
            <td class="admin2" style="border-bottom:1px solid #fff;"><b><%=getTran(request,"curative","medication.openproductionorders",sWebLanguage)%></b></td>
            <td>
                <table>
        <%
    	}
		for(int n=0;n<openOrders.size();n++){
			ProductionOrder productionOrder = (ProductionOrder)openOrders.elementAt(n);
			if(productionOrder.getProductStock()!=null && productionOrder.getProductStock().getProduct()!=null){
				String editTag="<td><a href='javascript:openProductionOrder("+productionOrder.getId()+")'><b>"+productionOrder.getProductStock().getProduct().getName()+"</b></a></td>";
				String noEditTag="<td><b>"+productionOrder.getProductStock().getProduct().getName()+"</b></td>";
				out.println("<tr><td>"+ScreenHelper.formatDate(productionOrder.getCreateDateTime())+"</td>"+(activeUser.getAccessRight("system.manageproductionorders.select")?editTag:noEditTag)+"</tr>");
			}
		}
        if(openOrders.size() > 0){
		    %>
		            </table>
		        </td></tr><tr style="vertical-align:top;">
		    <%
        }
        //--- Closed undelivered orders ---//
    	Vector undeliveredOrders = new Vector();
    	for(int n=0;n<productionOrders.size();n++){
    		ProductionOrder order = (ProductionOrder)productionOrders.elementAt(n);
    		if(order.getCloseDateTime()!=null && order.getProductStock()!=null){
    			//Now we check if this order has already been delivered
    			Vector deliveries = ProductStockOperation.getDeliveries(order.getProductStock().getUid(), activePatient.personid, ScreenHelper.parseDate(ScreenHelper.formatDate(order.getUpdateDateTime())), null, "OC_OPERATION_OBJECTID", "ASC");
    			if(deliveries.size()==0){
    				undeliveredOrders.add(order);
    			}
    		}
    	}
    	if(undeliveredOrders.size()>0){
            %>
            <td class="admin2" style="border-bottom:1px solid #fff;"><b><%=getTran(request,"curative","medication.undeliveredproductionorders",sWebLanguage)%></b></td>
            <td>
                <table>
        <%
    	}
		for(int n=0;n<undeliveredOrders.size();n++){
			ProductionOrder productionOrder = (ProductionOrder)undeliveredOrders.elementAt(n);
			if(productionOrder.getProductStock()!=null && productionOrder.getProductStock().getProduct()!=null){
				String deliverTag="<td onmouseover='this.style.cursor=\"hand\"' onmouseout='this.style.cursor=\"default\"'><img onclick='deliverOrder(\""+productionOrder.getProductStock().getUid()+"\",\""+productionOrder.getProductStock().getProduct().getName()+"\");' src='"+sCONTEXTPATH+"/_img/icons/icon_person.png"+"'/></td>";
				String editTag="<td><a href='javascript:openProductionOrder("+productionOrder.getId()+")'><b>"+productionOrder.getProductStock().getProduct().getName()+"</b></a></td>";
				String noEditTag="<td><b>"+productionOrder.getProductStock().getProduct().getName()+"</b></td>";
				out.println("<tr>"+(productionOrder.getProductStock().getServiceStock().isDispensingUser(activeUser.userid)?deliverTag:"")+"<td>"+ScreenHelper.formatDate(productionOrder.getCreateDateTime())+"</td>"+(activeUser.getAccessRight("system.manageproductionorders.select")?editTag:noEditTag)+"</tr>");
			}
		}
        if(undeliveredOrders.size() > 0){
		    %>
		            </table>
		        </td></tr><tr style="vertical-align:top;">
		    <%
        }
        //--- 1:CHRONIC ---------------------------------------------------------------------------
        String sProductUnit, timeUnitTran, sPrescrRule;
        Vector chronicMedications = ChronicMedication.find(activePatient.personid,"","","","OC_CHRONICMED_BEGIN","ASC");
        if(chronicMedications.size()>0){
            %>
                <td class="admin2" style="border-bottom:1px solid #fff;"><b><%=getTran(request,"curative","medication.chronic",sWebLanguage)%></b></td>
                <td>
                    <table>
            <%
        }
        
        ChronicMedication chronicMedication;
        for(int n=0; n<chronicMedications.size(); n++){
            chronicMedication = (ChronicMedication)chronicMedications.elementAt(n);
            
            sPrescrRule = getTran(request,"web.prescriptions","prescriptionrule",sWebLanguage);
            sPrescrRule = sPrescrRule.replaceAll("#unitspertimeunit#",chronicMedication.getUnitsPerTimeUnit()+"");

            // productunits
            if(chronicMedication.getUnitsPerTimeUnit()==1){
                sProductUnit = getTran(request,"product.unit",chronicMedication.getProduct().getUnit(),sWebLanguage);
            }
            else{
                sProductUnit = getTran(request,"product.unit",chronicMedication.getProduct().getUnit(),sWebLanguage);
            }
            sPrescrRule = sPrescrRule.replaceAll("#productunit#",sProductUnit.toLowerCase());

            // timeunits
            if(chronicMedication.getTimeUnitCount()==1){
                sPrescrRule = sPrescrRule.replaceAll("#timeunitcount#","");
                timeUnitTran = getTran(request,"prescription.timeunit",chronicMedication.getTimeUnit(),sWebLanguage);
            }
            else{
                sPrescrRule = sPrescrRule.replaceAll("#timeunitcount#",chronicMedication.getTimeUnitCount()+"");
                timeUnitTran = getTran(request,"prescription.timeunits",chronicMedication.getTimeUnit(),sWebLanguage);
            }
            
            sPrescrRule = sPrescrRule.replaceAll("#timeunit#",timeUnitTran.toLowerCase());
            out.print("<tr><td><b><a href='javascript:showChronicPrescription("+chronicMedication.getUid()+");'>"+chronicMedication.getProduct().getName()+"</a></b><i> ("+sPrescrRule+")</i></td></tr>");
        }

        if(chronicMedications.size() > 0){
		    %>
		            </table>
		        </td>
		    <%
        }
        
        //--- 2:ACTIVE ----------------------------------------------------------------------------
        Vector activePrescriptions = Prescription.getActivePrescriptions(activePatient.personid);
        if(activePrescriptions!=null && activePrescriptions.size()>0){
            long latencydays = 1000*MedwanQuery.getInstance().getConfigInt("activeMedicationLatency",60);
            latencydays*= 24*3600;
        	Timestamp ts = new Timestamp(ScreenHelper.parseDate(ScreenHelper.stdDateFormat.format(new java.util.Date())).getTime()-latencydays);

		    %>
		        <td class="admin2" nowrap style="border-bottom:1px solid #fff;"><b><%=getTran(request,"curative","medication.prescription",sWebLanguage)%><br>(<%=getTran(request,"web","after",sWebLanguage)+" "+ScreenHelper.stdDateFormat.format(ts) %>)</b></td>
		        <td>
		            <table>
		    <%
		    
	        Prescription prescription;	    
	        for(int n=0; n<activePrescriptions.size(); n++){
	            prescription = (Prescription)activePrescriptions.elementAt(n);
	            
	            if(prescription!=null && prescription.getProduct()!=null){
	                sPrescrRule = getTran(request,"web.prescriptions","prescriptionrule",sWebLanguage);
	                sPrescrRule = sPrescrRule.replaceAll("#unitspertimeunit#",prescription.getUnitsPerTimeUnit()+"");

	                // productunits
	                if(prescription.getUnitsPerTimeUnit()==1){
	                    sProductUnit = getTran(request,"product.unit",prescription.getProduct().getUnit(),sWebLanguage);
	                }
	                else{
	                    sProductUnit = getTran(request,"product.unit",prescription.getProduct().getUnit(),sWebLanguage);
	                }
	                sPrescrRule = sPrescrRule.replaceAll("#productunit#",sProductUnit.toLowerCase());

	                // timeunits
	                if(prescription.getTimeUnitCount()==1){
	                    sPrescrRule = sPrescrRule.replaceAll("#timeunitcount#","");
	                    timeUnitTran = getTran(request,"prescription.timeunit",prescription.getTimeUnit(),sWebLanguage);
	                }
	                else{
	                    sPrescrRule = sPrescrRule.replaceAll("#timeunitcount#",prescription.getTimeUnitCount()+"");
	                    timeUnitTran = getTran(request,"prescription.timeunits",prescription.getTimeUnit(),sWebLanguage);
	                }

	                sPrescrRule = sPrescrRule.replaceAll("#timeunit#",timeUnitTran.toLowerCase());
	                if(prescription.getEnd()==null || !prescription.getEnd().before(new java.util.Date())){
		                out.print("<tr>"+
		                           "<td title='"+getTran(null,"web","active",sWebLanguage)+"'><b><a href='javascript:showPrescription(\""+prescription.getUid()+"\");'>"+prescription.getProduct().getName()+"</a></b><i> ("+sPrescrRule+")</i></td>"+
		                          "</tr>");
	                }
	                else {
		                out.print("<tr>"+
		                           "<td title='"+getTran(null,"web","inactive",sWebLanguage)+"'><font color='lightgray'><a style='color: gray' href='javascript:showPrescription(\""+prescription.getUid()+"\");'>"+prescription.getProduct().getName()+"</a><i> ("+sPrescrRule+")</i></font></td>"+
		                          "</tr>");
	                }
	            }
	        }
	        
    		%>
		            </table>
		        </td>
			<%
    	}
        
    //--- 3:PAPER ---------------------------------------------------------------------------------
    long time = new java.util.Date().getTime();
    long month = 30*24*3600;
    month *= 3000;
    time -= month;
    
    Vector paperprescriptions = PaperPrescription.find(activePatient.personid,"",ScreenHelper.stdDateFormat.format(new java.util.Date(time)),"","","DESC");
    if(paperprescriptions.size() > 0){
        %>
        <tr>
            <td class="admin2" style="vertical-align:top;border-bottom:1px solid #fff;"><b><%=getTran(request,"curative","medication.paperprescriptions",sWebLanguage)%><br/> &lt;3 <%=getTran(request,"web","months",sWebLanguage).toLowerCase()%></b></td>
            <td colspan="3">
                <table width="100%">
                    <%
                        String hiddenprescriptions = "";
                        String sClass = "";
                        
                        for(int n=0; n<paperprescriptions.size(); n++){
                        	// alternate row-style
                            if(sClass.length()==0) sClass = "1";
                            else                   sClass = "";
                            
                            PaperPrescription paperPrescription = (PaperPrescription)paperprescriptions.elementAt(n);
                            if(n < 3){
                                out.print("<tr class='list"+sClass+"' id='pp"+paperPrescription.getUid()+"'>"+
                                           "<td valign='top' nowrap width='1%'>"+
                                            "<img src='_img/icons/icon_delete.png' class='link' onclick='deletepaperprescription(\""+paperPrescription.getUid()+"\");'/> <b>"+ScreenHelper.stdDateFormat.format(paperPrescription.getBegin())+"</b>"+
                                           "&nbsp;</td>"+
                                           "<td><i>");
                                Vector products = paperPrescription.getProducts();
                                for(int i=0; i<products.size(); i++){
                                    out.print(products.elementAt(i)+"<br/>");
                                }
                                out.print("</i></td>"+
                                         "</tr>");
                            }
                            else {
                                hiddenprescriptions+= "<tr class='list"+sClass+"' id='pp"+paperPrescription.getUid()+"'>"+
                                                       "<td valign='top' nowrap width='1%'>"+
                                                        "<img src='_img/icons/icon_delete.png' class='link' onclick='deletepaperprescription(\""+paperPrescription.getUid()+"\");'/> <b>"+ScreenHelper.stdDateFormat.format(paperPrescription.getBegin())+"</b>"+
                                                       "&nbsp;</td>"+
                                                       "<td><i>";
                                Vector products = paperPrescription.getProducts();
                                for(int i=0; i<products.size(); i++){
                                    hiddenprescriptions+= products.elementAt(i)+"<br/>";
                                }
                                hiddenprescriptions+= "</i></td></tr>";
                            }
                        }
                    %>
                </table>
            </td>
        </tr>
        <%
        
        if(hiddenprescriptions.length() > 0){
            out.print("<tr>"+
                       "<td class='admin2'>"+
                        "<right><img src='"+sCONTEXTPATH+"/_img/icons/icon_plus.png' onclick='togglehiddenprescriptions();'/></right>"+
                       "</td>"+
                       "<td colspan='3'>"+
                        "<div id='hiddenprescriptions' style='display:none'>"+
                         "<table width='100%'>"+hiddenprescriptions+"</table>"+
                        "</div>"+
                       "</td>"+
                      "</tr>");
        }
    }
    
	//--- 4:DELIVERED -----------------------------------------------------------------------------
	long day = 24*3600*1000;
	Vector medicationHistory = ProductStockOperation.getPatientDeliveries(activePatient.personid,new java.util.Date(new java.util.Date().getTime()-MedwanQuery.getInstance().getConfigInt("patientMedicationDeliveryHistoryDuration",14)*day), new java.util.Date(),"OC_OPERATION_DATE","DESC");
	if(medicationHistory.size() > 0){
		%>
        <tr>
            <td class="admin2" style="vertical-align:top;border-bottom:1px solid #fff;"><b><%=getTran(request,"curative","product.deliveries",sWebLanguage)%><br/> &lt;<%= MedwanQuery.getInstance().getConfigInt("patientMedicationDeliveryHistoryDuration",14)%> <%=getTran(request,"web","days",sWebLanguage).toLowerCase()%></b></td>
            <td colspan="3">
                <table width="100%">
                    <% 
                        ProductStockOperation operation;
						for(int n=0; n<medicationHistory.size(); n++){
							operation = (ProductStockOperation)medicationHistory.elementAt(n);
							
							String product = "";
							if(operation.getProductStock()!=null && operation.getProductStock().getProduct()!=null){
								product = operation.getProductStock().getProduct().getName();
				                if(checkString(operation.getReceiveComment()).length()>0 || checkString(operation.getComment()).length()>0){
				                	product+= " ("+(checkString(operation.getReceiveComment())+" "+checkString(operation.getComment())).trim()+")";
				                }
							}
							if(operation.getUnitsChanged()!=0){
								out.print("<tr><td>"+ScreenHelper.stdDateFormat.format(operation.getDate())+"</td><td>"+operation.getUnitsChanged()+" X "+product+"</td></tr>");		                    
							}
						}
                    %>
                </table>
            </td>
        </tr>
	    <%
	}
	
    %>
    <tr height="99%"><td/></tr>
</table>

<script>
  function showPrescription(uid){
	var url = '<c:url value='/popup.jsp'/>?Page=medical/managePrescriptionsPopup.jsp&Action=showDetails&EditPrescrUid='+uid+"&ts=<%=getTs()%>&PopupWidth=800";
    window.open(url,'Popup','toolbar=no,status=no,scrollbars=yes,resizable=yes,width=1,height=1,menubar=no').moveBy(2000,2000);
  }
  
  function showChronicPrescription(uid){
	url = '<c:url value='/popup.jsp'/>?Page=medical/manageChronicMedication.jsp&PopupWidth=800&Action=showDetails&EditMedicationUid='+uid;
    window.open(url,'Popup','toolbar=no,status=no,scrollbars=yes,resizable=yes,width=1,height=1,menubar=no').moveBy(2000,2000);
  }
  
  function togglehiddenprescriptions(){
    if(document.getElementById('hiddenprescriptions').style.display=='none'){
       document.getElementById('hiddenprescriptions').style.display='block';
    }
    else{
      document.getElementById('hiddenprescriptions').style.display='none';
    }
  }
  function checkForInteractions(){
	  	document.getElementById("interactionswarning").innerHTML="<img height='5px' src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/>";
	    var url = "<c:url value=''/>pharmacy/popups/findRxNormDrugDrugInteractionsBoolean.jsp";
	    var params = "";
	    new Ajax.Request(url,{
	      method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
	        var interactions =  eval('('+resp.responseText+')');
	        if(interactions.interactionsexist=='1'){
	        	document.getElementById("interactionswarning").innerHTML="<a href='javascript:findInteractions();'><img src='<c:url value='/_img/icons/icon_warning.gif'/>' title='<%=getTranNoLink("web","prescription_has_interactions",sWebLanguage)%>'/><%=getTranNoLink("web","prescription_has_interactions",sWebLanguage)%>!</a>";
	        }
	        else {
	        	document.getElementById("interactionswarning").innerHTML='&nbsp';
	        }
	      },
		onFailure: function(resp){
        	document.getElementById("interactionswarning").innerHTML='&nbsp';
	      }
	    });
	  }

  <%
  	if(MedwanQuery.getInstance().getConfigInt("enableRxNorm",0)==1){
  %>
  		checkForInteractions();
  <%
  	}
  %>
  
  function findInteractions(){
	    openPopup("/pharmacy/popups/findRxNormDrugDrugInteractions.jsp&ts=<%=getTs()%>",800,600);
	}

	function openProductionOrder(uid){
		window.location.href="<c:url value="main.do?Page=pharmacy/manageProductionOrder.jsp"/>&productionOrderUid="+uid;
	}
	
	function deliverOrder(productstockuid,productname){
	    openPopup("/pharmacy/medication/popups/deliverMedicationPopup.jsp&reloadParent=1&EditProductStockUid="+productstockuid+"&EditProductName="+productname+"&EditOperationDescr=medicationdelivery.1&ts=<%=getTs()%>",800,450);
	}

</script>