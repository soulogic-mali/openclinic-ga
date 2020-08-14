package be.mxs.common.util.io;// Blob Finder Demo
// A.Greensted
// http://www.labbookpages.co.uk
// Please use however you like. I'd be happy to hear any feedback or comments.

import java.io.*;
import java.util.*;
import java.awt.*;
import java.awt.image.*;
import javax.swing.*;

public class BlobDemo
{
	public static Coordinates getBlobZones(String filename)
	{
		// Load Source image
		BufferedImage srcImage = null;

		try
		{
			File imgFile = new File(filename);
			srcImage = javax.imageio.ImageIO.read(imgFile);
		}
		catch (IOException ioE)
		{
			System.err.println(ioE);
			return null;
		}

		return getBlobZones(srcImage);
	}
	public static class Coordinates{
		public long x=0,y=0;
	}
	public static Coordinates getBlobZones(BufferedImage srcImage)
	{
		int width = srcImage.getWidth();
		int height = srcImage.getHeight();

		// Get raw image data
		Raster raster = srcImage.getData();
		DataBuffer buffer = raster.getDataBuffer();

		int type = buffer.getDataType();
		if (type != DataBuffer.TYPE_BYTE)
		{
			System.err.println("Wrong image data type (datatype="+buffer.getDataType()+")");
			return null;
		}
		if (buffer.getNumBanks() != 1)
		{
			System.err.println("Wrong image data type (numbanks="+buffer.getNumBanks()+")");
			return null;
		}

		DataBufferByte byteBuffer = (DataBufferByte) buffer;
		byte[] srcData = byteBuffer.getData(0);

		// Sanity check image
		if (width * height * 3 != srcData.length) {
			System.err.println("Unexpected image data size. Should be RGB image");
			return null;
		}

		// Output Image info
		System.out.printf("Loaded image: width: %d, height: %d, num bytes: %d\n", width, height, srcData.length);

		// Create Monochrome version - using basic threshold technique
		byte[] monoData = new byte[width * height];
		int srcPtr = 0;
		int monoPtr = 0;

		while (srcPtr < srcData.length)
		{
			int val = ((srcData[srcPtr]&0xFF) + (srcData[srcPtr+1]&0xFF) + (srcData[srcPtr+2]&0xFF)) / 3;
			monoData[monoPtr] = (val > 128) ? (byte) 0xFF : 0;

			srcPtr += 3;
			monoPtr += 1;
		}

		byte[] dstData = new byte[srcData.length];

		// Create Blob Finder
		BlobFinder finder = new BlobFinder(width, height);

		ArrayList<BlobFinder.Blob> blobList = new ArrayList<BlobFinder.Blob>();
		finder.detectBlobs(monoData, dstData, 0, -1, (byte)0, blobList);
		Coordinates coordinates = new Coordinates();
		// List Blobs
		System.out.printf("Found %d blobs:\n", blobList.size());
		long mass=0;
		for (BlobFinder.Blob blob : blobList) {
			mass+=blob.mass;
			coordinates.x+=(blob.xMin+blob.xMax)*blob.mass/2;
			coordinates.y+=(blob.yMin+blob.yMax)*blob.mass/2;
		}
		coordinates.x=coordinates.x/mass;
		coordinates.y=coordinates.y/mass;
		System.out.println("x="+coordinates.x+"   /   y="+coordinates.y);
		return coordinates;
	}
	
}