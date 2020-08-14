<%@page import="be.openclinic.knowledge.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"clinicalassistant","select",activeUser)%>

<form name='transactionForm' method='post'>
	<div id='pharmacyDiv'>&nbsp;</div>
	<div id='ikireziDiv'>&nbsp;</div>
</form>

<script>
	function listatcitems(atccode,encounteruid){
	    openPopup("/curative/getATCSources.jsp&atccode="+atccode+"&encounteruid="+encounteruid+"&ts=<%=getTs()%>",800,400).focus();
	}
	
	function listmissingsigns(id){
	    var url = "<c:url value="/ikirezi/getMissingFindings.jsp"/>?nrz="+id+"&ts="+new Date().getTime();
	    Modalbox.show(url,{title:'<%=getTranNoLink("ikirezi","missingfindings",sWebLanguage)%>',width:400, height:500, beforeHide:function(){if(bChanged){loadIkirezi();}}});
	}
	
	function loadIkirezi(){
		document.getElementById('ikireziDiv').innerHTML="<p/><img height='10px' src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/>&nbsp;&nbsp;<%=getTran(request,"web","analyzing.ikirezi.data",sWebLanguage)%>";
	    var url = "<c:url value=''/>ikirezi/ikireziAssistant.jsp";
	    var params = "";
	    new Ajax.Request(url,{
	      method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
	        document.getElementById("ikireziDiv").innerHTML="<table width='100%'>"+resp.responseText+"</table>";
	      },
		onFailure: function(resp){
        	document.getElementById("ikireziDiv").innerHTML='&nbsp';
	      }
	    });
	}
	
	function loadPharmacy(){
		document.getElementById('pharmacyDiv').innerHTML="<p/><img height='10px' src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/>&nbsp;&nbsp;<%=getTran(request,"web","analyzing.pharmacy.data",sWebLanguage)%>";
	    var url = "<c:url value=''/>ikirezi/pharmacyAssistant.jsp";
	    var params = "";
	    new Ajax.Request(url,{
	      method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
	        document.getElementById("pharmacyDiv").innerHTML="<table width='100%'>"+resp.responseText+"</table>";
	      },
		onFailure: function(resp){
       	document.getElementById("pharmacyDiv").innerHTML='&nbsp';
	      }
	    });
	}
	
	function deleteSymptom(encounteruid,id){
	    if(yesnoDialogDirectText('<%=getTran(request,"web","areyousure",sWebLanguage)%>')){
		    var url = "<c:url value=''/>ikirezi/deleteSymptom.jsp?symptomid="+id+"&encounteruid="+encounteruid;
		    var params = "";
		    new Ajax.Request(url,{
		      method: "POST",
		      parameters: params,
		      onSuccess: function(resp){
		    	  loadIkirezi();
		      },
			onFailure: function(resp){
		      }
		    });
	    }
	}
	
	function addDiagnosis(encounteruid,icd10){
	    if(yesnoDialogDirectText('<%=getTran(request,"web","areyousure",sWebLanguage)%>')){
		    var url = "<c:url value=''/>ikirezi/addDiagnosis.jsp?icd10="+icd10+"&encounteruid="+encounteruid;
		    var params = "";
		    new Ajax.Request(url,{
		      method: "POST",
		      parameters: params,
		      onSuccess: function(resp){
		    	  loadIkirezi();
		      },
			onFailure: function(resp){
		      }
		    });
	    }
	}
	
	function registersymptom(symptom,value){
		<%
			Encounter encounter = Encounter.getActiveEncounter(activePatient.personid);
		%>
	    var url = "<c:url value='/ikirezi/storeSymptom.jsp'/>";
	    var sParams=	"symptom="+symptom+
	    				"&value="+value+
	    				"&encounteruid=<%=encounter==null?"":encounter.getUid()%>";
	    new Ajax.Request(url,{
	      method: "POST",
	      parameters: sParams,
	      onSuccess: function(resp){
	    	  bChanged=true;
	      },
	    });
	}

	function showSDT(id){
		window.open("<c:url value='/popup.jsp?Page=ikirezi/showSDT.jsp'/>&id="+id+"&ts=<%=getTs()%>","SDT","toolbar=no,status=yes,scrollbars=yes,resizable=no,width=600,height=200,menubar=no").moveTo((screen.width - 500) / 2, (screen.height - 200) / 2);
	}
		
	window.setTimeout("loadPharmacy();",500);
	window.setTimeout("loadIkirezi();",500);
</script>