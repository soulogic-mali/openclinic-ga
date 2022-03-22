<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
<%
	TransactionVO tran = (TransactionVO)transaction;
	tran.initializeLastItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT");
%>
<table width="100%">
	<tr>
		<td width='1%' nowrap><b><%=getTran(request,"openclinic.chuk","temperature",sWebLanguage)%>:</b></td>
		<td width='20%' nowrap><%=SH.writeDefaultNumericInput(session, tran, "[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE", 5,25,50,sWebLanguage) %> °C</td>
		<td width='1%' nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.length",sWebLanguage)%>:</b></td>
		<td width='20%' nowrap><%=SH.writeDefaultNumericInput(session, tran, "ITEM_TYPE_BIOMETRY_HEIGHT", 5,0,250,sWebLanguage,"calculateBMI();") %> cm</td>
		<td width='1%' nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%>:</b></td>
		<td width='20%' nowrap><%=SH.writeDefaultNumericInput(session, tran, "ITEM_TYPE_BIOMETRY_WEIGHT", 5,0,400,sWebLanguage,"calculateBMI();") %> kg</td>
		<td width='1%' nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.bmi",sWebLanguage)%>:</b></td>
		<td nowrap><input id="BMI" class="text" type="text" size="5" name="BMI" readonly /></td>
	</tr>
	<tr>
		<td width='1%' nowrap><b><%=getTran(request,"openclinic.chuk","sao2",sWebLanguage)%>:</b></td>
		<td nowrap><%=SH.writeDefaultNumericInput(session, tran, "[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION", 5,0,100,sWebLanguage) %> %</td>
		<td width='1%' nowrap><b><%=getTran(request,"web","abdomencircumference",sWebLanguage)%>:</b></td>
		<td nowrap><%=SH.writeDefaultNumericInput(session, tran, "ITEM_TYPE_ABDOMENCIRCUMFERENCE", 5,0,200,sWebLanguage) %> cm</td>
		<% if(activePatient.gender.toLowerCase().startsWith("f") && activePatient.getAge()>12){ %>
			<td width='1%' nowrap><b><%=getTran(request,"web","fhr",sWebLanguage)%>:</b></td>
			<td nowrap><%=SH.writeDefaultNumericInput(session, tran, "ITEM_TYPE_FOETAL_HEARTRATE", 5,0,300,sWebLanguage) %> /min</td>
			<td width='1%' nowrap><b><%=getTran(request,"web","armcircumferenceshort",sWebLanguage)%>:</b></td>
			<td nowrap><%=SH.writeDefaultNumericInput(session, tran, "ITEM_TYPE_ARM_CIRCUMFERENCE", 5,0,50,sWebLanguage) %> cm</td>
		<% }else{ %>
			<td width='1%' nowrap><b><%=getTran(request,"web","armcircumferenceshort",sWebLanguage)%>:</b></td>
			<td nowrap>
				<%=SH.writeDefaultNumericInput(session, tran, "ITEM_TYPE_ARM_CIRCUMFERENCE", 5,0,50,sWebLanguage) %> cm
				<%=SH.writeDefaultHiddenInput(tran, "ITEM_TYPE_FOETAL_HEARTRATE") %>
			</td>
			<td colspan='2'>&nbsp;</td>
		<% } %>
	</tr>
	<tr>
		<td nowrap colspan='2'><b><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.pression-arterielle",sWebLanguage)%>:</b></td>
		<td nowrap colspan='2'><b><%=getTran(request,"openclinic.chuk","respiratory.frequency",sWebLanguage)%>:</b></td>
		<td nowrap colspan='2'><b><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.frequence-cardiaque",sWebLanguage)%>:</b></td>
		<td nowrap colspan='2'>
		<% if(activePatient.getAgeInDaysOnDate(tran.getUpdateTime())<1857){ %>
			<table width='100%'>
				<tr>
					<td width='33%' nowrap>
						<b><%=getTran(request,"Web.Occup","medwan.healthrecord.weightforlength",sWebLanguage)%> (Z)</b>
					</td>
					<td width='33%' nowrap>
						<b><%=getTran(request,"Web.Occup","medwan.healthrecord.weightforage",sWebLanguage)%> (Z)</b>
					</td>
					<td width='33%' nowrap>
						<b><%=getTran(request,"Web.Occup","medwan.healthrecord.heightforage",sWebLanguage)%> (Z)</b>
					</td>
				</tr>
			</table>
		<% } %>
		</td>
	</tr>
	<tr>
		<td nowrap colspan='2'><%=SH.writeDefaultNumericInput(session, tran, "ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT", 3,0,300,sWebLanguage, "setBP(this,\"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT\",\"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT\")") %> / <%=SH.writeDefaultNumericInput(session, tran, "ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT", 3,0,300,sWebLanguage, "setBP(this,\"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT\",\"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT\")") %> mmHg</td>
		<td nowrap colspan='2'><%=SH.writeDefaultNumericInput(session, tran, "[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY", 5, 0, 60, sWebLanguage) %> /min</td>
		<td nowrap colspan='2'><%=SH.writeDefaultNumericInput(session, tran, "ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY", 5, 0, 300, sWebLanguage,"setHF(this);") %> /min</td>
		<td nowrap colspan='2'>
		<% if(activePatient.getAgeInDaysOnDate(tran.getUpdateTime())<1857){ %>
			<table width='100%'>
				<tr>
					<td width='33%' nowrap>
						<input tabindex="-1" class="text" type="text" size="4" readonly name="WFL" id="WFL"><img id="wflinfo" style='display: none' src="<c:url value='/_img/icons/icon_info.gif'/>"/>
						<%=SH.writeDefaultHiddenInput(tran, "ITEM_TYPE_WEIGHT4HEIGHT_ZSCORE") %>
					</td>
					<td width='33%' nowrap>
						<input tabindex="-1" class="text" type="text" size="4" readonly name="WFA" id="WFA"><img id="wfainfo" style='display: none' src="<c:url value='/_img/icons/icon_info.gif'/>"/>
						<%=SH.writeDefaultHiddenInput(tran, "ITEM_TYPE_WEIGHT4AGE_ZSCORE") %>
					</td>
					<td width='33%' nowrap>
						<input tabindex="-1" class="text" type="text" size="4" readonly name="HFA" id="HFA"><img id="hfainfo" style='display: none' src="<c:url value='/_img/icons/icon_info.gif'/>"/>
						<%=SH.writeDefaultHiddenInput(tran, "ITEM_TYPE_HEIGHT4AGE_ZSCORE") %>
					</td>
				</tr>
			</table>
		<% }
		   else {
		%>
			<%=SH.writeDefaultHiddenInput(tran, "ITEM_TYPE_WEIGHT4HEIGHT_ZSCORE") %>
			<%=SH.writeDefaultHiddenInput(tran, "ITEM_TYPE_WEIGHT4AGE_ZSCORE") %>
			<%=SH.writeDefaultHiddenInput(tran, "ITEM_TYPE_HEIGHT4AGE_ZSCORE") %>
		<%} %>
		</td>
	</tr>
</table>

<script>
	function calculateBMI(){
	    var _BMI = 0;
	    var heightInput = document.getElementById('ITEM_TYPE_BIOMETRY_HEIGHT');
	    var weightInput = document.getElementById('ITEM_TYPE_BIOMETRY_WEIGHT');
	  	if(document.getElementById('WFL')){
	  		document.getElementById('WFL').value = "";
	  	}

	    if(heightInput.value > 0){
	      	_BMI = (weightInput.value * 10000) / (heightInput.value * heightInput.value);
	      	if (_BMI > 100 || _BMI < 5){
	        	document.getElementsByName('BMI')[0].value = "";
	     	}
	      	else {
	        	document.getElementsByName('BMI')[0].value = Math.round(_BMI*10)/10;
	      	}
	      	if(<%=activePatient.getAgeInDaysOnDate(tran.getUpdateTime())%><1857){
		      	var wfl=(weightInput.value*1/heightInput.value*1);
		      	if(wfl>0){
					document.getElementById("WFL").className="greytext";
					document.getElementById("wflinfo").style.display='none';
		    	  	if(heightInput.value*1>=65){
		    	  		checkWeightForHeight(heightInput.value,weightInput.value);
		    	  	}
		      	}
	    	  	if(weightInput.value*1>0){
	    	  		window.setTimeout("checkWeightForAge("+weightInput.value+");",300);
	    	  	}
	    	  	if(heightInput.value*1>0){
	    	  		window.setTimeout("checkHeightForAge("+heightInput.value+");",600);
	    	  	}
	      	}
	    }
	}
	function checkWeightForHeight(height,weight){
	    var today = new Date();
	    var url= '<c:url value="/ikirezi/getWeightForHeight.jsp"/>?height='+height+'&weight='+weight+'&gender=<%=activePatient.gender%>&ts='+today;
	    new Ajax.Request(url,{
	        method: "POST",
	        postBody: "",
	        onSuccess: function(resp){
	            var label = eval('('+resp.responseText+')');
	            document.getElementById("ITEM_TYPE_WEIGHT4HEIGHT_ZSCORE").value='';
	    		if(label.zindex>-999){
	    			if(label.zindex<-4){
	    				document.getElementById("WFL").className="darkredtext";
	    				document.getElementById("wflinfo").title="Z-index < -4: <%=getTranNoLink("web","severe.malnutrition",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wflinfo").style.display='';
	    			}
	    			else if(label.zindex<-3){
	    				document.getElementById("WFL").className="darkredtext";
	    				document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","severe.malnutrition",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wflinfo").style.display='';
	    			}
	    			else if(label.zindex<-2){
	    				document.getElementById("WFL").className="orangetext";
	    				document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","moderate.malnutrition",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wflinfo").style.display='';
	    			}
	    			else if(label.zindex<-1){
	    				document.getElementById("WFL").className="yellowtext";
	    				document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","light.malnutrition",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wflinfo").style.display='';
	    			}
	    			else if(label.zindex>2){
	    				document.getElementById("WFL").className="orangetext";
	    				document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","obesity",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wflinfo").style.display='';
	    			}
	    			else if(label.zindex>1){
	    				document.getElementById("WFL").className="yellowtext";
	    				 ocument.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","light.obesity",sWebLanguage).toUpperCase()%>";
	    				 ocument.getElementById("wflinfo").style.display='';
	    			}
	    			else{
	    				document.getElementById("WFL").className="text";
	    				document.getElementById("wflinfo").style.display='none';
	    			}
	    			document.getElementById("ITEM_TYPE_WEIGHT4HEIGHT_ZSCORE").value=(label.zindex*1).toFixed(2);
		    	  	document.getElementById("WFL").value = (label.zindex*1).toFixed(2);
	    		}
  			  	else{
  				  	document.getElementById("WFL").className="text";
  				  	document.getElementById("wflinfo").style.display='none';
  			  	}
	        },
	        onFailure: function(){
	        }
	    });
	}
	function checkWeightForAge(weight){
	    var today = new Date();
	    var url= '<c:url value="/ikirezi/getWeightForAge.jsp"/>?age=<%=activePatient.getAgeInDaysOnDate(tran.getUpdateTime())%>&weight='+weight+'&gender=<%=activePatient.gender%>&ts='+today;
	    new Ajax.Request(url,{
	        method: "POST",
	        postBody: "",
	        onSuccess: function(resp){
	            var label = eval('('+resp.responseText+')');
	            document.getElementById("ITEM_TYPE_WEIGHT4AGE_ZSCORE").value='';
	    		if(label.zindex>-999){
	    			if(label.zindex<-4){
	    				document.getElementById("WFA").className="darkredtext";
	    				document.getElementById("wfainfo").title="Z-index < -4: <%=getTranNoLink("web","severe.underweight",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wfainfo").style.display='';
	    			}
	    			else if(label.zindex<-3){
	    				document.getElementById("WFA").className="darkredtext";
	    				document.getElementById("wfainfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","severe.underweight",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wfainfo").style.display='';
	    			}
	    			else if(label.zindex<-2){
	    				document.getElementById("WFA").className="orangetext";
	    				document.getElementById("wfainfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","moderate.underweight",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wfainfo").style.display='';
	    			}
	    			else if(label.zindex<-1){
	    				document.getElementById("WFA").className="yellowtext";
	    				document.getElementById("wfainfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","light.underweight",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wfainfo").style.display='';
	    			}
	    			else if(label.zindex>2){
	    				document.getElementById("WFA").className="orangetext";
	    				document.getElementById("wfainfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","overweight",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wfainfo").style.display='';
	    			}
	    			else if(label.zindex>1){
	    				document.getElementById("WFA").className="yellowtext";
	    				 ocument.getElementById("wfainfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","light.overweight",sWebLanguage).toUpperCase()%>";
	    				 ocument.getElementById("wfainfo").style.display='';
	    			}
	    			else{
	    				document.getElementById("WFA").className="text";
	    				document.getElementById("wfainfo").style.display='none';
	    			}
	    			document.getElementById("ITEM_TYPE_WEIGHT4AGE_ZSCORE").value=(label.zindex*1).toFixed(2);
	    			document.getElementById("WFA").value=(label.zindex*1).toFixed(2);
	    		}
  			  	else{
  				  	document.getElementById("WFA").className="text";
  				  	document.getElementById("wfainfo").style.display='none';
  			  	}
	        },
	        onFailure: function(){
	        }
	    });
	}
	function checkHeightForAge(height){
	    var today = new Date();
	    var url= '<c:url value="/ikirezi/getHeightForAge.jsp"/>?age=<%=activePatient.getAgeInDaysOnDate(tran.getUpdateTime())%>&height='+height+'&gender=<%=activePatient.gender%>&ts='+today;
	    new Ajax.Request(url,{
	        method: "POST",
	        postBody: "",
	        onSuccess: function(resp){
	            var label = eval('('+resp.responseText+')');
	            document.getElementById("ITEM_TYPE_HEIGHT4AGE_ZSCORE").value='';
	    		if(label.zindex>-999){
	    			if(label.zindex<-4){
	    				document.getElementById("HFA").className="darkredtext";
	    				document.getElementById("hfainfo").title="Z-index < -4: <%=getTranNoLink("web","severe.underweight",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("hfainfo").style.display='';
	    			}
	    			else if(label.zindex<-3){
	    				document.getElementById("HFA").className="darkredtext";
	    				document.getElementById("hfainfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","severe.growthretardation",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("hfainfo").style.display='';
	    			}
	    			else if(label.zindex<-2){
	    				document.getElementById("HFA").className="orangetext";
	    				document.getElementById("hfainfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","moderate.growthretardation",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("hfainfo").style.display='';
	    			}
	    			else if(label.zindex<-1){
	    				document.getElementById("HFA").className="yellowtext";
	    				document.getElementById("hfainfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","light.growthretardation",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("hfainfo").style.display='';
	    			}
	    			else if(label.zindex>2){
	    				document.getElementById("HFA").className="orangetext";
	    				document.getElementById("hfainfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","growthadvance",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("hfainfo").style.display='';
	    			}
	    			else if(label.zindex>1){
	    				document.getElementById("HFA").className="yellowtext";
	    				 ocument.getElementById("hfainfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","light.growthadvance",sWebLanguage).toUpperCase()%>";
	    				 ocument.getElementById("hfainfo").style.display='';
	    			}
	    			else{
	    				document.getElementById("HFA").className="text";
	    				document.getElementById("hfainfo").style.display='none';
	    			}
	    			document.getElementById("ITEM_TYPE_HEIGHT4AGE_ZSCORE").value=(label.zindex*1).toFixed(2);
	    			document.getElementById("HFA").value=(label.zindex*1).toFixed(2);
	    		}
  			  	else{
  				  	document.getElementById("HFA").className="text";
  				  	document.getElementById("hfainfo").style.display='none';
  			  	}
	        },
	        onFailure: function(){
	        }
	    });
	}
	function setBP(obj,sbp,dbp){
		if((sbp.length>0)&&(dbp.length>0)){
		    isbp = document.getElementById(sbp).value*1;
		    idbp = document.getElementById(dbp).value*1;
		    if(idbp>isbp){
		      	alertDialog("Web.Occup","error.dbp_greather_than_sbp");
		    }
		}
		return false;
	}
    calculateBMI();
</script>