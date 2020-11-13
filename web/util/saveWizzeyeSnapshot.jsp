<%@page import="org.dom4j.*,java.io.*,java.nio.charset.StandardCharsets,org.apache.commons.httpclient.methods.multipart.*,java.nio.file.*,org.apache.commons.io.*,org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*"%>
<%@page import="be.openclinic.system.Encryption,be.mxs.common.util.system.HTMLEntities"%>
<%@include file="/includes/helper.jsp"%>
<%
	String id=request.getParameter("id");
	String user=request.getParameter("user");
	String wizzeyeRoot = SH.cs("wizzeyeserver","https://wizzeye.hnrw.org/room.html").substring(0,SH.cs("wizzeyeserver","https://wizzeye.hnrw.org/room.html").lastIndexOf("/"));
	String objectUrl=wizzeyeRoot+"/getObject.html?id="+id;
	System.out.println("objectUrl = "+objectUrl);
%>
<%=sJSPROTOTYPE %>

The following image was received in OpenClinic:<br/>
<IMG id="receivedimage"/><br/>
<SPAN id='roomid'></SPAN>
<IFRAME style="display:none" id="myiframe" src="<%=objectUrl%>"></iframe>

<script>
	window.onmessage = function(e){
		if(e.data.snapshot){
			document.getElementById("receivedimage").src=e.data.snapshot;
			document.getElementById("roomid").innerHTML="Room = "+e.data.room;
			storeData(e.data.room,e.data.snapshot,"snapshot");
		}
		if(e.data.videorecording){
			storeData(e.data.room,e.data.videorecording,"video");
		}
	};
	
	function storeData(roomid,imagedata,type){
		alert(1);
	  	var url = '<c:url value="/util/storeWizzeyeData.jsp"/>?ts='+<%=getTs()%>;
	  	new Ajax.Request(url,{
	    	method: "POST",
	    	postBody: 'roomid='+roomid+
			      	  '&type='+type+
			      	  '&user=<%=user%>'+
			    	  '&id=<%=id%>'+
		          	  '&imagedata='+imagedata,
	    	onSuccess: function(resp){
	    		alert(2);
	    		//Image was successfully stored, send message back to IFRAME
	    		console.log("Successfully stored "+type+" for room "+roomid+" into OpenClinic database");
	    	}
	  	});
	}
	
</script>
