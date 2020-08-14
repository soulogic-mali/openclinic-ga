<%@page import="be.openclinic.finance.*,be.openclinic.medical.*,be.mxs.common.model.vo.healthrecord.*,be.dpms.medwan.common.model.vo.system.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	java.util.Date date = new SimpleDateFormat("dd/MM/yyyy").parse("01/01/1900");
	int count=0;
	while(true){
		Connection conn = MedwanQuery.getInstance().getLongAdminConnection();
		PreparedStatement ps = conn.prepareStatement("select * from allpatients  where fegre>=? order by fegre");
		ps.setDate(1,new java.sql.Date(date.getTime()));
		ResultSet rs = ps.executeQuery();
		while(rs.next() && count<500){
			try{
				count++;
				AdminPerson patient = null;
				int personid = rs.getInt("id");
				date = rs.getDate("fegre");
				String patientid = checkString(rs.getString("historia"));
				String typedoc = checkString(rs.getString("tipodoc"));
				String natreg = checkString(rs.getString("num_dni"));
				String lastname = checkString(rs.getString("apellidos"));
				String firstname = checkString(rs.getString("nombres"));
				String gender = checkString(rs.getString("sexo"));
				java.util.Date dateofbirth = rs.getDate("fnaci");
				String ubigeo = checkString(rs.getString("ubigeo"));
				String diag1 = checkString(rs.getString("dxeg1"));
				String diag2 = checkString(rs.getString("dxeg2"));
				String diag3 = checkString(rs.getString("dxeg3"));
				String destination = checkString(rs.getString("desti"));
				String insurance = checkString(rs.getString("tipseg"));
				//Log
				System.out.println(personid+" / "+lastname+" / "+firstname+" / "+natreg);
				//Set personal data
				patient = new AdminPerson();
				patient.checkImmatnew=true;
				patient.checkNatreg=true;
				patient.personid="";
				patient.begin=new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date());
				patient.sourceid="4";
				patient.updateuserid="4";
				patient.dateOfBirth=dateofbirth==null?"":new SimpleDateFormat("dd/MM/yyyy").format(dateofbirth);
				patient.firstname=firstname;
				patient.lastname=lastname;
				patient.setID("immatnew",patientid);
				if(natreg.length()>0){
					if(typedoc.startsWith("01")){
						patient.personType="1";
						patient.setID("natreg",natreg);
					}
					else if(typedoc.startsWith("02")){
						patient.personType="3";
						patient.setID("natreg",natreg);
					}
					else if(typedoc.startsWith("03")){
						patient.personType="2";
						patient.setID("natreg",natreg);
					}
				}
				patient.gender=gender;
				patient.nativeCountry="pe";
				patient.language="es";
				//Add private data
				AdminPrivateContact apc = new AdminPrivateContact();
				apc.city=ubigeo;
				patient.privateContacts.add(apc);
				System.out.println("Patient: "+patient.getFullName());
				patient.store();
				System.out.println("Stored...");
				Vector insurances = Insurance.selectInsurances(patient.personid, "");
				//Add insurance
				System.out.println("Insurance: "+insurance);
				if(insurance.equalsIgnoreCase("se")){
					boolean bFound=false;
					//SIS patient
					for(int n=0;n<insurances.size();n++){
						Insurance ins = (Insurance)insurances.elementAt(n);
						if(ins.getInsurarUid().equalsIgnoreCase("1.29")){
							bFound=true;
						}
					}
					if(!bFound){
						Insurance ins = new Insurance();
						ins.setCreateDateTime(new java.util.Date());
						ins.setDefaultInsurance(1);
						ins.setInsuranceCategoryLetter("A");
						ins.setInsurarUid("1.29");
						ins.setPatientUID(patient.personid);
						ins.setStart(new java.sql.Timestamp(date.getTime()));
						ins.setType("b");
						ins.setUpdateDateTime(new java.util.Date());
						ins.setUpdateUser(activeUser.userid);
						ins.setVersion(1);
						ins.store();
					}
				}
				else if(insurance.equalsIgnoreCase("ss")){
					boolean bFound=false;
					//Uninsured patient
					for(int n=0;n<insurances.size();n++){
						Insurance ins = (Insurance)insurances.elementAt(n);
						if(ins.getInsurarUid().equalsIgnoreCase("1.31")){
							bFound=true;
						}
					}
					if(!bFound){
						Insurance ins = new Insurance();
						ins.setCreateDateTime(new java.util.Date());
						ins.setDefaultInsurance(1);
						ins.setInsuranceCategoryLetter("A");
						ins.setInsurarUid("1.31");
						ins.setPatientUID(patient.personid);
						ins.setStart(new java.sql.Timestamp(date.getTime()));
						ins.setType("d");
						ins.setUpdateDateTime(new java.util.Date());
						ins.setUpdateUser(activeUser.userid);
						ins.setVersion(1);
						ins.store();
					}
				}
				else if(insurance.equalsIgnoreCase("so")){
					boolean bFound=false;
					//SOAT patient
					for(int n=0;n<insurances.size();n++){
						Insurance ins = (Insurance)insurances.elementAt(n);
						if(ins.getInsurarUid().equalsIgnoreCase("1.35")){
							bFound=true;
						}
					}
					if(!bFound){
						Insurance ins = new Insurance();
						ins.setCreateDateTime(new java.util.Date());
						ins.setDefaultInsurance(1);
						ins.setInsuranceCategoryLetter("A");
						ins.setInsurarUid("1.35");
						ins.setPatientUID(patient.personid);
						ins.setStart(new java.sql.Timestamp(date.getTime()));
						ins.setType("B");
						ins.setUpdateDateTime(new java.util.Date());
						ins.setUpdateUser(activeUser.userid);
						ins.setVersion(1);
						ins.store();
					}
				}
				else if(insurance.equalsIgnoreCase("tf")){
					boolean bFound=false;
					//Trabajador familiar
					for(int n=0;n<insurances.size();n++){
						Insurance ins = (Insurance)insurances.elementAt(n);
						if(ins.getInsurarUid().equalsIgnoreCase("1.38")){
							bFound=true;
						}
					}
					if(!bFound){
						Insurance ins = new Insurance();
						ins.setCreateDateTime(new java.util.Date());
						ins.setDefaultInsurance(1);
						ins.setInsuranceCategoryLetter("A");
						ins.setInsurarUid("1.38");
						ins.setPatientUID(patient.personid);
						ins.setStart(new java.sql.Timestamp(date.getTime()));
						ins.setType("b");
						ins.setUpdateDateTime(new java.util.Date());
						ins.setUpdateUser(activeUser.userid);
						ins.setVersion(1);
						ins.store();
					}
				}
				else if(insurance.equalsIgnoreCase("ae")){
					boolean bFound=false;
					//AE Patient?
					for(int n=0;n<insurances.size();n++){
						Insurance ins = (Insurance)insurances.elementAt(n);
						if(ins.getInsurarUid().equalsIgnoreCase("1.39")){
							bFound=true;
						}
					}
					if(!bFound){
						Insurance ins = new Insurance();
						ins.setCreateDateTime(new java.util.Date());
						ins.setDefaultInsurance(1);
						ins.setInsuranceCategoryLetter("A");
						ins.setInsurarUid("1.39");
						ins.setPatientUID(patient.personid);
						ins.setStart(new java.sql.Timestamp(date.getTime()));
						ins.setType("b");
						ins.setUpdateDateTime(new java.util.Date());
						ins.setUpdateUser(activeUser.userid);
						ins.setVersion(1);
						ins.store();
					}
				}
				//Add transactions
				//Check if Encounter exists
				System.out.println("1");
				Encounter encounter = null;
				Vector encounters = Encounter.selectEncounters("", "", ScreenHelper.formatDate(date), "", "admission", "", "", "", patient.personid, "");
				System.out.println("ENCOUNTERS.SIZE="+encounters.size());
				if(encounters.size()>0){
					encounter=(Encounter)encounters.elementAt(0);
				}
				if(encounter==null){
					encounter=new Encounter();
					encounter.setBegin(date);
					encounter.setCreateDateTime(date);
					encounter.setEnd(date);
					encounter.setPatientUID(patient.personid);
					encounter.setServiceUID("CL");
					encounter.setType("admission");
					encounter.setUpdateUser("4");
					encounter.setVersion(1);
					encounter.store();
				}
				System.out.println("2");
				//Check if healthrecord exists
				int healthrecordid = MedwanQuery.getInstance().getHealthRecordIdFromPersonId(Integer.parseInt(patient.personid));
				System.out.println("healthrecordid="+healthrecordid);
				//Create an epicrisis transaction if it doesn't exist yet
				TransactionVO transaction = null;
				Vector epicrisis = MedwanQuery.getInstance().getTransactionsByType(Integer.parseInt(patient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_MCD");
				System.out.println("EPICRISIS="+epicrisis.size());
				for(int n=0;n<epicrisis.size();n++){
					TransactionVO t = (TransactionVO)epicrisis.elementAt(n);
					System.out.println("t="+t.getUpdateTime());
					System.out.println("date="+date);
					if(t.getUpdateTime().equals(date)){
						transaction=t;
						break;
					}
				}
				System.out.println("3");
				if(healthrecordid==0 || transaction==null){
					transaction = new TransactionVO();
					transaction.setCreateDateTime(date);
					transaction.setCreationDate(date);
					transaction.setHealthrecordId(healthrecordid);
					transaction.setServerId(1);
					transaction.setStatus(1);
					transaction.setTransactionId(-1);
					transaction.setTransactionType("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_MCD");
					transaction.setUpdateTime(date);
					UserVO user = MedwanQuery.getInstance().getUser("4");
					transaction.setUpdateUser("4");
					transaction.setUser(user);
					transaction.setVersion(1);
					transaction.setVersionServerId(1);
					transaction.setItems(new Vector());
		            ItemContextVO itemContextVO = new ItemContextVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", "");
		            transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
		                    "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID",
		                    encounter.getUid(),
		                    date,
		                    itemContextVO));
		            transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
		                    "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT",
		                    "CL",
		                    date,
		                    itemContextVO));
		            transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
		                    "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MCD_COMMENT",
		                    "Datos importados",
		                    date,
		                    itemContextVO));
		    		System.out.println("4");
					if(diag1.length()>0){
						String diag=diag1;
						if(diag.length()>5){
							diag=diag.substring(0,5);
						}
			            transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
			                    "ICD10Code"+diag,
			                    "-",
			                    date,
			                    itemContextVO));
			            transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
			                    "FlagsICD10Code"+diag,
			                    "adms",
			                    date,
			                    itemContextVO));
			            transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
			                    "CertaintyICD10Code"+diag,
			                    "500",
			                    date,
			                    itemContextVO));
			            transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
			                    "GravityICD10Code"+diag,
			                    "1",
			                    date,
			                    itemContextVO));
			            transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
			                    "NCICD10Code"+diag,
			                    "1",
			                    date,
			                    itemContextVO));
					}
		    		System.out.println("5");
					if(diag2.length()>0){
						String diag=diag2;
						if(diag.length()>5){
							diag=diag.substring(0,5);
						}
			            transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
			                    "ICD10Code"+diag,
			                    "-",
			                    date,
			                    itemContextVO));
			            transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
			                    "FlagsICD10Code"+diag,
			                    "adms",
			                    date,
			                    itemContextVO));
			            transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
			                    "CertaintyICD10Code"+diag,
			                    "500",
			                    date,
			                    itemContextVO));
			            transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
			                    "GravityICD10Code"+diag,
			                    "1",
			                    date,
			                    itemContextVO));
			            transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
			                    "NCICD10Code"+diag,
			                    "1",
			                    date,
			                    itemContextVO));
					}
		    		System.out.println("6");
					if(diag3.length()>0){
						String diag=diag3;
						if(diag.length()>5){
							diag=diag.substring(0,5);
						}
			            transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
			                    "ICD10Code"+diag,
			                    "-",
			                    date,
			                    itemContextVO));
			            transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
			                    "FlagsICD10Code"+diag,
			                    "adms",
			                    date,
			                    itemContextVO));
			            transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
			                    "CertaintyICD10Code"+diag,
			                    "500",
			                    date,
			                    itemContextVO));
			            transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
			                    "GravityICD10Code"+diag,
			                    "1",
			                    date,
			                    itemContextVO));
			            transaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
			                    "NCICD10Code"+diag,
			                    "1",
			                    date,
			                    itemContextVO));
					}
		    		System.out.println("7");
					transaction = MedwanQuery.getInstance().updateTransaction(Integer.parseInt(patient.personid), transaction);
		    		System.out.println("8");
					if(diag1.length()>0){
						String diag=diag1;
						if(diag.length()>5){
							diag=diag.substring(0,5);
						}
			            Diagnosis diagnosis = new Diagnosis();
			            diagnosis.setAuthorUID("4");
			            diagnosis.setCertainty(500);
			            diagnosis.setGravity(1);
			            diagnosis.setCode(diag);
			            diagnosis.setCodeType("icd10");
			            diagnosis.setCreateDateTime(date);
			            diagnosis.setDate(date);
			            diagnosis.setEncounterUID(encounter.getUid());
			            diagnosis.setLateralisation(new StringBuffer());
			            diagnosis.setNC("1");
			            diagnosis.setReferenceUID("1."+transaction.getTransactionId());
			            diagnosis.setReferenceType("Transaction");
			            diagnosis.setServiceUid("CL");
			            diagnosis.setUpdateUser("4");
			            diagnosis.setVersion(1);
			            diagnosis.store();
					}
					if(diag2.length()>0){
						String diag=diag2;
						if(diag.length()>5){
							diag=diag.substring(0,5);
						}
			            Diagnosis diagnosis = new Diagnosis();
			            diagnosis.setAuthorUID("4");
			            diagnosis.setCertainty(500);
			            diagnosis.setGravity(1);
			            diagnosis.setCode(diag);
			            diagnosis.setCodeType("icd10");
			            diagnosis.setCreateDateTime(date);
			            diagnosis.setDate(date);
			            diagnosis.setEncounterUID(encounter.getUid());
			            diagnosis.setLateralisation(new StringBuffer());
			            diagnosis.setNC("1");
			            diagnosis.setReferenceUID("1."+transaction.getTransactionId());
			            diagnosis.setReferenceType("Transaction");
			            diagnosis.setServiceUid("CL");
			            diagnosis.setUpdateUser("4");
			            diagnosis.setVersion(1);
			            diagnosis.store();
					}
					if(diag3.length()>0){
						String diag=diag3;
						if(diag.length()>5){
							diag=diag.substring(0,5);
						}
			            Diagnosis diagnosis = new Diagnosis();
			            diagnosis.setAuthorUID("4");
			            diagnosis.setCertainty(500);
			            diagnosis.setGravity(1);
			            diagnosis.setCode(diag);
			            diagnosis.setCodeType("icd10");
			            diagnosis.setCreateDateTime(date);
			            diagnosis.setDate(date);
			            diagnosis.setEncounterUID(encounter.getUid());
			            diagnosis.setLateralisation(new StringBuffer());
			            diagnosis.setNC("1");
			            diagnosis.setReferenceUID("1."+transaction.getTransactionId());
			            diagnosis.setReferenceType("Transaction");
			            diagnosis.setServiceUid("CL");
			            diagnosis.setUpdateUser("4");
			            diagnosis.setVersion(1);
			            diagnosis.store();
					}
				}
				
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		System.out.println("COUNT="+count);
		rs.close();
		ps.close();
		conn.close();
		if(count<499){
			break;
		}
		count=0;
	}
%>