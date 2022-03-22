<%@page import="java.lang.management.ManagementFactory"%>
<%@page import="be.openclinic.system.SystemInfo"%>
<%@include file="/includes/helper.jsp"%>
<%=sJSVIS %>
<body onresize='drawGraphs(true);'>
<table width='100%'>
	<tr>
		<td colspan='2'>
			<center>
				<font style='color: #4f6199;font-size: 36px;font-weight: bolder'><%=getTran(request,"web","hospitalname",SH.p(request,"language","en")) %></font><br/>
				<font style='color: #4f6199;font-size: 24px;font-weight: bolder'>OpenClinic GA system performance dashboard</font><br/>
				&nbsp;<img src='<%=sCONTEXTPATH%>/_img/block.png' height='1px' id='keepalive'/>
			</center>
		</td>
	</tr>
	<tr>
		<td width='50%'>
			<center><div id='memory_graph'></div>
			<font style='font-size: 24px;font-weight: bolder'>Memory load: <span id='memoryload'></span></font></center>
		</td>
		<td width='50%'>
			<center><div id='users_graph'></div>
			<font style='font-size: 24px;font-weight: bolder'>User load: <span id='usersload'></span></font></center>
		</td>
	</tr>
	<tr>
		<td width='50%'>
			<center><div id='cpu_graph'></div>
			<font style='font-size: 24px;font-weight: bolder'>CPU load: <span id='cpuload'></span></font></center>
		</td>
		<td width='50%'>
			<%if(SH.cs("replicationServer","").length()>0){ %>
				<center><div id='replication_graph'></div>
				<font style='font-size: 24px;font-weight: bolder'>Replication delay: <span id='replicationload'></span></font></center>
			<%} %>
		</td>
	</tr>
</table>
<script>
	var lastcheck = new Date().getTime();
	var lastdashboardcheck = new Date().getTime()-2000;
	var resettime = new Date().getTime(); 
	
	function keepAlive(){
		var size=(new Date().getTime()-lastcheck)/1000;
		document.getElementById('keepalive').style.height=size;
		document.getElementById('keepalive').style.width=size;
		if(new Date().getTime()-lastcheck>10000){
			lastcheck = new Date().getTime();
			resettime = new Date().getTime();
			window.setTimeout("loadDashboardInfo()",500);
		}
		window.setTimeout("keepAlive()",1000);
	}
	function loadDashboardInfo(){
    	var url = '<c:url value="/dashboards/getSystemAdministratorData.jsp"/>';
		localcheck = new Date().getTime();
    	new Ajax.Request(url,{
      		parameters: "",
      		onSuccess: function(resp){
      			if(new Date().getTime()-lastdashboardcheck<2000){
      				return;
      			}
      			else{
      				lastdashboardcheck=new Date().getTime();
      			}
      			lastcheck = new Date().getTime();
       			var info = eval('('+resp.responseText+')');
        		document.getElementById("memoryload").innerHTML="<font style='font-size: 24px;font-weight: bolder'>"+info.memoryload+" MB</font>";
        		document.getElementById("usersload").innerHTML="<font style='font-size: 24px;font-weight: bolder'>"+info.usersload+"</font>";
        		document.getElementById("cpuload").innerHTML="<font style='font-size: 24px;font-weight: bolder'>"+info.cpuload+"%</font>";
    			<%if(SH.cs("replicationServer","").length()>0){ %>
	    			if(info.replicationload.length==0){
	    				info.replicationload="?";
	    			}
	        		document.getElementById("replicationload").innerHTML="<font style='font-size: 24px;font-weight: bolder'>"+info.replicationload+" sec</font>";
				<%} %>

        		var now = vis.moment();
        		memoryDataset.add({
       		    	x: now,
       		    	y: info.memoryload,
       		  	});

        		usersDataset.add({
       		    	x: now,
       		    	y: info.usersload,
       		  	});

        		cpuDataset.add({
       		    	x: now,
       		    	y: info.cpuload,
       		  	});

    			<%if(SH.cs("replicationServer","").length()>0){ %>
					if(info.replicationload!="?"){
						var load = info.replicationload;
						if(load>3600){
							load=3600;
						}
	    				replicationDataset.add({
		       		    	x: now,
		       		    	y: load,
		       		  	});
    				}
				<%} %>

				// remove all data points which are no longer visible
       		  	var range = memoryGraph2d.getWindow();
       		  	var interval = range.end - range.start;
       		  	var oldIds = memoryDataset.getIds({
       		  		filter: function (item) {
       		      		return item.x < range.start - interval;
       		    	},
       			});
        		memoryDataset.remove(oldIds);
        		
       		  	range = usersGraph2d.getWindow();
       		  	interval = range.end - range.start;
       		  	oldIds = usersDataset.getIds({
       		  		filter: function (item) {
       		      		return item.x < range.start - interval;
       		    	},
       			});
        		usersDataset.remove(oldIds);

       		  	range = cpuGraph2d.getWindow();
       		  	interval = range.end - range.start;
       		  	oldIds = cpuDataset.getIds({
       		  		filter: function (item) {
       		      		return item.x < range.start - interval;
       		    	},
       			});
        		cpuDataset.remove(oldIds);

    			<%if(SH.cs("replicationServer","").length()>0){ %>
	       		  	range = replicationGraph2d.getWindow();
	       		  	interval = range.end - range.start;
	       		  	oldIds = replicationDataset.getIds({
	       		  		filter: function (item) {
	       		      		return item.x < range.start - interval;
	       		    	},
	       			});
	        		replicationDataset.remove(oldIds);
				<%} %>
				if(localcheck>resettime){
					window.setTimeout("loadDashboardInfo()",2000);
				}
      		},
      		onError: function(){
      			alert("error");
      		}
    	});
  	}
	
	function renderStep(){
	  	var now = vis.moment();
	  	var range = memoryGraph2d.getWindow();
	  	var interval = range.end - range.start;
	  	memoryGraph2d.setWindow(now - interval, now, { animation: false });

	  	range = usersGraph2d.getWindow();
	  	interval = range.end - range.start;
	  	usersGraph2d.setWindow(now - interval, now, { animation: false });

	  	range = cpuGraph2d.getWindow();
	  	interval = range.end - range.start;
	  	cpuGraph2d.setWindow(now - interval, now, { animation: false });

		<%if(SH.cs("replicationServer","").length()>0){ %>
		  	range = replicationGraph2d.getWindow();
		  	interval = range.end - range.start;
		  	replicationGraph2d.setWindow(now - interval, now, { animation: false });
		<%} %>

		window.setTimeout("renderStep()",2000);
	}
	
	var memoryContainer,usersContainer,cpuContainer,replicationContainer;
	var memoryDataset,usersDataset,cpuDataset,replicationDataset;
	var memoryGraph2d,usersGraph2d,cpuGraph2d,replicationGraph2d;
	
	function drawGraphs(destroy){
		//Memory graph
		if(destroy){
			memoryGraph2d.destroy();
			usersGraph2d.destroy();
			cpuGraph2d.destroy();
			if(replicationGraph2d) replicationGraph2d.destroy();
		}
		memoryContainer = document.getElementById("memory_graph");
		memoryDataset = new vis.DataSet();
		var graphheight=window.innerHeight*0.33;
		var options = {
			start: vis.moment().add(-30, "seconds"), // changed so its faster
			end: vis.moment(),
			height: graphheight,
			width: '90%',
			showMajorLabels: false,
			style: 'line',
			format: {
				minorLabels: {
					second:     'mm:ss',
				},
			},
			dataAxis: {
			    left: {
				    range: {
				        min: 0,
				        max: <%=ManagementFactory.getMemoryMXBean().getHeapMemoryUsage().getMax()*1.1/(1024*1024)%>,
				    },
				    title: {
				    	text: 'Memory in MB',
				    },
			    },
			},
			drawPoints: {
			    style: "circle", // square, circle
			    size: 3,
			},
			shaded: {
			    orientation: "bottom", // top, bottom
			},
		};	
		memoryGraph2d = new vis.Graph2d(memoryContainer, memoryDataset, options);
		
		//Users graph
		usersContainer = document.getElementById("users_graph");
		usersDataset = new vis.DataSet();
		options = {
			start: vis.moment().add(-30, "seconds"), // changed so its faster
			end: vis.moment(),
			height: graphheight,
			width: '90%',
			showMajorLabels: false,
			style: 'line',
			dataAxis: {
			    left: {
				    range: {
				        min: 0,
				        max: 300,
				    },
				    title: {
				    	text: 'Connected users',
				    },
			    },
			},
			drawPoints: {
			    style: "circle", // square, circle
			    size: 3,
			},
			shaded: {
			    orientation: "bottom", // top, bottom
			},
		};	
		usersGraph2d = new vis.Graph2d(usersContainer, usersDataset, options);
		
		//CPU graph
		cpuContainer = document.getElementById("cpu_graph");
		cpuDataset = new vis.DataSet();
		options = {
			start: vis.moment().add(-30, "seconds"), // changed so its faster
			end: vis.moment(),
			height: graphheight,
			width: '90%',
			showMajorLabels: false,
			style: 'line',
			dataAxis: {
			    left: {
				    range: {
				        min: 0,
				        max: 100,
				    },
				    title: {
				    	text: '%CPU Load',
				    },
			    },
			},
			drawPoints: {
			    style: "circle", // square, circle
			    size: 3,
			},
			shaded: {
			    orientation: "bottom", // top, bottom
			},
		};	
		cpuGraph2d = new vis.Graph2d(cpuContainer, cpuDataset, options);
		
		<%if(SH.cs("replicationServer","").length()>0){ %>
			//Replication graph
			replicationContainer = document.getElementById("replication_graph");
			replicationDataset = new vis.DataSet();
			options = {
				start: vis.moment().add(-30, "seconds"), // changed so its faster
				end: vis.moment(),
				height: graphheight,
				width: '90%',
				showMajorLabels: false,
				style: 'line',
				dataAxis: {
				    left: {
					    range: {
					        min: 0,
					        max: 3600,
					    },
					    title: {
					    	text: 'Replication delay',
					    },
				    },
				},
				drawPoints: {
				    style: "circle", // square, circle
				    size: 3,
				},
				shaded: {
				    orientation: "bottom", // top, bottom
				},
			};	
			replicationGraph2d = new vis.Graph2d(replicationContainer, replicationDataset, options);
		<%} %>
	}

	drawGraphs();
	loadDashboardInfo();
	keepAlive();
	renderStep();
	window.setTimeout("window.location.reload()",600000);
	document.body.style.backgroundColor="#fcfcf7";
	window.setTimeout("window.resizeTo(screen.width, screen.height);",500);
</script>

</body>