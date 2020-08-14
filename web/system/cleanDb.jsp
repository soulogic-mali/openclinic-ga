<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%!
	public boolean viewExists(Element root, String table, String db){
		Iterator i = root.elementIterator("view");
		while(i.hasNext()){
			Element t = (Element)i.next();
			if(t.attributeValue("db").equalsIgnoreCase(db) && t.attributeValue("name").equalsIgnoreCase(table)){
				return true;
			}
		}
		return false;
	}
	public boolean tableExists(Element root, String table, String db){
		Iterator i = root.elementIterator("table");
		while(i.hasNext()){
			Element t = (Element)i.next();
			if(t.attributeValue("db").equalsIgnoreCase(db) && t.attributeValue("name").equalsIgnoreCase(table)){
				return true;
			}
		}
		return false;
	}
	public boolean indexExists(Element root, String table, String index, String db){
		Iterator i = root.elementIterator("table");
		while(i.hasNext()){
			Element t = (Element)i.next();
			if(t.attributeValue("db").equalsIgnoreCase(db) && t.attributeValue("name").equalsIgnoreCase(table)){
				if(t.element("indexes")!=null){
					Iterator j = t.element("indexes").elementIterator("index");
					while(j.hasNext()){
						Element in = (Element)j.next();
						if(in.attributeValue("name").equalsIgnoreCase(index)){
							return true;
						}
					}
				}
			}
		}
		return false;
	}
%>
<%
	if(request.getParameter("submit")!=null){
		Enumeration parameters = request.getParameterNames();
		while(parameters.hasMoreElements()){
			String parameter = (String)parameters.nextElement();
			if(parameter.startsWith("droptable")){
				String database=parameter.split("\\$")[1];
				String table =parameter.split("\\$")[2];
				Connection conn = null;
				if(database.equalsIgnoreCase("admin")){
					conn=MedwanQuery.getInstance().getAdminConnection();
				}
				else if(database.equalsIgnoreCase("openclinic")){
					conn=MedwanQuery.getInstance().getOpenclinicConnection();
				}
				Statement st = conn.createStatement();
				st.execute("drop table "+table);
				st.close();
				conn.close();
			}
			else if(parameter.startsWith("dropview")){
				String database=parameter.split("\\$")[1];
				String table =parameter.split("\\$")[2];
				Connection conn = null;
				if(database.equalsIgnoreCase("admin")){
					conn=MedwanQuery.getInstance().getAdminConnection();
				}
				else if(database.equalsIgnoreCase("openclinic")){
					conn=MedwanQuery.getInstance().getOpenclinicConnection();
				}
				Statement st = conn.createStatement();
				st.execute("drop view "+table);
				st.close();
				conn.close();
			}
			else if(parameter.startsWith("dropindex")){
				String database=parameter.split("\\$")[1];
				String table =parameter.split("\\$")[2];
				String index =parameter.split("\\$")[3];
				Connection conn = null;
				if(database.equalsIgnoreCase("admin")){
					conn=MedwanQuery.getInstance().getAdminConnection();
				}
				else if(database.equalsIgnoreCase("openclinic")){
					conn=MedwanQuery.getInstance().getOpenclinicConnection();
				}
				Statement st = conn.createStatement();
				st.execute("drop index "+index+" on "+table);
				st.close();
				conn.close();
			}
		}
	}
%>
<form name='transactionForm' method='post'>
	<table>
		<tr class='admin'>
			<td><%=getTran(request,"web","database",sWebLanguage) %></td>
			<td><%=getTran(request,"web","objectname",sWebLanguage) %></td>
			<td><%=getTran(request,"web","dropobject",sWebLanguage) %></td>
		</tr>
	<%
		HashSet indexes = new HashSet();
		SAXReader reader = new SAXReader(false);
		String sDoc = MedwanQuery.getInstance().getConfigString("templateSource","http://localhost/openclinic/_common/xml/")+"db.xml";
		Document document = reader.read(new URL(sDoc));
		Element root = document.getRootElement();
		Connection conn = MedwanQuery.getInstance().getAdminConnection();
		ResultSet rs = conn.getMetaData().getTables(null,null,"%",null);
		while(rs.next()){
			String tablename = rs.getString("TABLE_NAME").toUpperCase();
			String tabletype = rs.getString("TABLE_TYPE");
			if(tabletype.equalsIgnoreCase("table") && !tableExists(root,tablename,"ocadmin")){
				out.println("<tr><td>"+MedwanQuery.getInstance().getConfigString("admindbName","?admin?")+"</td><td><font color='red'>TABLE "+tablename+"</font></td><td><input type='checkbox' name='droptable$admin$"+tablename+"' checked/></td></tr>");
			}
			else if(tabletype.equalsIgnoreCase("view") && !viewExists(root,tablename,"ocadmin")){
				out.println("<tr><td>"+MedwanQuery.getInstance().getConfigString("admindbName","?admin?")+"</td><td><font color='red'>VIEW "+tablename+"</font></td><td><input type='checkbox' name='dropview$admin$"+tablename+"' checked/></td></tr>");
			}
			else if(tabletype.equalsIgnoreCase("table")){
				ResultSet rs2 = conn.getMetaData().getIndexInfo(null, null, tablename, false, false);	
				while(rs2.next()){
					String indexname=rs2.getString("INDEX_NAME");
					if(indexname!=null){
						indexname=indexname.toUpperCase();
						if(!indexes.contains("admin."+tablename+"."+indexname) && !indexExists(root,tablename,indexname,"ocadmin")){
							out.println("<tr><td>"+MedwanQuery.getInstance().getConfigString("admindbName","?admin?")+"</td><td>INDEX "+tablename+"."+indexname+"</td><td><input type='checkbox' name='dropindex$admin$"+tablename+"$"+indexname+"' checked/></td></tr>");
							indexes.add("admin."+tablename+"."+indexname);
						}
					}
				}
			}
		}
		rs.close();
		conn = MedwanQuery.getInstance().getOpenclinicConnection();
		rs = conn.getMetaData().getTables(null,null,"%",null);
		while(rs.next()){
			String tablename = rs.getString("TABLE_NAME").toUpperCase();
			String tabletype = rs.getString("TABLE_TYPE");
			if(tabletype.equalsIgnoreCase("table") && !tableExists(root,tablename,"openclinic")){
				String checked="checked";
				String[] excludeTables = MedwanQuery.getInstance().getConfigString("excludeTablesFromClean","oc_config").split(",");
				for(int n=0;n<excludeTables.length;n++){
					if(tablename.indexOf(excludeTables[n].toUpperCase())>-1){
						checked="";
						break;
					}
				}
				out.println("<tr><td>"+MedwanQuery.getInstance().getConfigString("openclinicdbName","?openclinic?")+"</td><td><font color='red'>TABLE "+tablename+"</font></td><td><input type='checkbox' name='droptable$openclinic$"+tablename+"' "+checked+"/></td></tr>");
			}
			else if(tabletype.equalsIgnoreCase("view") && !viewExists(root,tablename,"openclinic")){
				out.println("<tr><td>"+MedwanQuery.getInstance().getConfigString("openclinicdbName","?openclinic?")+"</td><td><font color='red'>VIEW "+tablename+"</font></td><td><input type='checkbox' name='dropview$openclinic$"+tablename+"' checked/></td></tr>");
			}
			else if(tabletype.equalsIgnoreCase("table")){
				ResultSet rs2 = conn.getMetaData().getIndexInfo(null, null, tablename, false, false);	
				while(rs2.next()){
					String indexname=rs2.getString("INDEX_NAME");
					if(indexname!=null){
						indexname=indexname.toUpperCase();
						if(!indexes.contains("openclinic."+tablename+"."+indexname) && !indexExists(root,tablename,indexname,"openclinic")){
							String checked="checked";
							String[] excludeTables = MedwanQuery.getInstance().getConfigString("excludeTablesFromClean","oc_config").split(",");
							for(int n=0;n<excludeTables.length;n++){
								if(tablename.indexOf(excludeTables[n].toUpperCase())>-1){
									checked="";
									break;
								}
							}
							out.println("<tr><td>"+MedwanQuery.getInstance().getConfigString("openclinicdbName","?openclinic?")+"</td><td>INDEX "+tablename+"."+indexname+"</td><td><input type='checkbox' name='dropindex$openclinic$"+tablename+"$"+indexname+"' "+checked+"/></td></tr>");
							indexes.add("openclinic."+tablename+"."+indexname);
						}
					}
				}
			}
		}
		rs.close();
	%>
	</table>
	<input type='submit' name='submit' value='<%=getTran(null,"web","execute",sWebLanguage) %>'/>
	<input type='submit' name='reload' value='<%=getTran(null,"web","reload",sWebLanguage) %>'/>
</form>