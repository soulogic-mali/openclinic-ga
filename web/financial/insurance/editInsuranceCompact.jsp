<%@page import="be.openclinic.finance.*,
                be.mxs.common.util.system.*"%>
<%@include file="/includes/validateUser.jsp"%>

<script>
  function searchInsuranceCategory(){
	openPopup("/_common/search/searchInsuranceCategory.jsp&ts=<%=getTs()%>&VarCode=EditInsuranceCategoryLetter"+
			  "&VarText=EditInsuranceInsurarName&VarCat=EditInsuranceCategory&VarCompUID=EditInsurarUID"+
			  "&VarTyp=EditInsuranceType&VarTypName=EditInsuranceTypeName&"+
			  "VarFunction=checkInsuranceAuthorization()&Active=1&NoActive=1",600);
  }
	
  function doBack(){
    window.location.href="<c:url value='/main.do'/>?Page=curative/editEncounterCompact.jsp&ts=<%=getTs()%>";
  }

  function doSearchBack(){
    window.location.href="<c:url value='/main.do'/>?Page=curative/editEncounterCompact.jsp&ts=<%=getTs()%>";
  }

  <%-- DO SAVE --%>
  function doSave(){
	if(validateInsuranceNumber()){
	    if("<%=MedwanQuery.getInstance().getConfigString("InsuranceAgentAuthorizationNeededFor","$$").replaceAll("\\*","")%>"==document.getElementById('EditInsurarUID').value && document.getElementById('EditInsuranceNr').value==''){
	      alertDialog("web","insurancenr.mandatory");
	    }
	    else if("<%=MedwanQuery.getInstance().getConfigString("InsuranceAgentAuthorizationNeededFor","$$").replaceAll("\\*","")%>"==document.getElementById('EditInsurarUID').value && document.getElementById('EditInsuranceStatus').value==''){
	      alertDialog("web","insurancestatus.mandatory");
	    }
	   	else if(EditInsuranceForm.EditInsuranceStart && EditInsuranceForm.EditInsuranceStart.value.length<8){
	   	  alertDialog("web","insurancedatestart.mandatory");
	   	}
	  	else{
	      EditInsuranceForm.EditSaveButton.disabled = true;
	      EditInsuranceForm.Action.value = "SAVE";
	      EditInsuranceForm.submit();
	    }
	}
  }
</script>

<%=checkPermission(out,"financial.insurance","select",activeUser)%>

<%
    String sAction = checkString(request.getParameter("Action"));

	String sEditInsuranceUID = checkString(request.getParameter("EditInsuranceUID"));
    String sEditInsurarUID = checkString(request.getParameter("EditInsurarUID"));
	String sEditExtraInsurarUID = checkString(request.getParameter("EditExtraInsurarUID"));
	String sEditExtraInsurarUID2 = checkString(request.getParameter("EditExtraInsurarUID2"));
    String sEditInsuranceNr = checkString(request.getParameter("EditInsuranceNr"));
    String sEditInsuranceType = checkString(request.getParameter("EditInsuranceType"));
    String sEditInsuranceMember = checkString(request.getParameter("EditInsuranceMember"));
    String sEditInsuranceMemberImmat = checkString(request.getParameter("EditInsuranceMemberImmat"));
    String sEditInsuranceMemberEmployer = checkString(request.getParameter("EditInsuranceMemberEmployer"));
    String sEditInsuranceStatus = checkString(request.getParameter("EditInsuranceStatus"));
    String sEditAuthorization = checkString(request.getParameter("EditAuthorization"));
    String sEditInsuranceStart = checkString(request.getParameter("EditInsuranceStart"));
    if(sEditInsuranceStart.length()==0){
        sEditInsuranceStart = ScreenHelper.stdDateFormat.format(new java.util.Date());
    }
    String sEditInsuranceStop = checkString(request.getParameter("EditInsuranceStop"));
    String sEditInsuranceCategoryLetter = checkString(request.getParameter("EditInsuranceCategoryLetter"));
    String sEditInsuranceCategory = "";
    String sEditInsuranceInsurarName = "";
    String sEditInsuranceComment = checkString(request.getParameter("EditInsuranceComment"));
    String sEditInsuranceDefault = checkString(request.getParameter("EditInsuranceDefault"));
    String sEditInsuranceMemberCategory = checkString(request.getParameter("EditInsuranceMemberCategory"));
    String sEditInsuranceFamilyCode = checkString(request.getParameter("EditInsuranceFamilyCode"));
	if(sEditInsuranceDefault.length()==0){
		sEditInsuranceDefault = "0";
	}
	
	boolean bCanSave = true;
	
	//***** SAVE *****
    if(sAction.equals("SAVE")){
        if(sEditInsurarUID.length()!=0){
        	Insurar insurar = Insurar.get(sEditInsurarUID);
        	if(insurar!=null && insurar.getRequireAffiliateID()==1 && sEditInsuranceNr.length()==0){
        		out.print("<script>alertDialog('web','requireaffiliateid');</script>");
        		bCanSave = false;
        	}
        }
        
        if(bCanSave){
	        if(sEditInsuranceCategoryLetter.length()==0){
	            sEditInsurarUID = "";
	        }
	        
	        Insurance insurance = new Insurance();
	        if(sEditInsuranceUID.length() > 0){
	            insurance = Insurance.get(sEditInsuranceUID);
	        }
	        else{
	            insurance.setCreateDateTime(getSQLTime());
	        }
	
	        if(sEditInsuranceStart.length() > 0){
	            insurance.setStart(new Timestamp(ScreenHelper.getSQLDate(sEditInsuranceStart).getTime()));
	        }
	        
	        if(sEditInsuranceStop.length() > 0) {
	            insurance.setStop(new Timestamp(ScreenHelper.getSQLDate(sEditInsuranceStop).getTime()));
	        }
	        
	        insurance.setInsuranceNr(sEditInsuranceNr);
	        insurance.setType(sEditInsuranceType);
	        insurance.setMember(sEditInsuranceMember);
	        insurance.setMemberImmat(sEditInsuranceMemberImmat);
	        insurance.setMemberEmployer(sEditInsuranceMemberEmployer);
	        insurance.setStatus(sEditInsuranceStatus);
	        insurance.setInsuranceCategoryLetter(sEditInsuranceCategoryLetter);
	        insurance.setComment(new StringBuffer(sEditInsuranceComment));
	        insurance.setUpdateDateTime(getSQLTime());
	        insurance.setUpdateUser(activeUser.userid);
	        insurance.setPatientUID(activePatient.personid);
	        insurance.setInsurarUid(sEditInsurarUID);
	        insurance.setExtraInsurarUid(sEditExtraInsurarUID);
	        insurance.setExtraInsurarUid2(sEditExtraInsurarUID2);
	        insurance.setDefaultInsurance(Integer.parseInt(sEditInsuranceDefault));
	        insurance.setMembercategory(sEditInsuranceMemberCategory);
	        insurance.setFamilycode(sEditInsuranceFamilyCode);
	        insurance.store();
	        if(MedwanQuery.getInstance().getConfigInt("copyInsuranceNumberToImmatNew",0)==1){
		        if(checkString(insurance.getInsuranceNr()).length()>0 && !insurance.getInsuranceNr().equalsIgnoreCase(activePatient.getID("immatnew"))){
		        	activePatient.setID("immatnew", insurance.getInsuranceNr());
		        	activePatient.store();
		        }
	        }	        
	        if(insurance.getDefaultInsurance()==1){
	        	// Cancel defaults for other insurances of this patient
	        	Vector insurances = Insurance.selectInsurances(activePatient.personid,"");
	        	for(int n=0; n<insurances.size(); n++){
	        		Insurance ins = (Insurance)insurances.elementAt(n);
	        		if(!ins.getUid().equals(insurance.getUid())){
	        			ins.setDefaultInsurance(0);
	        			ins.store();
	        		}
	        	}
	        			
	        }
	        if(sEditAuthorization.length() > 0){
	        	Pointer.storePointer("AUTH."+sEditInsurarUID+"."+activePatient.personid+"."+new SimpleDateFormat("yyyyMM").format(new java.util.Date()), new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date(new java.util.Date().getTime()+24*3600*1000))+";"+activeUser.userid);
	        }
	        
	        out.print("<script>doSearchBack();</script>");
        }
        out.flush();
    }

    if(sEditInsuranceUID.length() > 0 && bCanSave){
    	Insurance insurance = Insurance.get(sEditInsuranceUID);

        sEditInsuranceNr = insurance.getInsuranceNr();
        sEditInsuranceType = insurance.getType();
        sEditInsuranceMember = insurance.getMember();
        sEditInsuranceMemberImmat = insurance.getMemberImmat();
        sEditInsuranceMemberEmployer = insurance.getMemberEmployer();
        sEditInsuranceStatus = insurance.getStatus();
        sEditInsuranceCategoryLetter = insurance.getInsuranceCategoryLetter();
        sEditInsurarUID = insurance.getInsurarUid();
        sEditExtraInsurarUID = insurance.getExtraInsurarUid();
        sEditExtraInsurarUID2 = insurance.getExtraInsurarUid2();
        
        if(insurance.getStart() != null){
            sEditInsuranceStart = ScreenHelper.stdDateFormat.format(insurance.getStart());
        } 
        else{
            sEditInsuranceStart = "";
        }
        
        if(insurance.getStop() != null){
            sEditInsuranceStop = ScreenHelper.stdDateFormat.format(insurance.getStop());
        }
        else{
            sEditInsuranceStop = "";
        }
        
        sEditInsuranceComment = insurance.getComment().toString();
        
        InsuranceCategory insuranceCategory = InsuranceCategory.get(sEditInsurarUID,sEditInsuranceCategoryLetter);
        if(insuranceCategory.getLabel().length() > 0){
            sEditInsuranceInsurarName = insuranceCategory.getInsurar().getName();
            sEditInsuranceCategory = insuranceCategory.getCategory()+": "+insuranceCategory.getLabel();
        }
        sEditInsuranceDefault = insurance.getDefaultInsurance()+"";
        sEditInsuranceMemberCategory = ScreenHelper.checkString(insurance.getMembercategory());
        sEditInsuranceFamilyCode = ScreenHelper.checkString(insurance.getFamilycode());
    }
    else if(sEditInsurarUID.length()>0 && sEditInsuranceCategoryLetter.length() > 0){
        InsuranceCategory insuranceCategory = InsuranceCategory.get(sEditInsurarUID,sEditInsuranceCategoryLetter);
        if(insuranceCategory.getLabel().length() > 0){
            sEditInsuranceInsurarName = insuranceCategory.getInsurar().getName();
            sEditInsuranceCategory = insuranceCategory.getCategory()+": "+insuranceCategory.getLabel();
        }
    }        
%>
<form name="EditInsuranceForm" id="EditInsuranceForm" method="POST" action="<c:url value='/main.do'/>?Page=financial/insurance/editInsuranceCompact.jsp&ts=<%=getTs()%>">
    <input type="hidden" name="EditInsuranceUID" value="<%=sEditInsuranceUID%>"/>
    
    <%=writeTableHeader("insurance","manageInsurance",sWebLanguage," doBack();")%>
    <table class='list' border='0' width='100%' cellspacing='1'>
        <%-- insurancenr --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"insurance","insurancenr",sWebLanguage)%></td>
            <td class="admin2">
                <input class="text" type="text" name="EditInsuranceNr" id="EditInsuranceNr" value="<%=sEditInsuranceNr%>" size="<%=sTextWidth%>"/>
            </td>
        </tr>
        
        <%-- status --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"insurance","status",sWebLanguage)%></td>
            <td class="admin2">
                <select class="text" name="EditInsuranceStatus" id="EditInsuranceStatus" onchange="setStatus();">
                    <option value=""></option>
                    <%=ScreenHelper.writeSelectUnsorted(request,"insurance.status",sEditInsuranceStatus,sWebLanguage)%>
                </select>
            </td>
        </tr>
        
        <%-- member --%>
        <tr>
            <td class="admin"><%=getTran(request,"insurance","member",sWebLanguage)%></td>
            <td class="admin2">
                <input class="text" type="text" name="EditInsuranceMember" id="EditInsuranceMember" value="<%=sEditInsuranceMember%>" size="<%=sTextWidth%>"/>
            </td>
        </tr>
<%
	if(MedwanQuery.getInstance().getConfigInt("MFPextendedInformation",0)==1||MedwanQuery.getInstance().getConfigString("edition").equalsIgnoreCase("openpharmacy")||MedwanQuery.getInstance().getConfigString("edition").equalsIgnoreCase("openinsurance")){
%>
        <%-- immat --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"insurance","memberimmat",sWebLanguage)%></td>
            <td class="admin2">
                <input class="text" type="text" name="EditInsuranceMemberImmat" id="EditInsuranceMemberImmat" value="<%=sEditInsuranceMemberImmat%>" size="<%=sTextWidth%>"/>
            </td>
        </tr>
        <%-- employer --%>
        <tr>
            <td class="admin"><%=getTran(request,"insurance","memberemployer",sWebLanguage)%></td>
            <td class="admin2">
                <input class="text" type="text" name="EditInsuranceMemberEmployer" value="<%=sEditInsuranceMemberEmployer%>" size="<%=sTextWidth%>"/>
            </td>
        </tr>
 <%
	}
 %>
<%
	if(MedwanQuery.getInstance().getConfigInt("enableRwanda",0)==1){
%>
        <%-- membercategory --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"insurance","membercategory",sWebLanguage)%></td>
            <td class="admin2">
            	<select class="text" name="EditInsuranceMemberCategory" id="EditInsuranceMemberCategory">
            		<option></option>
            		<%=ScreenHelper.writeSelect(request,"membercategory", sEditInsuranceMemberCategory, sWebLanguage) %>
            	</select>
            </td>
        </tr>
        <%-- employer --%>
        <tr>
            <td class="admin"><%=getTran(request,"insurance","familycode",sWebLanguage)%></td>
            <td class="admin2">
            	<select class="text" name="EditInsuranceFamilyCode" id="EditInsuranceFamilyCode">
            		<option></option>
            		<%=ScreenHelper.writeSelect(request,"familycode", sEditInsuranceFamilyCode, sWebLanguage) %>
            	</select>
            </td>
        </tr>
 <%
	}
 %>
        <%-- company --%>
        <tr>
            <td class="admin"><%=getTran(request,"web","company",sWebLanguage)%></td>
            <td class="admin2">
                <input type="hidden" name="EditInsurarUID" id="EditInsurarUID" value="<%=sEditInsurarUID%>"/>
                <input class="text" type="text" readonly name="EditInsuranceInsurarName" value="<%=sEditInsuranceInsurarName%>" size="<%=sTextWidth%>"/>
              
                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchInsuranceCategory();">
                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="EditInsuranceForm.EditInsuranceInsurarName.value='';EditInsuranceForm.EditInsuranceCategory.value='';EditInsuranceForm.EditInsuranceCategoryLetter.value='';checkInsuranceAuthorization()">
            </td>
        </tr>
        <%-- category --%>
        <tr>
            <td class="admin"><%=getTran(request,"web","category",sWebLanguage)%></td>
            <td class="admin2">
                <input type="hidden" name="EditInsuranceCategoryLetter" value="<%=sEditInsuranceCategoryLetter%>"/>
                <input class="text" type="text" readonly name="EditInsuranceCategory" value="<%=sEditInsuranceCategory%>" size="<%=sTextWidth%>"/>
            </td>
        </tr>
        <%-- type --%>
        <tr>
            <td class="admin"><%=getTran(request,"web","tariff",sWebLanguage)%></td>
            <td class="admin2">
                <input type="hidden" name="EditInsuranceType" value="<%=sEditInsuranceType%>"/>
                <input class="text" type="text" readonly name="EditInsuranceTypeName" value="<%=sEditInsuranceType.length()>0?getTran(request,"insurance.types",sEditInsuranceType,sWebLanguage):""%>" size="<%=sTextWidth%>" readonly/>
            </td>
        </tr>
        <%-- complementary coverage --%>
        <tr>
            <td class="admin"><%=getTran(request,"web","complementarycoverage",sWebLanguage)%></td>
            <td class="admin2">
                <select class="text" name="EditExtraInsurarUID" id="EditExtraInsurarUID">
                    <option value=""></option>
					<%
						Hashtable extrainsurars = (Hashtable)((Hashtable)MedwanQuery.getInstance().getLabels().get(sWebLanguage.toLowerCase())).get("patientsharecoverageinsurance");
						boolean bApprovalNeeded=false;
						if(extrainsurars!=null){
							Enumeration eExtrainsurars = extrainsurars.keys();
							while(eExtrainsurars.hasMoreElements()){
								String key = (String)eExtrainsurars.nextElement();
								//Check if the insurer needs approval
								boolean bCanAdd=false;
								Insurar insr = Insurar.get(key);
								if(insr!=null && (insr.getNeedsApproval()==0 || activeUser.getAccessRight("financial.insurerapproval.select"))){
									bCanAdd=true;
								}
								if(insr!=null && insr.getNeedsApproval()==1 && !activeUser.getAccessRight("financial.insurerapproval.select")){
									bApprovalNeeded=true;
								}
								if(bCanAdd || sEditExtraInsurarUID.equalsIgnoreCase(key)){
									out.println("<option value='"+key+"' "+(sEditExtraInsurarUID.equalsIgnoreCase(key)?"selected":"")+">"+getTran(request,"patientsharecoverageinsurance",key,sWebLanguage)+"</option>");								
								}
								else{
									out.println("<option value='"+key+"' disabled "+(sEditExtraInsurarUID.equalsIgnoreCase(key)?"selected":"")+">"+getTran(request,"patientsharecoverageinsurance",key,sWebLanguage)+"</option>");								
								}
							}
						}
					%>
                </select>
                <%
					if(bApprovalNeeded){
				%>
					<input type='button' class='button' value='<%=getTranNoLink("web","requestapproval",sWebLanguage)%>' onclick='requestInsurerApproval(1)'/>
				<%
					}
                %>
            </td>
        </tr>
        <%
        	if(MedwanQuery.getInstance().getConfigInt("enableComplementaryInsurance2",0)==1){
        %>
        <tr>
            <td class="admin"><%=getTran(request,"web","complementarycoverage2",sWebLanguage)%></td>
            <td class="admin2">
                <select class="text" name="EditExtraInsurarUID2" id="EditExtraInsurarUID2">
                    <option value=""></option>
					<%
						bApprovalNeeded=false;
						Hashtable extrainsurars2 = (Hashtable)((Hashtable)MedwanQuery.getInstance().getLabels().get(sWebLanguage.toLowerCase())).get("patientsharecoverageinsurance2");
						if(extrainsurars2!=null){
							Enumeration eExtrainsurars2 = extrainsurars2.keys();
							while(eExtrainsurars2.hasMoreElements()){
								String key = (String)eExtrainsurars2.nextElement();
								//Check if the insurer needs approval
								boolean bCanAdd=false;
								Insurar insr = Insurar.get(key);
								if(insr!=null && (insr.getNeedsApproval()==0 || activeUser.getAccessRight("financial.insurerapproval.select"))){
									bCanAdd=true;
								}
								if(insr!=null && insr.getNeedsApproval()==1 && !activeUser.getAccessRight("financial.insurerapproval.select")){
									bApprovalNeeded=true;
								}
								if(bCanAdd || sEditExtraInsurarUID2.equalsIgnoreCase(key)){
									out.println("<option value='"+key+"' "+(sEditExtraInsurarUID2.equalsIgnoreCase(key)?"selected":"")+">"+getTran(request,"patientsharecoverageinsurance2",key,sWebLanguage)+"</option>");								
								}
								else{
									out.println("<option value='"+key+"' disabled "+(sEditExtraInsurarUID2.equalsIgnoreCase(key)?"selected":"")+">"+getTran(request,"patientsharecoverageinsurance2",key,sWebLanguage)+"</option>");								
								}
							}
						}
					%>
                </select>
                <%
					if(bApprovalNeeded){
				%>
					<input type='button' class='button' value='<%=getTranNoLink("web","requestapproval",sWebLanguage)%>' onclick='requestInsurerApproval(2)'/>
				<%
					}
                %>
            </td>
        </tr>
		<%
        	}
		%>        
        <%-- start --%>
        <tr>
            <td class="admin"><%=getTran(request,"web","default.insurance",sWebLanguage)%></td>
            <td class="admin2">
				<input type='checkbox' name='EditInsuranceDefault' id='EditInsuranceDefault' value='1' <%=sEditInsuranceDefault.equalsIgnoreCase("1")?"checked":"" %>/>
            </td>
        </tr>
        <%-- start --%>
        <tr>
            <td class="admin"><%=getTran(request,"web","start",sWebLanguage)%></td>
            <td class="admin2">
                <%
                	if(sEditInsuranceUID.length()==0 || activeUser.getAccessRight("financial.modifyinsurancebegin.select")){
                		out.print(writeDateField("EditInsuranceStart","EditInsuranceForm",sEditInsuranceStart,sWebLanguage));
                	}
                	else {
                		out.print(sEditInsuranceStart+"<input type='hidden' name='EditInsuranceStart' id='EditInsuranceStart' value='"+sEditInsuranceStart+"'/>");
                	}
                %>
            </td>
        </tr>
        <%-- stop --%>
        <tr>
            <td class="admin"><%=getTran(request,"web","stop",sWebLanguage)%></td>
            <td class="admin2">
                <%
                	if(sEditInsuranceUID.length()==0 || activeUser.getAccessRight("financial.modifyinsuranceend.select")){
                		out.println(writeDateField("EditInsuranceStop","EditInsuranceForm",sEditInsuranceStop,sWebLanguage));
                	}
                	else{
                		out.print(sEditInsuranceStop);
                	}
                %>
            </td>
        </tr>
        <%-- comment --%>
        <tr>
            <td class="admin"><%=getTran(request,"web","comment",sWebLanguage)%></td>
            <td class="admin2">
                <%=writeTextarea("EditInsuranceComment","69","4","",sEditInsuranceComment)%>
            </td>
        </tr>
        
        <tr id='authorization'></tr>
        
        <%=ScreenHelper.setFormButtonsStart()%>
	        <%
	        	if((sEditInsuranceUID.length()==0 && activeUser.getAccessRight("financial.insurance.add")) || activeUser.getAccessRight("financial.insurance.edit")){
	                %><input class="button" type="button" name="EditSaveButton" value='<%=getTranNoLink("Web","save",sWebLanguage)%>' onclick="doSave();">&nbsp;<%
	        	}
	        %>
            <input class="button" type="button" name="Backbutton" value='<%=getTranNoLink("Web","Back",sWebLanguage)%>' onclick="doSearchBack();">
            <input class="button" type="button" name="Accreditationbutton" id="Accreditationbutton" value='<%=getTranNoLink("Web","accreditation",sWebLanguage)%>' onclick="checkInsuranceAuthorization(true);">
        <%=ScreenHelper.setFormButtonsStop()%>
    </table>
    
    <input type="hidden" name="Action" value="">
</form>

<script>
  <%-- SET STATUS --%>
  function setStatus(){
  	if(document.getElementById("EditInsuranceStatus").value=="affiliate"){
       document.getElementById("EditInsuranceMember").value="<%=activePatient.firstname+" "+activePatient.lastname.toUpperCase()%>";
      if(document.getElementById("EditInsuranceMemberImmat")!=null){
        document.getElementById("EditInsuranceMemberImmat").value="<%=activePatient.getID(MedwanQuery.getInstance().getConfigString("EditInsuranceMemberImmatField","immatnew"))%>";
      }
  	}
  }

  <%-- CHECK INSURANCE AUTHORISATION --%>
  function checkInsuranceAuthorization(force,ignorewarnings){
	$('authorization').innerHTML = "<td class='admin'><td class='admin2'><img src='<c:url value="_img/themes/default/ajax-loader.gif"/>'/></td>"
    var params = "insuraruid="+EditInsuranceForm.EditInsurarUID.value+
                 "&personid=<%=activePatient.personid%>"+
                 "&language=<%=sWebLanguage%>"+
                 "&userid=<%=activeUser.userid%>";
	if(force){
		params+="&forceautorization=true";
	}                 
	if(ignorewarnings){
		if(window.confirm('<%=getTranNoLink("web","areyousuretoignorewarning",sWebLanguage)%>')){
			params+="&ignorewarnings=true";
		}
		else{
			return;	
		}
	}                 
    var url= '<c:url value="/financial/checkInsuranceAuthorization.jsp"/>?ts='+new Date();
    new Ajax.Request(url,{
	  method: "POST",
      parameters: params,
      onSuccess: function(resp){
        $('authorization').innerHTML = resp.responseText;
        if($('authorized') && $('authorized').value=='1'){
        	$('Accreditationbutton').style.display='none';
        }
      },
	  onFailure: function(){
	    alert('error');
      }
    });
  }
  
  function validateInsuranceNumber(){
	  <%if(MedwanQuery.getInstance().getConfigInt("enablePAODES",0)==1){%>
	  	//Only set limitation for UDAM numbers
	  	if(document.getElementById("EditInsurarUID").value=='<%=MedwanQuery.getInstance().getConfigString("UDAMInsurerCode","1.4")%>'){
	  		if(document.getElementById('EditInsuranceNr').value.length!=<%=MedwanQuery.getInstance().getConfigInt("UDAMInsurerCodeLength",21)%>){
	  			alert('<%=getTranNoLink("paodes","insurancenrmustbe21characters",sWebLanguage).replaceAll("@@size@@",MedwanQuery.getInstance().getConfigString("UDAMInsurerCodeLength","21"))%>');
	  			document.getElementById('EditInsuranceNr').focus();
	  			return false;
	  		}
	  	}
	  <%}%>
	  return true;
  }

  function requestInsurerApproval(type){
	  if(type==1){
		  openPopup("/financial/requestInsurerApproval.jsp&ts=<%=getTs()%>&PopupWidth=500&PopupHeight=100&insurertype=patientsharecoverageinsurance");
	  }
	  else{
		  openPopup("/financial/requestInsurerApproval.jsp&ts=<%=getTs()%>&PopupWidth=500&PopupHeight=100&insurertype=patientsharecoverageinsurance2");
	  }
  }

  checkInsuranceAuthorization();
  
  function showdetails(pointer){
	  openPopup("/financial/showDetails.jsp&ts=<%=getTs()%>&PopupWidth=500&PopupHeight=200&pointer="+pointer);
  }
</script>