<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	boolean bCanSave=true;
	java.util.Date registrationdate=null,transferdate=null;
	
	String giftid = checkString(request.getParameter("giftid"));
	String deliverydate = checkString(request.getParameter("deliverydate"));
	if(deliverydate.length()==0){
		deliverydate=ScreenHelper.getSQLDate(new java.util.Date());
	}
	String location = checkString(request.getParameter("location"));
	if(location.length()==0 && activeUser.activeService!=null){
		location = activeUser.activeService.getLabel(sWebLanguage);
	}

	String lastname = checkString(request.getParameter("lastname"));
	String firstname = checkString(request.getParameter("firstname"));
	String dateofbirth = checkString(request.getParameter("dateofbirth"));
	String gender = checkString(request.getParameter("gender"));
	String telephone = checkString(request.getParameter("telephone"));
	String address = checkString(request.getParameter("address"));
	String pockets = checkString(request.getParameter("pockets"));
	String comment = checkString(request.getParameter("comment"));
	boolean bDuplicateWarning =false;
	if(checkString(request.getParameter("duplicatewarning")).equalsIgnoreCase(giftid)){
		bDuplicateWarning=true;
	}

	if(request.getParameter("submit")!=null){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		int nGiftId=-1;
		try{
			nGiftId=Integer.parseInt(giftid);
		}
		catch(Exception t){t.printStackTrace();}
		if(nGiftId>-1){
			//Find out if the blood donation id exists
			PreparedStatement ps = conn.prepareStatement("select * from Transactions where transactionid=? and transactiontype=?");
			ps.setInt(1, nGiftId);
			ps.setString(2, "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_CNTS_BLOODGIFT");
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				//The bloodgift exists
				//Verify if this delivery has not yet been registered
				rs.close();
				ps.close();
				ps = conn.prepareStatement("select * from OC_BLOODDELIVERIES where OC_BLOODDELIVERY_ID=? AND "+
										   " OC_BLOODDELIVERY_DATE=? AND "+
										   " OC_BLOODDELIVERY_PATIENTNAME=? AND "+
										   " OC_BLOODDELIVERY_PATIENTDATEOFBIRTH=?");
				ps.setInt(1,nGiftId);
				java.sql.Date date = null;
				try{
					date = new java.sql.Date(ScreenHelper.parseDate(deliverydate).getTime());
				}
				catch(Exception t){}
				ps.setDate(2,date);
				ps.setString(3, lastname);
				date = null;
				try{
					date = new java.sql.Date(ScreenHelper.parseDate(dateofbirth).getTime());
				}
				catch(Exception t){}
				ps.setDate(4, date);
				rs = ps.executeQuery();
				if(rs.next()){
					if(!bDuplicateWarning){
						out.println("<script>alert('"+getTranNoLink("cnts","deliveryalreadyexists_usingdata",sWebLanguage)+"');</script>");
						out.flush();
						bDuplicateWarning=true;
						location=checkString(rs.getString("OC_BLOODDELIVERY_LOCATION"));
						firstname=checkString(rs.getString("OC_BLOODDELIVERY_PATIENTFIRSTNAME"));
						gender=checkString(rs.getString("OC_BLOODDELIVERY_PATIENTGENDER"));
						telephone=checkString(rs.getString("OC_BLOODDELIVERY_PATIENTTELEPHONE"));
						address=checkString(rs.getString("OC_BLOODDELIVERY_PATIENTADDRESS"));
						pockets=rs.getInt("OC_BLOODDELIVERY_POCKETS")+"";
						comment=checkString(rs.getString("OC_BLOODDELIVERY_COMMENT"));
						rs.close();
						ps.close();
					}
					else {
						//update existing record
						rs.close();
						ps.close();
						ps = conn.prepareStatement("delete from OC_BLOODDELIVERIES where OC_BLOODDELIVERY_ID=? AND "+
								   " OC_BLOODDELIVERY_DATE=? AND "+
								   " OC_BLOODDELIVERY_PATIENTNAME=? AND "+
								   " OC_BLOODDELIVERY_PATIENTDATEOFBIRTH=?");
						ps.setInt(1,nGiftId);
						date = null;
						try{
							date = new java.sql.Date(ScreenHelper.parseDate(deliverydate).getTime());
						}
						catch(Exception t){}
						ps.setDate(2,date);
						ps.setString(3, lastname);
						date = null;
						try{
							date = new java.sql.Date(ScreenHelper.parseDate(dateofbirth).getTime());
						}
						catch(Exception t){}
						ps.setDate(4, date);
						ps.execute();
						ps.close();
						ps = conn.prepareStatement("insert into OC_BLOODDELIVERIES("+
								" OC_BLOODDELIVERY_DATE,"+
								" OC_BLOODDELIVERY_LOCATION,"+
								" OC_BLOODDELIVERY_PATIENTNAME,"+
								" OC_BLOODDELIVERY_PATIENTFIRSTNAME,"+
								" OC_BLOODDELIVERY_PATIENTGENDER,"+
								" OC_BLOODDELIVERY_PATIENTTELEPHONE,"+
								" OC_BLOODDELIVERY_PATIENTADDRESS,"+
								" OC_BLOODDELIVERY_PATIENTDATEOFBIRTH,"+
								" OC_BLOODDELIVERY_POCKETS,"+
								" OC_BLOODDELIVERY_COMMENT,"+
								" OC_BLOODDELIVERY_ID,"+
								" OC_BLOODDELIVERY_USERID)"+
								" values(?,?,?,?,?,?,?,?,?,?,?,?)"
						);
						date = null;
						try{
							date = new java.sql.Date(ScreenHelper.parseDate(deliverydate).getTime());
						}
						catch(Exception t){}
						ps.setDate(1,date);
						ps.setString(2,location);
						ps.setString(3, lastname);
						ps.setString(4, firstname);
						ps.setString(5, gender);
						ps.setString(6, telephone);
						ps.setString(7, address);
						date = null;
						try{
							date = new java.sql.Date(ScreenHelper.parseDate(dateofbirth).getTime());
						}
						catch(Exception t){}
						ps.setDate(8, date);
						ps.setInt(9, Integer.parseInt(pockets));
						ps.setString(10, comment);
						ps.setInt(11, nGiftId);
						ps.setInt(12, Integer.parseInt(activeUser.userid));
						ps.execute();
						ps.close();
					}
				}
				else {
					//Now register a patient delivery (using a pointer) 
					rs.close();
					ps.close();
					ps = conn.prepareStatement("insert into OC_BLOODDELIVERIES("+
							" OC_BLOODDELIVERY_DATE,"+
							" OC_BLOODDELIVERY_LOCATION,"+
							" OC_BLOODDELIVERY_PATIENTNAME,"+
							" OC_BLOODDELIVERY_PATIENTFIRSTNAME,"+
							" OC_BLOODDELIVERY_PATIENTGENDER,"+
							" OC_BLOODDELIVERY_PATIENTTELEPHONE,"+
							" OC_BLOODDELIVERY_PATIENTADDRESS,"+
							" OC_BLOODDELIVERY_PATIENTDATEOFBIRTH,"+
							" OC_BLOODDELIVERY_POCKETS,"+
							" OC_BLOODDELIVERY_COMMENT,"+
							" OC_BLOODDELIVERY_ID,"+
							" OC_BLOODDELIVERY_USERID)"+
							" values(?,?,?,?,?,?,?,?,?,?,?,?)"
					);
					date = null;
					try{
						date = new java.sql.Date(ScreenHelper.parseDate(deliverydate).getTime());
					}
					catch(Exception t){}
					ps.setDate(1,date);
					ps.setString(2,location);
					ps.setString(3, lastname);
					ps.setString(4, firstname);
					ps.setString(5, gender);
					ps.setString(6, telephone);
					ps.setString(7, address);
					date = null;
					try{
						date = new java.sql.Date(ScreenHelper.parseDate(dateofbirth).getTime());
					}
					catch(Exception t){}
					ps.setDate(8, date);
					ps.setInt(9, Integer.parseInt(pockets));
					ps.setString(10, comment);
					ps.setInt(11, nGiftId);
					ps.setInt(12, Integer.parseInt(activeUser.userid));
					ps.execute();
					ps.close();
				}
			}
			else{
				//blooddonation id does not exist
				//warn user
				rs.close();
				ps.close();
				out.println("<script>alert('"+getTranNoLink("cnts","donationidnotavailable",sWebLanguage)+"');</script>");
				out.flush();
			}
		}
	}
	
%>
<form name='transactionForm' method='post'>
	<%if(bDuplicateWarning){ %>
		<input type='hidden' name='duplicatewarning' id='duplicatewarning' value='<%=giftid%>'/>
	<%} %>
	<table width='100%'>
		<tr class='admin'><td colspan='2'><%=getTran(request,"cnts","registerblooddelivery",sWebLanguage) %></td></tr>
		<tr>
			<td class='admin'><%=getTran(request,"bloodgift","giftid",sWebLanguage)%></td>
			<td class='admin2'>
				<input type='text' class='text' size='10' name='giftid' id='giftid' value='<%=giftid%>'/>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"bloodgift","deliverydate",sWebLanguage)%></td>
			<td class='admin2'>
	           	<%=ScreenHelper.writeDateField("deliverydate", "transactionForm",deliverydate , true, false, sWebLanguage, sCONTEXTPATH)%>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"bloodgift","deliverylocation",sWebLanguage)%></td>
			<td class='admin2'>
				<input type='text' class='text' size='80' name='location' id='location' value='<%=location %>'/>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","lastname",sWebLanguage)%></td>
			<td class='admin2'>
				<input type='text' class='text' size='80' name='lastname' id='lastname' value='<%=lastname%>'/>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","firstname",sWebLanguage)%></td>
			<td class='admin2'>
				<input type='text' class='text' size='80' name='firstname' id='firstname' value='<%=firstname%>'/>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","dateofbirth",sWebLanguage)%></td>
			<td class='admin2'>
	           	<%=ScreenHelper.writeDateField("dateofbirth", "transactionForm",dateofbirth, true, false, sWebLanguage, sCONTEXTPATH)%>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","gender",sWebLanguage)%></td>
			<td class='admin2'>
				<select name='gender' id='gender' class='text'>
					<option/>
					<option value='m' <%=gender.equalsIgnoreCase("m")?"selected":"" %>>M</option>
					<option value='f' <%=gender.equalsIgnoreCase("f")?"selected":"" %>>F</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","telephone",sWebLanguage)%></td>
			<td class='admin2'>
				<input type='text' class='text' size='80' name='telephone' id='telephone' value='<%=telephone%>'/>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","address",sWebLanguage)%></td>
			<td class='admin2'>
				<input type='text' class='text' size='80' name='address' id='address' value='<%=address%>'/>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"bloodgift","pockets",sWebLanguage)%></td>
			<td class='admin2'>
				<select class='text' name='pockets' id='pockets'>
					<option value='0' <%=pockets.equalsIgnoreCase("0")?"selected":"" %>></option>
					<option value='1' <%=pockets.equalsIgnoreCase("1")?"selected":"" %>>1</option>
					<option value='2' <%=pockets.equalsIgnoreCase("2")?"selected":"" %>>2</option>
					<option value='3' <%=pockets.equalsIgnoreCase("3")?"selected":"" %>>3</option>
					<option value='4' <%=pockets.equalsIgnoreCase("4")?"selected":"" %>>4</option>
					<option value='5' <%=pockets.equalsIgnoreCase("5")?"selected":"" %>>5</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","comment",sWebLanguage)%></td>
			<td class='admin2'>
				<textarea class='text' cols='68' name='comment' id='comment'><%=comment %></textarea>
			</td>
		</tr>
	</table>
	<center>
		<input type='submit' id='submitbutton' name='submit' value='<%=getTran(null,"web","save",sWebLanguage)%>' onclick="doSubmit();"/>
		<input type='button' id='closebutton' name='closebutton' value='<%=getTran(null,"web","close",sWebLanguage)%>' onclick='window.close();'/>
	</center>
</form>

<script>
	function doSubmit(){
		if(document.getElementById("giftid").value.length==0){
			alert('<%=getTran(null,"web.manage","datamissing",sWebLanguage)%>');
			document.getElementById("giftid").focus;
		}
		else if(document.getElementById("pockets").value=='0'){
			alert('<%=getTran(null,"web.manage","datamissing",sWebLanguage)%>');
			document.getElementById("pockets").focus;
		}
		else{
			transactionForm.submit();
		}
	}

	function clearId(){
		document.getElementById('giftid').value='';
	}
	
	function searchId(){
	    openPopup("/_common/search/searchBloodCollections.jsp&ts=<%=getTs()%>&ReturnField=giftid&ReturnFunction=findCollection()&PopuHeight=400&PopupWidth=600");
	}
	
	function findCollection(){
	    var params = 'giftid='+document.getElementById("giftid").value;
	    var url = '<c:url value="/cnts/getCollectionData.jsp"/>?ts='+new Date();
	    new Ajax.Request(url,{
	 	method: "GET",
	      parameters: params,
	      onSuccess: function(resp){
	        var label = eval('('+resp.responseText+')');
	        $("giftid").value = label.giftid;
	        $("receptiondate").value = label.receptiondate;
	        $("location").value = label.location;
	        $("collectionunit").value = label.collectionunit;
	        $("lastname").value = label.lastname;
	        $("firstname").value = label.firstname;
	        $("dateofbirth").value = label.dateofbirth;
	        $("gender").value = label.gender;
	        $("telephone").value = label.telephone;
	        $("address").value = label.address;
	        $("volume").value = label.volume;
	        $("comment").value = label.comment;
	      }
	    });
	}
</script>