package be.openclinic.archiving;

import java.io.File;
import java.io.IOException;
import java.util.Iterator;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.servlet.ServletOutputStream;

import org.apache.commons.io.FileUtils;

public class DicomUtils {
	
	public static boolean compressDicomDefault(String filename) {
		return compressDicom(filename, "--j2kr");
	}
	
	public static boolean compressDicom(String filename,String compression) {
		FileUtils.deleteQuietly(new File(filename+".z"));
		FileUtils.deleteQuietly(new File(filename+".u"));
		String[] args = {compression,filename,filename+".z"};
		if (Dcm2dcm.main(args)) {
			try {
				FileUtils.moveFile(new File(filename), new File(filename+".u"));
				try {
					FileUtils.moveFile(new File(filename+".z"), new File(filename));
					FileUtils.deleteQuietly(new File(filename+".u"));
					return true;
				} catch (IOException e) {
					FileUtils.moveFile(new File(filename+".u"), new File(filename));
					FileUtils.deleteQuietly(new File(filename+".z"));
					e.printStackTrace();
				}
			} catch (IOException e) {
				FileUtils.deleteQuietly(new File(filename+".z"));
				e.printStackTrace();
			}
		}
		return false;
	}

	public static boolean compressDicomDefault(String sourcefile, String destinationfile) {
		return compressDicom(sourcefile,destinationfile, "--j2kr");
	}
	
	public static boolean compressDicom(String sourcefile, String destinationfile, String compression) {
		String[] args = {compression,sourcefile,destinationfile};
		return Dcm2dcm.main(args);
	}
	
	public static boolean exportToJpeg(String sourcefile, String destinationfile) {
		Dcm2Jpg dcm2jpg = new Dcm2Jpg();
		try {
			dcm2jpg.convert(new File(sourcefile), new File(destinationfile));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	public static boolean exportToJpeg(String sourcefile, ServletOutputStream sos) {
		Dcm2Jpg dcm2jpg = new Dcm2Jpg();
		try {
			dcm2jpg.convert(new File(sourcefile), sos);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
		return true;
	}
		
	public static org.dcm4che2.imageioimpl.plugins.dcm.DicomImageReader getDCM4CHE2DicomImageReader(){
		Iterator<ImageReader> readers = ImageIO.getImageReadersByFormatName("DICOM");
		if(!readers.hasNext()) {
			ImageIO.scanForPlugins();
			readers = ImageIO.getImageReadersByFormatName("DICOM");
		}
		while(readers.hasNext()) {
			ImageReader candidate = readers.next(); 
			if(candidate instanceof org.dcm4che2.imageioimpl.plugins.dcm.DicomImageReader) {
				return (org.dcm4che2.imageioimpl.plugins.dcm.DicomImageReader)candidate;
			}
		}
		return null;
	}

	public static org.dcm4che3.imageio.plugins.dcm.DicomImageReader getDCM4CHE3DicomImageReader(){
		Iterator<ImageReader> readers = ImageIO.getImageReadersByFormatName("DICOM");
		if(!readers.hasNext()) {
			ImageIO.scanForPlugins();
			readers = ImageIO.getImageReadersByFormatName("DICOM");
		}
		while(readers.hasNext()) {
			ImageReader candidate = readers.next(); 
			if(candidate instanceof org.dcm4che3.imageio.plugins.dcm.DicomImageReader) {
				return (org.dcm4che3.imageio.plugins.dcm.DicomImageReader)candidate;
			}
		}
		return null;
	}

}
