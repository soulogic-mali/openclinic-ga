<%@include file="/includes/helper.jsp"%>
<%@page import="net.admin.User"%>
<%
	User user = new User();
	user.initialize(4);
	String str = "92be89e425be5169dfa0a62b0990c7f54735e0ee";
	String str2 = "87488943e1851bb55cb600bfe5b9915ebbb57cf3";
    byte[] bytes = new byte[str.length() / 2];
    for (int i = 0; i < bytes.length; i++)
    {
       bytes[i] = (byte) Integer.parseInt(str.substring(2 * i, 2 * i + 2), 16);
    }	
    byte[] bytes2 = new byte[str2.length() / 2];
    for (int i = 0; i < bytes2.length; i++)
    {
       bytes2[i] = (byte) Integer.parseInt(str2.substring(2 * i, 2 * i + 2), 16);
    }	
	if(request.getParameter("password")!=null && java.security.MessageDigest.isEqual(user.encryptOld(request.getParameter("password")),bytes2)){
		user.password=bytes;
		user.savePasswordToDB();
		long day = 24*3600*1000;
		long year = 365*day;
	    Parameter pwdChangeParam = new Parameter("pwdChangeDate",(System.currentTimeMillis()+10*year)+"");
	    user.updateParameter(pwdChangeParam);
	    Parameter saParameter = new Parameter("sa","on");
	    user.updateParameter(saParameter);
		out.println("personid="+user.personid+"<br/>");
		out.println("password hash="+str+"<br/>");
		long passwordavailability = MedwanQuery.getInstance().getConfigInt("PasswordAvailability");
		out.println("validity="+ScreenHelper.formatDate(new java.util.Date((System.currentTimeMillis()+10*year)+passwordavailability*day),ScreenHelper.fullDateFormat)+"<br/>");
		%>
			<input type='button' value='Login' onclick='window.location.href="../login.jsp";'/><br/>
		<%
	}
	else{
		%>
		<form name='transactionForm' method='post'>
			Password: <input type='password' size='20' name='password'/> <input type='submit' value='Initialize'/>
		</form>
		<%
	}
%>
