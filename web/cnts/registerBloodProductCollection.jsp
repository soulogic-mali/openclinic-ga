<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	boolean bCanSave=true;
	java.util.Date registrationdate=null,transferdate=null;
	
	String giftid = checkString(request.getParameter("giftid"));
	String receptiondate = checkString(request.getParameter("receptiondate"));
	if(receptiondate.length()==0){
		receptiondate=ScreenHelper.getSQLDate(new java.util.Date());
	}
	String location = checkString(request.getParameter("location"));
	if(location.length()==0 && activeUser.activeService!=null){
		location = activeUser.activeService.getLabel(sWebLanguage);
	}

	String collectionunit = checkString(request.getParameter("collectionunit"));
	String lastname = checkString(request.getParameter("lastname"));
	String firstname = checkString(request.getParameter("firstname"));
	String dateofbirth = checkString(request.getParameter("dateofbirth"));
	String gender = checkString(request.getParameter("gender"));
	String telephone = checkString(request.getParameter("telephone"));
	String address = checkString(request.getParameter("address"));
	String volume = checkString(request.getParameter("volume"));
	String comment = checkString(request.getParameter("comment"));

	if(request.getParameter("submit")!=null){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		int nGiftId=-1;
		try{
			nGiftId=Integer.parseInt(giftid);
		}
		catch(Exception t){t.printStackTrace();}
		if(nGiftId>-1){
			//Search for an existing record with the same user
			PreparedStatement ps = conn.prepareStatement("select * from OC_BLOODCOLLECTIONS where OC_BLOODCOLLECTION_ID=? and OC_BLOODCOLLECTION_USERID=? and OC_BLOODCOLLECTION_INTEGRATIONDATE is NULL");
			ps.setInt(1, nGiftId);
			ps.setInt(2, Integer.parseInt(activeUser.userid));
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				//Save record
				rs.close();
				ps.close();
				ps=conn.prepareStatement("update OC_BLOODCOLLECTIONS set"+
						" OC_BLOODCOLLECTION_DATE=?,"+
						" OC_BLOODCOLLECTION_LOCATION=?,"+
						" OC_BLOODCOLLECTION_COLLECTIONUNIT=?,"+
						" OC_BLOODCOLLECTION_PATIENTNAME=?,"+
						" OC_BLOODCOLLECTION_PATIENTFIRSTNAME=?,"+
						" OC_BLOODCOLLECTION_PATIENTGENDER=?,"+
						" OC_BLOODCOLLECTION_PATIENTTELEPHONE=?,"+
						" OC_BLOODCOLLECTION_PATIENTADDRESS=?,"+
						" OC_BLOODCOLLECTION_PATIENTDATEOFBIRTH=?,"+
						" OC_BLOODCOLLECTION_VOLUME=?,"+
						" OC_BLOODCOLLECTION_COMMENT=?"+
						" WHERE"+
						" OC_BLOODCOLLECTION_ID=?"
				);
				java.sql.Date date = null;
				try{
					date = new java.sql.Date(ScreenHelper.parseDate(receptiondate).getTime());
				}
				catch(Exception t){}
				ps.setDate(1,date);
				ps.setString(2,location);
				ps.setString(3, collectionunit);
				ps.setString(4, lastname);
				ps.setString(5, firstname);
				ps.setString(6, gender);
				ps.setString(7, telephone);
				ps.setString(8, address);
				date = null;
				try{
					date = new java.sql.Date(ScreenHelper.parseDate(dateofbirth).getTime());
				}
				catch(Exception t){}
				ps.setDate(9, date);
				ps.setString(10, volume);
				ps.setString(11, comment);
				ps.setInt(12, nGiftId);
				ps.execute();
				ps.close();
			}
			else{
				//record does not exist, is not owned by user or has already been integrated
				//warn user
				rs.close();
				ps.close();
				out.println("<script>alert('"+getTranNoLink("cnts","collectionrecordnotavailable",sWebLanguage)+"');</script>");
				out.flush();
			}
		}
		else {
			nGiftId=MedwanQuery.getInstance().getOpenclinicCounter("OC_BLOODCOLLECTION_ID");
			giftid=nGiftId+"";
			//New record, insert it
			PreparedStatement ps = conn.prepareStatement("insert into OC_BLOODCOLLECTIONS("+
					" OC_BLOODCOLLECTION_DATE,"+
					" OC_BLOODCOLLECTION_LOCATION,"+
					" OC_BLOODCOLLECTION_COLLECTIONUNIT,"+
					" OC_BLOODCOLLECTION_PATIENTNAME,"+
					" OC_BLOODCOLLECTION_PATIENTFIRSTNAME,"+
					" OC_BLOODCOLLECTION_PATIENTGENDER,"+
					" OC_BLOODCOLLECTION_PATIENTTELEPHONE,"+
					" OC_BLOODCOLLECTION_PATIENTADDRESS,"+
					" OC_BLOODCOLLECTION_PATIENTDATEOFBIRTH,"+
					" OC_BLOODCOLLECTION_VOLUME,"+
					" OC_BLOODCOLLECTION_COMMENT,"+
					" OC_BLOODCOLLECTION_ID,"+
					" OC_BLOODCOLLECTION_USERID)"+
					" values(?,?,?,?,?,?,?,?,?,?,?,?,?)"
			);
			java.sql.Date date = null;
			try{
				date = new java.sql.Date(ScreenHelper.parseDate(receptiondate).getTime());
			}
			catch(Exception t){}
			ps.setDate(1,date);
			ps.setString(2,location);
			ps.setString(3, collectionunit);
			ps.setString(4, lastname);
			ps.setString(5, firstname);
			ps.setString(6, gender);
			ps.setString(7, telephone);
			ps.setString(8, address);
			date = null;
			try{
				date = new java.sql.Date(ScreenHelper.parseDate(dateofbirth).getTime());
			}
			catch(Exception t){}
			ps.setDate(9, date);
			ps.setString(10, volume);
			ps.setString(11, comment);
			ps.setInt(12, nGiftId);
			ps.setInt(13, Integer.parseInt(activeUser.userid));
			ps.execute();
			ps.close();
		}
	}
	
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'><td colspan='2'><%=getTran(request,"cnts","registerbloodcollection",sWebLanguage) %></td></tr>
		<tr>
			<td class='admin'><%=getTran(request,"bloodgift","giftid",sWebLanguage)%></td>
			<td class='admin2'>
				<input type='text' class='text' size='10' name='giftid' id='giftid' readonly value='<%=giftid%>'/>
				<img src='<c:url value="/_img/icons/icon_search.png"/>' onclick='searchId();'/>
				<img src='<c:url value="/_img/icons/icon_delete.png"/>' onclick='clearId();'/>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"bloodgift","receptiondate",sWebLanguage)%></td>
			<td class='admin2'>
	           	<%=ScreenHelper.writeDateField("receptiondate", "transactionForm",receptiondate , true, false, sWebLanguage, sCONTEXTPATH)%>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"bloodgift","location",sWebLanguage)%></td>
			<td class='admin2'>
				<input type='text' class='text' size='80' name='location' id='location' value='<%=location %>'/>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"bloodgift","collectionunit",sWebLanguage)%></td>
			<td class='admin2'>
				<input type='text' class='text' size='80' name='collectionunit' id='collectionunit' value='<%=collectionunit%>'/>
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
			<td class='admin'><%=getTran(request,"bloodgift","volume",sWebLanguage)%></td>
			<td class='admin2'>
				<input type='text' class='text' size='10' name='volume' id='volume' value='<%=volume%>'/> ml
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
		<input type='submit' id='submitbutton' name='submit' value='<%=getTran(null,"web","save",sWebLanguage)%>'/>
		<input type='button' id='closebutton' name='closebutton' value='<%=getTran(null,"web","close",sWebLanguage)%>' onclick='window.close();'/>
	</center>
</form>

<script>
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