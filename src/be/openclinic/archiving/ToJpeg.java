package be.openclinic.archiving;

public class ToJpeg {

	public static void main(String[] args) throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException {
		be.openclinic.archiving.DicomUtils.exportToJpeg("C:/Users/Frank/OneDrive/projects/openclinicnew/web/scan/to/D/00000192317.dcm","C:/Users/Frank/OneDrive/projects/openclinicnew/web/scan/to/D/00000192317.dcm.z");
	}

}
