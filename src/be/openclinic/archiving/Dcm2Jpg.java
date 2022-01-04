package be.openclinic.archiving;

import java.awt.image.BufferedImage;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;

import javax.imageio.IIOException;
import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.spi.ImageWriterSpi;
import javax.imageio.spi.ServiceRegistry;
import javax.imageio.stream.FileImageOutputStream;
import javax.imageio.stream.ImageInputStream;
import javax.imageio.stream.ImageOutputStream;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpSession;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.GnuParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.OptionBuilder;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.dcm4che2.data.DicomObject;
import org.dcm4che2.imageio.plugins.dcm.DicomImageReadParam;
import org.dcm4che2.io.DicomInputStream;
import org.dcm4che2.util.CloseUtils;

import com.sun.image.codec.jpeg.ImageFormatException;

import be.mxs.common.util.system.Debug;
import be.openclinic.system.SH;

/**
 * @author Gunter Zeilinger <gunterze@gmail.com>
 * @version $Revision$ $Date$
 * @since Jul 11, 2007
 */
public class Dcm2Jpg {

    private static final String USAGE =
        "dcm2jpg [Options] <dcmfile> <jpegfile>\n" +
        "or dcm2jpg [Options] <dcmfile>... <outdir>\n" +
        "or dcm2jpg [Options] <indir>... <outdir>";
    private static final String DESCRIPTION = 
        "Convert DICOM image(s) to JPEG(s)\nOptions:";
    private static final String EXAMPLE = null;
    private int frame = 1;
    private float center;
    private float width;
    private String vlutFct;
    private boolean autoWindowing;
    private DicomObject prState;
    private short[] pval2gray;
    private String formatName = "JPEG";
    private String compressionType = "jpeg";
    private String fileExt = ".jpg";
    private Float imageQuality;
    private String imageWriterClassname;

    private void setFrameNumber(int frame) {
        this.frame = frame;
    }

    private void setWindowCenter(float center) {
        this.center = center;        
    }
    
    private void setWindowWidth(float width) {
        this.width = width;       
    }

    public final void setVoiLutFunction(String vlutFct) {
        this.vlutFct = vlutFct;
    }    

    private final void setAutoWindowing(boolean autoWindowing) {
        this.autoWindowing = autoWindowing;
    }

    private final void setPresentationState(DicomObject prState) {
        this.prState = prState;        
    }
    
    private final void setPValue2Gray(short[] pval2gray) {
        this.pval2gray = pval2gray;
    }
    
    public final void setFileExt(String fileExt) {
        this.fileExt = fileExt;
    }
    
    private void setImageWriter (String imagewriter) {
    	this.imageWriterClassname = imagewriter;
    }
    
    public void setFormatName(String formatName) {
        this.formatName = formatName;
    }

    public void setImageQuality (int quality) {
    	this.imageQuality = new Float(quality / 100f);
    }
    
    private ImageWriter getImageWriter(String imageWriterClass) throws IIOException {
        ImageWriter writer;
        for (Iterator<ImageWriter> it = ImageIO.getImageWritersByFormatName(formatName) ; it.hasNext() ;) {
            writer = it.next();
            if ("*".equals(imageWriterClass)
                    ||writer.getClass().getName().equals(imageWriterClass)) {
                return writer;
            }
        }
        throw new IIOException("No such ImageWriter - " + imageWriterClass);
    }
    
    public void setCompressionType(String compressionType) {
        this.compressionType = compressionType;
    }

    public void convert(File src, File dest) throws IOException {
        ImageReader reader = DicomUtils.getDCM4CHE2DicomImageReader();
        DicomImageReadParam param = 
            (DicomImageReadParam) reader.getDefaultReadParam();
        param.setWindowCenter(center);
        param.setWindowWidth(width);
        param.setVoiLutFunction(vlutFct);
        param.setPresentationState(prState);
        param.setPValue2Gray(pval2gray);
        param.setAutoWindowing(autoWindowing);
        ImageInputStream iis = ImageIO.createImageInputStream(src);
        BufferedImage bi;  
        try {
            reader.setInput(iis, false);
            bi = reader.read(frame - 1, param);
            if (bi == null) {
                Debug.println("\nError: " + src + " - couldn't read!");
                return;
            }
            if (imageWriterClassname == null) {
                encodeByJPEGEncoder(bi, dest);
            } else {
                encodeByImageIO(bi, dest);
            }
        } finally {
            CloseUtils.safeClose(iis);
        }
    }
    
    public void convert(File src, ServletOutputStream dest) throws Exception {
        ImageReader reader = DicomUtils.getDCM4CHE2DicomImageReader();
        DicomImageReadParam param = 
            (DicomImageReadParam) reader.getDefaultReadParam();
        param.setWindowCenter(center);
        param.setWindowWidth(width);
        param.setVoiLutFunction(vlutFct);
        param.setPresentationState(prState);
        param.setPValue2Gray(pval2gray);
        param.setAutoWindowing(autoWindowing);
        ImageInputStream iis = ImageIO.createImageInputStream(src);
        BufferedImage bi;  
        try {
            reader.setInput(iis, false);
            bi = reader.read(frame - 1, param);
            if (bi == null) {
                Debug.println("\nError: " + src + " - couldn't read!");
                return;
            }
            if (imageWriterClassname == null) {
                encodeByJPEGEncoder(bi, dest);
            } else {
                encodeByImageIO(bi, dest);
            }
        }
        catch(Exception e){
        	e.printStackTrace();
        } finally {
            CloseUtils.safeClose(iis);
        }
    }
    

    public void convert(File src, ServletOutputStream dest, HttpSession session) throws IOException {
        ImageReader reader = DicomUtils.getDCM4CHE2DicomImageReader();
        DicomImageReadParam param = 
            (DicomImageReadParam) reader.getDefaultReadParam();
        param.setWindowCenter(center);
        param.setWindowWidth(width);
        param.setVoiLutFunction(vlutFct);
        param.setPresentationState(prState);
        param.setPValue2Gray(pval2gray);
        param.setAutoWindowing(autoWindowing);
        ImageInputStream iis = ImageIO.createImageInputStream(src);
        BufferedImage bi;  
        try {
            reader.setInput(iis, false);
            bi = reader.read(frame - 1, param);
            if (bi == null) {
                Debug.println("\nError: " + src + " - couldn't read!");
                return;
            }
            if (imageWriterClassname == null) {
                encodeByJPEGEncoder(bi, dest);
            } else {
                encodeByImageIO(bi, dest);
            }
        }
        catch(Exception e){
        	e.printStackTrace();
        } finally {
            CloseUtils.safeClose(iis);
        }
    }
    
    public void convert(File src, ServletOutputStream dest, ImageReader reader) throws IOException {
        DicomImageReadParam param = 
            (DicomImageReadParam) reader.getDefaultReadParam();
        param.setWindowCenter(center);
        param.setWindowWidth(width);
        param.setVoiLutFunction(vlutFct);
        param.setPresentationState(prState);
        param.setPValue2Gray(pval2gray);
        param.setAutoWindowing(autoWindowing);
        ImageInputStream iis = ImageIO.createImageInputStream(src);
        BufferedImage bi;  
        try {
            reader.setInput(iis, false);
            bi = reader.read(frame - 1, param);
            if (bi == null) {
                Debug.println("\nError: " + src + " - couldn't read!");
                return;
            }
            if (imageWriterClassname == null) {
                encodeByJPEGEncoder(bi, dest);
            } else {
                encodeByImageIO(bi, dest);
            }
            dest.flush();
        }
        catch(Exception e){
        	e.printStackTrace();
        } finally {
            CloseUtils.safeClose(iis);
        }
    }
    
    private void writeJpeg(BufferedImage bi,ImageOutputStream ios) throws IOException {
    	ImageWriter jpgWriter = ImageIO.getImageWritersByFormatName("jpg").next();
    	ImageWriteParam jpgWriteParam = jpgWriter.getDefaultWriteParam();
    	jpgWriteParam.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
    	jpgWriteParam.setCompressionQuality(Float.parseFloat(SH.cs("PACSThumbnailCompression", "0.1f")));
    	jpgWriter.setOutput(ios);
    	IIOImage outputImage = new IIOImage(bi, null, null);
    	jpgWriter.write(null, outputImage, jpgWriteParam);
    	jpgWriter.dispose();
    }
    
    private void encodeByJPEGEncoder(BufferedImage bi, File dest) throws ImageFormatException, IOException {
    	FileImageOutputStream out = null;
        try {
            out = new FileImageOutputStream(dest);
            writeJpeg(bi,out);
        } finally {
            CloseUtils.safeClose(out);
        }
    }

    private void encodeByJPEGEncoder(BufferedImage bi, ServletOutputStream dest) {
        try {
        	ImageOutputStream ios = ImageIO.createImageOutputStream(dest);
        	writeJpeg(bi,ios);
        	CloseUtils.safeClose(ios);
        } 
        catch(Exception e){
        	e.printStackTrace();
        };
    }
    
    private void encodeByImageIO(BufferedImage bi, File dest) throws IOException {
        ImageWriter writer = getImageWriter(imageWriterClassname);
        ImageOutputStream out = null;
        try {
            out = ImageIO.createImageOutputStream(dest);
            writer.setOutput(out);
            ImageWriteParam iwparam = writer.getDefaultWriteParam();
            if (iwparam.canWriteCompressed()) {
                iwparam.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
                String[] compressionTypes = iwparam.getCompressionTypes();
                if (compressionTypes != null && compressionTypes.length > 0) {
                    if (compressionType != null || iwparam.getCompressionType() == null) {
                        for (int i = 0; i < compressionTypes.length; i++) {
                            if (compressionType == null || compressionTypes[i].compareToIgnoreCase(compressionType) == 0) {
                                iwparam.setCompressionType(compressionTypes[i]);
                                break;
                            }
                        }
                    }
                }
                if (imageQuality != null)
                    iwparam.setCompressionQuality(imageQuality);
            } else if (imageQuality != null) {
                Debug.println("Selected Image Writer can not compress! imageQuality is ignored!");
            }
            writer.write(null, new IIOImage(bi, null, null), iwparam);
        } finally {
            CloseUtils.safeClose(out);
            writer.dispose();
        }
    }

    private void encodeByImageIO(BufferedImage bi, ServletOutputStream dest) throws IOException {
        ImageWriter writer = getImageWriter(imageWriterClassname);
        ImageOutputStream out = null;
        try {
            out = ImageIO.createImageOutputStream(dest);
            writer.setOutput(out);
            ImageWriteParam iwparam = writer.getDefaultWriteParam();
            if (iwparam.canWriteCompressed()) {
                iwparam.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
                String[] compressionTypes = iwparam.getCompressionTypes();
                if (compressionTypes != null && compressionTypes.length > 0) {
                    if (compressionType != null || iwparam.getCompressionType() == null) {
                        for (int i = 0; i < compressionTypes.length; i++) {
                            if (compressionType == null || compressionTypes[i].compareToIgnoreCase(compressionType) == 0) {
                                iwparam.setCompressionType(compressionTypes[i]);
                                break;
                            }
                        }
                    }
                }
                if (imageQuality != null)
                    iwparam.setCompressionQuality(imageQuality);
            } else if (imageQuality != null) {
                Debug.println("Selected Image Writer can not compress! imageQuality is ignored!");
            }
            writer.write(null, new IIOImage(bi, null, null), iwparam);
        } finally {
            CloseUtils.safeClose(out);
            writer.dispose();
        }
    }

    public int mconvert(List<String> args, int optind, File destDir)
            throws IOException {
        int count = 0;
        for (int i = optind, n = args.size() - 1; i < n; ++i) {
            File src = new File(args.get(i));
            count += mconvert(src, new File(destDir, src2dest(src)));
        }
        return count;
    }

    private String src2dest(File src) {
        String srcname = src.getName();
        return src.isFile() ? srcname + this.fileExt : srcname;
    }

    public int mconvert(File src, File dest) throws IOException {
        if (!src.exists()) {
            System.err.println("WARNING: No such file or directory: " + src
                    + " - skipped.");                
            return 0;
        }
        if (src.isFile()) {
            try {
                convert(src, dest);
            } catch (Exception e) {
                System.err.println("WARNING: Failed to convert " + src + ":");
                e.printStackTrace(System.err);
                return 0;
            }
            return 1;
        }
        File[] files = src.listFiles();
        if (files.length > 0 && !dest.exists()) {
            dest.mkdirs();
        }
        int count = 0;
        for (int i = 0; i < files.length; ++i) {
            count += mconvert(files[i], new File(dest, src2dest(files[i])));
        }
        return count;
    }

    @SuppressWarnings("unchecked")
    public static void main(String args[]) throws Exception {
        CommandLine cl = parse(args);
        Dcm2Jpg dcm2jpg = new Dcm2Jpg();
        if (cl.hasOption("f")) {
            dcm2jpg.setFrameNumber(
                    parseInt(cl.getOptionValue("f"),
                            "illegal argument of option -f",
                            1, Integer.MAX_VALUE));
        }
        if (cl.hasOption("p")) {
            dcm2jpg.setPresentationState(loadDicomObject(
                    new File(cl.getOptionValue("p"))));
        }
        if (cl.hasOption("pv2gray")) {
            dcm2jpg.setPValue2Gray(loadPVal2Gray(
                    new File(cl.getOptionValue("pv2gray"))));
        }        
        if (cl.hasOption("c")) {
            dcm2jpg.setWindowCenter(
                    parseFloat(cl.getOptionValue("c"),
                            "illegal argument of option -c"));
        }
        if (cl.hasOption("w")) {
            dcm2jpg.setWindowWidth(
                    parseFloat(cl.getOptionValue("w"),
                            "illegal argument of option -w"));
        }
        
        if (cl.hasOption("q")) {
            dcm2jpg.setImageQuality(
                    parseInt(cl.getOptionValue("q"),
                            "illegal argument of option -q", 0, 100));
        }
        
        if (cl.hasOption("F")) {
            String fn =cl.getOptionValue("F");
            dcm2jpg.setFormatName(fn.toUpperCase());
            dcm2jpg.setImageWriter("*");
            dcm2jpg.setFileExt("."+fn.toLowerCase());
            dcm2jpg.setCompressionType("JPEG".equalsIgnoreCase(fn) ? "jpeg" : null);
        }

        if (cl.hasOption("T")) {
            String type =cl.getOptionValue("T");
            dcm2jpg.setCompressionType("*".equals(type) ? null :type);
        }

        if (cl.hasOption("imagewriter")) {
            dcm2jpg.setImageWriter(cl.getOptionValue("imagewriter"));
        }
        
        if (cl.hasOption("sigmoid")) {
            dcm2jpg.setVoiLutFunction(DicomImageReadParam.SIGMOID);
        }
        dcm2jpg.setAutoWindowing(!cl.hasOption("noauto"));
        if (cl.hasOption("jpgext")) {
            dcm2jpg.setFileExt(cl.getOptionValue("jpgext"));
        }
        if (cl.hasOption("S")) {
            dcm2jpg.showFormatNames();
            return;
        }
        if (cl.hasOption("s")) {
            dcm2jpg.showImageWriters();
            return;
        }

        final List<String> argList = cl.getArgList();
        int argc = argList.size();

        File dest = new File(argList.get(argc-1));
        long t1 = System.currentTimeMillis();
        int count = 1;
        if (dest.isDirectory()) {
            count = dcm2jpg.mconvert(argList, 0, dest);
        } else {
            File src = new File(argList.get(0));
            if (argc > 2 || src.isDirectory()) {
                exit("dcm2jpg: when converting several files, "
                        + "last argument must be a directory\n");
            }
			if (!src.exists()){
				exit("Cannot find the file specified: " + argList.get(0));
			}
            dcm2jpg.convert(src, dest);
        }
        long t2 = System.currentTimeMillis();
        Debug.println("\nconverted " + count + " files in " + (t2 - t1)
                / 1000f + " s.");
    }

    private void showImageWriters() {
        ImageWriter writer;
        Debug.println("ImageWriters for format name:"+formatName);
        int i = 0;
        for (Iterator<ImageWriter> it = ImageIO.getImageWritersByFormatName(formatName) ; it.hasNext() ;) {
            writer = it.next();
            Debug.println("Writer["+(i++)+"]: "+writer.getClass().getName()+":");
            Debug.println("   Write Param:");
            ImageWriteParam param = writer.getDefaultWriteParam();
            Debug.println("       canWriteCompressed:"+param.canWriteCompressed());
            Debug.println("      canWriteProgressive:"+param.canWriteProgressive());
            Debug.println("            canWriteTiles:"+param.canWriteTiles());
            Debug.println("           canOffsetTiles:"+param.canOffsetTiles());
            if (param.canWriteCompressed()) {
                String[] types = param.getCompressionTypes();
                Debug.println("   Compression Types:");
                if (types != null && types.length > 0) {
                    for (int j = 0 ; j < types.length ; j++) {
                        Debug.println("           Type["+j+"]:"+types[j]);
                    }
                }
            }
            Debug.println("-----------------------------");
        }
    }
    
    private void showFormatNames() {
        Debug.println("List of supported Format Names of registered ImageWriters:");
        Iterator<ImageWriterSpi> writers = ServiceRegistry.lookupProviders(ImageWriterSpi.class);
        HashSet<String> allNames = new HashSet<String>();
        String[] names;
        for (; writers.hasNext() ;) {
            names = writers.next().getFormatNames();
            for (int i = 0 ; i < names.length ; i++) {
                allNames.add(names[i].toUpperCase());
            }
        }
        Debug.print("   Found "+allNames.size()+" format names: ");
        for (String n : allNames) {
            Debug.print("'"+n+"', ");
        }
    }

    private static DicomObject loadDicomObject(File file) {
        DicomInputStream in = null;
        try {
            in = new DicomInputStream(file);
            return in.readDicomObject();
        } catch (IOException e) {
            exit(e.getMessage());
            throw new RuntimeException();
        } finally {
            CloseUtils.safeClose(in);
        }
    }

    private static short[] loadPVal2Gray(File file) {
        BufferedReader r = null;
        try {
            r = new BufferedReader(new InputStreamReader(new FileInputStream(
                    file)));
            short[] pval2gray = new short[256];
            int n = 0;
            String line;
            while ((line = r.readLine()) != null) {
                try {
                    int val = Integer.parseInt(line.trim());
                    if (n == pval2gray.length) {
                        if (n == 0x10000) {
                            exit("Number of entries in " + file + " > 2^16");
                        }
                        short[] tmp = pval2gray;
                        pval2gray = new short[n << 1];
                        System.arraycopy(tmp, 0, pval2gray, 0, n);
                    }
                    pval2gray[n++] = (short) val;
                } catch (NumberFormatException nfe) {
                    // ignore lines where Integer.parseInt fails
                }
            }
            if (n != pval2gray.length) {
                exit("Number of entries in " + file + ": " + n
                        + " != 2^[8..16]");
            }
            return pval2gray;
        } catch (IOException e) {
            exit(e.getMessage());
            throw new RuntimeException();
        } finally {
            CloseUtils.safeClose(r);
        }
    }

    private static CommandLine parse(String[] args) {
        Options opts = new Options();
        OptionBuilder.withArgName("frame");
        OptionBuilder.hasArg();
        OptionBuilder.withDescription(
                "frame to convert, 1 (= first frame) by default");
        opts.addOption(OptionBuilder.create("f"));
        
        OptionBuilder.withArgName("imagequality");
        OptionBuilder.hasArg();
        OptionBuilder.withDescription(
                "JPEG Image Quality (0-100)");
        opts.addOption(OptionBuilder.create("q"));
        
        OptionBuilder.withArgName("ImageWriterClass");
        OptionBuilder.hasArg();
        OptionBuilder.withDescription(
                "ImageWriter to be used [Default: JPEGImageEncoder instead of imageIO]. Use * to choose the first ImageIO Writer found for given image format");
        opts.addOption(OptionBuilder.create("imagewriter"));
        opts.addOption("S", "showFormats", false, "Show all supported format names by registered ImageWriters.");
        opts.addOption("s", "showimagewriter", false, "Show all available Image Writer for specified format name.");

        OptionBuilder.withArgName("formatName");
        OptionBuilder.hasArg();
        OptionBuilder.withDescription(
                "Image Format Name. [default JPEG] This option will imply default values for ImageWriterClass='*' and jpgext='.<formatname>'");
        opts.addOption(OptionBuilder.create("F"));
        OptionBuilder.withArgName("compressionType");
        OptionBuilder.hasArg();
        OptionBuilder.withDescription(
                "Compression Type. [default: '*' (exception: jpeg for format JPEG)] Only applicable if an ImageWriterClass is used! Use * to choose the first compression type.");
        opts.addOption(OptionBuilder.create("T"));
        
        OptionBuilder.withArgName("prfile");
        OptionBuilder.hasArg();
        OptionBuilder.withDescription(
                "file path of presentation state to apply");
        opts.addOption(OptionBuilder.create("p"));
        OptionBuilder.withArgName("center");
        OptionBuilder.hasArg();
        OptionBuilder.withDescription("Window Center");
        opts.addOption(OptionBuilder.create("c"));
        OptionBuilder.withArgName("width");
        OptionBuilder.hasArg();
        OptionBuilder.withDescription("Window Width");
        opts.addOption(OptionBuilder.create("w"));
        opts.addOption("sigmoid", false,
                "apply sigmoid VOI LUT function with given Window Center/Width");
        opts.addOption("noauto", false,
                "disable auto-windowing for images w/o VOI attributes");
        OptionBuilder.withArgName("file");
        OptionBuilder.hasArg();
        OptionBuilder.withDescription(
                "file path of P-Value to gray value map");
        opts.addOption(OptionBuilder.create("pv2gray"));
        OptionBuilder.withArgName(".xxx");
        OptionBuilder.hasArg();
        OptionBuilder.withDescription(
                "jpeg file extension used with destination directory argument,"
                + " default: '.jpg'.");
        opts.addOption(OptionBuilder.create("jpgext"));
        opts.addOption("h", "help", false, "print this message");
        opts.addOption("V", "version", false,
                "print the version information and exit");
        CommandLine cl = null;
        try {
            cl = new GnuParser().parse(opts, args);
        } catch (ParseException e) {
            exit("dcm2jpg: " + e.getMessage());
            throw new RuntimeException("unreachable");
        }
        if (cl.hasOption('V')) {
            Package p = Dcm2Jpg.class.getPackage();
            Debug.println("dcm2jpg v" + p.getImplementationVersion());
            System.exit(0);
        }
        if (cl.hasOption('h') || !(cl.hasOption('s') || cl.hasOption('S')) && cl.getArgList().size() < 2) {
            HelpFormatter formatter = new HelpFormatter();
            formatter.printHelp(USAGE, DESCRIPTION, opts, EXAMPLE);
            System.exit(0);
        }
        return cl;
    }

    private static int parseInt(String s, String errPrompt, int min, int max) {
        try {
            int i = Integer.parseInt(s);
            if (i >= min && i <= max)
                return i;
        } catch (NumberFormatException e) {
            // parameter is not a valid integer; fall through to exit
        }
        exit(errPrompt);
        throw new RuntimeException();
    }

    private static float parseFloat(String s, String errPrompt) {
        try {
            return Float.parseFloat(s);
        } catch (NumberFormatException e) {
            exit(errPrompt);
            throw new RuntimeException();
        }
    }
       
    private static void exit(String msg) {
        System.err.println(msg);
        System.err.println("Try 'dcm2jpg -h' for more information.");
        System.exit(1);
    }

}