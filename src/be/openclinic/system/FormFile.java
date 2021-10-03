package be.openclinic.system;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;

public class FormFile {
	String filename=null;
	byte[] document=null;
	
	public String getFilename() {
		return filename;
	}
	public void setFilename(String filename) {
		this.filename = filename;
	}
	public byte[] getDocument() {
		return document;
	}
	public void setDocument(byte[] document) {
		this.document = document;
	}
	
	public boolean isAcceptableUploadFileExtension() {
		return SH.isAcceptableUploadFileExtension(this.getFilename());
	}
	
	public boolean store(String pathAndFileName) {
		try {
			FileUtils.writeByteArrayToFile(new File(pathAndFileName), this.getDocument());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
		return true;
	}
}
