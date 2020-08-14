<%@ page import="java.util.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/_common/patient/patienteditHelper.jsp"%>
<%=sJSEMAIL%>
<%
    if((activePatient!=null)&&(request.getParameter("SavePatientEditForm")==null)) {
    %>
<script>
	function changeRegion(){
	    var today = new Date();
	
	    var url= path + '/_common/search/searchByAjax/getDistrictsByRegion.jsp?ts=' + today;
	    new Ajax.Request(url,{
	            method: "POST",
	            postBody: '&FindRegion='+document.getElementById("PDistrict").value,
	            onSuccess: function(resp){
	                var sDistricts = resp.responseText;
	
	                if (sDistricts.length>0){
	                    var aDistricts = sDistricts.split("$");
	                    $('PSector').options.length=1;
	                    $('PZipcode').value = "";
	                    for(var i=0; i<aDistricts.length; i++){
	                    	aDistricts[i] = aDistricts[i].replace(/^\s+/,'');
	                    	aDistricts[i] = aDistricts[i].replace(/\s+$/,'');
	
	                        if ((aDistricts[i].length>0)&&(aDistricts[i]!=" ")){
	                            $("PSector").options[i] = new Option(aDistricts[i], aDistricts[i]);
	                        }
	                    }
	                }
	            },
	            onFailure: function(){
	            }
	        }
	    );
	  }

	function changeDistrict(){
	    var today = new Date();
	
	    var url= path + '/_common/search/searchByAjax/getCitiesByDistrictAndRegion.jsp?ts=' + today;
	    new Ajax.Request(url,{
	            method: "POST",
	            postBody: 'FindDistrict=' + document.getElementById("PSector").value+'&FindRegion='+document.getElementById("PDistrict").value,
	            onSuccess: function(resp){
	                var sCities = resp.responseText;
	
	                if (sCities.length>0){
	                    var aCities = sCities.split("$");
	                    $('PCity').options.length=1;
	                    $('PZipcode').value = "";
	                    for(var i=0; i<aCities.length; i++){
	                        aCities[i] = aCities[i].replace(/^\s+/,'');
	                        aCities[i] = aCities[i].replace(/\s+$/,'');
	
	                        if ((aCities[i].length>0)&&(aCities[i]!=" ")){
	                            $("PCity").options[i] = new Option(aCities[i], aCities[i]);
	                        }
	                    }
	                }
	            },
	            onFailure: function(){
	            }
	        }
	    );
	  }
	
    function changeCity(){
        var today = new Date();

        var url= path + '/_common/search/searchByAjax/getZipcodeByCityAndDistrictAndRegion.jsp?ts=' + today;
        new Ajax.Request(url,{
                method: "POST",
                postBody: 'FindRegion=' + document.getElementById("PDistrict").value+'&FindDistrict=' + document.getElementById("PSector").value+'&FindCity='+ document.getElementById("PCity").value
            ,
                onSuccess: function(resp){
                    var zipcode = resp.responseText;
                    $("PZipcode").value = zipcode.trim();
                },
                onFailure: function(){
                }
            }
        );
    }

    function setProvince(prov){
        for(n=0;n<document.getElementById("PProvince").options.length;n++){
            if (document.getElementById("PProvince").options[n].value==prov){
                document.getElementById("PProvince").selectedIndex=n;
                break;
            }
        }
    }
</script>
        <table border='0' width='100%' class="list" cellspacing="1">
    <%
        AdminPrivateContact apc = ScreenHelper.getActivePrivate(activePatient);

        boolean bNew = false;
        String sStartDate;
        if (apc == null || apc.privateid==null || apc.privateid.length()==0 || Integer.parseInt(apc.privateid)<0) {
            apc = new AdminPrivateContact();
            apc.begin = getDate();
            apc.country = sDefaultCountry;
            bNew = true;
            sStartDate = "PatientEditForm.DateOfBirth.value";
        }
        else {
            sStartDate = "\""+apc.begin+"\"";
        }

        String sBeginDate = normalRow("Web.admin","addresschangesince","PBegin","AdminPrivate",sWebLanguage);
        sBeginDate+="<input class='text' type='text' name='PBegin' value=\""+apc.begin.trim()+"\"";

        /*if (bEditable) {
            sBeginDate+= sBackground;
        }*/

        sBeginDate+=(" size='12' onblur='checkBegin(this,"+sStartDate.trim()+")'>&nbsp;"
            +"<img class='link' name='popcal' onclick='gfPop1.fPopCalendar(document.all[\"PBegin\"]);return false;' src='"+sCONTEXTPATH+"/_img/icons/icon_agenda.png' ALT='"+getTran(request,"Web","Select",sWebLanguage)+"'>"
            +"&nbsp;<img class='link' src='"+sCONTEXTPATH+"/_img/icons/icon_compose.png' ALT='"+getTran(request,"Web","PutToday",sWebLanguage)+"' onclick='getToday(PBegin);'>");

        if (!bNew){
            sBeginDate+= " <img src='"+sCONTEXTPATH+"/_img/icons/icon_new.png' id='buttonNewAPC' class='link' alt='"+getTran(request,"Web","new",sWebLanguage)+"' onclick='newAPC()'>";
//            sBeginDate+= "&nbsp;<input type='button' name='buttonNewAPC' class='button' onclick='newAPC()' value='"+getTran(request,"Web","new",sWebLanguage)+"'>";
        }
        sBeginDate+= "</td></tr>";

        String sRegions = "<select class='text' id='PDistrict' name='PDistrict' onchange='changeRegion();'><option/>";
        Vector vRegions = Zipcode.getRegions(MedwanQuery.getInstance().getConfigString("zipcodetable","RwandaZipcodes"));
        Collections.sort(vRegions);
        String sTmpRegion;
        boolean bRegionSelected = false;
        for (int i=0;i<vRegions.size();i++){
            sTmpRegion = (String)vRegions.elementAt(i);

            sRegions += "<option value='"+sTmpRegion+"'";

            if (sTmpRegion.equalsIgnoreCase(apc.district)){
                sRegions+=" selected";
                bRegionSelected = true;
            }
            sRegions += ">"+sTmpRegion+"</option>";
        }

        String sDistricts = "<select class='text' id='PSector' name='PSector' onchange='changeDistrict();'><option/>";
        Vector vDistricts = Zipcode.getDistricts(apc.district,MedwanQuery.getInstance().getConfigString("zipcodetable","RwandaZipcodes"));
        Collections.sort(vDistricts);
        String sTmpDistrict;
        boolean bDistrictSelected = false;
        for (int i=0;i<vDistricts.size();i++){
            sTmpDistrict = (String)vDistricts.elementAt(i);

            sDistricts += "<option value='"+sTmpDistrict+"'";

            if (sTmpDistrict.equalsIgnoreCase(apc.sector)){
                sDistricts+=" selected";
                bDistrictSelected = true;
            }
            sDistricts += ">"+sTmpDistrict+"</option>";
        }

        if ((!bDistrictSelected)&&(checkString(apc.district).length()>0)){
            sDistricts += "<option value='"+checkString(apc.sector)+"' selected>"+checkString(apc.sector)+"</option>";
        }
        sDistricts += "</select>";

        String sCities = "<select class='text' id='PCity' name='PCity' onchange='changeCity();'><option/>";
        Vector vCities = Zipcode.getCities(apc.district,apc.sector,MedwanQuery.getInstance().getConfigString("zipcodetable","RwandaZipcodes"));
        Collections.sort(vCities);
        String sTmpCity;
        boolean bCitySelected = false;
        for (int i=0;i<vCities.size();i++){
            sTmpCity = (String)vCities.elementAt(i);

            sCities += "<option value='"+sTmpCity+"'";

            if (sTmpCity.equalsIgnoreCase(apc.city)){
                sCities+=" selected";
                bCitySelected = true;
            }
            sCities += ">"+sTmpCity+"</option>";
        }

        if ((!bCitySelected)&&(checkString(apc.city).length()>0)){
            sCities += "<option value='"+checkString(apc.city)+"' selected>"+checkString(apc.city)+"</option>";
        }
        sCities += "</select>";

        out.print(sBeginDate
            +inputRow(request,"Web","address","PAddress","AdminPrivate",apc.address,"T",true, true,sWebLanguage)
            +"<tr><td class='admin'>"+getTran(request,"web","province",sWebLanguage)+"</td><td class='admin2'>"+sRegions+"</td></tr>"
            +"<tr><td class='admin'>"+getTran(request,"web","community",sWebLanguage)+"</td><td class='admin2'>"+sDistricts+"</td></tr>"
            +"<tr><td class='admin'>"+getTran(request,"web","hill_quarter",sWebLanguage)+"</td><td class='admin2'>"+sCities+"</td></tr>"
            +inputRow(request,"Web","zipcode","PZipcode","AdminPrivate",apc.zipcode,"T",false,false,sWebLanguage)
            +writeCountry(request,apc.country,"PCountry","AdminPrivate","PCountryDescription",true, "Country",sWebLanguage)
            +inputRow(request,"Web","email","PEmail","AdminPrivate",apc.email,"T",true,false,sWebLanguage)
            +inputRow(request,"Web","telephone","PTelephone","AdminPrivate",apc.telephone,"T",true,false,sWebLanguage)
            +inputRow(request,"Web","mobile","PMobile","AdminPrivate",apc.mobile,"T",true,false,sWebLanguage)
            //+inputRow(request,"Web","province","PProvince","AdminPrivate",apc.province,"T",true,false,sWebLanguage)
            //+"<tr><td class='admin'>"+getTran(request,"web","province",sWebLanguage)+"</td><td class='admin2'><select class='text' name='PProvince' id='PProvince'><option/>"
                //+ScreenHelper.writeSelect(request,"province",apc.province,sWebLanguage,false,true)
                //+"</select></td></tr>"
            +inputRow(request,"Web","cell","PCell","AdminPrivate",apc.cell,"T",true,false,sWebLanguage)
            +inputRow(request,"Web","function","PFunction","AdminPrivate",apc.businessfunction,"T",true,false,sWebLanguage)
            +inputRow(request,"Web","business","PBusiness","AdminPrivate",apc.business,"T",true,false,sWebLanguage)
            +inputRow(request,"Web","comment","PComment","AdminPrivate",apc.comment,"T",true,false,sWebLanguage));
    %>
    <%-- spacer --%>
    <tr height="0">
        <td width='<%=sTDAdminWidth%>'/><td width='*'/>
    </tr>
</table>
<script>
  function newAPC(){
    retVal = makeMsgBox("?","<%=getTran(null,"Web.admin","recuperation_old_data",sWebLanguage)%>",32,3,0,4096);

    if (retVal==7){
      document.all["PAddress"].value = "";
      document.all["PZipcode"].value = "";
      document.all["PCountry"].value = "<%=sDefaultCountry%>";
      document.all["PEmail"].value = "";
      document.all["PTelephone"].value = "";
      document.all["PMobile"].value = "";
      document.all["PProvince"].value = "";
      document.getElementById("PDistrict").value = "";
      document.getElementById("PSector").value = "";
      document.getElementById("PCity").value = "";
      document.all["PCell"].value = "";
      document.all["PFunction"].value = "";
      document.all["PBusiness"].value = "";
      document.all["PComment"].value = "";
    }

    getToday(document.all["PBegin"]);
    document.all["PBegin"].focus();
  }

  <%-- check submit admin private --%>
  function checkSubmitAdminPrivate() {
    var maySubmit = true;

    var sObligatoryFields = "<%=MedwanQuery.getInstance().getConfigString("ObligatoryFields_AdminPrivate")%>";
    var aObligatoryFields = sObligatoryFields.split(",");

    <%-- check for valid email --%>
    if(PatientEditForm.PEmail.value.length > 0){
      if(!validEmailAddress(PatientEditForm.PEmail.value)){
        maySubmit = false;
        displayGenericAlert = false;

        var popupUrl = "<c:url value="/popup.jsp"/>?Page=_common/search/okPopup.jsp&ts=999999999&labelType=Web&labelID=invalidemailaddress";
        var modalities = "dialogWidth:266px;dialogHeight:163px;center:yes;scrollbars:no;resizable:no;status:no;location:no;";
        (window.showModalDialog)?window.showModalDialog(popupUrl,"",modalities):window.confirm("<%=getTranNoLink("web","invalidemailaddress",sWebLanguage)%>");

        activateTab('AdminPrivate');
        PatientEditForm.PEmail.focus();
      }
    }

    <%-- check obligatory field for content --%>
    for(var i=0; i<aObligatoryFields.length; i++){
      var obligatoryField = document.all(aObligatoryFields[i]);

      if(obligatoryField != null){
        if(obligatoryField.type == undefined){
          if(obligatoryField.innerHTML == ""){
            maySubmit = false;
            break;
          }
        }
        else if(obligatoryField.value == ""){
          if(obligatoryField.type != "hidden"){
            activateTab('AdminPrivate');
            obligatoryField.focus();
          }
          maySubmit = false;
          break;
        }
      }
    }

    return maySubmit;
  }

  var path = '<c:url value="/"/>';
  
</script>
<%
    }
%>