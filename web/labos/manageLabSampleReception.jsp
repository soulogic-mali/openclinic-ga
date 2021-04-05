<%@page import="be.openclinic.medical.Labo"%>
<%@page import="be.openclinic.medical.LabRequest,
                be.openclinic.medical.LabSample"%>
<%@page import="java.util.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"labos.samplereception","select",activeUser)%>

<%
    String labrequestid = checkString(request.getParameter("labrequestid"));
    int serverid = 0, transactionid = 0;
    boolean bFind=false;
    String sMessage="";
    
    String updatebarcode=checkString(request.getParameter("updatebarcode"));
    String createbarcode=checkString(request.getParameter("createbarcode"));
    if(updatebarcode.length()>0){
    	String specimenid=updatebarcode.split(";")[0];
    	String barcodeid=updatebarcode.split(";")[1];
    	if(MedwanQuery.getInstance().getConfigString("labbarcodesmask","0000000000").length()>0){
    		if(barcodeid.length()<MedwanQuery.getInstance().getConfigString("labbarcodesmask","0000000000").length()){
    			barcodeid=MedwanQuery.getInstance().getConfigString("labbarcodesmask","0000000000").substring(0,MedwanQuery.getInstance().getConfigString("labbarcodesmask","0000000000").length()-barcodeid.length())+barcodeid;
    		}
    	}
    	if(!Labo.setLabBarcode(specimenid, barcodeid).equalsIgnoreCase("USED")){
    		labrequestid=barcodeid;
    	}
    	else{
    		sMessage=getTranNoLink("web","barcodealreadyused",sWebLanguage)+": "+barcodeid;
    	}
    }
    else if(createbarcode.length()>0){
    	labrequestid=Labo.createLabBarcode(createbarcode);
    }
    
    Enumeration parameters = request.getParameterNames();
    if(parameters!=null){
        while(parameters.hasMoreElements()){
            String name = (String)parameters.nextElement();
            String fields[] = name.split("\\.");
            if(fields[0].equalsIgnoreCase("receive") && fields.length >= 4){
                serverid = Integer.parseInt(fields[1]);
                transactionid = Integer.parseInt(fields[2]);
                LabRequest.setSampleReceived(serverid,transactionid,name.replaceAll(fields[0]+"."+fields[1]+"."+fields[2]+".", ""),Integer.parseInt(activeUser.userid));
                labrequestid = "";
            }
            else if(fields[0].equalsIgnoreCase("receive") && fields.length == 3){
                transactionid = Integer.parseInt(fields[2]);
                labrequestid = transactionid+"";
                bFind=true;
            }
        }
    }
%>

<form name="frmSampleReception" method="post">
    <%=writeTableHeader("Web","sampleReception",sWebLanguage," doBack();")%>
    <input type='hidden' id='find' name='find'/>
    <input type='hidden' id='updatebarcode' name='updatebarcode'/>
    <input type='hidden' id='createbarcode' name='createbarcode'/>
    <table width="100%" class="menu" cellspacing="1" cellpadding="0">
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTranNoLink("web","labrequestid",sWebLanguage)%></td>
            <td class="admin2">
                <input type="text" size="16" class="text" id="labrequestid" name="labrequestid" value="<%=labrequestid%>"/>
                <input type="submit" class="button" name="find" value="<%=getTranNoLink("web","find",sWebLanguage)%>"/>
            </td>
        </tr>
    </table>
    <br>
    
    <table class="list" cellspacing="0" cellpadding="0">
<%
    boolean bInitialized = false;
    if(request.getParameter("find")!=null || bFind){
        if(labrequestid.length() > 0 || transactionid>0){
        	String lr=labrequestid;
        	String activebarcode="";
            try{
                if(labrequestid.length() > 0){
                    if(labrequestid.indexOf(".") == -1){
                    	String barcodeid=labrequestid;
                    	//First lookup if this is a barcodeid
                    	if(MedwanQuery.getInstance().getConfigString("labbarcodesmask","0000000000").length()>0){
                    		if(barcodeid.length()<MedwanQuery.getInstance().getConfigString("labbarcodesmask","0000000000").length()){
                    			barcodeid=MedwanQuery.getInstance().getConfigString("labbarcodesmask","0000000000").substring(0,MedwanQuery.getInstance().getConfigString("labbarcodesmask","0000000000").length()-barcodeid.length())+barcodeid;
                    		}
                    	}
                    	String specimen = Labo.getLabSpecimenId(barcodeid);
                    	if(specimen!=null){
                    		activebarcode=barcodeid;
                    		labrequestid=specimen.split("\\.")[0]+"."+specimen.split("\\.")[1];
                    	}
                        serverid = Integer.parseInt(labrequestid.split("\\.")[0]);
    	                transactionid = Integer.parseInt(labrequestid.split("\\.")[1]);
                    }
	                LabRequest labRequest = LabRequest.getUnsampledRequest(serverid, Integer.toString(transactionid), sWebLanguage);
	                if(labRequest != null && labRequest.getRequestdate()!=null){
	                    out.print("<tr>");
	                     out.print("<td colspan='2'>"+(labRequest.getRequestdate()!=null?ScreenHelper.formatDate(labRequest.getRequestdate(),ScreenHelper.fullDateFormat):"")+"<BR/><a href='javascript:showRequest("+labRequest.getServerid()+","+labRequest.getTransactionid()+")'><b>"+labRequest.getTransactionid()+"</b></a>"+(labRequest.isUrgent()?" <img height='14px' title='"+getTranNoLink("labrequest.urgency","urgent",sWebLanguage)+"' src='"+sCONTEXTPATH+"/_img/icons/icon_blinkwarning.gif'/>":"")+"</td>");
	                     out.print("<td><a href='javascript:readBarcode3(\"0"+labRequest.getPersonid()+"\");'><b>"+labRequest.getPatientname()+"</b></a> (°"+(labRequest.getPatientdateofbirth()!=null?ScreenHelper.formatDate(labRequest.getPatientdateofbirth()):"")+" - "+labRequest.getPatientgender()+")<br/><i>"+labRequest.getServicename()+" - "+MedwanQuery.getInstance().getUserName(labRequest.getUserid())+"</i></td>");
	                    out.print("</tr>");
	                    
	                    Hashtable allsamples=labRequest.findAllSamples(sWebLanguage);
	                    Hashtable unreceived = labRequest.findUnreceivedSamples(sWebLanguage);
	                    Enumeration enumeration = allsamples.elements();
	                    while (enumeration.hasMoreElements()){
	                        LabSample labSample = (LabSample)enumeration.nextElement();
	                        out.print("<tr><td><center>");
	                        
	                        if(MedwanQuery.getInstance().getConfigInt("forceExternalLabBarcodes",0)==1){
								String specimenid=serverid+"."+transactionid+"."+labSample.type;
		                        String barcodeid=checkString(Labo.getLabBarcode(specimenid));
		                        if(unreceived.get(labSample.type)!=null){
	                            	if(barcodeid.length()>0){
	                            		out.print("<input type='checkbox' name='receive."+serverid+"."+transactionid+"." +labSample.type+"'/>");
	                            	}
	                            	else{
	                            		out.print("<input disabled type='checkbox' name='receive."+serverid+"."+transactionid+"." +labSample.type+"'/>");
	                            	}
	                                bInitialized = true;
		                        }
		                        else{
		                            %><img src="<c:url value='/_img/themes/default/check.gif'/>"/><%
		                        }
		                        String bgcolor="";
		                        if(activebarcode.equalsIgnoreCase(barcodeid)){
		                        	bgcolor="style='background-color: yellow'";
		                        }
		                        out.print("</center></td><td colspan='2'>"+MedwanQuery.getInstance().getLabel("labanalysis.monster",labSample.type,sWebLanguage)+"</td><td>"+(barcodeid.length()>0?"[ <font "+bgcolor+">"+barcodeid+"</font> ] <img src='"+sCONTEXTPATH+"/_img/icons/icon_print.png' onclick='printLabel(\""+specimenid+"\")'/></td>":"")+"<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:setSampleId(\""+specimenid+"\")'>"+getTran(request,"web","setbarcode",sWebLanguage)+"</a></tr>");
	                        }
	                        else{
		                        if(unreceived.get(labSample.type)!=null){
		                            out.print("<input type='checkbox' name='receive."+serverid+"."+transactionid+"." +labSample.type+"'/>");
		                            bInitialized = true;
		                        }
		                        else{
		                            %><img src="<c:url value='/_img/themes/default/check.gif'/>"/><%
		                        }
								String specimenid=serverid+"."+transactionid+"."+labSample.type;
		                        String barcodeid=checkString(Labo.getLabBarcode(specimenid));
		                        String bgcolor="";
		                        if(activebarcode.equalsIgnoreCase(barcodeid)){
		                        	bgcolor="style='background-color: yellow'";
		                        }
		                        out.print("</center></td><td colspan='2'>"+MedwanQuery.getInstance().getLabel("labanalysis.monster",labSample.type,sWebLanguage)+"</td><td>"+(barcodeid.length()>0?"[ <font "+bgcolor+">"+barcodeid+"</font> ] <img src='"+sCONTEXTPATH+"/_img/icons/icon_print.png' onclick='printLabel(\""+specimenid+"\")'/></td>":"")+"<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:setSampleId(\""+specimenid+"\")'>"+getTran(request,"web","setbarcode",sWebLanguage)+"</a></td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:createSampleId(\""+specimenid+"\")'>"+getTran(request,"web","generatebarcode",sWebLanguage)+"</a></td></tr>");
	                        }
	                    }
	                }
                }
            }
            catch(Exception e){
                e.printStackTrace();
            }
            try{
            	labrequestid=lr;
                if(labrequestid.length() > 0 ){
                    if(labrequestid.indexOf(".") == -1 && labrequestid.length()<10){
                   		labrequestid=MedwanQuery.getInstance().getServerId()+"."+labrequestid;
                    }
                    serverid = Integer.parseInt(labrequestid.split("\\.")[0]);
	                transactionid = Integer.parseInt(labrequestid.split("\\.")[1]);
                }
                
                LabRequest labRequest = LabRequest.getUnsampledRequest(serverid, Integer.toString(transactionid), sWebLanguage);
                if(labRequest != null && labRequest.getTransactionid()==transactionid){
                    out.print("<tr>");
                     out.print("<td colspan='2'>"+(labRequest.getRequestdate()!=null?ScreenHelper.formatDate(labRequest.getRequestdate(),ScreenHelper.fullDateFormat):"")+"<BR/><a href='javascript:showRequest("+labRequest.getServerid()+","+labRequest.getTransactionid()+")'><b><font style='background-color: yellow'>"+labRequest.getTransactionid()+" </font></b></a>"+" "+(labRequest.isUrgent()?" <img height='14px' title='"+getTranNoLink("labrequest.urgency","urgent",sWebLanguage)+"' src='"+sCONTEXTPATH+"/_img/icons/icon_blinkwarning.gif'/>":"")+"</td>");
                     out.print("<td><a href='javascript:readBarcode3(\"0"+labRequest.getPersonid()+"\");'><b>"+labRequest.getPatientname()+"</b></a> (°"+(labRequest.getPatientdateofbirth()!=null?ScreenHelper.formatDate(labRequest.getPatientdateofbirth()):"")+" - "+labRequest.getPatientgender()+")<br/><i>"+labRequest.getServicename()+" - "+MedwanQuery.getInstance().getUserName(labRequest.getUserid())+"</i></td>");
                    out.print("</tr>");
                    
                    Hashtable allsamples=labRequest.findAllSamples(sWebLanguage);
                    Hashtable unreceived = labRequest.findUnreceivedSamples(sWebLanguage);
                    Enumeration enumeration = allsamples.elements();
                    while (enumeration.hasMoreElements()){
                        LabSample labSample = (LabSample)enumeration.nextElement();
                        out.print("<tr><td><center>");
                        
                        if(MedwanQuery.getInstance().getConfigInt("forceExternalLabBarcodes",0)==1){
    						String specimenid=serverid+"."+transactionid+"."+labSample.type;
                            String barcodeid=checkString(Labo.getLabBarcode(specimenid));
                            if(unreceived.get(labSample.type)!=null){
                            	if(barcodeid.length()>0){
                            		out.print("<input type='checkbox' name='receive."+serverid+"."+transactionid+"." +labSample.type+"'/>");
                            	}
                            	else{
                            		out.print("<input disabled type='checkbox' name='receive."+serverid+"."+transactionid+"." +labSample.type+"'/>");
                            	}
                                bInitialized = true;
                            }
                            else{
                                %><img src="<c:url value='/_img/themes/default/check.gif'/>"/><%
                            }
                        	out.print("</center></td><td colspan='2'>"+MedwanQuery.getInstance().getLabel("labanalysis.monster",labSample.type,sWebLanguage)+"</td><td>"+(barcodeid.length()>0?"[ "+barcodeid+" ] <img src='"+sCONTEXTPATH+"/_img/icons/icon_print.png' onclick='printLabel(\""+specimenid+"\")'/></td>":"")+"<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:setSampleId(\""+specimenid+"\")'>"+getTran(request,"web","setbarcode",sWebLanguage)+"</a></td></tr>");
                        }
                        else{
                            if(unreceived.get(labSample.type)!=null){
                                out.print("<input type='checkbox' name='receive."+serverid+"."+transactionid+"." +labSample.type+"'/>");
                                bInitialized = true;
                            }
                            else{
                                %><img src="<c:url value='/_img/themes/default/check.gif'/>"/><%
                            }
    						String specimenid=serverid+"."+transactionid+"."+labSample.type;
                            String barcodeid=checkString(Labo.getLabBarcode(specimenid));
                        	out.print("</center></td><td colspan='2'>"+MedwanQuery.getInstance().getLabel("labanalysis.monster",labSample.type,sWebLanguage)+"</td><td>"+(barcodeid.length()>0?"[ "+barcodeid+" ] <img src='"+sCONTEXTPATH+"/_img/icons/icon_print.png' onclick='printLabel(\""+specimenid+"\")'/></td>":"")+"<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:setSampleId(\""+specimenid+"\")'>"+getTran(request,"web","setbarcode",sWebLanguage)+"</a></td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:createSampleId(\""+specimenid+"\")'>"+getTran(request,"web","generatebarcode",sWebLanguage)+"</a></td></tr>");
                        }
                    }
                }
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
        else{
            Vector unsampledRequests = LabRequest.findUnreceivedRequests(sWebLanguage);
            for(int n=0; n<unsampledRequests.size(); n++){
                LabRequest labRequest = (LabRequest)unsampledRequests.elementAt(n);
                if(labRequest!=null && labRequest.getRequestdate()!=null) {
                    out.print("<tr><td class='admin2'><b><a href='javascript:document.getElementById(\"labrequestid\").value=\""+labRequest.getServerid()+"."+labRequest.getTransactionid()+"\";selectRequest();'>"+(labRequest.getRequestdate()==null?"?":ScreenHelper.stdDateFormat.format(labRequest.getRequestdate()))+"</a> "+labRequest.getPatientname()+" </b></td><td class='admin2'> "+labRequest.getPatientgender()+" </td>"+
                            "<td class='admin2'> "+(labRequest.getPatientdateofbirth()==null?"?":ScreenHelper.stdDateFormat.format(labRequest.getPatientdateofbirth()))+" </td><td class='admin2'><i> "+labRequest.getServicename()+"</i></td>"+
                    		"<td class='admin2'>&nbsp;<i>"+getTran(request,"web","requestid",sWebLanguage)+":</i> <a href='javascript:showRequest("+labRequest.getServerid()+","+labRequest.getTransactionid()+")'><b>"+labRequest.getTransactionid()+"</b></a>"+(labRequest.isUrgent()?" <img height='14px' title='"+getTranNoLink("labrequest.urgency","urgent",sWebLanguage)+"' src='"+sCONTEXTPATH+"/_img/icons/icon_blinkwarning.gif'/>":"")+"</td></tr>");
                }
            }
        }
    }
%>
    </table>
<%
    if(bInitialized){
        %><br><input type="submit" class="button" name="receive" value="<%=getTranNoLink("web","receive",sWebLanguage)%>"/><%
    }
%>
    <div id="sampleReceiver"/>
</form>

<script>
  document.getElementsByName('labrequestid')[0].focus();
    
  function selectRequest(){
	  document.getElementById('find').value='1';
	  frmSampleReception.submit();
  }
  function showRequest(serverid,transactionid){
    window.open("<c:url value='/labos/manageLabResult_view.jsp'/>?ts=<%=getTs()%>&show."+serverid+"."+transactionid+"=1","Popup"+new Date().getTime(),"toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=800,height=600,menubar=no");
  }
  function doBack(){
    window.location.href="<c:url value="/main.do"/>?Page=labos/index.jsp";
  }
  function setSampleId(specimenid){
	  barcodeid=window.prompt('ID');
	  if(barcodeid.length>0){
		  document.getElementById('updatebarcode').value=specimenid+";"+barcodeid;
		  frmSampleReception.submit();
	  }
  }
  function createSampleId(specimenid){
	  document.getElementById('createbarcode').value=specimenid;
	  frmSampleReception.submit();
  }
  function printLabel(specimenid){
	  window.open("<c:url value='/healthrecord/createLabSampleLabelPdf.jsp'/>?execute."+specimenid, "Popup"+new Date().getTime(), "toolbar=no, status=yes, scrollbars=yes, resizable=yes, width=400, height=300, menubar=no").moveTo((screen.width - 400) / 2, (screen.height - 300) / 2);
  }
  
  <%
  if(sMessage.length()>0){
	  out.println("alert('"+sMessage+"');");
  }
  %>
  
</script>