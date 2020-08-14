package be.openclinic.archiving;

public class Compress {

	public static void main(String[] args) throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException {
		//System.setProperty("java.library.path","c:\\temp");
		System.out.println("LIB PATH = "+System.getProperty("java.library.path"));
		be.openclinic.archiving.DicomUtils.compressDicom("c:/temp/test.dcm","--j2kr");
	}

}
