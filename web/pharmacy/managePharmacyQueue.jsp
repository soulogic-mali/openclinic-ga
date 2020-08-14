<%@page import="be.openclinic.pharmacy.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
%>
<form id="transactionForm">
	<table width='100%'>
		<tr class='admin'>
			<td>
				<select class='text' name="servicestock" id="servicestock" onchange="loadQueueContent();">
					<%
		                String defaultPharmacy = (String)session.getAttribute("defaultPharmacy");
		                Vector servicestocks = ServiceStock.getStocksByUser(activeUser.userid);
		                
		                ServiceStock stock;
		                for(int n=0; n<servicestocks.size(); n++){
		                    stock = (ServiceStock)servicestocks.elementAt(n);
		                    out.print("<option value='"+stock.getUid()+"' "+(stock.getUid().equals(defaultPharmacy)?"selected":"")+">"+stock.getName().toUpperCase()+"</option>");
		                }
		            %>
				</select>
				<input type='radio' name='unconfirmed' id='unconfirmed' class='text' value='0' checked onclick='loadQueueContent()'/><%=getTran(request,"web","showconfirmed",sWebLanguage) %>
				<input type='radio' name='unconfirmed' id='unconfirmed' class='text' value='1' onclick='loadQueueContent()'/><%=getTran(request,"web","showunconfirmed",sWebLanguage) %>
			</td>
			<td>
				<div id='lastupdate'/>
			</td>
		</tr>
		<tr id='queueContent'/>
	</table>
</form>

<script>
	var myTimeout;
	
	function loadQueueContent(){
		window.clearTimeout(myTimeout);
	    var url = '<c:url value="/pharmacy/getQueueContent.jsp"/>?servicestockuid='+document.getElementById('servicestock').value+'&ts='+new Date();
	    new Ajax.Request(url,{
	      method: "POST",
	      parameters: "unconfirmed="+transactionForm.elements["unconfirmed"].value,
	      onSuccess: function(resp){
            $('queueContent').innerHTML = resp.responseText;
            var date = new Date();
            document.getElementById("lastupdate").innerHTML='<%=getTranNoLink("web","lastupdatetime",sWebLanguage)%>: '+('00'+date.getHours()).slice(-2)+':'+('00'+date.getMinutes()).slice(-2)+':'+('00'+date.getSeconds()).slice(-2);
            myTimeout=window.setTimeout("loadQueueContent()",<%=MedwanQuery.getInstance().getConfigInt("pharmacyQueueRefreshInterval",5000)%>);
	      }
	    });
	}
	
	function deliverProduct(operationuid){
	    var URL = "/pharmacy/deliverQueue.jsp&operationuid="+operationuid;
	    openPopup(URL,400,200,"OpenClinic");
	}
	
	function deleteProduct(listuid){
		if(window.confirm('<%=getTranNoLink("web","areyousuretodelete",sWebLanguage)%>')){
		    var url = '<c:url value="/pharmacy/deleteQueue.jsp"/>?listuid='+listuid+'&ts='+new Date();
		    new Ajax.Request(url,{
		      method: "POST",
		      parameters: "",
		      onSuccess: function(resp){
	        	loadQueueContent();
		      }
		    });
		}
	}
	
	window.setTimeout("loadQueueContent()",500);

	function selectPatient(personid){
		window.opener.location.href='<%=sCONTEXTPATH%>/main.do?Page=curative/index.jsp&PersonID='+personid;
		window.close();
	}
</script>