<%@page import="java.util.Hashtable,
                be.openclinic.finance.Prestation"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%
    String sAction = checkString(request.getParameter("Action")); 

	String sEditPrestationGroup = checkString(request.getParameter("EditPrestationGroup")),
	       sEditPrestationName  = checkString(request.getParameter("EditPrestationName"));

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
    	Debug.println("\n****************** system/managePrestationGroups.jsp ******************");
    	Debug.println("sAction              : "+sAction);
    	Debug.println("sEditPrestationGroup : "+sEditPrestationGroup);
    	Debug.println("sEditPrestationName  : "+sEditPrestationName+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
    String sMsg = "";
    
    //*** NEW group ***
	if(sAction.equals("newGroup")){
		String sGroupName = request.getParameter("newgroupname");
		Debug.println("NEW group : "+sGroupName);
		
		String sSql = "select * from oc_prestation_groups where oc_group_description = ?";
		PreparedStatement ps = oc_conn.prepareStatement(sSql);
		ps.setString(1,sGroupName);
		ResultSet rs = ps.executeQuery();
		int newGroupCounter = MedwanQuery.getInstance().getOpenclinicCounter("OC_PRESTATION_GROUP");
		
		if(!rs.next()){
			rs.close();
			ps.close();
			
			sSql = "insert into oc_prestation_groups(oc_group_serverid,oc_group_objectid,oc_group_description)"+
			       " values(?,?,?)";
			ps = oc_conn.prepareStatement(sSql);
			ps.setInt(1,MedwanQuery.getInstance().getConfigInt("serverId",1));
			ps.setInt(2,newGroupCounter);
			ps.setString(3,sGroupName);
			ps.execute();
			ps.close();
			
			
		}
		else{
			rs.close();
			ps.close();
		}
		
		sEditPrestationGroup = MedwanQuery.getInstance().getConfigInt("serverId",1)+"."+newGroupCounter;
		sMsg = getTran(request,"web","groupAdded",sWebLanguage);
	}
    //*** DELETE group ***
    else if(sAction.equals("deleteGroup")){
		Debug.println("DELETE group : "+request.getParameter("deletegroupuid"));
		
		String sSql = "delete from oc_prestation_groups"+
	                  " where oc_group_serverid=? and oc_group_objectid=?";
		PreparedStatement ps = oc_conn.prepareStatement(sSql);
		ps.setInt(1,Integer.parseInt(request.getParameter("deletegroupuid").split("\\.")[0]));
		ps.setInt(2,Integer.parseInt(request.getParameter("deletegroupuid").split("\\.")[1]));
		ps.executeUpdate();
		ps.close();
		
		sMsg = getTran(request,"web","groupDeleted",sWebLanguage);
	}
    //*** ADD prestation ***
	else if(sAction.equals("addPrestation")){
		Debug.println("ADD prestation : "+sEditPrestationGroup+" ("+sEditPrestationName+")");
		
		String sSql = "select * from oc_prestationgroups_prestations"+
	                  " where oc_prestationgroup_groupuid = ?"+
		              "  and oc_prestationgroup_prestationuid = ?";
		PreparedStatement ps = oc_conn.prepareStatement(sSql);
		ps.setString(1,sEditPrestationGroup);
		ps.setString(2,sEditPrestationName);
		ResultSet rs = ps.executeQuery();
		if(!rs.next()){
			rs.close();
			ps.close();
			
			sSql = "insert into oc_prestationgroups_prestations(oc_prestationgroup_groupuid,oc_prestationgroup_prestationuid)"+
			       " values(?,?)";
			ps=oc_conn.prepareStatement(sSql);
			ps.setString(1,sEditPrestationGroup);
			ps.setString(2,sEditPrestationName);
			ps.execute();
			ps.close();
			
			sMsg = getTran(request,"web","prestationAdded",sWebLanguage);
		}
		else{
			rs.close();
			ps.close();
			
			sMsg = getTran(request,"web","prestationAlreadyExists",sWebLanguage);
		}
	}
    //*** DELETE prestation ***
	else if(sAction.equals("deletePrestation")){
		Debug.println("DELETE prestation : "+request.getParameter("deleteprestationuid"));
		
		String sSql = "delete from oc_prestationgroups_prestations"+
	                  " where oc_prestationgroup_groupuid=? and oc_prestationgroup_prestationuid=?";
		PreparedStatement ps = oc_conn.prepareStatement(sSql);
		ps.setString(1,sEditPrestationGroup);
		ps.setString(2,request.getParameter("deleteprestationuid"));
		ps.executeUpdate();
		ps.close();

		sMsg = getTran(request,"web","prestationDeleted",sWebLanguage);
	}
%>
<form name='EditForm' method='POST'>
    <%=writeTableHeader("Web.manage","ManagePrestationGroups",sWebLanguage," doBack();")%>
    <input type="hidden" name="Action" value="">
    
	<table width="100%" class="list" cellpadding="0" cellspacing="1">
		<%-- PRESTATION GROUP --%>
		<tr>
			<td width="120" class="admin2"><%=getTran(request,"web","prestationgroup",sWebLanguage)%></td>
			<td width="180" class="admin2" nowrap>
				<select class="text" name="EditPrestationGroup" id="EditPrestationGroup" onchange="loadPrestations();">
                    <option/>
					<%
						String sSql = "select * from oc_prestation_groups"+
					                  " order by oc_group_description";
						PreparedStatement ps = oc_conn.prepareStatement(sSql);
						ResultSet rs = ps.executeQuery();
						while(rs.next()){
							String sGroupUid = rs.getInt("oc_group_serverid")+"."+rs.getInt("oc_group_objectid");
							out.println("<option "+(sEditPrestationGroup.equalsIgnoreCase(sGroupUid)?"selected":"")+" value='"+sGroupUid+"'>"+rs.getString("oc_group_description")+"</option>");
						}
						rs.close();
						ps.close();
						oc_conn.close();
					%>
				</select> <a href='javascript:deleteGroup();'><img class="link" src='<c:url value="/_img/icons/icon_delete.png"/>'/></a>
			</td>
			
			<%-- NEW GROUP NAME --%>
			<td class="admin2">
				<input type='text' class='text' name='newgroupname' id='newgroupname' size='25' maxLength='50'/>
				<input type='button' class='button' name='newgroup' value='<%=getTranNoLink("web","new",sWebLanguage)%>' onclick='createNewGroup();'/>
			</td>
		</tr>
		
		<%-- PRESTATION --%>
		<tr>
            <td class="admin2"><%=getTran(request,"web","prestation",sWebLanguage)%></td>
            <td class="admin2" colspan="2">
                <input type="hidden" name="tmpPrestationUID">
                <input type="hidden" name="tmpPrestationName">

                <select class="text" name="EditPrestationName" id="EditPrestationName">
                    <option/>
                    <%
                    	Vector vPopularPrestations = activeUser.getTopPopularPrestations(10);
                        if(vPopularPrestations!=null){
                            String sPrestationUid;
                            for(int i=0; i<vPopularPrestations.size(); i++){
                                sPrestationUid = checkString((String)vPopularPrestations.elementAt(i));
                                
                                if(sPrestationUid.length() > 0){
                                    Prestation prestation = Prestation.get(sPrestationUid);
                                    if(prestation!=null){
                                        out.print("<option value='"+checkString(prestation.getUid())+"'>"+checkString(prestation.getDescription())+"</option>");
                                    }
                                }
                            }
                        }
                    %>
                </select>
                
                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchPrestation();">&nbsp;
                <input type="button" class="button" onclick="addPrestation();" value="<%=getTranNoLink("web","add",sWebLanguage)%>">
            </td>
        </tr>
	</table>
	
	<div id="msgDiv" style="height:18px">
	<%
	    if(sMsg.length() > 0){
	        %><%=sMsg%><br><%
	    }
	%>		
	</div>
	
	<div id="prestationcontent"></div>
	
    <input type="hidden" name="tmpPrestationUID">
    <input type="hidden" name="tmpPrestationName">
    <input type="hidden" name="deleteprestationuid">
    <input type="hidden" name="deletegroupuid">	
</form>

<%=ScreenHelper.alignButtonsStart()%>
    <input type="button" class="button" name="backButton" value="<%=getTranNoLink("web","back",sWebLanguage)%>" onClick="doBack();">
<%=ScreenHelper.alignButtonsStop()%>

<script>
  <%-- ADD PRESTATION --%>
  function addPrestation(){
	if(EditForm.EditPrestationName.selectedIndex > 0){
      EditForm.Action.value = "addPrestation";
	  EditForm.submit();
	}
	else{
	  alertDialog("web.manage","dataMissing");
	  EditForm.EditPrestationName.focus();
	}
  }
 
  <%-- LOAD PRESTATIONS --%>
  function loadPrestations(){
	if(EditForm.EditPrestationGroup.selectedIndex > 0){
      document.getElementById("prestationcontent").innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br>Loading..";
	}
	
    var url = '<c:url value="/financial/getGroupPrestations.jsp"/>?ts='+new Date().getTime();
    new Ajax.Request(url,{
      method: "POST",
      postBody: 'PrestationGroupUID='+EditForm.EditPrestationGroup.value,
      onSuccess: function(resp){
        var label = eval('('+resp.responseText+')');
        document.getElementById('prestationcontent').innerHTML = label.PrestationContent;
      },
      onFailure: function(){
        alert("error");
      }
    });
  }

  <%-- CREATE NEW GROUP --%>
  function createNewGroup(){
	if(document.getElementById("newgroupname").value.length > 0){
	  EditForm.Action.value = "newGroup";
      EditForm.submit();
	}
	else{
      document.getElementById("newgroupname").focus();
	}
  }

  <%-- SEARCH PRESTATION --%>
  function searchPrestation(){
    EditForm.tmpPrestationName.value = "";
    EditForm.tmpPrestationUID.value = "";
    
    var url = "/_common/search/searchPrestation.jsp&ts="+new Date().getTime()+
              "&ReturnFieldUid=tmpPrestationUID"+
              "&ReturnFieldDescr=tmpPrestationName"+
              "&doFunction=setSearchedPrestation()";
    openPopup(url);
  }

  <%-- SET SEARCHED PRESTATION --%>
  function setSearchedPrestation(){
    if(document.getElementsByName('tmpPrestationUID')[0].value.length > 0){
      var optionCount = EditForm.EditPrestationName.options.length;

      var newOption = new Option();
      newOption.text = document.getElementsByName('tmpPrestationName')[0].value;
      newOption.value = document.getElementsByName('tmpPrestationUID')[0].value;
   
      EditForm.EditPrestationName.options.add(newOption);
      EditForm.EditPrestationName.options[optionCount].selected = true;
    }
  }

  <%-- DELETE PRESTATION --%>
  function deletePrestation(prestationuid){
	if(yesnoDeleteDialog()){
  	  document.getElementsByName('deleteprestationuid')[0].value=prestationuid;
	  EditForm.Action.value = "deletePrestation";
	  EditForm.submit();
	}
  }

  <%-- DELETE GROUP --%>
  function deleteGroup(){
    if(document.getElementsByName('EditPrestationGroup')[0].value.length>0){
	  if(yesnoDeleteDialog()){
        document.getElementsByName('deletegroupuid')[0].value = document.getElementsByName('EditPrestationGroup')[0].value;
        EditForm.Action.value = "deleteGroup";
        EditForm.submit();
      }
	}
    else{
      alertDialog("web","firstSelectGroup");
      document.getElementById("EditPrestationGroup").focus();
    }
  }

  <%-- DO BACK --%>
  function doBack(){
    window.location.href = "<%=sCONTEXTPATH%>/main.jsp?Page=system/menu.jsp";
  }
  
  <%
      // do not load prestations on creation of a new group, nor on initial page-load
      if(sAction.length() > 0 && !sAction.equals("newGroup")){
    	%>loadPrestations();<%  
      }		
  %>
  
  window.setTimeout("document.getElementById('msgDiv').innerHTML = '';",2500);
</script>