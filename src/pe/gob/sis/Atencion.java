package pe.gob.sis;

import java.text.SimpleDateFormat;
import java.util.Hashtable;
import java.util.Vector;

import be.mxs.common.util.system.ScreenHelper;

public class Atencion extends SIS_Object{ 

	public Atencion() {
		super(85, "SIS_ATENCION");
	}
	
	public Atencion get(String uid){
		return (Atencion)get(tableName,fields,uid);
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
	
	public static Atencion getForFUA(String uid){
		return (Atencion)get("SIS_ATENCION",85,uid);
	}
	
	boolean isValid(int fieldid){
		if("*1*5*18*24*43*44*72*79*80*81*".contains("*"+fieldid+"*")){
			return getValueInt(fieldid)>0;
		}
		else if("*2*3*4*6*7*8*14*17*20*21*28*31*32*33*34*35*36*42*45*74*".contains("*"+fieldid+"*")){
			return getValueString(fieldid).length()>0;
		}
		else if("*10*".contains("*"+fieldid+"*")){
			return "*S*N*".contains("*"+getValueString(fieldid).toUpperCase()+"*");
		}
		else if("*11*12*13*".contains("*"+fieldid+"*")){
			return getValueString(10).equalsIgnoreCase("N") || getValueString(fieldid).length()>0;
		}
		else if("*25*".contains("*"+fieldid+"*")){
			if(getValueInt(24)==1 || getValueInt(24)==4){
				return getValueString(fieldid).length()==8;
			}
			else if(getValueInt(24)==2){
				return true;
			}
			else if(getValueInt(24)==3){
				return getValueString(fieldid).length()==9;
			}
			else if(getValueInt(24)==7){
				return getValueString(fieldid).length()>0;
			}
			else if(getValueInt(24)==8){
				return getValueString(fieldid).length()==10;
			}
		}
		else if("*26*27*".contains("*"+fieldid+"*")){
			return getValueString(27).length()>0 || getValueString(26).length()>0;
		}
		else if("*30*".contains("*"+fieldid+"*")){
			return getValueDate(fieldid)!=null;
		}
		else if("*37*".contains("*"+fieldid+"*")){
			if(getValueInt(36)==2 || getValueInt(36)==3 || getValueInt(36)==6){
				return getValueString(fieldid).length()>0;
			}
		}
		else if("*38*".contains("*"+fieldid+"*")){
			if(getValueInt(36)==2 || getValueInt(36)==3 || getValueInt(36)==6){
				return getValueDouble(fieldid)>0;
			}
		}
		else if("*39*83*".contains("*"+fieldid+"*")){
			return getValueDateTime(fieldid)!=null;
		}
		else if("*40*41*".contains("*"+fieldid+"*")){
			return (getValueInt(34)!=2 || getValueInt(43)==3) || getValueString(fieldid).length()>0;
		}
		else if("*46*".contains("*"+fieldid+"*")){
			return (!"*065*066*067*068*".contains("*"+getValueString(42)+"*") || (getValueDate(fieldid)!=null && getValueDate(39)!=null && !getValueDate(fieldid).after(getValueDate(39))));
		}
		else if("*47*".contains("*"+fieldid+"*")){
			return (!"*065*066*067*068*".contains("*"+getValueString(42)+"*") || (getValueDate(fieldid)!=null && getValueDate(39)!=null && !getValueDate(fieldid).before(getValueDate(39))));
		}
		else if("*48*49*".contains("*"+fieldid+"*")){
			if(getValueInt(45)>2 && getValueInt(45)<7){
				return getValueString(fieldid).length()>0;
			}
		}
		else if("*50*".contains("*"+fieldid+"*")){
			if(getValueInt(35)==2){
				return getValueDate(fieldid)!=null;
			}
			if(getValueInt(35)==0){
				return getValueDate(fieldid)==null;
			}
		}
		else if("*60*".contains("*"+fieldid+"*")){
			return getValueInt(43)!=4 || getValueString(fieldid).length()>0;
		}
		else if("*65*".contains("*"+fieldid+"*")){
			return getValueInt(45)!=9 || getValueString(fieldid).length()>0;
		}
		else if("*73*".contains("*"+fieldid+"*")){
			if(getValueInt(72)==1){
				return getValueString(fieldid).length()==8;
			}
			else if(getValueInt(72)==3){
				return getValueString(fieldid).length()==9;
			}
		}
		else if("*82*".contains("*"+fieldid+"*")){
			if(getValueInt(81)==1){
				return getValueString(fieldid).length()==8;
			}
			else if(getValueInt(81)==3){
				return getValueString(fieldid).length()==9;
			}
		}
		return true;
	}
}
