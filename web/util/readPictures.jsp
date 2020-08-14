<%@page import="java.awt.BufferCapabilities"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	Connection conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from openclinic.infra3");
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		String url = checkString(rs.getString("view_north"));
		if(url.length()>0){
			try{
				int documentid = MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS");
				java.awt.image.BufferedImage image = ImageIO.read(new URL(url));
				ImageIO.write(image, "jpg", new java.io.File("c:/temp/gmao/"+documentid+".jpg"));
				//The file was retrieved, store it to arch_documents
				PreparedStatement ps2 = conn.prepareStatement("insert into arch_documents(arch_document_serverid,arch_document_objectid,arch_document_UDI,arch_document_title,arch_document_category,arch_document_date,arch_document_reference,arch_document_storagename,arch_document_updatetime,arch_document_updateid) values(?,?,?,?,?,?,?,?,?,?)");
				ps2.setInt(1,1);
				ps2.setInt(2,documentid);
				ps2.setString(3,"1."+documentid);
				ps2.setString(4,"Vue Nord de la structure");
				ps2.setString(5,"asset");
				ps2.setDate(6, new java.sql.Date(new java.util.Date().getTime()));
				String assetid=rs.getString("id");
				ps2.setString(7,"asset.1."+assetid);
				ps2.setString(8,"0/"+documentid+".jpg");
				ps2.setTimestamp(9, new java.sql.Timestamp(new java.util.Date().getTime()));
				ps2.setString(10,"4");
				ps2.execute();
				ps2.close();
				System.out.println("Image successfully stored to "+documentid+".jpg");
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		url = checkString(rs.getString("view_est"));
		if(url.length()>0){
			try{
				int documentid = MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS");
				java.awt.image.BufferedImage image = ImageIO.read(new URL(url));
				ImageIO.write(image, "jpg", new java.io.File("c:/temp/gmao/"+documentid+".jpg"));
				//The file was retrieved, store it to arch_documents
				PreparedStatement ps2 = conn.prepareStatement("insert into arch_documents(arch_document_serverid,arch_document_objectid,arch_document_UDI,arch_document_title,arch_document_category,arch_document_date,arch_document_reference,arch_document_storagename,arch_document_updatetime,arch_document_updateid) values(?,?,?,?,?,?,?,?,?,?)");
				ps2.setInt(1,1);
				ps2.setInt(2,documentid);
				ps2.setString(3,"1."+documentid);
				ps2.setString(4,"Vue Est de la structure");
				ps2.setString(5,"asset");
				ps2.setDate(6, new java.sql.Date(new java.util.Date().getTime()));
				String assetid=rs.getString("id");
				ps2.setString(7,"asset.1."+assetid);
				ps2.setString(8,"0/"+documentid+".jpg");
				ps2.setTimestamp(9, new java.sql.Timestamp(new java.util.Date().getTime()));
				ps2.setString(10,"4");
				ps2.execute();
				ps2.close();
				System.out.println("Image successfully stored to "+documentid+".jpg");
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		url = checkString(rs.getString("view_west"));
		if(url.length()>0){
			try{
				int documentid = MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS");
				java.awt.image.BufferedImage image = ImageIO.read(new URL(url));
				ImageIO.write(image, "jpg", new java.io.File("c:/temp/gmao/"+documentid+".jpg"));
				//The file was retrieved, store it to arch_documents
				PreparedStatement ps2 = conn.prepareStatement("insert into arch_documents(arch_document_serverid,arch_document_objectid,arch_document_UDI,arch_document_title,arch_document_category,arch_document_date,arch_document_reference,arch_document_storagename,arch_document_updatetime,arch_document_updateid) values(?,?,?,?,?,?,?,?,?,?)");
				ps2.setInt(1,1);
				ps2.setInt(2,documentid);
				ps2.setString(3,"1."+documentid);
				ps2.setString(4,"Vue Oeust de la structure");
				ps2.setString(5,"asset");
				ps2.setDate(6, new java.sql.Date(new java.util.Date().getTime()));
				String assetid=rs.getString("id");
				ps2.setString(7,"asset.1."+assetid);
				ps2.setString(8,"0/"+documentid+".jpg");
				ps2.setTimestamp(9, new java.sql.Timestamp(new java.util.Date().getTime()));
				ps2.setString(10,"4");
				ps2.execute();
				ps2.close();
				System.out.println("Image successfully stored to "+documentid+".jpg");
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		url = checkString(rs.getString("degradations"));
		if(url.length()>0){
			try{
				int documentid = MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS");
				java.awt.image.BufferedImage image = ImageIO.read(new URL(url));
				ImageIO.write(image, "jpg", new java.io.File("c:/temp/gmao/"+documentid+".jpg"));
				//The file was retrieved, store it to arch_documents
				PreparedStatement ps2 = conn.prepareStatement("insert into arch_documents(arch_document_serverid,arch_document_objectid,arch_document_UDI,arch_document_title,arch_document_category,arch_document_date,arch_document_reference,arch_document_storagename,arch_document_updatetime,arch_document_updateid) values(?,?,?,?,?,?,?,?,?,?)");
				ps2.setInt(1,1);
				ps2.setInt(2,documentid);
				ps2.setString(3,"1."+documentid);
				ps2.setString(4,"Dégradations apparentes");
				ps2.setString(5,"asset");
				ps2.setDate(6, new java.sql.Date(new java.util.Date().getTime()));
				String assetid=rs.getString("id");
				ps2.setString(7,"asset.1."+assetid);
				ps2.setString(8,"0/"+documentid+".jpg");
				ps2.setTimestamp(9, new java.sql.Timestamp(new java.util.Date().getTime()));
				ps2.setString(10,"4");
				ps2.execute();
				ps2.close();
				System.out.println("Image successfully stored to "+documentid+".jpg");
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		url = checkString(rs.getString("degradations2"));
		if(url.length()>0){
			try{
				int documentid = MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS");
				java.awt.image.BufferedImage image = ImageIO.read(new URL(url));
				ImageIO.write(image, "jpg", new java.io.File("c:/temp/gmao/"+documentid+".jpg"));
				//The file was retrieved, store it to arch_documents
				PreparedStatement ps2 = conn.prepareStatement("insert into arch_documents(arch_document_serverid,arch_document_objectid,arch_document_UDI,arch_document_title,arch_document_category,arch_document_date,arch_document_reference,arch_document_storagename,arch_document_updatetime,arch_document_updateid) values(?,?,?,?,?,?,?,?,?,?)");
				ps2.setInt(1,1);
				ps2.setInt(2,documentid);
				ps2.setString(3,"1."+documentid);
				ps2.setString(4,"Dégradations apparentes");
				ps2.setString(5,"asset");
				ps2.setDate(6, new java.sql.Date(new java.util.Date().getTime()));
				String assetid=rs.getString("id");
				ps2.setString(7,"asset.1."+assetid);
				ps2.setString(8,"0/"+documentid+".jpg");
				ps2.setTimestamp(9, new java.sql.Timestamp(new java.util.Date().getTime()));
				ps2.setString(10,"4");
				ps2.execute();
				ps2.close();
				System.out.println("Image successfully stored to "+documentid+".jpg");
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		url = checkString(rs.getString("degradations3"));
		if(url.length()>0){
			try{
				int documentid = MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS");
				java.awt.image.BufferedImage image = ImageIO.read(new URL(url));
				ImageIO.write(image, "jpg", new java.io.File("c:/temp/gmao/"+documentid+".jpg"));
				//The file was retrieved, store it to arch_documents
				PreparedStatement ps2 = conn.prepareStatement("insert into arch_documents(arch_document_serverid,arch_document_objectid,arch_document_UDI,arch_document_title,arch_document_category,arch_document_date,arch_document_reference,arch_document_storagename,arch_document_updatetime,arch_document_updateid) values(?,?,?,?,?,?,?,?,?,?)");
				ps2.setInt(1,1);
				ps2.setInt(2,documentid);
				ps2.setString(3,"1."+documentid);
				ps2.setString(4,"Dégradations apparentes");
				ps2.setString(5,"asset");
				ps2.setDate(6, new java.sql.Date(new java.util.Date().getTime()));
				String assetid=rs.getString("id");
				ps2.setString(7,"asset.1."+assetid);
				ps2.setString(8,"0/"+documentid+".jpg");
				ps2.setTimestamp(9, new java.sql.Timestamp(new java.util.Date().getTime()));
				ps2.setString(10,"4");
				ps2.execute();
				ps2.close();
				System.out.println("Image successfully stored to "+documentid+".jpg");
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		url = checkString(rs.getString("degradations4"));
		if(url.length()>0){
			try{
				int documentid = MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS");
				java.awt.image.BufferedImage image = ImageIO.read(new URL(url));
				ImageIO.write(image, "jpg", new java.io.File("c:/temp/gmao/"+documentid+".jpg"));
				//The file was retrieved, store it to arch_documents
				PreparedStatement ps2 = conn.prepareStatement("insert into arch_documents(arch_document_serverid,arch_document_objectid,arch_document_UDI,arch_document_title,arch_document_category,arch_document_date,arch_document_reference,arch_document_storagename,arch_document_updatetime,arch_document_updateid) values(?,?,?,?,?,?,?,?,?,?)");
				ps2.setInt(1,1);
				ps2.setInt(2,documentid);
				ps2.setString(3,"1."+documentid);
				ps2.setString(4,"Dégradations apparentes");
				ps2.setString(5,"asset");
				ps2.setDate(6, new java.sql.Date(new java.util.Date().getTime()));
				String assetid=rs.getString("id");
				ps2.setString(7,"asset.1."+assetid);
				ps2.setString(8,"0/"+documentid+".jpg");
				ps2.setTimestamp(9, new java.sql.Timestamp(new java.util.Date().getTime()));
				ps2.setString(10,"4");
				ps2.execute();
				ps2.close();
				System.out.println("Image successfully stored to "+documentid+".jpg");
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		url = checkString(rs.getString("degradations5"));
		if(url.length()>0){
			try{
				int documentid = MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS");
				java.awt.image.BufferedImage image = ImageIO.read(new URL(url));
				ImageIO.write(image, "jpg", new java.io.File("c:/temp/gmao/"+documentid+".jpg"));
				//The file was retrieved, store it to arch_documents
				PreparedStatement ps2 = conn.prepareStatement("insert into arch_documents(arch_document_serverid,arch_document_objectid,arch_document_UDI,arch_document_title,arch_document_category,arch_document_date,arch_document_reference,arch_document_storagename,arch_document_updatetime,arch_document_updateid) values(?,?,?,?,?,?,?,?,?,?)");
				ps2.setInt(1,1);
				ps2.setInt(2,documentid);
				ps2.setString(3,"1."+documentid);
				ps2.setString(4,"Dégradations apparentes");
				ps2.setString(5,"asset");
				ps2.setDate(6, new java.sql.Date(new java.util.Date().getTime()));
				String assetid=rs.getString("id");
				ps2.setString(7,"asset.1."+assetid);
				ps2.setString(8,"0/"+documentid+".jpg");
				ps2.setTimestamp(9, new java.sql.Timestamp(new java.util.Date().getTime()));
				ps2.setString(10,"4");
				ps2.execute();
				ps2.close();
				System.out.println("Image successfully stored to "+documentid+".jpg");
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		url = checkString(rs.getString("fence_view"));
		if(url.length()>0){
			try{
				int documentid = MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS");
				java.awt.image.BufferedImage image = ImageIO.read(new URL(url));
				ImageIO.write(image, "jpg", new java.io.File("c:/temp/gmao/"+documentid+".jpg"));
				//The file was retrieved, store it to arch_documents
				PreparedStatement ps2 = conn.prepareStatement("insert into arch_documents(arch_document_serverid,arch_document_objectid,arch_document_UDI,arch_document_title,arch_document_category,arch_document_date,arch_document_reference,arch_document_storagename,arch_document_updatetime,arch_document_updateid) values(?,?,?,?,?,?,?,?,?,?)");
				ps2.setInt(1,1);
				ps2.setInt(2,documentid);
				ps2.setString(3,"1."+documentid);
				ps2.setString(4,"Vue de la cloture");
				ps2.setString(5,"asset");
				ps2.setDate(6, new java.sql.Date(new java.util.Date().getTime()));
				String assetid=rs.getString("id");
				ps2.setString(7,"asset.1."+assetid);
				ps2.setString(8,"0/"+documentid+".jpg");
				ps2.setTimestamp(9, new java.sql.Timestamp(new java.util.Date().getTime()));
				ps2.setString(10,"4");
				ps2.execute();
				ps2.close();
				System.out.println("Image successfully stored to "+documentid+".jpg");
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		url = checkString(rs.getString("exterior_view"));
		if(url.length()>0){
			try{
				int documentid = MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS");
				java.awt.image.BufferedImage image = ImageIO.read(new URL(url));
				ImageIO.write(image, "jpg", new java.io.File("c:/temp/gmao/"+documentid+".jpg"));
				//The file was retrieved, store it to arch_documents
				PreparedStatement ps2 = conn.prepareStatement("insert into arch_documents(arch_document_serverid,arch_document_objectid,arch_document_UDI,arch_document_title,arch_document_category,arch_document_date,arch_document_reference,arch_document_storagename,arch_document_updatetime,arch_document_updateid) values(?,?,?,?,?,?,?,?,?,?)");
				ps2.setInt(1,1);
				ps2.setInt(2,documentid);
				ps2.setString(3,"1."+documentid);
				ps2.setString(4,"Vue des aménagements extérieurs");
				ps2.setString(5,"asset");
				ps2.setDate(6, new java.sql.Date(new java.util.Date().getTime()));
				String assetid=rs.getString("id");
				ps2.setString(7,"asset.1."+assetid);
				ps2.setString(8,"0/"+documentid+".jpg");
				ps2.setTimestamp(9, new java.sql.Timestamp(new java.util.Date().getTime()));
				ps2.setString(10,"4");
				ps2.execute();
				ps2.close();
				System.out.println("Image successfully stored to "+documentid+".jpg");
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
	}
	rs.close();
	ps.close();
	conn.close();
%>