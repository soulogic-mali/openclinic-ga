package pe.gob.sis;

import java.util.Vector;

public class Insumos extends SIS_Object{

	public Insumos() {
		super(8, "SIS_INSUMOS");
	}

	public static Vector getForFUA(String uid){
		return SIS_Object.getForFUA("SIS_INSUMOS", 8, uid);
	}
	
	public static void moveToHistory(String uid){
		moveToHistory("SIS_INSUMOS", 8, uid);
	}
	
	public String getErrors(){
		String errors = "";
		for(int n=1;n<=fields;n++){
			if(!isValid(n)){
				if(errors.length()>0){
					errors+=",";
				}
				errors+=n;
			}
		}
		return errors;
	}

	boolean isValid(int fieldid){
		if("*1*3*".contains("*"+fieldid+"*")){
			return getValueInt(fieldid)>0;
		}
		else if("*2*".contains("*"+fieldid+"*")){
			return FUA.isValidDIGEMID(getValueString(fieldid));
		}
		return true;
	}

}
