<%@ page import="java.util.*" %>
<%!
	String getClique(String[] members,String suffix){
		String clique="";	
		for(int n=1;n<members.length;n++){
			clique+="<tr><td>"+members[0]+"</td><td>"+members[n]+"</td><td>"+suffix+"</td></tr>";
		}
		if(members.length>2){
			clique+=getClique(Arrays.copyOfRange(members,1,members.length),suffix);
		}
		return clique;
	}
%>
<%
	String result="";
	if((request.getParameter("formaction")+"").equalsIgnoreCase("getclique")){
		String[] members = request.getParameter("cliqueMembers").split("\n");
		result="<div  id='resultstable'><table border='1'>"+getClique(members,request.getParameter("cliqueWeight"))+"</table></div>";
	}
%>
<form name='transactionForm' method='post'>
	<input type='hidden' name='formaction' id='formaction'/>
	<table>
		<tr>
			<td>Weight of the relations</td>
			<td colspan='2'><input type='text' size='5' name='cliqueWeight'/></td>
		</tr>
		<tr>
			<td>Clique members separated by comma:</td>
			<td><textarea name='cliqueMembers' cols='60' rows='2'></textarea></td>
			<td><input type='button' name='cliqueButton' value='Generate clique' onclick='document.getElementById("formaction").value="getclique";transactionForm.submit();'/></td>
		</tr>
	</table>
	<%=result %>
</form>
<script>
	function copyToClipboard (text) {
	  if (navigator.clipboard) { // default: modern asynchronous API
	    return navigator.clipboard.writeText(text);
	  } else if (window.clipboardData && window.clipboardData.setData) {     // for IE11
	    window.clipboardData.setData('Text', text);
	    return Promise.resolve();
	  } else {
	    // workaround: create dummy input
	    const input = h('input', { type: 'text' });
	    input.value = text;
	    document.body.append(input);
	    input.focus();
	    input.select();
	    document.execCommand('copy');
	    input.remove();
	    return Promise.resolve();
	  }
	}
	copyToClipboard(document.getElementById('resultstable').innerHTML);
</script>