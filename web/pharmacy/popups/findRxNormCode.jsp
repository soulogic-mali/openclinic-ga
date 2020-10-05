<%@ page import="java.io.*,org.dom4j.*,org.dom4j.io.*,be.mxs.common.util.io.*,org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*,be.mxs.common.util.db.*,be.mxs.common.util.system.*,be.openclinic.finance.*,net.admin.*,java.util.*,java.text.*,be.openclinic.adt.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	private SortedSet getRxNormCodes(String sKey){
		TreeSet codes = new TreeSet();
		try{
			HttpClient client = new HttpClient();
			//First retrieve all rxcui for the term
			Hashtable rxcuis = new Hashtable();
			String url = MedwanQuery.getInstance().getConfigString("NLM_DDI_URL_FindRxNormCode","http://rxnav.nlm.nih.gov/REST/approximateTerm");
			GetMethod method = new GetMethod(url);
			method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
			NameValuePair nvp1= new NameValuePair("term",sKey);
			method.setQueryString(new NameValuePair[]{nvp1});
			int statusCode = client.executeMethod(method);
			BufferedReader br = new BufferedReader(new StringReader(method.getResponseBodyAsString()));
			SAXReader reader=new SAXReader(false);
			org.dom4j.Document document=reader.read(br);
			Element root = document.getRootElement();
			if(root.getName().equalsIgnoreCase("rxnormdata")){
				Element approximateGroup=root.element("approximateGroup");
				Iterator candidates = approximateGroup.elementIterator("candidate");
				while(candidates.hasNext()){
					Element candidate = (Element)candidates.next();
					if(candidate.elementText("rxcui")!=null && rxcuis.get(candidate.element("rxcui"))==null){
						rxcuis.put(candidate.elementText("rxcui"),Integer.parseInt(candidate.elementText("score")));
					}
				}
			}
			
			//For all rxcuis, find the RxNorm name
			Enumeration e = rxcuis.keys();
			while(e.hasMoreElements()){
				String rxcui=(String)e.nextElement();
				url = MedwanQuery.getInstance().getConfigString("NLM_DDI_URL_FindRxNormProperties","http://rxnav.nlm.nih.gov/REST/rxcui/"+rxcui+"/properties");
				method = new GetMethod(url);
				method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
				statusCode = client.executeMethod(method);
				br = new BufferedReader(new StringReader(method.getResponseBodyAsString()));
				reader=new SAXReader(false);
				document=reader.read(br);
				root = document.getRootElement();
				if(root.getName().equalsIgnoreCase("rxnormdata")){
					Element properties = root.element("properties");
					if(properties!=null && properties.element("name")!=null){
						String score="000"+(100-(Integer)rxcuis.get(rxcui));
						codes.add(score.substring(score.length()-3,score.length())+";"+properties.elementText("name")+";"+rxcui);
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
	StringBuffer output= new StringBuffer();
	output.append("<form name='transactionForm' method='post' action='popup.jsp?Page=/pharmacy/popups/findRxNormCode.jsp&PopupWidth="+checkString(request.getParameter("PopupWidth"))+"&PopupHeight="+checkString(request.getParameter("PopupHeight"))+"'>");
	output.append("<input type='hidden' name='PopupWidth' value='"+checkString(request.getParameter("PopupWidth"))+"'/>");
	output.append("<input type='hidden' name='PopupHeight' value='"+checkString(request.getParameter("PopupHeight"))+"'/>");
	output.append("<input type='hidden' name='returnField' value='"+checkString(request.getParameter("returnField"))+"'/>");
	output.append("<input type='text' class='text' size='80' name='key' value='"+key+"'/>");
	output.append("<input type='submit' name='submit' value='"+getTran(request,"web","find",sWebLanguage)+"'/>");
	
	output.append("<table width='100%'>");
	output.append("<tr class='admin'>");
	output.append("<td>"+getTran(request,"web","drugname",sWebLanguage)+"</td>");
	output.append("<td>"+getTran(request,"web","rxnormcode",sWebLanguage)+"</td>");
	output.append("</tr>");
		SortedSet codes=getRxNormCodes(key);
		Iterator i = codes.iterator();
		int counter=0;
		while(i.hasNext()){
			String code=(String)i.next();
			output.append("<tr>");
			output.append("<td class='admin'>"+code.split(";")[1]+"("+(100-Integer.parseInt(code.split(";")[0]))+"%)</td>");
			output.append("<td class='admin2' valign='top'><input class='text' type='checkbox' "+(counter>0?"":"checked")+" name='chkrxnorm"+code.split(";")[2]+"' id='"+code.split(";")[2]+"'/>"+code.split(";")[2]+"</td>");
			output.append("</tr>");
			
			counter++;
		}
		
		output.append("</table>");
		if(request.getParameter("returnField")!=null){
			output.append("<input type='button' class='button' name='transfer' value='"+getTranNoLink("web","copydata",sWebLanguage)+"' onclick='copyData();'/>");
		}
output.append("</form>");

output.append("<script>");
output.append("function copyData(){");
output.append("var codes='';");
output.append("for(n=0;n<document.all.length;n++){");
output.append("if(document.all[n].name && document.all[n].name.startsWith('chkrxnorm') && document.all[n].checked){");
output.append("if(codes.length>0){");
output.append("codes=codes+';';");
output.append("}");
output.append("codes=codes+document.all[n].id;");
output.append("}");
output.append("}");		
output.append("window.opener.document.getElementById('"+request.getParameter("returnField")+"').value=codes;");
output.append("window.close();");
output.append("}");
output.append("</script>");
session.setAttribute("popupcontent", output.toString());
out.println(output.toString());
%>
