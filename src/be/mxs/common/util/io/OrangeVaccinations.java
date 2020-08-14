package be.mxs.common.util.io;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.Hashtable;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.Pointer;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.medical.Vaccination;
import be.openclinic.reporting.MessageNotifier;
import net.admin.AdminPerson;
import net.admin.AdminPrivateContact;

public class OrangeVaccinations {
	public static void loadNewPersons(){
		//First we find out when was the last person loaded
		String lastPersonLoad = MedwanQuery.getInstance().getConfigString("lastOrangeVaccinationPersonLoad","19000101120000000");
		String sSql = "select * from dbvaccination.persons where RegistrationDateTime>? and secretCode is null order by RegistrationDateTime";
		Connection conn = MedwanQuery.getInstance().getAdminConnection();
		try{
			PreparedStatement ps = conn.prepareStatement(sSql);
			ps.setTimestamp(1, new java.sql.Timestamp(new SimpleDateFormat("yyyyMMddHHmmssSSS").parse(lastPersonLoad).getTime()-3600*1000));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				//Pick up the data provided by the user
				int id = rs.getInt("idPersons");
				String phone = ScreenHelper.checkString(rs.getString("PhoneNumber"));
				String firstname = ScreenHelper.checkString(rs.getString("Firstname")).toUpperCase();
				String lastname = ScreenHelper.checkString(rs.getString("Lastname")).toUpperCase();
				Date dateofbirth = rs.getDate("DateOfBirth");
				java.sql.Timestamp registrationdatetime = rs.getTimestamp("RegistrationDateTime");
				if(dateofbirth!=null && dateofbirth.before(new java.util.Date()) && ScreenHelper.checkString(rs.getString("secretCode")).length()==0){
					//Generate a secret code and update the record
					String secret = new java.util.Random().nextInt(9999)+"";
					PreparedStatement ps2 = conn.prepareStatement("update dbvaccination.persons set secretCode=? where idPersons=?");
					ps2.setString(1, secret);
					ps2.setInt(2, id);
					ps2.execute();
					ps2.close();
					//Now spool a message confirming the subscription
					String sResult = ScreenHelper.getTranNoLink("web", "patientvaccinationsubscriptionconfirmation", "fr");
					sResult=sResult.replaceAll("#patientname#", lastname.toUpperCase()+", "+firstname.toUpperCase());
					sResult=sResult.replaceAll("#patientbirth#", new SimpleDateFormat("dd/MM/yyyy").format(dateofbirth));
					sResult=sResult.replaceAll("#secretcode#", secret);
					//Spool message for SMPP sending
					MessageNotifier.SpoolMessage(MedwanQuery.getInstance().getOpenclinicCounter("OC_MESSAGES"), "smpp", sResult, phone, "vaccinationsubscription", "fr");
				}
				PreparedStatement ps2 = conn.prepareStatement("select * from Admin where immatnew=? and firstname=? and dateofbirth=?");
				ps2.setString(1, phone);
				ps2.setString(2, firstname);
				ps2.setDate(3, new java.sql.Date(dateofbirth.getTime()));
				ResultSet rs2 = ps2.executeQuery();
				if(!rs2.next()){
					if(dateofbirth!=null && dateofbirth.before(new java.util.Date())){
						//The person does not exist, create it
						AdminPerson person = new AdminPerson();
						person.setID("immatnew", phone);
						person.firstname=firstname;
						person.lastname=lastname;
						person.dateOfBirth=new SimpleDateFormat("dd/MM/yyyy").format(dateofbirth);
						person.sourceid="1";
						person.updateuserid="4";
						person.language="FR";
						person.nativeCountry="ML";
						person.statute="V";
						person.begin=new SimpleDateFormat("dd/MM/yyyy").format(registrationdatetime);
						Debug.println("Storing patient "+lastname.toUpperCase()+", "+firstname.toUpperCase());
						person.setUpdateDateTime(registrationdatetime);
						AdminPrivateContact apc = new AdminPrivateContact();
						apc.mobile=phone;
						person.privateContacts.add(apc);
						person.store();
						//We now determine the next vaccination stage
						long day = 24*3600*1000;
						long week = 7*day;
						//Determine age of patient
						int ageInWeeks = new Long((new java.util.Date().getTime()-registrationdatetime.getTime())/week).intValue();
						Debug.println("Age in weeks = "+ageInWeeks);
						java.util.Date appointmentdate = null;
						int nextreminderstage=0;
						if(ageInWeeks<1){
							nextreminderstage=1;
							appointmentdate=new java.util.Date(registrationdatetime.getTime());
						}
						else if(ageInWeeks<7){
							nextreminderstage=2;
							appointmentdate=new java.util.Date(registrationdatetime.getTime()+week*6);
						}
						else if(ageInWeeks<11){
							nextreminderstage=3;
							appointmentdate=new java.util.Date(registrationdatetime.getTime()+week*10);
						}
						else if(ageInWeeks<18){
							nextreminderstage=4;
							appointmentdate=new java.util.Date(registrationdatetime.getTime()+week*14);
						}
						else if(ageInWeeks<52){
							nextreminderstage=5;
							appointmentdate=new java.util.Date(registrationdatetime.getTime()+week*38);
						}
						Debug.println("Appointmentdate = "+appointmentdate);
						Debug.println("nextreminderstage = "+nextreminderstage);
						if(appointmentdate!=null && nextreminderstage>0){
							if(appointmentdate.before(new java.util.Date())){
								appointmentdate=new java.util.Date(new java.util.Date().getTime()+day);
							}
							//An initial message must be sent
							String sResult = ScreenHelper.getTranNoLink("web", "patientvaccinationinitialremindercontent", "fr");
							sResult=sResult.replaceAll("#patientname#", (lastname+", "+firstname).toUpperCase());
							sResult=sResult.replaceAll("#patientbirth#", new SimpleDateFormat("dd/MM/yyyy").format(dateofbirth));
							sResult=sResult.replaceAll("#appointmentdate#", new SimpleDateFormat("dd/MM/yyyy").format(appointmentdate));
							sResult=sResult.replaceAll("#vaccinationstage#", ScreenHelper.getTranNoLink("vaccinationstage", nextreminderstage+"", "fr"));
							Debug.println("spooling message = "+sResult);
							//Spool message for SMPP sending
							MessageNotifier.SpoolMessage(MedwanQuery.getInstance().getOpenclinicCounter("OC_MESSAGES"), "smpp", sResult, phone, "vaccinationreminder", "fr");
						}
					}
				}
				rs2.close();
				ps2.close();
				//The person was treated, update lastOrangeVaccinationPersonLoad
				MedwanQuery.getInstance().setConfigString("lastOrangeVaccinationPersonLoad", new SimpleDateFormat("yyyyMMddHHmmssSSS").format(registrationdatetime));
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public static void sendReminders(){
		int hour = 3600000;
		//First figure out when the last reminders were sent
		try {
			java.util.Date lastReminderSent = new SimpleDateFormat("yyyyMMddHHmmssSSS").parse(MedwanQuery.getInstance().getConfigString("lastOrangeVaccinationReminderSent","19000101120000000"));
			if(new java.util.Date().getTime()-lastReminderSent.getTime()>MedwanQuery.getInstance().getConfigInt("orangeVaccinationReminderInterval",6*hour)){
				//We first select all persons that are within the age range for the vaccination program (up to 1 year old)
				java.util.Date oneYearAgo = new SimpleDateFormat("dd/MM/yyyy").parse(new SimpleDateFormat("dd/MM/").format(new java.util.Date())+(Integer.parseInt(new SimpleDateFormat("yyyy").format(new java.util.Date()))-1));
				String sSql = "select a.*,b.mobile from Admin a,AdminPrivate b where a.statute='V' and a.personid=b.personid and b.stop is null and dateofbirth>?";
				Connection conn = MedwanQuery.getInstance().getAdminConnection();
				PreparedStatement ps = conn.prepareStatement(sSql);
				ps.setDate(1, new java.sql.Date(oneYearAgo.getTime()));
				ResultSet rs = ps.executeQuery();
				while(rs.next()){
					String personid=rs.getString("personid");
					String language=ScreenHelper.checkString(rs.getString("language")).toLowerCase();
					if(language.length()==0){
						language="fr";
					}
					String patientfullname=ScreenHelper.checkString(rs.getString("lastname").toUpperCase())+", "+ScreenHelper.checkString(rs.getString("firstname").toUpperCase());
					String phone=ScreenHelper.checkString(rs.getString("mobile"));
					Debug.println("Checking reminders for "+personid+" "+patientfullname);
					int vaccinationstage=0;
					int nextreminderstage=0;
					//For each patient, we first verify which is the next vaccination stage
					//Possible vaccination stages:
					//1: 0  - 1 weeks (birth)
					//2: 1  - 7 weeks (6 weeks)
					//3: 7  - 11 weeks (10 weeks)
					//4: 11 - 18 weeks (14 weeks)
					//5: 18 - 52 weeks (38 weeks - 9 months)
					long day = 24*3600*1000;
					long week = 7*day;
					//Determine age of patient
					java.util.Date dateofbirth = rs.getDate("dateofbirth");
					java.util.Date begin = rs.getDate("begindate");
					if(begin==null){
						begin=dateofbirth;
					}
					int ageInWeeks = new Long((new java.util.Date().getTime()-begin.getTime())/week).intValue();
					//Determine actual vaccination stage
					//Make a hashset of all vaccinations that have been given to this patient
					HashSet vaccinations = new HashSet();
					Connection conn2 = MedwanQuery.getInstance().getOpenclinicConnection();
					PreparedStatement ps2 = conn2.prepareStatement("select * from oc_vaccinations where oc_vaccination_patientuid=?");
					ps2.setString(1, personid);
					ResultSet rs2 = ps2.executeQuery();
					while(rs2.next()){
						vaccinations.add(rs2.getString("oc_vaccination_type"));
					}
					rs2.close();
					ps2.close();
					conn2.close();
					//Now determine the last complete vaccination status
					if(vaccinations.contains("measles") && vaccinations.contains("yellowfever") && vaccinations.contains("meningitisa")){
						vaccinationstage = 5;
					}
					else if(vaccinations.contains("polio3") && vaccinations.contains("penta3") && vaccinations.contains("pneumo3") && vaccinations.contains("rota3")){
						vaccinationstage = 4;
					}
					else if(vaccinations.contains("polio2") && vaccinations.contains("penta2") && vaccinations.contains("pneumo2") && vaccinations.contains("rota2")){
						vaccinationstage = 3;
					}
					else if(vaccinations.contains("polio1") && vaccinations.contains("penta1") && vaccinations.contains("pneumo1") && vaccinations.contains("rota1")){
						vaccinationstage = 2;
					}
					else if(vaccinations.contains("bcg") && vaccinations.contains("polio0")){
						vaccinationstage = 1;
					}
					Debug.println("Last vaccination stage = "+vaccinationstage);
					Debug.println("Age in weeks = "+ageInWeeks);
					java.util.Date appointmentdate = null;
					if(ageInWeeks<1){
						if(vaccinationstage<1) nextreminderstage=1;
						appointmentdate=new java.util.Date(begin.getTime());
					}
					else if(ageInWeeks<7){
						if(ageInWeeks>=4 && vaccinationstage<2) {
							nextreminderstage=2;
							appointmentdate=new java.util.Date(begin.getTime()+week*6);
						}
					}
					else if(ageInWeeks<11){
						if(ageInWeeks>=8 && vaccinationstage<3) {
							nextreminderstage=3;
							appointmentdate=new java.util.Date(begin.getTime()+week*10);
						}
					}
					else if(ageInWeeks<18){
						if(ageInWeeks>=12 && vaccinationstage<4) {
							nextreminderstage=4;
							appointmentdate=new java.util.Date(begin.getTime()+week*14);
						}
					}
					else if(ageInWeeks<52){
						if(ageInWeeks>=36 && vaccinationstage<5) {
							nextreminderstage=5;
							appointmentdate=new java.util.Date(begin.getTime()+week*38);
						}
					}
					Debug.println("Next reminder stage = "+nextreminderstage);
					if(appointmentdate!=null && nextreminderstage>0){
						if(appointmentdate.before(new java.util.Date())){
							appointmentdate=new java.util.Date(new java.util.Date().getTime()+day);
						}
						//A reminder message must be sent
						//We first verify if the message has not been sent yet
						if(Pointer.getPointer("VACCREM."+personid+"."+nextreminderstage).length()==0){
							String vaccinationcode = (ScreenHelper.convertToAlfabeticalCode(MedwanQuery.getInstance().getOpenclinicCounter("VaccinationCode")+"")+new java.util.Random().nextInt(99)).toUpperCase();
							String sResult = ScreenHelper.getTranNoLink("web", "patientvaccinationremindercontent", language);
							sResult=sResult.replaceAll("#patientname#", patientfullname);
							sResult=sResult.replaceAll("#patientbirth#", new SimpleDateFormat("dd/MM/yyyy").format(dateofbirth));
							sResult=sResult.replaceAll("#appointmentdate#", new SimpleDateFormat("dd/MM/yyyy").format(appointmentdate));
							sResult=sResult.replaceAll("#vaccinationstage#", ScreenHelper.getTranNoLink("vaccinationstage", nextreminderstage+"", language));
							sResult=sResult.replaceAll("#vaccinationcode#", vaccinationcode);
							//Spool message for SMPP sending
							MessageNotifier.SpoolMessage(MedwanQuery.getInstance().getOpenclinicCounter("OC_MESSAGES"), "smpp", sResult, phone, "vaccinationreminder", language);
							Pointer.storePointer("VACCREM."+personid+"."+nextreminderstage, vaccinationcode);
							Pointer.storePointer("VACCCODE."+vaccinationcode, personid+"."+nextreminderstage);
							//Also store this code in the vaccination database
							ps2=conn.prepareStatement("insert into dbvaccination.vaccinationcodes(Code) values(?)");
							ps2.setString(1, vaccinationcode);
							ps2.execute();
							ps2.close();
						}
					}
				}
				rs.close();
				ps.close();
				conn.close();
				//The reminders were sent, update lastOrangeVaccinationPersonLoad
				MedwanQuery.getInstance().setConfigString("lastOrangeVaccinationReminderSent", new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new java.util.Date()));
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static void updateVaccinations(){
		try {
			java.util.Date lastVaccinationUpdate = new SimpleDateFormat("yyyyMMddHHmmssSSS").parse(MedwanQuery.getInstance().getConfigString("lastOrangeVaccinationUpdate","19000101120000000"));
			String sSql = "select * from dbvaccination.vaccinationcodes where VaccinationDate>=? order by VaccinationDate";
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement(sSql);
			ps.setTimestamp(1, new java.sql.Timestamp(lastVaccinationUpdate.getTime()));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				String vaccinationcode = rs.getString("Code");
				java.util.Date vaccinationdate = rs.getTimestamp("VaccinationDate");
				//we first check to which patient this code belongs
				String patientreference = Pointer.getPointer("VACCCODE."+vaccinationcode);
				if(patientreference.length()>0){
					String personid = patientreference.split("\\.")[0];
					int nextreminderstage = Integer.parseInt(patientreference.split("\\.")[1]);
					Hashtable vaccinations = Vaccination.getVaccinations(personid);
					boolean bVaccinRegistered = false;
					if(nextreminderstage==1){
						if(vaccinations.get("bcg")==null){
							Vaccination vaccination = new Vaccination(personid,new SimpleDateFormat("dd/MM/yyyy").format(vaccinationdate),"bcg","","","","","");
							vaccination.save();
							bVaccinRegistered=true;
						}
						if(vaccinations.get("polio0")==null){
							Vaccination vaccination = new Vaccination(personid,new SimpleDateFormat("dd/MM/yyyy").format(vaccinationdate),"polio0","","","","","");
							vaccination.save();
							bVaccinRegistered=true;
						}
					}
					else if(nextreminderstage==2){
						if(vaccinations.get("polio1")==null){
							Vaccination vaccination = new Vaccination(personid,new SimpleDateFormat("dd/MM/yyyy").format(vaccinationdate),"polio1","","","","","");
							vaccination.save();
							bVaccinRegistered=true;
						}
						if(vaccinations.get("penta1")==null){
							Vaccination vaccination = new Vaccination(personid,new SimpleDateFormat("dd/MM/yyyy").format(vaccinationdate),"penta1","","","","","");
							vaccination.save();
							bVaccinRegistered=true;
						}
						if(vaccinations.get("pneumo1")==null){
							Vaccination vaccination = new Vaccination(personid,new SimpleDateFormat("dd/MM/yyyy").format(vaccinationdate),"pneumo1","","","","","");
							vaccination.save();
							bVaccinRegistered=true;
						}
						if(vaccinations.get("rota1")==null){
							Vaccination vaccination = new Vaccination(personid,new SimpleDateFormat("dd/MM/yyyy").format(vaccinationdate),"rota1","","","","","");
							vaccination.save();
							bVaccinRegistered=true;
						}
					}
					else if(nextreminderstage==3){
						if(vaccinations.get("polio2")==null){
							Vaccination vaccination = new Vaccination(personid,new SimpleDateFormat("dd/MM/yyyy").format(vaccinationdate),"polio2","","","","","");
							vaccination.save();
							bVaccinRegistered=true;
						}
						if(vaccinations.get("penta2")==null){
							Vaccination vaccination = new Vaccination(personid,new SimpleDateFormat("dd/MM/yyyy").format(vaccinationdate),"penta2","","","","","");
							vaccination.save();
							bVaccinRegistered=true;
						}
						if(vaccinations.get("pneumo2")==null){
							Vaccination vaccination = new Vaccination(personid,new SimpleDateFormat("dd/MM/yyyy").format(vaccinationdate),"pneumo2","","","","","");
							vaccination.save();
							bVaccinRegistered=true;
						}
						if(vaccinations.get("rota2")==null){
							Vaccination vaccination = new Vaccination(personid,new SimpleDateFormat("dd/MM/yyyy").format(vaccinationdate),"rota2","","","","","");
							vaccination.save();
							bVaccinRegistered=true;
						}
					}
					else if(nextreminderstage==4){
						if(vaccinations.get("polio3")==null){
							Vaccination vaccination = new Vaccination(personid,new SimpleDateFormat("dd/MM/yyyy").format(vaccinationdate),"polio3","","","","","");
							vaccination.save();
							bVaccinRegistered=true;
						}
						if(vaccinations.get("penta3")==null){
							Vaccination vaccination = new Vaccination(personid,new SimpleDateFormat("dd/MM/yyyy").format(vaccinationdate),"penta3","","","","","");
							vaccination.save();
							bVaccinRegistered=true;
						}
						if(vaccinations.get("pneumo3")==null){
							Vaccination vaccination = new Vaccination(personid,new SimpleDateFormat("dd/MM/yyyy").format(vaccinationdate),"pneumo3","","","","","");
							vaccination.save();
							bVaccinRegistered=true;
						}
						if(vaccinations.get("rota3")==null){
							Vaccination vaccination = new Vaccination(personid,new SimpleDateFormat("dd/MM/yyyy").format(vaccinationdate),"rota3","","","","","");
							vaccination.save();
							bVaccinRegistered=true;
						}
					}
					else if(nextreminderstage==5){
						if(vaccinations.get("measles")==null){
							Vaccination vaccination = new Vaccination(personid,new SimpleDateFormat("dd/MM/yyyy").format(vaccinationdate),"measles","","","","","");
							vaccination.save();
							bVaccinRegistered=true;
						}
						if(vaccinations.get("yellowfever")==null){
							Vaccination vaccination = new Vaccination(personid,new SimpleDateFormat("dd/MM/yyyy").format(vaccinationdate),"yellowfever","","","","","");
							vaccination.save();
							bVaccinRegistered=true;
						}
						if(vaccinations.get("meningitisa")==null){
							Vaccination vaccination = new Vaccination(personid,new SimpleDateFormat("dd/MM/yyyy").format(vaccinationdate),"meningitisa","","","","","");
							vaccination.save();
							bVaccinRegistered=true;
						}
					}
					if(bVaccinRegistered){
						HashSet newvaccinations = new HashSet();
						Connection conn2 = MedwanQuery.getInstance().getOpenclinicConnection();
						PreparedStatement ps2 = conn2.prepareStatement("select * from oc_vaccinations where oc_vaccination_patientuid=?");
						ps2.setString(1, personid);
						ResultSet rs2 = ps2.executeQuery();
						while(rs2.next()){
							newvaccinations.add(rs2.getString("oc_vaccination_type"));
						}
						rs2.close();
						ps2.close();
						conn2.close();
						int vaccinationstage=0;
						Debug.println("Number of vaccinations registered = "+newvaccinations.size());
						//Now determine the last complete vaccination status
						if(newvaccinations.contains("measles") && newvaccinations.contains("yellowfever") && newvaccinations.contains("meningitisa")){
							vaccinationstage = 5;
						}
						else if(newvaccinations.contains("polio3") && newvaccinations.contains("penta3") && newvaccinations.contains("pneumo3") && newvaccinations.contains("rota3")){
							vaccinationstage = 4;
						}
						else if(newvaccinations.contains("polio2") && newvaccinations.contains("penta2") && newvaccinations.contains("pneumo2") && newvaccinations.contains("rota2")){
							vaccinationstage = 3;
						}
						else if(newvaccinations.contains("polio1") && newvaccinations.contains("penta1") && newvaccinations.contains("pneumo1") && newvaccinations.contains("rota1")){
							vaccinationstage = 2;
						}
						else if(newvaccinations.contains("bcg") && newvaccinations.contains("polio0")){
							vaccinationstage = 1;
						}
						if(vaccinationstage<5){
							Debug.println("vaccinationstage="+vaccinationstage);
							long day = 24*3600*1000;
							long week = 7*day;
							java.util.Date appointmentdate=null;
							nextreminderstage=vaccinationstage+1;
							//Determine age of patient
							conn2 = MedwanQuery.getInstance().getAdminConnection();
							ps2 = conn2.prepareStatement("select firstname,lastname,dateofbirth,mobile,begindate from admin a,adminprivate b where a.personid=b.personid and b.stop is null and a.personid=?");
							ps2.setInt(1, Integer.parseInt(personid));
							rs2=ps2.executeQuery();
							if(rs2.next()){
								java.util.Date begin = rs2.getDate("begindate");
								java.util.Date dateofbirth = rs2.getDate("dateofbirth");
								if(begin==null){
									begin=dateofbirth;
								}
								String firstname=rs2.getString("firstname");
								String lastname=rs2.getString("lastname");
								String phone=rs2.getString("mobile");
								if(nextreminderstage==2){
									appointmentdate=new java.util.Date(begin.getTime()+week*6);
								}
								else if(nextreminderstage==3){
									appointmentdate=new java.util.Date(begin.getTime()+week*10);
								}
								else if(nextreminderstage==4){
									appointmentdate=new java.util.Date(begin.getTime()+week*14);
								}
								else if(nextreminderstage==5){
									appointmentdate=new java.util.Date(begin.getTime()+week*38);
								}
								Debug.println("Appointmentdate = "+appointmentdate);
								Debug.println("nextreminderstage = "+nextreminderstage);
								if(appointmentdate!=null && nextreminderstage>0){
									if(appointmentdate.before(new java.util.Date())){
										appointmentdate=new java.util.Date(new java.util.Date().getTime()+day);
									}
									//An initial message must be sent
									String sResult = ScreenHelper.getTranNoLink("web", "patientvaccinationinitialremindercontent", "fr");
									sResult=sResult.replaceAll("#patientname#", (lastname+", "+firstname).toUpperCase());
									sResult=sResult.replaceAll("#patientbirth#", new SimpleDateFormat("dd/MM/yyyy").format(dateofbirth));
									sResult=sResult.replaceAll("#appointmentdate#", new SimpleDateFormat("dd/MM/yyyy").format(appointmentdate));
									sResult=sResult.replaceAll("#vaccinationstage#", ScreenHelper.getTranNoLink("vaccinationstage", nextreminderstage+"", "fr"));
									Debug.println("spooling message = "+sResult);
									//Spool message for SMPP sending
									MessageNotifier.SpoolMessage(MedwanQuery.getInstance().getOpenclinicCounter("OC_MESSAGES"), "smpp", sResult, phone, "vaccinationreminder", "fr");
								}
							}
							rs2.close();
							ps2.close();
							conn2.close();
						}
					}
				}
				//The vaccinationcode was treated, update lastOrangeVaccinationUpdate
				MedwanQuery.getInstance().setConfigString("lastOrangeVaccinationUpdate", new SimpleDateFormat("yyyyMMddHHmmssSSS").format(vaccinationdate));
			}
			rs.close();
			ps.close();
			conn.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
