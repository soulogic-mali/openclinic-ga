<%@page import="be.mxs.common.model.vo.healthrecord.TransactionVO,
                be.mxs.common.model.vo.healthrecord.ItemVO,
                be.openclinic.pharmacy.Product,
                java.text.DecimalFormat,
                be.openclinic.medical.*,
                be.openclinic.system.Transaction,
                be.openclinic.system.Item,
                java.util.*" %>
                
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%=checkPermission(out,"cnrkr.kine", "select",activeUser)%>

<script>
	function selectKeywords(destinationidfield,destinationtextfield,labeltype,divid,titleid,keyid,mousey){	
		var bShowKeywords=true;
		document.getElementById("activeDestinationIdField").value=destinationidfield;
		document.getElementById("activeDestinationTextField").value=destinationtextfield;
		document.getElementById("activeLabeltype").value=labeltype;
		document.getElementById("activeDivld").value=divid;
		
		var allElements = document.getElementsByTagName("*");
		for(n=0;n<allElements.length;n++){
			if(allElements[n].id && allElements[n].id.indexOf("keywords_title")==0){
				allElements[n].style.textDecoration = "none";
			}
			else if(allElements[n].id && allElements[n].id.indexOf("keywords_key")==0){
				allElements[n].width = "16";
			}
		}
	  	if(document.getElementById(titleid) && document.getElementById(keyid)){
	  	    document.getElementById(titleid).style.textDecoration = "underline";
	  	  	document.getElementById(keyid).width = '32';
	  	  	document.getElementById('keywordstd').style = "vertical-align:top";
		}
	    else{
	    	bShowKeywords=false;
	    }
	    
	    if(bShowKeywords){
		    var params = "";
		    var today = new Date();
		    var url = '<c:url value="/healthrecord/ajax/getKeywords.jsp"/>'+
		              '?destinationidfield='+destinationidfield+
		              '&destinationtextfield='+destinationtextfield+
		              '&labeltype='+labeltype+
		              '&ts='+today;
		    new Ajax.Request(url,{
		      method: "POST",
		      parameters: params,
		      onSuccess: function(resp){
		    	  document.getElementById(divid).innerHTML = resp.responseText;
		    	  setPosition(divid);
		      },
		      onFailure: function(){
		    	  document.getElementById(divid).innerHTML = "";
		      }
		    });
	    }
	    else{
	    	document.getElementById(divid).innerHTML = "";
	    }
	}
	
	function setPosition(divid){
		document.getElementById(divid).style.width=(document.getElementById(divid).parentElement.getBoundingClientRect().right-document.getElementById(divid).parentElement.getBoundingClientRect().left)-15;
		document.getElementById(divid).style.position='absolute';
		var topvalue = (document.getElementById("Juist").getBoundingClientRect().top*1)+100;
		var minus = document.getElementById("Juist").scrollTop*1;
		if(minus>100) { minus=100;};
		topvalue = topvalue*1 - minus*1;
		document.getElementById(divid).style.top=topvalue;
	}

  <%-- ADD KEYWORD --%>
  function addKeyword(id,label,destinationidfield,destinationtextfield){
	while(document.getElementById(destinationtextfield).innerHTML.indexOf('&nbsp;')>-1){
		document.getElementById(destinationtextfield).innerHTML=document.getElementById(destinationtextfield).innerHTML.replace('&nbsp;','');
	}
	var ids = document.getElementById(destinationidfield).value;
	if((ids+";").indexOf(id+";")<=-1){
	  document.getElementById(destinationidfield).value = ids+";"+id;
	  
	  if(document.getElementById(destinationtextfield).innerHTML.length > 0){
		if(!document.getElementById(destinationtextfield).innerHTML.endsWith("| ")){
          document.getElementById(destinationtextfield).innerHTML+= " | ";
	    }
	  }
	  
	  document.getElementById(destinationtextfield).innerHTML+= "<span style='white-space: nowrap;'><a href='javascript:deleteKeyword(\""+destinationidfield+"\",\""+destinationtextfield+"\",\""+id+"\");'><img width='8' src='<c:url value="/_img/themes/default/erase.png"/>' class='link' style='vertical-align:-1px'/></a> <b>"+label+"</b></span> | ";
	}
  }

  function storekeywordsubtype(s){
    var params = "";
    var today = new Date();
    var url = '<c:url value="/healthrecord/ajax/storeKeywordSubtype.jsp"/>'+
              '?subtype='+s;
    new Ajax.Request(url,{
      method: "POST",
      parameters: params,
      onSuccess: function(resp){
    	  selectKeywords(document.getElementById("activeDestinationIdField").value,
    			  document.getElementById("activeDestinationTextField").value,
    			  document.getElementById("activeLabeltype").value,
    			  document.getElementById("activeDivld").value);
      },
      onFailure: function(){
      }
    });
  }

  <%-- DELETE KEYWORD --%>
  function deleteKeywordCoded(kw){
	  destinationidfield=kw.split("\~")[0];
	  destinationtextfield=kw.split("\~")[1];
	  id=kw.split("\~")[2];
	  keyname=kw.split("\~")[3];
	  
		var newids = "";
		var ids = document.getElementById(destinationidfield).value.split(";");
		for(n=0; n<ids.length; n++){
		  if(ids[n].indexOf("$")>-1){
			if(id!=ids[n]){
			  newids+= ids[n]+";";
			}
		  }
		}
		
		document.getElementById(destinationidfield).value = newids;
		var newlabels = "";
		var labels = document.getElementById(destinationtextfield).innerHTML.split(" | ");
	    for(n=0;n<labels.length;n++){
		  if(labels[n].trim().length>0 && labels[n].indexOf(keyname)<=-1){
		    newlabels+=labels[n]+" | ";
		  }
		}
	    
		document.getElementById(destinationtextfield).innerHTML = newlabels;
  }

  function deleteKeyword(destinationidfield,destinationtextfield,id){
	var newids = "";
	var ids = document.getElementById(destinationidfield).value.split(";");
	for(n=0; n<ids.length; n++){
	  if(ids[n].indexOf("$")>-1){
		if(id!=ids[n]){
		  newids+= ids[n]+";";
		}
	  }
	}
	
	document.getElementById(destinationidfield).value = newids;
	var newlabels = "";
	var labels = document.getElementById(destinationtextfield).innerHTML.split(" | ");
    for(n=0;n<labels.length;n++){
	  if(labels[n].trim().length>0 && labels[n].indexOf(id)<=-1){
	    newlabels+=labels[n]+" | ";
	  }
	}
    
	document.getElementById(destinationtextfield).innerHTML = newlabels;	
  }


	<%-- ACTIVATE TAB --%>
  function activateTab(iTab){
    if(document.getElementById('tr1-view')) document.getElementById('tr1-view').style.display = 'none';
    if(document.getElementById('tr2-view')) document.getElementById('tr2-view').style.display = 'none';
    if(document.getElementById('tr3-view')) document.getElementById('tr3-view').style.display = 'none';
    if(document.getElementById('tr4-view')) document.getElementById('tr4-view').style.display = 'none';
    if(document.getElementById('tr5-view')) document.getElementById('tr5-view').style.display = 'none';
    if(document.getElementById('tr6-view')) document.getElementById('tr6-view').style.display = 'none';
    if(document.getElementById('tr7-view')) document.getElementById('tr7-view').style.display = 'none';
    if(document.getElementById('tr8-view')) document.getElementById('tr8-view').style.display = 'none';
    if(document.getElementById('tr9-view')) document.getElementById('tr9-view').style.display = 'none';

    if(document.getElementById('td1')) document.getElementById('td1').className = "tabunselected";
    if(document.getElementById('td2')) document.getElementById('td2').className = "tabunselected";
    if(document.getElementById('td3')) document.getElementById('td3').className = "tabunselected";
    if(document.getElementById('td4')) document.getElementById('td4').className = "tabunselected";
    if(document.getElementById('td5')) document.getElementById('td5').className = "tabunselected";
    if(document.getElementById('td6')) document.getElementById('td6').className = "tabunselected";
    if(document.getElementById('td7')) document.getElementById('td7').className = "tabunselected";
    if(document.getElementById('td8')) document.getElementById('td8').className = "tabunselected";
    if(document.getElementById('td9')) document.getElementById('td9').className = "tabunselected";

    if (iTab==1){
      document.getElementById('tr1-view').style.display = '';
      document.getElementById('td1').className="tabselected";
      resizeContentPane();
    }
    else if (iTab==2){
        document.getElementById('tr2-view').style.display = '';
        document.getElementById('td2').className="tabselected";
        resizeContentPane();
      }
    else if (iTab==3){
        document.getElementById('tr3-view').style.display = '';
        document.getElementById('td3').className="tabselected";
        resizeContentPane();
      }
    else if (iTab==4){
        document.getElementById('tr4-view').style.display = '';
        document.getElementById('td4').className="tabselected";
        resizeContentPane();
      }
    else if (iTab==5){
    	loadAssessment(true);
      }
    else if (iTab==6){
    	loadTests(true);
      }
    else if (iTab==7){
        document.getElementById('tr7-view').style.display = '';
        document.getElementById('td7').className="tabselected";
        resizeContentPane();
      }
    else if (iTab==8){
        document.getElementById('tr8-view').style.display = '';
        document.getElementById('td8').className="tabselected";
        resizeContentPane();
      }
    else if (iTab==9){
        document.getElementById('tr9-view').style.display = '';
        document.getElementById('td9').className="tabselected";
        resizeContentPane();
      }
  }
  
  function activateTab2(iTab){
    if(document.getElementById('tr11-view')) document.getElementById('tr11-view').style.display = 'none';
    if(document.getElementById('tr12-view')) document.getElementById('tr12-view').style.display = 'none';
    if(document.getElementById('tr13-view')) document.getElementById('tr13-view').style.display = 'none';
    if(document.getElementById('tr14-view')) document.getElementById('tr14-view').style.display = 'none';
    if(document.getElementById('tr15-view')) document.getElementById('tr15-view').style.display = 'none';
    if(document.getElementById('tr16-view')) document.getElementById('tr16-view').style.display = 'none';
    if(document.getElementById('tr17-view')) document.getElementById('tr17-view').style.display = 'none';
    if(document.getElementById('tr18-view')) document.getElementById('tr18-view').style.display = 'none';
    if(document.getElementById('tr19-view')) document.getElementById('tr19-view').style.display = 'none';
    if(document.getElementById('tr20-view')) document.getElementById('tr20-view').style.display = 'none';

    if(document.getElementById('td11')) document.getElementById('td11').className = "tabunselected";
    if(document.getElementById('td12')) document.getElementById('td12').className = "tabunselected";
    if(document.getElementById('td13')) document.getElementById('td13').className = "tabunselected";
    if(document.getElementById('td14')) document.getElementById('td14').className = "tabunselected";
    if(document.getElementById('td15')) document.getElementById('td15').className = "tabunselected";
    if(document.getElementById('td16')) document.getElementById('td16').className = "tabunselected";
    if(document.getElementById('td17')) document.getElementById('td17').className = "tabunselected";
    if(document.getElementById('td18')) document.getElementById('td18').className = "tabunselected";
    if(document.getElementById('td19')) document.getElementById('td19').className = "tabunselected";
    if(document.getElementById('td20')) document.getElementById('td20').className = "tabunselected";

    if (iTab==11){
      document.getElementById('tr11-view').style.display = '';
      document.getElementById('td11').className="tabselected";
      resizeContentPane();
    }
    else if (iTab==12){
        document.getElementById('tr12-view').style.display = '';
        document.getElementById('td12').className="tabselected";
        resizeContentPane();
      }
    else if (iTab==13){
        document.getElementById('tr13-view').style.display = '';
        document.getElementById('td13').className="tabselected";
        resizeContentPane();
      }
    else if (iTab==14){
        document.getElementById('tr14-view').style.display = '';
        document.getElementById('td14').className="tabselected";
        resizeContentPane();
      }
    else if (iTab==15){
        document.getElementById('tr15-view').style.display = '';
        document.getElementById('td15').className="tabselected";
        resizeContentPane();
      }
    else if (iTab==16){
        document.getElementById('tr16-view').style.display = '';
        document.getElementById('td16').className="tabselected";
        resizeContentPane();
      }
    else if (iTab==17){
        document.getElementById('tr17-view').style.display = '';
        document.getElementById('td17').className="tabselected";
        resizeContentPane();
      }
    else if (iTab==18){
        document.getElementById('tr18-view').style.display = '';
        document.getElementById('td18').className="tabselected";
        resizeContentPane();
      }
    else if (iTab==19){
        document.getElementById('tr19-view').style.display = '';
        document.getElementById('td19').className="tabselected";
        resizeContentPane();
      }
    else if (iTab==20){
        document.getElementById('tr20-view').style.display = '';
        document.getElementById('td20').className="tabselected";
        resizeContentPane();
      }
  }

  	function resizeContentPane(pane){
	  	if(document.getElementById("Juist").clientHeight>0){
		  	document.getElementById("contentpane").width=document.getElementById("Juist").clientWidth; 
	  	}
  	}
  	
  	function collapseTestIfComplete(testid){
  		if(document.getElementById("test."+testid) && document.getElementById("ITEM_TYPE_CNRKR_KINE_TEST_"+testid+"_TOTAL") && document.getElementById("ITEM_TYPE_CNRKR_KINE_TEST_"+testid+"_TOTAL").value*1>0){
  			document.getElementById("test."+testid).style.display='none';
  			document.getElementById("test."+testid+".img").src='<%=sCONTEXTPATH%>/_img/treemenu/plus.gif';
  		}
  		setTestIcon(testid);
  	}
  	
  	function setTestIcon(testid){
  		if(document.getElementById("test."+testid) && document.getElementById("ITEM_TYPE_CNRKR_KINE_TEST_"+testid+"_TOTAL") && document.getElementById("ITEM_TYPE_CNRKR_KINE_TEST_"+testid+"_TOTAL").value*1>0){
  			if(document.getElementById("test."+testid+".complete")){
  				document.getElementById("test."+testid+".complete").src='<%=sCONTEXTPATH%>/_img/icons/mobile/check.png';
  			}
  		}
  		else{
  			if(document.getElementById("test."+testid+".complete")){
  				document.getElementById("test."+testid+".complete").src='<%=sCONTEXTPATH%>/_img/icons/mobile/checklist.png';
  			}
  		}
  	}
  	
  	function toggleTest(testid){
  		if(document.getElementById(testid)){
  	  		if(document.getElementById(testid).style.display=='none'){
  	  			document.getElementById(testid).style.display='';
  	  			document.getElementById(testid+".img").src='<%=sCONTEXTPATH%>/_img/treemenu/minus.gif';
  	  		}
  	  		else {
  	  			document.getElementById(testid).style.display='none';
  	  			document.getElementById(testid+".img").src='<%=sCONTEXTPATH%>/_img/treemenu/plus.gif';
  	  		}
  		}
  	}
  	
  	function calculateTestScores(){
  		calculatePASS();
  		calculateACTIVLIM();
  		calculateMMSE();
  		calculateBBS();
  		calculateABILHAND();
  		calculateABILOCO();
  		calculateSTARTBACK();
  		calculateEIFEL();
  		calculateOSWESTRY();
  		calculateTampaEKT();
  		calculateKOOS();
  		calculateHOOS();
  		calculateSF36();
  	}
  	
  	function collapseTests(){
  		collapseTestIfComplete("PASS");
  		collapseTestIfComplete("ACTIVLIM");
  		collapseTestIfComplete("MMSE");
  		collapseTestIfComplete("BBS");
  		collapseTestIfComplete("ABILHAND");
  		collapseTestIfComplete("ABILOCO");
  		collapseTestIfComplete("STARTBACK");
  		collapseTestIfComplete("EIFEL");
  		collapseTestIfComplete("OSWESTRY");
  		collapseTestIfComplete("TAMPAEKT");
  		collapseTestIfComplete("KOOS");
  		collapseTestIfComplete("HOOS");
  		collapseTestIfComplete("SF36");
  	}
  	
  	function calculatePASS(){
  		if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_PASS_TOTAL')){
	  		var score = 0;
	  		var subscore = 0;
	  		for(n=1;n<13;n++){
	  			if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_PASS_'+n) && document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_PASS_'+n).value.length>0){
	  				score = score + document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_PASS_'+n).value*1;
	  				subscore = subscore + document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_PASS_'+n).value*1;
	  			}
	  			else{
	  				score=0;
	  				subscore=0;
	  				document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_PASS_TOTAL1').value=subscore;
	  				break;
	  			}
	  			if(n==7){
	  				document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_PASS_TOTAL1').style.textAlign='center';
	  				document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_PASS_TOTAL1').value=subscore;
	  				subscore=0;
	  			}
	  		}
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_PASS_TOTAL2').style.textAlign='center';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_PASS_TOTAL2').value=subscore;
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_PASS_TOTAL').style.textAlign='center';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_PASS_TOTAL').style.height='20';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_PASS_TOTAL').style.fontSize='14px';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_PASS_TOTAL').style.fontWeight='bolder';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_PASS_TOTAL').value=score;
  		}
  		setTestIcon("PASS");
  	}

  	function calculateEIFEL(){
  		if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_TOTAL')){
	  		var score = 0;
	  		for(n=1;n<25;n++){
	  			if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_'+n) && document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_'+n).value.length>0){
	  				score = score + document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_'+n).value*1;
	  			}
	  			else{
	  				score=0;
	  				break;
	  			}
	  		}
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_TOTAL').style.textAlign='center';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_TOTAL').style.height='20';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_TOTAL').style.fontSize='14px';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_TOTAL').style.fontWeight='bolder';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_TOTAL').value=score;
  		}
  		setTestIcon("EIFEL");
  	}

  	function calculateTampaEKT(){
  		if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_TOTAL')){
	  		var score = 0;
	  		for(n=1;n<18;n++){
	  			if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_'+n) && document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_'+n).value.length>0){
	  				score = score + document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_'+n).value*1;
	  			}
	  			else{
	  				score=0;
	  				break;
	  			}
	  		}
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_TOTAL').style.textAlign='center';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_TOTAL').style.height='20';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_TOTAL').style.fontSize='14px';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_TOTAL').style.fontWeight='bolder';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_TOTAL').value=score;
  		}
  		setTestIcon("TAMPAEKT");
  	}

  	function calculateKOOS(){
  		if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_KOOS_TOTAL')){
	  		var score = 0;
	  		for(n=1;n<43;n++){
	  			if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_KOOS_'+n) && document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_KOOS_'+n).value.length>0){
	  				score = score + document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_KOOS_'+n).value*1;
	  			}
	  			else{
	  				score=0;
	  				break;
	  			}
	  		}
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_KOOS_TOTAL').style.textAlign='center';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_KOOS_TOTAL').style.height='20';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_KOOS_TOTAL').style.fontSize='14px';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_KOOS_TOTAL').style.fontWeight='bolder';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_KOOS_TOTAL').value=score;
  		}
  		setTestIcon("KOOS");
  	}

  	function calculateHOOS(){	
  		if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_HOOS_TOTAL')){
	  		var score = 0;
	  		for(n=1;n<41;n++){
	  			if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_HOOS_'+n) && document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_HOOS_'+n).value.length>0){
	  				score = score + document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_HOOS_'+n).value*1;
	  			}
	  			else{
	  				score=0;
	  				break;
	  			}
	  		}
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_HOOS_TOTAL').style.textAlign='center';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_HOOS_TOTAL').style.height='20';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_HOOS_TOTAL').style.fontSize='14px';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_HOOS_TOTAL').style.fontWeight='bolder';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_HOOS_TOTAL').value=score;
  		}
  		setTestIcon("HOOS");
  	}

  	function calculateSF36(){
  		if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_SF36_TOTAL')){
	  		var score = 0;
	  		for(n=1;n<37;n++){
	  			if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_SF36_'+n) && document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_SF36_'+n).value.length>0){
	  				score = score + document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_SF36_'+n).value*1;
	  			}
	  			else{
	  				score=0;
	  				break;
	  			}
	  		}
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_SF36_TOTAL').style.textAlign='center';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_SF36_TOTAL').style.height='20';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_SF36_TOTAL').style.fontSize='14px';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_SF36_TOTAL').style.fontWeight='bolder';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_SF36_TOTAL').value=score;
  		}
  		setTestIcon("SF36");
  	}

  	function calculateSTARTBACK(){
  		if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_STARTBACK_TOTAL')){
	  		var score = 0;
	  		for(n=1;n<10;n++){
	  			if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_STARTBACK_'+n) && document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_STARTBACK_'+n).value.length>0){
	  				score = score + document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_STARTBACK_'+n).value*1;
	  			}
	  			else{
	  				score=0;
	  				break;
	  			}
	  		}
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_STARTBACK_TOTAL').style.textAlign='center';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_STARTBACK_TOTAL').style.height='20';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_STARTBACK_TOTAL').style.fontSize='14px';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_STARTBACK_TOTAL').style.fontWeight='bolder';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_STARTBACK_TOTAL').value=score;
  		}
  		setTestIcon("STARTBACK");
  	}

  	function calculateACTIVLIM(){
  		if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_TOTAL')){
	  		var score = 0;
	  		var missing =0;
	  		for(n=1;n<21;n++){
	  			if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_'+n) && document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_'+n).value.length>0){
	  				val = document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_'+n).value*1;
	  				if(val>=0){
		  				score = score + val;
	  				}
	  				else{
	  					missing++;
	  				}
	  			}
	  			else{
	  				score=0;
	  				missing=0;
	  				break;
	  			}
	  		}
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_TOTAL').style.textAlign='center';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_TOTAL').style.height='20';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_TOTAL').style.fontSize='14px';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_TOTAL').style.fontWeight='bolder';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_TOTAL').value=score;
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_MISSINGANSWERS').style.textAlign='center';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_MISSINGANSWERS').value=missing;
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_LINEARSCORE').style.textAlign='center';
  		}
  		setTestIcon("ACTIVLIM");
  	}

  	function calculateABILHAND(){
  		if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_TOTAL')){
	  		var score = 0;
	  		var missing =0;
	  		for(n=1;n<22;n++){
	  			if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_'+n) && document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_'+n).value.length>0){
	  				val = document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_'+n).value*1;
	  				if(val>=0){
		  				score = score + val;
	  				}
	  				else{
	  					missing++;
	  				}
	  			}
	  			else{
	  				score=0;
	  				missing=0;
	  				break;
	  			}
	  		}
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_TOTAL').style.textAlign='center';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_TOTAL').style.height='20';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_TOTAL').style.fontSize='14px';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_TOTAL').style.fontWeight='bolder';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_TOTAL').value=score;
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_MISSINGANSWERS').style.textAlign='center';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_MISSINGANSWERS').value=missing;
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_LINEARSCORE').style.textAlign='center';
  		}
  		setTestIcon("ABILHAND");
  	}

  	function calculateABILOCO(){
  		if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_TOTAL')){
	  		var score = 0;
	  		var missing =0;
	  		for(n=1;n<11;n++){
	  			if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_'+n) && document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_'+n).value.length>0){
	  				val = document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_'+n).value*1;
	  				if(val>=0){
		  				score = score + val;
	  				}
	  				else{
	  					missing++;
	  				}
	  			}
	  			else{
	  				score=0;
	  				missing=0;
	  				break;
	  			}
	  		}
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_TOTAL').style.textAlign='center';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_TOTAL').style.height='20';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_TOTAL').style.fontSize='14px';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_TOTAL').style.fontWeight='bolder';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_TOTAL').value=score;
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_MISSINGANSWERS').style.textAlign='center';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_MISSINGANSWERS').value=missing;
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_LINEARSCORE').style.textAlign='center';
  		}
  		setTestIcon("ABILOCO");
  	}

  	function calculateMMSE(){
  		if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_MMSE_TOTAL')){
	  		var score = 0;
	  		for(n=1;n<31;n++){
	  			if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_MMSE_'+n+".1")){
	  				if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_MMSE_'+n+".1").checked){
	  					score++;
	  				}
	  			}
	  		}
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_MMSE_TOTAL').style.textAlign='center';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_MMSE_TOTAL').style.height='20';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_MMSE_TOTAL').style.fontSize='14px';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_MMSE_TOTAL').style.fontWeight='bolder';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_MMSE_TOTAL').value=score;
  		}
  		setTestIcon("MMSE");
  	}

  	function calculateBBS(){
  		if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_BBS_TOTAL')){
	  		var score = 0;
	  		for(n=1;n<15;n++){
	  			if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_BBS_'+n).value.length>0){
	  				score=score+document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_BBS_'+n).value.replace(";","")*1;
	  				document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_BBS_'+n+"_TD").style.backgroundColor="lightgreen";
	  			}
	  			else{
	  				score=0;
	  				break;
	  			}
	  		}
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_BBS_TOTAL').style.textAlign='center';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_BBS_TOTAL').style.height='20';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_BBS_TOTAL').style.fontSize='14px';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_BBS_TOTAL').style.fontWeight='bolder';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_BBS_TOTAL').value=score;
  		}
  		setTestIcon("BBS");
  	}
  	
  	function calculateOSWESTRY(){
  		if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_TOTAL')){
	  		var score = 0;
	  		for(n=1;n<11;n++){
	  			if(document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_'+n).value.length>0){
	  				score=score+document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_'+n).value.replace(";","")*1;
	  				document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_'+n+"_TD").style.backgroundColor="lightgreen";
	  			}
	  			else{
	  				score=0;
	  				break;
	  			}
	  		}
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_TOTAL').style.textAlign='center';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_TOTAL').style.height='20';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_TOTAL').style.fontSize='14px';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_TOTAL').style.fontWeight='bolder';
			document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_TOTAL').value=score;
  		}
  		setTestIcon("OSWESTRY");
  	}
  	

</script>
<form name="transactionForm" id="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>' >
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>

    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>

    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RECRUITMENT_CONVOCATION_ID" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RECRUITMENT_CONVOCATION_ID" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>

	<input type='hidden' name='activeDestinationIdField' id='activeDestinationIdField'/>
	<input type='hidden' name='activeDestinationTextField' id='activeDestinationTextField'/>
	<input type='hidden' name='activeLabeltype' id='activeLabeltype'/>
	<input type='hidden' name='activeDivld' id='activeDivld'/>
	<input type='hidden' name='activeAssessment' id='activeAssessment'/>
	<input type='hidden' name='activeTest' id='activeTest'/>

    <%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>

    <%-- TITLE --%>
    <table class="list" width='100%' cellspacing="0" cellpadding="0">
        <tr class="admin">
            <td width="1%" nowrap>
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
            </td>
            <td nowrap>
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
            </td>
            <td width="90%"><%=contextHeader(request,sWebLanguage)%></td>
        </tr>
    </table>

    <br/>

    <%-- TABS --%>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td class='tabs' width='5'>&nbsp;</td>
            <td class='tabunselected' width="1%" onclick="activateTab(1)" id="td1" nowrap>&nbsp;<b><%=getTran(request,"web","prescription",sWebLanguage)%></b>&nbsp;</td>
            <td class='tabs' width='5'>&nbsp;</td>
            <td class='tabunselected' width="1%" onclick="activateTab(2)" id="td2" nowrap>&nbsp;<b><%=getTran(request,"web","consultation",sWebLanguage)%></b>&nbsp;</td>
            <td class='tabs' width='5'>&nbsp;</td>
            <td class='tabunselected' width="1%" onclick="activateTab(3)" id="td3" nowrap>&nbsp;<b><%=getTran(request,"web.occup","treatment",sWebLanguage)%></b>&nbsp;</td>
            <td class='tabs' width='5'>&nbsp;</td>
            <td class='tabunselected' width="1%" onclick="activateTab(5)" id="td5" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","assessment",sWebLanguage)%></b>&nbsp;</td>
            <td class='tabs' width='5'>&nbsp;</td>
            <td class='tabunselected' width="1%" onclick="activateTab(6)" id="td6" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","tests",sWebLanguage)%></b>&nbsp;</td>
            <td class='tabs' width='5'>&nbsp;</td>
            <td class='tabunselected' width="1%" onclick="activateTab(4)" id="td4" nowrap>&nbsp;<b><%=getTran(request,"web","report",sWebLanguage)%></b>&nbsp;</td>
            <td width="*" class='tabs'></td>
        </tr>
    </table>
    <%-- HIDEABLE --%>
    
    <table id="contentpane" style="vertical-align:top;" width="100%" border="0" cellspacing="0">
        <tr id="tr1-view" style="display:none">
            <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKinePrescription.jsp"),pageContext);%></td>
        </tr>
        <tr id="tr2-view" style="display:none">
            <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineConsultation.jsp"),pageContext);%></td>
        </tr>
        <tr id="tr3-view" style="display:none">
            <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineTreatment.jsp"),pageContext);%></td>
        </tr>
        <tr id="tr4-view" style="display:none">
            <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineReport.jsp"),pageContext);%></td>
        </tr>
        <tr id="tr5-view" style="display:none">
            <td><div id="kineAssessment"/></td>
        </tr>
        <tr id="tr6-view" style="display:none">
            <td><div id="kineTests"/></td>
        </tr>
    </table>
    <%-- BUTTONS --%>
    <%=ScreenHelper.alignButtonsStart()%>
        <%=getButtonsHtml(request,activeUser,activePatient,"cnrkr.neuromuscular",sWebLanguage)%>    
        <script>
        	document.getElementById("buttonsDiv").innerHTML+="<input class='button' type='button' value='<%=getTranNoLink("web","printassessment",sWebLanguage) %>' onclick='printAssessment(\"<%=((TransactionVO)transaction).getServerId()+"."+((TransactionVO)transaction).getTransactionId()%>\")'/>";
        </script> 
    <%=ScreenHelper.alignButtonsStop()%>

    <%=ScreenHelper.contextFooter(request)%>
    <table width='100%' cellspacinf='0'>
    	<tr><td><center><img height='80px' src='<c:url value="/_img/apefepartners.png"/>'/></center></td></tr>
    </table>
</form>

<script>
  activateTab(1);
	
  	function printAssessment(transactionuid){
  		printWordDocuments(transactionuid);
	}
  <%-- SUBMIT FORM --%>
	function submitForm(){
		  if(<%=((TransactionVO)transaction).getServerId()%>==1 && document.getElementById('encounteruid').value=='' <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
				alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
				searchEncounter();
			  }	
		  else {
		    transactionForm.saveButton.disabled = true;
		    document.getElementById('surgerydate').value=document.getElementById('sdate').value;
		    document.getElementById('closingdate').value=document.getElementById('cdate').value;
		    document.getElementById('reportingdate').value=document.getElementById('rdate').value;
		    <%
		    	SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
		        out.print(takeOverTransaction(sessionContainerWO, activeUser,"document.transactionForm.submit();"));
		    %>
		  }
	}    
	
	function searchEncounter(){
	      openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&Varcode=encounteruid&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
	  }
	function loadAssessment(activate){
    	var referenceTransactionUid='';
    	if(document.getElementById('referenceTransactionUid')){
    		referenceTransactionUid=document.getElementById('referenceTransactionUid').value;
    	}
    	var params = "assessmenttype="+document.getElementById("ITEM_TYPE_CNRKR_KINE_DIAGNOSTICACTS").value+"&referenceTransactionUid="+referenceTransactionUid;
		if(!(document.getElementById('activeAssessment').value==params)){
	    	var url = '<c:url value="/healthrecord/ajax/loadCNRKRAssessment.jsp"/>?ts='+new Date().getTime();
			new Ajax.Request(url,{
			method: "POST",
			parameters: params,
			onSuccess: function(resp){
			 	document.getElementById("kineAssessment").innerHTML = resp.responseText;
			 	if(activate){
			        document.getElementById('tr5-view').style.display = '';
			        td5.className="tabselected";
			 	}
		        resizeContentPane();
		        resizeAllTextareas(10);
		        document.getElementById('activeAssessment').value=params;
		    }
			});
		}
		else{
		 	if(activate){
		        document.getElementById('tr5-view').style.display = '';
		        td5.className="tabselected";
		 	}
		}
	}
	function addDivValue(fieldId,typeId,valueId){
		var fieldValue = document.getElementById(fieldId).value;
		var typeValue = document.getElementById(typeId).value;
		var valueValue = document.getElementById(valueId).value;
		var existingValues = fieldValue.split(";");
		fieldValue="";
		for(n=0;n<existingValues.length;n++){
			if(existingValues[n].split(":").length>1 && !(existingValues[n].split(":")[0]==typeValue)){
				fieldValue+=existingValues[n]+";";
				document.getElementById("div_"+fieldId).innerHTML='';
			}
		}
		if(valueValue>-1){
			fieldValue+=typeValue+":"+valueValue+";";
		}
		document.getElementById(fieldId).value=fieldValue;
		showDivValues(fieldId,typeId);
	}
	
	function showDivValues(fieldId,typeId){
		var fieldValue = document.getElementById(fieldId).value;
		existingValues = fieldValue.split(";");
		var html="<table width='100%'>";
		for(n=0;n<existingValues.length;n++){
			var t = existingValues[n].split(":")[0];
			var v = existingValues[n].split(":")[1];
			for(i=0;i<document.getElementById(typeId).options.length;i++){
				var option = document.getElementById(typeId).options[i];
				if(option.value==t){
					html+="<tr><td style='border:0.5px solid black;'><b>"+option.text+"</b></td><td style='border:0.5px solid black;background-color: black;color: white;font-weight:bolder;text-align:center;'>"+v+"</td></tr>";
				}
			}
		}
		html+="</table>";
		document.getElementById("div_"+fieldId).innerHTML=html;
	}

</script>
<script>

	function loadTests(activate){
    	var referenceTransactionUid='';
    	if(document.getElementById('referenceTransactionUid')){
    		referenceTransactionUid=document.getElementById('referenceTransactionUid').value;
    	}
    	var params = "test1="+document.getElementById("ITEM_TYPE_CNRKR_KINE_TEST1_code").value+
					 "&test2="+document.getElementById("ITEM_TYPE_CNRKR_KINE_TEST2_code").value+
					 "&test3="+document.getElementById("ITEM_TYPE_CNRKR_KINE_TEST3_code").value+
					 "&test4="+document.getElementById("ITEM_TYPE_CNRKR_KINE_TEST4_code").value+
					 "&referenceTransactionUid="+referenceTransactionUid
    				 ;
		if(!(document.getElementById('activeTest').value==params)){
			var url = '<c:url value="/healthrecord/ajax/loadCNRKRTests.jsp"/>?ts='+new Date().getTime();
			new Ajax.Request(url,{
			method: "POST",
			parameters: params,
			onSuccess: function(resp){
			 	document.getElementById("kineTests").innerHTML = resp.responseText;
			 	if(activate){
			        document.getElementById('tr6-view').style.display = '';
			        td6.className="tabselected";
				}	
		        resizeContentPane();
		        calculateTestScores();
		        if(params.indexOf("2.1")>-1 && document.getElementById("ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_QUESTIONSET")){
					setAbilhandOrder(document.getElementById("ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_QUESTIONSET").value,true);
		        }
		        if(params.indexOf("2.2")>-1 && document.getElementById("ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_QUESTIONSET")){
					setAbilocoOrder(document.getElementById("ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_QUESTIONSET").value,true);
		        }
		        collapseTests();
		        document.getElementById('activeTest').value=params;
			}
			});
		}
		else{
		 	if(activate){
		        document.getElementById('tr6-view').style.display = '';
		        td6.className="tabselected";
			}	
		}
	}
	
</script>
<script>

	var abilhandlabel = {};
	var abilocolabel = {};
	var order = '1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21';
	var locoorder = '1;2;3;4;5;6;7;8;9;10';
	var questions=order.split(";");
	<%
		for(int n=1;n<22;n++){
			out.println("abilhandlabel["+n+"] = \""+getTran(request,"cnrkr.abilhand","1."+n,sWebLanguage)+"\";");
		}
	%>
	var locoquestions=order.split(";");
	<%
		for(int n=1;n<11;n++){
			out.println("abilocolabel["+n+"] = \""+getTran(request,"cnrkr.abiloco","1."+n,sWebLanguage)+"\";");
		}
	%>
	
	function setAbilhandOrder(id,novalueset){
		//First store existing associations
		var abihandvalues={};
		for(n=0;n<21;n++){
			abihandvalues[questions[n]*1]=document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_'+(n+1)).value;
		}
		if(id==1){
			order = '1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21';
		}
		else if(id==2){
			order = '1;3;5;7;9;11;13;15;17;19;21;2;4;6;8;10;12;14;16;18;20';
		}
		else if(id==3){
			order = '21;17;13;9;5;1;18;14;10;6;2;19;15;11;7;3;20;16;12;8;4';
		}
		else if(id==4){
			order = '6;9;12;15;18;21;2;5;8;11;14;17;20;1;4;7;10;13;16;19;3';
		}
		else if(id==5){
			order = '15;13;11;9;7;5;3;1;20;18;16;14;12;10;8;6;4;2;21;19;17';
		}
		else if(id==6){
			order = '20;2;19;3;18;4;17;5;16;6;15;7;14;8;13;9;12;10;11;21;1';
		}
		else if(id==7){
			order = '5;10;15;20;4;9;14;19;3;8;13;18;2;7;12;17;1;6;11;16;21';
		}
		else if(id==8){
			order = '8;9;7;10;6;11;5;12;4;13;3;14;2;15;1;16;21;17;20;18;19';
		}
		else if(id==9){
			order = '19;15;11;7;3;20;16;12;8;4;21;17;13;9;5;1;18;14;10;6;2';
		}
		else if(id==10){
			order = '4;6;9;13;18;3;10;12;7;17;5;2;21;11;1;20;14;8;15;16;19';
		}
		questions=order.split(";");
		for(n=0;n<questions.length;n++){
			document.getElementById("t"+(n+1)).innerHTML=(n+1)+". "+abilhandlabel[questions[n]*1];
			if(!novalueset){
				document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_'+(n+1)).value=abihandvalues[questions[n]*1];
			}
		}
	}
	
	function setAbilocoOrder(id,novalueset){
		//First store existing associations
		var abilocovalues={};
		for(n=0;n<10;n++){
			abilocovalues[locoquestions[n]*1]=document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_'+(n+1)).value;
		}
		if(id==1){
			locoorder = '1;2;3;4;5;6;7;8;9;10';
		}
		else if(id==2){
			locoorder = '1;3;5;7;9;2;4;6;8;10';
		}
		else if(id==3){
			locoorder = '9;5;1;6;2;7;3;10;8;4';
		}
		else if(id==4){
			locoorder = '6;9;2;5;8;1;4;7;10;3';
		}
		else if(id==5){
			locoorder = '9;7;5;3;1;10;8;6;4;2';
		}
		else if(id==6){
			locoorder = '5;6;2;7;3;4;9;10;1;8';
		}
		else if(id==7){
			locoorder = '5;4;9;3;8;2;7;1;6;10';
		}
		else if(id==8){
			locoorder = '8;9;7;10;6;5;4;3;2;1';
		}
		else if(id==9){
			locoorder = '7;3;8;4;9;5;1;10;6;2';
		}
		else if(id==10){
			locoorder = '4;6;9;3;10;7;5;2;1;8';
		}
		locoquestions=locoorder.split(";");
		for(n=0;n<locoquestions.length;n++){
			document.getElementById("t"+(n+1)).innerHTML=(n+1)+". "+abilocolabel[locoquestions[n]*1];
			if(!novalueset){
				document.getElementById('ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_'+(n+1)).value=abilocovalues[locoquestions[n]*1];
			}
		}
	}

	if(<%=((TransactionVO)transaction).getServerId()%>==1 && document.getElementById('encounteruid').value=='' <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
			alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
			searchEncounter();
	}	
	
	loadAssessment(false);
	loadTests(false);

</script>

<%=writeJSButtons("transactionForm","saveButton")%>

