<%@ page errorPage="/includes/error.jsp" %>
<%@ include file="/includes/validateUser.jsp" %>
<%@ page import="java.util.*,be.mxs.common.util.system.HTMLEntities,be.openclinic.util.*" %>
<%!
    //--- GET PARENT ------------------------------------------------------------------------------
    private String getParent(String type,String sCode, String sWebLanguage) {
        String sReturn = "";
        if ((sCode != null) && (sCode.trim().length() > 0)) {
            String sLabel = getTran(null,"admin.nomenclature."+type, sCode, sWebLanguage);
            String sParentID = Nomenclature.get(type,sCode).getParentId();
			if(checkString(sParentID).length()>0){
                    sReturn = getParent(type,sParentID, sWebLanguage)
                            + "<img src='" + sCONTEXTPATH + "/_img/themes/default/pijl.gif'>"
                            + "<a href='javascript:populateCategory(\"" + type + "\",\"" + sCode + "\")' title='" + getTran(null,"Web.Occup", "medwan.common.open", sWebLanguage) + "'>" + sLabel + "</a>";
            }

            if (sReturn.trim().length() == 0) {
                sReturn = sReturn + "<img src='" + sCONTEXTPATH + "/_img/themes/default/pijl.gif'>"
                        + "<a href='javascript:populateCategory(\"" + type + "\",\"" + sCode + "\")' title='" + getTran(null,"Web.Occup", "medwan.common.open", sWebLanguage) + "'>" + sLabel + "</a>";
            }
        }
        return sReturn;
    }

    //--- WRITE MY ROW ----------------------------------------------------------------------------
    private String writeMyRow(String sType, String sID, String sWebLanguage, String sIcon) {

        String row = "";
        String sLabel = getTran(null,"admin.nomenclature."+sType, sID, sWebLanguage);
        Nomenclature nomenclature=Nomenclature.get(sType,sID);

        if (nomenclature!=null){
            //Set display class
            String sClass="";

            if (sIcon.length() == 0 && Nomenclature.getChildren(sType,sID).size()>0) {
                sIcon = "<img src='" + sCONTEXTPATH + "/_img/themes/default/menu_tee_plus.gif' onclick='populateCategory(\"" + sType + "\",\"" + sID + "\")' alt='" + getTran(null,"Web.Occup", "medwan.common.open", sWebLanguage) + "'>";
            }

            row += "<tr>" +
                    " <td>" + sIcon + "</td><td><img src='" + sCONTEXTPATH + "/_img/icons/icon_view.png' alt='" + getTran(null,"Web", "view", sWebLanguage) + "' onclick='viewCategory(\"" + sType + "\",\"" + sID + "\")'></td>" +
                    " <td class='"+sClass+"'>" + sID + "</td>"+
                    "<td class='"+sClass+"'><a href='javascript:selectParentCategory(\"" + sType + "\",\"" + sID + "\",\"" + sLabel + "\")' title='" + getTran(null,"Web", "select", sWebLanguage) + "'>" + sLabel + "</a></td>"+
                    "</tr>";
        }
        return row;
    }
%>
<%
    // form data
    String  sViewCode = checkString(request.getParameter("ViewCode")),
            sFindText = checkString(request.getParameter("FindText")).toUpperCase(),
            sNoActive = checkString(request.getParameter("NoActive")),
            sFindType = checkString(request.getParameter("FindType")),
            sFindCode = checkString(request.getParameter("FindCode")).toUpperCase();

    // DEBUG ///////////////////////////////////////////////////////////
    Debug.println("### sFindText : " + sFindText);
    Debug.println("### sFindType : " + sFindType);
    Debug.println("### sFindCode : " + sFindCode);
    ////////////////////////////////////////////////////////////////////

    // options
    String sFindParentCode = request.getParameter("FindParentCode");
    // variables
    StringBuffer sOut = new StringBuffer();
    String sNomenclatureID, sNavigation = "";
    Hashtable hSelected = new Hashtable();
    SortedSet set = new TreeSet();
    Object element;
    int iTotal = 0;

    //*** search on findCode **********************************************************************
    if (sFindCode.length() > 0) {
        Vector vNomenclatures = Nomenclature.getChildren(sFindType,sFindCode);
        Iterator iter = vNomenclatures.iterator();

        while (iter.hasNext()) {
        	Nomenclature nomenclature = (Nomenclature) iter.next();
            sNomenclatureID = nomenclature.getId();
            set.add(sNomenclatureID);
            hSelected.put(sNomenclatureID, writeMyRow(sFindType, sNomenclatureID, sWebLanguage, ""));

            iTotal++;
        }

        sNavigation = getParent(sFindType,sFindCode, sWebLanguage);
    }
    //*** search on findText **********************************************************************
    else if (sFindText != null && sFindText.length() > 0) {
        Vector vNomenclatureIDs = Nomenclature.getNomenclatureIDsByText(sFindType, sWebLanguage, sFindText);
        Iterator iter = vNomenclatureIDs.iterator();
        String labelid;

        while (iter.hasNext()) {
            labelid = (String) iter.next();
            set.add(labelid);
            hSelected.put(labelid, writeMyRow(sFindType, labelid, sWebLanguage, ""));
            iTotal++;
        }
    }
    //*** empty search ****************************************************************************
    else {

        Vector vNomenclatures;
        if (sFindParentCode == null) {
        	vNomenclatures = Nomenclature.getRootElements(sFindType);
        } else {
        	vNomenclatures = Nomenclature.getChildren(sFindType,sFindParentCode);
        }
        Iterator iter = vNomenclatures.iterator();

        while (iter.hasNext()) {
        	Nomenclature nomenclature = (Nomenclature)iter.next();
            sNomenclatureID = nomenclature.getId();
            set.add(sNomenclatureID);
            hSelected.put(sNomenclatureID, writeMyRow(sFindType, sNomenclatureID, sWebLanguage, ""));
            iTotal++;
        }
        sNavigation = getParent(sFindType,sFindCode, sWebLanguage);
    }
%>
&nbsp;<a href="javascript:clearSearchFields();doFind();">Home</a>

<div id="navigationMenu"><%=sNavigation%></div>
<table width="100%" cellspacing="1">
    <%
        if (sViewCode.length() > 0) {
            if (iTotal == 0) {
                sViewCode = sFindCode;
            }
            String sLabel = getTran(request,"admin.nomenclature."+sFindType, sViewCode, sWebLanguage);
            Nomenclature nomenclature = Nomenclature.get(sFindType,sViewCode);

            if (nomenclature != null) {
    %>
    <tr height="30px">
        <td width="30%">&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2" align="right">
            <input type="button" class="button" value="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="selectParentCategory('<%=sFindType%>','<%=sViewCode%>','<%=sLabel%>');">
        </td>
    </tr>
    <%
        }
    } else {
        // sorteer
        Iterator it = set.iterator();
        while (it.hasNext()) {
            element = it.next();
            sOut.append(((String) hSelected.get(element.toString())));
        }

        // display search results
        if (iTotal > 0) {
    %>
    <tbody class="hand">
        <%=HTMLEntities.htmlentities(sOut.toString())%>
    </tbody>
    <%
    } else {
    %>
    <tr>
        <td colspan="3"><%=HTMLEntities.htmlentities(getTran(request,"web", "norecordsfound", sWebLanguage))%></td>
    </tr>
    <%
        }
    %>
    <%-- SPACER --%>
    <tr height="1">
        <td width="1%">&nbsp;</td>
        <td width="1%">&nbsp;</td>
        <td width="1%">&nbsp;</td>
    </tr>
    <%
        }
    %>
</table>