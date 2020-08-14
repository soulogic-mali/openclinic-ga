<%@include file="/includes/validateUser.jsp"%>
<%=sJSPROTOTYPE%>
<%=sJSNUMBER%>
<%
	//Clear fingerprint call id
	session.setAttribute("fingerprintid", "");
	session.setAttribute("fingerprintimage", "");
	session.removeAttribute("fingerprintjpg");
	MedwanQuery.setSession(session,new User());

	//Call local fingerprint reader
	
%>
<table width='100%'>
	<tr>
		<td>
			<table width='100%'>
				<tr>
					<td>
						<%
							out.print("<span id='loader'><img src='"+request.getParameter("referringServer")+"/_img/themes/"+sUserTheme+"/ajax-loader.gif'/>"+
						              "<br><br>"+MedwanQuery.getInstance().getLabel("web","waiting_for_fingerprint",((User)session.getAttribute("activeUser")).person.language)+"</span></br>");
						%>
					</td>
				</tr>
				<tr>
					<td>
						<form name="frmFingerPrint" method="post" action="<c:url value="/_common/readFingerPrint.jsp"/>">
						    <input type="hidden" name="language" value="<%=((User)session.getAttribute("activeUser")).person.language%>"/>
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
		var url = '<c:url value="/_common/dp/readFingerPrintSecugen.jsp"/>?noverify=1&ts='+new Date().getTime();
		new Ajax.Request(url,{
		  	method: "POST",
		  	postBody: '',
		  	onSuccess: function(resp){
			    var s=eval('('+resp.responseText+')');
			    if(s.success==1){
		    		document.getElementById("fingerprintImage").src = '<c:url value="/util/getActiveFingerprintJpg.jsp"/>';
		    		document.getElementById("loader").style.display='none';
		    		window.setTimeout("doSave()",1000);
			    }
			    else if(s.success==0){
		    		document.getElementById("fingerprintImage").src = '<c:url value="/_img/fingerprintImageSmallWrong.jpg"/>';
			        if(reads<5){
			    		reads++;
			    		window.open("<%=sCONTEXTPATH%>/util/startFingerPrintReader.jsp","hidden-form");
			    		window.setTimeout("doRead()",1000);
			        }
			        else{
			        	window.close();
			        }
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
	
	function doSave(){
		window.opener.document.getElementById("storefingerprint").value="1";
		window.opener.document.getElementById("transactionForm").submit();
		window.close();
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
			    	document.getElementById('readerID').innerHTML = '<%=getTranNoLink("web","fingerprint.reader.detected",sWebLanguage)%>:<br/><b>'+s.serial+"</b>";
			    	reads=1;
			    	doRead();
			        window.open("<%=sCONTEXTPATH%>/util/startFingerPrintReader.jsp","hidden-form");
			    }
			    else{
				    document.getElementById('readerID').innerHTML = '<%=getTranNoLink("web","detecting.reader",sWebLanguage)%>';
				    window.setTimeout("doDetect()",1000);
			    }
		  	},
		  	onFailure: function(){
			    document.getElementById('readerID').innerHTML = '<%=getTranNoLink("web","detecting.reader",sWebLanguage)%>';
			    window.setTimeout("doDetect()",1000);
		  	}
		});
	}
	<%if(checkString(request.getParameter("noread")).equalsIgnoreCase("1")){%>
		window.opener.document.getElementById("storefingerprint").value="2";
		window.opener.document.getElementById("transactionForm").submit();
		window.close();
	<%}
	else{%>
		window.open("<%=sCONTEXTPATH%>/util/initializeFingerPrintReader.jsp","hidden-form");
		doDetect();
	<%}%>
</script>
