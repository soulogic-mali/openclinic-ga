package be.mxs.common.util.io;

import javax.servlet.http.HttpSession;

import com.digitalpersona.uareu.Engine;
import com.digitalpersona.uareu.Engine.PreEnrollmentFmd;

import be.mxs.common.util.db.MedwanQuery;

import com.digitalpersona.uareu.Fid;
import com.digitalpersona.uareu.Fmd;
import com.digitalpersona.uareu.Reader;
import com.digitalpersona.uareu.UareUException;
import com.digitalpersona.uareu.UareUGlobal;

public class DigitalPersona implements Reader.CaptureCallback,Engine.EnrollmentCallback{
	private Reader m_Reader=null;
    private com.digitalpersona.uareu.Fmd.Format fmdFormat;
    private boolean bReceivedResult;
    private Reader.CaptureResult result;
    private Fmd enrollmentFmd;
    private int enrollCount;
    private String enrollCountParameter=null;
    int timeout=5000;
    
    public DigitalPersona(){
    	
    }
    
    public DigitalPersona(String enrollCountParameter){
    	this.enrollCountParameter=enrollCountParameter;
    }
    
    public int getEnrollCount() {
		return enrollCount;
	}

	public void setEnrollCount(int enrollCount) {
		this.enrollCount = enrollCount;
	}

	public Fmd getEnrollmentFmd() {
		return enrollmentFmd;
	}

	public void setEnrollmentFmd(Fmd enrollmentFmd) {
		this.enrollmentFmd = enrollmentFmd;
	}

	public Reader.CaptureResult getResult() {
		return result;
	}

	public void CaptureResultEvent(Reader.CaptureResult result){
    	this.result=result;
        bReceivedResult=true;
    }
	
	public PreEnrollmentFmd GetFmd(Fmd.Format format){
		if(enrollCountParameter!=null){
			MedwanQuery.getInstance().getCountersInUse().put(enrollCountParameter, enrollCount);
		}
    	bReceivedResult=false;
		Engine.PreEnrollmentFmd prefmd = null;
		System.out.println("got enrollment event");
    	m_Reader=getReader();
    	if(m_Reader==null){
    		return null;
    	}
        System.out.println("reader = "+m_Reader.GetDescription().name);
		//open reader
		try{
			Thread.sleep(100);
			m_Reader.Open(Reader.Priority.EXCLUSIVE);
		}
		catch(Exception e){ 
			e.printStackTrace(); 
            try {
				m_Reader.Reset();
			} catch (UareUException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
            System.out.println("reader was reset");
		}
		boolean bReady = false;
		int counter=0;
		while(!bReady && counter<20){
			Reader.Status rs;
			try {
				rs = m_Reader.GetStatus();
				if(Reader.ReaderStatus.BUSY == rs.status){
					//if busy, wait a bit
					try{
						Thread.sleep(100);
						counter++;
						System.out.print(".");
					} 
					catch(InterruptedException e) {
						e.printStackTrace();
						break; 
					}
				}
				else if(Reader.ReaderStatus.READY == rs.status || Reader.ReaderStatus.NEED_CALIBRATION == rs.status){
					//ready for capture
					bReady = true;
					break;
				}
				else{
					//reader failure
					break;
				}
			} catch (UareUException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		try {
			if(bReady){
	            System.out.println("status = "+m_Reader.GetStatus());
	            System.out.println("cancapture = "+m_Reader.GetCapabilities().can_capture);
	            System.out.println("can_extract_features  = "+m_Reader.GetCapabilities().can_extract_features );
	            System.out.println("start enrollment capture");
				m_Reader.CaptureAsync(Fid.Format.ANSI_381_2004, Reader.ImageProcessing.IMG_PROC_DEFAULT, 500, this.timeout,this);
	            System.out.println("async event sent");
	    		enrollCount++;
	            long starttime = new java.util.Date().getTime();
	            while(!bReceivedResult && new java.util.Date().getTime()-starttime<this.timeout){
	            	try {
						Thread.sleep(500);
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
	            }
    			m_Reader.Close();
			}
			else{
	            System.out.println("reader not ready");
	            m_Reader.Reset();
	            System.out.println("reader was reset");
			}
		} catch (UareUException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if(bReceivedResult){
			System.out.println("sending fingerprint to engine");
			Engine engine = UareUGlobal.GetEngine();
			Fmd fmd;
			try {
				fmd = engine.CreateFmd(getResult().image, Fmd.Format.ANSI_378_2004);
				//return prefmd 
				prefmd = new Engine.PreEnrollmentFmd();
				prefmd.fmd = fmd;
				prefmd.view_index = 0;
			} catch (UareUException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			System.out.println("fingerprint added to enrollment");
		}
		else{
			System.out.println("no valid result registered");
		}
		return prefmd;
	}
	
	public Reader getReader(){
        try {
            com.digitalpersona.uareu.ReaderCollection collection= com.digitalpersona.uareu.UareUGlobal.GetReaderCollection();
			collection.GetReaders();
	        if(collection.size()==0){
	        	return null;
	        }else{
	        	return collection.get(0);
	        }
		} catch (UareUException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        return null;
	}
	
	public void EnrollFingerprint(int timeout){
		this.timeout=timeout;
		enrollmentFmd=null;
		enrollCount=0;
		try {
			Engine engine = UareUGlobal.GetEngine();
			enrollmentFmd = engine.CreateEnrollmentFmd(Fmd.Format.ANSI_378_2004, this);
			System.out.println("End of enrollment process");
		} catch (UareUException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		enrollCount=-1;
		if(enrollCountParameter!=null){
			MedwanQuery.getInstance().getCountersInUse().put(enrollCountParameter, enrollCount);
		}
	}
    
    public void readFingerPrint(int timeout){
    	this.timeout=timeout;
    	bReceivedResult=false;
    	result=null;
        try{            
        	m_Reader=getReader();
        	if(m_Reader==null){
        		return;
        	}
            System.out.println("reader = "+m_Reader.GetDescription().name);
    		//open reader
    		try{
    			m_Reader.Open(Reader.Priority.EXCLUSIVE);
    		}
    		catch(UareUException e){ 
    			e.printStackTrace(); 
	            m_Reader.Reset();
	            System.out.println("reader was reset");
    		}
			boolean bReady = false;
			int counter=0;
			while(!bReady && counter<20){
				Reader.Status rs = m_Reader.GetStatus();
				if(Reader.ReaderStatus.BUSY == rs.status){
					//if busy, wait a bit
					try{
						Thread.sleep(100);
						counter++;
						System.out.print(".");
					} 
					catch(InterruptedException e) {
						e.printStackTrace();
						break; 
					}
				}
				else if(Reader.ReaderStatus.READY == rs.status || Reader.ReaderStatus.NEED_CALIBRATION == rs.status){
					//ready for capture
					bReady = true;
					break;
				}
				else{
					//reader failure
					break;
				}
			}
			if(bReady){
	            System.out.println("status = "+m_Reader.GetStatus());
	            System.out.println("cancapture = "+m_Reader.GetCapabilities().can_capture);
	            System.out.println("can_extract_features  = "+m_Reader.GetCapabilities().can_extract_features );
	            System.out.println("start capture");
				m_Reader.CaptureAsync(Fid.Format.ANSI_381_2004, Reader.ImageProcessing.IMG_PROC_DEFAULT, 500, timeout,this);
				//m_Reader.Capture(Fid.Format.ANSI_381_2004, Reader.ImageProcessing.IMG_PROC_DEFAULT, 500, timeout);
	            System.out.println("async event sent");
	            long starttime = new java.util.Date().getTime();
	            while(!bReceivedResult && new java.util.Date().getTime()-starttime<timeout){
	            	try {
						Thread.sleep(100);
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
	            }
	            try {
	    			m_Reader.Close();
	    		} catch (UareUException e) {
	    			// TODO Auto-generated catch block
	    			e.printStackTrace();
	    		}
			}
			else{
	            System.out.println("reader not ready");
	            m_Reader.Reset();
	            System.out.println("reader was reset");
			}
        } catch (UareUException e){
        	e.printStackTrace();
        }
    }
}
