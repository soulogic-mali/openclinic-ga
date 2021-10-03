<%@page import="be.openclinic.finance.*,
				be.openclinic.medical.*,
                be.openclinic.statistics.CsvStats,
                be.mxs.common.util.system.HTMLEntities,
                be.mxs.common.util.db.MedwanQuery,
                java.text.SimpleDateFormat,
                java.util.Date"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	boolean hasPBFTransaction(String encounteruid,String userid){
		boolean bHasTransactions = false;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select * from transactions t, items i where t.serverid=i.serverid and t.transactionid=i.transactionid and "+
					" i.type='be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID' and i.value='"+encounteruid+"' and t.userId="+userid+" and t.transactionType NOT IN ('be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_LAB_REQUEST','be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_MIR2')");
			ResultSet rs = ps.executeQuery();
			bHasTransactions=rs.next();
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return bHasTransactions;
	}
	
	java.sql.Date getSqlDate(ResultSet rs,String datefield){
		java.sql.Date d = null;
		try{
			d=rs.getDate(datefield);
		}
		catch(Exception e){}
		return d;
	}
%>
                
<%
	boolean done=false;
	String label = "labelfr";
	if(sWebLanguage.equalsIgnoreCase("e")||sWebLanguage.equalsIgnoreCase("en")){
		label = "labelen";		
	}

	String sQueryType  = checkString(request.getParameter("query")),
	       sTableType  = checkString(request.getParameter("tabletype")),
	       sTargetLang = checkString(request.getParameter("targetlanguage"));
	
	/// DEBUG /////////////////////////////////////////////////////////////////////////////////////
	if(Debug.enabled){
		Debug.println("\n************************** util/csvStats.jsp **************************");
		Debug.println("label      : "+label);
		Debug.println("sQueryType : "+sQueryType);
		Debug.println("sTableType : "+sTableType+"\n");
	}
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	
    String query = null;
	
	//*** 1 - SERVICE ****************************************************
    if("service.list".equalsIgnoreCase(sQueryType)){
        query = "select upper(OC_LABEL_ID) as CODE, OC_LABEL_VALUE as NAME, b.serviceparentid as PARENT"+
                " from OC_LABELS a, ServicesAddressView b"+
                "  where OC_LABEL_ID = b.serviceid"+
                "   and OC_LABEL_TYPE = 'service'"+
                "   and OC_LABEL_LANGUAGE = '"+sWebLanguage+"'"+
                " order by upper(OC_LABEL_ID)";
    }
	//*** 2 - PATIENTS ***************************************************
    else if("patients.list".equalsIgnoreCase(sQueryType)){
        query = "select a.personid, immatnew as patientid, lastname, firstname, dateofbirth,"+
                "  (select max(district) from privateview where personid=a.personid) as location1,"+
                "  (select max(oc_label_value) from oc_labels,privateview where oc_label_type='province' and oc_label_id=province and personid=a.personid and oc_label_language='"+sWebLanguage+"') as location2"+
                " from adminview a";
    }
	//*** CNRKR kiné report ***************************************************
    else if("cnrkr.burundi.kinelist".equalsIgnoreCase(sQueryType)){
    	query = "select t.serverid,t.transactionid,a.personid from transactions t, items i, healthrecord h, adminview a where t.healthrecordid=h.healthrecordid and h.personid=a.personid and t.transactiontype='be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_CNRKR_KINE' and"+
    			" i.serverid=t.serverid and"+
    			" i.transactionid=t.transactionid and"+
    			" i.type='be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_CLOSINGDATE' and"+
    			" length(i.value)=10 and"+
    			" STR_TO_DATE(i.value, '%d/%m/%Y')>=? and"+
    			" STR_TO_DATE(i.value, '%d/%m/%Y')<?"+
    			" order by t.updatetime";
    	StringBuffer sResult = new StringBuffer();
    	sResult.append("DATE DEBUT;DATE FIN;NOM;PRENOM;PATIENTID;SEXE;AGE;ETAT CIVIL;PROVINCE;COMMUNE;GROUPE DE PATHOLOGIE;ACTES DE TRAITEMENT;RESULTATS;KINESITHERAPEUTE\n");
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	PreparedStatement ps = conn.prepareStatement(query);
    	ps.setDate(1,new java.sql.Date(ScreenHelper.parseDate(request.getParameter("begin")).getTime()));
    	ps.setDate(2,new java.sql.Date(ScreenHelper.parseDate(request.getParameter("end")).getTime()));
    	ResultSet rs = ps.executeQuery();
    	while(rs.next()){
    		int serverid = rs.getInt("serverid");
    		int transactionid = rs.getInt("transactionid");
    		TransactionVO transaction = MedwanQuery.getInstance().loadTransaction(serverid, transactionid);
    		if(transaction!=null && transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_CARDTYPE").equalsIgnoreCase("2")){
    			sResult.append(ScreenHelper.formatDate(transaction.getUpdateTime())+";");
    			sResult.append(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_CLOSINGDATE")+";");
    			AdminPerson patient = AdminPerson.getAdminPerson(rs.getString("personid"));
    			if(patient!=null){
    				sResult.append(patient.lastname.toUpperCase()+";");
    				sResult.append(patient.firstname.toUpperCase()+";");
    				sResult.append(patient.personid+";");
    				sResult.append(patient.gender.toUpperCase()+";");
    				try{
	    				int age = patient.getAgeInMonths();
	    				if(age<60){
	    					sResult.append(" 0-5;");
	    				}
	    				else if(age<120){
	    					sResult.append(" 5-10;");
	    				}
	    				else if(age<240){
	    					sResult.append(" 10-20;");
	    				}
	    				else if(age<360){
	    					sResult.append(" 20-30;");
	    				}
	    				else if(age<480){
	    					sResult.append(" 30-40;");
	    				}
	    				else if(age<600){
	    					sResult.append(" 40-50;");
	    				}
	    				else if(age<720){
	    					sResult.append(" 50-60;");
	    				}
	    				else if(age<840){
	    					sResult.append(" 60-70;");
	    				}
	    				else{
	    					sResult.append(" 70+;");
	    				}
    				}
    				catch(Exception ae){
    					sResult.append(";");
    				}
    				sResult.append(ScreenHelper.getTranNoLink("civil.status",patient.comment2,sWebLanguage)+";");
    				if(patient.getActivePrivate()!=null){
    					sResult.append(patient.getActivePrivate().district+";");
    					sResult.append(patient.getActivePrivate().sector+";");
    				}
    				else{
    					sResult.append(";;");
    				}
    			}
    			else{
    				sResult.append(";;;;;;;;");
    			}
    			sResult.append(ScreenHelper.getTranNoLink("cnrkr.diagnosticacts",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_DIAGNOSTICACTS"),sWebLanguage)+";");
    			String[] treatments = transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_TREATMENTS").split("£");
    			Hashtable hTreatments = new Hashtable();
    			for(int n=0;n<treatments.length;n++){
    				for(int i=1;i<11;i++){
    					if(treatments[n].split(";").length>i && treatments[n].split(";")[i].length()>0){
    						if(hTreatments.get(treatments[n].split(";")[i])==null){
    							hTreatments.put(treatments[n].split(";")[i],1);
    						}
    						else{
    							hTreatments.put(treatments[n].split(";")[i],(Integer)hTreatments.get(treatments[n].split(";")[i])+1);
    						}
    					}
    				}
    			}
    			Enumeration eTreatments = hTreatments.keys();
    			boolean bInit=false;
    			while(eTreatments.hasMoreElements()){
    				String key = (String)eTreatments.nextElement();
    				if(bInit){
    					sResult.append(", ");
    				}
    				sResult.append(hTreatments.get(key)+" x "+ScreenHelper.getTranNoLink("cnrkr.acts",key,sWebLanguage));
    				bInit=true;
    			}
    			sResult.append(";");
    			sResult.append(ScreenHelper.getTranNoLink("kine.outcome",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_REPORTOUTCOME"),sWebLanguage)+";");
    			try{
    				sResult.append(transaction.getUser().getPersonVO().getFullName()+";\r\n");
    			}
    			catch(Exception ea){
    				sResult.append(";\r\n");
    			}
    		}
    	}
    	rs.close();
    	ps.close();
        conn.close();
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
	    ServletOutputStream os = response.getOutputStream();

    	byte[] b = sResult.toString().getBytes("ISO-8859-1");
        for(int n=0; n<b.length; n++){
            os.write(b[n]);
        }
        os.flush();
        os.close();
        done=true;
    }
	//*** CNRKR consultations report ***************************************************
    else if("cnrkr.burundi.consultationslist".equalsIgnoreCase(sQueryType)){
    	query="select t.serverid,t.transactionid,a.personid from transactions t, healthrecord h, adminview a where a.personid=h.personid and t.healthrecordid=h.healthrecordid and t.updatetime>=? and t.updatetime<? and t.transactiontype='be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_CNRKR_CONSULTATION'";
    	StringBuffer sResult = new StringBuffer();
    	sResult.append("DATE;NOM;PRENOM;PATIENTID;SEXE;AGE;ETAT CIVIL;PROVINCE;COMMUNE;PATHOLOGIE;GROUPE DE PATHOLOGIE;CISP-2/CIM10;NOM DU DIAGNOSTIC (CISP-2/CIM10);MEDECIN;REEDUCATION;\n");
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	PreparedStatement ps = conn.prepareStatement(query);
    	ps.setDate(1,new java.sql.Date(ScreenHelper.parseDate(request.getParameter("begin")).getTime()));
    	ps.setDate(2,new java.sql.Date(ScreenHelper.parseDate(request.getParameter("end")).getTime()));
    	ResultSet rs = ps.executeQuery();
    	while(rs.next()){
    		int serverid = rs.getInt("serverid");
    		int transactionid = rs.getInt("transactionid");
    		TransactionVO transaction = MedwanQuery.getInstance().loadTransaction(serverid, transactionid);
    		if(transaction!=null){
    			sResult.append(ScreenHelper.formatDate(transaction.getUpdateTime())+";");
    			AdminPerson patient = AdminPerson.getAdminPerson(rs.getString("personid"));
    			if(patient!=null){
    				sResult.append(patient.lastname.toUpperCase()+";");
    				sResult.append(patient.firstname.toUpperCase()+";");
    				sResult.append(patient.personid+";");
    				sResult.append(patient.gender.toUpperCase()+";");
    				try{
	    				int age = patient.getAgeInMonths();
	    				if(age<60){
	    					sResult.append(" 0-5;");
	    				}
	    				else if(age<120){
	    					sResult.append(" 5-10;");
	    				}
	    				else if(age<240){
	    					sResult.append(" 10-20;");
	    				}
	    				else if(age<360){
	    					sResult.append(" 20-30;");
	    				}
	    				else if(age<480){
	    					sResult.append(" 30-40;");
	    				}
	    				else if(age<600){
	    					sResult.append(" 40-50;");
	    				}
	    				else if(age<720){
	    					sResult.append(" 50-60;");
	    				}
	    				else if(age<840){
	    					sResult.append(" 60-70;");
	    				}
	    				else{
	    					sResult.append(" 70+;");
	    				}
    				}
    				catch(Exception ae){
    					sResult.append(";");
    				}
    				sResult.append(ScreenHelper.getTranNoLink("civil.status",patient.comment2,sWebLanguage)+";");
    				if(patient.getActivePrivate()!=null){
    					sResult.append(patient.getActivePrivate().district+";");
    					sResult.append(patient.getActivePrivate().sector+";");
    				}
    				else{
    					sResult.append(";;");
    				}
    			}
    			else{
    				sResult.append(";;;;;;;;");
    			}
    			HashSet icdcodes = new HashSet();
    			boolean bInit=false;
    			if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY").length()>0){
    				sResult.append(ScreenHelper.getTranNoLink("cnrkr.pathology",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY"),sWebLanguage).split(";")[0]);
    				if(!ScreenHelper.getTranNoLink("cnrkr.icdmap",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY"),"fr").equals(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY"))){
    					icdcodes.add(ScreenHelper.getTranNoLink("cnrkr.icdmap",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY"),"fr"));
    				}
    				bInit=true;
    			}
    			if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY2").length()>0){
    				if(bInit){
    					sResult.append(", ");
    				}
    				else{
        				bInit=true;
    				}
    				sResult.append(ScreenHelper.getTranNoLink("cnrkr.pathology",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY2"),sWebLanguage).split(";")[0]);
    				if(!ScreenHelper.getTranNoLink("cnrkr.icdmap",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY2"),"fr").equals(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY2"))){
    					icdcodes.add(ScreenHelper.getTranNoLink("cnrkr.icdmap",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY2"),"fr"));
    				}
    			}
    			if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY3").length()>0){
    				if(bInit){
    					sResult.append(", ");
    				}
    				else{
        				bInit=true;
    				}
    				sResult.append(ScreenHelper.getTranNoLink("cnrkr.pathology",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY3"),sWebLanguage).split(";")[0]);
    				if(!ScreenHelper.getTranNoLink("cnrkr.icdmap",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY3"),"fr").equals(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY3"))){
    					icdcodes.add(ScreenHelper.getTranNoLink("cnrkr.icdmap",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY3"),"fr"));
    				}
    			}
    			if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY4").length()>0){
    				if(bInit){
    					sResult.append(", ");
    				}
    				else{
        				bInit=true;
    				}
    				sResult.append(ScreenHelper.getTranNoLink("cnrkr.pathology",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY4"),sWebLanguage).split(";")[0]);
    				if(!ScreenHelper.getTranNoLink("cnrkr.icdmap",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY4"),"fr").equals(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY4"))){
    					icdcodes.add(ScreenHelper.getTranNoLink("cnrkr.icdmap",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY4"),"fr"));
    				}
    			}
    			sResult.append(";");
    			bInit=false;
    			if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY").split("\\.")[0].length()>0){
    				sResult.append(ScreenHelper.getTranNoLink("cnrkr.pathology",ScreenHelper.checkString(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY")).split("\\.")[0],sWebLanguage).split(";")[0]);
    				bInit=true;
    			}
    			if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY2").split("\\.")[0].length()>0){
    				if(bInit){
    					sResult.append(", ");
    				}
    				else{
        				bInit=true;
    				}
    				sResult.append(ScreenHelper.getTranNoLink("cnrkr.pathology",ScreenHelper.checkString(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY2")).split("\\.")[0],sWebLanguage).split(";")[0]);
    			}
    			if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY3").split("\\.")[0].length()>0){
    				if(bInit){
    					sResult.append(", ");
    				}
    				else{
        				bInit=true;
    				}
    				sResult.append(ScreenHelper.getTranNoLink("cnrkr.pathology",ScreenHelper.checkString(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY3")).split("\\.")[0],sWebLanguage).split(";")[0]);
    			}
    			if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY4").split("\\.")[0].length()>0){
    				if(bInit){
    					sResult.append(", ");
    				}
    				else{
        				bInit=true;
    				}
    				sResult.append(ScreenHelper.getTranNoLink("cnrkr.pathology",ScreenHelper.checkString(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY4")).split("\\.")[0],sWebLanguage).split(";")[0]);
    			}
    			sResult.append(";");
    			//We voegen ook nog alle geregistreerde icd10 codes voor dit consult toe
    			Collection items = transaction.getItems();
    			Iterator iItems = items.iterator();
    			while(iItems.hasNext()){
    				ItemVO item = (ItemVO)iItems.next();
    				if(item.getType().startsWith("ICD10Code")){
    					icdcodes.add(item.getType().replaceAll("ICD10Code",""));
    				}
    			}
				Iterator iIcd = icdcodes.iterator();
				bInit=false;
				while(iIcd.hasNext()){
    				if(bInit){
    					sResult.append(", ");
    				}
    				else{
        				bInit=true;
    				}
    				sResult.append(iIcd.next());
				}
				sResult.append(";");
				iIcd = icdcodes.iterator();
				bInit=false;
				while(iIcd.hasNext()){
    				if(bInit){
    					sResult.append(", ");
    				}
    				else{
        				bInit=true;
    				}
    				sResult.append(MedwanQuery.getInstance().getCodeTran("icd10code"+iIcd.next(), sWebLanguage) );
				}
				sResult.append(";");
    			try{
    				sResult.append(transaction.getUser().getPersonVO().getFullName()+";");
    			}
    			catch(Exception ea){
    				sResult.append(";");
    			}
    			sResult.append(ScreenHelper.getTranNoLink("cnrkr.reeducation",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_REEDUCATION"),sWebLanguage)+";\r\n");
    		}
    	}
    	rs.close();
    	ps.close();
        conn.close();
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
	    ServletOutputStream os = response.getOutputStream();

    	byte[] b = sResult.toString().getBytes("ISO-8859-1");
        for(int n=0; n<b.length; n++){
            os.write(b[n]);
        }
        os.flush();
        os.close();
        done=true;
    }
   	//*** 2.a - Vida ***************************************************
    else if("vida".equalsIgnoreCase(sQueryType)){
        Hashtable vaccins = new Hashtable();
        Hashtable comments = new Hashtable();
        Hashtable polios = new Hashtable();
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
        PreparedStatement ps = conn.prepareStatement("select * from OC_VACCINATIONS where OC_VACCINATION_DATE<>'' order by OC_VACCINATION_UPDATETIME");
        ResultSet rs = ps.executeQuery();  
        String date,type;
        while(rs.next()){
        	date = checkString(rs.getString("OC_VACCINATION_DATE"));
        	type=rs.getString("OC_VACCINATION_TYPE");
        	if(type.startsWith("vita100")){
        		type="vita100";
        	}
        	else if(type.startsWith("vita200.1")){
        		type="vita200.1";
        	}
        	else if(type.startsWith("vita200.2")){
        		type="vita200.2";
        	}
        	else if(type.startsWith("alben200")){
        		type="alben200";
        	}
        	else if(type.startsWith("alben400")){
        		type="alben400";
        	}
        	if(date.length()>0){
        		String uid=rs.getString("OC_VACCINATION_PATIENTUID")+"."+type;
        		vaccins.put(uid,date);
        		String comment=checkString(rs.getString("OC_VACCINATION_OBSERVATION"));
        		if(comment.length()>0){
        			comments.put(uid,getTranNoLink("malivaccinationobservations",comment.split(";")[0],sWebLanguage)+(comment.split(";").length<2?"":": "+comment.split(";")[1]));
        		}
        		String polio=checkString(rs.getString("OC_VACCINATION_MODIFIER"));
        		if(polio.length()>0){
        			polios.put(uid,getTranNoLink("malivaccinationmodifiers",polio.split(";")[0],sWebLanguage));
        		}
        	}
        }
		rs.close();
		ps.close();
        query = "select b.cell as NoCons,a.comment3 as NoChefID1, b.city as SOUQRTIE, b.quarter as QUARTIER, (select max(firstname) from adminview where personid=a.comment3) as PRCHEF_1, (select max(lastname) from adminview where personid=a.comment3) as NMCHEF_1,"+
                "  a.comment5 as RELACHEF,a.personid as NoIndiv, firstname as PrIndiv2, lastname as NmIndiv2,datediff(now(),a.dateofbirth)/365 as Age, gender as SEXE, comment2 as STATMAT,a.dateofbirth as DATENAIS"+
                " from adminview a, privateview b where a.personid=b.personid and exists (select * from oc_vaccinations where OC_VACCINATION_PATIENTUID=a.personid and OC_VACCINATION_DATE<>'') order by a.comment3,a.searchname";
		StringBuffer sResult=new StringBuffer().append("NoCons;NoChefID1;SOUQRTIE;QUARTIER;PRCHEF_1;NMCHEF_1;RELACHEF;NoIndiv;PrIndiv2;NmIndiv2;Age;SEXE;STATMAT;DATENAIS;BCG;OBS_BCG;POLIO0;OBS_POLIO0;PV_POLIO0;POLIO1;OBS_POLIO1;PV_POLIO1;PENTA1;OBS_PENTA1;PNEUMO1;OBS_PNEUMO1;ROTA1;OBS_ROTA1;POLIO2;OBS_POLIO2;PV_POLIO2;PENTA2;OBS_PENTA2;PNEUMO2;OBS_PNEUMO2;ROTA2;OBS_ROTA2;POLIO3;OBS_POLIO3;PV_POLIO3;PENTA3;OBS_PENTA3;PNEUMO3;OBS_PNEUMO3;ROTA3;OBS_ROTA3;ROUGEOLE;OBS_ROUGEOLE;FIEVREJAUNE;OBS_FIEVREJAUNE;MENIGITEA;OBS_MENINGITEA;VAT1;OBS_VAT1;VAT2;OBS_VAT2;VATR1;OBS_VATR1;VATR2;OBS_VATR2;VATR3;OBS_VATR3;VITA100;OBS_VITA100;VITA200.1;OBS_VITA200.1;ALBEN200;OBS_ALBEN200;VITA200.2;OBS_VITA200.2;ALBEN400;OBS_ALBEN400\r\n");
        ps=conn.prepareStatement(query);
        rs=ps.executeQuery();
        SimpleDateFormat myformat= new SimpleDateFormat("dd/MM/yyyy");
        String sAge,personid;
        java.util.Date birth, minimumdate=new SimpleDateFormat("dd/MM/yyyy").parse("01/01/1900");
        int age;
        while(rs.next()){
			personid=checkString(rs.getString("NoIndiv"));
			birth=getSqlDate(rs,"DATENAIS");
			if(birth!=null && birth.before(minimumdate)){
				birth=null;
			}
			age=rs.getInt("Age");
			sAge=age+"";
			if(age>150 || age<0){
				sAge="";
			}
        	sResult.append(checkString(rs.getString("NoCons"))+";"+checkString(rs.getString("NoChefID1"))+";"+checkString(rs.getString("SOUQRTIE"))+";"+checkString(rs.getString("QUARTIER"))+";"+checkString(rs.getString("PRCHEF_1"))+";"+checkString(rs.getString("NMCHEF_1"))+";"+getTranNoLink("relationship",checkString(rs.getString("RELACHEF")),sWebLanguage)+";"+personid+";"+checkString(rs.getString("PrIndiv2"))+";"+checkString(rs.getString("NmIndiv2"))+";"
        	+sAge+";"+checkString(rs.getString("SEXE"))+";"+getTranNoLink("civil.status",checkString(rs.getString("STATMAT")),sWebLanguage)+";"+ScreenHelper.formatDate(birth,myformat));
			sResult.append(";"+checkString((String)vaccins.get(personid+".bcg")));
			sResult.append(";"+checkString((String)comments.get(personid+".bcg")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".polio0")));
			sResult.append(";"+checkString((String)comments.get(personid+".polio0")));
			sResult.append(";"+checkString((String)polios.get(personid+".polio0")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".polio1")));
			sResult.append(";"+checkString((String)comments.get(personid+".polio1")));
			sResult.append(";"+checkString((String)polios.get(personid+".polio1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".penta1")));
			sResult.append(";"+checkString((String)comments.get(personid+".penta1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".pneumo1")));
			sResult.append(";"+checkString((String)comments.get(personid+".pneumo1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".rota1")));
			sResult.append(";"+checkString((String)comments.get(personid+".rota1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".polio2")));
			sResult.append(";"+checkString((String)comments.get(personid+".polio2")));
			sResult.append(";"+checkString((String)polios.get(personid+".polio2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".penta2")));
			sResult.append(";"+checkString((String)comments.get(personid+".penta2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".pneumo2")));
			sResult.append(";"+checkString((String)comments.get(personid+".pneumo2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".rota2")));
			sResult.append(";"+checkString((String)comments.get(personid+".rota2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".polio3")));
			sResult.append(";"+checkString((String)comments.get(personid+".polio3")));
			sResult.append(";"+checkString((String)polios.get(personid+".polio3")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".penta3")));
			sResult.append(";"+checkString((String)comments.get(personid+".penta3")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".pneumo3")));
			sResult.append(";"+checkString((String)comments.get(personid+".pneumo3")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".rota3")));
			sResult.append(";"+checkString((String)comments.get(personid+".rota3")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".measles")));
			sResult.append(";"+checkString((String)comments.get(personid+".measles")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".yellowfever")));
			sResult.append(";"+checkString((String)comments.get(personid+".yellowfever")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".meningitisa")));
			sResult.append(";"+checkString((String)comments.get(personid+".meningitisa")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vat1")));
			sResult.append(";"+checkString((String)comments.get(personid+".vat1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vat2")));
			sResult.append(";"+checkString((String)comments.get(personid+".vat2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vatr1")));
			sResult.append(";"+checkString((String)comments.get(personid+".vatr1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vatr2")));
			sResult.append(";"+checkString((String)comments.get(personid+".vatr2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vatr3")));
			sResult.append(";"+checkString((String)comments.get(personid+".vatr3")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vita100")));
			sResult.append(";"+checkString((String)comments.get(personid+".vita100")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vita200.1")));
			sResult.append(";"+checkString((String)comments.get(personid+".vita200.1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".alben200")));
			sResult.append(";"+checkString((String)comments.get(personid+".alben200")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vita200.2")));
			sResult.append(";"+checkString((String)comments.get(personid+".vita200.2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".alben400")));
			sResult.append(";"+checkString((String)comments.get(personid+".alben400")));
        	sResult.append("\r\n");        	
        }
        rs.close();
        ps.close();
        conn.close();
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
	    ServletOutputStream os = response.getOutputStream();

    	byte[] b = sResult.toString().getBytes("ISO-8859-1");
        for(int n=0; n<b.length; n++){
            os.write(b[n]);
        }
        os.flush();
        os.close();
        done=true;
    }
	//*** 2.b - Banconi ***************************************************
    else if("banconi".equalsIgnoreCase(sQueryType)){
        Hashtable vaccins = new Hashtable();
        Hashtable comments = new Hashtable();
        Hashtable polios = new Hashtable();
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
        PreparedStatement ps = conn.prepareStatement("select * from OC_VACCINATIONS order by OC_VACCINATION_UPDATETIME");
        ResultSet rs = ps.executeQuery();  
        String date,type;
        while(rs.next()){
        	date = checkString(rs.getString("OC_VACCINATION_DATE"));
        	type=rs.getString("OC_VACCINATION_TYPE");
        	if(type.startsWith("vita100")){
        		type="vita100";
        	}
        	else if(type.startsWith("vita200.1")){
        		type="vita200.1";
        	}
        	else if(type.startsWith("vita200.2")){
        		type="vita200.2";
        	}
        	else if(type.startsWith("alben200")){
        		type="alben200";
        	}
        	else if(type.startsWith("alben400")){
        		type="alben400";
        	}
        	if(date.length()>0){
        		String uid=rs.getString("OC_VACCINATION_PATIENTUID")+"."+type;
        		vaccins.put(uid,date);
        		String comment=checkString(rs.getString("OC_VACCINATION_OBSERVATION"));
        		if(comment.length()>0){
        			comments.put(uid,getTranNoLink("malivaccinationobservations",comment.split(";")[0],sWebLanguage)+(comment.split(";").length<2?"":": "+comment.split(";")[1]));
        		}
        		String polio=checkString(rs.getString("OC_VACCINATION_MODIFIER"));
        		if(polio.length()>0){
        			polios.put(uid,getTranNoLink("malivaccinationmodifiers",polio.split(";")[0],sWebLanguage));
        		}
        	}
        }
		rs.close();
		ps.close();
        query = "select b.cell as NoCons,a.comment3 as NoChefID1, b.city as SOUQRTIE, (select max(firstname) from adminview where personid=a.comment3) as PRCHEF_1, (select max(lastname) from adminview where personid=a.comment3) as NMCHEF_1,"+
                "  a.personid as NoIndiv, firstname as PrIndiv2, substring(firstname,1,1)"+MedwanQuery.getInstance().concatSign()+"substring(lastname,1,1) as ININDIV_2,lastname as NmIndiv2,a.comment5 as RELACHEF,datediff(now(),a.dateofbirth)/365 as AGEAN, gender as SEXE, comment2 as STATMAT,a.dateofbirth as DATENAIS,a.comment4 as STATUT_2,a.updatetime as Date_Suivi_19,a.comment as Commentaire"+
                " from adminview a, privateview b where a.personid=b.personid order by a.comment3,a.searchname";
        conn = MedwanQuery.getInstance().getOpenclinicConnection();
        ps = conn.prepareStatement("select OC_ENCOUNTER_PATIENTUID,OC_ENCOUNTER_ENDDATE from OC_ENCOUNTERS where OC_ENCOUNTER_OUTCOME like 'dead%'");
        rs = ps.executeQuery();
        Hashtable deaths =new Hashtable();
        while(rs.next()){
        	deaths.put(rs.getString("OC_ENCOUNTER_PATIENTUID"),getSqlDate(rs,"OC_ENCOUNTER_ENDDATE"));
        }
        rs.close();
        ps.close();
		StringBuffer sResult=new StringBuffer().append("NoCons;NoChefID1;SOUQRTIE;PRCHEF_1;NMCHEF_1;NoIndiv;PrIndiv2;ININDIV_2;NmIndiv2;RELACHEF;AGEAN;SEXE;STATMAT;DATENAIS;STATUT_2;Date_Suivi_19;Commentaire;Nouv_DCD;BCG;POLIO0;POLIO1;PENTA1;PNEUMO1;ROTA1;POLIO2;PENTA2;PNEUMO2;ROTA2;POLIO3;PENTA3;PNEUMO3;ROTA3;ROUGEOLE;FIEVREJAUNE;MENIGITEA;VAT1;VAT2;VATR1;VATR2;VATR3;VITA100;VITA200.1;ALBEN200;VITA200.2;ALBEN400\r\n");

        ps=conn.prepareStatement(query);
        rs=ps.executeQuery();
        SimpleDateFormat myformat= new SimpleDateFormat("dd/MM/yyyy");
        String sAge,personid;
        java.util.Date birth, minimumdate=new SimpleDateFormat("dd/MM/yyyy").parse("01/01/1900");
        int age;
        while(rs.next()){
			personid=checkString(rs.getString("NoIndiv"));
			birth=getSqlDate(rs,"DATENAIS");
			if(birth!=null && birth.before(minimumdate)){
				birth=null;
			}
			age=rs.getInt("AGEAN");
			sAge=age+"";
			if(age>150 || age<0){
				sAge="";
			}
        	sResult.append(checkString(rs.getString("NoCons"))+";"+checkString(rs.getString("NoChefID1"))+";"+checkString(rs.getString("SOUQRTIE"))+";"+checkString(rs.getString("PRCHEF_1"))+";"+checkString(rs.getString("NMCHEF_1"))+";"+personid+";"+checkString(rs.getString("PrIndiv2"))+";"+rs.getString("ININDIV_2")+";"+checkString(rs.getString("NmIndiv2"))+";"+getTranNoLink("relationship",checkString(rs.getString("RELACHEF")),sWebLanguage)+";"
        	+sAge+";"+checkString(rs.getString("SEXE"))+";"+getTranNoLink("civil.status",checkString(rs.getString("STATMAT")),sWebLanguage)+";"+ScreenHelper.formatDate(birth,myformat)+";"+checkString(rs.getString("STATUT_2"))+";"+ScreenHelper.formatDate(getSqlDate(rs,"Date_Suivi_19"),myformat)+";"+checkString(rs.getString("Commentaire"))+";"+ScreenHelper.formatDate((java.sql.Date)deaths.get(personid),myformat));        	
			sResult.append(";"+checkString((String)vaccins.get(personid+".bcg")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".polio0")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".polio1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".penta1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".pneumo1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".rota1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".polio2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".penta2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".pneumo2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".rota2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".polio3")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".penta3")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".pneumo3")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".rota3")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".measles")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".yellowfever")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".meningitisa")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vat1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vat2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vatr1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vatr2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vatr3")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vita100")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vita200.1")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".alben200")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".vita200.2")));
			sResult.append(";"+checkString((String)vaccins.get(personid+".alben400")));
        	sResult.append("\r\n");        	
        }
        rs.close();
        ps.close();
        conn.close();
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
	    ServletOutputStream os = response.getOutputStream();

    	byte[] b = sResult.toString().getBytes("ISO-8859-1");
        for(int n=0; n<b.length; n++){
            os.write(b[n]);
        }
        os.flush();
        os.close();
        done=true;
    }
	//*** 3 - LABELS *****************************************************
    else if("labels.list".equalsIgnoreCase(sQueryType)){
    	if(ScreenHelper.checkString(sTableType).equalsIgnoreCase("singlelanguage")){
    		if(request.getParameter("language")!=null){
    			query = "select oc_label_type as TYPE,oc_label_id as ID,oc_label_language as LANGUAGE,oc_label_value as LABEL"+
    		            " from oc_labels"+
    					"  where oc_label_language='"+request.getParameter("language")+"'"+
    		            " order by oc_label_type,oc_label_id";
    			Debug.println(query);
    		}
    	}
    	else if(ScreenHelper.checkString(sTableType).equalsIgnoreCase("multilanguage")){
    		if(request.getParameter("language")!=null){
        		String languagecolumns = "";
        		String[] languages = request.getParameter("language").split(",");
        		for(int n=0;n<languages.length;n++){
        			languagecolumns+=",(select max(oc_label_value) from oc_labels where oc_label_type=a.oc_label_type and oc_label_id=a.oc_label_id and oc_label_language='"+languages[n]+"') "+languages[n].toUpperCase();
        		}
    			query = "select a.oc_label_type TYPE,a.oc_label_id ID"+languagecolumns+
    					" from (select distinct oc_label_type,oc_label_id from oc_labels) a"+
    					"  order by oc_label_type,oc_label_id";
    			Debug.println(query);
    		}
    	}
    	else if(ScreenHelper.checkString(sTableType).equalsIgnoreCase("missinglabels")){
    		if(request.getParameter("sourcelanguage")!=null && request.getParameter("targetlanguage")!=null){
        		String languagecolumns = ",(select max(oc_label_value) from oc_labels where oc_label_type=a.oc_label_type and oc_label_id=a.oc_label_id and oc_label_language='"+request.getParameter("targetlanguage")+"') "+request.getParameter("targetlanguage").toUpperCase();
        		String[] languages = request.getParameter("sourcelanguage").split(",");
        		for(int n=0; n<languages.length; n++){
        			languagecolumns+= ",(select max(oc_label_value) from oc_labels where oc_label_type=a.oc_label_type and oc_label_id=a.oc_label_id and oc_label_language='"+languages[n]+"') "+languages[n].toUpperCase();
        		}
    			query = "select a.oc_label_type TYPE,a.oc_label_id ID"+languagecolumns+" from (select distinct oc_label_type,oc_label_id from oc_labels) a where not exists (select * from oc_labels where oc_label_type=a.oc_label_type and oc_label_id=a.oc_label_id and oc_label_value<>'' and oc_label_language='"+request.getParameter("targetlanguage")+"') order by oc_label_type,oc_label_id";
    			Debug.println(query);
    		}
    	}
    }
	//*** 4 - USERS ******************************************************
    else if("user.list".equalsIgnoreCase(sQueryType)){
        query = "select userid as CODE, firstname as FIRSTNAME, lastname as LASTNAME, a.start as START, a.stop as STOP"+
                " from Users a, Admin b"+
                "  where a.personid = b.personid"+
                "   order by userid";
    }
	//*** UNDELIVERED RAW MATERIAL ORDERS ******************************************************
    else if("undelivered.rwamaterial.orders".equalsIgnoreCase(sQueryType)){
        query = "select oc_order_dateordered PO_DATE,"+
        		" o.oc_order_productionorderuid PO_NUMBER,"+
        		" pr.oc_product_code FG_ITEM_CODE,"+
        		" pr2.oc_product_code RM_ITEM_CODE,"+
        		" pr2.oc_product_name RM_ITEM_DESCRIPTION,"+
        		" o.oc_order_packagesordered RM_ORDERED,"+
        		" o.oc_order_packagesdelivered RM_DELIVERED,"+
        		" o.oc_order_comment RM_COMMENTS"+
        		" from oc_productorders o, oc_productionorders p, oc_productstocks s, oc_products pr, oc_productstocks s2, oc_products pr2 where"+
        		" oc_order_packagesordered>oc_order_packagesdelivered and"+
        		" oc_productionorder_id=oc_order_productionorderuid and"+
        		" s.oc_stock_objectid=replace(oc_productionorder_targetproductstockuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"+
        		" pr.oc_product_objectid=replace(s.oc_stock_productuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"+
        		" s2.oc_stock_objectid=replace(oc_order_productstockuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"+
        		" pr2.oc_product_objectid=replace(s2.oc_stock_productuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"+
        		" oc_order_processed=0 and"+
        		" oc_order_status is null";
    }
	//*** 5 - PRESTATIONS ************************************************
    else if("prestation.list".equalsIgnoreCase(sQueryType)){
        query = "select OC_PRESTATION_CODE CODE, OC_PRESTATION_DESCRIPTION DESCRIPTION, OC_PRESTATION_PRICE DEFAULTPRICE,"+
                "  OC_PRESTATION_CATEGORIES TARIFFS,OC_PRESTATION_REFTYPE FAMILY,OC_PRESTATION_TYPE TYPE,"+
                "  OC_PRESTATION_INVOICEGROUP INVOICEGROUP,OC_PRESTATION_CLASS CLASS"+
                " from oc_prestations"+
                "  where (OC_PRESTATION_INACTIVE is NULL OR OC_PRESTATION_INACTIVE<>1)"+
                "   ORDER BY OC_PRESTATION_CODE;";
    }
	//*** 6 - DEBETS *****************************************************
    else if("debet.list".equalsIgnoreCase(sQueryType)){
        query = "select oc_debet_date as DATE, personid PERSONID, lastname as NOM, firstname as PRENOM, dateofbirth DATE_NAISSANCE, '#'||oc_insurance_insuraruid as MOD_PAIEMENT,oc_prestation_description as PRESTATION,"+
    			" oc_prestation_reftype as FAMILY, oc_prestation_invoicegroup as INVOICEGROUP,"+
                "  oc_debet_quantity as QUANTITE,"+MedwanQuery.getInstance().convert("int","oc_debet_amount")+" as PATIENT,"+
                   MedwanQuery.getInstance().convert("int","oc_debet_insuraramount")+" as ASSUREUR, oc_label_value as SERVICE,"+
                "  oc_debet_credited as ANNULE,replace(oc_debet_patientinvoiceuid,'1.','') as FACT_PATIENT, oc_encounter_type as ENCOUNTER_TYPE,oc_insurar_name NOM_ASSUREUR"+
        		" from oc_debets, oc_encounters, adminview, oc_prestations, servicesview, oc_labels, oc_insurances, oc_insurars"+
        		"  where oc_encounter_objectid = replace(oc_debet_encounteruid,'1.','')"+
         		"   and oc_prestation_objectid = replace(oc_debet_prestationuid,'1.','')"+
           		"   and oc_insurance_objectid = replace(oc_debet_insuranceuid,'1.','')"+
          		"   and oc_insurar_objectid = replace(oc_insurance_insuraruid,'1.','')"+
        		"   and serviceid = oc_debet_serviceuid"+
        		"   and oc_label_type = 'service'"+
        		"   and oc_label_id = serviceid"+
        		"   and oc_label_language = '"+sWebLanguage+"'"+
        		"   and oc_encounter_patientuid = personid"+
        		"   and oc_debet_date >= "+MedwanQuery.getInstance().convertStringToDate("'<begin>'")+
        		"   and oc_debet_date <= "+MedwanQuery.getInstance().convertStringToDate("'<end>'")+
        		" ORDER BY oc_debet_date, lastname, firstname";
    }
	//*** LAB RESULTS *****************************************************
    else if("lab.list".equalsIgnoreCase(sQueryType)){
    	Hashtable insurances = new Hashtable();
    	Hashtable analysisnames = new Hashtable();
        query = "select a.personid PERSONID,lastname LASTNAME,firstname FIRSTNAME,dateofbirth DATE_OF_BIRTH,gender GENDER,c.creationdate ORDERDATE,resultdate RESULTDATE,analysiscode ANALYSIS,resultvalue RESULTVALUE,resultcomment COMMENT"+
        		" from adminview a,healthrecord b,transactions c,requestedlabanalyses d"+
    			" where"+
        		" a.personid=b.personid and b.healthrecordid=c.healthrecordid and c.serverid=d.serverid and c.transactionid=d.transactionid and"+
    			" finalvalidationdatetime is not null and resultdate>=?"+
    			" and resultdate<=?"+
        		" order by personid,resultdate";
    	StringBuffer sResult = new StringBuffer();
    	sResult.append("ID PERSONNE;NOM;PRENOM;SEXE;NAISSANCE;AGE;ASSUREUR;NO_ASSUREUR;CODE_ANALYSE;NOM_ANALYSE;RESULTAT;HEURE_DEMANDE;HEURE_RESULTAT;COMMENTAIRE\n");

		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	PreparedStatement ps = conn.prepareStatement(query);
    	ps.setDate(1,new java.sql.Date(ScreenHelper.parseDate(request.getParameter("begin")).getTime()));
    	ps.setDate(2,new java.sql.Date(ScreenHelper.parseDate(request.getParameter("end")).getTime()));
    	ResultSet rs = ps.executeQuery();
    	while(rs.next()){
    		int personid=rs.getInt("PERSONID");
    		sResult.append(personid+";");
    		sResult.append(rs.getString("LASTNAME")+";");
    		sResult.append(rs.getString("FIRSTNAME")+";");
    		sResult.append(rs.getString("GENDER")+";");
    		Date dateofbirth=rs.getDate("DATE_OF_BIRTH");
    		sResult.append(ScreenHelper.formatDate(dateofbirth)+";");
    		String age="";
			try{
				int a = AdminPerson.getAge(dateofbirth);
				if(a<1){
					age = "0->11m";
				}
				else if(a<5){
					age = "12->59m";
				}
				else if(a<10){
					age = "5->9";
				}
				else if(a<10){
					age = "5->9";
				}
				else if(a<15){
					age = "10->14";
				}
				else if(a<20){
					age = "15->19";
				}
				else if(a<25){
					age = "20->24";
				}
				else if(a<50){
					age = "25->49";
				}
				else {
					age = "50+";
				}
				sResult.append(age+";");
			}
			catch(Exception ae){
				sResult.append(";");
			}
			if(insurances.get(personid)==null){
				Insurance insurance = Insurance.getDefaultInsuranceForPatient(personid+"");
				if(insurance!=null){
					insurances.put(personid,insurance);
				}
			}
			if(insurances.get(personid)!=null){
				Insurance insurance = (Insurance)insurances.get(personid);
				sResult.append((insurance.getInsurar()==null?"":insurance.getInsurar().getName())+";");
				sResult.append((insurance.getInsurar()==null?"":insurance.getInsuranceNr())+";");
			}
			else{
				sResult.append(";;");
			}
			String analysis=rs.getString("ANALYSIS");
    		sResult.append(analysis+";");
    		if(analysisnames.get(analysis)==null){
    			analysisnames.put(analysis,LabAnalysis.labelForCode(analysis, sWebLanguage));
    		}
    		sResult.append(analysisnames.get(analysis)+";");
    		sResult.append(rs.getString("RESULTVALUE")+";");
    		sResult.append(new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(rs.getTimestamp("ORDERDATE"))+";");
    		sResult.append(new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(rs.getTimestamp("RESULTDATE"))+";");
    		sResult.append(rs.getString("COMMENT")+"\n");
    	}
    	rs.close();
    	ps.close();
        conn.close();
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
	    ServletOutputStream os = response.getOutputStream();

    	byte[] b = sResult.toString().getBytes("ISO-8859-1");
        for(int n=0; n<b.length; n++){
            os.write(b[n]);
        }
        os.flush();
        os.close();
        done=true;
    }
    else if("imaging.list".equalsIgnoreCase(sQueryType)){
    	Hashtable insurances = new Hashtable();
    	Hashtable analysisnames = new Hashtable();
        query = "select * from transactions where transactiontype='be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_MIR2' and updatetime>=? and updatetime<? order by updatetime";
    	StringBuffer sResult = new StringBuffer();
    	sResult.append("ID PERSONNE;NOM;PRENOM;SEXE;NAISSANCE;AGE;ASSUREUR;NO_ASSUREUR;CODE_EXAMEN;NOM_EXAMEN;RESULTAT;HEURE_DEMANDE;HEURE_RESULTAT\n");
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	PreparedStatement ps = conn.prepareStatement(query);
    	ps.setDate(1,new java.sql.Date(ScreenHelper.parseDate(request.getParameter("begin")).getTime()));
    	ps.setDate(2,new java.sql.Date(ScreenHelper.parseDate(request.getParameter("end")).getTime()));
    	ResultSet rs = ps.executeQuery();
    	while(rs.next()){
    		TransactionVO transaction = MedwanQuery.getInstance().loadTransaction(rs.getInt("serverid"), rs.getInt("transactionid"));
    		if(transaction!=null){
    			String[] sequences=";2;3;4;5".split(";");
    			for(int q=0;q<sequences.length;q++){
					String examcode=transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_TYPE"+sequences[q]);
					if(examcode.length()==0){
						continue;
					}
					if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_PROTOCOL"+sequences[q]).length()==0 && transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OTHER_REQUESTS_VALIDATION"+sequences[q]).length()==0){
						continue;
					}
	    			AdminPerson patient = AdminPerson.getAdminPerson(MedwanQuery.getInstance().getPersonIdFromHealthrecordId(rs.getInt("healthrecordid"))+"");
		    		sResult.append(patient.personid+";");
		    		sResult.append(patient.lastname+";");
		    		sResult.append(patient.firstname+";");
		    		sResult.append(patient.gender+";");
		    		sResult.append(patient.dateOfBirth+";");
		    		String age="";
					try{
						int a = patient.getAge();
						if(a<1){
							age = "0->11m";
						}
						else if(a<5){
							age = "12->59m";
						}
						else if(a<10){
							age = "5->9";
						}
						else if(a<10){
							age = "5->9";
						}
						else if(a<15){
							age = "10->14";
						}
						else if(a<20){
							age = "15->19";
						}
						else if(a<25){
							age = "20->24";
						}
						else if(a<50){
							age = "25->49";
						}
						else {
							age = "50+";
						}
						sResult.append(age+";");
					}
					catch(Exception ae){
						sResult.append(";");
					}
					if(insurances.get(patient.personid)==null){
						Insurance insurance = Insurance.getDefaultInsuranceForPatient(patient.personid);
						if(insurance!=null){
							insurances.put(patient.personid,insurance);
						}
					}
					if(insurances.get(patient.personid)!=null){
						Insurance insurance = (Insurance)insurances.get(patient.personid);
						sResult.append(insurance.getInsurar().getName()+";");
						sResult.append(insurance.getInsuranceNr()+";");
					}
					else{
						sResult.append(";;");
					}
		    		sResult.append(examcode+";");
		    		sResult.append(getTranNoLink("mir_type",examcode,sWebLanguage)+";");
		    		if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_ABNORMAL"+sequences[q]).equalsIgnoreCase("medwan.common.true")){
			    		sResult.append(getTranNoLink("mir","abnormal",sWebLanguage)+";");
		    		}
		    		else if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_NOTHING_TO_MENTION"+sequences[q]).equalsIgnoreCase("medwan.common.true")){
			    		sResult.append(getTranNoLink("mir","RAS",sWebLanguage)+";");
		    		}
		    		else{
						sResult.append(";");
		    		}
		    		sResult.append(new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(rs.getTimestamp("creationDate"))+";");
		    		sResult.append(new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(rs.getTimestamp("ts"))+"\n");
    			}
    		}
    	}
    	rs.close();
    	ps.close();
        conn.close();
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
	    ServletOutputStream os = response.getOutputStream();

    	byte[] b = sResult.toString().getBytes("ISO-8859-1");
        for(int n=0; n<b.length; n++){
            os.write(b[n]);
        }
        os.flush();
        os.close();
        done=true;
    }
	//*** 6 - DEBETS *****************************************************
    else if("debet.list.per.encounter".equalsIgnoreCase(sQueryType)){
        query = "select count(*) as TOTAL_ENCOUNTERS, "+MedwanQuery.getInstance().convert("int","avg(PATIENT)")+" as PATIENT,"+MedwanQuery.getInstance().convert("int",MedwanQuery.getInstance().getConfigString("stddevFunction","stdev")+"("+MedwanQuery.getInstance().convert("int","PATIENT")+")")+" as PATIENT_STDEV, "+MedwanQuery.getInstance().convert("int","avg(ASSUREUR)")+" as ASSUREUR,"+MedwanQuery.getInstance().convert("int",MedwanQuery.getInstance().getConfigString("stddevFunction","stdev")+"("+MedwanQuery.getInstance().convert("int","ASSUREUR")+")")+" as ASSUREUR_STDEV, "+MedwanQuery.getInstance().convert("int","avg(ASSUREUR_COMPL)")+" as ASSUREUR_COMPL,"+MedwanQuery.getInstance().convert("int",MedwanQuery.getInstance().getConfigString("stddevFunction","stdev")+"("+MedwanQuery.getInstance().convert("int","ASSUREUR_COMPL")+")")+" as ASSUREUR_COMPL_STDEV, ENCOUNTER_TYPE from (select sum("+MedwanQuery.getInstance().convert("int","oc_debet_amount")+") as PATIENT,sum("+
                MedwanQuery.getInstance().convert("int","oc_debet_insuraramount")+") as ASSUREUR,sum("+
                        MedwanQuery.getInstance().convert("int","oc_debet_extrainsuraramount")+") as ASSUREUR_COMPL,oc_encounter_objectid, oc_encounter_type as ENCOUNTER_TYPE"+
        		" from oc_debets, oc_encounters, adminview, oc_prestations, servicesview, oc_labels"+
        		"  where oc_encounter_objectid = replace(oc_debet_encounteruid,'1.','')"+
        		"   and oc_prestation_objectid = replace(oc_debet_prestationuid,'1.','')"+
        		"   and serviceid = oc_debet_serviceuid"+
        		"   and oc_label_type = 'service'"+
        		"   and oc_label_id = serviceid"+
        		"   and oc_label_language = '"+sWebLanguage+"'"+
        		"   and oc_encounter_patientuid = personid"+
        		"   and oc_debet_date >= "+MedwanQuery.getInstance().convertStringToDate("'<begin>'")+
        		"   and oc_debet_date <= "+MedwanQuery.getInstance().convertStringToDate("'<end>'")+
        		" group BY oc_encounter_objectid,oc_encounter_type) a group by ENCOUNTER_TYPE";
    }
	//*** 7 - INVOICES ***************************************************
    else if("hmk.invoices.list".equalsIgnoreCase(sQueryType)){
    	try{
	        Connection loc_conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
			StringBuffer sResult = new StringBuffer();
			
			// search all the invoices from this period     
			query = "select oc_patientinvoice_serverid,oc_patientinvoice_objectid from oc_patientinvoices"+
			        " where oc_patientinvoice_date>="+ MedwanQuery.getInstance().convertStringToDate("'<begin>'")+
			        "  and oc_patientinvoice_date<="+ MedwanQuery.getInstance().convertStringToDate("'<end>'")+
			        "   order by oc_patientinvoice_date";
	        query = query.replaceAll("<begin>",request.getParameter("begin"))
	        		     .replaceAll("<end>",request.getParameter("end"));
			Debug.println(query);
			PreparedStatement ps = loc_conn.prepareStatement(query);
			ResultSet rs = ps.executeQuery();
			int counter = 1;
			String doctor =checkString(request.getParameter("doctor"));
			String service=checkString(request.getParameter("service"));
		    response.setContentType("application/octet-stream; charset=windows-1252");
		    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
		    
		    ServletOutputStream os = response.getOutputStream();
		    
		    // header
			sResult.append("SERIAL;DATE;PATIENTID;PATIENT;DATEOFBIRTH;AGE;GENDER;DEPARTMENT;DISEASE;DOCTOR;INSURER;COMPL_INSURER;PAT_SHARE_COVERAGE_INSURER;INS_PART;COMPL_INS_PART;PAT_SHARE_COVERAGE_PART;PAT_PART;TOTAL\r\n");
		    
	    	byte[] b = sResult.toString().getBytes("ISO-8859-1");
	        for(int n=0; n<b.length; n++){
	            os.write(b[n]);
	        }
	        os.flush();
	        int c=0;
			while(rs.next()){
				c++;
				sResult = new StringBuffer();
				PatientInvoice invoice = PatientInvoice.get(rs.getString("oc_patientinvoice_serverid")+"."+rs.getString("oc_patientinvoice_objectid"));
				if(invoice!=null){
					if(doctor.length()>0 && invoice.getSignatures().indexOf("("+doctor+")")<0){
						continue;
					}
					if(service.length()>0 && !invoice.getServices().contains(service)){
						continue;
					}
					sResult.append(invoice.getUid().split("\\.")[1]+";");
					sResult.append((invoice.getDate()==null?"":ScreenHelper.stdDateFormat.format(invoice.getDate()))+";");
					sResult.append((invoice.getPatientUid()==null?"":invoice.getPatientUid())+";");
					sResult.append((invoice.getPatient()==null?"":invoice.getPatient().getFullName())+";");
					sResult.append((invoice.getPatient()==null || invoice.getPatient().dateOfBirth==null?"":invoice.getPatient().dateOfBirth)+";");
				
					String age = "";
					try{
						int a = invoice.getPatient().getAge();
						if(a<5){
							age = "0->4";
						}
						else if(a<15){
							age = "5->14";
						}
						else {
							age = "15+";
						}
					}
					catch(Exception e){
						// empty
					}
					
					sResult.append(age+";");
					sResult.append((invoice.getPatient()==null?"":invoice.getPatient().gender)+";");
					sResult.append(invoice.getServicesAsString(sWebLanguage)+";");
					sResult.append(invoice.getDiseases(sWebLanguage)+";");
					sResult.append(invoice.getSignatures()+";");
					sResult.append(invoice.getInsurers()+";");
					sResult.append(invoice.getExtraInsurers()+";");
					sResult.append(invoice.getExtraInsurers2()+";");
					sResult.append(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#")).format(invoice.getInsurarAmount())+";");
					sResult.append((new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#")).format(invoice.getExtraInsurarAmount()))+";");
					sResult.append((new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#")).format(invoice.getExtraInsurarAmount2()))+";");
					sResult.append((new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#")).format(invoice.getPatientOwnAmount()))+";");
					sResult.append((new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#")).format(invoice.getInsurarAmount()+invoice.getExtraInsurarAmount2()+invoice.getPatientOwnAmount()+invoice.getExtraInsurarAmount()))+";");
					sResult.append("\r\n");
				}
				
		    	b = sResult.toString().getBytes("ISO-8859-1");
		        for(int n=0; n<b.length; n++){
		            os.write(b[n]);
		        }
		        os.flush();
			}
			rs.close();
			ps.close();
			
			loc_conn.close();
	        os.close();
	        done=true;
    	}
    	catch(Exception e){
    		e.printStackTrace();
    	}
    }
	//*** 7 - INVOICES ***************************************************
    else if("pbf.burundi.surgerylist".equalsIgnoreCase(sQueryType)){
        try{
	    	Connection loc_conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
			StringBuffer sResult = new StringBuffer();
			long l = 24*3600*1000;
			java.util.Date beginDate = ScreenHelper.parseDate(request.getParameter("begin"));
			java.util.Date endDate = ScreenHelper.parseDate(request.getParameter("end"));
			endDate.setTime(endDate.getTime()+l);
			query = " select a.dateofbirth,t.serverid,t.transactionid,a.personid,a.lastname,a.firstname from transactions t, healthrecord h, adminview a where t.healthrecordid=h.healthrecordid and h.personid=a.personid and"+
					" t.transactiontype='be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_OPERATION_PROTOCOL' and"+
					" t.updatetime>=? and t.updatetime<? order by t.updatetime";
			Debug.println(query);
			PreparedStatement ps = loc_conn.prepareStatement(query);
			ps.setTimestamp(1, new Timestamp(beginDate.getTime()));
			ps.setTimestamp(2, new Timestamp(endDate.getTime()));
			ResultSet rs = ps.executeQuery();
			int counter = 1;
		    response.setContentType("application/octet-stream; charset=windows-1252");
		    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
		    
		    ServletOutputStream os = response.getOutputStream();
		    
		    // header
			sResult.append("DATE;IDPERSONNE;NOM;PRENOM;AGE;NAISSANCE;PROCEDURE;ANESTHESIE;CHIRURGIEN;TYPE_CHIRURGIE;CIM10;DIAGNOSTIC\r\n");
			while(rs.next()){
				int serverid = rs.getInt("serverid");
				int transactionid = rs.getInt("transactionid");
				java.util.Date dateofbirth = getSqlDate(rs,"dateofbirth");
				String age = "";
				try{
					int a = AdminPerson.getAge(dateofbirth);
					if(a<1){
						age = "0->11m";
					}
					else if(a<5){
						age = "12->59m";
					}
					else if(a<10){
						age = "5->9";
					}
					else if(a<10){
						age = "5->9";
					}
					else if(a<15){
						age = "10->14";
					}
					else if(a<20){
						age = "15->19";
					}
					else if(a<25){
						age = "20->24";
					}
					else if(a<50){
						age = "25->49";
					}
					else {
						age = "50+";
					}
				}
				catch(Exception e){
					// empty
				}
				
				TransactionVO transaction = MedwanQuery.getInstance().loadTransaction(serverid, transactionid);
				if(transaction!=null){
					String encounteruid = transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID");
					SortedSet hAuthors = new TreeSet(),hDiagcodes = new TreeSet(),hDiaglabels = new TreeSet();
					if(encounteruid.length()>0){
						//Now add the diagnoses for the Encounter
						if(checkString(request.getParameter("diagsicd10")).equalsIgnoreCase("1")){
							Vector diagnoses = Diagnosis.selectDiagnoses("", "", encounteruid, "", "", "", "", "", "", "", "", "icd10", "");
							for(int n=0;n<diagnoses.size();n++){
								Diagnosis diagnosis = (Diagnosis)diagnoses.elementAt(n);
								hAuthors.add(User.getFullUserName(diagnosis.getAuthorUID()));
								hDiagcodes.add(diagnosis.getCode().toUpperCase());
								hDiaglabels.add(MedwanQuery.getInstance().getDiagnosisLabel("icd10", diagnosis.getCode(), sWebLanguage));
							}
						}
						if(checkString(request.getParameter("diagsrfe")).equalsIgnoreCase("1")){
							Vector rfes = ReasonForEncounter.getReasonsForEncounterByEncounterUid(encounteruid);
							for(int n=0;n<rfes.size();n++){
								ReasonForEncounter rfe = (ReasonForEncounter)rfes.elementAt(n);
								if(rfe.getCodeType().equalsIgnoreCase("icd10")){
									hAuthors.add(User.getFullUserName(rfe.getAuthorUID()));
									hDiagcodes.add(rfe.getCode().toUpperCase());
									hDiaglabels.add(MedwanQuery.getInstance().getDiagnosisLabel("icd10", rfe.getCode(), sWebLanguage));
								}
							}
						}
						if(checkString(request.getParameter("diagsfreetext")).equalsIgnoreCase("1")){
							HashSet hFree = Encounter.getFreeTextDiagnoses(encounteruid);
							Iterator iFree = hFree.iterator();
							while(iFree.hasNext()){
								String[] diaglabel=((String)iFree.next()).split(";");
								hAuthors.add(diaglabel[0]);
								hDiagcodes.add(diaglabel[1]);
								hDiaglabels.add(diaglabel[2]);
							}
						}
					}					
					StringBuffer sDiagnoses = new StringBuffer();
					if(hDiagcodes.size()==0){
						sDiagnoses.append("-;");
					}
					else{
						Iterator i = hDiagcodes.iterator();
						while(i.hasNext()){
							sDiagnoses.append(i.next());
							if(i.hasNext()){
								sDiagnoses.append(", ");
							}
						}
						sDiagnoses.append(";");
					}
					if(hDiaglabels.size()==0){
						sDiagnoses.append("-;");
					}
					else{
						Iterator i = hDiaglabels.iterator();
						while(i.hasNext()){
							sDiagnoses.append(i.next());
							if(i.hasNext()){
								sDiagnoses.append(", ");
							}
						}
						sDiagnoses.append(";");
					}

					if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACT1").length()>0){
						sResult.append(ScreenHelper.formatDate(transaction.getUpdateTime())+";");
						sResult.append(rs.getInt("personid")+";");
						sResult.append(rs.getString("lastname").toUpperCase()+";");
						sResult.append(rs.getString("firstname").toUpperCase()+";");
						sResult.append(age+";");
						sResult.append(ScreenHelper.formatDate(dateofbirth)+";");
						sResult.append(ScreenHelper.removeAccents(getTranNoLink("surgicalacts.mspls",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACT1"),sWebLanguage)).toUpperCase()+";");
						sResult.append(ScreenHelper.removeAccents(getTranNoLink("anesthesiaacts.mspls",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACT1"),sWebLanguage)).toUpperCase()+";");
						sResult.append(ScreenHelper.removeAccents(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGEONS")).replaceAll("\n",", ").replaceAll("\r","")+";");
						sResult.append(ScreenHelper.removeAccents(getTranNoLink("surgerytypes",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGERYTYPE"),sWebLanguage)).toUpperCase()+";");
						sResult.append(sDiagnoses);
						sResult.append("\r\n");
					}
					if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACT2").length()>0){
						sResult.append(ScreenHelper.formatDate(transaction.getUpdateTime())+";");
						sResult.append(rs.getInt("personid")+";");
						sResult.append(rs.getString("lastname").toUpperCase()+";");
						sResult.append(rs.getString("firstname").toUpperCase()+";");
						sResult.append(age+";");
						sResult.append(ScreenHelper.formatDate(dateofbirth)+";");
						sResult.append(ScreenHelper.removeAccents(getTranNoLink("surgicalacts.mspls",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACT2"),sWebLanguage)).toUpperCase()+";");
						sResult.append(ScreenHelper.removeAccents(getTranNoLink("anesthesiaacts.mspls",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACT2"),sWebLanguage)).toUpperCase()+";");
						sResult.append(ScreenHelper.removeAccents(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGEONS")).replaceAll("\n",", ").replaceAll("\r","")+";");
						sResult.append(ScreenHelper.removeAccents(getTranNoLink("surgerytypes",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGERYTYPE"),sWebLanguage)).toUpperCase()+";");
						sResult.append(sDiagnoses);
						sResult.append("\r\n");
					}
					if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACT3").length()>0){
						sResult.append(ScreenHelper.formatDate(transaction.getUpdateTime())+";");
						sResult.append(rs.getInt("personid")+";");
						sResult.append(rs.getString("lastname").toUpperCase()+";");
						sResult.append(rs.getString("firstname").toUpperCase()+";");
						sResult.append(age+";");
						sResult.append(ScreenHelper.formatDate(dateofbirth)+";");
						sResult.append(ScreenHelper.removeAccents(getTranNoLink("surgicalacts.mspls",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACT3"),sWebLanguage)).toUpperCase()+";");
						sResult.append(ScreenHelper.removeAccents(getTranNoLink("anesthesiaacts.mspls",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_ANESTHESIA_ACT3"),sWebLanguage)).toUpperCase()+";");
						sResult.append(ScreenHelper.removeAccents(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGEONS")).replaceAll("\n",", ").replaceAll("\r","")+";");
						sResult.append(ScreenHelper.removeAccents(getTranNoLink("surgerytypes",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGERYTYPE"),sWebLanguage)).toUpperCase()+";");
						sResult.append(sDiagnoses);
						sResult.append("\r\n");
					}
				}
			}
		    
		    byte[]b = sResult.toString().getBytes("ISO-8859-1");
	        for(int n=0; n<b.length; n++){
	            os.write(b[n]);
	        }
	        os.flush();
			rs.close();
			ps.close();
			
			loc_conn.close();
	        os.close();
	        done=true;
        }
        catch(Exception z){
        	z.printStackTrace();
        }
    }
    else if(sQueryType.startsWith("pbf.burundi.lab.")){
        try{
	    	Connection loc_conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
			StringBuffer sResult = new StringBuffer();
			long l = 24*3600*1000;
			java.util.Date beginDate = ScreenHelper.parseDate(request.getParameter("begin"));
			java.util.Date endDate = ScreenHelper.parseDate(request.getParameter("end"));
			endDate.setTime(endDate.getTime()+l);
		    response.setContentType("application/octet-stream; charset=windows-1252");
		    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
		    ServletOutputStream os = response.getOutputStream();
		    
		    if(MedwanQuery.getInstance().getConfigString(sQueryType,"unknownexam").equalsIgnoreCase("unknownexam")){
		    	sResult.append(getTranNoLink("web","definelabexamparameter",sWebLanguage)+": "+sQueryType);
		    }
		    else {
			    query = "select * from requestedlabanalyses,adminview where patientid=personid and analysiscode=? and resultdate>=? and resultdate<?";
				Debug.println(query);
				PreparedStatement ps = loc_conn.prepareStatement(query);
				ps.setString(1,MedwanQuery.getInstance().getConfigString(sQueryType,"unknownexam"));
				ps.setTimestamp(2, new Timestamp(beginDate.getTime()));
				ps.setTimestamp(3, new Timestamp(endDate.getTime()));
				ResultSet rs = ps.executeQuery();
				int counter = 1;
			    // header
				sResult.append("IDPERSONNE;NOM;PRENOM;AGE;NAISSANCE;DATE;RESULTAT;\r\n");
				while(rs.next()){
					sResult.append(rs.getString("patientid")+";");
					sResult.append(rs.getString("lastname").toUpperCase()+";");
					sResult.append(rs.getString("firstname").toUpperCase()+";");
					java.util.Date dateofbirth = getSqlDate(rs,"dateofbirth");
					String age = "";
					try{
						int a = AdminPerson.getAge(dateofbirth);
						if(a<1){
							age = "0->11m";
						}
						else if(a<5){
							age = "12->59m";
						}
						else if(a<10){
							age = "5->9";
						}
						else if(a<10){
							age = "5->9";
						}
						else if(a<15){
							age = "10->14";
						}
						else if(a<20){
							age = "15->19";
						}
						else if(a<25){
							age = "20->24";
						}
						else if(a<50){
							age = "25->49";
						}
						else {
							age = "50+";
						}
					}
					catch(Exception e){
						// empty
					}
					sResult.append(age+";");
					sResult.append(ScreenHelper.formatDate(dateofbirth)+";");
					sResult.append(ScreenHelper.formatDate(rs.getDate("resultdate"))+";");
					sResult.append(checkString(rs.getString("resultvalue"))+";");	
					sResult.append("\r\n");
				}
				rs.close();
				ps.close();
		    }
		    byte[]b = sResult.toString().getBytes("ISO-8859-1");
	        for(int n=0; n<b.length; n++){
	            os.write(b[n]);
	        }
	        os.flush();
			
			loc_conn.close();
	        os.close();
	        done=true;
	    }
	    catch(Exception z){
	    	z.printStackTrace();
	    }
    }
    else if("pbf.burundi.deliverieslist".equalsIgnoreCase(sQueryType)){
        try{
	    	Connection loc_conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
			StringBuffer sResult = new StringBuffer();
			long l = 24*3600*1000;
			java.util.Date beginDate = ScreenHelper.parseDate(request.getParameter("begin"));
			java.util.Date endDate = ScreenHelper.parseDate(request.getParameter("end"));
			endDate.setTime(endDate.getTime()+l);
			query = " select a.dateofbirth,t.serverid,t.transactionid,a.personid,a.lastname,a.firstname from transactions t, healthrecord h, adminview a where t.healthrecordid=h.healthrecordid and h.personid=a.personid and"+
					" t.transactiontype='be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_DELIVERY_MSPLS' and"+
					" t.updatetime>=? and t.updatetime<? order by t.updatetime";
			Debug.println(query);
			PreparedStatement ps = loc_conn.prepareStatement(query);
			ps.setTimestamp(1, new Timestamp(beginDate.getTime()));
			ps.setTimestamp(2, new Timestamp(endDate.getTime()));
			ResultSet rs = ps.executeQuery();
			int counter = 1;
		    response.setContentType("application/octet-stream; charset=windows-1252");
		    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
		    
		    ServletOutputStream os = response.getOutputStream();
		    
		    // header
			sResult.append("DATE;ACCOUCHEMENT;IDPERSONNE;NOM;PRENOM;AGE;NAISSANCE;TYPE_ACCOUCHEMENT;ASSUREUR;CARTE;DEROULEMENT;\r\n");
			while(rs.next()){
				int serverid = rs.getInt("serverid");
				int transactionid = rs.getInt("transactionid");
				int personid=rs.getInt("personid");
				TransactionVO transaction = MedwanQuery.getInstance().loadTransaction(serverid, transactionid);
				if(transaction!=null){
					sResult.append(ScreenHelper.formatDate(transaction.getUpdateTime())+";");
					sResult.append(checkString(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_REANIMATION_DATE"))+";");
					sResult.append(personid+";");
					sResult.append(rs.getString("lastname").toUpperCase()+";");
					sResult.append(rs.getString("firstname").toUpperCase()+";");
					java.util.Date dateofbirth = getSqlDate(rs,"dateofbirth");
					String age = "";
					try{
						int a = AdminPerson.getAge(dateofbirth);
						if(a<1){
							age = "0->11m";
						}
						else if(a<5){
							age = "12->59m";
						}
						else if(a<10){
							age = "5->9";
						}
						else if(a<10){
							age = "5->9";
						}
						else if(a<15){
							age = "10->14";
						}
						else if(a<20){
							age = "15->19";
						}
						else if(a<25){
							age = "20->24";
						}
						else if(a<50){
							age = "25->49";
						}
						else {
							age = "50+";
						}
					}
					catch(Exception e){
						// empty
					}
					sResult.append(age+";");
					sResult.append(ScreenHelper.formatDate(dateofbirth)+";");
					String sType="?";
					if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DELIVERYTYPE_DYSTOCIC").equalsIgnoreCase("medwan.common.true")){
						sType=getTranNoLink("openclinic.chuk", "openclinic.common.dystocic", sWebLanguage);
					}
					if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DELIVERYTYPE_EUSTOCIC").equalsIgnoreCase("medwan.common.true")){
						sType=getTranNoLink("openclinic.chuk", "openclinic.common.eutocic", sWebLanguage);
					}
					sResult.append(sType+";");
					//Add insurancedata here
					Insurance insurance = Insurance.getDefaultInsuranceForPatient(personid+"");
					if(insurance!=null){
						sResult.append(insurance.getInsurar().getName()+";"+insurance.getInsuranceNr());
					}
					else{
						sResult.append(";");
					}
					sResult.append(";");
					sResult.append(ScreenHelper.removeAccents(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DESCRIPTION")).replaceAll("´", "'").replaceAll("`", "'").toUpperCase().replaceAll("\n", ", ").replaceAll("\r", "").replaceAll(";", ",")+";");
					sResult.append("\r\n");
					
				}
			}
		    
		    byte[]b = sResult.toString().getBytes("ISO-8859-1");
	        for(int n=0; n<b.length; n++){
	            os.write(b[n]);
	        }
	        os.flush();
			rs.close();
			ps.close();
			
			loc_conn.close();
	        os.close();
	        done=true;
        }
        catch(Exception z){
        	z.printStackTrace();
        }
    }
    else if("pbf.burundi.familyplanninglist".equalsIgnoreCase(sQueryType)){
        try{
	    	Connection loc_conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
			StringBuffer sResult = new StringBuffer();
			long l = 24*3600*1000;
			java.util.Date beginDate = ScreenHelper.parseDate(request.getParameter("begin"));
			java.util.Date endDate = ScreenHelper.parseDate(request.getParameter("end"));
			endDate.setTime(endDate.getTime()+l);
			query = " select a.dateofbirth,t.serverid,t.transactionid,a.personid,a.lastname,a.firstname,a.gender from transactions t, healthrecord h, adminview a where t.healthrecordid=h.healthrecordid and h.personid=a.personid and"+
					" t.transactiontype in ('be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_MSPLS_FAMILY_PLANNING_SURVEILLANCE','be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_MSPLS_FAMILY_PLANNING_CONSULTATION') and"+
					" t.updatetime>=? and t.updatetime<? order by t.updatetime";
			Debug.println(query);
			PreparedStatement ps = loc_conn.prepareStatement(query);
			ps.setTimestamp(1, new Timestamp(beginDate.getTime()));
			ps.setTimestamp(2, new Timestamp(endDate.getTime()));
			ResultSet rs = ps.executeQuery();
			int counter = 1;
		    response.setContentType("application/octet-stream; charset=windows-1252");
		    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
		    
		    ServletOutputStream os = response.getOutputStream();
		    
		    // header
			sResult.append("DATE;IDPERSONNE;NOM;PRENOM;AGE;NAISSANCE;SEXE;METHODE;NOUVELLE_ACCEPTANTE;QUANTITE_DISTRIBUEE;\r\n");
			while(rs.next()){
				int serverid = rs.getInt("serverid");
				int transactionid = rs.getInt("transactionid");
				int personid=rs.getInt("personid");
				TransactionVO transaction = MedwanQuery.getInstance().loadTransaction(serverid, transactionid);
				if(transaction!=null){
					sResult.append(ScreenHelper.formatDate(transaction.getUpdateTime())+";");
					sResult.append(personid+";");
					sResult.append(rs.getString("lastname").toUpperCase()+";");
					sResult.append(rs.getString("firstname").toUpperCase()+";");
					java.util.Date dateofbirth = getSqlDate(rs,"dateofbirth");
					String age = "";
					try{
						int a = AdminPerson.getAge(dateofbirth);
						if(a<1){
							age = "0->11m";
						}
						else if(a<5){
							age = "12->59m";
						}
						else if(a<10){
							age = "5->9";
						}
						else if(a<10){
							age = "5->9";
						}
						else if(a<15){
							age = "10->14";
						}
						else if(a<20){
							age = "15->19";
						}
						else if(a<25){
							age = "20->24";
						}
						else if(a<50){
							age = "25->49";
						}
						else {
							age = "50+";
						}
					}
					catch(Exception e){
						// empty
					}
					sResult.append(age+";");
					sResult.append(ScreenHelper.formatDate(dateofbirth)+";");
					sResult.append(rs.getString("gender")+";");
					sResult.append(getTranNoLink("fp.selectedmethod",transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.selectedmethod"),sWebLanguage)+";");
					boolean bNew = false;
					String[] info = transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.otherinformation").split(";");
					for(int n=0;!bNew && n<info.length;n++){
						if(info[n].equalsIgnoreCase("1")){
							bNew=true;
						}
					}
					if(bNew){
						sResult.append(getTranNoLink("web","yes",sWebLanguage)+";");
					}
					else{
						sResult.append(getTranNoLink("web","no",sWebLanguage)+";");
					}
					sResult.append(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PF_DISTRIBUTEDQUANTITY")+";");
					sResult.append("\r\n");
				}
			}
		    
		    byte[]b = sResult.toString().getBytes("ISO-8859-1");
	        for(int n=0; n<b.length; n++){
	            os.write(b[n]);
	        }
	        os.flush();
			rs.close();
			ps.close();
			
			loc_conn.close();
	        os.close();
	        done=true;
        }
        catch(Exception z){
        	z.printStackTrace();
        }
    }
    else if("insurer.userlist".equalsIgnoreCase(sQueryType)){
        try{
	    	Connection loc_conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
			StringBuffer sResult = new StringBuffer();
			long l = 24*3600*1000;
			java.util.Date beginDate = ScreenHelper.parseDate(request.getParameter("begin"));
			java.util.Date endDate = ScreenHelper.parseDate(request.getParameter("end"));
			String insurer = checkString(request.getParameter("insureruid"));
			endDate.setTime(endDate.getTime()+l);
			query = "select dateofbirth,gender,oc_patientinvoice_date,personid,lastname,firstname,(select max(oc_encounter_serviceuid) from oc_encounters_view v where v.oc_encounter_objectid=e.oc_encounter_objectid) oc_encounter_serviceuid,oc_insurance_nr,"+
					" oc_patientinvoice_objectid,sum(oc_debet_insuraramount) insuraramount,sum(oc_debet_amount) patientamount"+
					" from oc_patientinvoices i,adminview a, oc_debets d,oc_encounters e,oc_insurances s"+
					" where"+
					" i.oc_patientinvoice_patientuid=a.personid and"+
					" d.oc_debet_patientinvoiceuid=i.oc_patientinvoice_serverid||'.'||i.oc_patientinvoice_objectid and"+
					" e.oc_encounter_objectid=replace(d.oc_debet_encounteruid,'1.','') and"+
					" s.oc_insurance_objectid=replace(oc_debet_insuranceuid,'1.','') and"+
					" s.oc_insurance_insuraruid=? and"+
					" i.oc_patientinvoice_date>=? and i.oc_patientinvoice_date<?"+
					" group by dateofbirth,gender,oc_patientinvoice_date,personid,lastname,firstname,oc_encounter_serviceuid,oc_insurance_nr,oc_patientinvoice_objectid"+
					" order by oc_patientinvoice_date,personid";
			Debug.println(query);
			PreparedStatement ps = loc_conn.prepareStatement(query);
			ps.setString(1,insurer);
			ps.setTimestamp(2, new Timestamp(beginDate.getTime()));
			ps.setTimestamp(3, new Timestamp(endDate.getTime()));
			ResultSet rs = ps.executeQuery();
			int counter = 1;
		    response.setContentType("application/octet-stream; charset=windows-1252");
		    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
		    
		    ServletOutputStream os = response.getOutputStream();
		    
		    // header
			sResult.append("DATE;PATIENTID;NAME;FIRSTNAME;AGE;BIRTHDATE;GENDER;DEPARTMENT;MEMBERNR;INVOICENR;PATIENTAMOUNT;INSURERAMOUNT\r\n");
			while(rs.next()){
				sResult.append(ScreenHelper.formatDate(getSqlDate(rs,"oc_patientinvoice_date"))+";");
				sResult.append(rs.getInt("personid")+";");
				sResult.append(rs.getString("lastname").toUpperCase()+";");
				sResult.append(rs.getString("firstname").toUpperCase()+";");
				java.util.Date dateofbirth = getSqlDate(rs,"dateofbirth");
				String age = "";
				try{
					int a = AdminPerson.getAge(dateofbirth);
					if(a<1){
						age = "0->11m";
					}
					else if(a<5){
						age = "12->59m";
					}
					else if(a<10){
						age = "5->9";
					}
					else if(a<10){
						age = "5->9";
					}
					else if(a<15){
						age = "10->14";
					}
					else if(a<20){
						age = "15->19";
					}
					else if(a<25){
						age = "20->24";
					}
					else if(a<50){
						age = "25->49";
					}
					else {
						age = "50+";
					}
				}
				catch(Exception e){
					// empty
				}
				sResult.append(age+";");
				sResult.append(ScreenHelper.formatDate(dateofbirth)+";");
				sResult.append(rs.getString("gender")+";");
				sResult.append(rs.getString("oc_encounter_serviceuid")+";");
				sResult.append(rs.getString("oc_insurance_nr")+";");
				sResult.append(rs.getString("oc_patientinvoice_objectid")+";");
				sResult.append(rs.getString("patientamount")+";");
				sResult.append(rs.getString("insuraramount")+";");
				sResult.append("\r\n");
			}
		    
		    byte[]b = sResult.toString().getBytes("ISO-8859-1");
	        for(int n=0; n<b.length; n++){
	            os.write(b[n]);
	        }
	        os.flush();
			rs.close();
			ps.close();
			
			loc_conn.close();
	        os.close();
	        done=true;
        }
        catch(Exception z){
        	z.printStackTrace();
        }
    }
    else if("cnrkr.burundi.consultationslist".equalsIgnoreCase(sQueryType)){
        try{
	    	Connection loc_conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
			StringBuffer sResult = new StringBuffer();
			String service=checkString(request.getParameter("service"));
			String doctor =checkString(request.getParameter("doctor"));
			String encountertypes="'ooo'";
			if(checkString(request.getParameter("includevisits")).equalsIgnoreCase("1")){
				encountertypes+=",'visit'";
			}
			if(checkString(request.getParameter("includeadmissions")).equalsIgnoreCase("1")){
				encountertypes+=",'admission'";
			}
			long l = 24*3600*1000;
			java.util.Date endDate = ScreenHelper.parseDate(request.getParameter("end"));
			endDate.setTime(endDate.getTime()+l);
			String childServices = Service.getChildIdsAsString(service);
			//We maken eerst een lijst van alle voorschriften die 
        }
        catch(Exception z){
        	z.printStackTrace();
        }
    }
    else if("pbf.burundi.consultationslist".equalsIgnoreCase(sQueryType)){
        try{
	    	Connection loc_conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
			StringBuffer sResult = new StringBuffer();
			String service=checkString(request.getParameter("service"));
			String doctor =checkString(request.getParameter("doctor"));
			String encountertypes="'ooo'";
			if(checkString(request.getParameter("includevisits")).equalsIgnoreCase("1")){
				encountertypes+=",'visit'";
			}
			if(checkString(request.getParameter("includeadmissions")).equalsIgnoreCase("1")){
				encountertypes+=",'admission'";
			}
			long l = 24*3600*1000;
			java.util.Date endDate = ScreenHelper.parseDate(request.getParameter("end"));
			endDate.setTime(endDate.getTime()+l);
			
			String childServices = Service.getChildIdsAsString(service);
	
			query = "select a.oc_encounter_serviceuid,oc_encounter_outcome,a.oc_encounter_situation,a.oc_encounter_objectid,a.oc_encounter_serverid,a.oc_encounter_begindate,b.personid,b.firstname,b.lastname,b.gender,b.dateofbirth,b.comment5,c.address,c.sector,c.cell,c.district,c.city from oc_encounters_view a,adminview b,privateview c where"+
			        " a.oc_encounter_patientuid=b.personid and"+
					" b.personid=c.personid and"+
					" a.oc_encounter_type in ("+encountertypes+") and"+
			        " oc_encounter_begindate>="+ MedwanQuery.getInstance().convertStringToDate("'<begin>'")+" and"+
			        " oc_encounter_begindate<"+ MedwanQuery.getInstance().convertStringToDate("'<end>'")+
					(service.length()>0?" and oc_encounter_serviceuid in ("+childServices+")":"")+
			        " order by oc_encounter_begindate,oc_encounter_objectid";
	        query = query.replaceAll("<begin>",request.getParameter("begin"))
	        		     .replaceAll("<end>",ScreenHelper.formatDate(endDate));
			Debug.println(query);
			PreparedStatement ps = loc_conn.prepareStatement(query);
			ResultSet rs = ps.executeQuery();
			int counter = 1;
		    response.setContentType("application/octet-stream; charset=windows-1252");
		    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
		    
		    ServletOutputStream os = response.getOutputStream();
		    
		    // header
			sResult.append("SERVICE;DATE;SITUATION;IDPERSONNE;PRENOM;NOM;SEXE;AGE;NAISSANCE;CHEF_FAMILLE;ADRESSE;PROVINCE;VILLAGE;COLLINE;MEDECIN;CIM10;DIAGNOSTIC/MOTIFCONTACT*;TRAITEMENT;STATUT;DUREE_GROSSESSE;ASSURANCE;CARTE;NOUVEAU_CAS;EVOLUTION;MALADIE_CHRONIQUE\r\n");
	    	byte[] b = sResult.toString().getBytes("ISO-8859-1");
	        for(int n=0; n<b.length; n++){
	            os.write(b[n]);
	        }
	        os.flush();
			sResult=new StringBuffer();
			
	        int activeEncounterObjectId=-1;
			while(rs.next()){
				try{
					int encounterServerId = rs.getInt("oc_encounter_serverid");
					int encounterObjectId=rs.getInt("oc_encounter_objectid");
					if(doctor.length()>0 && !hasPBFTransaction(encounterServerId+"."+encounterObjectId, doctor)){
						continue;
					}
					if(encounterObjectId==activeEncounterObjectId){
						//We don't want to show the same encounter multiple times
						continue;
					}
					activeEncounterObjectId=encounterObjectId;
					String personid=rs.getString("personid");
					sResult = new StringBuffer();
					sResult.append(getTranNoLink("service",checkString(rs.getString("oc_encounter_serviceuid")),sWebLanguage)+";");
					sResult.append(ScreenHelper.formatDate(getSqlDate(rs,"oc_encounter_begindate"))+";");
					sResult.append(ScreenHelper.getTranNoLink("encounter.situation",rs.getString("oc_encounter_situation"),sWebLanguage)+";");
					sResult.append(personid+";");
					sResult.append(ScreenHelper.removeAccents(checkString(rs.getString("firstname")).toUpperCase()).replaceAll("´", "'").replaceAll("`", "'")+";");
					sResult.append(ScreenHelper.removeAccents(checkString(rs.getString("lastname")).toUpperCase()).replaceAll("´", "'").replaceAll("`", "'")+";");
					sResult.append(rs.getString("gender").toUpperCase()+";");
					java.util.Date dateofbirth = getSqlDate(rs,"dateofbirth");
					String age = "";
					try{
						int a = AdminPerson.getAge(dateofbirth);
						if(a<1){
							age = "0->11m";
						}
						else if(a<5){
							age = "12->59m";
						}
						else if(a<10){
							age = "5->9";
						}
						else if(a<10){
							age = "5->9";
						}
						else if(a<15){
							age = "10->14";
						}
						else if(a<20){
							age = "15->19";
						}
						else if(a<25){
							age = "20->24";
						}
						else if(a<50){
							age = "25->49";
						}
						else {
							age = "50+";
						}
					}
					catch(Exception e){
						// empty
					}
					sResult.append(age+";");
					sResult.append(ScreenHelper.formatDate(dateofbirth)+";");
					sResult.append(ScreenHelper.removeAccents(checkString(rs.getString("comment5")).toUpperCase()).replaceAll("´", "'").replaceAll("`", "'")+";");
					String address ="";
					if(checkString(rs.getString("address")).length()>0){
						address+=rs.getString("address");	
					}
					if(checkString(rs.getString("cell")).length()>0){
						if(address.length()>0){
							address+=", ";
						}
						address+=rs.getString("cell");	
					}
					sResult.append(address==null?"":address.toUpperCase()+";");
					sResult.append(checkString(rs.getString("district")).toUpperCase()+";");
					sResult.append(checkString(rs.getString("sector")).toUpperCase()+";");
					sResult.append(checkString(rs.getString("city")).toUpperCase()+";");
					SortedSet hAuthors = new TreeSet(),hDiagcodes = new TreeSet(),hDiaglabels = new TreeSet();
					String newcase="0",chronic="0";
					//Now add the diagnoses for the Encounter
					if(checkString(request.getParameter("diagsicd10")).equalsIgnoreCase("1")){
						Vector diagnoses = Diagnosis.selectDiagnoses("", "", MedwanQuery.getInstance().getConfigString("serverId")+"."+encounterObjectId, doctor, "", "", "", "", "", "", "", "icd10", "");
						for(int n=0;n<diagnoses.size();n++){
							try{
								Diagnosis diagnosis = (Diagnosis)diagnoses.elementAt(n);
								hAuthors.add(User.getFullUserName(diagnosis.getAuthorUID()));
								hDiagcodes.add(diagnosis.getCode().toUpperCase());
								hDiaglabels.add(MedwanQuery.getInstance().getDiagnosisLabel("icd10", diagnosis.getCode(), sWebLanguage));
								if(diagnosis.getNC().equalsIgnoreCase("1")){
									newcase="1";
								}
								if(diagnosis.getFlags().contains("T")){
									chronic="1";
								}
							}
							catch(Exception d){}
						}
					}
					if(checkString(request.getParameter("diagsrfe")).equalsIgnoreCase("1")){
						Vector rfes = ReasonForEncounter.getReasonsForEncounterByEncounterUid(MedwanQuery.getInstance().getConfigString("serverId")+"."+encounterObjectId);
						for(int n=0;n<rfes.size();n++){
							ReasonForEncounter rfe = (ReasonForEncounter)rfes.elementAt(n);
							if(rfe.getCodeType().equalsIgnoreCase("icd10")){
								try{
									hAuthors.add(User.getFullUserName(rfe.getAuthorUID()));
									hDiagcodes.add(rfe.getCode().toUpperCase());
									hDiaglabels.add(MedwanQuery.getInstance().getDiagnosisLabel("icd10", rfe.getCode(), sWebLanguage));
									if(rfe.getFlags().contains("N")){
										newcase="1";
									}
								}
								catch(Exception d){}
							}
						}
					}
					if(checkString(request.getParameter("diagsfreetext")).equalsIgnoreCase("1")){
						HashSet hFree = Encounter.getFreeTextDiagnoses(MedwanQuery.getInstance().getConfigString("serverId")+"."+encounterObjectId);
						Iterator iFree = hFree.iterator();
						while(iFree.hasNext()){
							String[] diaglabel=((String)iFree.next()).split(";");
							hAuthors.add(diaglabel[0]);
							hDiagcodes.add(diaglabel[1]);
							hDiaglabels.add(diaglabel[2]);
						}
					}
					
					if(hAuthors.size()==0){
						sResult.append("-;");
					}
					else{
						Iterator i = hAuthors.iterator();
						while(i.hasNext()){
							sResult.append(i.next());
							if(i.hasNext()){
								sResult.append(", ");
							}
						}
						sResult.append(";");
					}
					if(hDiagcodes.size()==0){
						sResult.append("-;");
					}
					else{
						Iterator i = hDiagcodes.iterator();
						while(i.hasNext()){
							sResult.append(i.next());
							if(i.hasNext()){
								sResult.append(", ");
							}
						}
						sResult.append(";");
					}
					if(hDiaglabels.size()==0){
						sResult.append("-;");
					}
					else{
						Iterator i = hDiaglabels.iterator();
						while(i.hasNext()){
							sResult.append(((String)i.next()).replaceAll("\n", " ").replaceAll("\r", ""));
							if(i.hasNext()){
								sResult.append(", ");
							}
						}
						sResult.append(";");
					}
					//Add Treatment here
					Vector treatments = MedwanQuery.getInstance().getEncounterItems(encounterServerId+"."+encounterObjectId, "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_TREATMENT");
					for(int n=0;n<treatments.size();n++){
						try{
							ItemVO item = (ItemVO)treatments.elementAt(n);
							sResult.append(ScreenHelper.removeAccents(item.getValue()).replaceAll("´", "'").replaceAll("`", "'").toUpperCase().replaceAll("\n", ", ").replaceAll("\r", "").replaceAll(";", ",")+" ");
						}
						catch(Exception d){
						}
					}
					sResult.append(";");
					//Add Status here
					treatments = MedwanQuery.getInstance().getEncounterItems(encounterServerId+"."+encounterObjectId, "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_PATIENTTYPE2");
					for(int n=0;n<treatments.size();n++){
						try{
							ItemVO item = (ItemVO)treatments.elementAt(n);
							sResult.append(getTranNoLink("outpatient.type2",item.getValue(),sWebLanguage)+" ");
						}
						catch(Exception d){
						}
					}
					sResult.append(";");
					//Add Pregnancy duration here
					treatments = MedwanQuery.getInstance().getEncounterItems(encounterServerId+"."+encounterObjectId, "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE");
					if(treatments.size()>0){
						try{
							ItemVO item = (ItemVO)treatments.elementAt(0);
							sResult.append(item.getValue()+" ");
						}
						catch(Exception d){
						}
					}
					sResult.append(";");
					//Add insurancedata here
					Insurance insurance = Insurance.getDefaultInsuranceForPatient(personid);
					if(insurance!=null && insurance.getInsurar()!=null){
						sResult.append(insurance.getInsurar().getName()+";"+insurance.getInsuranceNr());
					}
					else{
						sResult.append(";");
					}
					sResult.append(";"+newcase);
					sResult.append(";"+getTranNoLink(MedwanQuery.getInstance().getConfigString("encounterOutcomeType","encounter.outcome"),rs.getString("oc_encounter_outcome"),sWebLanguage));
					sResult.append(";"+chronic);
					
					sResult.append("\r\n");
			    	b = sResult.toString().getBytes("ISO-8859-1");
			        for(int n=0; n<b.length; n++){
			            os.write(b[n]);
			        }
			        os.flush();
					sResult=new StringBuffer();
				}
				catch(Exception o){
					o.printStackTrace();
				}

			}
			rs.close();
			ps.close();
			
			loc_conn.close();
	        os.close();
	        done=true;
        }
        catch(Exception z){
        	z.printStackTrace();
        }
    }
    else if("pbf.burundi.admissionslist".equalsIgnoreCase(sQueryType)){
        try{
    	Connection loc_conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
		StringBuffer sResult = new StringBuffer();
		String service=checkString(request.getParameter("service"));
		String doctor =checkString(request.getParameter("doctor"));
		long day = 24*3600*1000;
		java.util.Date endDate = ScreenHelper.parseDate(request.getParameter("end"));
		endDate.setTime(endDate.getTime()+day);
		
		String childServices = Service.getChildIdsAsString(service);

		// search all the invoices from this period     
		query = "select personid,lastname,firstname,gender,dateofbirth,oc_encounter_origin,oc_encounter_begindate, oc_encounter_enddate,oc_encounter_outcome,oc_encounter_serverid,oc_encounter_objectid"+
		        " from oc_encounters a, adminview b where"+
				" ((oc_encounter_begindate>="+MedwanQuery.getInstance().convertStringToDate("'<begin>'")+" and oc_encounter_begindate<"+MedwanQuery.getInstance().convertStringToDate("'<end>'")+") OR (oc_encounter_enddate>="+MedwanQuery.getInstance().convertStringToDate("'<begin>'")+" and oc_encounter_enddate<"+MedwanQuery.getInstance().convertStringToDate("'<end>'")+")) and"+
				" oc_encounter_type='admission' and"+
		        " personid=oc_encounter_patientuid "+
				(service.length()>0?" and oc_encounter_serviceuid in ("+childServices+")":"")+
		        " order by oc_encounter_begindate,oc_encounter_objectid";
        query = query.replaceAll("<begin>",request.getParameter("begin"))
        		     .replaceAll("<end>",ScreenHelper.formatDate(endDate));
		Debug.println(query);
		PreparedStatement ps = loc_conn.prepareStatement(query);
		ResultSet rs = ps.executeQuery();
		int counter = 1;
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
	    
	    ServletOutputStream os = response.getOutputStream();
	    
	    // header
		sResult.append("IDPERSONNE;NOM;PRENOM;SEXE;NAISSANCE;AGE;ARRIVEE;ORIGINZ;DEPART;DUREE;EVOLUTION;CIM10_ARRIVEE;CIM10_SORTIE;PAIEMENT;SERVICE\r\n");
	    
    	byte[] b = sResult.toString().getBytes("ISO-8859-1");
        for(int n=0; n<b.length; n++){
            os.write(b[n]);
        }
        os.flush();
        int activeEncounterObjectId=-1;
        Vector records = new Vector();
		while(rs.next()){
			Hashtable ht = new Hashtable();
			ht.put("oc_encounter_serverid",rs.getInt("oc_encounter_serverid"));
			ht.put("oc_encounter_objectid",rs.getInt("oc_encounter_objectid"));
			ht.put("personid",rs.getInt("personid"));
			ht.put("lastname",SH.c(rs.getString("lastname")));
			ht.put("firstname",SH.c(rs.getString("firstname")));
			ht.put("gender",SH.c(rs.getString("gender")));
			if(rs.getDate("dateofbirth")!=null){
				ht.put("dateofbirth",rs.getDate("dateofbirth"));
			}
			ht.put("oc_encounter_begindate",rs.getTimestamp("oc_encounter_begindate"));
			if(rs.getTimestamp("oc_encounter_enddate")!=null){
				ht.put("oc_encounter_enddate",rs.getTimestamp("oc_encounter_enddate"));
			}
			ht.put("oc_encounter_origin",SH.c(rs.getString("oc_encounter_origin")));
			ht.put("oc_encounter_outcome",SH.c(rs.getString("oc_encounter_outcome")));
			records.add(ht);
		}
		rs.close();
		ps.close();
		for(int r=0;r<records.size();r++){
			Hashtable ht = (Hashtable)records.elementAt(r);
			int encounterServerId = (Integer)ht.get("oc_encounter_serverid");
			int encounterObjectId=(Integer)ht.get("oc_encounter_objectid");
			
			sResult = new StringBuffer();
			int personid = (Integer)ht.get("personid");
			sResult.append(personid+";");
			sResult.append(((String)ht.get("lastname")).toUpperCase().replaceAll(";","")+";");
			sResult.append(((String)ht.get("firstname")).toUpperCase().replaceAll(";","")+";");
			sResult.append(((String)ht.get("gender")).toUpperCase()+";");
			String age = "";
			if(ht.get("dateofbirth")!=null){
				java.util.Date dateofbirth = new java.util.Date(((java.sql.Date)ht.get("dateofbirth")).getTime());
				sResult.append(ScreenHelper.formatDate(dateofbirth)+";");
				try{
					int a = AdminPerson.getAge(dateofbirth);
					if(a<1){
						age = "0->11m";
					}
					else if(a<5){
						age = "12->59m";
					}
					else if(a<10){
						age = "5->9";
					}
					else if(a<10){
						age = "5->9";
					}
					else if(a<15){
						age = "10->14";
					}
					else if(a<20){
						age = "15->19";
					}
					else if(a<25){
						age = "20->24";
					}
					else if(a<50){
						age = "25->49";
					}
					else {
						age = "50+";
					}
				}
				catch(Exception e){
					// empty
				}
			}
			else{
				sResult.append(";");
			}
			sResult.append(age+";");
			java.util.Date begindate = new java.util.Date(((java.sql.Timestamp)ht.get("oc_encounter_begindate")).getTime());
			java.util.Date enddate = null;
			try{
				enddate = new java.util.Date(((java.sql.Timestamp)ht.get("oc_encounter_enddate")).getTime());
			}
			catch(Exception ex){}
			sResult.append(new SimpleDateFormat("dd/MM/yyyy HH:mm").format(begindate)+";");
			sResult.append(ScreenHelper.removeAccents(getTranNoLink("urgency.origin",(String)ht.get("oc_encounter_origin"),sWebLanguage)).toUpperCase()+";");
			if(enddate!=null){
				sResult.append(new SimpleDateFormat("dd/MM/yyyy HH:mm").format(enddate)+";");
				sResult.append(((enddate.getTime()-begindate.getTime())/day+1)+";");
			}
			else{
				sResult.append(";;");
			}
			sResult.append(ScreenHelper.removeAccents(getTranNoLink("encounter.outcome",(String)ht.get("oc_encounter_outcome"),sWebLanguage)).toUpperCase()+";");
			
			//Find ICD10 codes on addmission
			String freetext="";
			HashSet admissionDiagnoses = new HashSet();
			Vector admissions = MedwanQuery.getInstance().getTransactionsByType(personid, "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_HPRC_ADMISSION",encounterServerId+"."+encounterObjectId);
			for(int n=0;n<admissions.size();n++){
				TransactionVO transaction = (TransactionVO)admissions.elementAt(n);
				if(transaction!=null){
					Collection items = transaction.getItems();
					Iterator i = items.iterator();
					while(i.hasNext()){
						ItemVO item = (ItemVO)i.next();
						if(item.getType().startsWith("ICD10Code")){
							admissionDiagnoses.add(item.getType().replaceAll("ICD10Code", "")+" "+MedwanQuery.getInstance().getCodeTran(item.getType().toLowerCase(), sWebLanguage));
						}
						else if(item.getType().equalsIgnoreCase("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_DIAGNOSIS")){
							freetext=item.getValue();
						}
					}
				}
			}
			admissions = MedwanQuery.getInstance().getTransactionsByType(personid, "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_SST_ADMISSION",encounterServerId+"."+encounterObjectId);
			for(int n=0;n<admissions.size();n++){
				TransactionVO transaction = (TransactionVO)admissions.elementAt(n);
				if(transaction!=null){
					Collection items = transaction.getItems();
					Iterator i = items.iterator();
					while(i.hasNext()){
						ItemVO item = (ItemVO)i.next();
						if(item.getType().startsWith("ICD10Code")){
							admissionDiagnoses.add(item.getType().replaceAll("ICD10Code", "")+" "+MedwanQuery.getInstance().getCodeTran(item.getType().toLowerCase(), sWebLanguage));
						}
					}
				}
			}
			Iterator it = admissionDiagnoses.iterator();
			boolean bInit =false;
			while(it.hasNext()){
				if(bInit){
					sResult.append(", ");
				}
				sResult.append(((String)it.next()).replaceAll("\n", " ").replaceAll("\r", ""));
				bInit=true;
			}
			if(freetext.length()>0){
				if(bInit){
					sResult.append(", ");
				}
				sResult.append(freetext.replaceAll(";","").replaceAll("\n", " ").replaceAll("\r", ""));
			}
			sResult.append(";");

			//Find ICD10 codes and paymenttypes on discharge
			String paymenttype="";
			HashSet dischargeDiagnoses = new HashSet();
			Vector discharges = MedwanQuery.getInstance().getTransactionsByType(personid, "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_HPRC_DISCHARGE",encounterServerId+"."+encounterObjectId);
			for(int n=0;n<discharges.size();n++){
				TransactionVO transaction = (TransactionVO)discharges.elementAt(n);
				if(transaction!=null){
					Collection items = transaction.getItems();
					Iterator i = items.iterator();
					while(i.hasNext()){
						ItemVO item = (ItemVO)i.next();
						if(item.getType().startsWith("ICD10Code")){
							dischargeDiagnoses.add(item.getType().replaceAll("ICD10Code", "")+" "+MedwanQuery.getInstance().getCodeTran(item.getType().toLowerCase(), sWebLanguage));
						}
						else if(item.getType().equalsIgnoreCase("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PAYMENT_TYPE")){
							paymenttype=item.getValue();
						}
					}
				}
			}
			discharges = MedwanQuery.getInstance().getTransactionsByType(personid, "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_SST_ADMISSION",encounterServerId+"."+encounterObjectId);
			for(int n=0;n<discharges.size();n++){
				TransactionVO transaction = (TransactionVO)discharges.elementAt(n);
				if(transaction!=null){
					Collection items = transaction.getItems();
					Iterator i = items.iterator();
					while(i.hasNext()){
						ItemVO item = (ItemVO)i.next();
						if(item.getType().startsWith("ICD10Code")){
							dischargeDiagnoses.add(item.getType().replaceAll("ICD10Code", "")+" "+MedwanQuery.getInstance().getCodeTran(item.getType().toLowerCase(), sWebLanguage));
						}
					}
				}
			}
			it = dischargeDiagnoses.iterator();
			bInit =false;
			while(it.hasNext()){
				if(bInit){
					sResult.append(", ");
				}
				sResult.append(((String)it.next()).replaceAll("\n", " ").replaceAll("\r", ""));
				bInit=true;
			}
			sResult.append(";");
			sResult.append(ScreenHelper.removeAccents(getTranNoLink("payment.type",paymenttype,sWebLanguage)).toUpperCase()+";");
			
			Encounter encounter = Encounter.get(encounterServerId+"."+encounterObjectId);
			PreparedStatement ps2 = loc_conn.prepareStatement("select distinct oc_encounter_serviceuid from oc_encounters_view where oc_encounter_serverid=? and oc_encounter_objectid=?");
			ps2.setInt(1,encounterServerId);
			ps2.setInt(2,encounterObjectId);
			ResultSet rs2 = ps2.executeQuery();
			bInit =false;
			while(rs2.next()){
				if(bInit){
					sResult.append(", ");
				}
				sResult.append(rs2.getString("oc_encounter_serviceuid"));
				bInit=true;
			}
			rs2.close();
			ps2.close();
			sResult.append(";");
			
			sResult.append("\r\n");
	    	b = sResult.toString().getBytes("ISO-8859-1");
	        for(int n=0; n<b.length; n++){
	            os.write(b[n]);
	        }
	        os.flush();
		}
		
		loc_conn.close();
        os.close();
        done=true;
        }
        catch(Exception z){
        	z.printStackTrace();
        }
    }
	//*** 8 - GLOBAL LIST ************************************************
    else if("global.list".equalsIgnoreCase(sQueryType)){
        Connection loc_conn = MedwanQuery.getInstance().getLongOpenclinicConnection(),
    	           lad_conn = MedwanQuery.getInstance().getLongAdminConnection();
		StringBuffer sResult = null;
		
		// search all encounters from this period
		query = "select * from oc_encounters_view a, adminview b"+
		        " where a.oc_encounter_patientuid = b.personid"+
         		"  and OC_ENCOUNTER_BEGINDATE <= "+ MedwanQuery.getInstance().convertStringToDate("'<end>'")+
		        "  and OC_ENCOUNTER_BEGINDATE >= "+ MedwanQuery.getInstance().convertStringToDate("'<begin>'")+
		        " ORDER BY oc_encounter_objectid";
        query = query.replaceAll("<begin>",request.getParameter("begin"))
        		     .replaceAll("<end>",request.getParameter("end"));
        System.out.println("QUERY ===== "+query);
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		Debug.println(query);
		PreparedStatement ps = loc_conn.prepareStatement(query);
		ResultSet rs = ps.executeQuery();
		SortedMap results = new TreeMap();
		while(rs.next()){
			String id = rs.getString("oc_encounter_serverid")+"_"+rs.getString("oc_encounter_objectid");

			sResult = new StringBuffer();
			sResult.append(id+";");			
			sResult.append(checkString(rs.getString("oc_encounter_type"))+";");			
			
			java.util.Date dbegin = getSqlDate(rs,"oc_encounter_begindate");
			sResult.append(dbegin==null?";":ScreenHelper.stdDateFormat.format(dbegin)+";");		
			
			java.util.Date dend = getSqlDate(rs,"oc_encounter_enddate");
			sResult.append(dend==null?";":ScreenHelper.stdDateFormat.format(dend)+";");			
			
			String patientid = checkString(rs.getString("oc_encounter_patientuid"));
			sResult.append(patientid+";");		
			
			java.util.Date dob = null;
			try{
				dob=getSqlDate(rs,"dateofbirth");
			}
			catch(Exception e){}
			sResult.append(dob==null?";":new SimpleDateFormat("MM/yyyy").format(dob)+";");			
			sResult.append(checkString(rs.getString("gender"))+";");		
		
			try{
				long year = 1000*3600;
				year = year*24*365;
				long age = dbegin.getTime()-dob.getTime();
				age = age/year;
				
				sResult.append(age+";");
			}
			catch(Exception q){
				sResult.append(";");
			}
			
			sResult.append(checkString(rs.getString("oc_encounter_outcome"))+";");		
			sResult.append(checkString(rs.getString("oc_encounter_destinationuid"))+";");		
			sResult.append(checkString(rs.getString("oc_encounter_origin"))+";");
			
			String serviceid = checkString(rs.getString("oc_encounter_serviceuid")).replaceAll("\\.","_");
			sResult.append(serviceid+";");
			
			sResult.append(checkString(rs.getString("oc_encounter_beduid")).replaceAll("\\.","_")+";");
			sResult.append(checkString(rs.getString("oc_encounter_manageruid")).replaceAll("\\.","_")+";");
			sResult.append(checkString(rs.getString("oc_encounter_updateuid")).replaceAll("\\.","_")+";");
			
			results.put(id+";"+patientid+";"+(dbegin==null?"":new SimpleDateFormat("yyyyMMddHHmmsss").format(dbegin))+";"+serviceid,sResult.toString());
		}
		
		Iterator iResults = results.keySet().iterator();
		sResult = new StringBuffer();
		
		// header
		sResult.append("CODE;TYPE;BEGINDATE;ENDDATE;PATIENT_CODE;MONTH_OF_BIRTH;GENDER;AGE;OUTCOME;DESTINATION;ORIGIN;"+
		               "CODE_SERVICE;CODE_BED;CODE_WARDMANAGER;ENCODER;DISTRICT;INSURER;CODE_USER;TYPE;DIAGCODE;LABEL;CERTAINTY;GRAVITY\r\n");
		
		while(iResults.hasNext()){
			String line = (String)iResults.next();
			String content = (String)results.get(line);
			
			// Add the district
			ps2 = lad_conn.prepareStatement("select * from adminprivate where personid="+line.split(";")[1]);
			rs2 = ps2.executeQuery();
			if(rs2.next()){
				content+= rs2.getString("district")+";";
			}
			else{
				content+= ";";
			}
			rs2.close();
			ps2.close();
			
			// Add insurer
			query = "select max(OC_INSURAR_NAME) as INSURER"+
			        " from OC_INSURARS q, OC_INSURANCES r, OC_DEBETS s"+
			        "  where q.oc_insurar_objectid = replace(r.oc_insurance_insuraruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')"+
			        "   and r.oc_insurance_objectid = replace(s.oc_debet_insuranceuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')"+
			        "   and s.oc_debet_encounteruid='"+line.split(";")[0].replaceAll("\\_", ".")+"'";
			ps2 = loc_conn.prepareStatement(query);
			rs2 = ps2.executeQuery();
			if(rs2.next()){
				content+= checkString(rs2.getString("insurer"))+";";
			}
			else{
				content+= ";";
			}
			rs2.close();
			ps2.close();
			
			// Add reasons for encounter
			ps2 = loc_conn.prepareStatement("select * from OC_DIAGNOSES"+
			                                " where OC_DIAGNOSIS_ENCOUNTERUID='"+line.split(";")[0].replaceAll("\\_", ".")+"'");
			rs2 = ps2.executeQuery();
			
			boolean bHasDiags=false;
			while(rs2.next()){
				bHasDiags = true;
				String codetype = checkString(rs2.getString("OC_DIAGNOSIS_CODETYPE"));
				String code = checkString(rs2.getString("OC_DIAGNOSIS_CODE"));
				
				sResult.append(content+checkString(rs2.getString("OC_DIAGNOSIS_AUTHORUID"))+";"+codetype+";"+code+";"+MedwanQuery.getInstance().getCodeTran((codetype.toLowerCase().startsWith("icpc")?"icpccode":"icd10code")+code, sWebLanguage)+";"+checkString(rs2.getString("OC_DIAGNOSIS_CERTAINTY"))+";"+checkString(rs2.getString("OC_DIAGNOSIS_GRAVITY"))+";\r\n");
			}
			rs2.close();
			ps2.close();
			
			if(!bHasDiags){
				sResult.append(content+";"+";"+";"+";"+";"+"\r\n");
			}
		}
		rs.close();
		ps.close();
		
        loc_conn.close();
        lad_conn.close();
        
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
	   
	    ServletOutputStream os = response.getOutputStream();
    	byte[] b = sResult.toString().getBytes("ISO-8859-1");
        for(int n=0; n<b.length; n++){
            os.write(b[n]);
        }
        os.flush();
        os.close();
        done=true;
    }
	//*** 9 - GLOBAL RFE *************************************************
    else if("globalrfe.list".equalsIgnoreCase(sQueryType)){
        Connection loc_conn = MedwanQuery.getInstance().getLongOpenclinicConnection(),
    	           lad_conn = MedwanQuery.getInstance().getLongAdminConnection();
		StringBuffer sResult = null;
		
		// First we search all encounters from this period
		query = "select * from oc_encounters_view a, adminview b where a.oc_encounter_patientuid=b.personid and "+
		        " OC_ENCOUNTER_BEGINDATE<="+ MedwanQuery.getInstance().convertStringToDate("'<end>'")+" AND"+
		        " OC_ENCOUNTER_BEGINDATE>="+ MedwanQuery.getInstance().convertStringToDate("'<begin>'")+" ORDER BY oc_encounter_objectid";
        query = query.replaceAll("<begin>",request.getParameter("begin"))
        		     .replaceAll("<end>",request.getParameter("end"));
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		PreparedStatement ps = loc_conn.prepareStatement(query);
		ResultSet rs = ps.executeQuery();
		SortedMap results = new TreeMap();
		while(rs.next()){
			sResult = new StringBuffer();
			
			String id = rs.getString("oc_encounter_serverid")+"_"+rs.getString("oc_encounter_objectid");
			sResult.append(id+";");
			
			sResult.append(checkString(rs.getString("oc_encounter_type"))+";");			
			
			java.util.Date dbegin = getSqlDate(rs,"oc_encounter_begindate");
			sResult.append(dbegin==null?";":ScreenHelper.stdDateFormat.format(dbegin)+";");		
			
			java.util.Date dend = getSqlDate(rs,"oc_encounter_enddate");
			sResult.append(dend==null?";":ScreenHelper.stdDateFormat.format(dend)+";");			
			
			String patientid = checkString(rs.getString("oc_encounter_patientuid"));
			sResult.append(patientid+";");		
			
			java.util.Date dob = getSqlDate(rs,"dateofbirth");
			sResult.append(dob==null?";":new SimpleDateFormat("MM/yyyy").format(dob)+";");			
			sResult.append(checkString(rs.getString("gender"))+";");		
			
			try{
				long year = 1000*3600;
				year = year*24*365;
				long age = dbegin.getTime()-dob.getTime();
				age = age/year;
				
				sResult.append(age+";");
			}
			catch(Exception q){
				sResult.append(";");
			}
			
			sResult.append(checkString(rs.getString("oc_encounter_outcome"))+";");		
			sResult.append(checkString(rs.getString("oc_encounter_destinationuid"))+";");		
			sResult.append(checkString(rs.getString("oc_encounter_origin"))+";");
			
			String serviceid = checkString(rs.getString("oc_encounter_serviceuid")).replaceAll("\\.","_");
			sResult.append(serviceid+";");
			
			sResult.append(checkString(rs.getString("oc_encounter_beduid")).replaceAll("\\.","_")+";");
			sResult.append(checkString(rs.getString("oc_encounter_manageruid")).replaceAll("\\.","_")+";");
			sResult.append(checkString(rs.getString("oc_encounter_updateuid")).replaceAll("\\.","_")+";");
			
			results.put(id+";"+patientid+";"+(dbegin==null?"":new SimpleDateFormat("yyyyMMddHHmmsss").format(dbegin))+";"+serviceid,sResult.toString());
		}
		
		Iterator iResults = results.keySet().iterator();
		sResult = new StringBuffer();
		
		// header
		sResult.append("CODE;TYPE;BEGINDATE;ENDDATE;PATIENT_CODE;MONTH_OF_BIRTH;GENDER;AGE;OUTCOME;DESTINATION;"+
		               "ORIGIN;CODE_SERVICE;CODE_BED;CODE_WARDMANAGER;ENCODER;DISTRICT;INSURER;CODE_USER;TYPE;"+
				       "DIAGCODE;LABEL;CERTAINTY;GRAVITY\r\n");
		
		while(iResults.hasNext()){
			String line =(String)iResults.next();
			String content = (String)results.get(line);
		
			// Add the district
			ps2 = lad_conn.prepareStatement("select * from adminprivate where personid="+line.split(";")[1]);
			rs2 = ps2.executeQuery();
			if(rs2.next()){
				content+= rs2.getString("district")+";";
			}
			else{
				content+= ";";
			}
			rs2.close();
			ps2.close();
			
			// Add insurer
			query = "select max(OC_INSURAR_NAME) as INSURER"+
			        " from OC_INSURARS q, OC_INSURANCES r, OC_DEBETS s"+
			        "  where q.oc_insurar_objectid = replace(r.oc_insurance_insuraruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')"+
			        "   and r.oc_insurance_objectid = replace(s.oc_debet_insuranceuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')"+
			        "   and s.oc_debet_encounteruid = '"+line.split(";")[0].replaceAll("\\_", ".")+"'";
			ps2 = loc_conn.prepareStatement(query);
			rs2 = ps2.executeQuery();
			if(rs2.next()){
				content+= checkString(rs2.getString("insurer"))+";";
			}
			else{
				content+= ";";
			}
			rs2.close();
			ps2.close();
			
			// Add reasons for encounter
			ps2 = loc_conn.prepareStatement("select * from OC_RFE where OC_RFE_ENCOUNTERUID='"+line.split(";")[0].replaceAll("\\_", ".")+"'");
			rs2 = ps2.executeQuery();
			boolean bHasRfe = false;
			while(rs2.next()){
				bHasRfe = true;
				
				String codetype = checkString(rs2.getString("OC_RFE_CODETYPE"));
				String code = checkString(rs2.getString("OC_RFE_CODE"));
				
				sResult.append(content+checkString(rs2.getString("OC_RFE_UPDATEUID"))+";"+codetype+";"+code+";"+MedwanQuery.getInstance().getCodeTran((codetype.toLowerCase().startsWith("icpc")?"icpccode":"icd10code")+code, sWebLanguage)+";"+(checkString(rs2.getString("OC_RFE_FLAGS")).indexOf("N")>-1?"NEW":"OLD")+";\r\n");
			}
			rs2.close();
			ps2.close();
			
			if(!bHasRfe){
				sResult.append(content+";"+";"+";"+";"+";"+"\r\n");
			}
		}
		rs.close();
		ps.close();
		
        loc_conn.close();
        lad_conn.close();
        
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition","Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
	   
	    ServletOutputStream os = response.getOutputStream();
    	byte[] b = sResult.toString().getBytes("ISO-8859-1");
        for(int n=0; n<b.length; n++){
            os.write(b[n]);
        }
        os.flush();
        os.close();
        done=true;
    }
	//*** 10 - COUNTERS **************************************************
    else if("encounter.list".equalsIgnoreCase(sQueryType)){
        query = "select "+ MedwanQuery.getInstance().convert("varchar(10)","OC_ENCOUNTER_SERVERID")+MedwanQuery.getInstance().concatSign()+"'_'"+MedwanQuery.getInstance().concatSign()+ MedwanQuery.getInstance().convert("varchar(10)","OC_ENCOUNTER_OBJECTID")+" as CODE,"+
                "  OC_ENCOUNTER_TYPE as TYPE, OC_ENCOUNTER_BEGINDATE as BEGINDATE, OC_ENCOUNTER_ENDDATE as ENDDATE,"+
                "  OC_ENCOUNTER_PATIENTUID as CODE_PATIENT,substring("+MedwanQuery.getInstance().convertDateToString("dateofbirth")+",4,10) as MONTH_OF_BIRTH,"+
                "  gender as GENDER,OC_ENCOUNTER_OUTCOME as OUTCOME, OC_ENCOUNTER_DESTINATIONUID as DESTINATION, OC_ENCOUNTER_ORIGIN as ORIGIN,"+
                "  district as DISTRICT,replace(OC_ENCOUNTER_SERVICEUID,'.','_') as CODE_SERVICE,replace(OC_ENCOUNTER_BEDUID,'.','_') as CODE_LIT,"+
                "  replace(OC_ENCOUNTER_MANAGERUID,'.','_') as CODE_WARD, OC_ENCOUNTER_UPDATEUID as ENCODER"+
		        " from OC_ENCOUNTERS_VIEW, AdminView a, PrivateView b"+
		        "  where OC_ENCOUNTER_PATIENTUID = a.personid"+
		        "   and b.personid = a.personid"+
		        "   and b.stop is null"+
		        "   and OC_ENCOUNTER_BEGINDATE <= "+MedwanQuery.getInstance().convertStringToDate("'<end>'")+
		        "   and OC_ENCOUNTER_ENDDATE >= "+MedwanQuery.getInstance().convertStringToDate("'<begin>'")+
		        " union "+
		        "select "+MedwanQuery.getInstance().convert("varchar(10)","OC_ENCOUNTER_SERVERID")+MedwanQuery.getInstance().concatSign()+"'_'"+MedwanQuery.getInstance().concatSign()+ MedwanQuery.getInstance().convert("varchar(10)","OC_ENCOUNTER_OBJECTID")+" as CODE,"+
		        "  OC_ENCOUNTER_TYPE as TYPE, OC_ENCOUNTER_BEGINDATE as BEGINDATE, OC_ENCOUNTER_ENDDATE as ENDDATE,"+
		        "  OC_ENCOUNTER_PATIENTUID as CODE_PATIENT,substring("+ MedwanQuery.getInstance().convertDateToString("dateofbirth")+",4,10) as MONTH_OF_BIRTH,"+
		        "  gender GENDER,OC_ENCOUNTER_OUTCOME as OUTCOME, OC_ENCOUNTER_DESTINATIONUID as DESTINATION, OC_ENCOUNTER_ORIGIN as ORIGIN,"+
		        "  null as DISTRICT,replace(OC_ENCOUNTER_SERVICEUID,'.','_') as CODE_SERVICE,replace(OC_ENCOUNTER_BEDUID,'.','_') as CODE_LIT,"+
		        "  replace(OC_ENCOUNTER_MANAGERUID,'.','_') as CODE_WARD, OC_ENCOUNTER_UPDATEUID as ENCODER"+
		        " from OC_ENCOUNTERS_VIEW, AdminView a"+
		        "  where OC_ENCOUNTER_PATIENTUID = a.personid"+
		        "   and not exists (select * from PrivateView where personid = a.personid)"+
		        "   and OC_ENCOUNTER_BEGINDATE <= "+ MedwanQuery.getInstance().convertStringToDate("'<end>'")+
		        "   and OC_ENCOUNTER_ENDDATE >= "+MedwanQuery.getInstance().convertStringToDate("'<begin>'")+
                " order by CODE";
    }
	//*** 11 - WICKET CREDITS ********************************************
    else if("wicketcredits.list".equalsIgnoreCase(sQueryType)){
        query = "select oc_wicket_credit_operationdate as DATE,a.oc_label_value as CASHDESK,b.oc_label_value as TYPE,"+MedwanQuery.getInstance().convert("int","oc_wicket_credit_amount")+" as AMOUNT,"+
                "  oc_wicket_credit_comment as COMMENT, oc_wicket_credit_invoiceuid as REF_INVOICE,"+
                "  lastname as USERLASTNAME, firstname as USERFIRSTNAME"+
        		" from oc_wicket_credits, oc_wickets, oc_labels a, oc_labels b, usersview c, adminview d"+
        		"  where oc_wicket_credit_updateuid = userid"+
        		"   and c.personid = d.personid"+
        		"   and oc_wicket_credit_operationdate >= "+MedwanQuery.getInstance().convertStringToDate("'<begin>'")+
        		"   and oc_wicket_credit_operationdate < "+MedwanQuery.getInstance().convertStringToDate("'<end>'")+
        		"   and oc_wicket_objectid = replace(oc_wicket_credit_wicketuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','')"+
        		"   and a.oc_label_type = 'service'"+
        		"   and a.oc_label_id = oc_wicket_serviceuid"+
        		"   and a.oc_label_language = '"+sWebLanguage+"'"+
        		"   and b.oc_label_type = 'credit.type'"+
        		"   and b.oc_label_id = oc_wicket_credit_type"+
        		"   and b.oc_label_language = '"+sWebLanguage+"'"+
        		" order by DATE";
    }
	//*** 12 - DIAGNOSES *************************************************
    else if("diagnosis.list".equalsIgnoreCase(sQueryType)){
        query = "select replace(OC_DIAGNOSIS_ENCOUNTERUID,'.','_') as CODE_CONTACT, OC_DIAGNOSIS_AUTHORUID as CODE_USER,"+
                "  OC_DIAGNOSIS_CODETYPE as TYPE, OC_DIAGNOSIS_CODE as CODE,"+
                "  (CASE OC_DIAGNOSIS_CODETYPE"+
                "    WHEN 'icpc'"+
                "     THEN (select "+label+" from icpc2 where code=OC_DIAGNOSIS_CODE)"+
                "     ELSE (select "+label+" from icd10 where code=OC_DIAGNOSIS_CODE)"+
                "   END) as LABEL,"+
                "  OC_DIAGNOSIS_CERTAINTY as CERTAINTY, OC_DIAGNOSIS_GRAVITY as GRAVITY,"+
                "  replace(OC_ENCOUNTER_SERVICEUID,'.','_') as CODE_SERVICE,"+
                "  replace(OC_ENCOUNTER_BEDUID,'.','_') as CODE_LIT,"+
                "  replace(OC_ENCOUNTER_MANAGERUID,'.','_') as CODE_WARD"+
                " from OC_DIAGNOSES a, OC_ENCOUNTERS_VIEW"+
                "  where OC_DIAGNOSIS_ENCOUNTERUID = "+ MedwanQuery.getInstance().convert("varchar(10)","OC_ENCOUNTER_SERVERID")+MedwanQuery.getInstance().concatSign()+"'.'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar(10)","OC_ENCOUNTER_OBJECTID")+
                "   and OC_ENCOUNTER_BEGINDATE <= "+ MedwanQuery.getInstance().convertStringToDate("'<end>'")+
                "   and OC_ENCOUNTER_ENDDATE >= "+ MedwanQuery.getInstance().convertStringToDate("'<begin>'")+
                " order by OC_ENCOUNTER_SERVERID, OC_ENCOUNTER_OBJECTID";
    }
	//*** 13 - RFE *******************************************************
    else if("rfe.list".equalsIgnoreCase(sQueryType)){
        query = "select replace(OC_RFE_ENCOUNTERUID,'.','_') as CODE_CONTACT, OC_RFE_UPDATEUID as CODE_USER,"+
                "  OC_RFE_CODETYPE as TYPE, OC_RFE_CODE as CODE,"+
                "  (CASE OC_RFE_CODETYPE"+
                "    WHEN 'icpc'"+
                "     THEN (select "+label+" from icpc2 where code=OC_RFE_CODE)"+
                "     ELSE (select "+label+" from icd10 where code=OC_RFE_CODE)"+
                "   END) as LABEL,"+
                "  replace(OC_ENCOUNTER_SERVICEUID,'.','_') as CODE_SERVICE,"+
                "  replace(OC_ENCOUNTER_BEDUID,'.','_') as CODE_LIT,"+
                "  replace(OC_ENCOUNTER_MANAGERUID,'.','_') as CODE_WARD"+
                " from OC_RFE a, OC_ENCOUNTERS_VIEW"+
                "  where OC_RFE_ENCOUNTERUID = "+MedwanQuery.getInstance().convert("varchar(10)","OC_ENCOUNTER_SERVERID")+MedwanQuery.getInstance().concatSign()+"'.'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar(10)","OC_ENCOUNTER_OBJECTID")+
                "   and OC_ENCOUNTER_BEGINDATE <= "+MedwanQuery.getInstance().convertStringToDate("'<end>'")+
                "   and OC_ENCOUNTER_ENDDATE >= "+MedwanQuery.getInstance().convertStringToDate("'<begin>'")+
                " order by OC_ENCOUNTER_SERVERID, OC_ENCOUNTER_OBJECTID";
    }
	//*** 14 - DOCUMENTS *************************************************
    else if("document.list".equalsIgnoreCase(sQueryType)){
        query = "select c.personid as CODE_PATIENT, a.userId as CODE_USER, a.updatetime as REGISTRATIONDATE, b.oc_label_value as TYPE"+
                " from Transactions a, oc_labels b, Healthrecord c"+
                "  where a.healthrecordid = c.healthrecordid"+
                "   and b.oc_label_type = 'web.occup'"+
                "   and b.oc_label_id = a.transactionType"+
                "   and b.OC_LABEL_LANGUAGE = '"+sWebLanguage+"'"+
                "   and a.updatetime >= "+MedwanQuery.getInstance().convertStringToDate("'<begin>'")+
                "   and a.updatetime <= "+MedwanQuery.getInstance().convertStringToDate("'<end>'")+
                " order by a.updatetime";
    }
    
	if(!done){
	    Connection loc_conn = MedwanQuery.getInstance().getLongOpenclinicConnection(),
		           lad_conn = MedwanQuery.getInstance().getLongAdminConnection();
	    
	    Debug.println(query);
	    CsvStats csvStats = new CsvStats(request.getParameter("begin"),
	    		                         request.getParameter("end"),
	    		                         "admin".equalsIgnoreCase(request.getParameter("db"))?lad_conn:loc_conn,
	    		                         query);
	    
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
	   
	    ServletOutputStream os = response.getOutputStream();
	    byte[] b = csvStats.execute().toString().getBytes("ISO-8859-1");
	    for(int n=0; n<b.length; n++){
	        os.write(b[n]);
	    }
	    loc_conn.close();
	    lad_conn.close();
	    
	    os.flush();
	    os.close();
	}
%>