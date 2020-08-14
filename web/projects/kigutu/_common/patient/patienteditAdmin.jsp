<%@page errorPage="/includes/error.jsp"%>
<%@include file="/_common/patient/patienteditHelper.jsp"%>
<%!
    //--- SET OPTION ------------------------------------------------------------------------------
    private String setOption(String sList, String sOption, String sDefault, int iCounter) {
        int iIndex = 0;

        if(sOption!=null && sOption.trim().length()>0){
            iIndex = sList.indexOf("'"+sOption+"'");
            if (iIndex>0) {
                sList = sList.substring(0,iIndex)+"'"+sOption+"' selected "+sList.substring(iIndex+(sOption.length()-1)+iCounter,sList.length());
            }
        }

        if(iIndex==0 && sDefault.trim().length()>0){
            iIndex = sList.indexOf("'"+sDefault+"'");
            if (iIndex>0) {
                sList = sList.substring(0,iIndex)+"'"+sDefault+"' selected "+sList.substring(iIndex+(sDefault.length()-1)+iCounter,sList.length());
            }
        }

        return sList;
    }
%>

<%
    //--- SAVE ------------------------------------------------------------------------------------
    if((activePatient!=null)&&(request.getParameter("SavePatientEditForm")==null)) {
        %>
            <table border='0' width='100%' class="list" cellspacing="1" style="border-top:none;">
        <%
		boolean bCanModifyCore=true;
        if(checkString(activePatient.personid).length()>0 && MedwanQuery.getInstance().getConfigInt("canmodifyexistingcoreadmindata",1)==0 && !activeUser.getAccessRight("patient.modifyexistingcoreadminrecord.select")){
        	bCanModifyCore=false;
        }
        java.util.Date cd = activePatient.getCreationDate();
        out.print(
    			(bCanModifyCore?inputRowOpen("Web","begindate","UpdateTime","Admin",ScreenHelper.formatDate(new java.util.Date()),"Dp",true,false,sWebLanguage)
    					+(cd==null?"":"("+getTran(request,"web","patientcreationdate",sWebLanguage)+": "+ScreenHelper.getSQLDate(cd)+")")+"</td></tr>":
    	            inputRow(request,"Web","begindate","UpdateTime","Admin",ScreenHelper.formatDate(new java.util.Date()),"T",bCanModifyCore,true,sWebLanguage)
    				)
        	//Lastname
    		+(	
        		MedwanQuery.getInstance().getConfigInt("showAdminLastname",1)==0?"<input type='hidden' name='Lastname' value='"+checkString(activePatient.lastname)+"'/>":
        		inputRow(request,"Web","Lastname","Lastname","Admin",activePatient.lastname,"T",bCanModifyCore,true,sWebLanguage)
        	 )
        	//Firstname
            +(
           		MedwanQuery.getInstance().getConfigInt("showAdminFirstname",1)==0?"<input type='hidden' name='Firstname' value='"+checkString(activePatient.firstname)+"'/>":
            	inputRow(request,"Web","Firstname","Firstname","Admin",activePatient.firstname,"T",bCanModifyCore,true,sWebLanguage)
             )
        	//Dateofbirth
			+(
           		MedwanQuery.getInstance().getConfigInt("showAdminDateOfBirth",1)==0?"<input type='hidden' name='DateOfBirth' value='"+checkString(activePatient.dateOfBirth)+"'/>":
				(bCanModifyCore?inputRow(request,"Web","Dateofbirth","DateOfBirth","Admin",activePatient.dateOfBirth,"Dp",true,false,sWebLanguage):
            	inputRow(request,"Web","Dateofbirth","DateOfBirth","Admin",activePatient.dateOfBirth,"T",bCanModifyCore,true,sWebLanguage))
			 )
        	//Native town
            +(
           		MedwanQuery.getInstance().getConfigInt("showAdminNativeTown",1)==0?"<input type='hidden' name='NativeTown' value='"+checkString(activePatient.nativeTown)+"'/>":
            	inputRow(request,"Web","NativeTown","NativeTown","Admin",activePatient.nativeTown,"N",true,true,sWebLanguage)
             )
        	//Native country
            +(
           		MedwanQuery.getInstance().getConfigInt("showAdminNativeCountry",1)==0?"<input type='hidden' name='NativeCountry' value='"+checkString(activePatient.nativeCountry)+"'/>":
            	writeCountry(activePatient.nativeCountry, "NativeCountry","Admin","NativeCountryDescription",true,"NativeCountry",sWebLanguage)
             )
        	//PersonId
            +(
           		MedwanQuery.getInstance().getConfigInt("showAdminPersonId",1)==0?"":
            	"<tr><td class='admin'>"+getTran(request,"web","personid",sWebLanguage)+"</td><td class='admin2'>"+activePatient.personid+"</td></tr>"
             )
        	//Immatnew
            +(
           		MedwanQuery.getInstance().getConfigInt("showAdminImmatNew",1)==0?"<input type='hidden' name='ImmatNew' value='"+checkString(activePatient.getID("immatnew"))+"'/>":
            	inputRow(request,"Web","immatnew","ImmatNew","Admin",activePatient.getID("immatnew"),"N",true,true,sWebLanguage)
             )
            +(
           		MedwanQuery.getInstance().getConfigInt("showAdminArchiveFileCode",1)==0?"<input type='hidden' name='archiveFileCode' value='"+checkString(activePatient.getID("archiveFileCode"))+"'/>":
            	"<tr><td class='admin'>"+getTran(request,"web","archiveFileCode",sWebLanguage)+"</td><td class='admin2'><input type='hidden' name='archiveFileCode' value='"+activePatient.getID("archiveFileCode")+"'/>"
                +activePatient.getID("archiveFileCode").toUpperCase()+"</td></tr>")
             );

        // natreg (max 11 chars)
        String sNatRegHtml = normalRow("Web","natreg","NatReg","Admin",sWebLanguage)+
                             "<input class='text' type='text' name='NatReg' value=\""+activePatient.getID("natreg").trim()+"\""+
                             " size='"+sTextWidth+"' maxLength='250'>";
        
        //Natreg
        out.print(
           		MedwanQuery.getInstance().getConfigInt("showAdminNatReg",1)==0?"<input type='hidden' name='NatReg' value='"+checkString(activePatient.getID("natreg"))+"'/>":
        		sNatRegHtml
        		);

        //language
        String sLanguage = "<select name='Language' select-one class='text'>";
        sLanguage+="<option value='' SELECTED>"+getTran(request,"web","choose",sWebLanguage)+"</option>";
        String sPatientLanguages = MedwanQuery.getInstance().getConfigString("PatientLanguages");
        if(sPatientLanguages.length()==0){
            sPatientLanguages = MedwanQuery.getInstance().getConfigString("supportedLanguages","en,fr");

            if(sPatientLanguages.length()==0){
                sPatientLanguages = sWebLanguage;
            }
        }
        String[] aPatientLanguages = sPatientLanguages.split(",");
        for(int i=0;i<aPatientLanguages.length;i++){
            sLanguage += "<option value='"+aPatientLanguages[i]+"'>"+getTran(request,"Web.Language",aPatientLanguages[i],sWebLanguage)+"</option>";
        }
        String sDefaultLanguage = MedwanQuery.getInstance().getConfigString("DefaultLanguage");
        if(sDefaultLanguage.length()==0){
            sDefaultLanguage = sWebLanguage;
        }
        sLanguage = setOption(sLanguage,activePatient.language.toLowerCase(),sDefaultLanguage.toLowerCase(),3);

        out.print(
       		MedwanQuery.getInstance().getConfigInt("showAdminLanguage",1)==0?"<input type='hidden' name='Language' value='"+checkString(activePatient.language)+"'/>":
        	normalRow("Web","language","Language","Admin",sWebLanguage)+sLanguage+"</select></td></tr>"
        );

      // gender
      String sGender = "<select name='Gender' select-one class='text'";
      sGender+="><option value='' SELECTED>"+getTran(request,"web","choose",sWebLanguage)+"</option>";
      sGender+="<option value='M'>"+getTran(request,"Web.Occup","Male",sWebLanguage)+"</option>"+
               "<option value='F'>"+getTran(request,"Web.Occup","Female",sWebLanguage)+"</option>";
      sGender = setOption(sGender,activePatient.gender.toUpperCase(),MedwanQuery.getInstance().getConfigString("defaultGender","F"),3);

      // status
      String sCivilStatus = "<select name='CivilStatus' select-one class='text'><option value=''/>"
            +ScreenHelper.writeSelect(request,"civil.status",activePatient.comment2,sWebLanguage)+"</select>";
			
	  // Comment5
      String sRelationships = "<select name='Comment5' select-one class='text'><option value=''/>"
           +ScreenHelper.writeSelect(request,"comment5.options",activePatient.comment5,sWebLanguage)+"</select>";

      out.print(
   	      // gender
    	  (
 	      		MedwanQuery.getInstance().getConfigInt("showAdminGender",1)==0?"<input type='hidden' name='Gender' value='"+checkString(activePatient.gender)+"'/>":
    		  	normalRow("Web","gender","Gender","Admin",sWebLanguage)+sGender+"</select></td></tr>"
    	  )
   	      // Comment2
          +(
  	      		MedwanQuery.getInstance().getConfigInt("showAdminComment2",1)==0?"<input type='hidden' name='CivilStatus' value='"+checkString(activePatient.comment2)+"'/>":
        		normalRow("Web","civilstatus","CivilStatus","Admin",sWebLanguage)+sCivilStatus+"</td></tr>"
           )
   	      // Comment1
          +(
   	      		MedwanQuery.getInstance().getConfigInt("showAdminComment1",1)==0?"<input type='hidden' name='Comment1' value='"+checkString(activePatient.comment1)+"'/>":
        		inputRow(request,"Web","treating-physician","Comment1","Admin",activePatient.comment1,"N",true,false,sWebLanguage)
           )
   	      // Comment3
          +(
  	      		MedwanQuery.getInstance().getConfigInt("showAdminComment3",1)==0?"<input type='hidden' name='Comment3' value='"+checkString(activePatient.comment3)+"'/>":
        		inputRow(request,"Web","comment3","Comment3","Admin",activePatient.comment3,"N",true, false,sWebLanguage)
           )
   	      // Comment4
          +(
  	      		MedwanQuery.getInstance().getConfigInt("showAdminComment4",1)==0?"<input type='hidden' name='Comment4' value='"+checkString(activePatient.comment4)+"'/>":
        		inputRow(request,"Web","comment4","Comment4","Admin",activePatient.comment4,"N",true, false,sWebLanguage)
           )
   	      // Comment
	      +(
 	      		MedwanQuery.getInstance().getConfigInt("showAdminComment",1)==0?"<input type='hidden' name='Comment' value='"+checkString(activePatient.comment)+"'/>":
	    		inputRow(request,"Web","comment","Comment","Admin",activePatient.comment,"N",true, false,sWebLanguage)
	       )
   	      // Comment5
          +(
  	      		MedwanQuery.getInstance().getConfigInt("showAdminComment5",1)==0?"<input type='hidden' name='Comment5' value='"+checkString(activePatient.comment5)+"'/>":
        		"<tr><td class='admin'>"+getTran(request,"web","comment5",sWebLanguage)+"</td><td class='admin2'>"+sRelationships+ "</td></tr>"
           )
   	      // DeathCertificate
          +(
   	      		MedwanQuery.getInstance().getConfigInt("showAdminDeathCertificate",1)==0?"<input type='hidden' name='DeathCertificateOn' value='"+checkString((String)activePatient.adminextends.get("deathcertificateon"))+"'/><input type='hidden' name='DeathCertificateTo' value='"+checkString((String)activePatient.adminextends.get("deathcertificateto"))+"'/>":
        		(activePatient.isDead()!=null?inputRow(request,"Web","deathcertificateon","DeathCertificateOn","Admin",checkString((String)activePatient.adminextends.get("deathcertificateon")),"T",true,false,sWebLanguage)
    	        +inputRow(request,"Web","deathcertificateto","DeathCertificateTo","Admin",checkString((String)activePatient.adminextends.get("deathcertificateto")),"T",true,false,sWebLanguage):"")
           )
	      +(
			  MedwanQuery.getInstance().getConfigInt("enableVip",0)==1 && activeUser.getAccessRight("vipaccess.select")?
			  normalRow("Web","vip","Vip","Admin",sWebLanguage)+"<input type='radio' name='Vip' id='Vip' value='0' "+(!"1".equalsIgnoreCase((String)activePatient.adminextends.get("vip"))?"checked":"")+">"+getTran(request,"vipstatus","0",sWebLanguage)+" <input type='radio' name='Vip' id='Vip' value='1' "+("1".equalsIgnoreCase((String)activePatient.adminextends.get("vip"))?"checked":"")+">"+getTran(request,"vipstatus","1",sWebLanguage)+"</td></tr>":
			  "<input type='hidden' name='Vip' id='Vip' value='"+checkString((String)activePatient.adminextends.get("vip"))+"'/>"	  
	      )
   	      // Tracnet ID
          +(
          		MedwanQuery.getInstance().getConfigInt("showAdminTracnetID",1)==0?"<input type='hidden' name='TracnetID' value='"+checkString(activePatient.getID("tracnetid"))+"'/>":
        		inputRow(request,"Web","tracnetid","TracnetID","Admin",checkString((String)activePatient.adminextends.get("tracnetid")),"N",true,false,sWebLanguage)
           )
	      +(
			  MedwanQuery.getInstance().getConfigInt("enableDatacenterPatientExport",0)==1 && activeUser.getAccessRight("datacenterpatientexport.select")?
			  normalRow("Web","datacenterpatientexport","datacenterpatientexport","Admin",sWebLanguage)+"<input type='radio' name='datacenterpatientexport' id='datacenterpatientexport' value='0' "+(!activePatient.hasPendingExportRequest() && activePatient.personid!=null && activePatient.personid.trim().length()>0?"checked":"")+">"+getTran(request,"datacenterpatientexport","0",sWebLanguage)+" <input type='radio' name='datacenterpatientexport' id='datacenterpatientexport' value='1' "+(activePatient.hasPendingExportRequest() || activePatient.personid==null || activePatient.personid.trim().length()==0?"checked":"")+">"+getTran(request,"datacenterpatientexport","1",sWebLanguage)+"</td></tr>":
			  "<input type='hidden' name='datacenterpatientexport' id='datacenterpatientexport' value='"+(activePatient.hasPendingExportRequest()?"1":"0")+"'/>"	  
	      )
	    );
    %>
    <tr height="0">
        <td width='<%=sTDAdminWidth%>'/><td width='*'/>
    </tr>
</table>

<script>
function checkSubmitAdmin(){
  var maySubmit = true;
  displayGenericAlert = true;
  if(checkDate(document.getElementById("DateOfBirth"))){
	  var sObligatoryFields = "<%=MedwanQuery.getInstance().getConfigString("ObligatoryFields_Admin")%>";
	  var aObligatoryFields = sObligatoryFields.split(",");
	
	  for(var i=0; i<aObligatoryFields.length; i++){
	    var obligatoryField = document.all(aObligatoryFields[i]);
	
	    if(obligatoryField != null){
	      if(obligatoryField.type==undefined){
	        if(obligatoryField.innerHTML==""){
	          maySubmit = false;
	          break;
	        }
	      }
	      else{
	    	if(obligatoryField.value==""){
	          if(obligatoryField.type != "hidden"){
	            activateTab('Admin');
	            obligatoryField.focus();
	          }
	          maySubmit = false;
	          break;
	        }
	    	else{
	    	  // selected option should be 1 or 2 (preventing data-input through "Inspect element")
	          if(obligatoryField.name=="Gender"){
	          	if(document.all("Gender").value.length > 0){
	          	  if(document.all("Gender").selectedIndex!=1 && document.all("Gender").selectedIndex!=2){
	                if(obligatoryField.type != "hidden"){
	                  activateTab('Admin');
	                  obligatoryField.focus();
	                }
	          	    maySubmit = false;
	                break;
	          	  }    
	          	}
	          }
	    	}
	      }
	    }
	  }
  }
  
  return maySubmit;
}

function checkBeginAdmin(sObject,sBegin){
  checkDate(sObject);
  var sdate = sObject.value;

  if(sdate.length==10){
    var iDayBegin = sBegin.substring(1,2);
	var iMonthBegin = sBegin.substring(4,5);
	var iYearBegin = sBegin.substring(7,10);
    var iBegin = new Date(iYearBegin,iMonthBegin,iDayBegin);

	var iDayObject = sdate.substring(1,2);
	var iMonthObject = sdate.substring(1,2);
	var iYearObject = sdate.substring(1,2);
	var iObject = new Date(iYearObject,iMonthObject,iDayObject);

    var difference = iBegin.getTime() - iObject.getTime();

    if(difference>0){
	  sObject.value = sBegin;
	}
  }
  else{
    sObject.value = sBegin;
  }
}

function checkDOB(oObject){
  checkDate(oObject);
  if(oObject.value.length>0){
    var dateDOB = makeDate(oObject.value);
    var today = new Date();

    var yearDOB = dateDOB.getYear();
    var yearToday = today.getYear();

    if(yearDOB < 100){
      yearDOB = 1900 + yearDOB;
    }

    if(yearToday - yearDOB < 14){
      return false;
    }
  }
  return true;
}
</script>
<%
    }
%>