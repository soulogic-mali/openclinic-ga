<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<logic:present name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="healthRecordVO">
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
    <bean:define id="lastTransaction_biometry" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="lastTransactionTypeBiometry"/>
    <%String type="";int level; %>
	<table class="list" width="100%" border="0" cellspacing="1" cellpadding="0">
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"triage","fase2title",sWebLanguage) %></td>
		</tr>
        <tr>
			<td class='admin' width='16%'><%=getTran(request,"triage","infection",sWebLanguage) %></td>
			<td class='admin2' id='infection'>
				<table width='100%'>
					<tr>
						<td width='20%' style='vertical-align: top; background-color: #FF5959'>
							<table width='100%'>
								<%
									type="INFECTION";
									level=1;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold; color:white'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FE9A2E'>
							<table width='100%'>
								<%
									level=2;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFF00'>
							<table width='100%'>
								<%
									level=3;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #01DF01'>
							<table width='100%'>
								<%
									level=4;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFFFF'>
							<table width='100%'>
								<%
									level=5;
									for(int n=1;n<=0;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
        <tr>
			<td class='admin' width='16%'><%=getTran(request,"triage","pain",sWebLanguage) %></td>
			<td class='admin2' id='PAIN'>
				<table width='100%'>
					<tr>
						<td width='20%' style='vertical-align: top; background-color: #FF5959'>
							<table width='100%'>
								<%
									type="PAIN";
									level=1;
									for(int n=1;n<=0;n++){ 
								%>
									<tr><td style='font-weight: bold; color:white'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FE9A2E'>
							<table width='100%'>
								<%
									level=2;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFF00'>
							<table width='100%'>
								<%
									level=3;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #01DF01'>
							<table width='100%'>
								<%
									level=4;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFFFF'>
							<table width='100%'>
								<%
									level=5;
									for(int n=1;n<=0;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
        <tr>
			<td class='admin' width='16%'><%=getTran(request,"triage","respiratory",sWebLanguage) %></td>
			<td class='admin2' id='RESPIRATORY'>
				<table width='100%'>
					<tr>
						<td width='20%' style='vertical-align: top; background-color: #FF5959'>
							<table width='100%'>
								<%
									type="RESPIRATORY";
									level=1;
									for(int n=1;n<=5;n++){ 
								%>
									<tr><td style='font-weight: bold; color:white'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FE9A2E'>
							<table width='100%'>
								<%
									level=2;
									for(int n=1;n<=5;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFF00'>
							<table width='100%'>
								<%
									level=3;
									for(int n=1;n<=5;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #01DF01'>
							<table width='100%'>
								<%
									level=4;
									for(int n=1;n<=3;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFFFF'>
						</td>
					</tr>
				</table>
			</td>
		</tr>
        <tr>
			<td class='admin' width='16%'><%=getTran(request,"triage","neurology",sWebLanguage) %></td>
			<td class='admin2' id='NEUROLOGY'>
				<table width='100%'>
					<tr>
						<td width='20%' style='vertical-align: top; background-color: #FF5959'>
							<table width='100%'>
								<%
								 	type="NEUROLOGY";
									level=1;
									for(int n=1;n<=3;n++){ 
								%>
									<tr><td style='font-weight: bold; color:white'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FE9A2E'>
							<table width='100%'>
								<%
									level=2;
									for(int n=1;n<=5;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFF00'>
							<table width='100%'>
								<%
									level=3;
									for(int n=1;n<=5;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #01DF01'>
							<table width='100%'>
								<%
									level=4;
									for(int n=1;n<=2;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFFFF'>
						</td>
					</tr>
				</table>
			</td>
        </tr>
        <tr>
			<td class='admin' width='16%'><%=getTran(request,"triage","cardiovascular",sWebLanguage) %></td>
			<td class='admin2' id='CARDIOVASCULAR'>
				<table width='100%'>
					<tr>
						<td width='20%' style='vertical-align: top; background-color: #FF5959'>
							<table width='100%'>
								<%
								 	type="CARDIOVASCULAR";
									level=1;
									for(int n=1;n<=4;n++){ 
								%>
									<tr><td style='font-weight: bold; color:white'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FE9A2E'>
							<table width='100%'>
								<%
									level=2;
									for(int n=1;n<=4;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFF00'>
							<table width='100%'>
								<%
									level=3;
									for(int n=1;n<=3;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #01DF01'>
							<table width='100%'>
								<%
									level=4;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFFFF'>
							<table width='100%'>
								<%
									level=5;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
					</tr>
				</table>
			</td>
        </tr>
        <tr>
			<td class='admin' width='16%'><%=getTran(request,"triage","muscular",sWebLanguage) %></td>
			<td class='admin2' id='MUSCULAR'>
				<table width='100%'>
					<tr>
						<td width='20%' style='vertical-align: top; background-color: #FF5959'>
							<table width='100%'>
								<%
								 	type="MUSCULAR";
									level=1;
									for(int n=1;n<=3;n++){ 
								%>
									<tr><td style='font-weight: bold; color:white'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FE9A2E'>
							<table width='100%'>
								<%
									level=2;
									for(int n=1;n<=5;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFF00'>
							<table width='100%'>
								<%
									level=3;
									for(int n=1;n<=4;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #01DF01'>
							<table width='100%'>
								<%
									level=4;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFFFF'>
							<table width='100%'>
								<%
									level=5;
									for(int n=1;n<=0;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
					</tr>
				</table>
			</td>
        </tr>
        <tr>
			<td class='admin' width='16%'><%=getTran(request,"triage","skin",sWebLanguage) %></td>
			<td class='admin2' id='SKIN'>
				<table width='100%'>
					<tr>
						<td width='20%' style='vertical-align: top; background-color: #FF5959'>
							<table width='100%'>
								<%
								 	type="SKIN";
									level=1;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold; color:white'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FE9A2E'>
							<table width='100%'>
								<%
									level=2;
									for(int n=1;n<=4;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFF00'>
							<table width='100%'>
								<%
									level=3;
									for(int n=1;n<=3;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #01DF01'>
							<table width='100%'>
								<%
									level=4;
									for(int n=1;n<=3;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFFFF'>
							<table width='100%'>
								<%
									level=5;
									for(int n=1;n<=4;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
					</tr>
				</table>
			</td>
        </tr>
        <tr>
			<td class='admin' width='16%'><%=getTran(request,"triage","gastrointestinal",sWebLanguage) %></td>
			<td class='admin2' id='GASTROINTESTINAL'>
				<table width='100%'>
					<tr>
						<td width='20%' style='vertical-align: top; background-color: #FF5959'>
							<table width='100%'>
								<%
								 	type="GASTROINTESTINAL";
									level=1;
									for(int n=1;n<=2;n++){ 
								%>
									<tr><td style='font-weight: bold; color:white'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FE9A2E'>
							<table width='100%'>
								<%
									level=2;
									for(int n=1;n<=3;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFF00'>
							<table width='100%'>
								<%
									level=3;
									for(int n=1;n<=3;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #01DF01'>
							<table width='100%'>
								<%
									level=4;
									for(int n=1;n<=3;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFFFF'>
							<table width='100%'>
								<%
									level=5;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
					</tr>
				</table>
			</td>
        </tr>
        <tr>
			<td class='admin' width='16%'><%=getTran(request,"triage","gynecology",sWebLanguage) %></td>
			<td class='admin2' id='GYNECOLOGY'>
				<table width='100%'>
					<tr>
						<td width='20%' style='vertical-align: top; background-color: #FF5959'>
							<table width='100%'>
								<%
									type="GYNECOLOGY";
									level=1;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold; color:white'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FE9A2E'>
							<table width='100%'>
								<%
									level=2;
									for(int n=1;n<=5;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFF00'>
							<table width='100%'>
								<%
									level=3;
									for(int n=1;n<=4;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #01DF01'>
							<table width='100%'>
								<%
									level=4;
									for(int n=1;n<=2;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFFFF'>
						</td>
					</tr>
				</table>
			</td>
		</tr>
        <tr>
			<td class='admin' width='16%'><%=getTran(request,"triage","ent",sWebLanguage) %></td>
			<td class='admin2' id='ENT'>
				<table width='100%'>
					<tr>
						<td width='20%' style='vertical-align: top; background-color: #FF5959'>
							<table width='100%'>
								<%
									type="ENT";
									level=1;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold; color:white'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FE9A2E'>
							<table width='100%'>
								<%
									level=2;
									for(int n=1;n<=5;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFF00'>
							<table width='100%'>
								<%
									level=3;
									for(int n=1;n<=6;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #01DF01'>
							<table width='100%'>
								<%
									level=4;
									for(int n=1;n<=2;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFFFF'>
							<table width='100%'>
								<%
									level=5;
									for(int n=1;n<=4;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
        <tr>
			<td class='admin' width='16%'><%=getTran(request,"triage","eye",sWebLanguage) %></td>
			<td class='admin2' id='EYE'>
				<table width='100%'>
					<tr>
						<td width='20%' style='vertical-align: top; background-color: #FF5959'>
							<table width='100%'>
								<%
									type="EYE";
									level=1;
									for(int n=1;n<=0;n++){ 
								%>
									<tr><td style='font-weight: bold; color:white'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FE9A2E'>
							<table width='100%'>
								<%
									level=2;
									for(int n=1;n<=4;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFF00'>
							<table width='100%'>
								<%
									level=3;
									for(int n=1;n<=2;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #01DF01'>
							<table width='100%'>
								<%
									level=4;
									for(int n=1;n<=2;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFFFF'>
							<table width='100%'>
								<%
									level=5;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
        <tr>
			<td class='admin' width='16%'><%=getTran(request,"triage","hematology",sWebLanguage) %></td>
			<td class='admin2' id='HEMATOLOGY'>
				<table width='100%'>
					<tr>
						<td width='20%' style='vertical-align: top; background-color: #FF5959'>
							<table width='100%'>
								<%
									type="HEMATOLOGY";
									level=1;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold; color:white'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FE9A2E'>
							<table width='100%'>
								<%
									level=2;
									for(int n=1;n<=3;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFF00'>
							<table width='100%'>
								<%
									level=3;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #01DF01'>
							<table width='100%'>
								<%
									level=4;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFFFF'>
							<table width='100%'>
								<%
									level=5;
									for(int n=1;n<=0;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
        <tr>
			<td class='admin' width='16%'><%=getTran(request,"triage","endocrinology",sWebLanguage) %></td>
			<td class='admin2' id='ENDOCRINOLOGY'>
				<table width='100%'>
					<tr>
						<td width='20%' style='vertical-align: top; background-color: #FF5959'>
							<table width='100%'>
								<%
									type="ENDOCRINOLOGY";
									level=1;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold; color:white'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FE9A2E'>
							<table width='100%'>
								<%
									level=2;
									for(int n=1;n<=2;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFF00'>
							<table width='100%'>
								<%
									level=3;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #01DF01'>
							<table width='100%'>
								<%
									level=4;
									for(int n=1;n<=0;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFFFF'>
							<table width='100%'>
								<%
									level=5;
									for(int n=1;n<=0;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
        <tr>
			<td class='admin' width='16%'><%=getTran(request,"triage","psychiatry",sWebLanguage) %></td>
			<td class='admin2' id='PSY'>
				<table width='100%'>
					<tr>
						<td width='20%' style='vertical-align: top; background-color: #FF5959'>
							<table width='100%'>
								<%
									type="PSY";
									level=1;
									for(int n=1;n<=0;n++){ 
								%>
									<tr><td style='font-weight: bold; color:white'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FE9A2E'>
							<table width='100%'>
								<%
									level=2;
									for(int n=1;n<=3;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFF00'>
							<table width='100%'>
								<%
									level=3;
									for(int n=1;n<=3;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #01DF01'>
							<table width='100%'>
								<%
									level=4;
									for(int n=1;n<=2;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFFFF'>
							<table width='100%'>
								<%
									level=5;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
        <tr>
			<td class='admin' width='16%'><%=getTran(request,"triage","behavior",sWebLanguage) %></td>
			<td class='admin2' id='BEHAVIOR'>
				<table width='100%'>
					<tr>
						<td width='20%' style='vertical-align: top; background-color: #FF5959'>
							<table width='100%'>
								<%
									type="BEHAVIOR";
									level=1;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold; color:white'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FE9A2E'>
							<table width='100%'>
								<%
									level=2;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFF00'>
							<table width='100%'>
								<%
									level=3;
									for(int n=1;n<=2;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #01DF01'>
							<table width='100%'>
								<%
									level=4;
									for(int n=1;n<=2;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFFFF'>
							<table width='100%'>
								<%
									level=5;
									for(int n=1;n<=0;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
        <tr>
			<td class='admin' width='16%'><%=getTran(request,"triage","violence",sWebLanguage) %></td>
			<td class='admin2' id='VIOLENCE'>
				<table width='100%'>
					<tr>
						<td width='20%' style='vertical-align: top; background-color: #FF5959'>
							<table width='100%'>
								<%
									type="VIOLENCE";
									level=1;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold; color:white'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FE9A2E'>
							<table width='100%'>
								<%
									level=2;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFF00'>
							<table width='100%'>
								<%
									level=3;
									for(int n=1;n<=2;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #01DF01'>
							<table width='100%'>
								<%
									level=4;
									for(int n=1;n<=1;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
						<td width='20%' style='vertical-align: top; background-color: #FFFFFF'>
							<table width='100%'>
								<%
									level=5;
									for(int n=1;n<=0;n++){ 
								%>
									<tr><td style='font-weight: bold'><input id="p<%=level %>_<%=type %>_<%=n %>" onclick='doTriage()' class='text' <%=setRightClick(session,"ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n)%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<%=((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).getItemId() %>]>.value" value="medwan.common.yes" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRIAGE_PHASE2_"+type+"_"+level+"_"+n).equalsIgnoreCase("medwan.common.yes")?"checked":"" %>><%=getTran(request,"web","triage2_"+type+"_"+level+"_"+n,sWebLanguage)%></td></tr>
								<%
									} 
								%>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
    </table>
</logic:present>