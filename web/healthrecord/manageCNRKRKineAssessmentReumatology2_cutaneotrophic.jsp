<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='0' cellpadding='0'>
	<tr>
		<td class='admin2' width='70%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","wound",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<table width='100%'>
       						<tr>
								<td width='30%'>
				   					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAWOUND", "cnrkr.yesno", sWebLanguage, "") %>
				   				</td>
				   				<td>
				   					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_CUTAWOUNDTEXT", 30, 1) %>
				   				</td>
				   			</tr>
				   		</table>
				   	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","scar",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<table width='100%'>
       						<tr>
								<td width='30%'>
				   					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTASCAR", "cnrkr.yesno", sWebLanguage, "") %>
				   				</td>
				   				<td>
				   					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTASCARTEXT", 30, 1) %>
				   				</td>
				   			</tr>
				   		</table>
				   	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTASCARSTATE"><%=getTran(request,"cnrkr","scar.state",sWebLanguage)%></div>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTASCARSTATE", "cnrkr.scarstate", "keywords2", sCONTEXTPATH, sWebLanguage,request) %>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMALOCATION"><%=getTran(request,"cnrkr","oedema.location",sWebLanguage)%></div>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMALOCATION", "cnrkr.oedemalocation", "keywords2", sCONTEXTPATH, sWebLanguage,request) %>
			       	</td>
				</tr>
				<tr class='admin'>
       				<td colspan='2'>
       					<%=getTran(request,"cnrkr","oedema.measurement",sWebLanguage)%>
       				</td>
       			</tr>
				<tr>
       				<td class='admin' width='20%'></td>
       				<td class='admin2' style="padding:0px;">
       					<table width='100%' cellspacing='0' cellpadding='0'>
       						<tr>
			       				<td class='admin' width='25%'><center>5 cm</center></td>
			       				<td class='admin' width='25%'><center>10 cm</center></td>
			       				<td class='admin' width='25%'><center>15 cm</center></td>
			       				<td class='admin' width='25%'><center>20 cm</center></td>
			       			</tr>
				   		</table>
				   	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'></td>
       				<td class='admin2' style="padding:0px;">
       					<table width='100%' cellspacing='0' cellpadding='0'>
       						<tr>
			       				<td class='admin' width='12.5%'><center><%=getTran(request,"cnrkr","R",sWebLanguage) %></center></td>
			       				<td class='admin' width='12.5%'><center><%=getTran(request,"cnrkr","L",sWebLanguage) %></center></td>
			       				<td class='admin' width='12.5%'><center><%=getTran(request,"cnrkr","R",sWebLanguage) %></center></td>
			       				<td class='admin' width='12.5%'><center><%=getTran(request,"cnrkr","L",sWebLanguage) %></center></td>
			       				<td class='admin' width='12.5%'><center><%=getTran(request,"cnrkr","R",sWebLanguage) %></center></td>
			       				<td class='admin' width='12.5%'><center><%=getTran(request,"cnrkr","L",sWebLanguage) %></center></td>
			       				<td class='admin' width='12.5%'><center><%=getTran(request,"cnrkr","R",sWebLanguage) %></center></td>
			       				<td class='admin' width='12.5%'><center><%=getTran(request,"cnrkr","L",sWebLanguage) %></center></td>
			       			</tr>
				   		</table>
				   	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'><%=getTran(request,"cnrkr","acromion",sWebLanguage) %></td>
       				<td class='admin2' style="padding:0px;">
       					<table width='100%' cellspacing='0' cellpadding='0'>
       						<tr>
       							<%String m = "ACRO"; %>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"5_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"10_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"10_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"15_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"15_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"20_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"20_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       			</tr>
				   		</table>
				   	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'><%=getTran(request,"cnrkr","olecranium",sWebLanguage) %></td>
       				<td class='admin2' style="padding:0px;">
       					<table width='100%' cellspacing='0' cellpadding='0'>
       						<tr>
       							<%m = "OLECRA"; %>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"5_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"10_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"10_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"15_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"15_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"20_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"20_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       			</tr>
				   		</table>
				   	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'><%=getTran(request,"cnrkr","styloid",sWebLanguage) %></td>
       				<td class='admin2' style="padding:0px;">
       					<table width='100%' cellspacing='0' cellpadding='0'>
       						<tr>
       							<%m = "STYLO"; %>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"5_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"10_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"10_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"15_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"15_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"20_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"20_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       			</tr>
				   		</table>
				   	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'><%=getTran(request,"cnrkr","eias",sWebLanguage) %></td>
       				<td class='admin2' style="padding:0px;">
       					<table width='100%' cellspacing='0' cellpadding='0'>
       						<tr>
       							<%m = "EIAS"; %>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"5_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"10_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"10_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"15_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"15_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"20_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"20_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       			</tr>
				   		</table>
				   	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'><%=getTran(request,"cnrkr","patella",sWebLanguage) %></td>
       				<td class='admin2' style="padding:0px;">
       					<table width='100%' cellspacing='0' cellpadding='0'>
       						<tr>
       							<%m = "PATELLA"; %>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"5_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"10_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"10_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"15_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"15_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"20_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"20_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       			</tr>
				   		</table>
				   	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'><%=getTran(request,"cnrkr","tta",sWebLanguage) %></td>
       				<td class='admin2' style="padding:0px;">
       					<table width='100%' cellspacing='0' cellpadding='0'>
       						<tr>
       							<%m = "TTA"; %>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"5_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"10_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"10_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"15_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"15_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"20_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"20_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       			</tr>
				   		</table>
				   	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'><%=getTran(request,"cnrkr","malleolum",sWebLanguage) %></td>
       				<td class='admin2' style="padding:0px;">
       					<table width='100%' cellspacing='0' cellpadding='0'>
       						<tr>
       							<%m = "MALLEO"; %>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"5_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"10_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"10_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"15_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"15_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"20_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_"+m+"20_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       			</tr>
				   		</table>
				   	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'></td>
       				<td class='admin2' style="padding:0px;">
       					<table width='100%' cellspacing='0' cellpadding='0'>
       						<tr>
			       				<td class='admin' width='12.5%'><center><%=getTran(request,"cnrkr","R",sWebLanguage) %></center></td>
			       				<td class='admin' width='12.5%'><center><%=getTran(request,"cnrkr","L",sWebLanguage) %></center></td>
			       				<td class='admin2' width='*'></td>
			       			</tr>
				   		</table>
				   	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'><%=getTran(request,"cnrkr","peri.hand",sWebLanguage) %></td>
       				<td class='admin2' style="padding:0px;">
       					<table width='100%' cellspacing='0' cellpadding='0'>
       						<tr>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_PERIHAND_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_PERIHAND_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='*'/>
			       			</tr>
				   		</table>
				   	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'><%=getTran(request,"cnrkr","peri.malleolum",sWebLanguage) %></td>
       				<td class='admin2' style="padding:0px;">
       					<table width='100%' cellspacing='0' cellpadding='0'>
       						<tr>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_PERIMALLEOLUM_R", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='12.5%'><center>
			  						<%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_PERIMALLEOLUM_L", 3, sWebLanguage, sCONTEXTPATH) %>
			       				</center></td>
			       				<td class='admin2' width='*'/>
			       			</tr>
				   		</table>
				   	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'><%=getTran(request,"web","comment",sWebLanguage) %></td>
       				<td class='admin2' style="padding:0px;">
       					<table width='100%' cellspacing='0' cellpadding='0'>
       						<tr>
			       				<td class='admin2'>
				   					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMAMEAS_COMMENT", 60, 1) %>
								</td>
			       			</tr>
				   		</table>
				   	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","oedema.type",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<table width='100%'>
       						<tr>
								<td width='30%'>
				   					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAOEDEMATYPE", "cnrkr.oedematype", sWebLanguage, "") %>
				   				</td>
				   				<td>
				   					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_CUTAOEDEMATYPETEXT", 30, 1) %>
				   				</td>
				   			</tr>
				   		</table>
				   	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","immobilisation",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<table width='100%'>
       						<tr>
								<td width='30%'>
				   					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTAIMMOBILISATION", "cnrkr.immobilisation", sWebLanguage, "") %>
				   				</td>
				   				<td>
				   					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_CUTAIMMOBILISATIONTEXT", 30, 1) %>
				   				</td>
				   			</tr>
				   		</table>
				   	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","contracture",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<table width='100%'>
       						<tr>
								<td width='30%'>
				   					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTACONTRACTURE", "cnrkr.yesno", sWebLanguage, "") %>
				   				</td>
				   				<td>
				   					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_CUTACONTRACTURETEXT", 30, 1) %>
				   				</td>
				   			</tr>
				   		</table>
				   	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","skincoloring",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<table width='100%'>
       						<tr>
								<td width='30%'>
				   					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTASKINCOLORING", "cnrkr.yesno", sWebLanguage, "") %>
				   				</td>
				   				<td>
				   					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_CUTASKINCOLORINGTEXT", 30, 1) %>
				   				</td>
				   			</tr>
				   		</table>
				   	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","localheat",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<table width='100%'>
       						<tr>
								<td width='30%'>
				   					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_CUTALOCALHEAT", "cnrkr.yesno", sWebLanguage, "") %>
				   				</td>
				   				<td>
				   					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_CUTALOCALHEATTEXT", 30, 1) %>
				   				</td>
				   			</tr>
				   		</table>
				   	</td>
				</tr>
			</table>
		</td>
       	<td id='keywordstd2' class="admin2" style="vertical-align:top;padding:0px;">
       		<div style="height:200px;overflow:auto" id="keywords2"></div>
       	</td>
	</tr>
</table>