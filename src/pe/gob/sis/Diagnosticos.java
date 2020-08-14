package pe.gob.sis;

import java.util.Vector;

public class Diagnosticos extends SIS_Object{

	public Diagnosticos() {
		super(5, "SIS_DIAGNOSTICOS");
	}

	public static void moveToHistory(String uid){
		moveToHistory("SIS_DIAGNOSTICOS", 5, uid);
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
	
	public static Vector getForFUA(String uid){
		return SIS_Object.getForFUA("SIS_DIAGNOSTICOS", 5, uid);
	}
	
	boolean isValid(int fieldid){
		if("*1*5*".contains("*"+fieldid+"*")){
			return getValueInt(fieldid)>0;
		}
		else if("*4*".contains("*"+fieldid+"*")){
			return "IE".contains(getValueString(fieldid).toUpperCase());
		}
		else if("*2*".contains("*"+fieldid+"*")){
			return getValueString(fieldid).length()>1;
		}
		return true;
	}
}
