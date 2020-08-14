<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<logic:present name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="healthRecordVO">
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
    <bean:define id="lastTransaction_biometry" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="lastTransactionTypeBiometry"/>
    <script>
        <%-- VALIDATE WEIGHT --%>
        <%
            int minWeight = 0;
            int maxWeight = 160;

            String weightMsg = getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight.validationerror",sWebLanguage);
            weightMsg = weightMsg.replaceAll("#min#",minWeight+"");
            weightMsg = weightMsg.replaceAll("#max#",maxWeight+"");
        %>
        function validateWeight(weightInput){
          weightInput.value = weightInput.value.replace(",",".");
          if(weightInput.value.length > 0){
            var min = <%=minWeight%>;
            var max = <%=maxWeight%>;

            if(isNaN(weightInput.value) || weightInput.value < min || weightInput.value > max){
              alertDialogDirectText("<%=weightMsg%>");
              //weightInput.value = "";
              weightInput.focus();
            }
          }
        }

        <%-- VALIDATE HEIGHT --%>
        <%
            int minHeight = 20;
            int maxHeight = 220;

            String heightMsg = getTran(request,"Web.Occup","medwan.healthrecord.biometry.height.validationerror",sWebLanguage);
            heightMsg = heightMsg.replaceAll("#min#",minHeight+"");
            heightMsg = heightMsg.replaceAll("#max#",maxHeight+"");
        %>
        function validateHeight(heightInput){
          heightInput.value = heightInput.value.replace(",",".");
          if(heightInput.value.length > 0){
            var min = <%=minHeight%>;
            var max = <%=maxHeight%>;

            if(isNaN(heightInput.value) || heightInput.value < min || heightInput.value > max){
              alertDialogDirectText("<%=heightMsg%>");
              heightInput.focus();
            }
          }
        }

        <%-- CALCULATE BMI --%>
        function calculateBMI(){
          var _BMI = 0;
          var heightInput = document.getElementsByName('currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="itemId"/>]>.value')[0];
          var weightInput = document.getElementsByName('currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="itemId"/>]>.value')[0];

          if(heightInput.value > 0){
            _BMI = (weightInput.value * 10000) / (heightInput.value * heightInput.value);
            if(_BMI > 100 || _BMI < 5){
              document.getElementsByName('BMI')[0].value = "";
            }
            else {
              document.getElementsByName('BMI')[0].value = Math.round(_BMI*10)/10;
            }
            var wfl=(weightInput.value*1/heightInput.value*1);
            if(wfl>0){
          	  document.getElementById('WFL').value = wfl.toFixed(2);
          	  checkWeightForHeight(heightInput.value,weightInput.value);
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
  	    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","light.obesity",sWebLanguage).toUpperCase()%>";
  	    				  document.getElementById("wflinfo").style.display='';
  	    			  }
  	    			  else{
  	    				  document.getElementById("WFL").className="text";
  	    				  document.getElementById("wflinfo").style.display='none';
  	    			  }
  	    		  }
      			  else{
      				  document.getElementById("WFL").className="text";
      				  document.getElementById("wflinfo").style.display='none';
      			  }
  	          },
  	          onFailure: function(){
  	          }
  	      }
  		  );
  	  	}
    </script>
        
	<table class="list" width="100%" border="0" cellspacing="1" cellpadding="0">
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"triage","fase1title",sWebLanguage) %></td>
		</tr>
        <tr>
        	<td class='admin2'>
        		<table width='100%' border="0" cellspacing="1" cellpadding="0">
        			<tr>
			            <td class="admin"><%=getTran(request,"Web.Occup","arrival",sWebLanguage)%></td>
			            <td colspan="3" class="admin2">
			            	<%
		            		if(((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HOUR").length()==0){
		            			((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HOUR").setValue(new SimpleDateFormat("HH").format(new java.util.Date()));
		            		}
		            		if(((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MINUTES").length()==0){
		            			((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MINUTES").setValue(new SimpleDateFormat("mm").format(new java.util.Date()));
		            		}
			            	%>
			                <input type="text" class="text" <%=setRightClick(session,"ITEM_TYPE_HOUR")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HOUR" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HOUR" property="value"/>" "onBlur="isNumber(this)" size="2" maxlength="2"/>:
			                <input type="text" class="text" <%=setRightClick(session,"ITEM_TYPE_MINUTES")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MINUTES" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MINUTES" property="value"/>" onBlur="isNumber(this)" size="2" maxlength="2"/>
			            </td>
        			</tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.frequence-cardiaque",sWebLanguage)%></td>
			            <td class="admin2" colspan="3"><input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="value"/>" onblur="setHF(this);"> /min
			                <input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH")%> type="radio" onDblClick="uncheckRadio(this);" id="sum_r1a" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH" property="itemId"/>]>.value" value="medwan.healthrecord.cardial.regulier" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH;value=medwan.healthrecord.cardial.regulier" property="value" outputString="checked"/>><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.regulier",sWebLanguage,"sum_r1a")%>
			                <input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH")%> type="radio" onDblClick="uncheckRadio(this);" id="sum_r1b" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH" property="itemId"/>]>.value" value="medwan.healthrecord.cardial.irregulier" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH;value=medwan.healthrecord.cardial.irregulier" property="value" outputString="checked"/>><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.irregulier",sWebLanguage,"sum_r1b")%>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.pression-arterielle",sWebLanguage)%></td>
			            <td class="admin2" nowrap>
			        		<table width='100%' border="0" cellspacing="1" cellpadding="0">
			        			<tr>
			        				<td>
						                <%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.bras-droit",sWebLanguage)%>
						            </td>
						            <td>
						                <input id="sbpr" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> /
						                <input id="dbpr" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> mmHg
						            </td>
						        </tr>
			        			<tr>
			        				<td>
						                <%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.bras-gauche",sWebLanguage)%>
						            </td>
						            <td>
						                <input id="sbpl" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT" property="value"/>" onblur="setBP(this,'sbpl','dbpl');"> /
						                <input id="dbpl" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT" property="value"/>" onblur="setBP(this,'sbpl','dbpl');"> mmHg
						            </td>
						        </tr>
						    </table>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"openclinic.chuk","temperature",sWebLanguage)%></td>
			            <td colspan="3" class="admin2">
			                <input id="temperature" type="text" class="text" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="value"/>" onBlur="if(isNumber(this)){if(!checkMinMaxOpen(0,45,this)){alertDialog('Web.Occup','medwan.common.unrealistic-value');}}" size="5"/> °C
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"openclinic.chuk","respiratory.frequency",sWebLanguage)%></td>
			            <td colspan="3" class="admin2">
			                <input id="respfrequency" type="text" class="text" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY" property="value"/>" onBlur="isNumber(this)" size="5"/> /min
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"openclinic.chuk","sao2",sWebLanguage)%></td>
			            <td colspan="3" class="admin2">
			                <input id="sao2" type="text" class="text" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION" property="value"/>" onBlur="isNumber(this)" size="5"/> %
			            </td>
			        </tr>
			        <tr>
			            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_WEIGHT")%> id="weight" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="value"/>" onBlur="validateWeight();calculateBMI();"/></td>
			        </tr>
			        <tr>
			            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.length",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_HEIGHT")%> class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="value"/>" onBlur="validateHeight(this);calculateBMI();"/></td>
			        </tr>
			        <tr>
			            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.bmi",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'><input id="bmi" tabindex="-1" class="text" type="text" size="10" readonly name="BMI"></td>
			        </tr>
			        <tr>
			            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.weightforlength",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'><input tabindex="-1" class="text" type="text" size="4" readonly name="WFL" id="WFL"><img id="wflinfo" style='display: none' src="<c:url value='/_img/icons/icon_info.gif'/>"/></td>
			        </tr>
        		</table>
        	</td>
        	<td class='admin2'>
       			<table width='100%' cellspacing="1" cellpadding="0">
       				<tr>
       					<td width='49%' style='text-align: right;' class='triagelarge'>
       						<table width='100%' cellspacing="1" cellpadding="0">
       							<tr><td><br/><br/></td></tr>
       							<tr>
			       					<td style='text-align: right' class='triagelarge'><%=getTran(request,"web","appearance",sWebLanguage) %></td>
       							</tr>
       							<tr>
       								<td style='text-align: right'>
										<%=getTran(request,"web","looksbad",sWebLanguage) %>?
				                        <input onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE1_LOOKSBAD")%> type="radio" onDblClick="uncheckRadio(this);" id="tr1_lbyes" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE1_LOOKSBAD" property="itemId"/>]>.value" value="medwan.common.yes" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE1_LOOKSBAD;value=medwan.common.yes" property="value" outputString="checked"/>><%=getTran(request,"web","yes",sWebLanguage)%>
				                        <input onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE1_LOOKSBAD")%> type="radio" onDblClick="uncheckRadio(this);" id="tr1_lbno" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE1_LOOKSBAD" property="itemId"/>]>.value" value="medwan.common.no" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE1_LOOKSBAD;value=medwan.common.no" property="value" outputString="checked"/>><%=getTran(request,"web","no",sWebLanguage)%>
       								</td>
       							</tr>
       						</table>
       					</td>
       					<td width='2%'><center><img height='200px' src='<%=sCONTEXTPATH%>/_img/triage.png'/></center></td>
       					<td width='49%' style='text-align: left' class='triagelarge'>
       						<table width='100%' cellspacing="1" cellpadding="0">
       							<tr><td><br/><br/></td></tr>
       							<tr>
			       					<td style='text-align: left' class='triagelarge'><%=getTran(request,"web","respiratoryeffort",sWebLanguage) %></td>
       							</tr>
       							<tr>
       								<td style='text-align: left'>
										<%=getTran(request,"web","tachypnoe",sWebLanguage) %>?
				                        <input onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE1_TACHYPNOE")%> type="radio" onDblClick="uncheckRadio(this);" id="tr1_tpyes" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE1_TACHYPNOE" property="itemId"/>]>.value" value="medwan.common.yes" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE1_TACHYPNOE;value=medwan.common.yes" property="value" outputString="checked"/>><%=getTran(request,"web","yes",sWebLanguage)%>
				                        <input onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE1_TACHYPNOE")%> type="radio" onDblClick="uncheckRadio(this);" id="tr1_tpno" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE1_TACHYPNOE" property="itemId"/>]>.value" value="medwan.common.no" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE1_TACHYPNOE;value=medwan.common.no" property="value" outputString="checked"/>><%=getTran(request,"web","no",sWebLanguage)%>
       								</td>
       							</tr>
       						</table>
       					</td>
       				</tr>
       				<tr>
       					<td/>
       					<td>
       						<table width='100%' cellspacing="1" cellpadding="0">
       							<tr><td><br/><br/></td></tr>
       							<tr>
			       					<td style='text-align: center' class='triagelarge'><%=getTran(request,"web","circulation",sWebLanguage) %></td>
       							</tr>
       							<tr>
       								<td style='text-align: center'>
										<%=getTran(request,"web","coldskin",sWebLanguage) %>?
				                        <input onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE1_COLDSKIN")%> type="radio" onDblClick="uncheckRadio(this);" id="tr1_csyes" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE1_COLDSKIN" property="itemId"/>]>.value" value="medwan.common.yes" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE1_COLDSKIN;value=medwan.common.yes" property="value" outputString="checked"/>><%=getTran(request,"web","yes",sWebLanguage)%>
				                        <input onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE1_COLDSKIN")%> type="radio" onDblClick="uncheckRadio(this);" id="tr1_csno" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE1_COLDSKIN" property="itemId"/>]>.value" value="medwan.common.no" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE1_COLDSKIN;value=medwan.common.no" property="value" outputString="checked"/>><%=getTran(request,"web","no",sWebLanguage)%>
       								</td>
       							</tr>
       						</table>
       					<td/>
       				</tr>
       			</table>
        	</td>
        </tr>
    </table>
</logic:present>
<script>
	calculateBMI();
</script>