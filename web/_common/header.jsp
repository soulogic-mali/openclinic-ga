<%@page import="be.openclinic.id.FingerPrint,
                be.mxs.common.util.system.Picture,
                be.openclinic.id.Barcode"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<script>    
  function checkDropdown(evt){
    if(window.myButton){
      lastevt = evt || window.event;
      var target;
      if(lastevt.target){
        target = lastevt.target;
      }
      else{
        target = lastevt.srcElement;
      }
      
      if(target.id.indexOf("menu") > -1 || target.id.indexOf("ddIcon") > -1){
    	return checkSaveButton();
      }
    }
  }
</script>

<table width="100%" cellspacing="0" cellpadding="0" class="topline">
    <tr>
        <%-- ADMIN HEADER --%>
        <td width="100%" valign="top" align="left">
            <table width="100%" cellspacing="0" cellpadding="0" border="0">
                <%
                    if(!"datacenter".equalsIgnoreCase((String)session.getAttribute("edition"))){
                        %>
			                <tr onmousedown="checkDropdown(event);">
			                    <td class="menu_bar" style="vertical-align:top;" colspan="3">
			                        <%ScreenHelper.setIncludePage(customerInclude("/_common/dropdownmenu.jsp"),pageContext);%>
			                    </td>			
			                </tr>
			                <tr>
			                    <td align="left">
			                        <%ScreenHelper.setIncludePage(customerInclude("/_common/searchPatient.jsp"),pageContext);%>
			                    </td>
			                </tr>
	                    <%
	                }
	            %>
            </table>
        </td>
        <td>
			<div>
			<%
			    if(!"datacenter".equalsIgnoreCase((String)session.getAttribute("edition"))){        
			        String sVersion = checkString((String)session.getAttribute("ProjectVersion"));
			
			        String bgi = "";
			        String sEdition = MedwanQuery.getInstance().getConfigString("edition","");
			        if("datacenter".equalsIgnoreCase(sEdition)){
			       	    bgi = "projects/datacenter/_img/projectlogo.jpg";
			        }
			        else if("openlab".equalsIgnoreCase(sEdition)){
			       	    bgi = "projects/openlab/_img/projectlogo.jpg";
			        }
			        else if("openpharmacy".equalsIgnoreCase(sEdition)){
			       	    bgi = "_img/openpharmacyprojectlogo.jpg";
			        }
			        else if("openinsurance".equalsIgnoreCase(sEdition)){
			       	    bgi = "_img/openinsuranceprojectlogo.jpg";
			        }
			        else{
			        	// default
					    bgi = "/"+sAPPDIR+"_img/themes/"+(sUserTheme.length()==0?"default":sUserTheme)+"/"+MedwanQuery.getInstance().getConfigString("defaultLogo","logo.png");
			        }
			
			        %>        
			            <div style="float:right;">
			                <%        		
						        // only show logo-div when logo-file was found
						   	    if(bgi.length() > 0){
						   	   	    String sLogoUrl = sAPPFULLDIR+"/"+bgi;
						   	   	    
						   	   	    java.io.File file = new java.io.File(sLogoUrl); 
						   	   	    if(!(file.exists() && file.isFile())){
						   	   	    	// default theme
						   			    bgi = "/_img/themes/default/"+MedwanQuery.getInstance().getConfigString("defaultLogo","logo.png");
						   	   	    	
						   	   	    	Debug.println("INFO : Configured project-logo-file for edition '"+sEdition+"' does not exist : '"+sLogoUrl+"', USING default logo");
						   	   	    }
						   	   	    
					   	   	   	    bgi = sCONTEXTPATH+"/"+bgi;   	   	   	    
					   	    	    %><div style='position: relative; display: inline'>
					   	    	    <center>
					   	    	    	<div style="padding-right: 10px ;padding-top: 5px;height: 22px">
									    <%
								            String sWorkTimeMessage = checkString((String)session.getAttribute("WorkTimeMessage"));
								            if(sWorkTimeMessage.length() > 0){
								                %><img style="float:right;" height='22px;' src="<c:url value='/_img/themes/default/men_at_work.gif'/>" alt="<%=(getTranNoLink("Web.Occup","medwan.common.workuntil",sWebLanguage)+" "+sWorkTimeMessage)%>"/><%
								            }
							
							                String sTmpPersonid = checkString(request.getParameter("personid"));
							                if(sTmpPersonid.length()==0){
							                    sTmpPersonid = checkString(request.getParameter("PersonID"));
							                }
							                
							                if(sTmpPersonid.length() > 0){
							                	try{
							                		sTmpPersonid = Integer.parseInt(sTmpPersonid)+"";
							                	}
							                	catch(Exception e){
							                		e.printStackTrace();
							                	}
							                	
							                    boolean bFingerPrint = FingerPrint.exists(Integer.parseInt(sTmpPersonid)),
							                            bPicture     = Picture.exists(Integer.parseInt(sTmpPersonid)),
							                            bBarcode     = Barcode.exists(Integer.parseInt(sTmpPersonid));
							                    if(!bFingerPrint){
							                        %> <a href="javascript:enrollFingerPrint();"><img style='vertical-align: middle' border='0' height='22px' src="<c:url value='/_img/icons/mobile/fingerprint.png'/>" alt="<%=getTranNoLink("web","enrollFingerPrint",sWebLanguage)%>"/></a><%
							                    }
							                    if(!bBarcode){
							                        %> <a href="javascript:printPatientCard();"><img style='vertical-align: middle' border='0' height='22px' src="<c:url value='/_img/icons/mobile/badge.png'/>" alt="<%=getTranNoLink("web","printPatientCard",sWebLanguage)%>"/></a><%
							                    }
							                    if(!bPicture){
							                        %> <a href="javascript:storePicture();"><img style='vertical-align: middle' border='0' height='22px' src="<c:url value='/_img/icons/mobile/camera.png'/>" alt="<%=getTranNoLink("web","loadPicture",sWebLanguage)%>"/></a><%
							                    }
							                }
							            %>
							            </div>
							            <br/>
							            <div style='vertical-align: bottom; padding-bottom: 5px; padding-right: 10px'>
						   	    	    	<img style='vertical-align: bottom' height='45px' src='<%=bgi%>'/><br/>
						   	    	    	<span style='white-space: nowrap;font-size: 9px'><%=sVersion %></span>
							   	    	    <% if(MedwanQuery.getInstance().getConfigString("TestEdition").equals("1")){ %>
							   	    	    <img height='35px' style="position: absolute;bottom: -65px;right:-120px;" src="<c:url value='/_img/themes/default/stamp_test.gif'/>" alt=""/>
							   	    	    <%} %>
							   	    	</div>
					   	    	    </center>
					   	    	    </div><%
						   	    }
			                %> 
			        	</div>        
			        <%
			    }
			%>
			</div>
        </td>
    </tr>
</table>

