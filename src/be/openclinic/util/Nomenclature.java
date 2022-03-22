package be.openclinic.util;

import java.io.StringReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Vector;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;
import net.admin.Service;

public class Nomenclature {
	String type;
	String id;
	String parentId;
	String data;
	int updatetUserId;
	java.util.Date updateTime;
	int inactive;
	Nomenclature parent;
	Hashtable parameters;
	
    public String getFullyQualifiedName(String language){
    	String name=ScreenHelper.getTran("admin.nomenclature."+type, id, language);
    	if(parentId!=null && parentId.length()>0){
    		Nomenclature parentNomenclature = Nomenclature.get(type,parentId);
    		if(parentNomenclature!=null){
    			name=parentNomenclature.getFullyQualifiedName(language)+" - "+name;
    		}
    	}
    	return name;
    }
    public String getFullyQualifiedNameGeneric(String language){
    	String name=ScreenHelper.getTran(type, id, language);
    	if(parentId!=null && parentId.length()>0){
    		Nomenclature parentNomenclature = Nomenclature.get(type,parentId);
    		if(parentNomenclature!=null){
    			name=parentNomenclature.getFullyQualifiedNameGeneric(language)+">"+name;
    		}
    	}
    	return name;
    }
    public String getFullyQualifiedIDGeneric(){
    	String theid = id;
    	if(parentId!=null && parentId.length()>0){
    		Nomenclature parentNomenclature = Nomenclature.get(type,parentId);
    		if(parentNomenclature!=null){
    			theid=parentNomenclature.getFullyQualifiedIDGeneric()+";"+id;
    		}
    	}
    	return theid;
    }
    public String getFullyQualifiedNameLibrary(String language){
    	String name=ScreenHelper.getTran(type, id, language);
    	if(parentId!=null && parentId.length()>0){
    		Nomenclature parentNomenclature = Nomenclature.get(type,parentId);
    		if(parentNomenclature!=null){
    			name="<a href='javascript:setFolder(\""+parentId+"\")'>"+parentNomenclature.getFullyQualifiedNameGeneric(language)+"</a>>"+name;
    		}
    	}
    	return name;
    }
    public String getFullyQualifiedName(String language,String separator){
    	String name=ScreenHelper.getTran("admin.nomenclature."+type, id, language);
    	if(parentId!=null && parentId.length()>0){
    		Nomenclature parentNomenclature = Nomenclature.get(type,parentId);
    		if(parentNomenclature!=null){
    			name=parentNomenclature.getFullyQualifiedName(language)+separator+name;
    		}
    	}
    	return name;
    }

    public String getType() {
		return ScreenHelper.checkString(type);
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getId() {
		return ScreenHelper.checkString(id);
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getParentId() {
		return ScreenHelper.checkString(parentId);
	}
	public void setParentId(String parentId) {
		this.parentId = parentId;
	}
	public String getData() {
		return ScreenHelper.checkString(data);
	}
	public void setData(String data) {
		this.data = data;
	}
	public int getUpdatetUserId() {
		return updatetUserId;
	}
	public void setUpdatetUserId(int updatetUserId) {
		this.updatetUserId = updatetUserId;
	}
	public java.util.Date getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(java.util.Date updateTime) {
		this.updateTime = updateTime;
	}
	public int getInactive() {
		return inactive;
	}
	public void setInactive(int inactive) {
		this.inactive = inactive;
	}
	public Nomenclature getParent(){
		if(parent==null && ScreenHelper.checkString(this.getParentId()).length()>0){
			parent = get(this.getType(),this.getParentId());
		}
		return parent;
	}
	
	public Hashtable getParameters(){
		if(parameters==null){
			parameters = new Hashtable();
			if(this.getData().length()>0){
				try{
		            SAXReader reader = new SAXReader(false);
		            Document document = reader.read(new StringReader(this.getData()));
		            Element root = document.getRootElement();
		            Iterator iParameters = root.elementIterator("p");
		            while(iParameters.hasNext()){
		            	Element p = (Element)iParameters.next();
		            	parameters.put(p.attributeValue("n"), p.getText());
		            }
				}
				catch(Exception e){
					e.printStackTrace();
				}
			}
		}
		return parameters;
	}
	
	public void setParameter(String key,String value){
		getParameters().put(key, value);
	}
	
	public String getParameter(String key){
		return ScreenHelper.checkString((String)getParameters().get(key));
	}
	
    public static Vector getNomenclatureIDsByText(String type, String sWebLanguage, String sText){
        PreparedStatement ps = null;
        ResultSet rs = null;

        Vector vCategoryIDs = new Vector();
        String sID;


        String sQuery = "SELECT OC_LABEL_TYPE,OC_LABEL_ID FROM OC_LABELS"+
                        " WHERE "+ScreenHelper.getConfigParam("lowerCompare","OC_LABEL_TYPE")+" = 'admin.nomenclature."+type+"'"+
                        "  AND "+ScreenHelper.getConfigParam("lowerCompare","OC_LABEL_LANGUAGE")+" LIKE ?"+
                        "  AND ("+ScreenHelper.getConfigParam("lowerCompare","OC_LABEL_ID")+" LIKE ?"+
                        "   OR "+ScreenHelper.getConfigParam("lowerCompare","OC_LABEL_ID")+" LIKE ?"+
                        "   OR "+ScreenHelper.getConfigParam("lowerCompare","OC_LABEL_VALUE")+" LIKE ?"+
                        "  ) order by OC_LABEL_TYPE,OC_LABEL_ID";

        Connection loc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            ps = loc_conn.prepareStatement(sQuery);
            ps.setString(1,"%"+sWebLanguage.toLowerCase()+"%");
            ps.setString(2,"%"+sText.toLowerCase()+"%");
            ps.setString(3,"%"+sText.toLowerCase()+".%");
            ps.setString(4,"%"+sText.toLowerCase()+"%");
            rs = ps.executeQuery();

            while(rs.next()){
                sID = ScreenHelper.checkString(rs.getString("OC_LABEL_ID"));

                vCategoryIDs.addElement(sID);
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                loc_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return vCategoryIDs;
    }

    public static String getRootNomenclatureCode(String code) {
    	return "";
    }

	public static Vector<Nomenclature> getRootElements(String type){
		Vector<Nomenclature> nomenclatures = new Vector<Nomenclature>();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = conn.prepareStatement("select * from OC_NOMENCLATURE where OC_NOMENCLATURE_TYPE=? and (OC_NOMENCLATURE_PARENTID is null or OC_NOMENCLATURE_PARENTID='')");
			ps.setString(1, type);
			rs = ps.executeQuery();
			while(rs.next()){
				Nomenclature nomenclature = null;
				nomenclature = new Nomenclature();
				nomenclature.setType(rs.getString("OC_NOMENCLATURE_TYPE"));
				nomenclature.setId(rs.getString("OC_NOMENCLATURE_ID"));
				nomenclature.setParentId(rs.getString("OC_NOMENCLATURE_PARENTID"));
				nomenclature.setData(rs.getString("OC_NOMENCLATURE_DATA"));
				nomenclature.setUpdatetUserId(rs.getInt("OC_NOMENCLATURE_UPDATEUSERID"));
				nomenclature.setUpdateTime(rs.getDate("OC_NOMENCLATURE_UPDATETIME"));
				nomenclature.setInactive(rs.getInt("OC_NOMENCLATURE_INACTIVE"));
				nomenclatures.add(nomenclature);
			}
		}
		catch(Exception e){
			try {
				if(rs!=null){
					rs.close();
				}
				if(ps!=null){
					ps.close();
				}
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		}
		finally{
			try{
				conn.close();
			}
			catch(Exception e2){
				e2.printStackTrace();
			}
		}
		return nomenclatures;
	}
	
	public static Vector<Nomenclature> getChildren(String type,String parentId){
		Vector<Nomenclature> nomenclatures = new Vector<Nomenclature>();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = conn.prepareStatement("select * from OC_NOMENCLATURE where OC_NOMENCLATURE_TYPE=? and OC_NOMENCLATURE_PARENTID=?");
			ps.setString(1, type);
			ps.setString(2, parentId);
			rs = ps.executeQuery();
			while(rs.next()){
				Nomenclature nomenclature = null;
				nomenclature = new Nomenclature();
				nomenclature.setType(rs.getString("OC_NOMENCLATURE_TYPE"));
				nomenclature.setId(rs.getString("OC_NOMENCLATURE_ID"));
				nomenclature.setParentId(rs.getString("OC_NOMENCLATURE_PARENTID"));
				nomenclature.setData(rs.getString("OC_NOMENCLATURE_DATA"));
				nomenclature.setUpdatetUserId(rs.getInt("OC_NOMENCLATURE_UPDATEUSERID"));
				nomenclature.setUpdateTime(rs.getDate("OC_NOMENCLATURE_UPDATETIME"));
				nomenclature.setInactive(rs.getInt("OC_NOMENCLATURE_INACTIVE"));
				nomenclatures.add(nomenclature);
			}
		}
		catch(Exception e){
			try {
				if(rs!=null){
					rs.close();
				}
				if(ps!=null){
					ps.close();
				}
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		}
		finally{
			try{
				conn.close();
			}
			catch(Exception e2){
				e2.printStackTrace();
			}
		}
		return nomenclatures;
	}
	
	public static Vector<Nomenclature> getAllChildren(String type,String parentId){
		Vector<Nomenclature> nomenclatures = new Vector<Nomenclature>();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = conn.prepareStatement("select * from OC_NOMENCLATURE where OC_NOMENCLATURE_TYPE=? and OC_NOMENCLATURE_PARENTID=?");
			ps.setString(1, type);
			ps.setString(2, parentId);
			rs = ps.executeQuery();
			while(rs.next()){
				Nomenclature nomenclature = null;
				nomenclature = new Nomenclature();
				nomenclature.setType(rs.getString("OC_NOMENCLATURE_TYPE"));
				nomenclature.setId(rs.getString("OC_NOMENCLATURE_ID"));
				nomenclature.setParentId(rs.getString("OC_NOMENCLATURE_PARENTID"));
				nomenclature.setData(rs.getString("OC_NOMENCLATURE_DATA"));
				nomenclature.setUpdatetUserId(rs.getInt("OC_NOMENCLATURE_UPDATEUSERID"));
				nomenclature.setUpdateTime(rs.getDate("OC_NOMENCLATURE_UPDATETIME"));
				nomenclature.setInactive(rs.getInt("OC_NOMENCLATURE_INACTIVE"));
				nomenclatures.add(nomenclature);
				nomenclatures.addAll(Nomenclature.getAllChildren(type, nomenclature.id));
			}
		}
		catch(Exception e){
			try {
				if(rs!=null){
					rs.close();
				}
				if(ps!=null){
					ps.close();
				}
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		}
		finally{
			try{
				conn.close();
			}
			catch(Exception e2){
				e2.printStackTrace();
			}
		}
		return nomenclatures;
	}
	
	public static Nomenclature get(String type,String uid){
		Nomenclature nomenclature = null;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = conn.prepareStatement("select * from OC_NOMENCLATURE where OC_NOMENCLATURE_TYPE=? and OC_NOMENCLATURE_ID=?");
			ps.setString(1, type);
			ps.setString(2, uid);
			rs = ps.executeQuery();
			if(rs.next()){
				nomenclature = new Nomenclature();
				nomenclature.setType(type);
				nomenclature.setId(uid);
				nomenclature.setParentId(rs.getString("OC_NOMENCLATURE_PARENTID"));
				nomenclature.setData(rs.getString("OC_NOMENCLATURE_DATA"));
				nomenclature.setUpdatetUserId(rs.getInt("OC_NOMENCLATURE_UPDATEUSERID"));
				nomenclature.setUpdateTime(rs.getDate("OC_NOMENCLATURE_UPDATETIME"));
				nomenclature.setInactive(rs.getInt("OC_NOMENCLATURE_INACTIVE"));
			}
			rs.close();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			try{
				conn.close();
			}
			catch(Exception e2){
				e2.printStackTrace();
			}
		}
		return nomenclature;
	}
	
	public static void delete(String type,String uid){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("delete from OC_NOMENCLATURE where OC_NOMENCLATURE_TYPE=? and OC_NOMENCLATURE_ID like ?");
			ps.setString(1, type);
			ps.setString(2, uid);
			ps.execute();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			try{
				conn.close();
			}
			catch(Exception e2){
				e2.printStackTrace();
			}
		}
	}
	
	public void store(){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		try{
			String newData = "<pars>";
			Hashtable pars = this.getParameters();
			Enumeration eParameters = pars.keys();
			while(eParameters.hasMoreElements()){
				String key = (String)eParameters.nextElement();
				String value = (String)pars.get(key);
				newData+="<p n='"+key+"'>"+value+"</p>";
			}
			newData+="</pars>";
			ps = conn.prepareStatement("delete from OC_NOMENCLATURE where OC_NOMENCLATURE_TYPE=? and OC_NOMENCLATURE_ID=?");
			ps.setString(1, this.getType());
			ps.setString(2, this.getId());
			ps.execute();
			ps.close();
			ps = conn.prepareStatement("insert into OC_NOMENCLATURE(OC_NOMENCLATURE_ID,OC_NOMENCLATURE_PARENTID,OC_NOMENCLATURE_DATA,"
					+ "OC_NOMENCLATURE_UPDATEUSERID,OC_NOMENCLATURE_UPDATETIME,OC_NOMENCLATURE_INACTIVE,OC_NOMENCLATURE_TYPE) values(?,?,?,?,?,?,?)");
			ps.setString(1, this.getId());
			ps.setString(2, this.getParentId());
			ps.setString(3, newData);
			ps.setInt(4, this.getUpdatetUserId());
			this.setUpdateTime(new java.util.Date());
			ps.setTimestamp(5, new java.sql.Timestamp(this.getUpdateTime().getTime()));
			ps.setInt(6, this.getInactive());
			ps.setString(7, this.getType());
			ps.execute();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			try{
				conn.close();
			}
			catch(Exception e2){
				e2.printStackTrace();
			}
		}
	}
	
}
