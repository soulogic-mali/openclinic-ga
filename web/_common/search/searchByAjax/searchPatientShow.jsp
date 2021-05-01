<%@page import="java.util.Vector,
                java.util.Hashtable,
                be.mxs.common.util.system.HTMLEntities"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
    String sFindLastname   = checkString(request.getParameter("FindLastname")),
           sFindFirstname  = checkString(request.getParameter("FindFirstname")),
           sFindDOB        = checkString(request.getParameter("FindDOB")),
           sFindGender     = checkString(request.getParameter("FindGender")),
           sReturnPersonID = checkString(request.getParameter("ReturnPersonID")),
           sPersonID       = checkString(request.getParameter("PersonID")),
           sNatReg         = checkString(request.getParameter("NatReg")),
		   sGiftID         = checkString(request.getParameter("giftid"));

    if(sReturnPersonID.length()==0){
        sReturnPersonID = checkString(request.getParameter("ReturnField"));
    }

    boolean bIsUser = checkString(request.getParameter("isUser")).equalsIgnoreCase("yes");
    boolean displayImmatNew = !checkString(request.getParameter("displayImmatNew")).equalsIgnoreCase("no");
    boolean bHasTracnet = checkString(request.getParameter("hasTracnetId")).equalsIgnoreCase("yes");

    String sSelectLastname  = ScreenHelper.normalizeSpecialCharacters(sFindLastname),
           sSelectFirstname = ScreenHelper.normalizeSpecialCharacters(sFindFirstname);
    
    /// DEBUG ///////////////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
    	Debug.println("\n*************** _common/search/searchByAjax/searchpatientShow.jsp ***************");
    	Debug.println("sFindLastname   : "+sFindLastname);
    	Debug.println("sFindFirstname  : "+sFindFirstname);
    	Debug.println("sFindDOB        : "+sFindDOB);
    	Debug.println("sFindGender     : "+sFindGender);
    	Debug.println("sReturnPersonID : "+sReturnPersonID);
    	Debug.println("sPersonID       : "+sPersonID);
    	Debug.println("sNatReg         : "+sNatReg);
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
%>

<table width="100%" cellspacing="0" cellpadding="0" class="list">
    <%
        Vector vPersons = new Vector();
    	if(!bIsUser && sPersonID.length()>0){
    		AdminPerson person = AdminPerson.getAdminPerson(sPersonID);
    		
    		if(person!=null && person.lastname!=null && person.lastname.length()>0){
                Hashtable hInfo = new Hashtable();
                
                hInfo.put("personid",ScreenHelper.checkString(sPersonID));
                hInfo.put("dateofbirth",ScreenHelper.checkString(person.dateOfBirth));
                hInfo.put("gender",ScreenHelper.checkString(person.gender));
                hInfo.put("lastname",ScreenHelper.checkString(person.lastname));
                hInfo.put("firstname",ScreenHelper.checkString(person.firstname));
                hInfo.put("immatnew",ScreenHelper.checkString(person.getID("immatnew")));
                hInfo.put("natreg",ScreenHelper.checkString(person.getID("natreg")));

                vPersons.addElement(hInfo);
    		}
    	}
    	else if(!bIsUser && sGiftID.length()>0){
    		TransactionVO transaction=null;
    		try{
    			transaction = MedwanQuery.getInstance().loadTransaction(MedwanQuery.getInstance().getConfigInt("serverId"), Integer.parseInt(sGiftID));
    		}
    		catch(Exception e){}
			if(transaction!=null){
				if(transaction.getTransactionType().equalsIgnoreCase("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_CNTS_BLOODGIFT")){
					String personid = MedwanQuery.getInstance().getPersonIdFromHealthrecordId(transaction.getHealthrecordId())+"";
		    		AdminPerson person = AdminPerson.getAdminPerson(personid);
		    		if(person!=null && person.lastname!=null && person.lastname.length()>0){
		                Hashtable hInfo = new Hashtable();
		                
		                hInfo.put("personid",ScreenHelper.checkString(personid));
		                hInfo.put("dateofbirth",ScreenHelper.checkString(person.dateOfBirth));
		                hInfo.put("gender",ScreenHelper.checkString(person.gender));
		                hInfo.put("lastname",ScreenHelper.checkString(person.lastname));
		                hInfo.put("firstname",ScreenHelper.checkString(person.firstname));
		                hInfo.put("immatnew",ScreenHelper.checkString(person.getID("immatnew")));
		                hInfo.put("natreg",ScreenHelper.checkString(person.getID("natreg")));
	
		                vPersons.addElement(hInfo);
		    		}
				}
			}
    	}
    	else if(sNatReg.length()>0){
    		String personid = AdminPerson.getPersonIdByNatReg(sNatReg);
    		if(personid!=null){
    			AdminPerson person = AdminPerson.getAdminPerson(personid);
    			if(person.isNotEmpty()){
	                Hashtable hInfo = new Hashtable();
	                
	                hInfo.put("personid",ScreenHelper.checkString(personid));
	                hInfo.put("dateofbirth",ScreenHelper.checkString(person.dateOfBirth));
	                hInfo.put("gender",ScreenHelper.checkString(person.gender));
	                hInfo.put("lastname",ScreenHelper.checkString(person.lastname));
	                hInfo.put("firstname",ScreenHelper.checkString(person.firstname));
	                hInfo.put("immatnew",ScreenHelper.checkString(person.getID("immatnew")));
	                hInfo.put("natreg",ScreenHelper.checkString(person.getID("natreg")));
	
	                vPersons.addElement(hInfo);
    			}
    		}
    	}
       	else if (bHasTracnet){
    		vPersons = AdminPerson.searchVirtualInvoicingAccounts(sSelectLastname, sSelectFirstname, sFindGender, sFindDOB, bIsUser);
    	}
       	else{
    		vPersons = AdminPerson.searchPatients(sSelectLastname, sSelectFirstname, sFindGender, sFindDOB, bIsUser);
    	}
    	
        Iterator personIter = vPersons.iterator();
        Hashtable hPersonInfo;
        if((sSelectLastname.length() > 0 || sSelectFirstname.length() > 0 || sNatReg.length()>0 || sFindGender.length() > 0 || sFindDOB.length() > 0 || sGiftID.length()>0) ||
           bIsUser || sPersonID.length()>0){
            String sClass = "", sLastname, sFirstname;
            boolean recsFound = false;
            StringBuffer results = new StringBuffer();

            while(personIter.hasNext()){
                hPersonInfo = (Hashtable)personIter.next();
                recsFound = true;

                // alternate row-style
                if(sClass.equals("")) sClass = "1";
                else                  sClass = "";

                // names
                sLastname = (String)hPersonInfo.get("lastname");
                sFirstname = (String)hPersonInfo.get("firstname");
                if(sNatReg.length()>0){
                    sFirstname+= " [<b>"+hPersonInfo.get("natreg")+"</b>]";
                }
                else{
	                if(displayImmatNew){
	                    sFirstname+= " ["+hPersonInfo.get("immatnew")+"]";
	                }
                }
                sLastname = sLastname.replace('\'','´');
                sFirstname = sFirstname.replace('\'','´');

                // one row
                if(bIsUser){
                    results.append("<tr class='list"+sClass+"' onclick=\"setPerson("+hPersonInfo.get("userid")+",'"+sLastname+" "+sFirstname+"');\">")
                            .append("<td>"+hPersonInfo.get("userid")+"</td>")
                            .append("<td>"+sLastname+" "+sFirstname+" ("+hPersonInfo.get("userid")+")</td>")
                            .append("<td>"+((String) hPersonInfo.get("gender")).toUpperCase()+"</td>")
                            .append("<td colspan='2'>"+hPersonInfo.get("dateofbirth")+"</td>")
                           .append("</tr>");
                } 
                else {
                    results.append("<tr class='list"+sClass+"' onclick=\"setPerson("+hPersonInfo.get("personid")+",'"+sLastname+" "+sFirstname+"');\">")
                            .append("<td>"+hPersonInfo.get("personid")+"</td>")
                            .append("<td>"+sLastname+" "+sFirstname+"</td>")
                            .append("<td>"+((String) hPersonInfo.get("gender")).toUpperCase()+"</td>")
                            .append("<td colspan='2'>"+hPersonInfo.get("dateofbirth")+"</td>")
                           .append("</tr>");
                }

            }
            
            if(recsFound){
			    %>
			    <%-- header --%>
			    <tr class="admin">
			        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"Web","personid",sWebLanguage))%></td>
			        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"Web","name",sWebLanguage))%></td>
			        <td width="50" nowrap><%=HTMLEntities.htmlentities(getTran(request,"Web","gender",sWebLanguage))%></td>
			        <td width="110" nowrap><%=HTMLEntities.htmlentities(getTran(request,"Web","dateofbirth",sWebLanguage))%></td>
			    </tr>
			
			    <tbody class="hand">
			        <%=HTMLEntities.htmlentities(results.toString())%>
			    </tbody>
			    <%
		    }
		    else{
		        // display 'no results' message
		        %>
		        <tr>
		            <td colspan="3">
		                <%=HTMLEntities.htmlentities(getTran(request,"web","norecordsfound",sWebLanguage))%><br>
		                <a href="javascript:addPerson()"><%=HTMLEntities.htmlentities(getTranNoLink("web","add.this.person",sWebLanguage))%></a>
		            </td>
		        </tr>
		        <%
		    }
		}
	%>
</table>