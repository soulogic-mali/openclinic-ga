package be.openclinic.medical;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.jfree.data.time.TimeSeries;

import net.admin.AdminPerson;
import net.admin.User;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;

public class Vaccination {
	public String personid,date,type,batchnumber,expiry,location,observation,modifier;
	
	public Vaccination(String personid, String date, String type, String batchnumber, String expiry, String location,
			String observation, String modifier) {
		super();
		this.personid = personid;
		this.date = date;
		this.type = type;
		this.batchnumber = batchnumber;
		this.expiry = expiry;
		this.location = location;
		this.observation = observation;
		this.modifier = modifier;
	}

	public Vaccination(){
		
	}
	
	public long getAge(){
		long d = 0;
		try{
			d= new java.util.Date().getTime()-ScreenHelper.parseDate(date).getTime();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return d;
	}
	
	public void delete(){
		date="";
		batchnumber="";
		expiry="";
		location="";
		observation="";
		modifier="";
		save();
	}
	
	public static boolean isActive(Hashtable vaccinations,String type){
		Vaccination vaccination = (Vaccination)vaccinations.get(type);
		return vaccination!=null && vaccination.date!=null && vaccination.date.length()>0;
	}
	
	public void save(){
		try{
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("delete from OC_VACCINATIONS where OC_VACCINATION_PATIENTUID = ? and"
					+ " OC_VACCINATION_TYPE=?");
			ps.setString(1,personid);
			ps.setString(2,type);
			ps.execute();
			ps.close();
			ps = conn.prepareStatement("insert into OC_VACCINATIONS(OC_VACCINATION_PATIENTUID,OC_VACCINATION_DATE,OC_VACCINATION_TYPE,"
					+ "OC_VACCINATION_BATCHNUMBER,OC_VACCINATION_EXPIRY,OC_VACCINATION_LOCATION,OC_VACCINATION_UPDATETIME,OC_VACCINATION_OBSERVATION,OC_VACCINATION_MODIFIER) values(?,?,?,?,?,?,?,?,?)");
			ps.setString(1,personid);
			ps.setString(2,date);
			ps.setString(3,type);
			ps.setString(4,batchnumber);
			ps.setString(5,expiry);
			ps.setString(6,location);
			ps.setTimestamp(7,new java.sql.Timestamp(new java.util.Date().getTime()));
			ps.setString(8,observation);
			ps.setString(9,modifier);
			ps.execute();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public static Hashtable getVaccinations(String personid){
		Hashtable vaccinations = new Hashtable();
		try{
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("select * from OC_VACCINATIONS where OC_VACCINATION_PATIENTUID=?");
			ps.setString(1,personid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				Vaccination vaccination = new Vaccination();
				vaccination.personid=rs.getString("OC_VACCINATION_PATIENTUID");
				vaccination.date=rs.getString("OC_VACCINATION_DATE");
				vaccination.type=rs.getString("OC_VACCINATION_TYPE");
				vaccination.batchnumber=rs.getString("OC_VACCINATION_BATCHNUMBER");
				vaccination.expiry=rs.getString("OC_VACCINATION_EXPIRY");
				vaccination.location=ScreenHelper.checkString(rs.getString("OC_VACCINATION_LOCATION"));
				vaccination.observation=rs.getString("OC_VACCINATION_OBSERVATION");
				vaccination.modifier=rs.getString("OC_VACCINATION_MODIFIER");
				vaccinations.put(vaccination.type,vaccination);
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return vaccinations;
	}

	public static HashSet getVaccinationsTodo(String personid){
		boolean bred=false;
		long age=0;
		try{
			AdminPerson person = AdminPerson.getAdminPerson(personid);
	    	age = new java.util.Date().getTime()-ScreenHelper.parseDate(person.dateOfBirth).getTime();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		long day = 24*3600*1000;
		long week=7*day;
		long month=30*day;
		long year=365*day;
		HashSet vaccinations = new HashSet();
		Hashtable allvaccinations = getVaccinations(personid);
		String[] vaccins="bcg;polio0;polio1;penta1;pneumo1;rota1;polio2;penta2;pneumo2;rota2;polio3;penta3;pneumo3;rota3;measles;yellowfever;meningitisa;vat1;vat2;vatr1;vatr2;vatr3;vita100;vita200.1;vita200.2;alben200.1;alben400.1".split(";");
		for(int n=0;n<vaccins.length;n++){
			Vaccination vaccination=(Vaccination)allvaccinations.get(vaccins[n]);
			if(vaccination==null || vaccination.date==null || vaccination.date.trim().length()==0){
				Vaccination vat1=(Vaccination)allvaccinations.get("vat1");
				Vaccination vat2=(Vaccination)allvaccinations.get("vat2");
				Vaccination vatr1=(Vaccination)allvaccinations.get("vatr1");
				Vaccination vatr2=(Vaccination)allvaccinations.get("vatr2");
				Vaccination vatr3=(Vaccination)allvaccinations.get("vatr3");
			
				//Vaccination rules base
				if("*bcg*polio0*".contains(vaccins[n])){
					//BIRTH
					bred=age<week;
				}
				if("*polio1*penta1*pneumo1*rota1*".contains(vaccins[n])){
					//6 WEEKS
					bred=(age>=6*week&&age<10*week);
				}
				if("*polio2*penta2*pneumo2*rota2*".contains(vaccins[n])){
					//10 WEEKS
					bred=(age>=10*week&&age<14*week);
				}
				if("*polio3*penta3*pneumo3*rota3*".contains(vaccins[n])){
					//14 WEEKS
					bred=(age>=14*week&&age<9*month);
				}
				if("*measles*yellowfever*meningitisa*".contains(vaccins[n])){
					//9 MONTHS
					bred=(age>=9*month&&age<13*month);
				}
				else if("*vat1*vat2*vatr1*vatr2*vatr3*".contains(vaccins[n])){
					//15-49 years
					if(age>=15*year&&age<50*year){
						
						bred=vaccins[n].equalsIgnoreCase("vat1") && vat2==null && vatr1==null && vatr2==null && vatr3==null;
						bred=bred||(vaccins[n].equalsIgnoreCase("vat2") && vat1!=null && vat1.getAge()>=30*day && vatr1==null && vatr2==null && vatr3==null);
						bred=bred||(vaccins[n].equalsIgnoreCase("vatr1") && vat2!=null && vat2.getAge()>=6*month && vatr2==null && vatr3==null);
						bred=bred||(vaccins[n].equalsIgnoreCase("vatr2") && vatr1!=null && vatr1.getAge()>=year && vatr3==null);
						bred=bred||(vaccins[n].equalsIgnoreCase("vatr3") && vatr2!=null && vatr2.getAge()>=year);
					}
				}
				else if("*vita100*vita100a*".contains(vaccins[n])){
					bred=(age>=6*month-week && age<12*month);
				}
				else if("*vita200.1*alben200.1*vita200.1a*alben200.1a*vita200.1b*alben200.1b*".contains(vaccins[n])){
					bred=(age>=12*month-week && age<24*month);
				}
				else if("*vita200.2*alben400.1*vita200.2a*alben400.1a*vita200.2b*alben400.1b*vita200.2c*alben400.1c*vita200.2d*alben400.1d*".contains(vaccins[n])){
					bred=(age>=24*month-week && age<60*month);
				}
				if(bred){
					vaccinations.add(vaccins[n]);
				}
			}

		}
		return vaccinations;
	}

    public static List getListValueGraph(int serverId, String type, String sLanguage, String userid) {
        Connection conn = null;
        PreparedStatement ps = null;
        List lArray = new LinkedList();
        try {
        	long day=24*3600*1000;
        	long year=365*day;
            TimeSeries series = new TimeSeries("data");
            conn = MedwanQuery.getInstance().getStatsConnection();
            ps = conn.prepareStatement("select count(*) total,year(DC_VACCINATION_DATE) YEAR,month(DC_VACCINATION_DATE) MONTH from DC_VACCINATIONS where DC_VACCINATION_SERVERUID=? and"
            		+ " DC_VACCINATION_MODEL='mali' and DC_VACCINATION_TYPE like ? and DC_VACCINATION_DATE>? group by year(DC_VACCINATION_DATE),month(DC_VACCINATION_DATE) order by year(DC_VACCINATION_DATE) ASC,month(DC_VACCINATION_DATE) ASC");
            ps.setInt(1, serverId);
            ps.setString(2, type+"%");
            ps.setDate(3, new java.sql.Date(new java.util.Date().getTime()-5*year));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Date dDate = ScreenHelper.parseDate("01/" + rs.getString("MONTH") + "/" + rs.getString("YEAR"));
                Integer iValue = Integer.parseInt(rs.getString("total"));
                lArray.add(new Object[]{dDate, iValue});
            }
            rs.close();
        }
        catch (Exception e) {
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (SQLException e2) {
                // TODO Auto-generated catch block
                e2.printStackTrace();
            }
            e.printStackTrace();
        }
        finally {
            try {
                conn.close();
            } catch (SQLException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        return lArray;
    }

    public static String getVaccination(Hashtable vaccinations,long age,HttpServletRequest request,String type,String parameter){
		String sResult="";
		String tag="<td class='admin2'>";
		String redtag="<td bgcolor='#FE4B59'>";
		//Find vaccination here
		Vaccination vaccination=(Vaccination)vaccinations.get(type);
		if(vaccination!=null){
			if(parameter.equalsIgnoreCase("date")){
				sResult=vaccination.date;
			}
			else if(parameter.equalsIgnoreCase("type")){
				sResult=vaccination.type;
			}
			else if(parameter.equalsIgnoreCase("batchnumber")){
				sResult=vaccination.batchnumber;
			}
			else if(parameter.equalsIgnoreCase("expiry")){
				sResult=vaccination.expiry;
			}
			else if(parameter.equalsIgnoreCase("observation")){
				sResult=vaccination.observation;
			}
			else if(parameter.equalsIgnoreCase("modifier")){
				sResult=vaccination.modifier;
			}
			else if(parameter.equalsIgnoreCase("location")){
				sResult=ScreenHelper.checkString(vaccination.location);
				if(sResult.startsWith("0")){
					sResult=ScreenHelper.getTranNoLink("vaccinationlocation",MedwanQuery.getInstance().getConfigString("defaultVaccinationLocation"),((User)request.getSession().getAttribute("activeUser")).person.language);
				}
				else if (sResult.length()==0){
					sResult="?";
				}
				else {
					sResult=ScreenHelper.getTranNoLink("vaccinationlocation",(sResult+" ").substring(0,1),((User)request.getSession().getAttribute("activeUser")).person.language);
				}
			}
		}
		
		if(parameter.equalsIgnoreCase("date")){
			boolean bred=false,bgreen=false,bedit=true;
			long day = 24*3600*1000;
			long week=7*day;
			long month=30*day;
			long year=365*day;
			Vaccination vat1=(Vaccination)vaccinations.get("vat1");
			Vaccination vat2=(Vaccination)vaccinations.get("vat2");
			Vaccination vatr1=(Vaccination)vaccinations.get("vatr1");
			Vaccination vatr2=(Vaccination)vaccinations.get("vatr2");
			Vaccination vatr3=(Vaccination)vaccinations.get("vatr3");
		
			//Vaccination rules base
			if(sResult.length()==0){
				if("*bcg*polio0*".contains(type)){
					//BIRTH
					bred=age<week;
				}
				if("*polio1*penta1*pneumo1*rota1*".contains(type)){
					//6 WEEKS
					bred=(age>=6*week&&age<10*week);
				}
				if("*polio2*penta2*pneumo2*rota2*".contains(type)){
					//10 WEEKS
					bred=(age>=10*week&&age<14*week);
				}
				if("*polio3*penta3*pneumo3*rota3*".contains(type)){
					//14 WEEKS
					bred=(age>=14*week&&age<9*month);
				}
				if("*measles*yellowfever*meningitisa*".contains(type)){
					//9 MONTHS
					bred=(age>=9*month&&age<13*month);
				}
				else if("*vat1*vat2*vatr1*vatr2*vatr3*".contains(type)){
					//15-49 years
					if(age>=15*year&&age<50*year){
						
						bred=type.equalsIgnoreCase("vat1") && vat2==null && vatr1==null && vatr2==null && vatr3==null;
						bred=bred||(type.equalsIgnoreCase("vat2") && vat1!=null && vat1.getAge()>=30*day && vatr1==null && vatr2==null && vatr3==null);
						bred=bred||(type.equalsIgnoreCase("vatr1") && vat2!=null && vat2.getAge()>=6*month && vatr2==null && vatr3==null);
						bred=bred||(type.equalsIgnoreCase("vatr2") && vatr1!=null && vatr1.getAge()>=year && vatr3==null);
						bred=bred||(type.equalsIgnoreCase("vatr3") && vatr2!=null && vatr2.getAge()>=year);
					}
				}
				else if("*vita100*vita100a*".contains(type)){
					bred=(age>=6*month-week && age<12*month);
				}
				else if("*vita200.1*alben200.1*".contains(type)){
					bred=(age>=12*month-week && age<24*month);
				}
				else if("*vita200.2*alben400.1*".contains(type)){
					bred=(age>=24*month-week && age<60*month);
				}
				if(type.equalsIgnoreCase("vita100a")) bedit = Vaccination.isActive(vaccinations,"vita100");
				if(type.equalsIgnoreCase("vita200.1a")) bedit = Vaccination.isActive(vaccinations,"vita200.1");
				if(type.equalsIgnoreCase("vita200.1b")) bedit =  Vaccination.isActive(vaccinations,"vita200.1a");
				if(type.equalsIgnoreCase("alben200.1a")) bedit =  Vaccination.isActive(vaccinations,"alben200.1");
				if(type.equalsIgnoreCase("alben200.1b")) bedit =  Vaccination.isActive(vaccinations,"alben200.1a");
				if(type.equalsIgnoreCase("vita200.2a")) bedit =  Vaccination.isActive(vaccinations,"vita200.2");
				if(type.equalsIgnoreCase("vita200.2b")) bedit =  Vaccination.isActive(vaccinations,"vita200.2a");
				if(type.equalsIgnoreCase("vita200.2c")) bedit =  Vaccination.isActive(vaccinations,"vita200.2b");
				if(type.equalsIgnoreCase("vita200.2d")) bedit = Vaccination.isActive(vaccinations,"vita200.2c");
				if(type.equalsIgnoreCase("alben400.1a")) bedit =  Vaccination.isActive(vaccinations,"alben400.1");
				if(type.equalsIgnoreCase("alben400.1b")) bedit =  Vaccination.isActive(vaccinations,"alben400.1a");
				if(type.equalsIgnoreCase("alben400.1c")) bedit =  Vaccination.isActive(vaccinations,"alben400.1b");
				if(type.equalsIgnoreCase("alben400.1d")) bedit =  Vaccination.isActive(vaccinations,"alben400.1c");
				
				sResult=(bred?redtag:tag)+(bedit?"<img src='"+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/_img/icons/icon_new.png' "
						+ "onclick='editVaccination(\""+type+"\");'/>":"");
			}
			else {
				//result is a date value
				java.util.Date vaccinationDate = ScreenHelper.parseDate(sResult);
				long vaccinationAge=0;
				if(vaccinationDate!=null){
					vaccinationAge=(vaccinationDate.getTime()-new java.util.Date().getTime()+age);
					if("*bcg*polio0*polio1*penta1*pneumo1*rota1*polio2*penta2*pneumo2*rota2*polio3*penta3*pneumo3*rota3*".contains(type)){
						//express in weeks
						sResult+=" ("+vaccinationAge/week+" "+ScreenHelper.getTran(null,"web","weeks",((User)request.getSession().getAttribute("activeUser")).person.language)+")";
					}
					else if("*measles*yellowfever*meningitisa*vita100*vita100a*vita200.1*alben200.1*vita200.1a*alben200.1a*vita200.1b*alben200.1b*vita200.2*alben400.1*vita200.2a*alben400.1a*vita200.2b*alben400.1b*vita200.2c*alben400.1c*vita200.2d*alben400.1d*".contains(type)){
						//express in months
						sResult+=" ("+vaccinationAge/month+" "+ScreenHelper.getTran(null,"web","months",((User)request.getSession().getAttribute("activeUser")).person.language)+")";
					}
					else if("*vat1*vat2*vatr1*vatr2*vatr3*".contains(type)){
						//express in years
						sResult+=" ("+vaccinationAge/year+" "+ScreenHelper.getTran(null,"web","years",((User)request.getSession().getAttribute("activeUser")).person.language)+")";
					}
				}
				sResult="<td bgcolor='lightgreen'><img src='"+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/_img/icons/icon_edit.png' "
						+ "onclick='editVaccination(\""+type+"\");'/>"+sResult;
				//Check if a warning must be added because of late vaccination
				boolean bWarning=false;
				bWarning=bWarning||("*bcg*polio0*".contains(type) && vaccinationAge/week>=4);
				bWarning=bWarning||("*polio1*penta1*pneumo1*rota1*".contains(type) && (vaccinationAge/week>=10 || vaccinationAge/week<5));
				bWarning=bWarning||("*polio2*penta2*pneumo2*rota2*".contains(type) && (vaccinationAge/week>=14 || vaccinationAge/week<9));
				bWarning=bWarning||("*polio3*penta3*pneumo3*rota3*".contains(type) && (vaccinationAge/month>=6 || vaccinationAge/week<13));
				bWarning=bWarning||("*measles*yellowfever*meningitisa*".contains(type) && (vaccinationAge/month>=12 || (vaccinationAge/month)<8));
				if(bWarning){
					sResult+=" <img src='"+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/_img/icons/icon_warning.gif' title='"+ScreenHelper.getTranNoLink("web","latevaccination",((User)request.getSession().getAttribute("activeUser")).person.language)+"'/>";
				}
			}
		}
		else {
			sResult=tag+sResult;
		}
		sResult+="</td>";
		return sResult;
	}
}
