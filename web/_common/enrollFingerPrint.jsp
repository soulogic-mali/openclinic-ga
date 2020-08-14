<%@include file="/includes/validateUser.jsp"%>
<%
	//Clear fingerprint call id
	session.setAttribute("fingerprintid", "");
	session.setAttribute("fingerprintimage", "");
	session.removeAttribute("fingerprintjpg");
	MedwanQuery.setSession(session,new User());
%>

<form name="frmEnrollFingerPrint" method="post">
    <%=writeTableHeader("web","enrollFingerPrint",sWebLanguage)%>
    <table width="100%" class="list" cellspacing="1" cellpadding="0">
        <tr>
            <td class="admin2" nowrap>
                <input type="radio" id="righthand" name="rightleft" value="R" checked/><%=getLabel(request,"web","right",sWebLanguage,"righthand")%>
                <input type="radio" id="lefthand" name="rightleft" value="L"/><%=getLabel(request,"web","left",sWebLanguage,"lefthand")%>
            </td>
            <td class="admin2">
                <select name="finger" class="text">
                    <option value="0"><%=getTranNoLink("web","thumb",sWebLanguage)%></option>
                    <option selected value="1"><%=getTranNoLink("web","index",sWebLanguage)%></option>
                    <option value="2"><%=getTranNoLink("web","middlefinger",sWebLanguage)%></option>
                    <option value="3"><%=getTranNoLink("web","ringfinger",sWebLanguage)%></option>
                    <option value="4"><%=getTranNoLink("web","littlefinger",sWebLanguage)%></option>
                </select>
            </td>
        </tr>
    </table>
    
    <%=ScreenHelper.alignButtonsStart()%>
        <input type="button" class="button" name="enrollButton" value="<%=getTranNoLink("web","read",sWebLanguage)%>" onclick="doRead(true)"/>
        <input type="button" class="button" name="buttonClose" value="<%=getTranNoLink("web","close",sWebLanguage)%>" onclick="window.close()"/>
    <%=ScreenHelper.alignButtonsStop()%>
    
    <table width='100%'>
        <tr>
            <td>
                <table>
                    <tr>
                        <td>
                        	<div name='clock' id='clock'></div>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap>
                        	<label name='readerID' id='readerID'></label>
                        </td>
                    </tr>
                </table>
            </td>
            <td>
                <img width='80px' id='fingerprintImage' name='fingerprintImage' src="<c:url value="/_img/fingerprintImageSmallNoPrint.jpg"/>"/>
            </td>
        </tr>
    </table>
    <br>
</form>
<IFRAME style="display:none" name="hidden-form"></IFRAME>

<script>
	
	var ncounter=0;
	
	function doRead(bInit){
		if(bInit){
		    window.open("<%=sCONTEXTPATH%>/util/startFingerPrintReader.jsp","hidden-form");
			ncounter=0;
		}
		ncounter++;
		document.getElementById("clock").innerHTML="<img src='<%=sCONTEXTPATH%>/_img/themes/default/ajax-loader.gif'/>";
		var r = 'L';
	    if(document.getElementById('righthand').checked){
	        r = 'R';
	    }
	    var parameters= 'rightleft='+r+'&finger='+frmEnrollFingerPrint.finger.value;		
		var url = '<c:url value="/_common/dp/enrollFingerPrintSecugen.jsp"/>?init='+bInit+'&ts='+new Date().getTime();
		new Ajax.Request(url,{
		  	method: "POST",
		  	postBody: parameters,
		  	onSuccess: function(resp){
			    var s=eval('('+resp.responseText+')');
			    if(s.success==1){
				    document.getElementById("clock").innerHTML="";
			    	document.getElementById('readerID').innerHTML = '<h4><%=getTranNoLink("web","enrollment_succeeded",sWebLanguage)%></h4>';
			    	document.getElementById('fingerprintImage').src='<%=sCONTEXTPATH%>/util/getActiveFingerprintJpg.jsp';
			    	window.setTimeout("doDetect()",3000);
			    }
			    else if(s.success==0 || ncounter>10){
				    document.getElementById("clock").innerHTML="";
			    	document.getElementById('readerID').innerHTML = '<h4><%=getTranNoLink("web","enrollment_failed",sWebLanguage)%></h4>';
			    }
			    else{
			    	window.setTimeout("doRead()",1000);
			    }
		  	},
		  	onFailure: function(){
		  		alert("error");
		  	}
		});
	}
	
	function doDetect(){
		document.getElementById('fingerprintImage').src="<c:url value="/_img/fingerprintImageSmallNoPrint.jpg"/>";
		var parameters='';
		var url = '<c:url value="/_common/dp/detectFingerPrintReaderSecugen.jsp"/>?ts='+new Date().getTime();
		new Ajax.Request(url,{
		  	method: "POST",
		  	postBody: parameters,
		  	onSuccess: function(resp){
			    var s=eval('('+resp.responseText+')');
			    if(s.serial!=''){
			    	document.getElementById('readerID').innerHTML = '<%=getTranNoLink("web","fingerprint.reader.detected",sWebLanguage)%>:<br/><b>'+s.serial+"</b>";

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
	
    window.open("<%=sCONTEXTPATH%>/util/initializeFingerPrintReader.jsp","hidden-form");
	doDetect();

</script>