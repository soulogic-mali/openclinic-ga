package be.openclinic.archiving;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.servlet.ServletOutputStream;

import org.dcm4che2.data.DicomObject;
import org.dcm4che2.data.Tag;
import org.dcm4che2.io.DicomInputStream;
import org.dcm4che2.io.DicomOutputStream;
import org.dcm4che2.io.StopTagInputHandler;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;

public class Dicom {

	public static DicomObject getDicomObject(String filename){
		return getDicomObject(new File(filename));
	}
	
	public static DicomObject getDicomObject(File file){
		DicomObject dcmObj=null;
		DicomInputStream din = null;
		try {
		    din = new DicomInputStream(file);
		    dcmObj = din.readDicomObject();
		}
		catch (Exception e) {
			e.printStackTrace();
		    Debug.println(e.getMessage());
		}
		finally {
		    try {
		        din.close();
		    }
		    catch (Exception ignore) {
		    }
		}
	    return dcmObj;
	}
	
	public static DicomObject getDicomObject(URL url){
		DicomObject dcmObj=null;
		DicomInputStream din = null;
		try {
		    din = new DicomInputStream(url.openStream());
		    dcmObj = din.readDicomObject();
		}
		catch (Exception e) {
			e.printStackTrace();
		    Debug.println(e.getMessage());
		}
		finally {
		    try {
		        din.close();
		    }
		    catch (Exception ignore) {
		    }
		}
	    return dcmObj;
	}
	
	public static DicomObject getDicomObjectNoPixels(File file){
		DicomObject dcmObj=null;
		DicomInputStream din = null;
		try {
		    din = new DicomInputStream(file);
		    din.setHandler(new StopTagInputHandler(Tag.PixelData));
		    dcmObj = din.readDicomObject();
		}
		catch (Exception e) {
			e.printStackTrace();
		    Debug.println(e.getMessage());
		}
		finally {
		    try {
		        din.close();
		    }
		    catch (Exception ignore) {
		    }
		}
	    return dcmObj;
	}
	
	public static void writeDicomObject(DicomObject obj,File file){
		FileOutputStream fos;
		try {
		    fos = new FileOutputStream(file);
		}
		catch (FileNotFoundException e) {
		    e.printStackTrace();
		    return;
		}
		BufferedOutputStream bos = new BufferedOutputStream(fos);
		DicomOutputStream dos = new DicomOutputStream(bos);
		try {
		    dos.writeDicomFile(obj);
		}
		catch (IOException e) {
		    e.printStackTrace();
		    return;
		}
		finally {
		    try {
		        dos.close();
		    }
		    catch (IOException ignore) {
		    }
		}
	}
	
	public static void convertDicomToJpeg(File source, File destination){
	    try{
	    	ImageIO.scanForPlugins();
            Dcm2Jpg dcm2jpg= new Dcm2Jpg();           
            dcm2jpg.convert(source, destination);         
        } catch(Exception e){
            e.printStackTrace();
        }
	}
	
	public static void convertDicomToJpeg(File source, File destination, int quality){
	    try{
	    	ImageIO.scanForPlugins();
            Dcm2Jpg dcm2jpg= new Dcm2Jpg();    
            dcm2jpg.setImageQuality(quality);
            dcm2jpg.convert(source, destination);         
        } catch(Exception e){
            e.printStackTrace();
        }
	}
	
	public static void convertDicomToJpegThumbnail(File source, ServletOutputStream destination, ImageReader reader){
	    try{
            Dcm2Jpg dcm2jpg= new Dcm2Jpg();       
            dcm2jpg.setImageQuality(MedwanQuery.getInstance().getConfigInt("DICOMThumbnailQuality",10));
            dcm2jpg.convert(source, destination,reader);         
        } catch(Exception e){
            e.printStackTrace();
        }
	}
	
	public static void convertDicomToJpegThumbnail(File source, ServletOutputStream destination){
	    try{
	    	ImageIO.scanForPlugins();
            Dcm2Jpg dcm2jpg= new Dcm2Jpg();       
            dcm2jpg.setImageQuality(MedwanQuery.getInstance().getConfigInt("DICOMThumbnailQuality",10));
            dcm2jpg.convert(source, destination);         
        } catch(Exception e){
            e.printStackTrace();
        }
	}
	
	public static void convertDicomToJpeg(File source, ServletOutputStream destination){
	    try{
	    	ImageIO.scanForPlugins();
            Dcm2Jpg dcm2jpg= new Dcm2Jpg();       
            dcm2jpg.convert(source, destination);         
        } catch(Exception e){
            e.printStackTrace();
        }
	}
	
}
