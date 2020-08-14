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
		Debug.println("\n************** financial/checkInsuranceAuthorisation.jsp **************");
		Debug.println("sMonth     : "+sMonth);
		Debug.println("personid   : "+personid);
		Debug.println("insuraruid : "+insuraruid);
		Debug.println("userid     : "+userid);
		Debug.println("language   : "+language+"\n");
	}
	///////////////////////////////////////////////////////////////////////////////////////////////
	String accreditationresult="",accreditationmechanism="",accreditationwarning="";

	Vector pointers = Pointer.getPointers("AUTH."+insuraruid+"."+personid+"."+sMonth);
	boolean bValid = false;
	SimpleDateFormat deci = new SimpleDateFormat("yyyyMMddHHmmss");
	
	for(int n=0; n<pointers.size() && !bValid; n++){
		String pointer = (String)pointers.elementAt(n);
		
		java.util.Date dValidUntil = deci.parse(pointer.split(";")[0]);
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
			// Still valid
			User user = User.get(Integer.parseInt(pointer.split(";")[1]));
			String username = user!=null?user.person.getFullName():"?";
			out.print(HTMLEntities.htmlentities("<td class='admin'>"+ScreenHelper.getTran(request,"web","insurance.agent.authorization",language)+"</td>"+
				                                    "<td class='admin2'>"+ScreenHelper.getTran(request,"web","authorized.by",language)+": "+username+" "+ScreenHelper.getTran(request,"web","until",language)+" <b>"+ScreenHelper.fullDateFormatSS.format(dValidUntil)+"</b></td>"));
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