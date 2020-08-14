<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='0' cellpadding='0'>
	<tr>
		<td class='admin2' width='100%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr class='admin'>
       				<td colspan='2'>
       					<center><%=getTran(request,"cnrkr","muscular.extensibility",sWebLanguage)%></center>
       				</td>
				</tr>
				<tr>
					<td class='admin'/>
					<td class='admin'>
						<table width='100%'><tr>
							<td class='admin' width='50%'><%=getTran(request,"web","right",sWebLanguage) %></td>
							<td class='admin'><%=getTran(request,"web","left",sWebLanguage) %></td>
						</tr></table>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","ischio.legs",sWebLanguage) %></td>
					<td>
						<table width='100%'><tr>
							<td class='admin2' width='50%'>
								<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCEXTISCHLEG",  sWebLanguage, "",0,180) %> °
							</td>
							<td class='admin2'>
								<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCEXTISCHLEG_LEFT",  sWebLanguage, "",0,180) %> °
							</td>
						</tr></table>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","iliopsoas",sWebLanguage) %></td>
					<td>
						<table width='100%'><tr>
							<td class='admin2' width='50%'>
								<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCEXTILIOPSOAS",  sWebLanguage, "",0,180) %> °
							</td>
							<td class='admin2'>
								<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCEXTILIOPSOAS_LEFT",  sWebLanguage, "",0,180) %> °
							</td>
						</tr></table>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","fascialata",sWebLanguage) %></td>
					<td>
						<table width='100%'><tr>
							<td class='admin2' width='50%'>
								<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCEXTFASCIALATA", "cnrkr.posneg", sWebLanguage, "") %>
							</td>
							<td class='admin2'>
								<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCEXTFASCIALATA_LEFT", "cnrkr.posneg", sWebLanguage, "") %>
							</td>
						</tr></table>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","femoralright",sWebLanguage) %></td>
					<td>
						<table width='100%'><tr>
							<td class='admin2' width='50%'>
								<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCEXTFEMORALRIGHT",  sWebLanguage, "",0,180) %> °
							</td>
							<td class='admin2'>
								<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCEXTFEMORALRIGHT_LEFT",  sWebLanguage, "",0,180) %> °
							</td>
						</tr></table>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","piriformis",sWebLanguage) %></td>
					<td>
						<table width='100%'><tr>
							<td class='admin2' width='50%'>
								<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCEXTPIRIFORMIS", "cnrkr.pririformis",  sWebLanguage, "") %>
							</td>
							<td class='admin2'>
								<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCEXTPIRIFORMIS_LEFT", "cnrkr.pririformis",  sWebLanguage, "") %>
							</td>
						</tr></table>
					</td>
				</tr>
				<tr>
       				<td class='admin'>
       					<%=getTran(request,"cnrkr","othermuscles",sWebLanguage)%>
       				</td>
					<td>
						<table width='100%'><tr>
							<td class='admin2' width='50%'>
		       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCEXTOTHER", 30, 1)%>
					       	</td>
		       				<td class='admin2'>
		       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCEXTOTHER_LEFT", 30, 1)%>
					       	</td>
						</tr></table>
					</td>
			    </tr>
				<tr>
       				<td class='admin'>
       					<%=getTran(request,"web","comment",sWebLanguage)%>
       				</td>
					<td class='admin2'>
       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_COMMENT", 30, 1)%>
			       	</td>
			    </tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class='admin2' colspan='2' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='0' cellpadding='0'>
				<tr class='admin'>
       				<td colspan='10'>
       					<center><%=getTran(request,"cnrkr","musculartest",sWebLanguage)%></center>
       				</td>
				</tr>
				<tr>
       				<td colspan='2' class='admin' width='20%'>
       					<center><%=getTran(request,"cnrkr","extremity.upperright",sWebLanguage)%></center>
       				</td>
       				<td colspan='2' class='admin'>
       					<center><%=getTran(request,"cnrkr","extremity.upperleft",sWebLanguage)%></center>
       				</td>
       				<td colspan='2' class='admin'>
       					<center><%=getTran(request,"cnrkr","extremity.lowerright",sWebLanguage)%></center>
       				</td>
       				<td colspan='2' class='admin'>
       					<center><%=getTran(request,"cnrkr","extremity.lowerleft",sWebLanguage)%></center>
       				</td>
       				<td colspan='2' class='admin'>
       					<center><%=getTran(request,"cnrkr","trunc",sWebLanguage)%></center>
       				</td>
				</tr>
				<tr style="vertical-align:top;padding:0px;">
					<td  colspan='2'>
						<select id='musscle.upperright' class='text'>
							<%=ScreenHelper.writeSelect(request, "cnrkr.muscles.upper", "", sWebLanguage) %>
						</select>
						<br/>
						<select id='musscle.upperright.value' class='text'>
							<%=ScreenHelper.writeSelect(request, "cnrkr.muscles.values", "", sWebLanguage) %>
						</select>
						<img id='img_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_UPPERRIGHT' onload='this.onplay()' onplay='showDivValues("ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_UPPERRIGHT","musscle.upperright")' src='<%=sCONTEXTPATH %>/_img/icons/icon_plus.png' onclick='addDivValue("ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_UPPERRIGHT","musscle.upperright","musscle.upperright.value")'/>
						<%=ScreenHelper.writeDefaultHiddenInput((TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_UPPERRIGHT") %>
						<span id='div_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_UPPERRIGHT'></span>
					</td>
					<td colspan='2'>
						<select id='musscle.upperleft' class='text'>
							<%=ScreenHelper.writeSelect(request, "cnrkr.muscles.upper", "", sWebLanguage) %>
						</select>
						<br/>
						<select id='musscle.upperleft.value' class='text'>
							<%=ScreenHelper.writeSelect(request, "cnrkr.muscles.values", "", sWebLanguage) %>
						</select>
						<img id='img_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_UPPERLEFT' onload='this.onplay()' onplay='showDivValues("ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_UPPERLEFT","musscle.upperleft")' src='<%=sCONTEXTPATH %>/_img/icons/icon_plus.png' onclick='addDivValue("ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_UPPERLEFT","musscle.upperleft","musscle.upperleft.value")'/>
						<%=ScreenHelper.writeDefaultHiddenInput((TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_UPPERLEFT") %>
						<span id='div_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_UPPERLEFT'></span>
					</td>
					<td colspan='2'>
						<select id='musscle.lowerright' class='text'>
							<%=ScreenHelper.writeSelect(request, "cnrkr.muscles.lower", "", sWebLanguage) %>
						</select>
						<br/>
						<select id='musscle.lowerright.value' class='text'>
							<%=ScreenHelper.writeSelect(request, "cnrkr.muscles.values", "", sWebLanguage) %>
						</select>
						<img id='img_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_LOWERRIGHT' onload='this.onplay()' onplay='showDivValues("ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_LOWERRIGHT","musscle.lowerright")' src='<%=sCONTEXTPATH %>/_img/icons/icon_plus.png' onclick='addDivValue("ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_LOWERRIGHT","musscle.lowerright","musscle.lowerright.value")'/>
						<%=ScreenHelper.writeDefaultHiddenInput((TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_LOWERRIGHT") %>
						<span id='div_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_LOWERRIGHT'></span>
					</td>
					<td colspan='2'>
						<select id='musscle.lowerleft' class='text'>
							<%=ScreenHelper.writeSelect(request, "cnrkr.muscles.lower", "", sWebLanguage) %>
						</select>
						<br/>
						<select id='musscle.lowerleft.value' class='text'>
							<%=ScreenHelper.writeSelect(request, "cnrkr.muscles.values", "", sWebLanguage) %>
						</select>
						<img id='img_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_LOWERLEFT' onload='this.onplay()' onplay='showDivValues("ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_LOWERLEFT","musscle.lowerleft")' src='<%=sCONTEXTPATH %>/_img/icons/icon_plus.png' onclick='addDivValue("ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_LOWERLEFT","musscle.lowerleft","musscle.lowerleft.value")'/>
						<%=ScreenHelper.writeDefaultHiddenInput((TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_LOWERLEFT") %>
						<span id='div_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_LOWERLEFT'></span>
					</td>
					<td colspan='2'>
						<select id='musscle.trunc' class='text'>
							<%=ScreenHelper.writeSelect(request, "cnrkr.muscles.trunc", "", sWebLanguage) %>
						</select>
						<br/>
						<select id='musscle.trunc.value' class='text'>
							<%=ScreenHelper.writeSelect(request, "cnrkr.muscles.values", "", sWebLanguage) %>
						</select>
						<img id='img_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_TRUNC' onload='this.onplay()' onplay='showDivValues("ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_TRUNC","musscle.trunc");' src='<%=sCONTEXTPATH %>/_img/icons/icon_plus.png' onclick='addDivValue("ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_TRUNC","musscle.trunc","musscle.trunc.value")'/>
						<%=ScreenHelper.writeDefaultHiddenInput((TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_TRUNC") %>
						<span id='div_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCTESTING_TRUNC'></span>
					</td>
				</tr>
				<tr>
       				<td class='admin' colspan='2'>
       					<%=getTran(request,"cnrkr","comment",sWebLanguage)%>
       				</td>
       				<td class='admin2' colspan='8'>
       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_MUSCCOMMENT", 80, 1)%>
			       	</td>
			    </tr>
			</table>
		</td>
	</tr>
</table>