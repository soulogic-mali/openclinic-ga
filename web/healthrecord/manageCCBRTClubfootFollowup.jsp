<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"occup.ccbrt.clubfootfollowup","select",activeUser)%>
<%=sJSCHARTJS%>
<%=sJSEXCANVAS%>

<form name="transactionForm" id="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>
   
    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>
    
    <%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>
    <%=contextHeader(request,sWebLanguage)%>
    
    <table class="list" width="100%" cellspacing="1">
        <%-- DATE --%>
        <tr>
            <td class="admin" width="5%" nowrap>
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
            </td>
            <td class="admin2">
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
                &nbsp;&nbsp;
                <font style="font-size: 12px;font-weight:bold;">
                <%=getTran(request,"web","age",sWebLanguage) %>: 
                <%
                	//Calculate the age of the patient on the date of transaction
                	long day = 24*3600*1000;
                	long week = day*7;
                	long month = day*30;
                	long year = day*365;
                	try{
                		long patientage=((TransactionVO)transaction).getUpdateTime().getTime()-ScreenHelper.parseDate(activePatient.dateOfBirth).getTime();
                		if(patientage<52*week){
                			out.println((patientage/week)+" "+getTran(request,"web","weeks",sWebLanguage));
                		}
                		else if(patientage<24*month){
                			out.println((patientage/month)+" "+getTran(request,"web","months",sWebLanguage));
                		}
                		else{
                			out.println((patientage/year)+" "+getTran(request,"web","years",sWebLanguage)+ " "+((patientage%year)/month)+" "+getTran(request,"web","months",sWebLanguage));
                		}
                	}
                	catch(Exception e){
                		out.println("?");
                	}
                	out.println("&nbsp;&nbsp;&nbsp;&nbsp;");
                    out.println(getTran(request,"web","followup",sWebLanguage)+":"); 
                	try{
                		Vector transactions = MedwanQuery.getInstance().getTransactionsByType(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_CCBRT_CLUBFOOT");
                		if(transactions.size()>0){
	                		long followupage=((TransactionVO)transaction).getUpdateTime().getTime()-((TransactionVO)transactions.elementAt(0)).getUpdateTime().getTime();
	               			out.println((followupage/week)+" "+getTran(request,"web","weeks",sWebLanguage));
                		}
                		else{
                    		out.println("?");
                		}
                		transactions = MedwanQuery.getInstance().getTransactionsByType(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_CCBRT_CLUBFOOT_FOLLOWUP");
                		Collections.reverse(transactions);
                		for(int n=0;n<transactions.size();n++){
                			TransactionVO t = (TransactionVO)transactions.elementAt(n);
                			if(((TransactionVO)transaction).getServerId()==t.getServerId() && ((TransactionVO)transaction).getTransactionId()==t.getTransactionId()){
                        		out.println("&nbsp;(#"+(n+1)+")");
                				
                			}
                		}
                	}
                	catch(Exception e){
                		out.println("?");
                	}
                %>
                </font>
            </td>
        </tr>
       	
       	
       	<tr>
           	<td class="admin" width='5%'><%=getTran(request,"ccbrt.eye","attendencytype",sWebLanguage) %></td>
           	<td class="admin2">
            	<table width='100%'>
		           <tr>
			           	<td  class='admin2' width='10%'>
			           	<select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_ATTENDENCYTYPE")%>  style='width: 100px' id="attendencytype" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_ATTENDENCYTYPE" property="itemId"/>]>.value">
					         <option/>
						     <%=ScreenHelper.writeSelect(request,"clubfoot.attendencytype",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_ATTENDENCYTYPE"),sWebLanguage,false,true) %>
					    </select>
						</td>
						
						<td class="admin2" width='10%'><%=getTran(request,"clubfoot.sfab.change","sfab.changes",sWebLanguage)%>&nbsp;</td>
			           <td  class='admin2' width='10%'>
								         <select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_SFABCHANGE")%> style='width: 100px' id="sfabchange" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_SFABCHANGE" property="itemId"/>]>.value">
								         <option/>
									     <%=ScreenHelper.writeSelect(request,"clubfoot.sfabchange",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_SFABCHANGE"),sWebLanguage,false,true) %>
								          </select>
						</td>

						<td class="admin2" width='10%'><%=getTran(request,"clubfoot.sfabchange.date","date.sfabchange",sWebLanguage)%>&nbsp;</td>
						<td class="admin2" nowrap>
			            	<input type="hidden" id="sfabchangedatefield"  name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_SFABCHANGEDATE" property="itemId"/>]>.value"/>
							<%=ScreenHelper.writeDateField("sfabchangedate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_SFABCHANGEDATE"), true, false, sWebLanguage, sCONTEXTPATH)%>
			            </td>
		           
		           </tr>
		         </table>
		       </td>
		     </tr>
            
           <tr>
           <td class="admin" width='5%' />
           	<td class="admin" colspan='10'>
            	<table width='100%'>
            		<tr>
	        			
	        			<td class='admin' width='10%'><%=getTran(request,"clubfoot","Material",sWebLanguage) %></td>
	        			<td class='admin' width='10%'><%=getTran(request,"clubfoot","Quantity",sWebLanguage) %></td>
	        			<td class='admin' width='10%'><%=getTran(request,"clubfoot","Material",sWebLanguage) %></td>
	        			<td class='admin' width='10%'><%=getTran(request,"clubfoot","Quantity",sWebLanguage) %></td>
	        			<td class='admin' width='10%'><%=getTran(request,"clubfoot","Material",sWebLanguage) %></td>
	        			<td class='admin' width='10%'><%=getTran(request,"clubfoot","Quantity",sWebLanguage) %></td>
	        			<td class='admin' width='10%'><%=getTran(request,"clubfoot","Material",sWebLanguage) %></td>
	        			<td class='admin' width='10%'><%=getTran(request,"clubfoot","Quantity",sWebLanguage) %></td>
	        			<td class='admin' width='10%'><%=getTran(request,"clubfoot","Material",sWebLanguage) %></td>
	        			<td class='admin' width='10%'><%=getTran(request,"clubfoot","Quantity",sWebLanguage) %></td>
	        		</tr>
            	</table>
	        	</td>
	        </tr>
	        
           	<tr>
           		<td class="admin" width='5%'><%=getTran(request,"web","usedmaterials",sWebLanguage)%>&nbsp;</td>
          		<td class="admin2" colspan='10'>
		           		<table width='100%'>
				           	<tr>
				           	<%-- MAterial 1 --%>
				           		<td  class='admin2' width='10%'>
							         <select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_1")%>  style='width: 100px' id="clubfoot.usedmaterial1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_1" property="itemId"/>]>.value">
							         <option/>
								     <%=ScreenHelper.writeSelect(request,"clubfoot.material",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_1"),sWebLanguage,false,true) %>
							          </select>
							    </td>
							    <td  class='admin2'width='10%'>
							         <input id="Quantity_1" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIALQUANTITY_1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIALQUANTITY_1" property="value"/>"/>
								</td>
								
								<%-- MAterial 2 --%>
								<td  class='admin2' width='10%'>
							         <select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_2")%>  style='width: 100px' id="clubfoot.usedmaterial2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_2" property="itemId"/>]>.value">
							         <option/>
								     <%=ScreenHelper.writeSelect(request,"clubfoot.material",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_2"),sWebLanguage,false,true) %>
							          </select>
							    </td>
							    <td  class='admin2'width='10%'>
							         <input id="Quantity_2" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIALQUANTITY_2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIALQUANTITY_2" property="value"/>"/>
								</td>
								
								
								<td  class='admin2' width='10%'>
							         <select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_3")%>  style='width: 100px' id="clubfoot.usedmaterial3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_3" property="itemId"/>]>.value">
							         <option/>
								     <%=ScreenHelper.writeSelect(request,"clubfoot.material",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_3"),sWebLanguage,false,true) %>
							          </select>
							    </td>
							    <td  class='admin2'width='10%'>
							         <input id="Quantity_3" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIALQUANTITY_3" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIALQUANTITY_3" property="value"/>"/>
								</td>
								
								<td  class='admin2' width='10%'>
							         <select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_4")%>  style='width: 100px' id="clubfoot.usedmaterial4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_4" property="itemId"/>]>.value">
							         <option/>
								     <%=ScreenHelper.writeSelect(request,"clubfoot.material",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_4"),sWebLanguage,false,true) %>
							          </select>
							    </td>
							    <td  class='admin2'width='10%'>
							         <input id="Quantity_4" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIALQUANTITY_4" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIALQUANTITY_4" property="value"/>"/>
								</td>
								
								<td  class='admin2' width='10%'>
							         <select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_5")%>  style='width: 100px' id="clubfoot.usedmaterial5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_5" property="itemId"/>]>.value">
							         <option/>
								     <%=ScreenHelper.writeSelect(request,"clubfoot.material",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_5"),sWebLanguage,false,true) %>
							          </select>
							    </td>
							    <td  class='admin2'width='10%'>
							         <input id="Quantity_5" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIALQUANTITY_5" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIALQUANTITY_5" property="value"/>"/>
								</td>
					   
		           			</tr>
		           		</table>
           		</td>
           		</tr>
           		
           		
           		
           		<tr>
           			<td class="admin" width='5%'/>
           			<td class="admin2" colspan='10'>
           					<table width='100%'>
           						<tr>
		           					<td  class='admin2' width='10%'>
						         		<select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_6")%>  style='width: 100px' id="clubfoot.usedmaterial6" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_6" property="itemId"/>]>.value">
						         		<option/>
							     		<%=ScreenHelper.writeSelect(request,"clubfoot.material",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_6"),sWebLanguage,false,true) %>
						          		</select>
					    			</td>
					    		<td  class='admin2'width='10%'>
					         	<input id="Quantity_6" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIALQUANTITY_6" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIALQUANTITY_6" property="value"/>"/>
								</td>
						
								<td  class='admin2' width='10%'>
							         <select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_7")%> style='width: 100px' id="clubfoot.usedmaterial7" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_7" property="itemId"/>]>.value">
							         <option/>
								     <%=ScreenHelper.writeSelect(request,"clubfoot.material",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_7"),sWebLanguage,false,true) %>
							          </select>
					    		</td>
					    		<td  class='admin2'width='10%'>
					         		<input id="Quantity_7" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIALQUANTITY_7" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIALQUANTITY_7" property="value"/>"/>
								</td>
						
								<td  class='admin2' width='10%'>
							         <select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_8")%>  style='width: 100px' id="clubfoot.usedmaterial8" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_8" property="itemId"/>]>.value">
							         <option/>
								     <%=ScreenHelper.writeSelect(request,"clubfoot.material",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_8"),sWebLanguage,false,true) %>
							          </select>
					    		</td>
					    		<td  class='admin2'width='10%'>
					         		<input id="Quantity_8" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIALQUANTITY_8" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIALQUANTITY_8" property="value"/>"/>
								</td>
						
								<td  class='admin2' width='10%'>
							         <select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_9")%>  style='width: 100px' id="clubfoot.usedmaterial9" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_9" property="itemId"/>]>.value">
							         <option/>
								     <%=ScreenHelper.writeSelect(request,"clubfoot.material",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIAL_9"),sWebLanguage,false,true) %>
							          </select>
					    		</td>
					    		<td  class='admin2'width='10%'>
					         		<input id="Quantity_9" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIALQUANTITY_9" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_USEDMATERIALQUANTITY_9" property="value"/>"/>
								</td>
								
								<td class='admin2' width='10%'/>
					    		<td class='admin2' width='10%'/>
								
			   
           						</tr>
           			</table>
           		</td>
          </tr>
           
           
      <tr>
            <td class="admin"><%=getTran(request,"ccbrt.ortho","followup",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
            	<table width='100%'>
            		<tr>
            			<td>
			            	<select class='text' id='frequency' onchange='calculateNextDate()'>
			            		<option/>
			            		<option value='1'>1</option>
			            		<option value='2'>2</option>
			            		<option value='3'>3</option>
			            		<option value='4'>4</option>
			            		<option value='5'>5</option>
			            		<option value='6'>6</option>
			            		<option value='7'>7</option>
			            		<option value='8'>8</option>
			            		<option value='9'>9</option>
			            		<option value='10'>10</option>
			            		<option value='11'>11</option>
			            		<option value='12'>12</option>
			            	</select>
			            	<select class='text' id='frequencytype' onchange='calculateNextDate()'>
			            		<option/>
			            		<option value='week'><%=getTran(request,"web","weeks",sWebLanguage) %></option>
			            		<option value='month'><%=getTran(request,"web","months",sWebLanguage) %></option>
			            		<option value='year'><%=getTran(request,"web","year",sWebLanguage) %></option>
			            	</select>
			                <input type="hidden" id="ccbrtdate" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_FOLLOWUPDATE" property="itemId"/>]>.value"/>
			            	<%=(ScreenHelper.writeDateField("followupdate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_FOLLOWUPDATE"), false, true, sWebLanguage, sCONTEXTPATH))%>
			            	&nbsp;&nbsp;<a href="javascript:openPopup('planning/findPlanning.jsp&FindDate='+document.getElementById('followupdate').value+'&isPopup=1&FindUserUID=<%=activeUser.userid %>',1024,600,'Agenda','toolbar=no,status=yes,scrollbars=no,resizable=yes,width=1024,height=600,menubar=no');void(0);"><%=getTran(request,"web","findappointment",sWebLanguage) %></a>
			            </td>
			            <td class="admin2" width='1%'><%=getTran(request,"web","notes",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <textarea id="notes" onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_NOTES")%> class="text" cols='60' rows='1' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_NOTES" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_EXAMINATION_NOTES" property="value"/></textarea>
			            </td>
		            </tr>
	            </table>
            </td>
           </tr>     
           
           
        <tr>
        	<td width="100%" colspan="2">
		      	<table width='100%'>
	        		<tr class='admin'>
			            <td colspan='11'><%=getTran(request,"web","initialmetrics",sWebLanguage)%>&nbsp;</td>
	        		</tr>
	        		<tr>
	        			<td class='admin'/>
	        			<td class='admin' width='9%'><%=getTran(request,"clubfoot","pc",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"clubfoot","re",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"clubfoot","eh",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"clubfoot","hindfootscore",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"clubfoot","clb",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"clubfoot","mc",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"clubfoot","lht",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"clubfoot","midfootscore",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"clubfoot","totalscore",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"clubfoot","treatment",sWebLanguage) %></td>
	        		</tr>
	        		<tr>
			            <td class='admin'><%=getTran(request,"web","rightfoot",sWebLanguage)%>&nbsp;</td>
			            <td >
			            	<select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_PC")%> onmouseup='calculatescores()' style='width: 60px' id="re_pc" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_PC" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.pc",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_PC"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td>
			            	<select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_RE")%> onmouseup='calculatescores()'  style='width: 60px' id="re_re" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_RE" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.re",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_RE"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td >
			            	<select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_EH")%> onmouseup='calculatescores()'  style='width: 60px' id="re_eh" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_EH" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.he",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_EH"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td class='admin2'>
			            	<span id='re_hindfootscore'/>
			            </td>
			            <td >
			            	<select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_CLB")%> onmouseup='calculatescores()' style='width: 60px' id="re_clb"  name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_CLB" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.clb",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_CLB"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td >
			            	<select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_MC")%> onmouseup='calculatescores()' style='width: 60px' id="re_mc" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_MC" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.mc",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_MC"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td >
			            	<select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_LHT")%> onmouseup='calculatescores()' style='width: 60px' id="re_lht"  name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_LHT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.lht",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_LHT"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td class='admin2'>
			            	<span id='re_midfootscore'/>
			            </td>
			            <td class='admin2'>
			            	<span id='re_totalfootscore'/>
			            </td>
			            <td >
			            	<select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_TREATMENT")%> style='width: 60px' id="re_treatment"  name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_TREATMENT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.treatment",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_TREATMENT"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
	        		</tr>
	        		<tr>
			            <td class='admin'><%=getTran(request,"web","leftfoot",sWebLanguage)%>&nbsp;</td>
			            <td >
			            	<select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_PC")%> onmouseup='calculatescores()' style='width: 60px' id="le_pc" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_PC" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.pc",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_PC"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td >
			            	<select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_RE")%> onmouseup='calculatescores()' style='width: 60px' id="le_re"  name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_RE" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.re",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_RE"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td >
			            	<select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_HE")%> onmouseup='calculatescores()' style='width: 60px' id="le_eh"  name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_EH" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.he",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_EH"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td class='admin2'>
			            	<span id='le_hindfootscore'/>
			            </td>
			            <td >
			            	<select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_CLB")%> onmouseup='calculatescores()' style='width: 60px' id="le_clb" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_CLB" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.clb",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_CLB"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td >
			            	<select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_MC")%> onmouseup='calculatescores()' style='width: 60px' id="le_mc" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_MC" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.mc",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_MC"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td >
			            	<select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_LHT")%> onmouseup='calculatescores()' style='width: 60px' id="le_lht" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_LHT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.lht",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_LHT"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
			            <td class='admin2'>
			            	<span id='le_midfootscore'/>
			            </td>
			            <td class='admin2'>
			            	<span id='le_totalfootscore'/>
			            </td>
			            <td >
			            	<select <%=setRightClick("ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_TREATMENT")%> style='width: 60px' id="le_treatment" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_TREATMENT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"clubfoot.treatment",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_TREATMENT"),sWebLanguage,false,true) %>
			            	</select>
			            </td>
	        		</tr>
			    </table>
	        </td>
        <tr>
    </table>
	<table width='100%'>
	    <tr>
	    	<td colspan='2'>
	    		&nbsp;
			</td>
	    </tr>
	    <tr>
	    	<td width='50%'>
	    		<center><b><%=getTran(request,"web","rightfoot",sWebLanguage) %></b></center>
			</td>
	    	<td width='50%'>
	    		<center><b><%=getTran(request,"web","leftfoot",sWebLanguage) %></b></center>
			</td>
	    </tr>
	    <tr>
	    	<td width='50%'>
	    		<center><div style="border: 0px solid black; height:300px; width:400px;"><canvas id="diagRightClubfoot"></canvas></div></center>
			</td>
	    	<td width='50%'>
				<center><div style="border: 0px solid black; height:300px; width:400px;"><canvas id="diagLeftClubfoot"></canvas></div></center>
			</td>
	    </tr>
	</table>
	<input type='hidden' id='rhf'/>
	<input type='hidden' id='rmf'/>
	<input type='hidden' id='lhf'/>
	<input type='hidden' id='lmf'/>
	<input type='hidden' id='tranid' value='<%=((TransactionVO)transaction).getServerId()+"."+((TransactionVO)transaction).getTransactionId()%>'/>
            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.ccbrt.clubfootfollowup",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>
	
    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
var rightClubfootChart;
var leftClubfootChart;

function drawRightClubfootGraph(){
	var ds= [
	        	{
	               	label: '<%=getTranNoLink("web","hindfootscore",sWebLanguage)%>',
	         		showLabels: true,
	         		backgroundColor: 'blue',
	         		borderColor: 'blue',
	         		borderWidth: 1,
	         		fill: false,
	                showLine: true,
	                pointStyle: 'rect',
	                radius: 5,
	               	data: []
	           	},
	           	{
	               	label: '<%=getTranNoLink("web","midfootscore",sWebLanguage)%>',
	         		showLabels: true,
	         		backgroundColor: 'red',
	         		borderColor: 'red',
	         		borderWidth: 1,
	         		fill: false,
	                showLine: true,
	                pointStyle: 'circle',
	                radius: 5,
	               	data: []
	           	},
	           	{
	               	label: '<%=getTranNoLink("web","totalfootscore",sWebLanguage)%>',
	         		showLabels: true,
	         		backgroundColor: 'black',
	         		borderColor: 'black',
	         		borderWidth: 1,
	         		fill: false,
	                showLine: true,
	                pointStyle: 'crossRot',
	                radius: 5,
	               	data: []
	           	},
   	];
	var ctx=document.getElementById('diagRightClubfoot').getContext("2d");
	ctx.height=300;
	ctx.width=400;
	Chart.defaults.global.defaultFontSize=10;
	rightClubfootChart = new Chart(ctx, {
	    type: 'scatter',
	    labels: ['0','1','2','3','4','5','6'],
	    data: {
	    	datasets: ds
	    },
	    options: {	
	    	maintainAspectRatio: false,
	        legend: {
	            display: true
	        },
	        scales: {
	        	yAxes: [{
	        		ticks: {
		        		min: 0,
		        		max: 6,	
		        		stepSize: 0.5,
	        		}
	        	}],
	        	xAxes: [{
	        		display: true,
	        		ticks: {
		        		min: 1,
		        		max: 8,
		        		stepSize: 1,
	        		}
	        	}],
	        }        	
	    },
	});
}

drawRightClubfootGraph();

function drawLeftClubfootGraph(){
	var ds= [
	        	{
	               	label: '<%=getTranNoLink("web","hindfootscore",sWebLanguage)%>',
	         		backgroundColor: 'blue',
	         		borderColor: 'blue',
	         		borderWidth: 1,
	         		fill: false,
	                showLine: true,
	                pointStyle: 'rect',
	                radius: 5,
	               	data: []
	           	},
	           	{
	               	label: '<%=getTranNoLink("web","midfootscore",sWebLanguage)%>',
	         		backgroundColor: 'red',
	         		borderColor: 'red',
	         		borderWidth: 1,
	         		fill: false,
	                showLine: true,
	                pointStyle: 'circle',
	                radius: 5,
	               	data: []
	           	},
	           	{
	               	label: '<%=getTranNoLink("web","totalfootscore",sWebLanguage)%>',
	         		backgroundColor: 'black',
	         		borderColor: 'black',
	         		borderWidth: 1,
	         		fill: false,
	                showLine: true,
	                pointStyle: 'crossRot',
	                radius: 5,
	               	data: []
	           	},
   	];
	var ctx=document.getElementById('diagLeftClubfoot').getContext("2d");
	ctx.height=300;
	ctx.width=400;
	Chart.defaults.global.defaultFontSize=10;
	leftClubfootChart = new Chart(ctx, {
	    type: 'scatter',
	    labels: ['0','1','2','3','4','5','6'],
	    data: {
	    	datasets: ds
	    },
	    options: {	
	    	maintainAspectRatio: false,
	        legend: {
	            display: true
	        },
	        scales: {
	        	yAxes: [{
	        		ticks: {
		        		min: 0,
		        		max: 6,	
		        		stepSize: 0.5,
	        		}
	        	}],
	        	xAxes: [{
	        		display: true,
	        		ticks: {
		        		min: 1,
		        		max: 8,
		        		stepSize: 1,
	        		}
	        	}],
	        }        	
	    },
	});
}

drawLeftClubfootGraph();

function loadClubfootScores(){
    var params = "tranid="+document.getElementById('tranid').value+
				 "&rhf="+document.getElementById('rhf').value+
				 "&rmf="+document.getElementById('rmf').value+
				 "&lhf="+document.getElementById('lhf').value+
				 "&lmf="+document.getElementById('lmf').value
    			 ;
    var today = new Date();
    var url = '<c:url value="/healthrecord/ajax/loadClubfootScores.jsp"/>';
    new Ajax.Request(url,{
      	method: "POST",
      	parameters: params,
      	onSuccess: function(resp){
          	var label = eval('('+resp.responseText+')');
	      	rightClubfootChart.config.data.datasets[0].data.clear();
	      	if(label.rightHindfoot.length>0){
		      	var d = label.rightHindfoot.split(";");
		      	for(n=0;n<d.length;n++){
		      		if(d[n]*1>-1){
		    			var newData={
		    	            x: n+1,
		    	            y: d[n],
		    	        };
		    			rightClubfootChart.config.data.datasets[0].data.push(newData);
		      		}
		      	}
	      	}
	      	rightClubfootChart.config.data.datasets[1].data.clear();
	      	if(label.rightMidfoot.length>0){
		      	var d = label.rightMidfoot.split(";");
		      	for(n=0;n<d.length;n++){
		      		if(d[n]*1>-1){
		    			var newData={
		    	            x: n+1,
		    	            y: d[n],
		    	        };
		    			rightClubfootChart.config.data.datasets[1].data.push(newData);
		      		}
		      	}
	      	}
	      	rightClubfootChart.config.data.datasets[2].data.clear();
	      	if(label.rightTotal.length>0){
		      	var d = label.rightTotal.split(";");
		      	for(n=0;n<d.length;n++){
		      		if(d[n]*1>-1){
		    			var newData={
		    	            x: n+1,
		    	            y: d[n],
		    	        };
		    			rightClubfootChart.config.data.datasets[2].data.push(newData);
		      		}
		      	}
	      	}
   	  	  	rightClubfootChart.update();
	      	leftClubfootChart.config.data.datasets[0].data.clear();
	      	if(label.leftHindfoot.length>0){
		      	var d = label.leftHindfoot.split(";");
		      	for(n=0;n<d.length;n++){
		      		if(d[n]*1>-1){
		    			var newData={
		    	            x: n+1,
		    	            y: d[n],
		    	        };
		    			leftClubfootChart.config.data.datasets[0].data.push(newData);
		      		}
		      	}
	      	}
	      	leftClubfootChart.config.data.datasets[1].data.clear();
	      	if(label.leftMidfoot.length>0){
		      	var d = label.leftMidfoot.split(";");
		      	for(n=0;n<d.length;n++){
		      		if(d[n]*1>-1){
		    			var newData={
		    	            x: n+1,
		    	            y: d[n],
		    	        };
		    			leftClubfootChart.config.data.datasets[1].data.push(newData);
		      		}
		      	}
	      	}
	      	leftClubfootChart.config.data.datasets[2].data.clear();
	      	if(label.leftTotal.length>0){
		      	var d = label.leftTotal.split(";");
		      	for(n=0;n<d.length;n++){
		      		if(d[n]*1>-1){
		    			var newData={
		    	            x: n+1,
		    	            y: d[n],
		    	        };
		    			leftClubfootChart.config.data.datasets[2].data.push(newData);
		      		}
		      	}
	      	}
   	  	  	leftClubfootChart.update();
      	},
      	onFailure: function(){
      	}
    });
}

function calculatescores(){
	var bchanged=false;
	s = document.getElementById('rhf').value;
	if(document.getElementById('re_pc').value.length>0 && document.getElementById('re_re').value.length>0 && document.getElementById('re_eh').value.length>0){
		document.getElementById('re_hindfootscore').innerHTML='<font style="font-size: 12px;font-weight:bold;">'+(document.getElementById('re_pc').value*1+document.getElementById('re_re').value*1+document.getElementById('re_eh').value*1)+'</font>';
		document.getElementById('rhf').value=(document.getElementById('re_pc').value*1+document.getElementById('re_re').value*1+document.getElementById('re_eh').value*1);
	}
	else{
		document.getElementById('re_hindfootscore').innerHTML='';
		document.getElementById('rhf').value='';
	}
	if(!(document.getElementById('rhf').value==s)){
		bchanged=true;			
	}
	s = document.getElementById('rmf').value;
	if(document.getElementById('re_clb').value.length>0 && document.getElementById('re_mc').value.length>0 && document.getElementById('re_lht').value.length>0){
		document.getElementById('re_midfootscore').innerHTML='<font style="font-size: 12px;font-weight:bold;">'+(document.getElementById('re_clb').value*1+document.getElementById('re_mc').value*1+document.getElementById('re_lht').value*1)+'</font>';
		document.getElementById('rmf').value=(document.getElementById('re_clb').value*1+document.getElementById('re_mc').value*1+document.getElementById('re_lht').value*1);
	}
	else{
		document.getElementById('re_midfootscore').innerHTML='';
		document.getElementById('rmf').value='';
	}
	if(!(document.getElementById('rmf').value==s)){
		bchanged=true;			
	}
	if(document.getElementById('re_hindfootscore').innerHTML.length>0 && document.getElementById('re_midfootscore').innerHTML.length>0){
		document.getElementById('re_totalfootscore').innerHTML='<font style="font-size: 12px;font-weight:bold;">'+(document.getElementById('re_pc').value*1+document.getElementById('re_re').value*1+document.getElementById('re_eh').value*1+document.getElementById('re_clb').value*1+document.getElementById('re_mc').value*1+document.getElementById('re_lht').value*1)+'</font>';
	}
	else{
		document.getElementById('re_totalfootscore').innerHTML='';
	}
	s = document.getElementById('lhf').value;
	if(document.getElementById('le_pc').value.length>0 && document.getElementById('le_re').value.length>0 && document.getElementById('le_eh').value.length>0){
		document.getElementById('le_hindfootscore').innerHTML='<font style="font-size: 12px;font-weight:bold;">'+(document.getElementById('le_pc').value*1+document.getElementById('le_re').value*1+document.getElementById('le_eh').value*1)+'</font>';
		document.getElementById('lhf').value=(document.getElementById('le_pc').value*1+document.getElementById('le_re').value*1+document.getElementById('le_eh').value*1);
	}
	else{
		document.getElementById('le_hindfootscore').innerHTML='';
		document.getElementById('lhf').value='';
	}
	if(!(document.getElementById('lhf').value==s)){
		bchanged=true;			
	}
	s = document.getElementById('lmf').value;
	if(document.getElementById('le_clb').value.length>0 && document.getElementById('le_mc').value.length>0 && document.getElementById('le_lht').value.length>0){
		document.getElementById('le_midfootscore').innerHTML='<font style="font-size: 12px;font-weight:bold;">'+(document.getElementById('le_clb').value*1+document.getElementById('le_mc').value*1+document.getElementById('le_lht').value*1)+'</font>';
		document.getElementById('lmf').value=(document.getElementById('le_clb').value*1+document.getElementById('le_mc').value*1+document.getElementById('le_lht').value*1);
	}
	else{
		document.getElementById('le_midfootscore').innerHTML='';
		document.getElementById('lmf').value='';
	}
	if(!(document.getElementById('lmf').value==s)){
		bchanged=true;			
	}
	if(document.getElementById('le_hindfootscore').innerHTML.length>0 && document.getElementById('le_midfootscore').innerHTML.length>0){
		document.getElementById('le_totalfootscore').innerHTML='<font style="font-size: 12px;font-weight:bold;">'+(document.getElementById('le_pc').value*1+document.getElementById('le_re').value*1+document.getElementById('le_eh').value*1+document.getElementById('le_clb').value*1+document.getElementById('le_mc').value*1+document.getElementById('le_lht').value*1)+'</font>';
	}
	else{
		document.getElementById('le_totalfootscore').innerHTML='';
	}
	if(bchanged){
		loadClubfootScores();
	}
}
function searchEncounter(){
    openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&Varcode=encounteruid&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
  }
  
  if( document.getElementById('encounteruid').value=="" <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
  	alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
  	searchEncounter();
  }	

  <%-- SUBMIT FORM --%>
  function calculateNextDate(){
	  var nextdate = new Date();
	  if(document.getElementById('frequencytype').value.length>0 && document.getElementById('frequency').value.length>0){
		  if(document.getElementById('frequencytype').value=='month'){
			  nextdate.setMonth(nextdate.getMonth()+document.getElementById('frequency').value*1);
		  }
		  else if(document.getElementById('frequencytype').value=='year'){
			  nextdate.setYear(nextdate.getFullYear()+document.getElementById('frequency').value*1);
		  }
		  else if(document.getElementById('frequencytype').value=='week'){
			  nextdate.setDate(nextdate.getDate()+document.getElementById('frequency').value*7);
		  }
		  document.getElementById('followupdate').value=("0"+nextdate.getDate()).substring(("0"+nextdate.getDate()).length-2,("0"+nextdate.getDate()).length)+"/"+("0"+(nextdate.getMonth()+1)).substring(("0"+(nextdate.getMonth()+1)).length-2,("0"+(nextdate.getMonth()+1)).length)+"/"+nextdate.getFullYear();
  	 }
  }
  function searchUser(managerUidField,managerNameField){
	  openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+managerUidField+"&ReturnName="+managerNameField+"&displayImmatNew=no&FindServiceID=<%=MedwanQuery.getInstance().getConfigString("CCBRTOrthoRegistryService")%>",650,600);
    document.getElementById(diagnosisUserName).focus();
  }
	function searchService(serviceUidField,serviceNameField){
	    openPopup("_common/search/searchService.jsp&ts=<%=getTs()%>&showinactive=1&VarCode="+serviceUidField+"&VarText="+serviceNameField);
	    document.getElementsByName(serviceNameField)[0].focus();
	}

  function submitForm(){

	  document.getElementById("ccbrtdate").value=document.getElementById("followupdate").value;
	  document.getElementById("sfabchangedatefield").value=document.getElementById("sfabchangedate").value;
      transactionForm.saveButton.disabled = true;
 		    <%
        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
        out.print(takeOverTransaction(sessionContainerWO,activeUser,"document.transactionForm.submit();"));
	    %>
  }
  calculatescores();
  loadClubfootScores();

</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>