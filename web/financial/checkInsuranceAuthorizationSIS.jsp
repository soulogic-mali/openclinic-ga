<%@page import="net.admin.*,
                java.text.*,
                java.util.*,
                be.mxs.common.util.system.*,
                be.mxs.common.util.db.*,be.openclinic.reporting.*,pe.gob.sis.*,be.openclinic.finance.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sMonth = new SimpleDateFormat("yyyyMM").format(new java.util.Date());	

	String personid   = request.getParameter("personid"),
           insuraruid = request.getParameter("insuraruid"),
           userid     = request.getParameter("userid"),
           language   = request.getParameter("language");
	
	/// DEBUG /////////////////////////////////////////////////////////////////////////////////////
	if(Debug.enabled){
		Debug.println("\n************** financial/checkInsuranceAuthorisationSIS.jsp **************");
		Debug.println("sMonth     : "+sMonth);
		Debug.println("personid   : "+personid);
		Debug.println("insuraruid : "+insuraruid);
		Debug.println("userid     : "+userid);
		Debug.println("language   : "+language+"\n");
	}
	///////////////////////////////////////////////////////////////////////////////////////////////
	String accreditationresult="",accreditationmechanism="",accreditationwarning="";
	if(ScreenHelper.checkString(request.getParameter("forceautorization")).length()>0){
		Insurar insurar = Insurar.get(insuraruid);
		if(insurar.getAccreditationMechanism().equalsIgnoreCase("sis")){
			accreditationmechanism="SIS";
			if(ScreenHelper.checkString(request.getParameter("manualautorization")).length()>0){
				ResultQueryAsegurado insurance = new ResultQueryAsegurado();
				insurance.setApePaterno(activePatient.getLastnameFather());
				insurance.setApeMaterno(activePatient.getLastnameMother());
				insurance.setNombres(activePatient.firstname);
				insurance.setGenero(activePatient.getBioGender().equalsIgnoreCase("m")?"1":"0");
				insurance.setContrato(ScreenHelper.checkString(request.getParameter("insurancenr")));
				insurance.setFecNacimiento(activePatient.dateOfBirth);
				insurance.setNroContrato(ScreenHelper.checkString(request.getParameter("insurancenr")));
				insurance.setEstado("PROVISIONAL");
				insurance.setIdError("0");
				insurance.setResultado("TMP."+new java.util.Date().getTime());
				insurance.setTipoDocumento("1");
				insurance.setNroDocumento(activePatient.getID("natreg"));
				insurance.setDisa("000");
				insurance.setTipoFormato("00");
				insurance.setTabla("0");
				insurance.setIdNumReg("0000000000");
				insurance.setIdUbigeo("000000");
				Acreditacion.store(insurance,Integer.parseInt(personid),new java.util.Date(),accreditationmechanism);
			}
			else{
				ResultQueryAsegurado insurance = SIS.getAffiliationInformation(Integer.parseInt(activePatient.personid));
				String dob="";
				if(checkString(insurance.getFecNacimiento()).length()>=8){
					dob=insurance.getFecNacimiento().substring(6,8)+"/"+insurance.getFecNacimiento().substring(4,6)+"/"+insurance.getFecNacimiento().substring(0,4);
				}
				//Now check if authorization was obtained
				if(checkString(insurance.getEstado()).equalsIgnoreCase("ACTIVO")){
					//Check that this is the same patient
					if(!checkString(request.getParameter("ignorewarnings")).equalsIgnoreCase("true")){
						if(!activePatient.lastname.toLowerCase().contains(insurance.getApePaterno().toLowerCase())
							|| !activePatient.lastname.toLowerCase().contains(insurance.getApeMaterno().toLowerCase())		
							|| !activePatient.firstname.toLowerCase().contains(insurance.getNombres().toLowerCase())		
							){
								accreditationwarning="<li><input type='hidden' id='accwarning' value='name'/>"+getTran(request,"web","patientname",sWebLanguage)+" <font color='red'>"+
								activePatient.lastname+", "+activePatient.firstname+"</font> "+getTran(request,"web","differsfrominsurancepatientname",sWebLanguage)+" <font color='red'>"+
								insurance.getApePaterno()+" "+insurance.getApeMaterno()+", "+insurance.getNombres()+"</font><br/>";
						}
						if(!activePatient.dateOfBirth.equalsIgnoreCase(dob)
							){
								accreditationwarning+="<li><input type='hidden' id='accwarning' value='dateofbirth'/>"+getTran(request,"web","patientdateofbirth",sWebLanguage)+" <font color='red'>"+
									activePatient.dateOfBirth+"</font> "+getTran(request,"web","differsfrominsurancepatientdateofbirth",sWebLanguage)+" <font color='red'>"+
									dob+"</font><br/>";
						}
						if(accreditationwarning.length()==0){
							Acreditacion.store(insurance,Integer.parseInt(personid),new java.util.Date(),accreditationmechanism);
						}
					}
					else{
						Acreditacion.store(insurance,Integer.parseInt(personid),new java.util.Date(),accreditationmechanism);
					}
					Vector insurances = Insurance.selectInsurances(activePatient.personid, "");
					//Update existing SIS insurance
					for(int n=0;n<insurances.size();n++){
						Insurance ins = (Insurance)insurances.elementAt(n);
						if(ins.getInsurarUid().equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("SIS","1.29"))){
							ins.setStop(null);
							ins.setInsuranceNr(insurance.getContrato());
							ins.store();
						}
					}
				}
				else{
					accreditationwarning=getTranNoLink("accreditationerrors","sis."+insurance.getIdError(),sWebLanguage);
				}
			}
		}
		else if(insurar.getAccreditationMechanism().equalsIgnoreCase("susalud")){
			accreditationmechanism="SUSALUD";
			//Todo: accreditation check
		}
	}
	
	long day=24*3600*1000;
	boolean bValid = false;
	SIS_Object acreditacion = Acreditacion.getLast(Integer.parseInt(activePatient.personid));
	if(acreditacion!=null){
		SimpleDateFormat deci = new SimpleDateFormat("yyyyMMddHHmmss");
		java.util.Date dValidUntil = new java.util.Date(acreditacion.getValueTimestamp(32).getTime()+day);
		if(dValidUntil.after(new java.util.Date())){
			bValid = true;
		}
		else if(MedwanQuery.getInstance().getConfigInt("enableAccreditationValidityPerEncounter",0)==1){
			Encounter activeEncounter = Encounter.getActiveEncounter(activePatient.personid);
			if(activeEncounter!=null){
				bValid = dValidUntil.after(activeEncounter.getBegin());
			}
		}
		if(bValid){
			out.print(HTMLEntities.htmlentities("<td class='admin'><input type='hidden' id='insid' value='"+acreditacion.getValueString(16)+"'/><input type='hidden' id='authorized' value='"+(acreditacion.getValueString(2).startsWith("TMP.")?"2":"1")+"'/>"+ScreenHelper.getTran(request,"web","insurance.authorization",language)+"</td>"+
                       "<td class='admin2'>"+ScreenHelper.getTran(request,"web","authorized.by",language)+": <b>"+acreditacion.getValueString(33)+"</b> "+ScreenHelper.getTran(request,"web","withauthorizationnumber",language)+" <b>"+(acreditacion.getValueString(2).startsWith("TMP.")?"<a href='javascript:deleteAccreditation(\""+acreditacion.getValueString(2)+"\")'><img style='vertical-align: bottom' height='14px' src='"+sCONTEXTPATH+"/_img/icons/icon_erase.gif'/></a>":"")+"<a id='showdetailsanchor' href='javascript:showdetails(\""+acreditacion.getValueString(2)+"\")' title='"+getTranNoLink("web","details",sWebLanguage)+"'>"+acreditacion.getValueString(2)+"</b></td>"));
		}
	}
	
	if(!bValid){
		if(MedwanQuery.getInstance().getConfigString("InsuranceAgentAuthorizationNeededFor","").indexOf("*"+insuraruid+"*")>-1){
			User user = User.get(Integer.parseInt(userid));
			if(user!=null && ((user.getParameter("insuranceagent")!=null && user.getParameter("insuranceagent").equalsIgnoreCase(insuraruid)) || user.getAccessRightNoSA("financial.authorizeanyinsurance.select"))){
				// This agent can give an authorization for performing prestation encoding
				out.print(HTMLEntities.htmlentities("<td class='admin'>"+ScreenHelper.getTran(request,"web","insurance.agent.authorize",language)+"</td>"+
				                                    "<td class='admin2'><input type='checkbox' class='text' name='EditAuthorization' id='EditAuthorization' value='"+new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date())+";"+userid+"'>"+ScreenHelper.getTran(request,"web","authorize.until",language)+" <b>"+ScreenHelper.fullDateFormatSS.format(new java.util.Date(new java.util.Date().getTime()+24*3600*1000))+"</b></td>"));
			}
			else{
				if(accreditationresult.length()>0){
					out.print(HTMLEntities.htmlentities("<td class='admin'><input type='hidden' id='authorized' value='0'/>"+ScreenHelper.getTran(request,"web","insurance.authorization",language)+"</td>"+
	                        "<td class='admin2'><img src='"+sCONTEXTPATH+"/_img/icons/icon_forbidden.png'/> <b>"+ScreenHelper.getTran(request,"web","not.authorized",language)+" "+getTran(request,"web","by",sWebLanguage)+" "+accreditationmechanism+" <font color='red'>["+getTran(request,"accreditationerrors",accreditationresult,sWebLanguage)+"]"+"</font></b></td>"));
				}
				else if(accreditationwarning.length()>0){
					out.print(HTMLEntities.htmlentities("<td class='admin'><input type='hidden' id='authorized' value='0'/>"+ScreenHelper.getTran(request,"web","insurance.authorization",language)+"</td>"+
	                        "<td class='admin2'><img src='"+sCONTEXTPATH+"/_img/icons/icon_info.gif'/> <b>"+ScreenHelper.getTran(request,"web","warning",language)+": <br/>"+accreditationwarning+" <input type='button' class='button' value='"+getTranNoLink("web","ignorewarning",sWebLanguage)+"' onclick='checkInsuranceAuthorization(true,true);'/></b></td>"));
				}
				else{
					out.print(HTMLEntities.htmlentities("<td class='admin'><input type='hidden' id='authorized' value='0'/>"+ScreenHelper.getTran(request,"web","insurance.authorization",language)+"</td>"+
	                        "<td class='admin2'></b>"+ScreenHelper.getTran(request,"web","not.authorized",language)+"</b></td>"));
				}
			}
		}
		else{
			out.print("<td colspan='2'><input type='hidden' id='authorized' value='1'/></td>");
		}
	}
%>