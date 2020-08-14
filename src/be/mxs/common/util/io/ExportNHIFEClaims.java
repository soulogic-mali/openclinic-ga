package be.mxs.common.util.io;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashSet;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;
import jpos.profile.PropInfoList.Iterator;
import net.admin.AdminPerson;
import net.admin.User;

public class ExportNHIFEClaims {

	public static String sub(String s,int length){
		if(s==null){
			s="";
		}
		if(s.length()>length){
			return s.substring(0,length);
		}
		else{
			return s;
		}
	}
	public static void main(String[] args) throws ClassNotFoundException, SQLException, ParseException {
		// TODO Auto-generated method stub
		long day=24*3600*1000;
		// This will load the MySQL driver, each DB has its own driver
	    System.out.println("driver OpenClinic="+args[0]);
	    System.out.println("url OpenClinic="+args[1]);
	    System.out.println("driver EClaims="+args[2]);
	    System.out.println("url EClaims="+args[3]);
	    Class.forName(args[0]);			
	    Connection conn =  DriverManager.getConnection(args[1]);
	    Connection conn2 =  DriverManager.getConnection(args[1]);
	    Class.forName(args[2]);			
	    Connection nhifconn =  DriverManager.getConnection(args[3]);
	    //Eerst moeten we de afgesloten NHIF facturen opzoeken
	    String sSql="select * from oc_config where oc_key='MFP'";
	    PreparedStatement ps = conn.prepareStatement(sSql);
	    ResultSet rs = ps.executeQuery();
	    String sNHIF="";
	    if(rs.next()){
	    	sNHIF=rs.getString("oc_value");
	    }
    	rs.close();
    	ps.close();
	    sSql="select * from oc_config where oc_key='BUNGE'";
	    ps = conn.prepareStatement(sSql);
	    rs = ps.executeQuery();
	    String sBUNGE="";
	    if(rs.next()){
	    	sBUNGE=rs.getString("oc_value");
	    }
    	rs.close();
    	ps.close();
	    sSql="select * from oc_config where oc_key='concatSign'";
	    ps = conn.prepareStatement(sSql);
	    rs = ps.executeQuery();
	    String sConcatSign="||";
	    if(rs.next()){
	    	sConcatSign=rs.getString("oc_value");
	    }
    	rs.close();
    	ps.close();
	    sSql="select * from oc_config where oc_key='NHIFFacilityCode'";
	    ps = conn.prepareStatement(sSql);
	    rs = ps.executeQuery();
	    String sNHIFFacilityCode="03993";
	    if(rs.next()){
	    	sNHIFFacilityCode=rs.getString("oc_value");
	    }
    	rs.close();
    	ps.close();
	    sSql="select * from oc_config where oc_key='NHIFUserName'";
	    ps = conn.prepareStatement(sSql);
	    rs = ps.executeQuery();
	    String sNHIFUserName="donarth";
	    if(rs.next()){
	    	sNHIFUserName=rs.getString("oc_value");
	    }
    	rs.close();
    	ps.close();
    	if(sNHIF.length()>0 || sBUNGE.length()>0){
    		System.out.println("NHIF UID = "+sNHIF);
    		System.out.println("BUNGE UID = "+sBUNGE);
    		rs.close();
    		ps.close();
    		//We exporteren automatisch voor de vorige maand, tenzij een specifieke periode wordt opgegeven
    		int activeyear = Integer.parseInt(new SimpleDateFormat("yyyy").format(new java.util.Date()));
    		int activemonth = Integer.parseInt(new SimpleDateFormat("MM").format(new java.util.Date()));
    		String activeday="01";
    		if(args.length>4 && args[4].split("/").length>2){
    			activeday=args[4].split("/")[0];
    			activemonth= Integer.parseInt(args[4].split("/")[1]);
    			activeyear= Integer.parseInt(args[4].split("/")[2]);
    			if(activemonth==12){
    				activemonth=1;
    				activeyear+=1;
    			}
    			else{
    				activemonth+=1;
    			}
    		}
    		else if(args.length>4 && args[4].split("/").length>1){
    			System.out.println("*"+args[4]+"*");
    			activemonth= Integer.parseInt(args[4].split("/")[0]);
    			activeyear= Integer.parseInt(args[4].split("/")[1]);
    			if(activemonth==12){
    				activemonth=1;
    				activeyear+=1;
    			}
    			else{
    				activemonth+=1;
    			}
    		}
    		java.util.Date dBegin = null, dEnd = null;
    		if(activemonth==1){
        		dBegin = new SimpleDateFormat("dd/MM/yyyy").parse(activeday+"/12/"+(activeyear-1));
        		dEnd = new SimpleDateFormat("dd/MM/yyyy").parse("01/01/"+activeyear);
    		}
    		else {
        		dBegin = new SimpleDateFormat("dd/MM/yyyy").parse(activeday+"/"+(activemonth-1)+"/"+activeyear);
        		dEnd = new SimpleDateFormat("dd/MM/yyyy").parse("01/"+(activemonth)+"/"+activeyear);
    		}
    		System.out.println("Investigating period "+new SimpleDateFormat("dd/MM/yyyy").format(dBegin)+" - "+new SimpleDateFormat("dd/MM/yyyy").format(dEnd));
    		//Search for all closed patient invoices for this insurer in the specified period
    		HashSet zeroInvoices=new HashSet();
    		if(sConcatSign.equalsIgnoreCase("||")){
	    		sSql="select distinct b.*,OC_INSURANCE_NR from oc_debets a, oc_patientinvoices b, oc_insurances c, oc_prestations d where"
	    				+ " oc_debet_patientinvoiceuid='1.'||oc_patientinvoice_objectid and"
	    				+ " oc_prestation_objectid=replace(oc_debet_prestationuid,'1.','') and"
	    				+ " (oc_prestation_nomenclature is not null and oc_prestation_nomenclature<>'') and"
	    				+ " oc_patientinvoice_date>=? and"
	    				+ " oc_patientinvoice_date<? and"
	    				+ " oc_patientinvoice_status='closed' and"
	    				+ " oc_insurance_objectid=replace(oc_debet_insuranceuid,'1.','') and"
	    				+ " length(oc_patientinvoice_comment)>0 and"
	    				+ " oc_insurance_insuraruid in ('"+sNHIF+"','"+sBUNGE+"') order by oc_patientinvoice_date";
    		}
    		else{
    			sSql="select oc_patientinvoice_objectid from oc_patientinvoices where "
	    				+ " oc_patientinvoice_date>=? and"
	    				+ " oc_patientinvoice_date<? and"
    					+ "(select sum(oc_debet_amount+oc_debet_insuraramount+oc_debet_extrainsuraramount) total from oc_debets,oc_prestations where oc_prestation_objectid=replace(oc_debet_prestationuid,'1.','') and (oc_prestation_nomenclature is not null and oc_prestation_nomenclature<>'') and oc_debet_patientinvoiceuid='1.'+convert(varchar,oc_patientinvoice_objectid))<=0";
    			ps = conn2.prepareStatement(sSql);
        		ps.setDate(1, new java.sql.Date(dBegin.getTime()));
        		ps.setDate(2, new java.sql.Date(dEnd.getTime()));
        		rs=ps.executeQuery();
        		while(rs.next()){
        			zeroInvoices.add(rs.getInt("oc_patientinvoice_objectid"));
        		}
        		rs.close();
        		ps.close();
	    		sSql="select distinct b.*,a.oc_debet_encounteruid,OC_INSURANCE_NR,oc_insurance_insuraruid from oc_debets a, oc_patientinvoices b, oc_insurances c, oc_prestations d where"
	    				+ " oc_debet_patientinvoiceuid='1.'+convert(varchar,oc_patientinvoice_objectid) and"
	    				+ " oc_prestation_objectid=replace(oc_debet_prestationuid,'1.','') and"
	    				+ " (oc_prestation_nomenclature is not null and oc_prestation_nomenclature<>'') and"
	    				+ " oc_patientinvoice_date>=? and"
	    				+ " oc_patientinvoice_date<? and"
	    				+ " oc_patientinvoice_status='closed' and"
	    				+ " oc_insurance_objectid=replace(oc_debet_insuranceuid,'1.','') and"
	    				+ " len(oc_patientinvoice_comment)>0 and"
	    				+ " oc_insurance_insuraruid in ('"+sNHIF+"','"+sBUNGE+"') order by oc_patientinvoice_date";
    		}
    		ps = conn2.prepareStatement(sSql);
    		ps.setDate(1, new java.sql.Date(dBegin.getTime()));
    		ps.setDate(2, new java.sql.Date(dEnd.getTime()));
    		rs=ps.executeQuery();
    		int lines=0;
    		while(rs.next()){
    			lines++;
    			int nInvoiceObjectId=rs.getInt("oc_patientinvoice_objectid");
				int nPatientId=rs.getInt("OC_PATIENTINVOICE_PATIENTUID");
				String sInvoiceUid="1."+rs.getString("oc_patientinvoice_objectid");
				String sEncounterUid=rs.getString("oc_debet_encounteruid");
				String sInsurarUid=rs.getString("oc_insurance_insuraruid");
    			if(zeroInvoices.contains(nInvoiceObjectId)){
    				continue;
    			}
    			if(lines % 20 ==0){
    				conn.close();
    				conn =  DriverManager.getConnection(args[1]);    				
    				nhifconn.close();
    				nhifconn =  DriverManager.getConnection(args[3]);
    			}
    			System.out.println("========================================================");
    			System.out.println("Found invoice "+nInvoiceObjectId+" on "+rs.getDate("oc_patientinvoice_date"));
    			System.out.println("========================================================");
    			//Eerst controleren we of er voor de specifieke periode wel degelijk een ClaimRegistration werd opgemaakt
    			String sClaimNo="CCBRT/NHIF/"+new SimpleDateFormat("MMM/yyyy").format(dBegin).toUpperCase();
    			sSql="select * from ClaimRegistration where ClaimNo=?";
    			PreparedStatement ps2 = nhifconn.prepareStatement(sSql);
    			ps2.setString(1, sub(sClaimNo,50));
    			ResultSet rs2=ps2.executeQuery();
    			if(!rs2.next()){
    				System.out.println("Creating ClaimRegistration N°"+sClaimNo);
    				rs2.close();
    				ps2.close();
    				sSql="insert into ClaimRegistration(ClaimNo,FacilityCode,ClaimMonth,ClaimYear,RemoteClaimNo,ReceivedDate,TreatmentDateFrom,TreatmentDateTo,FoliosSubmitted,AmountClaimed,AmountPaid,Status,Remarks,createdby,datecreated,lastmodifiedby,lastmodified)"
    						+ " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    				ps2=nhifconn.prepareStatement(sSql);
    				ps2.setString(1, sClaimNo);
    				ps2.setString(2, sNHIFFacilityCode);
    				ps2.setInt(3,Integer.parseInt(new SimpleDateFormat("MM").format(dBegin)));
    				ps2.setInt(4,Integer.parseInt(new SimpleDateFormat("yyyy").format(dBegin)));
    				ps2.setString(5, "");
    				ps2.setDate(6, null);
    				ps2.setDate(7,new java.sql.Date(dBegin.getTime()));
    				ps2.setDate(8,new java.sql.Date(dEnd.getTime()-day));
    				ps2.setInt(9, 0);
    				ps2.setDouble(10, 0);
    				ps2.setDouble(11, 0);
    				ps2.setString(12, "Open");
    				ps2.setString(13, "");
    				ps2.setString(14, sNHIFUserName);
    				ps2.setDate(15, new java.sql.Date(new java.util.Date().getTime()));
    				ps2.setString(16, sNHIFUserName);
    				ps2.setDate(17, new java.sql.Date(new java.util.Date().getTime()));
    				ps2.execute();
    			}
    			rs2.close();
    			ps2.close();
    			String sFolioId="";
    			java.util.Date dInvoice	= rs.getDate("OC_PATIENTINVOICE_DATE");

    			//Nu gaan we controleren of voor deze factuur reeds een folio bestaat, 
    			//indien neen, creëer een nieuw folio obv het serial number
    			String sSerialNo = rs.getString("OC_PATIENTINVOICE_COMMENT");
    			sSql="select * from Folios where ClaimNo=? and SerialNo=? and SourceDocumentNo=?";
    			ps2=nhifconn.prepareStatement(sSql);
    			ps2.setString(1, sub(sClaimNo,50));
    			ps2.setString(2, sub(sSerialNo,50));
    			ps2.setString(3, sub(nInvoiceObjectId+"",50));
    			rs2=ps2.executeQuery();
    			if(rs2.next()){
    				sFolioId=rs2.getString("FolioID");
    				System.out.println("Found existing Folio with ID "+sFolioId);
    			}
    			else {
    				//We creëren een nieuw Folio want het bestaat nog niet;
    				//We zoeken eerst het hoogste bestaande FolioNo op voor deze ClaimNo
    				rs2.close();
    				ps2.close();
    				//Now let's find the patient data
    				PreparedStatement ps3 = conn.prepareStatement("select * from adminview where personid=?");
    				ps3.setInt(1, nPatientId);
    				ResultSet rs3 = ps3.executeQuery();
    				if(rs3.next()){
    					java.sql.Date dDateOfBirth=rs3.getDate("dateofbirth");
	    				int nFolioNo=1;
	    				sSql="select max(FolioNo) maxno from Folios where ClaimNo=?";
	    				ps2=nhifconn.prepareStatement(sSql);
	    				ps2.setString(1, sClaimNo);
	    				rs2=ps2.executeQuery();
	    				if(rs2.next()){
	    					Integer i = rs2.getInt("maxno");
	    					if(i!=null){
	    						nFolioNo=i+1;
	    					}
	    				}
	    				rs2.close();
	    				ps2.close();
	    				sSql="insert into Folios(folioid,claimno,foliono,serialno,cardno,firstname,lastname,gender"
	    						+ ",age,attendancedate,patientfileno,authorizationno,servicetypeid,"
	    						+ "sourcefacilitycode,sourcedocumentno,letterrefno,patienttypecode,dateadmitted,"
	    						+ "datedischarged,createdby,datecreated,lastmodified,lastmodifiedby,DateOfBirth,"
	    						+ "TelephoneNo,EmployerNo,PractitionerName,QualificationID,SchemeID)"
	    						+ "values(newid(),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	    				ps2=nhifconn.prepareStatement(sSql);
	    				ps2.setString(1, sub(sClaimNo,50));
	    				ps2.setInt(2,nFolioNo);
	    				ps2.setString(3, sub(sSerialNo,50));
	    				ps2.setString(4, sub(rs.getString("OC_INSURANCE_NR"),20));
	    				ps2.setString(5, sub(rs3.getString("firstname"),50));
	    				ps2.setString(6, sub(rs3.getString("lastname"),50));
	    				String sGender=rs3.getString("gender");
	    				ps2.setString(7, sGender!=null && sGender.equalsIgnoreCase("M")?"Male":"Female");
	    				java.util.Date dBirth = rs3.getDate("dateofbirth");
	    				int age=1;
	    				if(dBirth!=null && Math.floor(getNrYears(dBirth, dInvoice))>1){
	    					age=(int)Math.floor(getNrYears(dBirth, dInvoice));
	    				}
	    				ps2.setDouble(8, age);
	    				ps2.setDate(9, new java.sql.Date(dInvoice.getTime()));
	    				ps2.setString(10,nPatientId+"");
	    				ps2.setString(11,sub(rs.getString("OC_PATIENTINVOICE_INSURARREFERENCE"),20));
	    				ps2.setInt(12,1);
	    				ps2.setString(13,null);
	    				ps2.setString(14,sub(nInvoiceObjectId+"",50));
	    				String sModifiers = rs.getString("OC_PATIENTINVOICE_MODIFIERS");
	    				ps2.setString(15,sModifiers.split(";")[0]);
	    				rs3.close();
	    				ps3.close();
	    				String sStatus="OUT";
	    				java.util.Date dAdmitted=null,dDischarged=null;
	    				ps3=conn.prepareStatement("select * from oc_debets,oc_encounters where oc_debet_patientinvoiceuid=? and oc_encounter_objectid=replace(oc_debet_encounteruid,'1.','')");
	    				ps3.setString(1, sInvoiceUid);
	    				rs3=ps3.executeQuery();
	    				HashSet practitioners = new HashSet();
	    				while(rs3.next()){
	    					String practitioner = rs3.getString("oc_debet_performeruid");
	    					if(practitioner!=null && practitioner.length()>0){
	    						practitioners.add(practitioner);
	    					}
	    					String s = rs3.getString("oc_encounter_type");
	    					if(s!=null && s.equalsIgnoreCase("admission")){
	    						sStatus="IN";
	    						dAdmitted=rs3.getDate("oc_encounter_begindate");
	    						dDischarged=rs3.getDate("oc_encounter_enddate");
	    					}
	    				}
	    				rs3.close();
	    				ps3.close();
	    				ps2.setString(16, sStatus);
	    				ps2.setDate(17, dAdmitted==null?null:new java.sql.Date(dAdmitted.getTime()));
	    				ps2.setDate(18, dDischarged==null?null:new java.sql.Date(dDischarged.getTime()));
	    				ps2.setString(19, sNHIFUserName);
	    				ps2.setDate(20, new java.sql.Date(dInvoice.getTime()));
	    				ps2.setDate(21, new java.sql.Date(new java.util.Date().getTime()));
	    				ps2.setString(22, sNHIFUserName);
	    				ps2.setDate(23, dDateOfBirth);
	    				ps3=conn.prepareStatement("select * from privateview where personid=?");
	    				ps3.setInt(1, nPatientId);
	    				rs3=ps3.executeQuery();
	    				if(rs3.next()){
	    					ps2.setString(24, rs3.getString("telephone"));
	    				}
	    				else{
	    					ps2.setString(24, "");
	    				}
	    				rs3.close();
	    				ps3.close();
	    				ps2.setString(25, "");
	    				String practitioner="";
	    				String qualification="";
	    				java.util.Iterator iPractitioners = practitioners.iterator();
	    				while(iPractitioners.hasNext()){
	    					String id = (String)iPractitioners.next();
	    					if(practitioner.length()>0){
	    						practitioner+=", ";
	    					}
		    				ps3=conn.prepareStatement("select lastname,firstname from usersview u,adminview a where u.personid=a.personid and userid=?");
		    				ps3.setInt(1, Integer.parseInt(id));
		    				rs3=ps3.executeQuery();
		    				if(rs3.next()){
		    					practitioner+=rs3.getString("firstname")+" "+rs3.getString("lastname");
			    				rs3.close();
			    				ps3.close();
			    				ps3=conn.prepareStatement("select * from ocadmin.dbo.userparameters where userid=? and parameter='medicalcentercode'");
			    				ps3.setInt(1, Integer.parseInt(id));
			    				rs3=ps3.executeQuery();
			    				if(rs3.next()){
	    							String mc =  rs3.getString("value");
	    							try{
		    							if(mc!=null && mc.length()>0 && (qualification.length()==0 || Integer.parseInt(qualification)>Integer.parseInt(mc))){
		    								qualification=mc;
		    							}
	    							}
	    							catch(Exception e){
	    								e.printStackTrace();
	    							}
			    				}
		    				}
		    				rs3.close();
		    				ps3.close();
	    				}
	    				ps2.setString(26, practitioner);
	    				try{
	    					ps2.setInt(27, Integer.parseInt(qualification));
	    				}
	    				catch(Exception e){
	    					ps2.setInt(27, 0);
	    				}
	    				if(sInsurarUid.equalsIgnoreCase(sNHIF)){
	    					ps2.setInt(28, 1001);
	    				}
	    				else{
	    					ps2.setInt(28, 2001);
	    				}
	    				ps2.execute();
    				}
    				rs3.close();
    				ps3.close();
    				rs2.close();
    				ps2.close();
        			sSql="select * from Folios where ClaimNo=? and SerialNo=? and SourceDocumentNo=?";
        			ps2=nhifconn.prepareStatement(sSql);
        			ps2.setString(1, sClaimNo);
        			ps2.setString(2, sSerialNo);
        			ps2.setString(3, sub(nInvoiceObjectId+"",50));
        			rs2=ps2.executeQuery();
        			if(rs2.next()){
        				sFolioId=rs2.getString("FolioID");
        				System.out.println("Created new Folio with ID "+sFolioId);
        			}
    			}
    			rs2.close();
    			ps2.close();
    			//Nu zouden we een folio moeten hebben waar we de folioitems (prestaties) kunnen aan toevoegen
    			if(sFolioId.length()>0){
    				//Eerst zoeken we alle prestaties op die aan de actieve factuur verbonden zijn
    				PreparedStatement ps3=conn.prepareStatement("select sum(OC_DEBET_QUANTITY) OC_DEBET_QUANTITY,"
						+ " oc_prestation_code,"
						+ " oc_prestation_nomenclature,oc_insurance_insuraruid"
						+ " from oc_debets,oc_prestations,oc_insurances "
						+ " where "
						+ " oc_prestation_objectid=replace(oc_debet_prestationuid,'1.','') and "
						+ " oc_insurance_objectid=replace(oc_debet_insuranceuid,'1.','') and "
						+ " oc_debet_patientinvoiceuid=? and oc_debet_credited=0"
						+ " group by oc_prestation_code,oc_prestation_nomenclature,oc_insurance_insuraruid");
    				ps3.setString(1, "1."+nInvoiceObjectId);
    				ResultSet rs3=ps3.executeQuery();
    				while(rs3.next()){
    					String sDebetInternalCode=rs3.getString("oc_prestation_code");
    					String sDebetUid="OpenClinic invoice ID: "+nInvoiceObjectId+" Health service ID: "+sDebetInternalCode;
    					//Hier beslissen welke code wordt gebruikt: interne code of NHIF code
    					//interne code = OC_PRESTATION_CODE
    					//NHIF code = OC_PRESTATION_NOMENCLATURE
    					String sDebetCode=rs3.getString("oc_prestation_nomenclature");
    					if(sDebetCode!=null && sDebetCode.length()>0){
	    					try{
	    						sDebetCode=Integer.parseInt(sDebetCode)+"";
	    					}
	    					catch(Exception e){
	    						e.printStackTrace();
	    					}
	    					int nQuantity=rs3.getInt("OC_DEBET_QUANTITY");
	    					if(nQuantity>-9999){
		    					//Eerst kijken we of dit item nog niet is toegevoegd geworden
		    					sSql="select * from FolioItems where FolioID=? and OtherDetails=?";
		    					ps2=nhifconn.prepareStatement(sSql);
		    					ps2.setString(1, sFolioId);
		    					ps2.setString(2, sDebetUid);
		    					rs2=ps2.executeQuery();
		    					if(rs2.next()){
		    						System.out.println("Folio item "+rs2.getString("FolioItemID")+" already exists for debet "+sDebetUid);
		    					}
		    					else {
		    						System.out.println("Insert new Folio item for debet "+sDebetUid);
		    						int nItemTypeId=-1;
		    						double nUnitPrice=0;
		    						rs2.close();
		    						ps2.close();
		    						//Find item type
		    						sSql="select * from PackageItems where ItemCode=?";
		    						ps2=nhifconn.prepareStatement(sSql);
		    						ps2.setString(1, sDebetCode);
		    						rs2=ps2.executeQuery();
		    						if(rs2.next()){
		    							nItemTypeId=rs2.getInt("ItemTypeId");
		    						}
		    						rs2.close();
		    						ps2.close();
		    						//Find unit price
		    						sSql="select * from GenericPackage where ItemCode=? and PackageID=?";
		    						ps2=nhifconn.prepareStatement(sSql);
		    						ps2.setString(1, sDebetCode);
		    	    				if(sInsurarUid.equalsIgnoreCase(sNHIF)){
		    	    					ps2.setInt(2, 102);
		    	    				}
		    	    				else{
		    	    					ps2.setInt(2, 201);
		    	    				}
		    						rs2=ps2.executeQuery();
		    						if(rs2.next()){
		    							nUnitPrice=rs2.getDouble("UnitPrice");
		    						}
		    						if(nItemTypeId>-1){
		        						rs2.close();
		        						ps2.close();
				    					sSql="insert into FolioItems(FolioItemID,FolioID,ItemTypeID,ItemCode,OtherDetails,ItemQuantity,"
				    							+ "UnitPrice,AmountClaimed,CreatedBy,datecreated,lastmodifiedby,lastmodified,PriceCode)"
				    							+ " values(newid(),?,?,?,?,?,?,?,?,?,?,?,?)";
				    					ps2=nhifconn.prepareStatement(sSql);
				    					ps2.setString(1, sFolioId);
				    					ps2.setInt(2,nItemTypeId);
				    					ps2.setString(3, sDebetCode);
				    					ps2.setString(4, sDebetUid);
				    					ps2.setInt(5,nQuantity);
				    					ps2.setDouble(6, nUnitPrice);
				    					ps2.setDouble(7,nQuantity*nUnitPrice);
				    					ps2.setString(8, sNHIFUserName);
				    					ps2.setDate(9, new java.sql.Date(dInvoice.getTime()));
				    					ps2.setString(10, sNHIFUserName);
				    					ps2.setDate(11, new java.sql.Date(new java.util.Date().getTime()));
			    	    				if(sInsurarUid.equalsIgnoreCase(sNHIF)){
			    	    					ps2.setString(12, "102-"+sDebetCode);
			    	    				}
			    	    				else{
			    	    					ps2.setString(12, "201-"+sDebetCode);
			    	    				}
				    					ps2.execute();
		    						}
		    						else{
		    							System.out.println("Health service code "+sDebetCode+" has no mapping on NHIF code table");
		        						sSql="delete from unknownhealthservicecodes where code=? and type='wrong-nhif'";
		        						PreparedStatement ps4=nhifconn.prepareStatement(sSql);
		        						ps4.setString(1, sDebetInternalCode);
		        						ps4.execute();
		        						ps4.close();
		        						sSql="insert into unknownhealthservicecodes(code,type) values(?,'wrong-nhif')";
		        						ps4=nhifconn.prepareStatement(sSql);
		        						ps4.setString(1, sDebetInternalCode);
		        						ps4.execute();
		        						ps4.close();
		    						}
		    					}
		    					rs2.close();
		    					ps2.close();
	    					}
    					}
    					else {
    						System.out.println("NHIF code has not been specified for debet code "+sDebetInternalCode);
    						sSql="delete from unknownhealthservicecodes where code=? and type='no-nhif'";
    						PreparedStatement ps4=nhifconn.prepareStatement(sSql);
    						ps4.setString(1, sDebetInternalCode);
    						ps4.execute();
    						ps4.close();
    						sSql="insert into unknownhealthservicecodes(code,type) values(?,'no-nhif')";
    						ps4=nhifconn.prepareStatement(sSql);
    						ps4.setString(1, sDebetInternalCode);
    						ps4.execute();
    						ps4.close();
    					}
    				}
    				rs3.close();
    				ps3.close();
        			java.util.Date dBeginDate=null;
        			java.util.Date dEndDate=null;
    				ps3=conn.prepareStatement("select * from oc_debets,oc_encounters where oc_debet_patientinvoiceuid=? and oc_encounter_objectid=replace(oc_debet_encounteruid,'1.','')");
    				ps3.setString(1, sInvoiceUid);
    				rs3=ps3.executeQuery();
    				while(rs3.next()){
    					String s = rs3.getString("oc_encounter_type");
   						java.util.Date d1=rs3.getDate("oc_encounter_begindate");
   						if(dBeginDate==null || (d1!=null && d1.before(dBeginDate))){
   							dBeginDate=d1;
   						}
   						java.util.Date d2=rs3.getDate("oc_encounter_enddate");
   						if(dEndDate==null || (d2!=null && d2.after(dEndDate))){
   							dEndDate=d2;
   						}
    				}
    				rs3.close();
    				ps3.close();
    				if(dEndDate==null){
    					dEndDate=new java.util.Date();
    				}
    				//Nu gaan we alle ziektecodes opzoeken die aan de encounters van deze factuur verbonden zijn
    				//De codes moeten geconverteerd worden en daarna toegevoegd aan e-Claims
    				ps3=conn.prepareStatement("select i1.type from healthrecord h,transactions t,items i1"+
    										" where h.personid=? and"+ 
    										" h.healthrecordid=t.healthrecordid and"+
    										" (abs(DATEDIFF(day,t.updatetime,?))<=1 or"+
    										" abs(DATEDIFF(day,t.updatetime,?))<=1 or"+
    										" (t.updatetime>=? and"+
    										" t.updatetime<=?)) and"+
    										" i1.transactionid=t.transactionid and"+
    										" i1.type like 'ICD10Code%'"+
    										" union"+
    										" select i1.type from healthrecord h,transactions t,items i1,items i2"+
											" where h.personid=? and"+ 
											" h.healthrecordid=t.healthrecordid and"+
    										" i1.transactionid=t.transactionid and"+
    										" i1.type like 'ICD10Code%' and"+
    										" i2.transactionid=t.transactionid and"+
    										" i2.type ='be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID' and"+
    										" i2.value=?");
    				ps3.setInt(1, nPatientId);
    				ps3.setDate(2, new java.sql.Date(dBeginDate.getTime()));
    				ps3.setDate(3, new java.sql.Date(dEndDate.getTime()));
    				ps3.setDate(4, new java.sql.Date(dBeginDate.getTime()));
    				ps3.setDate(5, new java.sql.Date(dEndDate.getTime()));
    				ps3.setInt(6, nPatientId);
    				ps3.setString(7, sEncounterUid);
    				rs3=ps3.executeQuery();
    				boolean bFoundUnmapped=false;
    				while(rs3.next()){
    					//We zoeken nu de mapping op naar de diagnoses in NHIF, indien niet gevonden gebruiken we 0
    					ps2=conn.prepareStatement("select * from icd10_to_nhif where icd10 like ?");
    					String sIcd10=rs3.getString("type").replaceAll("ICD10Code", "");
						System.out.println("Adding ICD10 code "+sIcd10);
    					ps2.setString(1, sIcd10+"%");
    					rs2=ps2.executeQuery();
    					int n=0;
    					if(rs2.next()){
    						n++;
    						String sNHIFcode = rs2.getInt("NHIF")+"";
    						//Eerst controleren of deze diagnose niet reeds werd toegevoegd
    						sSql="select * from FolioDiseases where FolioID=? and DiseaseCode=?";
    						PreparedStatement ps4=nhifconn.prepareStatement(sSql);
    						ps4.setString(1,sFolioId);
    						ps4.setString(2, sNHIFcode);
    						ResultSet rs4=ps4.executeQuery();
    						if(rs4.next()){
    							System.out.println("Disease Folio ID "+rs4.getString("FolioID")+" is already mapped to disease code "+sNHIFcode);
    						}
    						else{
    							System.out.println("Creating Disease Folio ID for disease code "+sNHIFcode);
    							rs4.close();
    							ps4.close();
    							sSql="insert into FolioDiseases(FolioDiseaseID,DiseaseCode,FolioID,Remarks,"
    									+ "CreatedBy,DateCreated,LastModifiedBy,LastModified)"
    									+ " values(newid(),?,?,?,?,?,?,?)";
    							ps4=nhifconn.prepareStatement(sSql);
    							ps4.setString(1,sNHIFcode);
    							ps4.setString(2, sFolioId);
    							ps4.setString(3, "ICD10: "+sIcd10);
    							ps4.setString(4, sNHIFUserName);
    							ps4.setDate(5, new java.sql.Date(dInvoice.getTime()));
    							ps4.setString(6, sNHIFUserName);
    							ps4.setDate(7, new java.sql.Date(new java.util.Date().getTime()));
    							ps4.execute();
    						}
    						rs4.close();
    						ps4.close();
    					}
    					else{
    						if(sIcd10.split("\\.").length>1){
    							sIcd10=sIcd10.split("\\.")[0];
    							System.out.println("Not found, trying ICD10 code "+sIcd10);
    							rs2.close();
    							ps2.close();
    	    					ps2=conn.prepareStatement("select * from icd10_to_nhif where icd10 like ?");
    	    					ps2.setString(1, sIcd10+"%");
    	    					rs2=ps2.executeQuery();
    	    					if(rs2.next()){
    	    						n++;
    	    						String sNHIFcode = rs2.getInt("NHIF")+"";
    	    						//Eerst controleren of deze diagnose niet reeds werd toegevoegd
    	    						sSql="select * from FolioDiseases where FolioID=? and DiseaseCode=?";
    	    						PreparedStatement ps4=nhifconn.prepareStatement(sSql);
    	    						ps4.setString(1,sFolioId);
    	    						ps4.setString(2, sNHIFcode);
    	    						ResultSet rs4=ps4.executeQuery();
    	    						if(rs4.next()){
    	    							System.out.println("Disease Folio ID "+rs4.getString("FolioID")+" is already mapped to disease code "+sNHIFcode);
    	    						}
    	    						else{
    	    							System.out.println("Creating Disease Folio ID for disease code "+sNHIFcode);
    	    							rs4.close();
    	    							ps4.close();
    	    							sSql="insert into FolioDiseases(FolioDiseaseID,DiseaseCode,FolioID,Remarks,"
    	    									+ "CreatedBy,DateCreated,LastModifiedBy,LastModified)"
    	    									+ " values(newid(),?,?,?,?,?,?,?)";
    	    							ps4=nhifconn.prepareStatement(sSql);
    	    							ps4.setString(1,sNHIFcode);
    	    							ps4.setString(2, sFolioId);
    	    							ps4.setString(3, "ICD10: "+sIcd10);
    	    							ps4.setString(4, sNHIFUserName);
    	    							ps4.setDate(5, new java.sql.Date(dInvoice.getTime()));
    	    							ps4.setString(6, sNHIFUserName);
    	    							ps4.setDate(7, new java.sql.Date(new java.util.Date().getTime()));
    	    							ps4.execute();
    	    						}
    	    						rs4.close();
    	    						ps4.close();
    	    					}
    						}
    					}
						rs2.close();
						ps2.close();
    					if(n==0){
    						System.out.println("No Mapping exists for ICD10 code "+sIcd10);
    						sSql="delete from unknowndiagnoses where icd10=?";
    						PreparedStatement ps4=nhifconn.prepareStatement(sSql);
    						ps4.setString(1, sIcd10);
    						ps4.execute();
    						ps4.close();
    						sSql="insert into unknowndiagnoses(icd10) values(?)";
    						ps4=nhifconn.prepareStatement(sSql);
    						ps4.setString(1, sIcd10);
    						ps4.execute();
    						ps4.close();
    					}
    				}
    				rs3.close();
    				ps3.close();
    			}
    			else{
    				System.out.println("ERROR: folio does not exist for Claim n°"+sClaimNo+" and Serial N°"+sSerialNo);
    			}
    		}
    		rs.close();
    		ps.close();
    	}
    	else {
    		System.out.println("NHIF UID MISSING!");
    	}
	    conn.close();
	    nhifconn.close();
	}
	
    public static float getNrYears(java.util.Date startDate, java.util.Date endDate){
        if(startDate == null || endDate == null){
            return 0;
        }
        
        Calendar start = new GregorianCalendar();
        Calendar end = new GregorianCalendar();
        start.setTime(startDate);
        end.setTime(endDate);
        long millis = end.getTimeInMillis() - start.getTimeInMillis();
        long days = millis / (1000 * 60 * 60 * 24)+1;

        // +1 to make the end inclusive
        // Count number of february 29's between cal1 and cal2
        int startyear = start.get(Calendar.YEAR);
        int endyear = end.get(Calendar.YEAR);
        if(start.get(Calendar.MONTH) > Calendar.FEBRUARY){
            startyear++;
        }
        if(end.get(Calendar.MONTH) < Calendar.FEBRUARY || (end.get(Calendar.MONTH) == Calendar.FEBRUARY && end.get(Calendar.DAY_OF_MONTH) < 29)){
            endyear--;
        }
        int feb29s = 0;
        for (int i = startyear; i <= endyear; i++){
            if((i % 4 == 0) && (i % 100!=0) || (i % 400 == 0)){
                feb29s++;
            }
        }
        
        return (float) (days - feb29s) / 365;
    }

}
