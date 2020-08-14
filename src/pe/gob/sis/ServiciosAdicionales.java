package pe.gob.sis;

public class ServiciosAdicionales extends SIS_Object{

	public ServiciosAdicionales() {
		super(2, "SIS_SERVICIOSADICIONALES");
	}

	public static void moveToHistory(String uid){
		moveToHistory("SIS_SERVICIOSADICIONALES", 2, uid);
	}
	
	boolean isValid(int fieldid){
		return true;
	}

}
