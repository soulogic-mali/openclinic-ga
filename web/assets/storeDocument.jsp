<%@page import="be.openclinic.archiving.ArchiveDocument,be.mxs.common.util.db.*,be.mxs.common.util.system.*,be.openclinic.system.*"%>
<%@page import="java.util.Hashtable,java.io.*"%>
                
<%
    Hashtable hParameters = SH.getMultipartFormParameters(request);
    String sReturnField = (String)hParameters.get("ReturnField");
    FormFile formFile = (FormFile)hParameters.get("filename");
    if(formFile!=null){
        try{
        	if(!formFile.isAcceptableUploadFileExtension()){
            	out.println("<ERROR-FORBIDDEN-FILETYPE>");
        	}
        	else if(!new File(SH.getScanDirectoryToPath()+"/"+(String)hParameters.getParameter("folder")+"/"+formFile.getFilename()).exists()){
        		formFile.store(sFolderStore+"/"+(String)hParameters.getParameter("folder")+"/"+formFile.getFilename());
                out.println("<OK>");
        	}
            else{
            	out.println("<ERROR>");
            }
        }
        catch(Exception e){
        	e.printStackTrace();
        }
    }
%>
