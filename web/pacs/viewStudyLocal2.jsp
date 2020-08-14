<%@page import="be.openclinic.common.OC_Object"%>
<%@ page import="be.mxs.common.util.db.*,be.mxs.common.util.system.*,java.sql.*" %>
<%@include file="/includes/helper.jsp"%>
<%=sJSPROTOTYPE %>
<%
    String server=(request.isSecure()?"https":"http")+"://"+ request.getServerName()+":"+request.getServerPort();
	long sid=new java.util.Date().getTime();
	long oid=new java.util.Random().nextInt();
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("delete from oc_config where oc_key like 'wadouid.%' and updatetime<?");
	ps.setTimestamp(1, new Timestamp(new java.util.Date().getTime()-120000));
	ps.execute();
	ps.close();
	conn.close();
	MedwanQuery.getInstance().reloadConfigValues();
	String wadoid="wadouid."+sid+"."+oid;
	MedwanQuery.getInstance().setConfigString(wadoid, request.getParameter("studyuid")+"@"+request.getParameter("seriesid")+"@"+session.getId());
%>
<IFRAME style="display:none" name="hidden-form" id='hf'></IFRAME>
<script>
	var url='weasis://'+encodeURI('$dicom:get -w <%=server %><%=request.getRequestURI().replaceAll(request.getServletPath(),"")%>/pacs/wadoQuery.jsp?wadouid=<%=wadoid %>');

    <%	
    	session.setAttribute("wadoQueryStarted", "0");
	%>
	document.getElementById('hf').src=url;
	//Check if session value was removed by wado request
	var maxcycles=10;
	var cycles=0;
	
	function checkWeasisStarted(){
	    var params = "";
		var url = '<%=sCONTEXTPATH%>/pacs/testWeasis.jsp';
		new Ajax.Request(url,{
		method: "GET",
		parameters: params,
		onSuccess: function(resp){
	        var label = eval('('+resp.responseText+')');
	        if(label.started=='1'){
	        	window.frameElement.onclick();
	        }
	        else{
	        	cycles++;
	        	if(cycles<maxcycles){
	        		window.setTimeout('checkWeasisStarted();',1000);
	        	}
	        	else{
		        	window.frameElement.onclick();
	        		window.location='<%=sCONTEXTPATH%>/pacs/warnMissingWeasis.jsp';
	        	}
	        }
		}
		});
	}
	
	//checkWeasisStarted();
</script>
