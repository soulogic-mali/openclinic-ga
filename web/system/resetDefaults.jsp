<%@page import="be.mxs.common.util.system.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%
	String country=request.getParameter("country");
	String os=request.getParameter("os");
	String database=request.getParameter("database");
	String admindb=request.getParameter("admindb");
	String openclinicdb=request.getParameter("openclinicdb");
	String mxsref=request.getParameter("mxsref");
	String edition = request.getParameter("edition");
	if(mxsref==null){
		mxsref= MedwanQuery.getInstance().getConfigString("mxsref","be");
	}
	boolean bUpdateDb=request.getParameter("updatedb")!=null;
	if(admindb!=null){
		if(!admindb.equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("admindbName", "ocadmin_dbo"))){
			bUpdateDb=true;
			MedwanQuery.getInstance().setConfigString("admindbName", admindb);
		}
	}
	if(openclinicdb!=null){
		if(!openclinicdb.equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("openclinicdbName", "openclinic_dbo"))){
			bUpdateDb=true;
			MedwanQuery.getInstance().setConfigString("openclinicdbName", openclinicdb);
		}
	}
	if(country==null) country=MedwanQuery.getInstance().getConfigString("setup.country","");
	if(os==null) os=MedwanQuery.getInstance().getConfigString("setup.os","");
	if(database==null) database=MedwanQuery.getInstance().getConfigString("setup.database","");
	if(request.getParameter("update")!=null){		
		MedwanQuery.getInstance().setConfigString("edition", edition);
        UpdateSystem systemUpdate = new UpdateSystem();
        
		if(checkString(request.getParameter("project")).length()>0){
			systemUpdate.updateProject(request.getParameter("project"));
		}
        systemUpdate.updateSetup("country",country,request);
        systemUpdate.updateSetup("os",os,request);
        systemUpdate.updateSetup("database",database,request);
		if(bUpdateDb){
			systemUpdate.updateDb();
		}
		if(request.getParameter("updatelabels")!=null){
			systemUpdate.updateLabels(sAPPFULLDIR);
		}
		MedwanQuery.getInstance().reloadConfigValues();
		MedwanQuery.getInstance().reloadLabels();
		
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("select value from Items where itemid=(select min(itemid) from Items)");
		ResultSet rs = ps.executeQuery();
		int oldSize=rs.getMetaData().getColumnDisplaySize(1);
		rs.close();
		ps.close();
		ps = conn.prepareStatement("select value from ItemsHistory where itemid=(select min(itemid) from Items)");
		rs = ps.executeQuery();
		int oldSize2=rs.getMetaData().getColumnDisplaySize(1);
		int newSize=Integer.parseInt(request.getParameter("itemvaluesize"));
		if(oldSize!=newSize || oldSize2!=newSize){
			String server = conn.getMetaData().getDatabaseProductName();
			String sQuery1="alter table Items modify column value varchar("+newSize+")";
			String sQuery2="alter table ItemsHistory modify column value varchar("+newSize+")";
			if(!server.startsWith("MySQL")){
				sQuery1="alter table Items alter column value varchar("+newSize+")";
				sQuery2="alter table ItemsHistory alter column value varchar("+newSize+")";
			}
			rs.close();
			ps.close();
			ps = conn.prepareStatement(sQuery1);
			ps.execute();
			ps.close();
			ps = conn.prepareStatement(sQuery2);
			ps.execute();
		}
		else{
			rs.close();
		}
		ps.close();
		conn.close();
		if(mxsref!=null){
			MedwanQuery.getInstance().setConfigString("mxsref", mxsref);
		}
	}
%>

<form name='resetDefaults' method='post'>
	<table class="list" cellpadding="0" cellspacing="1" width="100%"> 
		<tr class='admin'><td colspan='2'><%=getTran(request,"web","configure.core",sWebLanguage)%>&nbsp</td></tr>
		<tr>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran(request,"web","country",sWebLanguage)%></td>
			<td class='admin2'>
				<select name='country' id='country' class='text'>
					<option value=''></option>
					<option value='be' <%="be".equals(country)?"selected":""%>><%=getTran(request,"country","be",sWebLanguage).toUpperCase() %></option>
					<option value='bf' <%="bf".equals(country)?"selected":""%>><%=getTran(request,"country","bf",sWebLanguage).toUpperCase() %></option>
					<option value='bj' <%="bj".equals(country)?"selected":""%>><%=getTran(request,"country","bj",sWebLanguage).toUpperCase() %></option>
					<option value='ne' <%="ne".equals(country)?"selected":""%>><%=getTran(request,"country","ne",sWebLanguage).toUpperCase() %></option>
					<option value='rw' <%="rw".equals(country)?"selected":""%>><%=getTran(request,"country","rw",sWebLanguage).toUpperCase() %></option>
					<option value='bi' <%="bi".equals(country)?"selected":""%>><%=getTran(request,"country","bi",sWebLanguage).toUpperCase() %></option>
					<option value='ml' <%="ml".equals(country)?"selected":""%>><%=getTran(request,"country","ml",sWebLanguage).toUpperCase() %></option>
					<option value='cd' <%="cd".equals(country)?"selected":""%>><%=getTran(request,"country","cd",sWebLanguage).toUpperCase() %></option>
					<option value='ci' <%="ci".equals(country)?"selected":""%>><%=getTran(request,"country","ci",sWebLanguage).toUpperCase() %></option>
					<option value='cm' <%="cm".equals(country)?"selected":""%>><%=getTran(request,"country","cm",sWebLanguage).toUpperCase() %></option>
					<option value='cg' <%="cg".equals(country)?"selected":""%>><%=getTran(request,"country","cg",sWebLanguage).toUpperCase() %></option>
					<option value='al' <%="al".equals(country)?"selected":""%>><%=getTran(request,"country","al",sWebLanguage).toUpperCase() %></option>
					<option value='tz' <%="tz".equals(country)?"selected":""%>><%=getTran(request,"country","tz",sWebLanguage).toUpperCase() %></option>
					<option value='br' <%="br".equals(country)?"selected":""%>><%=getTran(request,"country","br",sWebLanguage).toUpperCase() %></option>
					<option value='ke' <%="ke".equals(country)?"selected":""%>><%=getTran(request,"country","ke",sWebLanguage).toUpperCase() %></option>
					<option value='ug' <%="ug".equals(country)?"selected":""%>><%=getTran(request,"country","ug",sWebLanguage).toUpperCase() %></option>
					<option value='bd' <%="bd".equals(country)?"selected":""%>><%=getTran(request,"country","bd",sWebLanguage).toUpperCase() %></option>
					<option value='lk' <%="lk".equals(country)?"selected":""%>><%=getTran(request,"country","lk",sWebLanguage).toUpperCase() %></option>
					<option value='zm' <%="zm".equals(country)?"selected":""%>><%=getTran(request,"country","zm",sWebLanguage).toUpperCase() %></option>
					<option value='ng' <%="ng".equals(country)?"selected":""%>><%=getTran(request,"country","ng",sWebLanguage).toUpperCase() %></option>
					<option value='ga' <%="ga".equals(country)?"selected":""%>><%=getTran(request,"country","ga",sWebLanguage).toUpperCase() %></option>
					<option value='sn' <%="sn".equals(country)?"selected":""%>><%=getTran(request,"country","sn",sWebLanguage).toUpperCase() %></option>
					<option value='et' <%="et".equals(country)?"selected":""%>><%=getTran(request,"country","et",sWebLanguage).toUpperCase() %></option>
					<option value='gn' <%="gn".equals(country)?"selected":""%>><%=getTran(request,"country","gn",sWebLanguage).toUpperCase() %></option>
					<option value='pe' <%="pe".equals(country)?"selected":""%>><%=getTran(request,"country","pe",sWebLanguage).toUpperCase() %></option>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran(request,"web","supportcountry",sWebLanguage)%></td>
			<td class='admin2'>
				<select name='mxsref' id='mxsref' class='text'>
					<option value=''></option>
					<option value='be' <%="be".equalsIgnoreCase(mxsref)?"selected":""%>><%=getTran(request,"country","be",sWebLanguage).toUpperCase() %></option>
					<option value='rw' <%="rw".equalsIgnoreCase(mxsref)?"selected":""%>><%=getTran(request,"country","rw",sWebLanguage).toUpperCase() %></option>
					<option value='bi' <%="bi".equalsIgnoreCase(mxsref)?"selected":""%>><%=getTran(request,"country","bi",sWebLanguage).toUpperCase() %></option>
					<option value='ml' <%="ml".equalsIgnoreCase(mxsref)?"selected":""%>><%=getTran(request,"country","ml",sWebLanguage).toUpperCase() %></option>
					<option value='cd' <%="cd".equalsIgnoreCase(mxsref)?"selected":""%>><%=getTran(request,"country","cd",sWebLanguage).toUpperCase() %></option>
					<option value='tz' <%="tz".equalsIgnoreCase(mxsref)?"selected":""%>><%=getTran(request,"country","tz",sWebLanguage).toUpperCase() %></option>
					<option value='sn' <%="sn".equalsIgnoreCase(mxsref)?"selected":""%>><%=getTran(request,"country","sn",sWebLanguage).toUpperCase() %></option>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","os",sWebLanguage)%>&nbsp</td>
			<td class='admin2'>
				<%
					String detectedos=System.getProperty("os.name").toLowerCase();
					if(detectedos.contains("windows")){
						detectedos="windows";
					}
					else if(detectedos.contains("linux")){
						detectedos="linux";
					}
					else if(detectedos.contains("solaris")){
						detectedos="solaris";
					}
					else if(detectedos.contains("mac")){
						detectedos="mac";
					}
				%>
			
				<select name='os' class='text'>
					<option value=''></option>
					<option value='linux' <%="mac".equals(detectedos)?"selected":""%>><%=getTran(request,"web","mac",sWebLanguage).toUpperCase() %></option>
					<option value='linux' <%="solaris".equals(detectedos)?"selected":""%>><%=getTran(request,"web","solaris",sWebLanguage).toUpperCase() %></option>
					<option value='linux' <%="linux".equals(detectedos)?"selected":""%>><%=getTran(request,"web","linux",sWebLanguage).toUpperCase() %></option>
					<option value='windows' <%="windows".equals(detectedos)?"selected":""%>><%=getTran(request,"web","windows",sWebLanguage).toUpperCase() %></option>
				</select>
				<%
					if(!detectedos.equals(os)){
				%>
				<font color="red"><img src="<c:url value="_img/icons/icon_warning.gif"/>"/> <%=getTran(request,"web","wrong.os",sWebLanguage)+": "+os %></font>
				<%
					}
				%>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","databaseserver",sWebLanguage)%>&nbsp</td>
			<td class='admin2'>
				<%
					//Autodetect database
					Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			        String detecteddatabase = conn.getMetaData().getDatabaseProductName().toLowerCase();
				%>
				<select name='database' class='text'>
					<option value=''></option>
					<option value='mysql' <%="mysql".equals(detecteddatabase)?"selected":""%>><%=getTran(request,"web","mysql",sWebLanguage).toUpperCase() %></option>
					<option value='sqlserver' <%=detecteddatabase.replaceAll(" ", "").contains("sqlserver")?"selected":""%>><%=getTran(request,"web","sqlserver",sWebLanguage).toUpperCase() %></option>
				</select>
				<%
					if(!detecteddatabase.replaceAll(" ", "").contains(database)){
				%>
				<font color="red"><img src="<c:url value="_img/icons/icon_warning.gif"/>"/> <%=getTran(request,"web","wrong.database",sWebLanguage)+": "+database+" (<> "+detecteddatabase+")" %></font>
				<%
					}
				%>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","project",sWebLanguage)%>&nbsp</td>
			<td class='admin2'>
				<input class='text' type='text' name='project' id='project' value='<%=MedwanQuery.getInstance().getConfigString("defaultProject","openclinic")%>'/>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","updatelabels",sWebLanguage)%>&nbsp</td>
			<td class='admin2'>
				<input class='text' type='checkbox' name='updatelabels' id='undatelabels'/>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","updatedatabase",sWebLanguage)%>&nbsp</td>
			<td class='admin2'>
				<input class='text' type='checkbox' name='updatedb' id='undatedb'/>
			</td>
		</tr>
		<tr>
			<%
				PreparedStatement ps = conn.prepareStatement("select value from Items where itemid=(select min(itemid) from Items)");
				ResultSet rs = ps.executeQuery();
				int nSize=rs.getMetaData().getColumnDisplaySize(1);
				rs.close();
				ps.close();
				conn.close();
			%>
			<td class='admin'><%=getTran(request,"web","itemvaluesize",sWebLanguage)%>&nbsp</td>
			<td class='admin2'>
				<select name='itemvaluesize' id ='itemvaluesize' class='text'>
					<option value='255' <%=nSize==255?"selected":"" %>>255</option>
					<option value='1000' <%=nSize==1000?"selected":"" %>>1000</option>
					<option value='3000' <%=nSize==3000?"selected":"" %>>3000</option>
					<option value='5000' <%=nSize==5000?"selected":"" %>>5000</option>
				</select>
			</td>
		</tr>
		<tr>
			<%
				String sEdition=MedwanQuery.getInstance().getConfigString("edition","openclinic");
			%>
			<td class='admin'><%=getTran(request,"web","edition",sWebLanguage)%>&nbsp</td>
			<td class='admin2'>
				<select name='edition' id ='edition' class='text'>
					<option value='openclinic' <%=sEdition.equals("openclinic")?"selected":"" %>>openclinic</option>
					<option value='openpharmacy' <%=sEdition.equals("openpharmacy")?"selected":"" %>>openpharmacy</option>
					<option value='openinsurance' <%=sEdition.equals("openinsurance")?"selected":"" %>>openinsurance</option>
					<option value='gmao' <%=sEdition.equals("gmao")?"selected":"" %>>gmao</option>
					<option value='mpi' <%=sEdition.equals("mpi")?"selected":"" %>>mpi</option>
					<option value='bloodbank' <%=sEdition.equals("bloodbank")?"selected":"" %>>bloodbank</option>
				</select>
			</td>
		</tr>
		<tr>
			<%
				String detectedadmindb=MedwanQuery.getInstance().getAdminConnection().getCatalog();
			%>
			<td class='admin'><%=getTran(request,"web","admindb",sWebLanguage)%>&nbsp</td>
			<td class='admin2'>
				<input class='text' type='text' name='admindb' id='admindb' value='<%=detectedadmindb%>'/>
				<%
					if(!detectedadmindb.equals(MedwanQuery.getInstance().getConfigString("admindbName","openclinic_dbo"))){
				%>
				<font color="red"><img src="<c:url value="_img/icons/icon_warning.gif"/>"/> <%=getTran(request,"web","wrong.openclinicdb",sWebLanguage)+": <b>"+MedwanQuery.getInstance().getConfigString("admindbName","openclinic_dbo") %></b></font>
				<%
					}
				%>
			</td>
		</tr>
		<tr>
			<%
				String detectedopenclinicdb=MedwanQuery.getInstance().getOpenclinicConnection().getCatalog();
			%>
			<td class='admin'><%=getTran(request,"web","openclinicdb",sWebLanguage)%>&nbsp</td>
			<td class='admin2'>
				<input class='text' type='text' name='openclinicdb' id='openclinicdb' value='<%=detectedopenclinicdb%>'/>
				<%
					if(!detectedopenclinicdb.equals(MedwanQuery.getInstance().getConfigString("openclinicdbName","openclinic_dbo"))){
				%>
				<font color="red"><img src="<c:url value="_img/icons/icon_warning.gif"/>"/> <%=getTran(request,"web","wrong.openclinicdb",sWebLanguage)+": <b>"+MedwanQuery.getInstance().getConfigString("openclinicdbName","openclinic_dbo") %></b></font>
				<%
					}
				%>
			</td>
		</tr>
	</table>
	
	<%=ScreenHelper.alignButtonsStart()%>
	    <input class='button' type = 'submit' name='update' value='<%=getTranNoLink("web","update",sWebLanguage)%>'/>
	<%=ScreenHelper.alignButtonsStop()%>
</form>

<script>
function sortlist(list) {
	var lb = document.getElementById(list);
	arrTexts = new Array();
	arrValues = new Array();
	
	for(i=0; i<lb.length; i++)  {
		  arrTexts[i] = lb.options[i].text+";"+lb.options[i].value;
	}
	
	arrTexts.sort();
	
	for(i=0; i<lb.length; i++)  {
	  lb.options[i].text = arrTexts[i].split(";")[0];
	  lb.options[i].value = arrTexts[i].split(";")[1];
	  if(lb.options[i].value=='<%=country%>'){
		  lb.options.selectedIndex=i;
	  }
	}
}

sortlist('country');
</script>