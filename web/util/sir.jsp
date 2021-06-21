<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.*"%>
<%@page import="org.apache.commons.fileupload.servlet.*,java.util.*,java.io.*"%>
<%!
	class Node {
		String label="";
		HashSet<String> links = new HashSet<String>();
		int infectedIterations=0;
		int immunityIterations=0;
	}
%>
<%
	boolean bIterate=false;
	String action="";
	int iterationCounter=0;
	if(session.getAttribute("iterationCounter")!=null){
		iterationCounter=(Integer)session.getAttribute("iterationCounter");
	}
	String immuneArray="";
	if(session.getAttribute("immuneArray")!=null){
		immuneArray=(String)session.getAttribute("immuneArray");
	}
	int recoveryIterations=0;
	if(session.getAttribute("recoveryIterations")!=null){
		recoveryIterations=(Integer)session.getAttribute("recoveryIterations");
	}
	int immunityIterations=0;
	if(session.getAttribute("immunityIterations")!=null){
		immunityIterations=(Integer)session.getAttribute("immunityIterations");
	}
	double survivalScore=0;
	if(session.getAttribute("survivalScore")!=null){
		survivalScore=(Double)session.getAttribute("survivalScore");
	}
	double iterationScore=1;
	if(session.getAttribute("iterationScore")!=null){
		iterationScore=(Double)session.getAttribute("iterationScore");
	}
	SortedMap<String,Node> nodes = (SortedMap)session.getAttribute("nodes");
	SortedSet<String> newlyInfectedNodes = new TreeSet<String>();
	if(ServletFileUpload.isMultipartContent(request)){
		try{
		    FileItemFactory factory = new DiskFileItemFactory();
		    ServletFileUpload upload = new ServletFileUpload(factory);
		    List items = null;
		    try {
		        items = upload.parseRequest((HttpServletRequest)request);
	        } catch (FileUploadException e) {
	             e.printStackTrace();
	        }
		    Iterator itr = items.iterator();
		    while (itr.hasNext()) {
		        FileItem item = (FileItem) itr.next();
		        if (!item.isFormField()) {
		        	try {
		        		if(item.getFieldName().equalsIgnoreCase("filename")){
			            	nodes = new TreeMap<String,Node>();
		                    InputStream is = new ByteArrayInputStream(item.get());
		                    BufferedReader bfReader = new BufferedReader(new InputStreamReader(is));
		                    String line = null;
		                    bfReader.readLine();
		                    while((line = bfReader.readLine()) != null){
		                        String[] fields = line.split(",");
		                        String source = fields[0];
		                        String target = fields[1];
		                        String label = fields[4];
		                        if(nodes.get(source)==null){
		                        	nodes.put(source,new Node());
		                        }
		                        Node node = nodes.get(source);
		                        node.links.add(target);
		                        if(nodes.get(target)==null){
		                        	nodes.put(target,new Node());
		                        }
		                        node = nodes.get(target);
		                        node.links.add(source);
		                    }
		        			iterationCounter=0;
		        			session.setAttribute("iterationCounter", 0);
		        			immuneArray="";
		        			session.setAttribute("immuneArray", "");
		        			immuneArray="";
		        			if(nodes!=null){
		        				try{
		        					Iterator<String> inodes = nodes.keySet().iterator();
		        					while(inodes.hasNext()){
		        						String id = inodes.next();
		        						Node node = nodes.get(id);
		        						node.label="";
		        						node.immunityIterations=0;
		        						node.infectedIterations=0;
		        					}
		        				}
		        				catch(Exception e){
		        					e.printStackTrace();
		        				}
		        			}
		           		}
		            } catch (Exception e) {
		                 e.printStackTrace();
		            }
		        }
		    }
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	else if(nodes!=null && nodes.size()>0){
		action = request.getParameter("formaction")+"";
		if(action.equalsIgnoreCase("setInfected")){
			String nodeid = request.getParameter("setinfected")+"";
			if(nodes!=null){
				try{
					Iterator<String> inodes = nodes.keySet().iterator();
					while(inodes.hasNext()){
						String id = inodes.next();
						if(id.equals(nodeid)){
							Node node = nodes.get(id);
							if(!node.label.equalsIgnoreCase("infected")){
								node.label="infected";
								newlyInfectedNodes.add(id);
							}
						}
					}
				}
				catch(Exception e){
					e.printStackTrace();
				}
			}
		}
		else if(action.equalsIgnoreCase("setImmune")){
			String nodeid = request.getParameter("setimmune")+"";
			if(nodes!=null){
				try{
					Iterator<String> inodes = nodes.keySet().iterator();
					while(inodes.hasNext()){
						String id = inodes.next();
						if(id.equals(nodeid)){
							Node node = nodes.get(id);
							if(node.label.equalsIgnoreCase("")){
								bIterate=action.equalsIgnoreCase("setImmune") && request.getParameter("noAutoIterate")==null;
								node.label="immune";
								node.immunityIterations=0;
								if(immuneArray.length()>0){
									immuneArray+=", ";
								}
								immuneArray+=id;
								session.setAttribute("immuneArray", immuneArray);
							}
						}
					}
				}
				catch(Exception e){
					e.printStackTrace();
				}
			}
		}
		else if(action.equalsIgnoreCase("reset")){
			iterationCounter=0;
			session.setAttribute("iterationCounter", 0);
			immuneArray="";
			session.setAttribute("immuneArray", "");
			if(nodes!=null){
				try{
					Iterator<String> inodes = nodes.keySet().iterator();
					while(inodes.hasNext()){
						String id = inodes.next();
						Node node = nodes.get(id);
						node.label="";
						node.immunityIterations=0;
						node.infectedIterations=0;
					}
				}
				catch(Exception e){
					e.printStackTrace();
				}
			}
		}
		else if(action.equalsIgnoreCase("setTransmissionRate")){
			session.setAttribute("transmissionRate", Integer.parseInt(request.getParameter("transmissionRate")));
		}
		else if(action.equalsIgnoreCase("setRecoveryIterations")){
			session.setAttribute("recoveryIterations", Integer.parseInt(request.getParameter("recoveryIterations")));
			recoveryIterations=(Integer)session.getAttribute("recoveryIterations");
		}
		else if(action.equalsIgnoreCase("setImmunityIterations")){
			session.setAttribute("immunityIterations", Integer.parseInt(request.getParameter("immunityIterations")));
			immunityIterations=(Integer)session.getAttribute("immunityIterations");
		}
		else if(action.equalsIgnoreCase("setSurvivalScore")){
			session.setAttribute("survivalScore", Double.parseDouble(request.getParameter("survivalScore")));
			survivalScore=(Double)session.getAttribute("survivalScore");
		}
		else if(action.equalsIgnoreCase("setIterationScore")){
			session.setAttribute("iterationScore", Double.parseDouble(request.getParameter("iterationScore")));
			iterationScore=(Double)session.getAttribute("iterationScore");
		}
		else if(action.equalsIgnoreCase("setImmunityIterations")){
			session.setAttribute("immunityIterations", Integer.parseInt(request.getParameter("immunityIterations")));
			immunityIterations=(Integer)session.getAttribute("immunityIterations");
		}
		if(action.equalsIgnoreCase("iterate") || bIterate){
			try{
				int rate = 100;
				if(session.getAttribute("transmissionRate")!=null){
					rate=(Integer)session.getAttribute("transmissionRate");
				}
				iterationCounter++;
				session.setAttribute("iterationCounter", iterationCounter);
				HashSet<String> treatedNodes = new HashSet<String>();
				if(nodes!=null){
					Iterator<String> inodes = nodes.keySet().iterator();
					while(inodes.hasNext()){
						String id = inodes.next();
						Node node = nodes.get(id);
						if(!treatedNodes.contains(id)){
							if(node.label.equalsIgnoreCase("infected")){
								//try to infect all neigboours
								Iterator iLinks = node.links.iterator();
								while(iLinks.hasNext()){
									String link = (String)iLinks.next();
									if(!treatedNodes.contains(link)){
										Node linkedNode = nodes.get(link);
										if(linkedNode.label.equalsIgnoreCase("")){
											//This is a not yet infected neighbor. Try to infect.
											Random rand = new Random();
											int int_random = rand.nextInt(100);
											if(int_random<=rate){
												linkedNode.label="infected";
												treatedNodes.add(link);
												newlyInfectedNodes.add(link);
											}
										}
									}
								}
							}
						}
						if(node.label.equalsIgnoreCase("infected")){
							if(recoveryIterations>0){
								node.infectedIterations++;
								if(node.infectedIterations>recoveryIterations){
									node.infectedIterations=0;
									node.immunityIterations=0;
									node.label="immune";
								}
							}
						}
					}
					inodes = nodes.keySet().iterator();
					while(inodes.hasNext()){
						String id = inodes.next();
						Node node = nodes.get(id);
						if(node.label.equalsIgnoreCase("immune")){
							if(immunityIterations>0){
								node.immunityIterations++;
								if(node.immunityIterations>immunityIterations){
									node.immunityIterations=0;
									node.infectedIterations=0;
									node.label="";
								}
							}
						}
					}
				}
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
	}
	session.removeAttribute("nodes");
	if(nodes!=null){
		session.setAttribute("nodes", nodes);
	}
%>
<img width='450px' src="../_img/sirs.png"/><p/>
<form name='fileForm' method='post' enctype="multipart/form-data">
	<input size='50' style='border: solid' id='fileupload' name="filename" type="file" title=""/>
	<input type='submit' name='submitFile' value='Read model'/>
</form>
<% if(nodes!=null && nodes.size()>0){ %>
	<form name='transactionForm' id='transactionForm' method='post'>
		<input type='hidden' name='formaction' id='formaction'/>
		<table>
			<tr>
				<td valign='middle'>Set infected:</td>
				<td valign='middle'>
					<select name='setinfected'>
						<option/>
						<%
							try{
								if(nodes!=null){
									Iterator<String> inodes = nodes.keySet().iterator();
									while(inodes.hasNext()){
										String id = inodes.next();
										Node node = nodes.get(id);
										if(node.label.equalsIgnoreCase("")){
											out.println("<option value='"+id+"'>"+id+"</option>");
										}
									}
								}
							}
							catch(Exception e){
								e.printStackTrace();
							}
						%>
					</select>
					<input type='button' name='setInfectedButton' onclick='submitForm("setInfected")' value='Set'/>
					<input type='button' name='setInfectedButton' onclick='submitForm("reset")' value='Reset'/>
				</td>
			</tr>
			<tr>
				<td valign='middle'>Set transmission rate:</td>
				<td valign='middle'>
					<select name='transmissionRate' onchange='submitForm("setTransmissionRate")'>
						<option/>
						<%
							int rate = 100;
							if(session.getAttribute("transmissionRate")!=null){
								rate=(Integer)session.getAttribute("transmissionRate");
							}
							for(int n=1;n<=100;n++){
								out.println("<option value='"+n+"'"+(n==rate?" selected":"")+">"+n+"%</option>");
							}
						%>
					</select>
				</td>
			</tr>
			<tr>
				<td valign='middle'>Set recovery time (0=never):</td>
				<td valign='middle'>
					<select name='recoveryIterations' onchange='submitForm("setRecoveryIterations")'>
						<%
							for(int n=0;n<=100;n++){
								out.println("<option value='"+n+"'"+(n==recoveryIterations?" selected":"")+">"+n+"</option>");
							}
						%>
					</select> cycles
				</td>
			</tr>
			<tr>
				<td valign='middle'>Set immunity time (0=forever):</td>
				<td valign='middle'>
					<select name='immunityIterations' onchange='submitForm("setImmunityIterations")'>
						<%
							for(int n=0;n<=100;n++){
								out.println("<option value='"+n+"'"+(n==immunityIterations?" selected":"")+">"+n+"</option>");
							}
						%>
					</select> cycles
				</td>
			</tr>
			<tr>
				<td valign='middle'>Set protection score:</td>
				<td valign='middle'>
					<select name='survivalScore' onchange='submitForm("setSurvivalScore")'>
						<%
							for(double n=0;n<=5;n+=0.1){
								out.println("<option value='"+((double)Math.round(n*100)/100)+"'"+(((double)Math.round(n*100)/100)==survivalScore?" selected":"")+">"+((double)Math.round(n*100)/100)+"</option>");
							}
						%>
					</select> points
				</td>
			</tr>
			<tr>
				<td valign='middle'>Set iteration score:</td>
				<td valign='middle'>
					<select name='iterationScore' onchange='submitForm("setIterationScore")'>
						<%
							for(double n=0;n<=5;n+=0.1){
								out.println("<option value='"+((double)Math.round(n*100)/100)+"'"+(((double)Math.round(n*100)/100)==iterationScore?" selected":"")+">"+((double)Math.round(n*100)/100)+"</option>");
							}
						%>
					</select> points
				</td>
			</tr>
			<%
				int infected=0,immune=0,notinfected=0;
				try{
					if(nodes!=null){
						Iterator<String> inodes = nodes.keySet().iterator();
						while(inodes.hasNext()){
							String id = inodes.next();
							Node node = nodes.get(id);
							if(node.label.equalsIgnoreCase("infected")){
								infected++;
							}
							else if(node.label.equalsIgnoreCase("immune")){
								immune++;
							}
							else if(node.label.equalsIgnoreCase("")){
								notinfected++;
							}
						}
					}
				}
				catch(Exception e){
					e.printStackTrace();
				}
			%>
			<%		
				boolean disableIterate=infected==0 || (((action.equalsIgnoreCase("iterate")||bIterate) && newlyInfectedNodes.size()==0) && recoveryIterations==0 && immunityIterations==0);
			%>
			<tr><td colspan='2'><hr/></td></tr>
			<tr>
				<td valign='middle'>Set immune:</td>
				<td valign='middle'>
					<select name='setimmune'>
						<option/>
						<%
							boolean canImmunize=false;
							try{
								if(nodes!=null){
									Iterator<String> inodes = nodes.keySet().iterator();
									while(inodes.hasNext()){
										String id = inodes.next();
										Node node = nodes.get(id);
										if(node.label.equalsIgnoreCase("")){
											out.println("<option value='"+id+"'>"+id+"</option>");
											canImmunize=true;
										}
									}
								}
							}
							catch(Exception e){
								e.printStackTrace();
							}
						%>
					</select>
					<input type='button' <%=disableIterate||!canImmunize?"disabled":"" %> name='setImmuneButton' onclick='submitForm("setImmune")' value='Set'/>
					<input type='checkbox' name='noAutoIterate' value='1' <%=(request.getParameter("noAutoIterate")+"").equalsIgnoreCase("1")?"checked":"" %>/>No auto iterate
				</td>
			</tr>
			<tr>
				<td/>
				<td><%=immuneArray %></td>
			</tr>
			<tr>
				<td valign='middle'>Add infection iteration</td>
				<td valign='middle'><input type='button' <%=disableIterate?"disabled":"" %> name='iterateButton' onclick='submitForm("iterate")' value='Iterate'/> [n=<%=iterationCounter %> score=<b><%=(double)Math.round(100*(iterationCounter*iterationScore+(notinfected+immune)*survivalScore))/100 %></b>]</td>
			</tr>
			<tr><td colspan='2'><hr/></td></tr>
			<tr>
				<td colspan='2'>
					<table width='100%'>
						<tr>
							<td width='25%' valign='top'>
								<table width='100%' border='1'>
									<tr><td nowrap>Infected (<%=infected %> = <%=infected*100/nodes.size() %>%)</td></tr>
									<%
										try{
											if(nodes!=null){
												Iterator<String> inodes = nodes.keySet().iterator();
												while(inodes.hasNext()){
													String id = inodes.next();
													Node node = nodes.get(id);
													if(node.label.equalsIgnoreCase("infected")){
														out.println("<tr><td>"+id+"</td></tr>");
													}
												}
											}
										}
										catch(Exception e){
											e.printStackTrace();
										}
									%>
								</table>
							</td>
							<td width='25%' valign='top'>
								<table width='100%' border='1'>
									<tr><td nowrap>Newly infected (<%=newlyInfectedNodes.size() %> = <%=newlyInfectedNodes.size()*100/nodes.size() %>%)</td></tr>
									<%
										try{
											if(nodes!=null){
												Iterator<String> inodes = newlyInfectedNodes.iterator();
												while(inodes.hasNext()){
													String id = inodes.next();
													out.println("<tr><td style='background-color: red; color: white; font-weight: bolder'>"+id+"</td></tr>");
												}
											}
										}
										catch(Exception e){
											e.printStackTrace();
										}
									%>
								</table>
							</td>
							<td width='25%' valign='top'>
								<table width='100%' border='1'>
									<tr><td nowrap>Immune (<%=immune %> = <%=immune*100/nodes.size() %>%)</td></tr>
									<%
										try{
											if(nodes!=null){
												Iterator<String> inodes = nodes.keySet().iterator();
												while(inodes.hasNext()){
													String id = inodes.next();
													Node node = nodes.get(id);
													if(node.label.equalsIgnoreCase("immune")){
														out.println("<tr><td style='background-color: green; color: white; font-weight: bolder'>"+id+"</td></tr>");
													}
												}
											}
										}
										catch(Exception e){
											e.printStackTrace();
										}
									%>
								</table>
							</td>
							<td width='*' valign='top'>
								<table width='100%' border='1'>
									<tr><td nowrap>Not infected (<%=notinfected %> = <%=notinfected*100/nodes.size() %>%)</td></tr>
									<%
										try{
											if(nodes!=null){
												Iterator<String> inodes = nodes.keySet().iterator();
												while(inodes.hasNext()){
													String id = inodes.next();
													Node node = nodes.get(id);
													if(node.label.equalsIgnoreCase("")){
														out.println("<tr><td>"+id+"</td></tr>");
													}
												}
											}
										}
										catch(Exception e){
											e.printStackTrace();
										}
									%>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
<%} %>
<script>
	function submitForm(actionlabel){
		document.getElementById('formaction').value=actionlabel;
		document.getElementById('transactionForm').submit();
	}
</script>