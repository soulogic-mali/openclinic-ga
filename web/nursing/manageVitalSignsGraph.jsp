<%@page import="be.openclinic.adt.Encounter.EncounterService"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=sJSCHARTJS%>
<%=sJSEXCANVAS%>
<%
	long second = 1000;
	long minute = 60*second;
	long hour = 60*minute;
	long day = 24*hour;
	java.util.Date dBegin = new java.util.Date(new java.util.Date().getTime()-7*day);
	java.util.Date dEnd = new java.util.Date(ScreenHelper.parseDate(ScreenHelper.formatDate(new java.util.Date())).getTime()+23*hour+59*minute);
	if(request.getParameter("graphBegin")!=null){
		try{
			dBegin = ScreenHelper.parseDate(request.getParameter("graphBegin"));
		}
		catch(Exception e){}
	}
	if(request.getParameter("graphEnd")!=null){
		try{
			dEnd = new java.util.Date(ScreenHelper.parseDate(request.getParameter("graphEnd")).getTime()+23*hour+59*minute);
		}
		catch(Exception e){}
	}
%>
<form name="transactionForm" method="post">
	<table width='100%'>
		<tr class='admin'><td colspan='2'><%=getTran(request,"web","nursinggraph",sWebLanguage) %></td></tr>
		<tr>
			<td class='admin'>
				<%=getTran(request,"web","start",sWebLanguage) %>: <%=ScreenHelper.writeDateField("graphBegin", "transactionForm", ScreenHelper.formatDate(dBegin), true, false, sWebLanguage, sCONTEXTPATH) %>
				&nbsp;&nbsp;<%=getTran(request,"web","end",sWebLanguage) %>: <%=ScreenHelper.writeDateField("graphEnd", "transactionForm", ScreenHelper.formatDate(dEnd), true, false, sWebLanguage, sCONTEXTPATH) %>
				&nbsp;&nbsp;<input class='button' type='submit' name='submitButton' value='<%=getTranNoLink("web","update",sWebLanguage) %>'/>
			</td>
			<td class='admin'>
				<select class='text' name='encounters' id='encounters' onchange='selectActiveEncounter()'>
					<option/>
					<%
						Vector encounters = Encounter.selectEncountersUnique("", "", "", "", "", "", "", "", activePatient.personid, "oc_encounter_begindate DESC");
						for(int n=0;n<encounters.size();n++){
							Encounter encounter = (Encounter)encounters.elementAt(n);
							if(encounter.getUid().split("\\.").length==2){
								Vector encounters2 = Encounter.selectEncounters(encounter.getUid().split("\\.")[0], encounter.getUid().split("\\.")[1], "", "", "", "", "", "", "", "oc_encounter_begindate");
								if(encounters2.size()>0){
									Encounter encounter2 = (Encounter)encounters2.elementAt(0);
									java.util.Date dEncounterEnd = new java.util.Date();
									if(encounter.getEnd()!=null){
										dEncounterEnd=encounter.getEnd();
									}
									boolean bSelected=ScreenHelper.formatDate(encounter.getBegin()).equalsIgnoreCase(ScreenHelper.formatDate(dBegin)) && ScreenHelper.formatDate(dEncounterEnd).equalsIgnoreCase(ScreenHelper.formatDate(dEnd));
									out.print("<option "+(bSelected?"selected":"")+" value='"+ScreenHelper.formatDate(encounter.getBegin())+";"+ScreenHelper.formatDate(dEncounterEnd)+"'>"+ScreenHelper.formatDate(encounter.getBegin())+" - "+ScreenHelper.formatDate(dEncounterEnd)+" ["+getTranNoLink("encountertype",encounter.getType(),sWebLanguage)+"]: "+getTranNoLink("service",encounter2.getServiceUID(),sWebLanguage)+"</option>");
								}
							}
						}
					%>
				</select>
			</td>
		</tr>
		<tr>
			<td><div style="border: 0px solid black; height:200px; width:400px;"><canvas id="diagTemp"></canvas></div></td>
			<td><div style="border: 0px solid black; height:200px; width:400px;"><canvas id="diagBP"></canvas></div></td>
		</tr>
		<tr>
			<td><div style="border: 0px solid black; height:200px; width:400px;"><canvas id="diagHR"></canvas></div></td>
			<td><div style="border: 0px solid black; height:200px; width:400px;"><canvas id="diagRR"></canvas></div></td>
		</tr>
		<tr>
			<td><div style="border: 0px solid black; height:200px; width:400px;"><canvas id="diagWeight"></canvas></div></td>
			<td></td>
		</tr>
	</table>
</form>
<script>
	var temperatureGraph,bloodPressureGraph,heartRateGraph,respiratoryRateGraph,weightGraph;
	Chart.defaults.global.showTooltips = true;
	Chart.defaults.global.scaleOverride = true;
	Chart.defaults.global.scaleSteps = 10;
	Chart.defaults.global.scaleStepWidth = 10;
	Chart.defaults.global.scaleStartValue = -100;
	var second = 1000;
	var minute = 60*second;
	var hour = 60*minute;
	var day = 24*hour;

	window.onload = function(){
		showTemperatureGraph();
		showBloodPressureGraph();
		showHeartRateGraph();
		showRespiratoryRateGraph();
		showWeightGraph();
	}

	function getStartDate(){
		var s = document.getElementById('graphBegin').value;
		var startyear = s.substring(6,11);
		var startmonth = s.substring(3,5)*1-1;
		var startday = s.substring(0,2);
		var startdate = new Date(startyear,startmonth,startday);
		return startdate;
	}

	function getEndDate(){
		var s = document.getElementById('graphEnd').value;
		var endyear = s.substring(6,11);
		var endmonth = s.substring(3,5)*1-1;
		var endday = s.substring(0,2);
		var enddate = new Date(endyear,endmonth,endday,23,59);
		return enddate;
	}

	function showTemperatureGraph(){
		var cannotations = [];
		var ds= [
	   	{
	       	label: '<%=getTranNoLink("web","temperature",sWebLanguage)%>',
            borderColor: 'black',
            borderWidth: 1,
	       	data: [
					<%
						//Load all temperatures in the defined period
						String itemTypes = 	"'be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE',"+
											"'be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TEMPERATURE'";
						Vector data = MedwanQuery.getInstance().getItemsFordPeriod(Integer.parseInt(activePatient.personid), itemTypes, dBegin, dEnd);
						for(int n=0;n<data.size();n++){
							ItemVO itemVO = (ItemVO)data.elementAt(n);
							java.util.Date date = itemVO.getDate();
							try{
								Double value = Double.parseDouble(itemVO.getValue().replaceAll(",", "."));
								out.println("{x: new Date("+new SimpleDateFormat("yyyy").format(date)+","+(Integer.parseInt(new SimpleDateFormat("MM").format(date))-1)+","+new SimpleDateFormat("dd").format(date)+","+new SimpleDateFormat("HH").format(date)+","+new SimpleDateFormat("mm").format(date)+"), y:"+value+"},");
							}
							catch(Exception e){};
						}
					%>
	       	       ]
	   	},
	   	];
		temperatureGraph=drawGraph(temperatureGraph,'diagTemp',35,43,1,cannotations,ds);
	}
	
	function showWeightGraph(){
		var cannotations = [];
		var ds= [
	   	{
	       	label: '<%=getTranNoLink("web","weight",sWebLanguage)%>',
            borderColor: 'black',
            borderWidth: 1,
	       	data: [
					<%
						//Load all weights in the defined period
						itemTypes = 	"'be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT'";
						data = MedwanQuery.getInstance().getItemsFordPeriod(Integer.parseInt(activePatient.personid), itemTypes, dBegin, dEnd);
						for(int n=0;n<data.size();n++){
							ItemVO itemVO = (ItemVO)data.elementAt(n);
							java.util.Date date = itemVO.getDate();
							try{
								Double value = Double.parseDouble(itemVO.getValue().replaceAll(",", "."));
								out.println("{x: new Date("+new SimpleDateFormat("yyyy").format(date)+","+(Integer.parseInt(new SimpleDateFormat("MM").format(date))-1)+","+new SimpleDateFormat("dd").format(date)+","+new SimpleDateFormat("HH").format(date)+","+new SimpleDateFormat("mm").format(date)+"), y:"+value+"},");
							}
							catch(Exception e){};
						}
					%>
	       	       ]
	   	},
	   	];
		maxweight=<%=MedwanQuery.getInstance().getMaximumItemValue(Integer.parseInt(activePatient.personid), itemTypes)%>+1;
		if(maxweight<0){
			maxweight=<%=MedwanQuery.getInstance().getConfigString("nursingGraphMaxWeight","200")%>;
		}
		minweight=<%=MedwanQuery.getInstance().getMinimumItemValue(Integer.parseInt(activePatient.personid), itemTypes)%>-1;
		if(minweight>1000){
			minweight=<%=MedwanQuery.getInstance().getConfigString("nursingGraphMinWeight","0")%>;
		}
		weightGraph=drawGraph(temperatureGraph,'diagWeight',minweight,maxweight,((maxweight-minweight)/10).toFixed(0),cannotations,ds);
	}
	
	function showHeartRateGraph(){
		var cannotations = [];
		var ds= [
	   	{
	       	label: '<%=getTranNoLink("web.occup","medwan.healthrecord.cardial.frequence-cardiaque",sWebLanguage)%>',
            borderColor: 'black',
            borderWidth: 1,
	       	data: [
					<%
						//Load all temperatures in the defined period
						itemTypes = 	"'be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY'";
						data = MedwanQuery.getInstance().getItemsFordPeriod(Integer.parseInt(activePatient.personid), itemTypes, dBegin, dEnd);
						for(int n=0;n<data.size();n++){
							ItemVO itemVO = (ItemVO)data.elementAt(n);
							java.util.Date date = itemVO.getDate();
							try{
								Double value = Double.parseDouble(itemVO.getValue().replaceAll(",", "."));
								out.println("{x: new Date("+new SimpleDateFormat("yyyy").format(date)+","+(Integer.parseInt(new SimpleDateFormat("MM").format(date))-1)+","+new SimpleDateFormat("dd").format(date)+","+new SimpleDateFormat("HH").format(date)+","+new SimpleDateFormat("mm").format(date)+"), y:"+value+"},");
							}
							catch(Exception e){};
						}
					%>
	       	       ]
	   	},
	   	];
		heartRateGraph=drawGraph(heartRateGraph,'diagHR',40,240,20,cannotations,ds);
	}
	
	function showRespiratoryRateGraph(){
		var cannotations = [];
		var ds= [
	   	{
	       	label: '<%=getTranNoLink("openclinic.chuk","respiratory.frequency",sWebLanguage)%>',
            borderColor: 'black',
            borderWidth: 1,
	       	data: [
					<%
						//Load all temperatures in the defined period
						itemTypes = 	"'be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY',"+
											"'be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_RESPIRATORY_FREQUENCY'";
						data = MedwanQuery.getInstance().getItemsFordPeriod(Integer.parseInt(activePatient.personid), itemTypes, dBegin, dEnd);
						for(int n=0;n<data.size();n++){
							ItemVO itemVO = (ItemVO)data.elementAt(n);
							java.util.Date date = itemVO.getDate();
							try{
								Double value = Double.parseDouble(itemVO.getValue().replaceAll(",", "."));
								out.println("{x: new Date("+new SimpleDateFormat("yyyy").format(date)+","+(Integer.parseInt(new SimpleDateFormat("MM").format(date))-1)+","+new SimpleDateFormat("dd").format(date)+","+new SimpleDateFormat("HH").format(date)+","+new SimpleDateFormat("mm").format(date)+"), y:"+value+"},");
							}
							catch(Exception e){};
						}
					%>
	       	       ]
	   	},
	   	];
		respiratoryRateGraph=drawGraph(respiratoryRateGraph,'diagRR',0,50,5,cannotations,ds);
	}
	
	function showBloodPressureGraph(){
		var cannotations = [];
		var ds= [
		 	   	{
			       	label: '<%=getTranNoLink("web","systolic",sWebLanguage)%>',
			       	fill: false,
		     		backgroundColor: 'red',
		            borderColor: 'red',
		            borderWidth: 1,
			       	data: [
							<%
								//Load all temperatures in the defined period
								itemTypes = 	"'be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT',"+
												"'be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT'";
								data = MedwanQuery.getInstance().getItemsFordPeriod(Integer.parseInt(activePatient.personid), itemTypes, dBegin, dEnd);
								for(int n=0;n<data.size();n++){
									ItemVO itemVO = (ItemVO)data.elementAt(n);
									java.util.Date date = itemVO.getDate();
									try{
										Double value = Double.parseDouble(itemVO.getValue().replaceAll(",", "."));
										out.println("{x: new Date("+new SimpleDateFormat("yyyy").format(date)+","+(Integer.parseInt(new SimpleDateFormat("MM").format(date))-1)+","+new SimpleDateFormat("dd").format(date)+","+new SimpleDateFormat("HH").format(date)+","+new SimpleDateFormat("mm").format(date)+"), y:"+value+"},");
									}
									catch(Exception e){};
								}
							%>
			       	       ]
			   	},
			   	{
			       	label: '<%=getTranNoLink("web","diastolic",sWebLanguage)%>',
			       	fill: false,
		     		backgroundColor: 'blue',
		            borderColor: 'blue',
		            borderWidth: 1,
			       	data: [
							<%
								//Load all temperatures in the defined period
								itemTypes = 	"'be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT',"+
												"'be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT'";
								data = MedwanQuery.getInstance().getItemsFordPeriod(Integer.parseInt(activePatient.personid), itemTypes, dBegin, dEnd);
								for(int n=0;n<data.size();n++){
									ItemVO itemVO = (ItemVO)data.elementAt(n);
									java.util.Date date = itemVO.getDate();
									try{
										Double value = Double.parseDouble(itemVO.getValue().replaceAll(",", "."));
										out.println("{x: new Date("+new SimpleDateFormat("yyyy").format(date)+","+(Integer.parseInt(new SimpleDateFormat("MM").format(date))-1)+","+new SimpleDateFormat("dd").format(date)+","+new SimpleDateFormat("HH").format(date)+","+new SimpleDateFormat("mm").format(date)+"), y:"+value+"},");
									}
									catch(Exception e){};
								}
							%>
			       	       ]
			   	},
	   	];
		bloodPressureGraph=drawGraph(bloodPressureGraph,'diagBP',40,240,20,cannotations,ds);
	}
	
	function drawGraph(cChart,canvasid,cMin,cMax,cStep,cAnnotations,dataset){
		var ctx=document.getElementById(canvasid).getContext("2d");
		Chart.defaults.global.defaultFontSize=10;
		maxdate=getEndDate();
		mindate=getStartDate();
		Chart.defaults.global.legend.onClick=function(){};
		cChart = new Chart(ctx, {
		    type: 'line',
		    data: {
		    	datasets: dataset
		    },
		    options: {	
		        legend: {
		            display: true,
		        },
		        scales: {
		        	yAxes: [{
		        		ticks: {
			        		min: cMin,
			        		max: cMax,	
			        		stepSize: cStep,
		        		}
		        	}],
		        	xAxes: [
		    	        	{
		    					type: "time",
		    					display: true,
		    					ticks: {
		    				        autoSkip: true,
		    				        maxTicksLimit: 10
		    				    },
		    					time: {
		    						min: mindate,
		    						max: maxdate,
		    					},
		    				},
					],
		        },
			      annotation: {
			          annotations: cAnnotations,
			          drawTime: "afterDraw" // (default)
			      },
		    },
		});
	}
	
	function selectActiveEncounter(){
		var activeencounteruid=document.getElementById('encounters').value;
		if(activeencounteruid.length>0){
			document.getElementById('graphBegin').value=activeencounteruid.split(";")[0];
			document.getElementById('graphEnd').value=activeencounteruid.split(";")[1];
			transactionForm.submit();
		}
	}
</script>