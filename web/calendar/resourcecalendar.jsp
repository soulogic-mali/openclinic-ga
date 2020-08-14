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
	    let calendarType = 'resource';
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
		    	schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source',
		    	plugins: [ 'resourceTimeline'],
	    	  	customButtons: {
		   		    searchButton: {
		   		      	text: '<%=getTranNoLink("web","find",sWebLanguage)%>',
		   		      	click: function() {
	    		      		setActiveButton("fc-searchButton-button");
		   		      		searchAppointment();
		   		      	}
		   		    },
		   		    appointmentsButton: {
		   		      	text: '<%=getTranNoLink("web.occup","medwan.common.appointments",sWebLanguage)%>',
		   		      	click: function() {
	    		      		setActiveButton("fc-appointmentsButton-button");
		   		      		appointmentsCalendar();
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
		    	allDaySlot: false,
		    	resourceOrder: 'order',
		    	slotDuration: '00:<%=ScreenHelper.padLeft(checkString(activeUser.getParameter("agenda_duration"),"15"),"0",2)%>:00',
		    	defaultView: 'resourceTimelineWeek',
		    	eventLimit: 5,
		    	height: 'auto',
		    	contentHeight: 'auto',
		    	minTime: '<%=ScreenHelper.padLeft(checkString(activeUser.getParameter("PlanningFindFrom").split("\\.")[0],"08"),"0",2)%>:<%=activeUser.getParameter("PlanningFindFrom").split("\\.").length<2?"00":ScreenHelper.padLeft(activeUser.getParameter("PlanningFindFrom").split("\\.")[1],"0",2)%>:00',
		    	maxTime: '<%=ScreenHelper.padLeft(checkString(activeUser.getParameter("PlanningFindUntil"),"18").split("\\.")[0],"0",2)%>:<%=activeUser.getParameter("PlanningFindUntil").split("\\.").length<2?"00":ScreenHelper.padLeft(activeUser.getParameter("PlanningFindUntil").split("\\.")[1],"0",2)%>:00',
		    	nowIndicator: true,
		    	resourcesInitiallyExpanded: true,
		    	resourceLabelText: '<%=getTranNoLink("web","resources",sWebLanguage)%>',
		        header:		{
		        	left:   'dateButton',
		            center: 'resourceTimelineMonth,resourceTimelineWeek,resourceTimelineDay',
		            right:  'appointmentsButton today searchButton prev,next'
		        },
		        buttonText:	{
		        	today:    '<%=getTranNoLink("web","today",sWebLanguage)%>',
		            month:    '<%=getTranNoLink("web","month",sWebLanguage)%>',
		            week:     '<%=getTranNoLink("web","week",sWebLanguage)%>',
		            day:      '<%=getTranNoLink("web","day",sWebLanguage)%>'
		        },
		        editable: false,
		        selectable: false,
		        eventResizableFromStart: true,
		        snapDuration: '00:05:00',
		        loading: function(isLoading) {
		            if (!isLoading) {
		            	var cl =calendar.getDate().toISOString().split("T")[0];
		            	cl=cl.split("-")[2]+"/"+cl.split("-")[1]+"/"+cl.split("-")[0];
		            	calendar.getOption('customButtons').dateButton.text=cl;
		            	calendar.render();
		            }
		        },
		        datesRender: function(info){
		        	if(!(info.view.type==viewType)){
			    		viewType=info.view.type
		    		}
		        	setToolTips(viewType);
		    	},
	    		eventAfterAllRender: function(info){
	    			alert(1);
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
			    resources: '<%=sCONTEXTPATH%>/calendar/showResources.jsp',
			    events: '<%=sCONTEXTPATH%>/calendar/showResourceEvents.jsp?type=resource'
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
	
	function setToolTips(viewType){
    	var elements = document.getElementsByTagName("DIV");
    	for(n=0;n<elements.length;n++){
    		element = elements[n];
    		if(element.className.indexOf('fc-scroller')==0){
    			if(viewType=='resourceTimelineMonth'){
    				element.scrollLeft=element.scrollWidth*(new Date().getDate())/40;
    			}
    			else if(viewType=='resourceTimelineWeek'){
    				element.scrollLeft=element.scrollWidth*(new Date().getDay())/7;
    			}
    		}
    		else if(element.className.indexOf('fc-title')==0){
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
    		if(element.className.indexOf('fc-title')==0){
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
	
	function editEvent(id,start,end,type){
		openPopup('calendar/editEvent.jsp&id='+id+'&begindate='+start+'&enddate='+end+"&calendartype="+type,500,300,'<%=getTranNoLink("web","editappointment",sWebLanguage)%>');
	}
	
	function searchAppointment(){
		openPopup('calendar/searchAppointment.jsp',650,450,'<%=getTranNoLink("web","search",sWebLanguage)%>');
	}
	
	function setDate(){
		openPopup('calendar/setDate.jsp&date='+calendar.getDate().toISOString() ,200,200,'<%=getTranNoLink("web","date",sWebLanguage)%>');
	}
	
	function appointmentsCalendar(){
		window.location.href='<%=sCONTEXTPATH%>/main.jsp?Page=calendar/calendar.jsp';
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
