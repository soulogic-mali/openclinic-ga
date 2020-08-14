package pe.gob.sis;

import java.util.Vector;

public class RecienNacido extends SIS_Object{

	public RecienNacido() {
		super(14, "SIS_RECIENNACIDO");
	}

	public static RecienNacido getForFUA(String uid){
		return (RecienNacido)get("SIS_RECIENNACIDO",14,uid);
	}
	
	boolean isValid(int fieldid){
		if("*3*".contains("*"+fieldid+"*")){
			return getValueInt(fieldid)==1 || getValueInt(fieldid)==7 || getValueInt(fieldid)==0;
		}
		if("*4*".contains("*"+fieldid+"*")){
			if(getValueInt(3)==1){
				return getValueString(fieldid).length()==8;
			}
			else if(getValueInt(3)==7){
				return getValueString(fieldid).length()>0 && getValueString(fieldid).length()<11;
			}
			else if(getValueInt(3)==0){
				return getValueString(fieldid).length()==0;
			}
		}
		if("*7*".contains("*"+fieldid+"*")){
			return getValueString(fieldid).length()>7 && getValueString(fieldid).length()<10;
		}
		if("*9*".contains("*"+fieldid+"*")){
			if(getValueInt(3)==0 && getValueString(10).length()==0){
				return getValueString(fieldid).length()>0;
			}
		}
		if("*10*".contains("*"+fieldid+"*")){
			if(getValueInt(3)==0 && getValueString(9).length()==0){
				return getValueString(fieldid).length()>0;
			}
		}
		if("*11*".contains("*"+fieldid+"*")){
			if(getValueInt(3)==0){
				return getValueString(fieldid).length()>0;
			}
		}
		if("*12*".contains("*"+fieldid+"*")){
			return getValueString(fieldid).length()==0 || getValueString(11).length()>0;
		}
		if("*13*14*".contains("*"+fieldid+"*")){
			return getValueString(fieldid).length()==0 || getValueInt(3)==0;
		}
		return true;
	}

}
