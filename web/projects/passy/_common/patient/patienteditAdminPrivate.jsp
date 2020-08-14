<%@ page import="java.util.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/_common/patient/patienteditHelper.jsp"%>
<%=sJSEMAIL%>
<%
    if((activePatient!=null)&&(request.getParameter("SavePatientEditForm")==null)) {
    %>
<script type="text/javascript">

function changeHSRegion(){
    var today = new Date();

    var url= path + '/_common/search/searchByAjax/getHSDistrictsByRegion.jsp?ts=' + today;
    new Ajax.Request(url,{
            method: "POST",
            postBody: 'FindRegion=' + document.getElementById("HSRegion").value,
            onSuccess: function(resp){
                var s = resp.responseText;
                if (s.length>0){
                    var aDistricts = s.split("$");
                    $('HSDistrict').options.length=1;
                    $('HSPost').options.length=1;
                    $('HSVillage').options.length=1;
                    for(var i=0; i<aDistricts.length; i++){
                        aDistricts[i] = aDistricts[i].replace(/^\s+/,'');
                        aDistricts[i] = aDistricts[i].replace(/\s+$/,'');
                        if ((aDistricts[i].length>0)&&(aDistricts[i]!=" ")){
                            $("HSDistrict").options[i] = new Option(aDistricts[i], aDistricts[i]);
                        }
                    }
                }
            },
            onFailure: function(){
            }
        }
    );
}

function changeHSDistrict(){
    var today = new Date();

    var url= path + '/_common/search/searchByAjax/getHSPostsByDistrict.jsp?ts=' + today;
    new Ajax.Request(url,{
            method: "POST",
            postBody: 'FindDistrict=' + document.getElementById("HSDistrict").value,
            onSuccess: function(resp){
                var s = resp.responseText;
                if (s.length>0){
                    var aPosts = s.split("$");
                    $('HSPost').options.length=1;
                    $('HSVillage').options.length=1;
                    for(var i=0; i<aPosts.length; i++){
                    	aPosts[i] = aPosts[i].replace(/^\s+/,'');
                    	aPosts[i] = aPosts[i].replace(/\s+$/,'');
                        if ((aPosts[i].length>0)&&(aPosts[i]!=" ")){
                            $("HSPost").options[i] = new Option(aPosts[i], aPosts[i]);
                        }
                    }
                }
            },
            onFailure: function(){
            }
        }
    );
}

function changeHSPost(){
    var today = new Date();

    var url= path + '/_common/search/searchByAjax/getHSVillagesByPost.jsp?ts=' + today;
    new Ajax.Request(url,{
            method: "POST",
            postBody: 'FindPost=' + document.getElementById("HSPost").value,
            onSuccess: function(resp){
                var s = resp.responseText;
                if (s.length>0){
                    var aVillages = s.split("$");
                    $('HSVillage').options.length=1;
                    for(var i=0; i<aVillages.length; i++){
                    	aVillages[i] = aVillages[i].replace(/^\s+/,'');
                    	aVillages[i] = aVillages[i].replace(/\s+$/,'');
                        if ((aVillages[i].length>0)&&(aVillages[i]!=" ")){
                            $("HSVillage").options[i] = new Option(aVillages[i], aVillages[i]);
                        }
                    }
                }
            },
            onFailure: function(){
            }
        }
    );
}

function changeRegion(){
    var today = new Date();

    var url= path + '/_common/search/searchByAjax/getDistrictsByRegion.jsp?ts=' + today;
    new Ajax.Request(url,{
            method: "POST",
            postBody: 'FindRegion=' + document.getElementById("PSanitaryDistrict").value,
            onSuccess: function(resp){
                var sDistricts = resp.responseText;
                if (sDistricts.length>0){
                    var aDistricts = sDistricts.split("$");
                    $('PDistrict').options.length=1;
                    $('PSector').options.length=1;
                    $('PZipcode').value = "";
                    for(var i=0; i<aDistricts.length; i++){
                        aDistricts[i] = aDistricts[i].replace(/^\s+/,'');
                        aDistricts[i] = aDistricts[i].replace(/\s+$/,'');

                        if ((aDistricts[i].length>0)&&(aDistricts[i]!=" ")){
                            $("PDistrict").options[i] = new Option(aDistricts[i], aDistricts[i]);
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
            postBody: 'FindRegion=' + document.getElementById("PSanitaryDistrict").value+'&FindDistrict=' + document.getElementById("PDistrict").value,
            onSuccess: function(resp){
                var sCities = resp.responseText;

                if (sCities.length>0){
                    var aCities = sCities.split("$");
                    $('PSector').options.length=1;
                    $('PZipcode').value = "";
                    for(var i=0; i<aCities.length; i++){
                        aCities[i] = aCities[i].replace(/^\s+/,'');
                        aCities[i] = aCities[i].replace(/\s+$/,'');

                        if ((aCities[i].length>0)&&(aCities[i]!=" ")){
                            $("PSector").options[i] = new Option(aCities[i], aCities[i]);
                        }
                    }
                }
            },
            onFailure: function(){
            }
        }
    );
  }

function changeSector(){
    var today = new Date();

    var url= path + '/_common/search/searchByAjax/getZipcodeByCityAndDistrictAndRegion.jsp?ts=' + today;
    new Ajax.Request(url,{
            method: "POST",
            postBody: 'FindDistrict=' + document.getElementById("PDistrict").value+'&FindCity='+ document.getElementById("PSector").value+'&FindRegion='+ document.getElementById("PSanitaryDistrict").value,
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
            +"<img class='link' name='popcal' onclick='gfPop1.fPopCalendar(document.getElementsByName(\"PBegin\")[0]);return false;' src='"+sCONTEXTPATH+"/_img/icons/icon_agenda.png' ALT='"+getTran(request,"Web","Select",sWebLanguage)+"'>"
            +"&nbsp;<img class='link' src='"+sCONTEXTPATH+"/_img/icons/icon_compose.png' ALT='"+getTran(request,"Web","PutToday",sWebLanguage)+"' onclick='getToday(PBegin);'>");

        if (!bNew){
            sBeginDate+= " <img src='"+sCONTEXTPATH+"/_img/icons/icon_new.png' id='buttonNewAPC' class='link' alt='"+getTran(request,"Web","new",sWebLanguage)+"' onclick='newAPC()'>";
        }
        sBeginDate+= "</td></tr>";


        if(apc.cell==null || apc.cell.length()==0){
        	apc.cell=MedwanQuery.getInstance().getConfigString("defaultHealthStructure","");
        }
        String sHSRegions = "<select class='text' id='HSRegion' name='HSRegion' onchange='changeHSRegion();'><option/>";
        Vector vHSRegions = HealthStructure.getRegions();
        Collections.sort(vHSRegions);
        String sTmpHSRegion;
        boolean bHSRegionSelected = false;
        for (int i=0;i<vHSRegions.size();i++){
            sTmpHSRegion = (String)vHSRegions.elementAt(i);

            sHSRegions += "<option value='"+sTmpHSRegion+"'";

            if (apc.cell!=null &&  apc.cell.split(";").length>0 && sTmpHSRegion.equalsIgnoreCase(apc.cell.split(";")[0])){
                sHSRegions+=" selected";
                bHSRegionSelected = true;
            }
            sHSRegions += ">"+sTmpHSRegion+"</option>";
        }
        sHSRegions += "</select><input type='hidden' name='PCell' id='PCell'/>";

        String sHSDistricts = "<select class='text' id='HSDistrict' name='HSDistrict' onchange='changeHSDistrict();'><option/>";
        Vector vHSDistricts = new Vector();
        if(apc.cell.split(";").length>0){
        	vHSDistricts=HealthStructure.getDistricts(apc.cell.split(";")[0]);
	        Collections.sort(vHSDistricts);
	        String sTmpHSDistrict;
	        boolean bHSDistrictSelected = false;
	        for (int i=0;i<vHSDistricts.size();i++){
	            sTmpHSDistrict = (String)vHSDistricts.elementAt(i);
	
	            sHSDistricts += "<option value='"+sTmpHSDistrict+"'";
	
	            if (apc.cell!=null && apc.cell.split(";").length>1 && sTmpHSDistrict.equalsIgnoreCase(apc.cell.split(";")[1])){
	                sHSDistricts+=" selected";
	                bHSDistrictSelected = true;
	            }
	            sHSDistricts += ">"+sTmpHSDistrict+"</option>";
	        }
        }
        sHSDistricts += "</select>";

        String sHSPosts = "<select class='text' id='HSPost' name='HSPost' onchange='changeHSPost();'><option/>";
        Vector vHSPosts = new Vector();
        if(apc.cell.split(";").length>1){
        	vHSPosts=HealthStructure.getPosts(apc.cell.split(";")[1]);
	        Collections.sort(vHSPosts);
	        String sTmpHSPost;
	        boolean bHSPostSelected = false;
	        for (int i=0;i<vHSPosts.size();i++){
	            sTmpHSPost = (String)vHSPosts.elementAt(i);
	
	            sHSPosts += "<option value='"+sTmpHSPost+"'";
	
	            if (apc.cell!=null && apc.cell.split(";").length>2 && sTmpHSPost.equalsIgnoreCase(apc.cell.split(";")[2])){
	                sHSPosts+=" selected";
	                bHSPostSelected = true;
	            }
	            sHSPosts += ">"+sTmpHSPost+"</option>";
	        }
        }
        sHSPosts += "</select>";

        String sHSVillages = "<select class='text' id='HSVillage' name='HSVillage' ><option/>";
        Vector vHSVillages = new Vector();
        if(apc.cell.split(";").length>2){
        	vHSVillages=HealthStructure.getVillages(apc.cell.split(";")[2]);
	        Collections.sort(vHSVillages);
	        String sTmpHSVillage;
	        boolean bHSVillageSelected = false;
	        for (int i=0;i<vHSVillages.size();i++){
	            sTmpHSVillage = (String)vHSVillages.elementAt(i);
	
	            sHSVillages += "<option value='"+sTmpHSVillage+"'";
	
	            if (apc.cell!=null && apc.cell.split(";").length>3 && sTmpHSVillage.equalsIgnoreCase(apc.cell.split(";")[3])){
	                sHSVillages+=" selected";
	                bHSVillageSelected = true;
	            }
	            sHSVillages += ">"+sTmpHSVillage+"</option>";
	        }
        }
        sHSVillages += "</select>";

        String sRegions = "<select class='text' id='PSanitaryDistrict' name='PSanitaryDistrict' onchange='changeRegion();'><option/>";
        Vector vRegions = Zipcode.getRegions(MedwanQuery.getInstance().getConfigString("zipcodetable","RwandaZipcodes"));
        Collections.sort(vRegions);
        String sTmpRegion;
        boolean bRegionSelected = false;
        for (int i=0;i<vRegions.size();i++){
            sTmpRegion = (String)vRegions.elementAt(i);

            sRegions += "<option value='"+sTmpRegion+"'";

            if (sTmpRegion.equalsIgnoreCase(apc.sanitarydistrict)){
                sRegions+=" selected";
                bRegionSelected = true;
            }
            sRegions += ">"+sTmpRegion+"</option>";
        }

        if ((!bRegionSelected)&&(checkString(apc.sanitarydistrict).length()>0)){
            sRegions += "<option value='"+checkString(apc.sanitarydistrict)+"' selected>"+checkString(apc.sanitarydistrict)+"</option>";
        }
        sRegions += "</select>";

        String sDistricts = "<select class='text' id='PDistrict' name='PDistrict' onchange='changeDistrict();'><option/>";
        Vector vDistricts = Zipcode.getDistricts(apc.sanitarydistrict,MedwanQuery.getInstance().getConfigString("zipcodetable","RwandaZipcodes"));
        Collections.sort(vDistricts);
        String sTmpDistrict;
        boolean bDistrictSelected = false;
        for (int i=0;i<vDistricts.size();i++){
            sTmpDistrict = (String)vDistricts.elementAt(i);

            sDistricts += "<option value='"+sTmpDistrict+"'";

            if (sTmpDistrict.equalsIgnoreCase(apc.district)){
                sDistricts+=" selected";
                bDistrictSelected = true;
            }
            sDistricts += ">"+sTmpDistrict+"</option>";
        }

        if ((!bDistrictSelected)&&(checkString(apc.district).length()>0)){
            sDistricts += "<option value='"+checkString(apc.district)+"' selected>"+checkString(apc.district)+"</option>";
        }
        sDistricts += "</select>";

        String sCities = "<select class='text' id='PSector' name='PSector' onchange='changeSector()'><option/>";
        Vector vCities = Zipcode.getCities(apc.sanitarydistrict,apc.district,MedwanQuery.getInstance().getConfigString("zipcodetable","RwandaZipcodes"));
        Collections.sort(vCities);
        String sTmpCity;
        boolean bCitySelected = false;
        for (int i=0;i<vCities.size();i++){
            sTmpCity = (String)vCities.elementAt(i);

            sCities += "<option value='"+sTmpCity+"'";

            if (sTmpCity.equalsIgnoreCase(apc.sector)){
                sCities+=" selected";
                bCitySelected = true;
            }
            sCities += ">"+sTmpCity+"</option>";
        }

        if ((!bCitySelected)&&(checkString(apc.sector).length()>0)){
            sCities += "<option value='"+checkString(apc.sector)+"' selected>"+checkString(apc.sector)+"</option>";
        }
        sCities += "</select>";

        out.print(sBeginDate
    			  //Address
            	  +(
           	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateAddress",1)==0?"<input type='hidden' name='PAddress' value='"+checkString(apc.address)+"'/>":
                		inputRow(request,"Web","address","PAddress","AdminPrivate",apc.address,"T",true, true,sWebLanguage)
                   )
			  //Sanitary district
              +(
       	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateSanitaryDistrict",1)==0?"<input type='hidden' name='PSanitaryDistrict' value='"+checkString(apc.sanitarydistrict)+"'/>":
            		"<tr><td class='admin'>"+getTran(request,"web","region",sWebLanguage)+"</td><td class='admin2'>"+sRegions+"</td></tr>"
               )
			  //District
              +(
       	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateDistrict",1)==0?"<input type='hidden' name='PDistrict' value='"+checkString(apc.district)+"'/>":
            		"<tr><td class='admin'>"+getTran(request,"web","country.department",sWebLanguage)+"</td><td class='admin2'>"+sDistricts+"</td></tr>"
               )
			  //Sector
              +(
      	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateSector",1)==0?"<input type='hidden' name='PSector' value='"+checkString(apc.sector)+"'/>":
      	            "<tr><td class='admin'>"+getTran(request,"web","community",sWebLanguage)+"</td><td class='admin2'>"+sCities+"</td></tr>"
               )
			  //Zipcode
              +(
      	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateZipcode",1)==0?"<input type='hidden' name='PZipcode' value='"+checkString(apc.zipcode)+"'/>":
            		inputRow(request,"Web","zipcode","PZipcode","AdminPrivate",apc.zipcode,"T",true,false,sWebLanguage)
               )
			  //Country
              +(
       	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateCountry",1)==0?"<input type='hidden' name='PCountry' value='"+checkString(apc.country)+"'/>":
            		writeCountry(request,apc.country,"PCountry","AdminPrivate","PCountryDescription",true, "Country",sWebLanguage)
               )
              +"<tr><td class='admin' colspan='2'>"+getTran(request,"web","healthstructure",sWebLanguage)+"</td></tr>"
			  //HSRegion
              +(
      	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateHSRegion",1)==0?"<input type='hidden' name='HSRegion' id='HSRegion' value='"+(checkString(apc.cell).split(";").length>0?apc.cell.split(";")[0]:"")+"'/>":
      	      		"<tr><td class='admin'>"+getTran(request,"web","healthregion",sWebLanguage)+"</td><td class='admin2'>"+sHSRegions+"</td></tr>"
               )
			  //HSDistrict
              +(
      	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateHSDistrict",1)==0?"<input type='hidden' name='HSDistrict' id='HSDistrict' value='"+(checkString(apc.cell).split(";").length>1?apc.cell.split(";")[1]:"")+"'/>":
      	            "<tr><td class='admin'>"+getTran(request,"web","healthdistrict",sWebLanguage)+"</td><td class='admin2'>"+sHSDistricts+"</td></tr>"
               )
			  //HSPost
              +(
      	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateHSPost",1)==0?"<input type='hidden' name='HSPost' id='HSPost' value='"+(checkString(apc.cell).split(";").length>2?apc.cell.split(";")[2]:"")+"'/>":
      	            "<tr><td class='admin'>"+getTran(request,"web","healthpost",sWebLanguage)+"</td><td class='admin2'>"+sHSPosts+"</td></tr>"
               )
			  //HSVillage
              +(
      	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateHSVillage",1)==0?"<input type='hidden' name='HSVillage' id='HSVillage' value='"+(checkString(apc.cell).split(";").length>3?apc.cell.split(";")[3]:"")+"'/>":
      	            "<tr><td class='admin'>"+getTran(request,"web","healthvillage",sWebLanguage)+"</td><td class='admin2'>"+sHSVillages+"</td></tr>"
               )
			  //Email
              +(
       	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateEmail",1)==0?"<input type='hidden' name='PEmail' value='"+checkString(apc.email)+"'/>":
            		inputRow(request,"Web","email","PEmail","AdminPrivate",apc.email,"T",true,false,sWebLanguage)
               )
			  //Phone
              +(
       	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateTelephone",1)==0?"<input type='hidden' name='PTelephone' value='"+checkString(apc.telephone)+"'/>":
            		inputRow(request,"Web","telephone","PTelephone","AdminPrivate",apc.telephone,"T",true,false,sWebLanguage)
               )
			  //Mobile phone
              +(
       	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateMobile",1)==0?"<input type='hidden' name='PMobile' value='"+checkString(apc.mobile)+"'/>":
            		inputRow(request,"Web","mobile","PMobile","AdminPrivate",apc.mobile,"T",true,false,sWebLanguage)
               )
  			  //Function
               +(
        	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateFunction",1)==0?"<input type='hidden' name='PFunction' value='"+checkString(apc.businessfunction)+"'/>":
             		inputRow(request,"Web","function","PFunction","AdminPrivate",apc.businessfunction,"T",true,false,sWebLanguage)
                )
 			  //Business
               +(
        	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateBusiness",1)==0?"<input type='hidden' name='PBusiness' value='"+checkString(apc.business)+"'/>":
             		inputRow(request,"Web","business","PBusiness","AdminPrivate",apc.business,"T",true,false,sWebLanguage)
                )
 			  //Comment
               +(
        	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateComment",1)==0?"<input type='hidden' name='PComment' value='"+checkString(apc.comment)+"'/>":
             		inputRow(request,"Web","comment","PComment","AdminPrivate",apc.comment,"T",true,false,sWebLanguage))
        		   );
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
      document.getElementsByName("PAddress")[0].value = "";
      document.getElementsByName("PZipcode")[0].value = "";
      document.getElementsByName("PCountry")[0].value = "<%=sDefaultCountry%>";
      document.getElementsByName("PEmail")[0].value = "";
      document.getElementsByName("PTelephone")[0].value = "";
      document.getElementsByName("PMobile")[0].value = "";
      document.getElementsByName("PProvince")[0].value = "";
      document.getElementById("PDistrict").value = "";
      document.getElementsByName("PCell")[0].value = "";
      document.getElementsByName("PCity")[0].value = "";
      document.getElementsByName("PFunction")[0].value = "";
      document.getElementsByName("PBusiness")[0].value = "";
      document.getElementsByName("PComment")[0].value = "";
    }

    getToday(document.getElementsByName("PBegin")[0]);
    document.getElementsByName("PBegin")[0].focus();
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
        alertDialog("web","invalidEmailAddress");
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
      document.getElementById("PCell").value=document.getElementById("HSRegion").value+";"+document.getElementById("HSDistrict").value+";"+document.getElementById("HSPost").value+";"+document.getElementById("HSVillage").value;
    }

    return maySubmit;
  }

  var path = '<c:url value="/"/>';

</script>
<%
    }
%>