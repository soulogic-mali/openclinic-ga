<%@page import="be.openclinic.finance.*,
                java.util.Vector,
                be.mxs.common.util.system.HTMLEntities"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
	String sFindInsurarName = checkString(request.getParameter("FindInsurarName"));
	String sNoActive = checkString(request.getParameter("NoActive"));

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
    	Debug.println("\n********** search/searchByAjax/searchinsuranceCategoryShow.jsp *********");
    	Debug.println("sFindInsurarName : "+sFindInsurarName);
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
%>

<table class="list" width="100%" cellspacing="1" cellpadding="0">
    <%
        Vector vInsurars = Insurar.getInsurarsByName(sFindInsurarName+"%");
        Vector activeInsurances = Insurance.getCurrentInsurances(activePatient.personid);
        String sActiveInsurances=";";
        for(int n=0;n<activeInsurances.size();n++){
        	Insurance insurance = (Insurance)activeInsurances.elementAt(n);
        	if(insurance.getInsurar()!=null){
        		sActiveInsurances+=insurance.getInsurar().getUid()+"."+insurance.getInsuranceCategoryLetter()+";";
        	}
        }
        String sClass = "", sInsurarUID = "";
        boolean recsFound = false;
        StringBuffer results = new StringBuffer();

        if(vInsurars.size() > 0){
            Iterator iter = vInsurars.iterator();
            Insurar objInsurar;
            
            while(iter.hasNext()){
                objInsurar = (Insurar)iter.next();

                if(!checkString(request.getParameter("Active")).equalsIgnoreCase("1") || objInsurar.getInactive()==0){
                    recsFound = true;
                 
                    if(objInsurar!=null && objInsurar.getInsuraceCategories()!=null && (objInsurar.getContact()==null || !objInsurar.getContact().equals("plan.openinsurance"))){
                        String cats = "";
                        for(int n=0; n<objInsurar.getInsuraceCategories().size(); n++){
                            InsuranceCategory insCat=(InsuranceCategory)objInsurar.getInsuraceCategories().elementAt(n);
                            if(n > 0){
                                cats+= "<br/>";
                            }
                            if(sNoActive.length()>0 && sActiveInsurances.indexOf(objInsurar.getUid()+"."+insCat.getCategory())>-1){
                            	cats+=insCat.getCategory()+" ("+insCat.getLabel()+" - "+insCat.getPatientShare()+"/"+(100-Integer.parseInt(insCat.getPatientShare()))+") <img src='"+sCONTEXTPATH+"/_img/themes/default/valid.gif' title='"+getTranNoLink("web","insurancecategoryalreadyactive",sWebLanguage)+"'>";
                            }
                            else{
                             cats+= "<a href=\"javascript:setInsuranceCategory('"+insCat.getCategory()+"','"+objInsurar.getUid()+"','"+objInsurar.getName().toUpperCase()+"','" +insCat.getCategory()+": "+insCat.getLabel()+"','"+objInsurar.getType()+"','"+getTranNoLink("insurance.types",objInsurar.getType(),sWebLanguage)+"');\">"+
                                    insCat.getCategory()+" ("+insCat.getLabel()+" - "+insCat.getPatientShare()+"/"+(100-Integer.parseInt(insCat.getPatientShare()))+")</a>";
                            }
                  }
                  
                  // alternate row-style
                  if(sClass.equals("")) sClass = "1";
                  else                  sClass = "";

                  results.append("<tr class='list"+sClass+"'>")
                          .append("<td>"+objInsurar.getName().toUpperCase()+"</td>")
                          .append("<td>"+cats+"</td>")
                         .append("</tr>");
                 }
                }
            }

            if(recsFound){
                %>
                    <tbody class="hand">
                        <tr class="admin">
                            <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"Web","name",sWebLanguage))%></td>
                            <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"Web","category",sWebLanguage))%></td>
                        </tr>

                        <%=HTMLEntities.htmlentities(results.toString())%>
                    </tbody>
                <%
            }
            else{
                // display 'no results' message
                %>
                    <tr>
                        <td colspan='3'><%=HTMLEntities.htmlentities(getTran(request,"web","norecordsfound",sWebLanguage))%></td>
                    </tr>
                <%
            }
        }
    %>
</table>