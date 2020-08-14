<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin2' width='70%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr>
					<td class='admin2' colspan='2' style="vertical-align:top;padding:0px;">
						<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
								<td class='admin'><%=getTran(request,"cnrkr","tonus",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_TONUS", "cnrkr.neuroadult.tonus", sWebLanguage, "") %></td>
							</tr>
							<tr>
								<td class='admin'><%=getTran(request,"cnrkr","spaciality",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_SPACIALITY", "cnrkr.gooddisturbed", sWebLanguage, "") %></td>
							</tr>
							<tr>
								<td class='admin'><%=getTran(request,"cnrkr","temporality",sWebLanguage) %></td>
								<td class='admin2' colspan='6'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_TEMPORALITE", "cnrkr.gooddisturbed", sWebLanguage, "") %></td>
							</tr>
							<tr>
								<td class='admin'><%=getTran(request,"cnrkr","intensity.globalforce.inferior",sWebLanguage) %></td>
								<td class='admin2'>
									<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_INTENSITY", sWebLanguage, "", 0,5) %>
									&nbsp;&nbsp;<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_INTENSITYTEXT", 30, 1) %>
								</td>
							</tr>
							<tr>
								<td class='admin' width='1%' nowrap><%=getTran(request,"cnrkr","intensity.globalforce.superior",sWebLanguage) %></td>
								<td class='admin2'>
									<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_INTENSITY_SUPERIOR", sWebLanguage, "", 0,5) %>
									&nbsp;&nbsp;<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_INTENSITYTEXT_SUPERIOR", 30, 1) %>
								</td>
							</tr>
							<tr class='admin'>
								<td colspan='2'><%=getTran(request,"cnrkr","voluntary.motricity",sWebLanguage)%></td>
							</tr>
							<tr class='admin'>
								<td colspan='2'><%=getTran(request,"cnrkr","intensitytesting",sWebLanguage) %></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class='admin2' colspan='2' style="vertical-align:top;padding:0px;">
						<table width='100%' cellspacing='1' cellpadding='0'>
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
									<img id='img_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_UPPERRIGHT' id='img_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_UPPERRIGHT' onload='this.onplay()' onplay='showDivValues("ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_UPPERRIGHT","musscle.upperright")' src='<%=sCONTEXTPATH %>/_img/icons/icon_plus.png' onclick='addDivValue("ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_UPPERRIGHT","musscle.upperright","musscle.upperright.value")'/>
									<%=ScreenHelper.writeDefaultHiddenInput((TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_UPPERRIGHT") %>
									<span id='div_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_UPPERRIGHT'></span>
								</td>
								<td colspan='2'>
									<select id='musscle.upperleft' class='text'>
										<%=ScreenHelper.writeSelect(request, "cnrkr.muscles.upper", "", sWebLanguage) %>
									</select>
									<br/>
									<select id='musscle.upperleft.value' class='text'>
										<%=ScreenHelper.writeSelect(request, "cnrkr.muscles.values", "", sWebLanguage) %>
									</select>
									<img id='img_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_UPPERLEFT' onload='this.onplay()' onplay='showDivValues("ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_UPPERLEFT","musscle.upperleft")' src='<%=sCONTEXTPATH %>/_img/icons/icon_plus.png' onclick='addDivValue("ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_UPPERLEFT","musscle.upperleft","musscle.upperleft.value")'/>
									<%=ScreenHelper.writeDefaultHiddenInput((TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_UPPERLEFT") %>
									<span id='div_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_UPPERLEFT'></span>
								</td>
								<td colspan='2'>
									<select id='musscle.lowerright' class='text'>
										<%=ScreenHelper.writeSelect(request, "cnrkr.muscles.lower", "", sWebLanguage) %>
									</select>
									<br/>
									<select id='musscle.lowerright.value' class='text'>
										<%=ScreenHelper.writeSelect(request, "cnrkr.muscles.values", "", sWebLanguage) %>
									</select>
									<img id='img_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_LOWERRIGHT' onload='this.onplay()' onplay='showDivValues("ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_LOWERRIGHT","musscle.lowerright")' src='<%=sCONTEXTPATH %>/_img/icons/icon_plus.png' onclick='addDivValue("ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_LOWERRIGHT","musscle.lowerright","musscle.lowerright.value")'/>
									<%=ScreenHelper.writeDefaultHiddenInput((TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_LOWERRIGHT") %>
									<span id='div_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_LOWERRIGHT'></span>
								</td>
								<td colspan='2'>
									<select id='musscle.lowerleft' class='text'>
										<%=ScreenHelper.writeSelect(request, "cnrkr.muscles.lower", "", sWebLanguage) %>
									</select>
									<br/>
									<select id='musscle.lowerleft.value' class='text'>
										<%=ScreenHelper.writeSelect(request, "cnrkr.muscles.values", "", sWebLanguage) %>
									</select>
									<img id='img_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_LOWERLEFT' onload='this.onplay()' onplay='showDivValues("ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_LOWERLEFT","musscle.lowerleft")' src='<%=sCONTEXTPATH %>/_img/icons/icon_plus.png' onclick='addDivValue("ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_LOWERLEFT","musscle.lowerleft","musscle.lowerleft.value")'/>
									<%=ScreenHelper.writeDefaultHiddenInput((TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_LOWERLEFT") %>
									<span id='div_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_LOWERLEFT'></span>
								</td>
								<td colspan='2'>
									<select id='musscle.trunc' class='text'>
										<%=ScreenHelper.writeSelect(request, "cnrkr.muscles.trunc", "", sWebLanguage) %>
									</select>
									<br/>
									<select id='musscle.trunc.value' class='text'>
										<%=ScreenHelper.writeSelect(request, "cnrkr.muscles.values", "", sWebLanguage) %>
									</select>
									<img id='img_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_TRUNC' onload='this.onplay()' onplay='showDivValues("ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_TRUNC","musscle.trunc");' src='<%=sCONTEXTPATH %>/_img/icons/icon_plus.png' onclick='addDivValue("ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_TRUNC","musscle.trunc","musscle.trunc.value")'/>
									<%=ScreenHelper.writeDefaultHiddenInput((TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_TRUNC") %>
									<span id='div_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCTESTING_TRUNC'></span>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class='admin2' colspan='2' style="vertical-align:top;padding:0px;">
						<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
			       				<td class='admin' width='15%'>
			       					<%=getTran(request,"cnrkr","comment",sWebLanguage)%>
			       				</td>
			       				<td class='admin2'>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MUSCCOMMENT", 80, 1)%>
						       	</td>
						    </tr>
							<tr>
			       				<td class='admin' width='15%'>
			       					<%=getTran(request,"cnrkr","coordination",sWebLanguage)%>
			       				</td>
			       				<td class='admin2'>
			       					<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.checkboxes","ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROLOGYADULT_COORDINATION", sWebLanguage,true)%>
			       					&nbsp;&nbsp;<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROLOGYADULT_COORDINATIONTEXT", 40, 1)%>
						       	</td>
						    </tr>
							<tr>
			       				<td class='admin' width='15%'>
			       					<%=getTran(request,"cnrkr","endurance",sWebLanguage)%>
			       				</td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_ENDURANCE", "cnrkr.gooddisturbed", sWebLanguage, "") %></td>
						    </tr>
						</table>
					</td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","automated.motricity",sWebLanguage)%></td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","stato.kinetics",sWebLanguage)%></td>
				</tr>
				<tr>
       				<td class='admin' width='15%'>
       					<%=getTran(request,"cnrkr","indexdeviation",sWebLanguage)%>
       				</td>
					<td class='admin2' style="vertical-align:top;padding:0px;">
						<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
			       				<td class='admin2' width='1%'>
			       					<%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROLOGYADULT_INDEXDEVIATION", "cnrkr.posneg", sWebLanguage,"")%>
						       	</td>
			       				<td class='admin2'>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROLOGYADULT_INDEXDEVIATIONTEXT", 40, 1)%>
						       	</td>
						    </tr>
						</table>
					</td>
			    </tr>
				<tr>
       				<td class='admin' width='15%'>
       					<%=getTran(request,"cnrkr","fukuda",sWebLanguage)%>
       				</td>
					<td class='admin2' style="vertical-align:top;padding:0px;">
						<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
			       				<td class='admin2' width='1%'>
			       					<%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROLOGYADULT_FUKUDA", "cnrkr.posneg", sWebLanguage,"")%>
						       	</td>
			       				<td class='admin2'>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROLOGYADULT_FUKUDATEXT", 40, 1)%>
						       	</td>
						    </tr>
						</table>
					</td>
			    </tr>
				<tr>
       				<td class='admin' width='15%'>
       					<%=getTran(request,"cnrkr","blindwalk",sWebLanguage)%>
       				</td>
					<td class='admin2' style="vertical-align:top;padding:0px;">
						<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
			       				<td class='admin2' width='1%'>
			       					<%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROLOGYADULT_BLINDWALK", "cnrkr.posneg", sWebLanguage,"")%>
						       	</td>
			       				<td class='admin2'>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROLOGYADULT_BLINDWALKTEXT", 40, 1)%>
						       	</td>
						    </tr>
						</table>
					</td>
			    </tr>
				<tr>
       				<td class='admin' width='15%'>
       					<%=getTran(request,"cnrkr","romberg",sWebLanguage)%>
       				</td>
					<td class='admin2' style="vertical-align:top;padding:0px;">
						<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
			       				<td class='admin2' width='1%'>
			       					<%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROLOGYADULT_ROMBERG", "cnrkr.posneg", sWebLanguage,"")%>
						       	</td>
			       				<td class='admin2'>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROLOGYADULT_ROMBERGTEXT", 40, 1)%>
						       	</td>
						    </tr>
						</table>
					</td>
			    </tr>
				<tr>
       				<td class='admin' width='15%'>
       					<%=getTran(request,"cnrkr","other",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROLOGYADULT_MOTRICITY_COMMENT", 80, 1)%>
			       	</td>
			    </tr>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","sitting",sWebLanguage)%></td>
				</tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","stability",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROLOGYADULT_STABILITY", "cnrkr.goodbad", sWebLanguage,"")%></td>
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","support",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROLOGYADULT_SUPPORT", "cnrkr.yesno", sWebLanguage,"")%></td>
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","retropulsion",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROLOGYADULT_RETROPULSION", "cnrkr.yesno", sWebLanguage,"")%></td>
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","lateropulsionleft",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROLOGYADULT_LATEROPULSIONLEFT", "cnrkr.yesno", sWebLanguage,"")%></td>
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","lateropulsionright",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROLOGYADULT_LATEROPULSIONRIGHT", "cnrkr.yesno", sWebLanguage,"")%></td>
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","intrinsictolerance",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROLOGYADULT_INTRINSICTOLERANCE", "cnrkr.yesno", sWebLanguage,"")%></td>
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","extrinsictolerance",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROLOGYADULT_EXTRINSICTOLERANCE", "cnrkr.yesno", sWebLanguage,"")%></td>
			    </tr>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","standing",sWebLanguage)%></td>
				</tr>
				<tr>
					<td class='admin' width='15%'>
						<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_SPONTANEOUSATTITUDE"><%=getTran(request,"cnrkr","spontaneous.attitude",sWebLanguage)%></div>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_SPONTANEOUSATTITUDE", "cnrkr.spontaneous.attitude", "keywords5", sCONTEXTPATH, sWebLanguage,request) %>
			      	</td>
				</tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","tandemposition",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction,request, "cnrkr.rightleft","ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROLOGYADULT_TANDEMPOSITION",  sWebLanguage,true)%></td>
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","monopodalsupprt",sWebLanguage)%></td>
					<td class='admin2'>
						<%=getTran(request,"web","left",sWebLanguage) %>:<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROLOGYADULT_MONOPODALLEFT", 3, sWebLanguage) %> sec
						&nbsp;&nbsp;&nbsp;<%=getTran(request,"web","right",sWebLanguage) %>:<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROLOGYADULT_MONOPODALRIGHT", 3, sWebLanguage) %> sec
					</td>
			    </tr>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","reflexmotricity",sWebLanguage)%></td>
				</tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","ROT",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_ROT", 60, 1)%></td>
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","RCP",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_RCP", 60, 1)%></td>
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","clonus",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_CLONUS", 60, 1)%></td>
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","tripleretreat",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_TRIPLERETREAT", 60, 1)%></td>
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","other",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_REFLEX_OTHER", 60, 1)%></td>
			    </tr>
			</table>
		</td>
    	<td width="30%" id='keywordstd5' class="admin2" style="vertical-align:top;padding:0px;">
    		<div style="height:200px;overflow:auto;" id="keywords5"></div>
    	</td>
    	<td>
			<div style="height:200px;overflow:auto;"/>
    	</td>
	</tr>
</table>