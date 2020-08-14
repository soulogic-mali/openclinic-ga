<%@ page import="java.util.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/_common/patient/patienteditHelper.jsp"%>
<%=sJSEMAIL%>
<%
    if((activePatient!=null)&&(request.getParameter("SavePatientEditForm")==null)) {
    %>
<script>
    function changeDistrict(){
      var today = new Date();

      var url= path + '/_common/search/searchByAjax/getCitiesByDistrict.jsp?ts=' + today;
      new Ajax.Request(url,{
              method: "POST",
              postBody: 'FindDistrict=' + document.getElementById("PDistrict").value,
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

        var url= path + '/_common/search/searchByAjax/getZipcodeByCityAndDistrict.jsp?ts=' + today;
        new Ajax.Request(url,{
                method: "POST",
                postBody: 'FindDistrict=' + document.getElementById("PDistrict").value+'&FindCity='+ document.getElementById("PSector").value
            ,
                onSuccess: function(resp){
                    var zipcode = resp.responseText;
                    $("PZipcode").value = zipcode.trim();
                    var prov=zipcode.substring(zipcode.indexOf("0"),zipcode.indexOf("0")+2);
                    if(prov=="01"){
                        setProvince("vk");
                    }
                    else if(prov=="02"){
                        setProvince("south");
                    }
                    else if(prov=="03"){
                        setProvince("west");
                    }
                    else if(prov=="04"){
                        setProvince("north");
                    }
                    else if(prov=="05"){
                        setProvince("east");
                    }
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
//            sBeginDate+= "&nbsp;<input type='button' name='buttonNewAPC' class='button' onclick='newAPC()' value='"+getTran(request,"Web","new",sWebLanguage)+"'>";
        }
        sBeginDate+= "</td></tr>";

        String sDistricts = "<select class='text' id='PDistrict' name='PDistrict' onchange='changeDistrict();'><option/>";
        Vector vDistricts = Zipcode.getDistricts(MedwanQuery.getInstance().getConfigString("zipcodetable","RwandaZipcodes"));
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
        Vector vCities = Zipcode.getCities(apc.district,MedwanQuery.getInstance().getConfigString("zipcodetable","RwandaZipcodes"));
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

        if ((!bCitySelected)&&(checkString(apc.city).length()>0)){
            sCities += "<option value='"+checkString(apc.city)+"' selected>"+checkString(apc.city)+"</option>";
        }
        sCities += "</select>";

        out.print(sBeginDate
  			  //Address
          	  +(
         	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateAddress",1)==0?"<input type='hidden' name='PAddress' value='"+checkString(apc.address)+"'/>":
              		inputRow(request,"Web","address","PAddress","AdminPrivate",apc.address,"T",true, true,sWebLanguage)
                 )
			  //District
              +(
       	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateDistrict",1)==0?"<input type='hidden' name='PDistrict' value='"+checkString(apc.district)+"'/>":
            		"<tr><td class='admin'>"+getTran(request,"web","region",sWebLanguage)+"</td><td class='admin2'>"+sDistricts+"</td></tr>"
               )
			  //Sector
              +(
      	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateSector",1)==0?"<input type='hidden' name='PSector' value='"+checkString(apc.sector)+"'/>":
            		"<tr><td class='admin'>"+getTran(request,"web","district",sWebLanguage)+"</td><td class='admin2'>"+sCities+"</td></tr>"
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
			  //Email
              +(
       	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateEmail",1)==0?"<input type='hidden' name='PEmail' value='"+checkString(apc.email)+"'/>":
            		inputRow(request,"Web","email","PEmail","AdminPrivate",apc.email,"T",true,false,sWebLanguage)
               )
			  //Phone
              +(
       	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateTelephone",1)==0?"<input type='hidden' name='PTelephone' id='PTelephone' value='"+checkString(apc.telephone)+"'/>":
       	      		"<tr><td class='admin'>"+getTran(request,"web","telephone",sWebLanguage)+(MedwanQuery.getInstance().getConfigString("ObligatoryFields_AdminPrivate").contains("PTelephone")?"*":"")+"</td><td class='admin2'><input type='text' class='text' name='PTelephone' id='PTelephone' value='"+checkString(apc.telephone)+"' size='"+sTextWidth+"' onblur='if(this.value!=\""+MedwanQuery.getInstance().getConfigString("editMaskTelephone","___ ___ ____")+"\" && this.value.indexOf(\"_\")>-1){alert(\""+getTranNoLink("web","wrongphonenumber",sWebLanguage)+"\");document.getElementById(\"PTelephone\").focus();}'/></td></tr>"
               )
			  //Mobile phone
              +(
       	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateMobile",1)==0?"<input type='hidden' name='PMobile' id='PMobile' value='"+checkString(apc.mobile)+"'/>":
           	      	"<tr><td class='admin'>"+getTran(request,"web","mobile",sWebLanguage)+(MedwanQuery.getInstance().getConfigString("ObligatoryFields_AdminPrivate").contains("PMobile")?"*":"")+"</td><td class='admin2'><input type='text' class='text' name='PMobile' id='PMobile' value='"+checkString(apc.mobile)+"' size='"+sTextWidth+"' onblur='if(this.value!=\""+MedwanQuery.getInstance().getConfigString("editMaskTelephone","___ ___ ____")+"\" && this.value.indexOf(\"_\")>-1){alert(\""+getTranNoLink("web","wrongphonenumber",sWebLanguage)+"\");document.getElementById(\"PMobile\").focus();}'/></td></tr>"
               )
			  //Province
              +(
       	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateProvince",1)==0?"<input type='hidden' name='PProvince' value='"+checkString(apc.province)+"'/>":
            	    "<tr><td class='admin'>"+getTran(request,"web","province",sWebLanguage)+"</td><td class='admin2'><select class='text' name='PProvince' id='PProvince'><option/>"
                    +ScreenHelper.writeSelect(request,"province",apc.province,sWebLanguage,false,true)
                    +"</select></td></tr>"
               )
 			  //City
               +(
        	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateCity",1)==0?"<input type='hidden' name='PCity' value='"+checkString(apc.city)+"'/>":
             		inputRow(request,"Web","city","PCity","AdminPrivate",apc.city,"T",true,false,sWebLanguage)
                )
 			  //Cell
               +(
        	      		MedwanQuery.getInstance().getConfigInt("showAdminPrivateCell",1)==0?"<input type='hidden' name='PCell' value='"+checkString(apc.cell)+"'/>":
             		inputRow(request,"Web","cell","PCell","AdminPrivate",apc.cell,"T",true,false,sWebLanguage)
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
      document.getElementById("PSector").value = "";
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

    document.getElementById('PTelephone').value=document.getElementById('PTelephone').value.replace(/\_/g,'');
    document.getElementById('PMobile').value=document.getElementById('PMobile').value.replace(/\_/g,'');
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
        else if(obligatoryField.value.trim() == ""){
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