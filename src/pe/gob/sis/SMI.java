package pe.gob.sis;

import java.util.Vector;

public class SMI extends SIS_Object{

	public SMI() {
		super(3, "SIS_SMI");
	}

	public static void moveToHistory(String uid){
		moveToHistory("SIS_SMI", 3, uid);
	}
	
	public static Vector getForFUA(String uid){
		return SIS_Object.getForFUA("SIS_SMI", 3, uid);
	}
	

}
