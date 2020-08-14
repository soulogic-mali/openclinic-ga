<%@page import="be.openclinic.finance.Insurance,
                java.util.Vector" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=sJSSORTTABLE%>

<%
	//Check if we have to set the defaultInsurance
	String sDefaultInsurance = checkString(request.getParameter("defaultInsurance"));
	if(sDefaultInsurance.length()>0){
		if(checkString(request.getParameter("activateDefault")).equalsIgnoreCase("1")){
		    Vector activeInsurances = Insurance.getCurrentInsurances(activePatient.personid);
		    for(int n=0;n<activeInsurances.size();n++){
		    	Insurance insurance = (Insurance)activeInsurances.elementAt(n);
		    	if(insurance.getUid().equalsIgnoreCase(sDefaultInsurance)){
		    		insurance.setDefaultInsurance(1);
		    		insurance.store();
		    	}
		    	else if(insurance.getDefaultInsurance()==1){
		    		insurance.setDefaultInsurance(0);
		    		insurance.store();
		    	}
		    }
		}
		else{
	    	Insurance insurance = Insurance.get(sDefaultInsurance);
	    	if(insurance!=null){
	    		insurance.setDefaultInsurance(0);
	    		insurance.store();
	    	}
		}
	}
    Vector vCurrentInsurances;
    vCurrentInsurances = Insurance.getCurrentInsurances(activePatient.personid);
    Iterator iter = vCurrentInsurances.iterator();

    Insurance currentInsurance;
%>
<table class="list" width="100%" cellspacing="0">
    <tr class="admin">
        <td>
            <%=getTran(request,"curative","insurance.status.title",sWebLanguage)%>&nbsp;
            <a href="<c:url value='/main.jsp'/>?Page=financial/insurance/historyInsurances.jsp&ts=<%=getTs()%>"><img height='16px' style='vertical-align: middle' src="<c:url value='/_img/icons/icon_history.png'/>" class="link" title="<%=getTranNoLink("web","historyinsurances",sWebLanguage)%>" style="vertical-align:-4px;"></a>
            <a href="<c:url value='/main.jsp'/>?Page=financial/insurance/editInsurance.jsp&ts=<%=getTs()%>"><img height='16px' style='vertical-align: middle' src="<c:url value='/_img/icons/icon_newpage.png'/>" class="link" title="<%=getTranNoLink("web","newinsurance",sWebLanguage)%>" style="vertical-align:-4px;"></a>
            <%if(Insurance.getActiveInsurance(activePatient.personid, MedwanQuery.getInstance().getConfigString("SIS","1.29"))!=null){ %>
	            <a href="<c:url value='/main.jsp'/>?Page=financial/fuaEdit.jsp&ts=<%=getTs()%>"><img height='16px' style='vertical-align: middle' src="<c:url value='/_img/icons/icon_fua.png'/>" class="link" title="<%=getTranNoLink("web","fua",sWebLanguage)%>" style="vertical-align:-4px;"></a>
	        <%}
              if(MedwanQuery.getInstance().getConfigInt("enableSIS",0)==1 && activePatient.getID("natreg").length()>0 && Insurance.getActiveInsurance(activePatient.personid, MedwanQuery.getInstance().getConfigString("SIS","1.29"))==null){
            	%>
	            <a href="javascript:checkSIS()"><img height='14px' style='vertical-align: middle' src="<c:url value='/_img/icons/sis.jpg'/>" class="link" title="<%=getTranNoLink("web","SIS",sWebLanguage)%>" style="vertical-align:-4px;"></a> <span id='sisdiv'/>
            	<%	  
              }
              %>
        </td>
    </tr>
    <%
        if(vCurrentInsurances.size() > 0){
    %>
    <tr>
        <td style="padding:0;">
            <table width="100%" class="sortable" cellpadding="0" cellspacing="0" id="searchresultsInsurance" style="border:0;">
                <tr class="gray">
                    <td><%=getTran(request,"insurance","insurancenr",sWebLanguage)%></td>
                    <td><%=getTran(request,"web","company",sWebLanguage)%></td>
                    <td><%=getTran(request,"web","tariff",sWebLanguage)%></td>
                    <td><%=getTran(request,"web","start",sWebLanguage)%></td>
                </tr>
    <%
            String sClass ="";
            while(iter.hasNext()){
                currentInsurance = (Insurance)iter.next();
                String sDefault="";
                if(activeUser.getAccessRightNoSA("financial.defaultinsurancemodify.select")){
	                if(currentInsurance.getDefaultInsurance()==1){
	                	sDefault="<input style='vertical-align: middle;' type='checkbox' class='text' checked onclick='setDefaultInsurance(this.checked,\""+currentInsurance.getUid()+"\")'/>";
	                }
	                else{
	                	sDefault="<input style='vertical-align: middle;' type='checkbox' class='text' onclick='setDefaultInsurance(this.checked,\""+currentInsurance.getUid()+"\")'/>";
	                }
                }
                else{
	                if(currentInsurance.getDefaultInsurance()==1){
	                	sDefault="<img width='10px' style='vertical-align: middle;' src='"+sCONTEXTPATH+"/_img/themes/default/check.gif'/> ";
	                }
	                else{
	                	sDefault="<img width='10px' style='vertical-align: middle;' src='"+sCONTEXTPATH+"/_img/themes/default/uncheck.gif'/> ";
	                }
                }
            	// alternate row-style
                if(sClass.equals("")) sClass = "1";
                else                  sClass = "";
            	
            	boolean bAuth = currentInsurance.isAuthorized();
            	
                %>
                <tr class="list<%=sClass%>" onmouseover="this.style.cursor='hand';" onmouseout="this.style.cursor='default';"">
                    <td  onclick="doSelect('<%=currentInsurance.getUid()%>');" <%=!bAuth?"style='vertical-align: middle;text-decoration: line-through'":""%>>
                    <%
                        if(!bAuth){
                            %><img style='vertical-align: middle;' width="18px" src="<c:url value="/_img/noaccess.jpg"/>"/><%
                        }
                    %>
                    <%=ScreenHelper.checkString(currentInsurance.getInsuranceNr())%></td>
                    <td <%=!bAuth?"style='text-decoration: line-through'":""%>><%=sDefault+"<span  onclick=\"doSelect('"+currentInsurance.getUid()+"');\">"+(ScreenHelper.checkString(currentInsurance.getInsuranceCategoryLetter()).length()>0 && currentInsurance.getInsuranceCategory().getLabel().length()>0?ScreenHelper.checkString(currentInsurance.getInsuranceCategory().getInsurar().getName())+ " ("+currentInsurance.getInsuranceCategory().getCategory()+": "+currentInsurance.getInsuranceCategory().getPatientShare()+"/"+(100-Integer.parseInt(currentInsurance.getInsuranceCategory().getPatientShare()))+")":"")%></span></td>
                    <td  onclick="doSelect('<%=currentInsurance.getUid()%>');" <%=!bAuth?"style='text-decoration: line-through'":""%>><%=ScreenHelper.checkString(getTran(request,"insurance.types",currentInsurance.getType(),sWebLanguage))%></td>
                    <td  onclick="doSelect('<%=currentInsurance.getUid()%>');" <%=!bAuth?"style='text-decoration: line-through'":""%>><%=ScreenHelper.checkString(currentInsurance.getStart()!=null?ScreenHelper.stdDateFormat.format(currentInsurance.getStart()):"")%></td>
                </tr>
                <%
            }
    %>
            </table>
        </td>
    </tr>
    <%
        }
    %>
</table>

<form name='setDefaultInsuranceForm' id='setDefaultInsuranceForm' method='post'>
	<input type='hidden' name='defaultInsurance' id='defaultInsurance'/>
	<input type='hidden' name='activateDefault' id='activateDefault'/>
</form>

<script>
  function doSelect(id){
    window.location.href = "<c:url value='/main.jsp'/>?Page=financial/insurance/editInsurance.jsp&EditInsuranceUID="+id+"&ts=<%=getTs()%>";
  }
  function checkSIS(){
		$('sisdiv').innerHTML = "<img height='10' src='<c:url value="_img/themes/default/ajax-loader.gif"/>'/>"
	    var params = "&forceautorization=true";
	    var url= '<c:url value="/financial/checkSIS.jsp"/>?ts='+new Date();
	    new Ajax.Request(url,{
		  method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
	        $('sisdiv').innerHTML = resp.responseText;
	        if($('authorized') && $('authorized').value=='1'){
	        	window.location.reload();
	        }
	        else{
	        	alert('<%=getTranNoLink("web","nosiscoverage",sWebLanguage)%>');
	        }
	      },
		  onFailure: function(){
		    alert('error');
		    $('sisdiv').innerHTML = "";
	      }
	    });
  }
  
  function setDefaultInsurance(cb,insuranceuid){
	  document.getElementById('defaultInsurance').value=insuranceuid;
	  if(cb){
		  document.getElementById('activateDefault').value=1;
	  }
	  else{
		  document.getElementById('activateDefault').value=0;
	  }
	  document.getElementById('setDefaultInsuranceForm').submit();
  }
</script>