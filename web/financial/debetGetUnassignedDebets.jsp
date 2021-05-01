<%@page import="be.openclinic.finance.Debet,
                java.util.*,
                be.openclinic.finance.Prestation,
                be.openclinic.adt.Encounter,
                be.mxs.common.util.system.HTMLEntities"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%!
    //--- GROUP DEBETS ----------------------------------------------------------------------------
    // group type by type (prestation type)
    private SortedMap groupDebets(Vector vDebets){
	    SortedMap groupedDebets = new TreeMap();

        if(vDebets!=null){
            String sDebetUID;
            Debet debet;

            for(int i=0; i<vDebets.size(); i++){
                sDebetUID = checkString((String)vDebets.elementAt(i));

                if(sDebetUID.length() > 0){
                    debet = Debet.get(sDebetUID);
                   
                    if(debet!=null && debet.getPrestation()!=null){
                        String sDebetUid = debet.getPrestation().getDescription()+"."+debet.getPrestation().getUid();
                        
                        Vector oneGroup = (Vector)groupedDebets.get(sDebetUid);
                        if(oneGroup==null){
                        	oneGroup = new Vector();
                        }
                    	oneGroup.add(debet);
                    	groupedDebets.put(sDebetUid,oneGroup);                        
                    }
                    else if(debet!=null){
                    	Debug.println("Prestation "+debet.getPrestationUid()+" missing on debet "+debet.getUid());
                    }
                }
            }
            
        }
        
	    return groupedDebets;
    }

    //--- DEBETS TO HTML --------------------------------------------------------------------------
    // These are the vectors containing debets of the same prestation-type.
    // Only the most recent debet is initially shown.
    // On click the other debets of that group will be shown. 
    private String debetsToHtml(SortedMap hDebetGroups, String sClass, String sWebLanguage, String sGroupIdx){
        String sHtml = "", sJS = "";

        if(hDebetGroups!=null){
            Debet debet;
            Encounter encounter = null;
            Prestation prestation = null;
            String sEncounterName, sPrestationDescription, sDebetUID, sPatientName;
            String sCredited;
            Hashtable hSort = new Hashtable();

            Vector oneGroup;
            String sDebetType;
            int groupIdx = 0;

            Vector groupKeys = new Vector(hDebetGroups.keySet());
            Iterator groupKeysIter = groupKeys.iterator();
            while(groupKeysIter.hasNext()){
            	sDebetType = (String)groupKeysIter.next();
            	oneGroup = (Vector)hDebetGroups.get(sDebetType);

            	Debet mostRecentDebet = (Debet)oneGroup.elementAt(0);
            	if(mostRecentDebet!=null){            	
	           	    // encounter and patient
	           	    sEncounterName = "";
	                sPatientName = "";

	                encounter = mostRecentDebet.getEncounter();
	                if(encounter!=null){
	                    sEncounterName = encounter.getEncounterDisplayName(sWebLanguage);
	                    sPatientName = ScreenHelper.getFullPersonName(encounter.getPatientUID());
	                }
                   
	            	// prestation
	            	sPrestationDescription = "";
	                if(checkString(mostRecentDebet.getPrestationUid()).length() > 0){
	                    prestation = mostRecentDebet.getPrestation();
	
	                    if(prestation!=null){
	                        sPrestationDescription = checkString(prestation.getDescription());
	                    }
	                }

	                // icons
	                String sIcons = "";
	                if(oneGroup.size() > 1){
	                    sIcons = "<img class='link' id='group"+groupIdx+"Plus' src='"+sCONTEXTPATH+"/_img/themes/default/plus.jpg' alt='"+getTranNoLink("Web.Occup","medwan.common.open",sWebLanguage)+"' style='display:block;'>"+
	                             "<img class='link' id='group"+groupIdx+"Min' src='"+sCONTEXTPATH+"/_img/themes/default/minus.jpg' alt='"+getTranNoLink("Web.Occup","medwan.common.close",sWebLanguage)+"' style='display:none;'>";
    	                
		                // open group by default (after click and page-submit)
		                if(sGroupIdx.equals(groupIdx+"")){
		                	sJS = "<script>toggleDebetGroup('"+sGroupIdx+"');</script>";
		                }
	                }

	                Hashtable groupInfo = getGroupInfo(oneGroup,sWebLanguage);
	                
	                String sOnClick = "";
	                if(oneGroup.size()==1){
	                	// no content below, so the main-TR must be clickable
	                	sOnClick = "onClick=\"setDebet('"+mostRecentDebet.getUid()+"','"+groupIdx+"');\" style='cursor:hand;'";
	                }
	                else{
	                	// content below, so open hidden table
	                	sOnClick = "onClick=\"toggleDebetGroup('"+groupIdx+"');\" style='cursor:hand;'";
	                }
	                String sInsurer="";
	                if(mostRecentDebet.getInsurance()!=null && mostRecentDebet.getInsurance().getInsurar()!=null){
	                	sInsurer=mostRecentDebet.getInsurance().getInsurar().getName();
	                }
					String user = "?";
					UserVO u =MedwanQuery.getInstance().getUser(mostRecentDebet.getUpdateUser());
					if (u!=null && u.getPersonVO()!=null){
						user=u.getPersonVO().getFullName();
					}

	            	// main-row for group : info about 'mostRecentDebet' or summed info 
	            	sHtml+= "<tr class='list1' "+sOnClick+">"+
	            	         "<td "+(oneGroup.size()>1?"":" style='cursor:pointer'")+">"+sIcons+"</td>"+
	            	         "<td "+(oneGroup.size()>1?"":" style='cursor:pointer'")+">"+(oneGroup.size()>1?"":ScreenHelper.getSQLDate(mostRecentDebet.getDate()))+"</td>"+
	            	         "<td "+(oneGroup.size()>1?"":" style='cursor:pointer'")+">"+HTMLEntities.htmlentities(sEncounterName)+" ("+user+")</td>"+
	                         "<td "+(oneGroup.size()>1?"":" style='cursor:pointer'")+">"+HTMLEntities.htmlentities(sPrestationDescription)+" ("+(String)groupInfo.get("quantity")+"x)</td>"+
  	                         "<td style='padding-left:5px;'>"+HTMLEntities.htmlentities(sInsurer)+"</td>"+
	                         "<td "+(oneGroup.size()>1?"":" style='cursor:pointer'")+">"+(dbl((String)groupInfo.get("amount"))+dbl((String)groupInfo.get("insurarAmount"))+dbl((String)groupInfo.get("extraInsurarAmount")))+" "+MedwanQuery.getInstance().getConfigParam("currency","EUR")+"</td>"+
	                         "<td "+(oneGroup.size()>1?"":" style='cursor:pointer'")+" "+(checkString(mostRecentDebet.getExtraInsurarUid2()).length()>0?"style='text-decoration:line-through'":"")+">"+(String)groupInfo.get("amount")+" "+MedwanQuery.getInstance().getConfigParam("currency","EUR")+"</td>"+
	                         "<td "+(oneGroup.size()>1?"":" style='cursor:pointer'")+">"+(String)groupInfo.get("insurarAmount")+" "+MedwanQuery.getInstance().getConfigParam("currency","EUR")+"</td>"+
	                         "<td "+(oneGroup.size()>1?"":" style='cursor:pointer'")+">"+(String)groupInfo.get("extraInsurarAmount")+" "+MedwanQuery.getInstance().getConfigParam("currency","EUR")+"</td>"+
	                         "<td "+(oneGroup.size()>1?"":" style='cursor:pointer'")+">"+(String)groupInfo.get("credited")+"</td>"+
	                        "</tr>";

	                // hidden rows for group
	                if(oneGroup.size() > 1){
		            	sHtml+= "<tr id='groupTable_"+groupIdx+"' style='display:none'>"+
		                         "<td colspan='10'>"+
		                          "<table width='100%' cellpadding='0' cellspacing='0'>"+
		                           groupToHtml(sDebetType,oneGroup,sClass,sWebLanguage,groupIdx)+
		                          "</table>"+
		                         "</td>"+
		                        "</tr>";
	                }

	            	groupIdx++;	                		
	            }
            }
        }
        
        return sHtml+sJS;
    }
    
    private double dbl(String s){
    	try{
    		return new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#,##0.00")).parse(s).doubleValue();
    	}
    	catch(Exception e){
    		e.printStackTrace();
    	}
    	return 0;
    }
    
    //--- GET GROUP INFO --------------------------------------------------------------------------
    private Hashtable getGroupInfo(Vector oneGroup, String sWebLanguage){
    	Hashtable info = new Hashtable(4);
    	
    	Debet debet;    	
    	double quantity = 0;
    	double credited = 0, amount = 0, insurarAmount = 0, extraInsurarAmount = 0;

    	for(int i=0; i<oneGroup.size(); i++){
    		debet = (Debet)oneGroup.get(i);
    		if(debet!=null){
	    		quantity+= debet.getQuantity(); 
	    		credited+= debet.getCredited(); 
	    		amount+= debet.getAmount(); 
	    		insurarAmount+= debet.getInsurarAmount(); 
	            if(debet.getCredited() == 0){
	            	extraInsurarAmount+= debet.getExtraInsurarAmount(); 
	            }
    		}
    	}

        DecimalFormat priceFormat = new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#,##0.00"));
    	// put sums in hash
    	info.put("quantity",Double.toString(quantity));
    	info.put("amount",priceFormat.format(amount));
    	info.put("insurarAmount",priceFormat.format(insurarAmount));
    	info.put("extraInsurarAmount",priceFormat.format(extraInsurarAmount));
    	
   	    info.put("credited",""); // empty string

    	return info;
    }
    
    //--- GROUP TO HTML ---------------------------------------------------------------------------
    // These are the hidden debets, sorted per type of prestation.
    private String groupToHtml(String sDebetType, Vector debetGroup, String sClass, String sWebLanguage, int groupIdx){
    	if(debetGroup.size()<=1) return ""; // do not group single debets
    	
    	String sHtml = "<table width='100%' cellspacing='0' cellpadding='0'>";

    	// column-width row
    	sHtml+= "<tr>"+
                 "<td width='4%'></td>"+
                 "<td width='8%'></td>"+
                 "<td width='23%'></td>"+
                 "<td width='23%'></td>"+
                 "<td width='7%'></td>"+
                 "<td width='7%'></td>"+
                 "<td width='7%'></td>"+
                 "<td width='7%'></td>"+
                 "<td width='7%'></td>"+
                 "<td width='7%'></td>"+
                "</tr>";

        if(debetGroup!=null){
        	//Sort the debetgroup
        	SortedMap sortedGroup = new TreeMap();
            for(int i=0; i<debetGroup.size(); i++){
            	Debet debet = (Debet)debetGroup.elementAt(i);
                if(debet!=null){
                	sortedGroup.put(debet.getDate().getTime()+"="+debet.getUid(),debet);
                }
            }
        	
            sHtml+= "<tbody class='hand'>";
            
            Debet debet;
            Encounter encounter = null;
            Prestation prestation = null;
            String sEncounterName, sPrestationDescription, sDebetUID, sPatientName, sCredited;
            SortedMap hSorted = new TreeMap();

            Iterator groupDebets = sortedGroup.keySet().iterator();
            int i= 0;
            while(groupDebets.hasNext()){
            	debet = (Debet)sortedGroup.get(groupDebets.next());
                if(debet!=null){
                	i++;
	           	    // encounter and patient
	                sEncounterName = "";
	                sPatientName = "";
	
	                encounter = debet.getEncounter();	
	                if(encounter!=null){
	                    sEncounterName = encounter.getEncounterDisplayName(sWebLanguage);
	                    sPatientName = ScreenHelper.getFullPersonName(encounter.getPatientUID());
	                }

	                // prestation
	                sPrestationDescription = "";
	                if(checkString(debet.getPrestationUid()).length() > 0){
	                    prestation = debet.getPrestation();
	
	                    if(prestation != null){
	                        sPrestationDescription = checkString(prestation.getDescription());
	                    }
	                }

	                double dExtraInsurarAmount=debet.getExtraInsurarAmount();

	                // credited ?
	                sCredited = "";
	                if(debet.getCredited() > 0){
	                    sCredited = getTran(null,"web.occup","medwan.common.yes",sWebLanguage);
	                    dExtraInsurarAmount=0;
	                }
	                String sInsurer="";
	                if(debet.getInsurance()!=null && debet.getInsurance().getInsurar()!=null){
	                	sInsurer=debet.getInsurance().getInsurar().getName();
	                }
					String user = "?";
					UserVO u =MedwanQuery.getInstance().getUser(debet.getUpdateUser());
					if (u!=null && u.getPersonVO()!=null){
						user=u.getPersonVO().getFullName();
					}
					
	                // no TRs
	                hSorted.put(sPatientName.toUpperCase()+"="+debet.getDate().getTime()+"="+debet.getUid()," onclick=\"setDebet('"+debet.getUid()+"','"+groupIdx+"');\">"
	                        +"<td>&nbsp;<i>"+i+"</i></td>"
	                        +"<td style='padding-left:5px;'>"+ScreenHelper.getSQLDate(debet.getDate())+"</td>"
	                        +"<td style='padding-left:5px;'>"+HTMLEntities.htmlentities(sEncounterName)+" ("+user+")</td>"
	                        +"<td style='padding-left:5px;'>"+HTMLEntities.htmlentities(sPrestationDescription)+" ("+debet.getQuantity()+"x)</td>"
  	                        +"<td style='padding-left:5px;'>"+HTMLEntities.htmlentities(sInsurer)+"</td>"
   	                        +"<td style='padding-left:5px;'>"+(debet.getAmount()+debet.getInsurarAmount()+dExtraInsurarAmount)+" "+MedwanQuery.getInstance().getConfigParam("currency","EUR")+"</td>"
	                        +"<td style='padding-left:5px;' "+(checkString(debet.getExtraInsurarUid2()).length()>0?"style='text-decoration:line-through'":"")+">"+debet.getAmount()+" "+MedwanQuery.getInstance().getConfigParam("currency","EUR")+"</td>"
	                        +"<td style='padding-left:5px;'>"+debet.getInsurarAmount()+" "+MedwanQuery.getInstance().getConfigParam("currency","EUR")+"</td>"
	                        +"<td style='padding-left:5px;'>"+dExtraInsurarAmount+" "+MedwanQuery.getInstance().getConfigParam("currency","EUR")+"</td>"
	                        +"<td style='padding-left:5px;'>"+sCredited+"</td>");
				}
            }

            // sort and reverse order
            Vector keys = new Vector(hSorted.keySet());
            Collections.reverse(keys);
            Iterator it = keys.iterator();

            while(it.hasNext()){
                sHtml+= "<tr "+hSorted.get((String)it.next())+"</tr>"; // class='list'
            }
            
            sHtml+= "</tbody>";
        }
        
        return sHtml;
    }
%>

<%    
    String sFindDateBegin = checkString(request.getParameter("FindDateBegin")),
           sFindDateEnd   = checkString(request.getParameter("FindDateEnd")),
           sFindAmountMin = checkString(request.getParameter("FindAmountMin")),
           sFindAmountMax = checkString(request.getParameter("FindAmountMax")),
           sGroupIdx      = checkString(request.getParameter("GroupIdx"));

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
    	Debug.println("\n**************** financial/debetGetUnassignedDebets.jsp ***************");
    	Debug.println("sFindDateBegin : "+sFindDateBegin);
    	Debug.println("sFindDateEnd   : "+sFindDateEnd);
    	Debug.println("sFindAmountMin : "+sFindAmountMin);
    	Debug.println("sFindAmountMax : "+sFindAmountMax);
    	Debug.println("sGroupIdx      : "+sGroupIdx+"\n"); // this debet-group should be opened by default
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
%>    
<table width="100%" cellspacing="0" cellpadding="0" id="debetsTable" style="padding:1px;">
    <tr class="admin">
        <td width="4%">&nbsp;</td>
        <td width="8%"><%=HTMLEntities.htmlentities(getTranNoLink("web","date",sWebLanguage))%></td>
        <td width="23%"><%=HTMLEntities.htmlentities(getTranNoLink("web.finance","encounter",sWebLanguage))%></td>
        <td width="23%"><%=HTMLEntities.htmlentities(getTranNoLink("web","prestation",sWebLanguage))%></td>
        <td width="7%"><%=HTMLEntities.htmlentities(getTranNoLink("web","insurar",sWebLanguage))%></td>
        <td width="7%"><%=HTMLEntities.htmlentities(getTranNoLink("web","total",sWebLanguage))%></td>
        <td width="7%"><%=HTMLEntities.htmlentities(getTranNoLink("web","amount",sWebLanguage))%></td>
        <td width="7%"><%=HTMLEntities.htmlentities(getTranNoLink("web.finance","amount.insurar",sWebLanguage))%></td>
        <td width="7%"><%=HTMLEntities.htmlentities(getTranNoLink("web.finance","amount.complementaryinsurar",sWebLanguage))%></td>
        <td width="7%"><%=HTMLEntities.htmlentities(getTranNoLink("web","canceled",sWebLanguage))%></td>
    </tr>
    
	<%		
	try{
    Vector vUnassignedDebets;
	    if(sFindDateBegin.length()==0 && sFindDateEnd.length()==0 && sFindAmountMin.length()==0 && sFindAmountMax.length()==0){
	    	// no search-criteria
	        vUnassignedDebets = Debet.getUnassignedPatientDebets(activePatient.personid);
	    }
	    else{
	        vUnassignedDebets = Debet.getPatientDebets(activePatient.personid,sFindDateBegin,sFindDateEnd,sFindAmountMin,sFindAmountMax);
	    }
	    
	    if(vUnassignedDebets.size() > 0){
	    	%><tbody><%=debetsToHtml(groupDebets(vUnassignedDebets),"",sWebLanguage,sGroupIdx)%></tbody><%	    	        
	    }
	    else{
	    	%><tr><td colspan="7"><%=getTranNoLink("web","noRecordsFound",sWebLanguage)%></td></tr><%
	    }
	}
	catch(Exception e){
		e.printStackTrace();
	}
	%>
</table>