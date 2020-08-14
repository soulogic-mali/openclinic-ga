<%@include file="/includes/helper.jsp"%>
<%
	//Clear fingerprint call id
	session.setAttribute("fingerprintid", "");
	session.setAttribute("fingerprintimage", "");
	MedwanQuery.setSession(session,new User());

	//Call local fingerprint reader
	
%>
<head>
    <%=sCSSNORMAL%>
    <%=sJSPROTOTYPE%>
    
    <script>
      window.resizeTo(400,200);
      window.moveTo((self.screen.width-document.body.clientWidth)/2,(self.screen.height-document.body.clientHeight)/2);
    </script>
</head>

<table width='100%'>
	<tr>
		<td>
			<table width='100%'>
				<tr>
					<td>
						<%
							out.print("<img src='"+request.getParameter("referringServer")+"/_img/themes/default/ajax-loader.gif'/>"+
						              "<br><br>"+MedwanQuery.getInstance().getLabel("web","waiting_for_fingerprint","en")+"</br>");
						%>
					</td>
				</tr>
				<tr>
					<td>
						<form name="frmFingerPrint" method="post" action="<c:url value="/_common/readFingerPrint.jsp"/>">
						    <input type="hidden" name="language" value="en"/>
						    <input type="hidden" name="start" value="<%=ScreenHelper.getTs()%>"/>
						    <input type="hidden" name="referringServer" value="<%=request.getParameter("referringServer")%>"/>
						    <label name='readerID' id='readerID'></label>
						</form>
					</td>
				</tr>
			</table>
		</td>
		<td>
			<img width='80px' id='fingerprintImage' name='fingerprintImage' src="<c:url value="/_img/fingerprintImageSmallNoPrint.jpg"/>"/>
		</td>
	</tr>
</table>
<IFRAME style="display:none" name="hidden-form"></IFRAME>

<script>
	var reads=0;

	function doRead(){
		var url = '<c:url value="/_common/dp/readUserFingerPrintSecugen.jsp"/>?ts='+new Date().getTime();
		new Ajax.Request(url,{
		  	method: "POST",
		  	postBody: '',
		  	onSuccess: function(resp){
			    var s=eval('('+resp.responseText+')');
			    if(s.success==1){
		    		document.getElementById("fingerprintImage").src = '<c:url value="/_img/fingerprintImageSmall.jpg"/>';
					selectUser(s.userid,s.password);
			    }
			    else if(s.success==0){
		    		document.getElementById("fingerprintImage").src = '<c:url value="/_img/fingerprintImageSmallWrong.jpg"/>';
			        if(reads<5){
			    		window.open("<%=sCONTEXTPATH%>/util/startFingerPrintReader.jsp","hidden-form");
			    		window.setTimeout("doRead()",1000);
			    		reads++;
			        }
			        else{
			        	window.close();
			        }
		    	}
			    else if(s.success==-99){
		    		document.getElementById("fingerprintImage").src = '<c:url value="/_img/fingerprintImageSmallWrong.jpg"/>';
		    	    window.open("<%=sCONTEXTPATH%>/util/initializeFingerPrintReader.jsp?clear=1","hidden-form");
				    window.setTimeout("doDetect()",1000);
			    }
			    else{
		    		window.setTimeout("doRead()",1000);
			    }
		  	},
		  	onFailure: function(){
	    		document.getElementById("fingerprintImage").src = '<c:url value="/_img/fingerprintImageSmallWrong.jpg"/>';
	    		window.setTimeout("doRead()",1000);
		  	}
		});
	}

	function doDetect(){
		var parameters='';
		document.getElementById("fingerprintImage").src = '<c:url value="/_img/fingerprintImageSmallNoPrint.jpg"/>';
		var url = '<c:url value="/_common/dp/detectFingerPrintReaderSecugen.jsp"/>?ts='+new Date().getTime();
		new Ajax.Request(url,{
		  	method: "POST",
		  	postBody: parameters,
		  	onSuccess: function(resp){
			    var s=eval('('+resp.responseText+')');
			    if(s.serial!=''){
			    	if(s.serial=='-1'){
			    	    window.open("<%=sCONTEXTPATH%>/util/initializeFingerPrintReader.jsp?clear=1","hidden-form");
					    window.setTimeout("doDetect()",1000);
			    	}
			    	else{
				    	document.getElementById('readerID').innerHTML = '<%=getTranNoLink("web","fingerprint.reader.detected","en")%>:<br/><b>'+s.serial+"</b>";
				    	reads=1;
				    	doRead();
				        window.open("<%=sCONTEXTPATH%>/util/startFingerPrintReader.jsp","hidden-form");
			    	}
			    }
			    else{
				    document.getElementById('readerID').innerHTML = '<%=getTranNoLink("web","detecting.reader","en")%>';
				    window.setTimeout("doDetect()",1000);
			    }
		  	},
		  	onFailure: function(){
			    document.getElementById('readerID').innerHTML = '<%=getTranNoLink("web","detecting.reader","en")%>';
			    window.setTimeout("doDetect()",1000);
		  	}
		});
	}
	
	function selectUser(userid,password){
		window.opener.location.href='<c:url value="/checkLogin.jsp"/>?ts=<%=ScreenHelper.getTs()%>&login='+userid+'&auto=true&password='+password;
		window.close();
	}

    window.open("<%=sCONTEXTPATH%>/util/initializeFingerPrintReader.jsp","hidden-form");
	doDetect();
</script>