package ocspring2;

import java.awt.BorderLayout;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Vector;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JScrollPane;
import javax.swing.JTable;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;

/**
 *
 * @author riknew
 */
public class OC {

   final Double PCPEMIN = 3.0;
   final Double CUTOFF = Double.parseDouble(MedwanQuery.getInstance().getConfigString("ikirezicutoff","0.3"));

   //static int selNrs1 = 136;
   //static int selNrs2 = 542;
   //static int selNrs3 = 134;
   //static int selNrs4 = 0;
   private int selNrs1;
   private int selNrs2;
   private int selNrs3;
   private int selNrs4;
   private String language;

   Statement statement;
   String mysql, vectorSQL;
   private int testi;

   public Vector<String> getListHeader() {
      Vector<String> cNames = new Vector<String>();
      try {
    	  
         statement = Db.conn.createStatement();
         ResultSet rs = statement.executeQuery(vectorSQL);
         ResultSetMetaData meta = rs.getMetaData();
         int colCount = meta.getColumnCount();
         cNames = new Vector<String>();
         for (int h = 1; h <= colCount; h++) {
            cNames.addElement(meta.getColumnName(h));
         }
         rs.close();
         statement.close();
      } catch (Exception e) {
         e.printStackTrace();
      }
      return cNames;
   }

   public Vector<Vector> getListData() {
		Debug.println(new SimpleDateFormat("HH:mm:ss:SSS").format(new java.util.Date())+"C.1");
      Vector<Vector> tVector = new Vector<Vector>();
      Vector<String> rVector;
      try {
         statement = Db.conn.createStatement();
         ResultSet rs = statement.executeQuery(vectorSQL);
  		Debug.println(new SimpleDateFormat("HH:mm:ss:SSS").format(new java.util.Date())+"C.2");
 		Debug.println(vectorSQL);
         ResultSetMetaData meta = rs.getMetaData();
         int colCount = meta.getColumnCount();
         while (rs.next()) {
     		Debug.println(new SimpleDateFormat("HH:mm:ss:SSS").format(new java.util.Date())+"C.3");
            rVector = new Vector<String>();
            for (int i = 0; i < colCount; i++) {
               rVector.addElement(rs.getString(i + 1));
            }
            tVector.addElement(rVector);
         }
 		Debug.println(new SimpleDateFormat("HH:mm:ss:SSS").format(new java.util.Date())+"C.4");
         rs.close();
         statement.close();
      } catch (Exception e) {
         e.printStackTrace();
      }
      return tVector;
   }

   public void setup() {
      Db.Connect();
      
      String sIkireziDb=MedwanQuery.getInstance().getConfigString("ikireziDbType","mysql");
      if(sIkireziDb.equalsIgnoreCase("mysql")){
	      //************
	      //* Modified *
	      //************
	      	Db.runsql("drop temporary table if exists tmp_sel");
	      //************
	      	
	      Db.runsql("create temporary table tmp_sel as select id,nrz,nrs, 0 as selection from assocdata");
	      Db.runsql("create index temporary1 on tmp_sel(nrs)");
	      Db.runsql("create index temporary2 on tmp_sel(nrz)");
	      
	      //************
	      //* Modified *
	      //************
	      	Db.runsql("drop temporary table if exists tmp_did");
	      //************
	      	
	      Db.runsql("create temporary table tmp_did (id int(11) NOT NULL AUTO_INCREMENT,NRZ int(11) DEFAULT NULL, PRIMARY KEY (id))");
	
	      //************
	      //* Modified *
	      //************
	      	Db.runsql("drop temporary table if exists tmp_sin");
	      //************
	      	
	      Db.runsql("create temporary table tmp_sin (id int(11) NOT NULL AUTO_INCREMENT, NRS int(11) DEFAULT NULL, PRIMARY KEY (id))");
	
	      //************
	      //* Modified *
	      //************
	      	Db.runsql("drop temporary table if exists tmp_nrs");
	      //************
	      	
	      Db.runsql("create temporary table tmp_nrs (id int(11) NOT NULL AUTO_INCREMENT, NRS int(11) DEFAULT NULL, PRIMARY KEY (id))");
	      testi = Db.get_integer("select count(*) from sym where (SYM.TTYPE=0) and nrs=" + selNrs1);
	      
	      if (testi == 0) {
	         //JOptionPane.showMessageDialog(null, "argument 1  error");
	         //System.exit(0);
	      } else {
	         mysql = "insert into tmp_sin (nrs) values (" + selNrs1 + ")";
	         Db.runsql(mysql);
	      }

	      testi = Db.get_integer("select count(*) from sym where  ((SYM.TTYPE=1) or (SYM.TTYPE=8)) and nrs=" + selNrs2);
	      if (testi == 0) {
	         //JOptionPane.showMessageDialog(null, "argument 2  error");
	         //System.exit(0);
	      } else {
	         mysql = "insert into tmp_sin (nrs) values (" + selNrs2 + ")";
	         Db.runsql(mysql);
	      }

	      testi = Db.get_integer("select count(*) from sym where  (SYM.TTYPE<>1 And SYM.TTYPE<>0 AND SYM.STARTUP=-1" + " AND sym.nrs not in (select nrsexclude from excludes where nrs in (" + selNrs1 + "," + selNrs2 + "))"
	              + " AND sym.nrs not in (select nrs from excludes where nrsexclude in (" + selNrs1 + "," + selNrs2 + "))) and nrs=" + selNrs3);
	      if (testi == 0) {
	         //JOptionPane.showMessageDialog(null, "argument 3  error");
	         //System.exit(0);
	      } else {
	         mysql = "insert into tmp_sin (nrs) values (" + selNrs3 + ")";
	         Db.runsql(mysql);
	      }

	      if (selNrs4 != 0) {
	         testi = Db.get_integer("select count(*) from sym where  (SYM.TTYPE<>1 And SYM.TTYPE<>0 AND SYM.STARTUP=-1"
	                 + " AND sym.nrs not in (select nrsexclude from excludes where nrs in (" + selNrs1 + "," + selNrs2 + "," + selNrs3 + "))"
	                 + " AND sym.nrs not in (select nrs from excludes where nrsexclude in (" + selNrs1 + "," + selNrs2 + "," + selNrs3 + ")))"
	                 + " AND sym.nrs =" + selNrs4);
	         if (testi == 0) {
	            //JOptionPane.showMessageDialog(null, "argument 4 error");
	            //System.exit(0);
	         } else {
	            mysql = "insert into tmp_sin (nrs) values (" + selNrs4 + ")";
	            Db.runsql(mysql);
	         }
	      }

	      if (selNrs4 == 0) {
	         mysql = "update tmp_sel set selection=1 where (nrz in (select nrz from diag)) and ((tmp_sel.nrs=" + selNrs1 + ") OR (tmp_sel.nrs=" + selNrs2 + ") OR (tmp_sel.nrs=" + selNrs3 + "))";
	         Db.runsql(mysql);
	      } else {
	         mysql = "update tmp_sel set selection=1 where (nrz in (select nrz from diag)) and ((tmp_sel.nrs=" + selNrs1 + ") OR (tmp_sel.nrs=" + selNrs2 + ") OR (tmp_sel.nrs=" + selNrs3 + ") OR (tmp_sel.nrs=" + selNrs4 + "))";
	         Db.runsql(mysql);
	      }

	      int cntSelected = Db.get_integer("select count(*) from tmp_sin");

	      Db.runsql("insert into tmp_did (nrz) SELECT tmp_sel.nrz FROM tmp_sel "
	              + " WHERE selection=1 GROUP BY NRZ HAVING count(nrz)=" + cntSelected);  //wordt nu 3 of 4 

	      String symptomlabel="sl.sympe";
	      String diseaselabel="e.zieke";
	      if(language.equalsIgnoreCase("fr")){
	    	  symptomlabel="sl.sympf";
	    	  diseaselabel="e.ziekf";
	      }
	      else if(language.equalsIgnoreCase("nl")){
	    	  symptomlabel="sl.sympn";
	    	  diseaselabel="e.ziekn";
	      }
	      else if(language.equalsIgnoreCase("es")){
	    	  symptomlabel="sl.symps";
	    	  diseaselabel="e.zieks";
	      }
	      else if(language.equalsIgnoreCase("pt")){
	    	  symptomlabel="sl.sympp";
	    	  diseaselabel="e.ziekp";
	      }
	      
	      vectorSQL = "SELECT 200 as RESULTCODE,a.nrz,a.nrs,"+diseaselabel+","+symptomlabel+",AFRICA_PC, AFRICA_PE ,d.cutoff,m.icd10 from "
	      		+ "assocdata a "
	              + "join diag d on a.nrz=d.NRZ "
	              + "join diag_lang e on a.nrz=e.NRZ "
	              + "join sym s on a.nrs=s.nrs "
	              + "join sym_lang sl on s.nrs=sl.nrs "
	              + "join diseasemappings m on a.nrz=m.nrz "
	              + "join tmp_sel on a.id=tmp_sel.id "
	              + "where a.nrz in (select nrz from tmp_did) and "
	              + "tmp_sel.selection=0 and "
	              + "d.cutoff<" + CUTOFF + " and "
	              + "AFRICA_PC>" + PCPEMIN + " and AFRICA_PE>" + PCPEMIN 
	              + "order by d.zieke,greatest(AFRICA_PC,AFRICA_PE) desc;";
      }
      else if(sIkireziDb.equalsIgnoreCase("sqlserver")){
	      //************
	      //* Modified *
	      //************
	      	Db.runsql("if OBJECT_ID('tempdb..tmp_sel') IS NOT NULL drop table tempdb..tmp_sel");
	      //************
	      	
	      Db.runsql("select id,nrz,nrs, 0 as selection into tempdb..tmp_sel from assocdata");
	      Db.runsql("create index temporary1 on tempdb..tmp_sel(nrs)");
	      Db.runsql("create index temporary2 on tempdb..tmp_sel(nrz)");
	      
	      //************
	      //* Modified *
	      //************
	      	Db.runsql("if OBJECT_ID('tempdb..tmp_did') IS NOT NULL drop table tempdb..tmp_did");
	      //************
	      	
	      Db.runsql("create table tempdb..tmp_did (id int identity(1,1) primary key ,NRZ int DEFAULT NULL)");
	
	      //************
	      //* Modified *
	      //************
	      	Db.runsql("if OBJECT_ID('tempdb..tmp_sin') IS NOT NULL drop table tempdb..tmp_sin");
	      //************
	      	
	      Db.runsql("create table tempdb..tmp_sin (id int identity(1,1) primary key, NRS int DEFAULT NULL)");
	
	      //************
	      //* Modified *
	      //************
	      	Db.runsql("if OBJECT_ID('tempdb..tmp_nrs') IS NOT NULL drop table tempdb..tmp_nrs");
	      //************
	      	
	      Db.runsql("create table tempdb..tmp_nrs (id int identity(1,1) primary key, NRS int DEFAULT NULL)");
	      
	      testi = Db.get_integer("select count(*) from sym where (SYM.TTYPE=0) and nrs=" + selNrs1);
	      if (testi == 0) {
	         //JOptionPane.showMessageDialog(null, "argument 1  error");
	         //System.exit(0);
	      } else {
	         mysql = "insert into tempdb..tmp_sin (nrs) values (" + selNrs1 + ")";
	         Db.runsql(mysql);
	      }

	      testi = Db.get_integer("select count(*) from sym where  ((SYM.TTYPE=1) or (SYM.TTYPE=8)) and nrs=" + selNrs2);
	      if (testi == 0) {
	         //JOptionPane.showMessageDialog(null, "argument 2  error");
	         //System.exit(0);
	      } else {
	         mysql = "insert into tempdb..tmp_sin (nrs) values (" + selNrs2 + ")";
	         Db.runsql(mysql);
	      }

	      testi = Db.get_integer("select count(*) from sym where  (SYM.TTYPE<>1 And SYM.TTYPE<>0 AND SYM.STARTUP=-1" + " AND sym.nrs not in (select nrsexclude from excludes where nrs in (" + selNrs1 + "," + selNrs2 + "))"
	              + " AND sym.nrs not in (select nrs from excludes where nrsexclude in (" + selNrs1 + "," + selNrs2 + "))) and nrs=" + selNrs3);
	      if (testi == 0) {
	         //JOptionPane.showMessageDialog(null, "argument 3  error");
	         //System.exit(0);
	      } else {
	         mysql = "insert into tempdb..tmp_sin (nrs) values (" + selNrs3 + ")";
	         Db.runsql(mysql);
	      }

	      if (selNrs4 != 0) {
	         testi = Db.get_integer("select count(*) from sym where  (SYM.TTYPE<>1 And SYM.TTYPE<>0 AND SYM.STARTUP=-1"
	                 + " AND sym.nrs not in (select nrsexclude from excludes where nrs in (" + selNrs1 + "," + selNrs2 + "," + selNrs3 + "))"
	                 + " AND sym.nrs not in (select nrs from excludes where nrsexclude in (" + selNrs1 + "," + selNrs2 + "," + selNrs3 + ")))"
	                 + " AND sym.nrs =" + selNrs4);
	         if (testi == 0) {
	            //JOptionPane.showMessageDialog(null, "argument 4 error");
	            //System.exit(0);
	         } else {
	            mysql = "insert into tempdb..tmp_sin (nrs) values (" + selNrs4 + ")";
	            Db.runsql(mysql);
	         }
	      }

	      if (selNrs4 == 0) {
	         mysql = "update tempdb..tmp_sel set selection=1 where (nrz in (select nrz from diag)) and ((nrs=" + selNrs1 + ") OR (nrs=" + selNrs2 + ") OR (nrs=" + selNrs3 + "))";
	         Db.runsql(mysql);
	      } else {
	         mysql = "update tempdb..tmp_sel set selection=1 where (nrz in (select nrz from diag)) and ((nrs=" + selNrs1 + ") OR (nrs=" + selNrs2 + ") OR (nrs=" + selNrs3 + ") OR (nrs=" + selNrs4 + "))";
	         Db.runsql(mysql);
	      }

	      int cntSelected = Db.get_integer("select count(*) from tempdb..tmp_sin");

	      Db.runsql("insert into tempdb..tmp_did (nrz) SELECT tempdb..tmp_sel.nrz FROM tempdb..tmp_sel "
	              + " WHERE selection=1 GROUP BY NRZ HAVING count(nrz)=" + cntSelected);  //wordt nu 3 of 4 

	      String symptomlabel="s.sympe";
	      String diseaselabel="e.zieke";
	      if(language.equalsIgnoreCase("fr")){
	    	  symptomlabel="s.sympf";
	    	  diseaselabel="e.ziekf";
	      }
	      else if(language.equalsIgnoreCase("nl")){
	    	  symptomlabel="s.sympn";
	    	  diseaselabel="e.ziekn";
	      }
	      
	      vectorSQL = "SELECT 200 as RESULTCODE,a.nrz,a.nrs,"+diseaselabel+","+symptomlabel+",AFRICA_PC, AFRICA_PE ,d.cutoff,m.icd10 from assocdata a "
	              + "join diag d on a.nrz=d.NRZ "
	              + "join diag_lang e on a.nrz=e.NRZ "
	              + "join sym s on a.nrs=s.nrs "
	              + "join diseasemappings m on a.nrz=m.nrz "
	              + "join tempdb..tmp_sel on a.id=tempdb..tmp_sel.id "
	              + "where (a.nrz in (select nrz from tempdb..tmp_did) and "
	              + "tempdb..tmp_sel.selection=0 and "
	              + "d.cutoff<" + CUTOFF + " and "
	              + "AFRICA_PC>" + PCPEMIN + " and AFRICA_PE>" + PCPEMIN + " ) "
	              + "order by d.zieke,(SELECT MAX(c) FROM (VALUES(AFRICA_PC),(AFRICA_PE)) T (c)) desc;";
      }
   }
   
   public static Vector<Vector> getResponse(Vector<String> signs, String language){
		Debug.println(new SimpleDateFormat("HH:mm:ss:SSS").format(new java.util.Date())+"A");
		OC oc = new OC();
		try {
		    oc.language=language;
		    oc.selNrs1 = Integer.parseInt(signs.elementAt(0));
		    oc.selNrs2 = Integer.parseInt(signs.elementAt(1));
		    oc.selNrs3 = Integer.parseInt(signs.elementAt(2));
		    oc.selNrs4 = Integer.parseInt(signs.elementAt(3));
		} catch (ArrayIndexOutOfBoundsException e) {
		    Debug.println("ArrayIndexOutOfBoundsException caught");
		}
		Debug.println(new SimpleDateFormat("HH:mm:ss:SSS").format(new java.util.Date())+"B");
		oc.setup();
		Debug.println(new SimpleDateFormat("HH:mm:ss:SSS").format(new java.util.Date())+"C");
		Vector<Vector> result = oc.getListData();
		Debug.println(new SimpleDateFormat("HH:mm:ss:SSS").format(new java.util.Date())+"D");
		try {
			if(Db.conn!=null) Db.conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
   }
   ;

   public static Vector<Vector> getResponse(String[] signs, String language){
	    OC oc = new OC();
	    try {
	        oc.selNrs1 = Integer.parseInt(signs[0]);
	        oc.selNrs2 = Integer.parseInt(signs[1]);
	        oc.selNrs3 = Integer.parseInt(signs[2]);
	        oc.selNrs4 = Integer.parseInt(signs[3]);
	        oc.language=language;
        } catch (ArrayIndexOutOfBoundsException e) {
	        Debug.println("ArrayIndexOutOfBoundsException caught");
	    }
	    oc.setup();
	    Vector<Vector> result = oc.getListData();
		try {
			if(Db.conn!=null) Db.conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
   }
   ;

}
