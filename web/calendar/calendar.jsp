<%@include file="/includes/validateUser.jsp"%>
<head>
	<%=sJSFULLCALENDAR %>
	<%=sCSSFULLCALENDAR %>
	<%=sJSPROTOTYPE %>
	
	<%
		if(session.getAttribute("calendarUser")==null){
			session.setAttribute("calendarUser",activeUser.userid);
		}
		if(session.getAttribute("calendarLocation")==null){
			session.setAttribute("calendarLocation","");
		}
	%>

    <script>
	    let clickCnt = 0;
	    let calendarType = 'user';
	    let calendarUser = '<%=session.getAttribute("calendarUser")%>';
	    let calendarLocation = '1';
	    var calendar;
	    var viewType='';
	    
	    <%-- ALERT POPUP --%>
	    function modalPopup(page,width,height,title){
	      if(width==null) width = 266;
	      if(height==null) height = 180;
	      Modalbox.show(page,{title:title,height:height,width:width});
	    }

	    function openPopup(page,width,height,title,parameters){
	        var url = "<c:url value='/popup.jsp'/>?Page="+page;
	        if(width!=undefined) url+= "&PopupWidth="+width;
	        if(height!=undefined) url+= "&PopupHeight="+height;
	        if(title==undefined){
	          if(page.indexOf("&") < 0){
	            title = page.replace("/","_");
	            title = replaceAll(title,".","_");
	          }
	          else{
	            title = replaceAll(page.substring(1,page.indexOf("&")),"/","_");
	            title = replaceAll(title,".","_");
	          }
	        }
	        if(!parameters || parameters.length==0){
	        	parameters="toolbar=no,status=no,scrollbars=no,resizable=no,width=1,height=1,menubar=no";
	        }
	        popup = window.open(url,title,parameters);
	        popup.moveBy(2000,2000);
	        return popup;
		}

	    function fmtDate(date){
	    	return date.getFullYear()+"-"+((date.getMonth()+1)+'').padStart(2,"0")+"-"+(date.getDate()+'').padStart(2,"0")+"T"+(date.getHours()+'').padStart(2,"0")+":"+(date.getMinutes()+'').padStart(2,"0")+":"+(date.getSeconds()+'').padStart(2,"0");
	    }
	    
	    document.addEventListener('DOMContentLoaded', function() {
		    var calendarEl = document.getElementById('calendar');
		    calendar = new FullCalendar.Calendar(calendarEl, {
		    	plugins: [ 'dayGrid','timeGrid','interaction'],
	    	  	customButtons: {
	    		    userButton: {
	    		    	id: 'button1',
	    		      	text: '<%=User.getFullUserName((String)session.getAttribute("calendarUser"))%>',
	    		      	click: function() {
	    		      		calendarType='user',
	    		      		setActiveButton("fc-userButton-button");
	    		      		renderEvents();
	    		      	}
	    		    },
	    		    changeUserButton: {
	    		      	text: '<%=getTranNoLink("web","user",sWebLanguage)%>',
	    		      	click: function() {
	    		      		setActiveButton("fc-changeUserButton-button");
	    		      		changeUser();
	    		      	}
	    		    },
	    		    resourceButton: {
	    		      	text: '<%=getTranNoLink("web","resources",sWebLanguage)%>',
	    		      	click: function() {
	    		      		setActiveButton("fc-resourceButton-button");
	    		      		resourceCalendar();
	    		      	}
	    		    },
		   		    patientButton: {
		   		      	text: '<%=activePatient==null?"":activePatient.getFullName()%>',
		   		      	click: function() {
		   		      		calendarType='patient',
	    		      		setActiveButton("fc-patientButton-button");
		   		      		renderEvents();
		   		      	}
		   		    },
		   		    searchButton: {
		   		      	text: '<%=getTranNoLink("web","find",sWebLanguage)%>',
		   		      	click: function() {
	    		      		setActiveButton("fc-searchButton-button");
		   		      		searchAppointment();
		   		      	}
		   		    },
		   		    dateButton: {
		   		      	text: '<%=ScreenHelper.formatDate(new java.util.Date())%>',
		   		      	click: function() {
	    		      		setActiveButton("fc-dateButton-button");
		   		      		setDate();
		   		      	}
		   		    }
	    		},
		    	allDaySlot: true,
		    	allDayText: '<%=getTranNoLink("web","location",sWebLanguage)%>',
		    	slotDuration: '00:<%=ScreenHelper.padLeft(checkString(activeUser.getParameter("agenda_duration"),"15"),"0",2)%>:00',
		    	defaultView: 'timeGridWeek',
		    	slotLabelFormat:	{
		    		hour: '2-digit',
		    		minute: '2-digit',
		    		omitZeroMinute: false,
		    		meridiem: 'short'
		    	},
		    	  eventTimeFormat: { 
		    		    hour: '2-digit',
		    		    minute: '2-digit',
		    		    meridiem: false
		    	},
		    	eventLimit: 5,
		    	height: 'auto',
		    	contentHeight: 'auto',
		    	datesRender: function(info){
		    		if(info.view.type=='dayGridMonth' && !(info.view.type==viewType)){
		    			calendar.setOption('columnHeaderFormat',{ weekday: 'short' });
		    		}
		    		else if(!(info.view.type==viewType)){
		    			calendar.setOption('columnHeaderFormat',{ weekday: 'short', month: 'numeric', day: 'numeric', omitCommas: true });
		    		}
		    		viewType=info.view.type
	    			setSize();
		    		setToolTips();
		    	},
		    	columnHeaderFormat: { weekday: 'short', day: '2-digit', month: '2-digit'},
		    	minTime: '<%=ScreenHelper.padLeft(checkString(activeUser.getParameter("PlanningFindFrom").split("\\.")[0],"08"),"0",2)%>:<%=activeUser.getParameter("PlanningFindFrom").split("\\.").length<2?"00":ScreenHelper.padLeft(activeUser.getParameter("PlanningFindFrom").split("\\.")[1],"0",2)%>:00',
		    	maxTime: '<%=ScreenHelper.padLeft(checkString(activeUser.getParameter("PlanningFindUntil"),"18").split("\\.")[0],"0",2)%>:<%=activeUser.getParameter("PlanningFindUntil").split("\\.").length<2?"00":ScreenHelper.padLeft(activeUser.getParameter("PlanningFindUntil").split("\\.")[1],"0",2)%>:00',
		    	nowIndicator: true,
		        header:		{
		        	left:   'dateButton',
		            center: 'dayGridMonth,timeGridWeek,timeGridDay userButton <%=activePatient==null?"":"patientButton"%>',
		            right:  'changeUserButton resourceButton today searchButton prev,next'
		        },
		        buttonText:	{
		        	today:    '<%=getTranNoLink("web","today",sWebLanguage)%>',
		            month:    '<%=getTranNoLink("web","month",sWebLanguage)%>',
		            week:     '<%=getTranNoLink("web","week",sWebLanguage)%>',
		            day:      '<%=getTranNoLink("web","day",sWebLanguage)%>'
		        },
		        editable: true,
		        selectable: true,
		        eventResizableFromStart: true,
		        snapDuration: '00:05:00',
		        eventResize: function(info) {
					//Event was resized, update in database
					updateEvent(info.event.id,fmtDate(info.event.start),fmtDate(info.event.end));
		        },
		        select : function(info){
		        	if(info.view.type!='dayGridMonth' && info.end-info.start>300000){
		        		editEvent('',fmtDate(info.start),fmtDate(info.end),calendarType);
		        	}
		        },
		        loading: function(isLoading) {
		            if (!isLoading) {
		            	var cl =calendar.getDate().toISOString().split("T")[0];
		            	cl=cl.split("-")[2]+"/"+cl.split("-")[1]+"/"+cl.split("-")[0];
		            	calendar.getOption('customButtons').dateButton.text=cl;
		            	calendar.render();
		            	setSize();
		            }
		        },
		        dateClick: function(info) {
		        	if(info.view.type!='dayGridMonth'){
		        		if(info.end-info.start>300000){
		        			editEvent('-2',info.dateStr);
		        		}
		        	}
		        	else{
		        		calendar.gotoDate(info.dateStr);
		        		calendar.changeView('timeGridDay');
		        		calendar.render();
				        setActiveButton();
		        	}
		        },
		        eventDrop: function(info) {
					//event drop code goes here
					updateEvent(info.event.id,fmtDate(info.event.start),fmtDate(info.event.end));
		        },
		        eventRender: function (info) {
		            info.el.addEventListener('click', function() {
			        	clickCnt++;         
			            if (clickCnt === 1) {
			            	oneClickTimer = setTimeout(function() {clickCnt = 0;}, 400);
			            } else if (clickCnt === 2) {
			                clearTimeout(oneClickTimer);
			                clickCnt = 0;
							//event double click treatment goes here
							editEvent(info.event.id);
			            }          
			        });
			        setActiveButton();
			    },
			    eventSources: [
			    	{
			    		id: 'main',
				    	url:	'<%=sCONTEXTPATH%>/calendar/showEvents.jsp',
				    	method:	'POST',
				    	extraParams: function() {
			    	      	return {
					    		type: calendarType, 
			    	        };
			    	    }
			    	}
			    ]
		    });
		    calendar.render();
		    calendar.setOption('locale', '<%=sWebLanguage.toLowerCase()%>');
	        setActiveButton();
		});
	
    </script>
</head>
<div id='calendar'></div>
<script>
	function renderEvents(){
		calendar.refetchEvents();
	}
	
	function setSize(){
		var factor = <%=Double.parseDouble(activeUser.getParameter("PlanningFindZoom","60"))/60%>;
    	var elements = document.getElementsByTagName("TR");
    	for(n=0;n<elements.length;n++){
    		element = elements[n];
    		if(element.getAttribute('data-time')){
    			element.style.height=element.offsetHeight*factor;
    		}
    	}
    	var elements = document.getElementsByTagName("A");
    	for(n=0;n<elements.length;n++){
    		element = elements[n];
    		if(element.className.indexOf('fc-time-grid-event')==0){
    			element.style.height=element.offsetHeight*factor;
    			element.style.top=element.offsetTop*factor;
    		}
    	}
	}
	
	function setToolTips(){
    	var elements = document.getElementsByTagName("DIV");
    	for(n=0;n<elements.length;n++){
    		element = elements[n];
    		if(element.className.indexOf('fc-title')==0){
    			if(element.parentElement.tagName=='A'){
            		element.parentElement.title=element.innerHTML;
    			}
    			else if(element.parentElement.parentElement.tagName=='A'){
            		element.parentElement.parentElement.title=element.innerHTML;
    			}
    		}
    	}
    	var elements = document.getElementsByTagName("SPAN");
    	for(n=0;n<elements.length;n++){
    		element = elements[n];
    		if(element.className.indexOf('fc-titleheader')==0){
    			if(element.parentElement.tagName=='A'){
            		element.parentElement.title=element.innerHTML;
    			}
    			else if(element.parentElement.parentElement.tagName=='A'){
            		element.parentElement.parentElement.title=element.innerHTML;
    			}
    		}
    	}
	}
	function updateEvent(id,start,end){
		var url='<%=sCONTEXTPATH%>/calendar/updateEvent.jsp';
		var params="id="+id+"&start="+start+"&end="+end;
		new Ajax.Request(url,{
			method: "POST",
			parameters: params,
			onSuccess: function(resp){
			   	renderEvents();
	        },
	        onError: function(resp){
				alert("error");
	        }
	    });
	}
	
	function updateUser(id){
		var url='<%=sCONTEXTPATH%>/calendar/updateCalendarUser.jsp';
		var params="id="+id;
		new Ajax.Request(url,{
			method: "POST",
			parameters: params,
			onSuccess: function(resp){
		    	var label = eval("("+resp.responseText+")");
		    	calendarType='user';
		    	calendar.getOption('customButtons').userButton.text=label.username;
		    	calendar.render();
		    	renderEvents();
	        },
	        onError: function(resp){
				alert("error");
	        }
	    });
	}
	
	function changeUser(){
	  	var url = "<c:url value="/popup.jsp?Page=_common/search/searchUser.jsp"/>&ts=<%=getTs()%>&PopupWidth=600&PopupHeight=400"+
	              "&FunctionToPerformWithId=updateUser";
	  	window.open(url,"searchUserPopup","height=1,width=1,toolbar=no,status=no,scrollbars=no,resizable=no,menubar=no");
	}
	
	function editEvent(id,start,end,type){
		openPopup('calendar/editEvent.jsp&id='+id+'&begindate='+start+'&enddate='+end+"&calendartype="+type,500,300,'<%=getTranNoLink("web","editappointment",sWebLanguage)%>');
	}
	
	function searchAppointment(){
		openPopup('calendar/searchAppointment.jsp',650,450,'<%=getTranNoLink("web","search",sWebLanguage)%>');
	}
	
	function setDate(){
		openPopup('calendar/setDate.jsp&date='+calendar.getDate().toISOString() ,200,200,'<%=getTranNoLink("web","date",sWebLanguage)%>');
	}
	
	function resourceCalendar(){
		window.location.href='<%=sCONTEXTPATH%>/main.jsp?Page=calendar/resourcecalendar.jsp';
	}
	
	function setActiveButton(){
        var cls="fc-userButton-button";
        if(calendarType=='patient'){
        	cls="fc-patientButton-button";
        }
		var elements = document.getElementsByTagName("button");
		for(n=0;n<elements.length;n++){
			if(elements[n].className.indexOf(cls)>-1) {
				elements[n].style.backgroundColor='red';
			}
			else{
				elements[n].style.backgroundColor='';
			}
		}
	}
</script>
