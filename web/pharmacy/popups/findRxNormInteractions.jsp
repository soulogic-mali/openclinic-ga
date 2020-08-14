<%@ page import="java.io.*,org.dom4j.*,org.dom4j.io.*,sun.misc.*,be.mxs.common.util.io.*,org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*,be.mxs.common.util.db.*,be.mxs.common.util.system.*,be.openclinic.finance.*,net.admin.*,java.util.*,java.text.*,be.openclinic.adt.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	private SortedMap getRxNormInteractions(String sKey){
		TreeMap codes = new TreeMap();
		try{
			HttpClient client = new HttpClient();
			String[] keys = sKey.split(";");
			for(int n=0;n<keys.length;n++){
				Hashtable rxcuis = new Hashtable();
				String url = MedwanQuery.getInstance().getConfigString("NLM_DDI_URL_FindRxNormInteraction","http://rxnav.nlm.nih.gov/REST/interaction/interaction.xml");
				GetMethod method = new GetMethod(url);
				method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
				NameValuePair nvp1= new NameValuePair("rxcui",keys[0]);
				method.setQueryString(new NameValuePair[]{nvp1});
				int statusCode = client.executeMethod(method);
				BufferedReader br = new BufferedReader(new StringReader(method.getResponseBodyAsString()));
				SAXReader reader=new SAXReader(false);
				org.dom4j.Document document=reader.read(br);
				Element root = document.getRootElement();
				if(root.getName().equalsIgnoreCase("interactiondata")){
					Element interactionTypeGroup=root.element("interactionTypeGroup");
					if(interactionTypeGroup!=null){
						Element interactionType=interactionTypeGroup.element("interactionType");
						Iterator interactionPairs = interactionType.elementIterator("interactionPair");
						while(interactionPairs.hasNext()){
							Element interactionPair=(Element)interactionPairs.next();
							String drugcodes="";
							String druginteractions="";
							Iterator interactionConcepts=interactionPair.elementIterator("interactionConcept");
							while(interactionConcepts.hasNext()){
								Element interactionConcept = (Element)interactionConcepts.next();
								if(interactionConcept.element("sourceConceptItem")!=null){
									Element sourceConceptItem=interactionConcept.element("sourceConceptItem");
									drugcodes+=sourceConceptItem.elementText("id")+";";
									if(druginteractions.length()>0){
										druginteractions+=", ";
									}
									druginteractions+=sourceConceptItem.elementText("name");
								}
							}
							codes.put(drugcodes,druginteractions+";"+interactionPair.elementText("description"));
						}
					}
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return codes;
	}
%>
<%
	String key=checkString(request.getParameter("key"));
	if(key.length()==0 && request.getParameter("submit")==null){
		key=checkString(request.getParameter("initkey"));
	}
%>
<form name="transactionForm" method="post">
	<input type='text' class='text' size='80' name='key' value='<%=key%>'/>
	<input type='submit' name='dosubmit' value='<%=getTran(null,"web","find",sWebLanguage) %>'/>
	&nbsp;&nbsp;&nbsp;&nbsp;
	<input type='checkbox' name='cbtranslate' value='1' <%=checkString(request.getParameter("cbtranslate")).equalsIgnoreCase("1")?"checked":"" %> onchange='transactionForm.submit();'/><%=getTran(request,"web.language",sWebLanguage,sWebLanguage) %>
	
	<table width="100%">
		<tr class='admin'>
			<td width='25%'><%=getTran(request,"web","drugnames",sWebLanguage) %></td>
			<td><%=getTran(request,"web","interaction",sWebLanguage) %></td>
		</tr>
	<%
		SortedMap codes=getRxNormInteractions(key);
		Iterator i = codes.keySet().iterator();
		int counter=0;
		while(i.hasNext()){
			String drugcodes=(String)i.next();
			String code = (String)codes.get(drugcodes);
			%>
			<tr>
				<td class='admin'><%=code.split(";")[0]%></td>
				<td class='admin2' valign='top'><%=Translate.translate("en",checkString(request.getParameter("cbtranslate")).equalsIgnoreCase("1")?sWebLanguage:"en",code.split(";")[1])%></td>
			</tr>
			
			<%	
			counter++;
		}
		if(counter==0){
		%>
			<tr>
			<td class='admin' colspan="2"><%= getTran(request,"web","no_known_interactions",sWebLanguage)%></td>
		</tr>
		<%
		}
	%>
	</table>
</form>
