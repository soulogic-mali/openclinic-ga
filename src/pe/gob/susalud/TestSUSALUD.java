package pe.gob.susalud;

import java.io.IOException;

import be.openclinic.reporting.SUSALUD;
import uk.org.primrose.GeneralException;
import uk.org.primrose.vendor.standalone.PrimroseLoader;

public class TestSUSALUD {

	public static void main(String[] args) throws GeneralException, IOException {
		PrimroseLoader.load("C:/Program Files/Apache Software Foundation/Tomcat 8.5/conf/db.cfg", true);

		System.out.println(SUSALUD.getAffiliationInformation(9966,"20029").getNuControlST());
		System.exit(0);
	}

}
