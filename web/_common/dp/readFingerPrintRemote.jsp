<%@include file="/includes/helper.jsp"%><%@page import="be.mxs.common.util.io.*,be.mxs.common.util.db.*,com.digitalpersona.uareu.*"%>
<%!
	private static byte[] hexStringToByteArray(String s) {
	    int len = s.length();
	    byte[] data = new byte[len / 2];
	    for (int i = 0; i < len; i += 2) {
	        data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
	                             + Character.digit(s.charAt(i+1), 16));
	    }
	    return data;
	}
	private String ByteArrayToString(byte[] ba)
	{
	        StringBuilder strBuilder=new StringBuilder();
	        int ibyte;
	        for(int i=0;i<ba.length;i++)
	        {
	            ibyte= ba[i] & 0xFF;
	            if(ibyte<16)
	                strBuilder.append("0");
	            strBuilder.append(Integer.toHexString(ibyte));
	        }
	        return strBuilder.toString();
	}
%>
<%
	DigitalPersona dp = new DigitalPersona();
	dp.readFingerPrint(MedwanQuery.getInstance().getConfigInt("fingerPrintTimeout",20000));
	String sVector = "";
	if(dp.getResult()!=null){
		sVector=ByteArrayToString(dp.getResult().image.getData());
	}
%>
;<%=sVector%>