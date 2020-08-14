<%@ page import="be.mxs.common.util.system.ScreenHelper" %>
<%@ page import="be.openclinic.medical.*,be.openclinic.adt.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %><%
    String encounterUid= ScreenHelper.checkString(request.getParameter("encounterUid"));
    String codeType= ScreenHelper.checkString(request.getParameter("codeType"));
    String code= ScreenHelper.checkString(request.getParameter("code"));
    String complaintonset= ScreenHelper.checkString(request.getParameter("onset"));
    String alternativeCodeType= ScreenHelper.checkString(request.getParameter("alternativeCodeType"));
    String alternativeCode= ScreenHelper.checkString(request.getParameter("alternativeCode"));
    String flags= ScreenHelper.checkString(request.getParameter("flags"));
    String language= ScreenHelper.checkString(request.getParameter("language"));
    String userUid= ScreenHelper.checkString(request.getParameter("userUid"));
    String trandate= ScreenHelper.checkString(request.getParameter("trandate"));
    String transfertoproblemlist= ScreenHelper.checkString(request.getParameter("transfertoproblemlist"));
    Date d = null;
    try{
        d = ScreenHelper.parseDate(trandate);
    }
    catch(Exception e){
    }
    if(d==null){
        try{
            d = ScreenHelper.parseDate(complaintonset);
        }
        catch(Exception e){
        }
    }
    ReasonForEncounter reasonForEncounter = new ReasonForEncounter();
    reasonForEncounter.setVersion(1);
    reasonForEncounter.setUpdateUser(userUid);
    reasonForEncounter.setUpdateDateTime(new Date());
    reasonForEncounter.setEncounterUID(encounterUid);
    reasonForEncounter.setDate(d);
    reasonForEncounter.setCreateDateTime(new Date());
    reasonForEncounter.setCodeType(codeType);
    reasonForEncounter.setCode(code);
    reasonForEncounter.setAuthorUID(userUid);
    reasonForEncounter.setFlags(flags);
    reasonForEncounter.store();
    if(alternativeCode.length()>0){
        reasonForEncounter = new ReasonForEncounter();
        reasonForEncounter.setVersion(1);
        reasonForEncounter.setUpdateUser(userUid);
        reasonForEncounter.setUpdateDateTime(new Date());
        reasonForEncounter.setEncounterUID(encounterUid);
        reasonForEncounter.setDate(d);
        reasonForEncounter.setCreateDateTime(new Date());
        reasonForEncounter.setCodeType(alternativeCodeType);
        reasonForEncounter.setCode(alternativeCode);
        reasonForEncounter.setAuthorUID(userUid);
        reasonForEncounter.setFlags(flags);
        reasonForEncounter.store();
    }
    if(transfertoproblemlist.equalsIgnoreCase("1")){
    	Encounter encounter = Encounter.get(encounterUid);
    	if(encounter.hasValidUid()){
	        Problem problem=new Problem(encounter.getPatientUID(),codeType,code,"",new java.util.Date(),null);
	        problem.setGravity(be.openclinic.medical.Diagnosis.getGravity(codeType,code,500));
	        problem.setCertainty(500);
	        problem.setUpdateDateTime(new java.util.Date());
	        problem.store();
    	}
    }
    out.println(ReasonForEncounter.getReasonsForEncounterAsHtml(encounterUid,language,"_img/icons/icon_delete.png","deleteRFE($serverid,$objectid)"));
%>