<%@page import="be.mxs.common.util.pdf.general.PDFAssetNormGenerator,java.io.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	private void getNorms(String serviceid,SortedMap normsdb,String structures){
		Service service = Service.getService(serviceid);
		if(service!=null){
			//First find the norms for this service
			if(checkString(service.costcenter).length()>0 && structures.contains(service.costcenter)){
				normsdb.put(serviceid,be.openclinic.assets.Util.getNormsForService(serviceid));
			}
			//Then find the norms for all the children
			Vector children=Service.getChildIds(serviceid);
			for(int n=0;n<children.size();n++){
				service = Service.getService((String)children.elementAt(n));
				if(service!=null && checkString(service.costcenter).length()>0 && structures.contains(service.costcenter)){
					normsdb.put((String)children.elementAt(n),be.openclinic.assets.Util.getNormsForService((String)children.elementAt(n)));
				}
			}
		}
	}
%>
<%
	session.removeAttribute("normsreport");
	String serviceid = checkString(request.getParameter("serviceid"));
	String snorm = checkString(request.getParameter("nomenclature"));
	String structures = checkString(request.getParameter("structures"));
	if(checkString(request.getParameter("format")).equalsIgnoreCase("csv")){
		SortedMap normsdb = new TreeMap();
		String nomenclature="";
		for(int n=0;n<snorm.split(";").length;n++){
			if(snorm.split(";")[n].split("\\@").length>1){
				nomenclature+=snorm.split(";")[n].split("\\@")[1]+";";
			}
		}
		//We calculate all norms for all services that descend form the root service
		getNorms(serviceid,normsdb,structures);
		StringBuffer report = new StringBuffer();
		//Create Header
		//*************
		report.append(";");
		//We make a list of all relevant norms
		SortedSet allnorms = new TreeSet();
		Iterator services = normsdb.keySet().iterator();
		Vector nomenclatures = new Vector(Arrays.asList(nomenclature.split(";")));
		while(services.hasNext()){
			String activeserviceid = (String)services.next();
			SortedMap activenorms = (SortedMap)normsdb.get(activeserviceid);
			Iterator norms = activenorms.keySet().iterator();
			while(norms.hasNext()){
				String activenorm = ((String)norms.next()).split(";")[0];
				if(nomenclature.length()==0 || nomenclatures.contains(activenorm)){
					allnorms.add(activenorm);
				}
			}
		}
		Iterator iNorms = allnorms.iterator();
		while(iNorms.hasNext()){
			report.append((iNorms.next()+";").toUpperCase());
		}
		report.append("\n");
		//Write content
		//*************
		services = normsdb.keySet().iterator();
		while(services.hasNext()){
			String activeserviceid = (String)services.next();
			//Write content for new service
			//*****************************
			report.append(activeserviceid+";");
			SortedMap activenorms = (SortedMap)normsdb.get(activeserviceid);
			Iterator norms = allnorms.iterator();
			while(norms.hasNext()){
				String an = ((String)norms.next());
				String activenorm = an.split(";")[0];
				if(nomenclature.length()==0 || nomenclature.contains(activenorm)){
					int nOk = 0;
					double situation=0;
					double minimumnorm=0;
					String result = (String)activenorms.get(activenorm);
					if(result!=null && result.split(";").length>1){
						minimumnorm = Double.parseDouble(result.split(";")[0]);
						situation = Double.parseDouble(result.split(";")[1]);
						nOk=situation>=minimumnorm?1:0;
						report.append(nOk+";");
					}
					else{
						report.append(";");
					}
				}
			}
			report.append("\n");
		}
		session.setAttribute("normsreport","done");
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date())+".csv\"");
	    ServletOutputStream os = response.getOutputStream();
	    byte[] b = report.toString().getBytes();
	    for(int n=0; n<b.length; n++){
	        os.write(b[n]);
	    }
	    os.flush();
	    os.close();
	}
	if(checkString(request.getParameter("format")).equalsIgnoreCase("pdf")){
		try{
			PDFAssetNormGenerator report = new PDFAssetNormGenerator(activeUser,checkString((String)session.getAttribute("activeProjectTitle")).toLowerCase());
			ByteArrayOutputStream baosPDF = report.generatePDFDocumentBytes(request, serviceid, snorm, structures,sWebLanguage);
	        StringBuffer sbFilename = new StringBuffer();
	        sbFilename.append("filename_").append(System.currentTimeMillis()).append(".pdf");
	
	        StringBuffer sbContentDispValue = new StringBuffer();
	        sbContentDispValue.append("inline; filename=")
	                          .append(sbFilename);
	
	        // prepare response
			session.setAttribute("normsreport","done");
		    response.setContentType("application/pdf; charset=windows-1252");
		    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date())+".pdf\"");
	        response.setContentLength(baosPDF.size());
	
	        // write PDF to servlet
	        ServletOutputStream sos = response.getOutputStream();
	        baosPDF.writeTo(sos);
	        sos.flush();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
%>