<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=sJSCHARTJS%>
<%=sJSEXCANVAS%>
<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
<script>
  <%-- ACTIVATE TAB --%>
  function activateTab(iTab){
    document.getElementById('tr1-view').style.display = 'none';
    document.getElementById('tr2-view').style.display = 'none';
    document.getElementById('tr3-view').style.display = 'none';

    td1.className = "tabunselected";
    td2.className = "tabunselected";
    td3.className = "tabunselected";

    if (iTab==1){
      document.getElementById('tr1-view').style.display = '';
      td1.className="tabselected";
    }
    else if (iTab==2){
      document.getElementById('tr2-view').style.display = '';
      td2.className="tabselected";
    }
    else if (iTab==3){
      document.getElementById('tr3-view').style.display = '';
      td3.className="tabselected";
    }
  }
</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab(1)" id="td1" nowrap>&nbsp;<b><%=getTran(request,"web","weightforage",sWebLanguage)+" - "+getTran(request,"web","whogrowthcurves."+activePatient.gender,sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab(2)" id="td2" nowrap>&nbsp;<b><%=getTran(request,"web","lengthforage",sWebLanguage)+" - "+getTran(request,"web","whogrowthcurves."+activePatient.gender,sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab(3)" id="td3" nowrap>&nbsp;<b><%=getTran(request,"web","weightforlength",sWebLanguage)+" - "+getTran(request,"web","whogrowthcurves."+activePatient.gender,sWebLanguage)%></b>&nbsp;</td>
        <td  style='text-align: right' width='*'>
        	<img height='25px' src='<%=sCONTEXTPATH %>/_img/who.png'/>&nbsp;
        </td>
    </tr>
</table>
<%-- HIDEABLE --%>
<table style="vertical-align:top;" width="100%" border="0" cellspacing="0">
    <tr id="tr1-view" style="display:none">
		<td><center><br/><br/><div style="border: 0px solid black; height:200px; width:400px;"><canvas id="weightforage"></canvas></div></center></td>
    </tr>
    <tr id="tr2-view" style="display:none">
		<td><center><br/><br/><div style="border: 0px solid black; height:200px; width:400px;"><canvas id="heightforage"></canvas></div></center></td>
    </tr>
    <tr id="tr3-view" style="display:none">
		<td><center><br/><br/><div style="border: 0px solid black; height:200px; width:400px;"><canvas id="weightforheight"></canvas></div></center></td>
    </tr>
</table>
<%
	java.util.Date dBegin = new java.util.Date(SH.parseDate(activePatient.dateOfBirth).getTime()-10*SH.getTimeDay());
	java.util.Date dEnd = new java.util.Date(new java.util.Date().getTime()+10*SH.getTimeDay());
%>
<script>
	var weightforageGraph,heightforageGraph,weightforheightGraph;
	Chart.defaults.global.tooltips.enabled=false;
	Chart.defaults.global.scaleOverride = true;
	Chart.defaults.global.scaleSteps = 10;
	Chart.defaults.global.scaleStepWidth = 10;
	Chart.defaults.global.scaleStartValue = -100;
	var second = 1000;
	var minute = 60*second;
	var hour = 60*minute;
	var day = 24*hour;
	
	window.onload = function(){
		drawGraphs();
	}
	
	function drawGraphs(){
		showWeightforageGraph();
		showHeightforageGraph();
		showWeightforheightGraph();
	}
	

	function showWeightforageGraph(){
		<%
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		%>
		var cannotations = [];
		var ds= [
		   	{
	            borderColor: 'grey',
	            fill: false,
	            pointRadius: 0,
	            borderWidth: 1,
	            borderDash: [1,2],
		       	data: [
						<%
							double minval=-1,maxval=-1;
							//First get all reference values
							PreparedStatement ps = conn.prepareStatement("select * from oc_growth where type='wfa' and gender=? and x<? order by x");
							ps.setString(1,activePatient.gender);
							ps.setInt(2,new Double((dEnd.getTime()-dBegin.getTime())/SH.getTimeDay()).intValue());
							ResultSet rs = ps.executeQuery();
							while(rs.next()){
								if(minval==-1){
									minval = rs.getDouble("sd3neg");
								}
								if(rs.getInt("x")%10==0){
									java.util.Date date = new java.util.Date(dBegin.getTime()+rs.getInt("x")*SH.getTimeDay());
									out.println("{x: new Date("+new SimpleDateFormat("yyyy").format(date)+","+(Integer.parseInt(new SimpleDateFormat("MM").format(date))-1)+","+new SimpleDateFormat("dd").format(date)+","+new SimpleDateFormat("HH").format(date)+","+new SimpleDateFormat("mm").format(date)+"), y:"+rs.getDouble("SD2neg")+"},");
								}
							}
							rs.close();
							ps.close();
						%>
		       	       ]
		   	},
		   	{
	            borderColor: 'grey',
	            fill: false,
	            pointRadius: 0,
	            borderWidth: 1,
	            borderDash: [1,2],
		       	data: [
						<%
							//First get all reference values
							ps = conn.prepareStatement("select * from oc_growth where type='wfa' and gender=? and x<? order by x");
							ps.setString(1,activePatient.gender);
							ps.setInt(2,new Double((dEnd.getTime()-dBegin.getTime())/SH.getTimeDay()).intValue());
							rs = ps.executeQuery();
							while(rs.next()){
								if(rs.getInt("x")%10==0){
									java.util.Date date = new java.util.Date(dBegin.getTime()+rs.getInt("x")*SH.getTimeDay());
									out.println("{x: new Date("+new SimpleDateFormat("yyyy").format(date)+","+(Integer.parseInt(new SimpleDateFormat("MM").format(date))-1)+","+new SimpleDateFormat("dd").format(date)+","+new SimpleDateFormat("HH").format(date)+","+new SimpleDateFormat("mm").format(date)+"), y:"+rs.getDouble("SD1neg")+"},");
								}
							}
							rs.close();
							ps.close();
						%>
		       	       ]
		   	},
		   	{
	            borderColor: 'green',
	            fill: false,
	            pointRadius: 0,
	            borderWidth: 2,
	            borderDash: [1,2],
		       	data: [
						<%
							//First get all reference values
							ps = conn.prepareStatement("select * from oc_growth where type='wfa' and gender=? and x<? order by x");
							ps.setString(1,activePatient.gender);
							ps.setInt(2,new Double((dEnd.getTime()-dBegin.getTime())/SH.getTimeDay()).intValue());
							rs = ps.executeQuery();
							while(rs.next()){
								if(rs.getInt("x")%10==0){
									java.util.Date date = new java.util.Date(dBegin.getTime()+rs.getInt("x")*SH.getTimeDay());
									out.println("{x: new Date("+new SimpleDateFormat("yyyy").format(date)+","+(Integer.parseInt(new SimpleDateFormat("MM").format(date))-1)+","+new SimpleDateFormat("dd").format(date)+","+new SimpleDateFormat("HH").format(date)+","+new SimpleDateFormat("mm").format(date)+"), y:"+rs.getDouble("SD0")+"},");
								}
							}
							rs.close();
							ps.close();
						%>
		       	       ]
		   	},
		   	{
	            borderColor: 'grey',
	            fill: false,
	            pointRadius: 0,
	            borderWidth: 1,
	            borderDash: [1,2],
		       	data: [
						<%
							//First get all reference values
							ps = conn.prepareStatement("select * from oc_growth where type='wfa' and gender=? and x<? order by x");
							ps.setString(1,activePatient.gender);
							ps.setInt(2,new Double((dEnd.getTime()-dBegin.getTime())/SH.getTimeDay()).intValue());
							rs = ps.executeQuery();
							while(rs.next()){
								if(rs.getInt("x")%10==0){
									java.util.Date date = new java.util.Date(dBegin.getTime()+rs.getInt("x")*SH.getTimeDay());
									out.println("{x: new Date("+new SimpleDateFormat("yyyy").format(date)+","+(Integer.parseInt(new SimpleDateFormat("MM").format(date))-1)+","+new SimpleDateFormat("dd").format(date)+","+new SimpleDateFormat("HH").format(date)+","+new SimpleDateFormat("mm").format(date)+"), y:"+rs.getDouble("SD1")+"},");
								}
							}
							rs.close();
							ps.close();
						%>
		       	       ]
		   	},
		   	{
	            borderColor: 'grey',
	            fill: false,
	            pointRadius: 0,
	            borderWidth: 1,
	            borderDash: [1,2],
		       	data: [
						<%
							//First get all reference values
							ps = conn.prepareStatement("select * from oc_growth where type='wfa' and gender=? and x<? order by x");
							ps.setString(1,activePatient.gender);
							ps.setInt(2,new Double((dEnd.getTime()-dBegin.getTime())/SH.getTimeDay()).intValue());
							rs = ps.executeQuery();
							while(rs.next()){
								maxval = rs.getDouble("sd3");
								if(rs.getInt("x")%10==0){
									java.util.Date date = new java.util.Date(dBegin.getTime()+rs.getInt("x")*SH.getTimeDay());
									out.println("{x: new Date("+new SimpleDateFormat("yyyy").format(date)+","+(Integer.parseInt(new SimpleDateFormat("MM").format(date))-1)+","+new SimpleDateFormat("dd").format(date)+","+new SimpleDateFormat("HH").format(date)+","+new SimpleDateFormat("mm").format(date)+"), y:"+rs.getDouble("SD2")+"},");
								}
							}
							rs.close();
							ps.close();
						%>
		       	       ]
		   	},
		   	//Now add the measurement data
		   	{
	            borderColor: 'darkred',
	            fill: false,
	            pointRadius: 3,
	            borderWidth: 1,
		       	data: [
					<%
						//Load all weights in the defined period
						String itemTypes = 	"'be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_WEIGHT'";
						Vector data = MedwanQuery.getInstance().getItemsFordPeriod(Integer.parseInt(activePatient.personid), itemTypes, dBegin, dEnd);
						for(int n=0;n<data.size();n++){
							ItemVO itemVO = (ItemVO)data.elementAt(n);
							java.util.Date date = itemVO.getDate();
							if(SH.formatDate(date).equalsIgnoreCase(SH.formatDate(((TransactionVO)transaction).getUpdateTime()))){
								try{
									out.println("{x: new Date("+new SimpleDateFormat("yyyy").format(date)+","+(Integer.parseInt(new SimpleDateFormat("MM").format(date))-1)+","+new SimpleDateFormat("dd").format(date)+","+new SimpleDateFormat("HH").format(date)+","+new SimpleDateFormat("mm").format(date)+"), y: document.getElementById('ITEM_TYPE_WEIGHT').value},");
								}
								catch(Exception e){};
							}
							else{
								try{
									Double value = Double.parseDouble(itemVO.getValue().replaceAll(",", "."));
									out.println("{x: new Date("+new SimpleDateFormat("yyyy").format(date)+","+(Integer.parseInt(new SimpleDateFormat("MM").format(date))-1)+","+new SimpleDateFormat("dd").format(date)+","+new SimpleDateFormat("HH").format(date)+","+new SimpleDateFormat("mm").format(date)+"), y:"+value+"},");
								}
								catch(Exception e){};
							}
						}
					%>
	       	       ]
		   	},
	   	];
		weightforageGraph=drawGraph(weightforageGraph,'weightforage',<%=Math.floor(minval)%>,<%=Math.ceil(maxval)%>,<%=Math.floor((Math.ceil(maxval)-Math.floor(minval))/5)%>,cannotations,ds);
	}
	
	function showHeightforageGraph(){
		var cannotations = [];
		var ds= [
		   	{
	            borderColor: 'grey',
	            fill: false,
	            pointRadius: 0,
	            borderWidth: 1,
	            borderDash: [1,2],
		       	data: [
						<%
							minval=-1;
							maxval=-1;
							//First get all reference values
							ps = conn.prepareStatement("select * from oc_growth where type='lfa' and gender=? and x<? order by x");
							ps.setString(1,activePatient.gender);
							ps.setInt(2,new Double((dEnd.getTime()-dBegin.getTime())/SH.getTimeDay()).intValue());
							rs = ps.executeQuery();
							while(rs.next()){
								if(minval==-1){
									minval = rs.getDouble("sd3neg");
								}
								if(rs.getInt("x")%10==0){
									java.util.Date date = new java.util.Date(dBegin.getTime()+rs.getInt("x")*SH.getTimeDay());
									out.println("{x: new Date("+new SimpleDateFormat("yyyy").format(date)+","+(Integer.parseInt(new SimpleDateFormat("MM").format(date))-1)+","+new SimpleDateFormat("dd").format(date)+","+new SimpleDateFormat("HH").format(date)+","+new SimpleDateFormat("mm").format(date)+"), y:"+rs.getDouble("SD2neg")+"},");
								}
							}
							rs.close();
							ps.close();
						%>
		       	       ]
		   	},
		   	{
	            borderColor: 'grey',
	            fill: false,
	            pointRadius: 0,
	            borderWidth: 1,
	            borderDash: [1,2],
		       	data: [
						<%
							//First get all reference values
							ps = conn.prepareStatement("select * from oc_growth where type='lfa' and gender=? and x<? order by x");
							ps.setString(1,activePatient.gender);
							ps.setInt(2,new Double((dEnd.getTime()-dBegin.getTime())/SH.getTimeDay()).intValue());
							rs = ps.executeQuery();
							while(rs.next()){
								if(rs.getInt("x")%10==0){
									java.util.Date date = new java.util.Date(dBegin.getTime()+rs.getInt("x")*SH.getTimeDay());
									out.println("{x: new Date("+new SimpleDateFormat("yyyy").format(date)+","+(Integer.parseInt(new SimpleDateFormat("MM").format(date))-1)+","+new SimpleDateFormat("dd").format(date)+","+new SimpleDateFormat("HH").format(date)+","+new SimpleDateFormat("mm").format(date)+"), y:"+rs.getDouble("SD1neg")+"},");
								}
							}
							rs.close();
							ps.close();
						%>
		       	       ]
		   	},
		   	{
	            borderColor: 'green',
	            fill: false,
	            pointRadius: 0,
	            borderWidth: 2,
	            borderDash: [1,2],
		       	data: [
						<%
							//First get all reference values
							ps = conn.prepareStatement("select * from oc_growth where type='lfa' and gender=? and x<? order by x");
							ps.setString(1,activePatient.gender);
							ps.setInt(2,new Double((dEnd.getTime()-dBegin.getTime())/SH.getTimeDay()).intValue());
							rs = ps.executeQuery();
							while(rs.next()){
								if(rs.getInt("x")%10==0){
									java.util.Date date = new java.util.Date(dBegin.getTime()+rs.getInt("x")*SH.getTimeDay());
									out.println("{x: new Date("+new SimpleDateFormat("yyyy").format(date)+","+(Integer.parseInt(new SimpleDateFormat("MM").format(date))-1)+","+new SimpleDateFormat("dd").format(date)+","+new SimpleDateFormat("HH").format(date)+","+new SimpleDateFormat("mm").format(date)+"), y:"+rs.getDouble("SD0")+"},");
								}
							}
							rs.close();
							ps.close();
						%>
		       	       ]
		   	},
		   	{
	            borderColor: 'grey',
	            fill: false,
	            pointRadius: 0,
	            borderWidth: 1,
	            borderDash: [1,2],
		       	data: [
						<%
							//First get all reference values
							ps = conn.prepareStatement("select * from oc_growth where type='lfa' and gender=? and x<? order by x");
							ps.setString(1,activePatient.gender);
							ps.setInt(2,new Double((dEnd.getTime()-dBegin.getTime())/SH.getTimeDay()).intValue());
							rs = ps.executeQuery();
							while(rs.next()){
								if(rs.getInt("x")%10==0){
									java.util.Date date = new java.util.Date(dBegin.getTime()+rs.getInt("x")*SH.getTimeDay());
									out.println("{x: new Date("+new SimpleDateFormat("yyyy").format(date)+","+(Integer.parseInt(new SimpleDateFormat("MM").format(date))-1)+","+new SimpleDateFormat("dd").format(date)+","+new SimpleDateFormat("HH").format(date)+","+new SimpleDateFormat("mm").format(date)+"), y:"+rs.getDouble("SD1")+"},");
								}
							}
							rs.close();
							ps.close();
						%>
		       	       ]
		   	},
		   	{
	            borderColor: 'grey',
	            fill: false,
	            pointRadius: 0,
	            borderWidth: 1,
	            borderDash: [1,2],
		       	data: [
						<%
							//First get all reference values
							ps = conn.prepareStatement("select * from oc_growth where type='lfa' and gender=? and x<? order by x");
							ps.setString(1,activePatient.gender);
							ps.setInt(2,new Double((dEnd.getTime()-dBegin.getTime())/SH.getTimeDay()).intValue());
							rs = ps.executeQuery();
							while(rs.next()){
								maxval = rs.getDouble("sd3");
								if(rs.getInt("x")%10==0){
									java.util.Date date = new java.util.Date(dBegin.getTime()+rs.getInt("x")*SH.getTimeDay());
									out.println("{x: new Date("+new SimpleDateFormat("yyyy").format(date)+","+(Integer.parseInt(new SimpleDateFormat("MM").format(date))-1)+","+new SimpleDateFormat("dd").format(date)+","+new SimpleDateFormat("HH").format(date)+","+new SimpleDateFormat("mm").format(date)+"), y:"+rs.getDouble("SD2")+"},");
								}
							}
							rs.close();
							ps.close();
						%>
		       	       ]
		   	},
		   	//Now add the measurement data
		   	{
	            borderColor: 'darkred',
	            fill: false,
	            pointRadius: 3,
	            borderWidth: 1,
		       	data: [
					<%
						//Load all weights in the defined period
						itemTypes = 	"'be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HEIGHT'";
						data = MedwanQuery.getInstance().getItemsFordPeriod(Integer.parseInt(activePatient.personid), itemTypes, dBegin, dEnd);
						for(int n=0;n<data.size();n++){
							ItemVO itemVO = (ItemVO)data.elementAt(n);
							java.util.Date date = itemVO.getDate();
							if(SH.formatDate(date).equalsIgnoreCase(SH.formatDate(((TransactionVO)transaction).getUpdateTime()))){
								try{
									out.println("{x: new Date("+new SimpleDateFormat("yyyy").format(date)+","+(Integer.parseInt(new SimpleDateFormat("MM").format(date))-1)+","+new SimpleDateFormat("dd").format(date)+","+new SimpleDateFormat("HH").format(date)+","+new SimpleDateFormat("mm").format(date)+"), y: document.getElementById('ITEM_TYPE_HEIGHT').value},");
								}
								catch(Exception e){};
							}
							else{
								try{
									Double value = Double.parseDouble(itemVO.getValue().replaceAll(",", "."));
									out.println("{x: new Date("+new SimpleDateFormat("yyyy").format(date)+","+(Integer.parseInt(new SimpleDateFormat("MM").format(date))-1)+","+new SimpleDateFormat("dd").format(date)+","+new SimpleDateFormat("HH").format(date)+","+new SimpleDateFormat("mm").format(date)+"), y:"+value+"},");
								}
								catch(Exception e){};
							}
						}
					%>
	       	       ]
		   	},
	   	];
		heightforageGraph=drawGraph(heightforageGraph,'heightforage',<%=Math.floor(minval)%>,<%=Math.ceil(maxval)%>,<%=Math.floor((Math.ceil(maxval)-Math.floor(minval))/5)%>,cannotations,ds);
		<%
			conn.close();
		%>
	}
	
	function showWeightforheightGraph(){
		var cannotations = [];
		var ds= [
		   	//Now add the measurement data
		   	{
	            borderColor: 'darkred',
	            fill: false,
	            pointRadius: 3,
	            borderWidth: 1,
		       	data: [
					<%
						minval=999;
						maxval=-1;
						//Load all weights in the defined period
						itemTypes = "'be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HEIGHT'";
						data = MedwanQuery.getInstance().getItemsFordPeriod(Integer.parseInt(activePatient.personid), itemTypes, dBegin, dEnd);
						for(int n=0;n<data.size();n++){
							ItemVO itemVO = (ItemVO)data.elementAt(n);
							java.util.Date date = itemVO.getDate();
							if(SH.formatDate(date).equalsIgnoreCase(SH.formatDate(((TransactionVO)transaction).getUpdateTime()))){
								try{
									out.println("{x: document.getElementById('ITEM_TYPE_HEIGHT').value, y: document.getElementById('ITEM_TYPE_WEIGHT').value},");
								}
								catch(Exception e){};
							}
							else{
								//Now let's see if we also have a Weight
								itemTypes = "'be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_WEIGHT'";
								Vector weights = MedwanQuery.getInstance().getItemsFordPeriod(Integer.parseInt(activePatient.personid), itemTypes, SH.parseDate(SH.formatDate(itemVO.getDate())), new java.util.Date(SH.parseDate(SH.formatDate(itemVO.getDate())).getTime()+SH.getTimeDay()));
								if(weights.size()>0){
									double length = Double.parseDouble(itemVO.getValue().replaceAll(",", "."));
									if(length<minval){
										minval=length;
									}
									if(length>maxval){
										maxval=length;
									}
									ItemVO weight = (ItemVO)weights.elementAt(0);
									try{
										Double value = Double.parseDouble(weight.getValue().replaceAll(",", "."));
										out.println("{x:"+length+", y:"+value+"},");
									}
									catch(Exception e){};
								}
							}
						}
					%>
	       	       ]
		   	},
		   	<%
		   		if(maxval>=minval){
		   			minval = minval -10;
		   			maxval = maxval +10;
		   	%>
		   	{
	            borderColor: 'grey',
	            fill: false,
	            pointRadius: 0.1,
	            borderWidth: 1,
		       	data: [
						<%
							//First get all reference values
							ps = conn.prepareStatement("select * from oc_growth where type='wfl' and gender=? and x>? and x<? order by x");
							ps.setString(1,activePatient.gender);
							ps.setDouble(2,minval);
							ps.setDouble(3,maxval);
							rs = ps.executeQuery();
							int counter=0;
							while(rs.next()){
								if(counter++%5==0){
									out.println("{x:"+rs.getDouble("x")+", y:"+rs.getDouble("sd2neg")+"},");
								}
							}
							rs.close();
							ps.close();
						%>
		       	       ]
		   	},
		   	{
	            borderColor: 'grey',
	            fill: false,
	            pointRadius: 0.1,
	            borderWidth: 1,
		       	data: [
						<%
							//First get all reference values
							ps = conn.prepareStatement("select * from oc_growth where type='wfl' and gender=? and x>? and x<? order by x");
							ps.setString(1,activePatient.gender);
							ps.setDouble(2,minval);
							ps.setDouble(3,maxval);
							rs = ps.executeQuery();
							counter=0;
							while(rs.next()){
								if(counter++%5==0){
									out.println("{x:"+rs.getDouble("x")+", y:"+rs.getDouble("sd1neg")+"},");
								}
							}
							rs.close();
							ps.close();
						%>
		       	       ]
		   	},
		   	{
	            borderColor: 'green',
	            fill: false,
	            pointRadius: 0.5,
	            borderWidth: 1,
		       	data: [
						<%
							//First get all reference values
							ps = conn.prepareStatement("select * from oc_growth where type='wfl' and gender=? and x>? and x<? order by x");
							ps.setString(1,activePatient.gender);
							ps.setDouble(2,minval);
							ps.setDouble(3,maxval);
							rs = ps.executeQuery();
							counter=0;
							while(rs.next()){
								if(counter++%5==0){
									out.println("{x:"+rs.getDouble("x")+", y:"+rs.getDouble("sd0")+"},");
								}
							}
							rs.close();
							ps.close();
						%>
		       	       ]
		   	},
		   	{
	            borderColor: 'grey',
	            fill: false,
	            pointRadius: 0.1,
	            borderWidth: 1,
		       	data: [
						<%
							//First get all reference values
							ps = conn.prepareStatement("select * from oc_growth where type='wfl' and gender=? and x>? and x<? order by x");
							ps.setString(1,activePatient.gender);
							ps.setDouble(2,minval);
							ps.setDouble(3,maxval);
							rs = ps.executeQuery();
							 counter=0;
							while(rs.next()){
								if(counter++%5==0){
									out.println("{x:"+rs.getDouble("x")+", y:"+rs.getDouble("sd1")+"},");
								}
							}
							rs.close();
							ps.close();
						%>
		       	       ]
		   	},
		   	{
	            borderColor: 'grey',
	            fill: false,
	            pointRadius: 0.1,
	            borderWidth: 1,
		       	data: [
						<%
							//First get all reference values
							ps = conn.prepareStatement("select * from oc_growth where type='wfl' and gender=? and x>? and x<? order by x");
							ps.setString(1,activePatient.gender);
							ps.setDouble(2,minval);
							ps.setDouble(3,maxval);
							rs = ps.executeQuery();
							 counter=0;
							while(rs.next()){
								if(counter++%5==0){
									out.println("{x:"+rs.getDouble("x")+", y:"+rs.getDouble("sd2")+"},");
								}
							}
							rs.close();
							ps.close();
						%>
		       	       ]
		   	},
		   	<%
		   		}
		   	%>
	   	];
		weightforheightGraph=drawGraph2(weightforheightGraph,'weightforheight',<%=Math.floor(minval)%>,<%=Math.ceil(maxval)%>,<%=Math.floor((Math.ceil(maxval)-Math.floor(minval))/5)%>,cannotations,ds);
		<%
			conn.close();
		%>
	}
	
	function drawGraph(cChart,canvasid,cMin,cMax,cStep,cAnnotations,dataset){
		var ctx=document.getElementById(canvasid).getContext("2d");
		Chart.defaults.global.defaultFontSize=10;
		mindate=new Date(<%=new SimpleDateFormat("yyyy,MM,dd").format(dBegin)%>);
		maxdate=new Date(<%=new SimpleDateFormat("yyyy,MM,dd").format(dEnd)%>);
		Chart.defaults.global.legend.onClick=function(){};
		cChart = new Chart(ctx, {
		    type: 'line',
		    data: {
		    	datasets: dataset
		    },
		    options: {	
		        legend: {
		            display: false,
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
	
	function drawGraph2(cChart,canvasid,cMin,cMax,cStep,cAnnotations,dataset){
		var ctx=document.getElementById(canvasid).getContext("2d");
		Chart.defaults.global.defaultFontSize=10;
		Chart.defaults.global.legend.onClick=function(){};
		cChart = new Chart(ctx, {
		    type: 'scatter',
		    data: {
		    	datasets: dataset
		    },
		    options: {	
		        legend: {
		            display: false,
		        },
			      annotation: {
			          annotations: cAnnotations,
			          drawTime: "afterDraw" // (default)
			      },
		    },
		});
	}
	
	activateTab(1);
</script>