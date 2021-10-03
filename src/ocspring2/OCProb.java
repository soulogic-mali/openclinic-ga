package ocspring2;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;
import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import ocspring2.*;
/*
used tables:
1. sintomis2: data import

2. work tables and views:
      sintomis
      poterireplex
      myselected2
      expimage
      diagnosid
      probabilita
      myrelated
      MYVIEW1
      MYVIEW2
      MYVIEW3   
      probabilita

3; export table: powertable

- import procedure : add_argument_in_sintomis_and_prob(int nrs, boolean present)
    for each argument
- export procedure:
   public Vector<Vector> getListData() {
   with fields: vectorSQL = "SELECT  id,  ZIEKE,  Espr1,  cutoff,  NRS,  SYMPE,  NRZ,  PC,  PE,  Prev,  PCE_REF,  Maxpcpe FROM powertable"; 
*/

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.ScreenHelper;

public class OCProb {
	
	String mysql;
	String language="";
	double mypc = 0.0;
	double mype = 0.0;
	double myprev = 0.0;
	final int MAXDIAGS = MedwanQuery.getInstance().getConfigInt("ikireziMaximumNumberOfDiagnoses",6);
	final int MAXSYMPTOMS = MedwanQuery.getInstance().getConfigInt("ikireziMaximumNumberOfSymptoms",50);
	String sessionid;

 
    public void setup(Hashtable symptoms) {
    	//Symptoms: key = (int)nrs, value = (boolean)present
    	try {
	        Db.Connect();
	        Prepare_Work_Tables();
	        setupProb();
	        Enumeration<Integer> eSymptoms =symptoms.keys();
	        while(eSymptoms.hasMoreElements()){
	        	int symptom = (Integer)eSymptoms.nextElement();
	        	add_argument_in_sintomis_and_prob(symptom,(boolean)symptoms.get(symptom));
	        }
	        create_powerTable();
    	} catch (SQLException ex) {
    		ex.printStackTrace();
    	}
   }
    
    
    private void create_powerTable() {
    	mysql = "CREATE TABLE IF NOT EXISTS POWERTABLE ("
              + " sessionid varchar(50),"
              + " id int(11) NOT NULL AUTO_INCREMENT,"
              + " ZIEKE VARCHAR(50)  CHARACTER SET UTF8,"
              + " ZIEKF VARCHAR(50)  CHARACTER SET UTF8,"
              + " ZIEKN VARCHAR(50)  CHARACTER SET UTF8,"
              + " ZIEKP VARCHAR(50)  CHARACTER SET UTF8,"
              + " ZIEKI VARCHAR(50)  CHARACTER SET UTF8,"
              + " ZIEKS VARCHAR(50)  CHARACTER SET UTF8,"
              + " Espr1 DOUBLE PRECISION,"
              + " cutoff DOUBLE PRECISION,"
              + " NRS INTEGER,"
              + " SYMPE VARCHAR(50) CHARACTER SET UTF8,"
              + " SYMPF VARCHAR(50) CHARACTER SET UTF8,"
              + " SYMPN VARCHAR(50) CHARACTER SET UTF8,"
              + " SYMPP VARCHAR(50) CHARACTER SET UTF8,"
              + " SYMPI VARCHAR(50) CHARACTER SET UTF8,"
              + " SYMPS VARCHAR(50) CHARACTER SET UTF8,"
              + " NRZ INTEGER,"
              + " PC INTEGER,"
              + " PE INTEGER,"
              + " Prev DOUBLE PRECISION,"
              + " PCE_REF VARCHAR(2) CHARACTER SET UTF8,"
              + " Maxpcpe integer,"      //,"
              + " PRIMARY KEY (id))";
    	
    	Db.runsql(mysql);
    	Db.runsql("delete from powertable where sessionid='"+sessionid+"'");
    	int last_cols_nr = Db.get_integer("select count( * ) from sintomis where sessionid='"+sessionid+"'") + 1;
    	String pro_last = "Pro" + last_cols_nr;
    	mysql = "SELECT probabilita.NRZ, 100*( (pow(10, " + pro_last + ") / (1 + pow(10, " + pro_last + ")))  ) AS Espr1,DIAG_LANG.ZIEK"+language
              + " FROM probabilita INNER JOIN DIAG ON probabilita.NRZ = DIAG.NRZ INNER JOIN DIAG_LANG on DIAG.NRZ=DIAG_LANG.NRZ"
              + " WHERE ((probabilita." + pro_last + ")>=-2) " + " and sessionid='"+sessionid+"' ORDER BY probabilita." + pro_last + " DESC";
    	String mySQL = "select count(*) from (" + mysql + ") as x";
    	int cnt = Db.get_integer(mySQL);
    	String mysql2 = "";
    	try {
    		ResultSet rs = Db.conn.createStatement().executeQuery((mysql));
    		while (rs.next()) {
    			int DIAG_nr = rs.getInt(1);
    			String DIAG_nm = rs.getString(3);
    			double DIAG_espr1 = rs.getFloat(2);
    			String DIAG_espr1_s = String.valueOf(DIAG_espr1);
    			mysql2 = "insert into POWERTABLE "
                    + "(sessionid, ZIEK"+language+"   ,ESPR1    ,CUTOFF   ,NRS, SYMP"+language+"    ,NRZ      ,PC       ,PE      ,PREV  ,MAXPCPE   ) "
                    + "SELECT  '"+sessionid+"',DIAG_LANG.ZIEK"+language+", " + DIAG_espr1_s + " as Espr1,  DIAG.cutoff, SYM.NRS, SYM_LANG.SYMP"+language+" ,assocdata.nrz, 0 as PC, 0 as PE "
                    + " , assocdata.cont_sens as prev, 0 as MAXPCPE"
                    + "  FROM (ASSOCDATA"
                    + " INNER JOIN DIAG ON ASSOCDATA.NRZ = DIAG.NRZ) INNER JOIN SYM ON ASSOCDATA.NRS = SYM.NRS INNER JOIN DIAG_LANG on DIAG.NRZ=DIAG_LANG.NRZ INNER JOIN SYM_LANG on SYM_LANG.NRS=SYM.NRS"
                    + " WHERE (ASSOCDATA.NRZ = " + DIAG_nr + " and not(sym.TTYPE=4  and sym.TYPENURSE=0)"
                    + " And SYM.ttype>1 and ((" + DIAG_espr1_s
                    + ">= DIAG.cutoff) or " + DIAG_espr1_s + ">=0.01 )) ";
    			Db.runsql(mysql2);
    		}
    		rs.close();
    	} catch (SQLException ex) {
    		ex.printStackTrace();
    	}
    	cnt = Db.get_integer("select count( * ) from powertable where sessionid='"+sessionid+"'");
    	mysql2 = "DELETE FROM POWERTABLE WHERE sessionid='"+sessionid+"' and NRS IN (select NRS from sintomis where sessionid='"+sessionid+"')";
    	Db.runsql(mysql2);
    	mysql2 = "DELETE FROM POWERTABLE WHERE sessionid='"+sessionid+"' and POWERTABLE.NRS IN (select NRSimplies from implies where implies.nrs in (select nrs from sintomis where sessionid='"+sessionid+"'))";
    	Db.runsql(mysql2);
    	mysql2 = "DELETE FROM POWERTABLE WHERE sessionid='"+sessionid+"' and POWERTABLE.NRS IN (select NRSexclude from excludes where excludes.nrs in (select nrs from sintomis where sessionid='"+sessionid+"'))";
    	Db.runsql(mysql2);
    	mysql2 = "DELETE FROM POWERTABLE WHERE sessionid='"+sessionid+"' and POWERTABLE.NRS IN (select NRSmaycause from maycause where maycause.nrs in (select nrs from sintomis where sessionid='"+sessionid+"'))";
    	Db.runsql(mysql2);
    	cnt = Db.get_integer("select count(*) from powertable where sessionid='"+sessionid+"'");
    	mysql = "select ZIEK"+language+",ESPR1,CUTOFF,NRS,SYMP"+language+",NRZ,PC,PE,PREV,MAXPCPE  "
              + " from powertable where sessionid='"+sessionid+"' order by espr1 desc,maxpcpe asc";
    	try {
    		ResultSet rs = Db.conn.createStatement().executeQuery((mysql));
    		int diagCount = 0;
    		if (rs.next()) {
    			int nrzOld = 0;
    			do {
    				if (nrzOld != rs.getInt("NRZ")) {
    					nrzOld = rs.getInt("NRZ");
    					diagCount++;
    				}
    				int SYM_nr = rs.getInt("NRS");
    				int DIAG_nr = rs.getInt("NRZ");
    				fppcpe(DIAG_nr, SYM_nr);
    				int b = (int) Math.round(mypc);
    				int c = (int) Math.round(mype);
    				mysql = "update powertable set pc=" + b + ",pe=" + c + ",prev=" + myprev + " where sessionid='"+sessionid+"' and NRS=" + SYM_nr + " and nrz=" + DIAG_nr;
    				Db.runsql(mysql);
    				String mypcpe = "";
    				if (b < 1) {
    					mypcpe = "0";
    				} else if (b < 6) {
    					mypcpe = "1";
    				} else if (b < 17) {
    					mypcpe = "2";
    				} else if (b < 58) {
    					mypcpe = "3";
    				} else {
    					mypcpe = "4";
    				}
    				if (c < 1) {
    					mypcpe = mypcpe + "0";
    				} else if (c < 6) {
    					mypcpe = mypcpe + "1";
    				} else if (c < 17) {
    					mypcpe = mypcpe + "2";
    				} else if (c < 58) {
    					mypcpe = mypcpe + "3";
    				} else {
    					mypcpe = mypcpe + "4";
    				}
    				Db.runsql("update powertable set pce_ref='" + mypcpe + "' where sessionid='"+sessionid+"' and NRS=" + SYM_nr + " and nrz=" + DIAG_nr);
    			} 
    			while (rs.next() && (diagCount <= MAXDIAGS));
    		}
    		rs.close();
    	} catch (SQLException ex) {
    		ex.printStackTrace();
    	}

    	cnt = Db.get_integer("select count( * ) from powertable where sessionid='"+sessionid+"'");
    	mysql = "DELETE FROM POWERTABLE WHERE sessionid='"+sessionid+"' and (POWERTABLE.PC < "+MedwanQuery.getInstance().getConfigInt("ikireziMinimumPower",5)+" and POWERTABLE.PE< "+MedwanQuery.getInstance().getConfigInt("ikireziMinimumPower",5)+")";
    	Db.runsql(mysql);
    	cnt = Db.get_integer("select count( * ) from powertable where sessionid='"+sessionid+"'");
    	mysql = "DELETE FROM POWERTABLE WHERE sessionid='"+sessionid+"' and (POWERTABLE.PC=0 and POWERTABLE.PE=0)";
    	Db.runsql(mysql);
    	cnt = Db.get_integer("select count( * ) from powertable where sessionid='"+sessionid+"'");
    	mysql = "UPDATE POWERTABLE SET POWERTABLE.maxpcpe = POWERTABLE.pe WHERE sessionid='"+sessionid+"' and POWERTABLE.pc-POWERTABLE.pe<0;";
    	Db.runsql(mysql);
    	mysql = "UPDATE POWERTABLE SET POWERTABLE.maxpcpe = POWERTABLE.pc WHERE sessionid='"+sessionid+"' and POWERTABLE.pc-POWERTABLE.pe>0;";
    	Db.runsql(mysql);
    	cnt = Db.get_integer("select count( * ) from powertable where sessionid='"+sessionid+"'");
    }

    public void Prepare_Work_Tables() {
    	mysql = "CREATE TABLE  IF NOT EXISTS sintomis(  sessionid varchar(50), id int(11) NOT NULL AUTO_INCREMENT,  numero int(11) DEFAULT NULL,"
    			+ " NRS int(11) DEFAULT NULL,  PRESENTE smallint(6) DEFAULT NULL,  MAYUNI smallint(6) DEFAULT NULL,  NRS_NM varchar(200) DEFAULT NULL,  PRIMARY KEY (id))";
    	Db.runsql(mysql);
    	mysql = "CREATE TABLE IF NOT EXISTS  poterireplex(sessionid varchar(50), NRS INTEGER,symPE VARCHAR(50) CHARACTER SET UTF8,"
    			+ " TTYPE DOUBLE PRECISION,NRZ INTEGER,PC INTEGER,PE INTEGER,PWTEXT VARCHAR(50) CHARACTER SET UTF8,PREV FLOAT)";
    	Db.runsql(mysql);
    	mysql = "CREATE TABLE IF NOT EXISTS myselected2(sessionid varchar(50), "
    			+ " NRS  INTEGER, NRZ INTEGER, ZIEK"+language+" VARCHAR(50) CHARACTER SET UTF8, cont_sens  FLOAT, PREV DOUBLE PRECISION,  PREV_sens DOUBLE PRECISION)";
    	Db.runsql(mysql);
		mysql = "CREATE TABLE  IF NOT EXISTS  expimage(sessionid varchar(50), id int(11) NOT NULL AUTO_INCREMENT,"
				+ " NRS int(11) DEFAULT NULL,  symPE varchar(200) DEFAULT NULL,  IMAGE smallint(6) DEFAULT NULL,"
				+ "CONT_SENS double DEFAULT NULL,  FATTO smallint(6) DEFAULT NULL,  PRIMARY KEY (id))";
		Db.runsql(mysql);
		mysql = "CREATE TABLE  IF NOT EXISTS  diagnosid( sessionid varchar(50),  id int(11) NOT NULL AUTO_INCREMENT,  NRZ int(11) DEFAULT NULL,  PRIMARY KEY (id))";
		Db.runsql(mysql);
		mysql = "CREATE TABLE  IF NOT EXISTS  probabilita( sessionid varchar(50),  id int(11) NOT NULL AUTO_INCREMENT,  NRZ int(11) DEFAULT NULL,"
				+ " PRO1 double DEFAULT NULL, PRIMARY KEY (id)";
		for(int n=2;n<MAXSYMPTOMS+2;n++){
			mysql+=",LP"+n+" double DEFAULT 0.0,PRO"+n+" double DEFAULT 0.0";
		}
		mysql+=")";
		Db.runsql(mysql);
	    mysql = "CREATE TABLE IF NOT EXISTS myrelated(sessionid varchar(50), NRZ Integer,  NRZNOT Integer, PROB_OLD Double precision ,PROB_LP Double precision,"
	            +"PROB_NEW Double precision,  cont_sens Float,  PREV_OLD Double precision, PREV_NEW Double precision,  FALSI Double precision,  CONDDAO Double precision )";
	    Db.runsql(mysql);
		mysql = "CREATE TABLE IF NOT EXISTS myselected2("
		              + "sessionid varchar(50), NRS  INTEGER, NRZ INTEGER, ZIEK"+language+" VARCHAR(50) CHARACTER SET UTF8, cont_sens  FLOAT, PREV DOUBLE PRECISION,  PREV_sens DOUBLE PRECISION)";
		Db.runsql(mysql);
		
		Db.runsql("delete from sintomis where sessionid='"+sessionid+"'");
		Db.runsql("delete from poterireplex where sessionid='"+sessionid+"'");
		Db.runsql("delete from myselected2 where sessionid='"+sessionid+"'");
		Db.runsql("delete from expimage where sessionid='"+sessionid+"'");
		Db.runsql("delete from diagnosid where sessionid='"+sessionid+"'");
		Db.runsql("delete from probabilita where sessionid='"+sessionid+"'");
		Db.runsql("delete from myrelated where sessionid='"+sessionid+"'");
    }
      
    public void setupProb() throws SQLException {
    	double p2 = Db.get_float("select sum(P_AMERICA) from diag where P_AMERICA<>0");
    	String s2 = String.valueOf(p2);
    	mysql = "insert into probabilita(sessionid,NRZ,PRO1) SELECT  '"+sessionid+"',NRZ,log10((P_AMERICA / " + s2 + ") / (1 - (P_AMERICA / " + s2 + "))) FROM diag d WHERE P_AMERICA  <> 0 ";
    	Db.runsql(mysql);
    }   
   
    public boolean add_argument_in_sintomis_and_prob(int nrs, boolean present) {
    	String sym = "";
    	int presente_i = (present ? -1 : 0);
    	int cnt;
    	cnt = 1 + Db.get_integer("select count(*) from sintomis where sessionid='"+sessionid+"'");
    	sym = Db.get_string("select symp"+language+" from sym inner join sym_lang on sym.nrs=sym_lang.nrs where sym.nrs=" + nrs);
    	mysql = "insert into sintomis(sessionid,numero,nrs,presente,nrs_nm) values ('"+sessionid+"'," + cnt + "," + nrs + "," + presente_i + ",'" + sym + "')";
    	Db.runsql(mysql);
    	int aantsym = Db.get_integer("select count(*) from sintomis where sessionid='"+sessionid+"'");
    	newPCPE(nrs, aantsym, present, false);
    	return true;
    }

    public void newPCPE(int nrs, int aantsym, boolean plus, boolean message) {
		Db.runsql("delete from myrelated where sessionid='"+sessionid+"'");
    	int alarm = Db.get_integer("select ALARM from sym where nrs=" + nrs);
    	double fatcom = Db.get_float("select comune from sym where nrs=" + nrs);
    	Integer lastPro = aantsym;
    	String prob_old = "PRO" + lastPro;
    	String prob_lp = "LP" + (lastPro + 1);
    	String prob_new = "PRO" + (lastPro + 1);
    	String myView2SQL= "SELECT distinct '"+sessionid+"' sessionid,P.NRZ, MYVIEW1.NRZ AS NRZNOT, " + prob_old + "," + prob_lp + "," + prob_new
              + " , MYVIEW1.cont_sens, (POW(10, " + prob_old + ") / (1 + POW(10, " + prob_old + "))) AS `PREV_OLD`, " + prob_lp + " as Prev_new," + prob_lp + " as falsi," + prob_lp + " as CONDDAO"
              + " FROM probabilita P LEFT JOIN  (SELECT NRZ, cont_sens FROM assocdata WHERE NRS=" + nrs+") MYVIEW1 ON P.NRZ=MYVIEW1.NRZ where P.sessionid='"+sessionid+"'";
    	mysql = "INSERT INTO myrelated (sessionid,NRZ, NRZNOT,PROB_OLD,PROB_LP,PROB_NEW, cont_sens, PREV_OLD, PREV_NEW, FALSI, CONDDAO) "+myView2SQL;
    	Db.runsql(mysql);
    	double p1 = Db.get_float("SELECT sum(prev_old) AS p1 FROM myrelated where sessionid='"+sessionid+"' and (not cont_sens is null)");
    	double sompr = Db.get_float("SELECT sum(prev_old*cont_sens) AS sompr FROM myrelated where sessionid='"+sessionid+"' and (not cont_sens is null)");
    	mysql = "UPDATE myrelated SET PROB_NEW=PROB_OLD where sessionid='"+sessionid+"'"; //allemaal initialiseren
    	Db.runsql(mysql);
    	if (plus && (alarm > 0)) {
    		mysql = "UPDATE myrelated SET PROB_NEW = -13 WHERE sessionid='"+sessionid+"' and (cont_sens Is Null)";
    		Db.runsql(mysql);
    	}
    	mysql = "update myrelated"
              + " SET FALSI=if (((" + sompr + "- cont_sens*prev_old+(1-" + p1 + ")*" + fatcom + ")/(1-prev_old) >0), (" + sompr + "- cont_sens*prev_old+(1-" + p1 + ")*" + fatcom + ")/(1-prev_old),0.00001)"
              + " where sessionid='"+sessionid+"' and (not cont_sens is null) ";
    	Db.runsql(mysql);
    	if (plus) {
    		mysql = "update myrelated SET PROB_LP= LOG10(cont_sens/falsi),PROB_NEW=PROB_OLD+LOG10(cont_sens/falsi) where sessionid='"+sessionid+"' and (not cont_sens is null)";
    		Db.runsql(mysql);
    		if (Db.get_integer("select count(*) from sintomis where sessionid='"+sessionid+"'") > 4) {    
    			String nrs_nm = Db.get_string("select nrs_nm from sintomis where sessionid='"+sessionid+"' and nrs=" + nrs);
    			maycause(nrs, nrs_nm, false);
    		}
    	} else {
    		mysql = "update myrelated SET PROB_LP= LOG10((1-falsi)/(1-cont_sens)),PROB_NEW=PROB_OLD-LOG10((1-falsi)/(1-cont_sens)) where sessionid='"+sessionid+"' and (not cont_sens is null)";
    		Db.runsql(mysql);
    	}
    	mysql = "update myrelated SET PREV_NEW= ( pow(10,PROB_NEW)/(1+pow(10,PROB_NEW))) where sessionid='"+sessionid+"'";
    	Db.runsql(mysql);
    	mysql = "SELECT Sum(PREV_NEW) AS P2 FROM myrelated where sessionid='"+sessionid+"' and (not cont_sens is null)";
    	double p2 = Db.get_float(mysql);
    	double faktor = (1 - p2) / (1 - p1);
    	mysql = "update myrelated SET conddao=((prev_NEW*" + faktor + ")/(1-prev_NEW*" + faktor + ")) WHERE sessionid='"+sessionid+"'";  //info
    	Db.runsql(mysql);
    	mysql = "update myrelated SET PROB_NEW =if((CONDDAO>0),log10(CONDDAO),0.0000000000001) where sessionid='"+sessionid+"' and (cont_sens is null)";
    	Db.runsql(mysql);
    	mysql = "update probabilita P SET P." + prob_new + "=(select M.PROB_NEW from myrelated M WHERE M.sessionid=P.sessionid and M.NRZ=P.NRZ), P." + prob_lp + "=(select M.PROB_LP from myrelated M WHERE M.sessionid=P.sessionid and M.NRZ=P.NRZ) where p.sessionid='"+sessionid+"'";
    	Db.runsql(mysql);
      	if ("PRO1".equals(prob_old)) {
      		mysql = "delete from diagnosid where sessionid='"+sessionid+"'";
      		Db.runsql(mysql);
      		mysql = "insert into diagnosid(sessionid,nrz) select '"+sessionid+"',assocdata.nrz from assocdata inner join diag on assocdata.nrz=diag.nrz where assocdata.nrs=" + nrs;
      		Db.runsql(mysql);
      	} else {
      		mysql = "Delete FROM diagnosid WHERE sessionid='"+sessionid+"' and diagnosid.NRZ NOT IN (SELECT assocdata.nrz from assocdata where assocdata.nrs=" + nrs + ")";
      		Db.runsql(mysql);
      	}
    }
   
   
    public boolean implies(int sym_nr, String sym_nm, boolean mess) { //mess=false -> silent
    	mysql = "select s.nrs_nm ,s.nrs,s.numero from sintomis s inner join implies i on S.nrs=i.nrs where ((i.nrsimplies=" + sym_nr + ")"
              + " AND ((S.Presente)=-1)) and s.sessionid='"+sessionid+"'";
    	try {
    		ResultSet rs = Db.conn.createStatement().executeQuery((mysql));
    		while (rs.next()) {
    			if (mess) {
    				rs.close();
    				return true;
    			}
    		}
    		rs.close();
    	} catch (SQLException ex) {
    		ex.printStackTrace();
    	}
    	return false;
    }

    public boolean exclude(int sym_nr, String sym_nm, boolean mess) {  //mess=false -> silent
    	mysql = "select s1.nrs_nm ,s1.nrs,s1.numero from sintomis s1 inner join excludes e1 on s1.nrs=e1.nrs where ((e1.nrsexclude=" + sym_nr + ")"
              + " AND ((s1.Presente)=-1)) and s1.sessionid='"+sessionid+"'"
              + " union "
              + " select s2.nrs_nm ,s2.nrs,s2.numero from sintomis s2 inner join excludes e2 on s2.nrs=e2.nrsexclude where ((e2.nrs=" + sym_nr + ")"
              + " AND ((s2.Presente)=-1)) and sessionid='"+sessionid+"'";
    	try {
    		ResultSet rs = Db.conn.createStatement().executeQuery((mysql));
    		while (rs.next()) {
    			if (mess) {
    				rs.close();
    				return true;
    			}
    		}
    		rs.close();
    	} catch (SQLException ex) {
    		ex.printStackTrace();
    	}
    	return false;
    }


   	public void maycause(int sym_nr, String sym_nm, boolean mess) {
   		mysql = "select nrs,nrsmaycause from maycause";
   		try {
   			ResultSet rs = Db.conn.createStatement().executeQuery((mysql));
   			while (rs.next()) {
   				int mc_nrs = rs.getInt(1);
   				int mc_nrsmaycause = rs.getInt(2);
   				if (sym_nr == mc_nrs) {
   					mysql = "select count(*) from sintomis where sessionid='"+sessionid+"' and nrs=" + mc_nrsmaycause;
   					if (Db.get_integer(mysql) > 0) {
   						String nrs_nm = Db.get_string("select nrs_nm from sintomis where sessionid='"+sessionid+"' and nrs=" + mc_nrsmaycause);
   						int numero = Db.get_integer("select numero from sintomis where sessionid='"+sessionid+"' and nrs=" + mc_nrsmaycause);
   						drop_light(nrs_nm, numero, sym_nm, mess);
   					}
   				}
   				if (sym_nr == mc_nrsmaycause) {
   					mysql = "select count(*) from sintomis where sessionid='"+sessionid+"' and nrs=" + mc_nrs;
   					if (Db.get_integer(mysql) > 0) {
   						String nrs_nm = Db.get_string("select nrs_nm from sintomis where sessionid='"+sessionid+"' and nrs=" + mc_nrs);
   						int numero = Db.get_integer("select numero from sintomis where sessionid='"+sessionid+"' and nrs=" + mc_nrs);
   						drop_light(nrs_nm, numero, sym_nm, mess);
   					}
   				}
   			}
   			rs.close();
   		} catch (SQLException ex) {
   			ex.printStackTrace();
   		}
   	}

   	public void drop_light(String nrs_nm, int nr, String s_nm, boolean mess) {
   		int oude_pro = 1 + Db.get_integer("select count( * ) from sintomis where sessionid='"+sessionid+"'"); //laatst ingevulde pro
   		String prob_new = "PRO" + String.valueOf(oude_pro);
   		String prob_vorig = "PRO" + String.valueOf(oude_pro - 1);
   		String lp_last = "LP" + String.valueOf(oude_pro);
   		String lp_may = "LP" + String.valueOf(nr);     //nr is recordnummer van sintomis"+"
   		mysql = "update probabilita AS p INNER JOIN myrelated AS r ON p.NRZ=r.NRZ "
              + " SET p." + prob_new + "="
              + " if(p." + lp_last + ">p." + lp_may + ",p." + prob_vorig + "+p." + lp_last + "-p." + lp_may + ",p." + prob_vorig + ")"
              + " WHERE p.sessionid=r.sessionid and (p." + lp_last + ">0) and (p." + lp_may + ">0) and (p.sessionid='"+sessionid+"' and p.NRZ=r.NRZ);";
   		Db.runsql(mysql);
   	}
   
   
   	public void fppcpe(int diag_nr, int sym_nr) {
   		double fatcom = Db.get_float("select comune from sym where nrs=" + sym_nr);
   		Db.runsql("delete from myselected2 where sessionid='"+sessionid+"'");
   		String prob_last = getProLast();
   		mysql = "INSERT INTO myselected2"
              + " SELECT '"+sessionid+"',a.nrs,a.NRZ, DIAG_LANG.ZIEK"+language+", a.cont_sens, "
              + "POW(10," + prob_last + ")/(1+POW(10," + prob_last + ")) as PREV"
              + ",  (POW(10," + prob_last + ")/(1+POW(10," + prob_last + "))) * cont_sens as prev_sens"
              + " FROM (assocdata a INNER JOIN diag d ON a.NRZ = d.nrz) INNER JOIN probabilita p ON d.nrz = P.NRZ INNER JOIN DIAG_LANG on D.NRZ=DIAG_LANG.NRZ"
              + " join sym s on a.nrs=s.nrs  WHERE p.sessionid='"+sessionid+"' and not(s.TTYPE=4  and s.TYPENURSE=0)"
              + " and (a.NRS=" + sym_nr + ")";
   		Db.runsql(mysql);
   		mysql = "SELECT sum(prev) AS p1 FROM myselected2 where sessionid='"+sessionid+"'";
   		double p1 = Db.get_float(mysql);
   		mysql = "SELECT sum(prev_sens) AS sompr FROM myselected2 where sessionid='"+sessionid+"'";
   		double sommeprod = Db.get_float(mysql);
   		mysql = "SELECT prev as p FROM myselected2 where sessionid='"+sessionid+"' and nrz=" + diag_nr;
   		myprev = Db.get_float(mysql);
   		mysql = "SELECT cont_sens as s FROM myselected2 where sessionid='"+sessionid+"' and nrz=" + diag_nr;
   		double bili = Db.get_float(mysql);
   		double falsipositivi = (sommeprod - myprev * bili + (1 - p1) * fatcom) / (1 - myprev);
   		if (falsipositivi == 0) {
   			falsipositivi = 0.000000001;
   		}
   		mypc = bili / falsipositivi;
   		mype = (1 - falsipositivi) / (1 - bili);
   	}

   	public String getProLast() {
   		int last_cols_nr = Db.get_integer("select count(*) from sintomis where sessionid='"+sessionid+"'") + 1;
   		return "Pro" + String.valueOf(last_cols_nr);
   	}   
      
   	public Vector<String> getListHeader() {
   		String vectorSQL = "SELECT  id,  ZIEK"+language+",  Espr1,  cutoff,  NRS,  SYMP"+language+",  NRZ,  PC,  PE,  Prev,  PCE_REF,  Maxpcpe FROM powertable where sessionid='"+sessionid+"'";
   		Vector<String> cNames = new Vector<String>();
   		try {
   			Statement statement = Db.conn.createStatement();
   			ResultSet rs = statement.executeQuery(vectorSQL);
   			ResultSetMetaData meta = rs.getMetaData();
   			int colCount = meta.getColumnCount();
   			cNames = new Vector<String>();
   			for (int h = 1; h <= colCount; h++) {
   				cNames.addElement(meta.getColumnName(h));
   			}
   		} catch (Exception e) {
   			e.printStackTrace();
   		}
   		return cNames;
   	}
   	
   	public static void registerSessionActivity(String sessionid){
   		try{
   			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
   			PreparedStatement ps = conn.prepareStatement("update oc_ikirezisessions set oc_session_updatetime=? where oc_session_id=?");
   			ps.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()));
   			ps.setString(2, sessionid);
   			if(ps.executeUpdate()==0){
   				ps.close();
   	   			ps = conn.prepareStatement("insert into oc_ikirezisessions(oc_session_updatetime,oc_session_id) values(?,?)");
   	   			ps.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()));
   	   			ps.setString(2, sessionid);
   	   			ps.execute();
   			}
	   		ps.close();
	   		conn.close();
   		}
   		catch(Exception e){
   			e.printStackTrace();
   		}
   	}
   	
   	public static Vector<Vector> getListData(String sessionid, String language){
   		if(ScreenHelper.checkString(language).toLowerCase().startsWith("f")){
   			language="f";
   		}
   		else if(ScreenHelper.checkString(language).toLowerCase().startsWith("n")){
   			language="n";
   		}
   		else if(ScreenHelper.checkString(language).toLowerCase().startsWith("p")){
   			language="p";
   		}
   		else if(ScreenHelper.checkString(language).toLowerCase().startsWith("i")){
   			language="i";
   		}
   		else if(ScreenHelper.checkString(language).toLowerCase().startsWith("es")){
   			language="s";
   		}
   		else {
   			language="e";
   		}
   		String vectorSQL = "SELECT  id,  ZIEK"+language+",  Espr1,  cutoff,  NRS,  SYMP"+language+",  NRZ,  PC,  PE,  Prev,  PCE_REF,  Maxpcpe FROM powertable where sessionid='"+sessionid+"' order by PC+PE DESC"; 
   		Vector<Vector> tVector = new Vector<Vector>();
   		Vector<String> rVector;
   		try {
   			Db.Connect();
   	   		registerSessionActivity(sessionid);
   			Statement statement = Db.conn.createStatement();
   			ResultSet rs = statement.executeQuery(vectorSQL);
   			ResultSetMetaData meta = rs.getMetaData();
   			int colCount = meta.getColumnCount();
   			while (rs.next()) {
   				rVector = new Vector<String>();
   				for (int i = 0; i < colCount; i++) {
   					rVector.addElement(rs.getString(i + 1));
   				}
   				tVector.addElement(rVector);
   			}
   	   		rs.close();
   	   		statement.close();
   	   		Db.conn.close();
   		} catch (Exception e) {
   			e.printStackTrace();
   		}
   		return tVector;
   	}

   	public static Vector<Vector> getListData(String sessionid, String language, String nrz){
   		if(ScreenHelper.checkString(language).toLowerCase().startsWith("f")){
   			language="f";
   		}
   		else if(ScreenHelper.checkString(language).toLowerCase().startsWith("n")){
   			language="n";
   		}
   		else if(ScreenHelper.checkString(language).toLowerCase().startsWith("p")){
   			language="p";
   		}
   		else if(ScreenHelper.checkString(language).toLowerCase().startsWith("i")){
   			language="i";
   		}
   		else if(ScreenHelper.checkString(language).toLowerCase().startsWith("es")){
   			language="s";
   		}
   		else {
   			language="e";
   		}
   		String vectorSQL = "SELECT  id,  ZIEK"+language+",  Espr1,  cutoff,  NRS,  SYMP"+language+",  NRZ,  PC,  PE,  Prev,  PCE_REF,  Maxpcpe FROM powertable where sessionid='"+sessionid+"' and NRZ="+nrz+" order by PC+PE DESC"; 
   		Vector<Vector> tVector = new Vector<Vector>();
   		Vector<String> rVector;
   		try {
   			Db.Connect();
   	   		registerSessionActivity(sessionid);
   			Statement statement = Db.conn.createStatement();
   			ResultSet rs = statement.executeQuery(vectorSQL);
   			ResultSetMetaData meta = rs.getMetaData();
   			int colCount = meta.getColumnCount();
   			while (rs.next()) {
   				rVector = new Vector<String>();
   				for (int i = 0; i < colCount; i++) {
   					rVector.addElement(rs.getString(i + 1));
   				}
   				tVector.addElement(rVector);
   			}
   	   		rs.close();
   	   		statement.close();
   	   		Db.conn.close();
   		} catch (Exception e) {
   			e.printStackTrace();
   		}
   		
   		return tVector;
   	}

   	public Vector<Vector> getListData() {
   		String vectorSQL = "SELECT  id,  ZIEK"+language+",  Espr1,  cutoff,  NRS,  SYMP"+language+",  NRZ,  PC,  PE,  Prev,  PCE_REF,  Maxpcpe FROM powertable where sessionid='"+sessionid+"'"; 
   		Vector<Vector> tVector = new Vector<Vector>();
   		Vector<String> rVector;
   		try {
   			Statement statement = Db.conn.createStatement();
   			ResultSet rs = statement.executeQuery(vectorSQL);
   			ResultSetMetaData meta = rs.getMetaData();
   			int colCount = meta.getColumnCount();
   			while (rs.next()) {
   				rVector = new Vector<String>();
   				for (int i = 0; i < colCount; i++) {
   					rVector.addElement(rs.getString(i + 1));
   				}
   				tVector.addElement(rVector);
   			}
   	   		rs.close();
   	   		statement.close();
   		} catch (Exception e) {
   			e.printStackTrace();
   		}
   		return tVector;
   	}
    
   	public OCProb(String sessionid,Hashtable symptoms,String language) {
   		this.sessionid=sessionid;
   		try {
   	   		Db.Connect();
   	   		registerSessionActivity(sessionid);
			Db.conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
   		if(ScreenHelper.checkString(language).toLowerCase().startsWith("f")){
   			this.language="f";
   		}
   		else if(ScreenHelper.checkString(language).toLowerCase().startsWith("n")){
   			this.language="n";
   		}
   		else if(ScreenHelper.checkString(language).toLowerCase().startsWith("p")){
   			this.language="p";
   		}
   		else if(ScreenHelper.checkString(language).toLowerCase().startsWith("i")){
   			this.language="i";
   		}
   		else if(ScreenHelper.checkString(language).toLowerCase().startsWith("es")){
   			this.language="s";
   		}
   		else {
   			this.language="e";
   		}
   		setup(symptoms);
   	} 
}
