<%@page import="be.mxs.common.util.system.Miscelaneous"%>
<%@include file="/includes/helper.jsp"%>
<%@page import="be.openclinic.medical.*"%>
<%@page import="java.util.*,java.text.*,java.io.*,com.itextpdf.text.*,com.itextpdf.text.pdf.*"%>
<%!
	PdfPCell getHeaderCell(String s, int colspan){
		PdfPCell cell = new PdfPCell(new Paragraph(s, FontFactory.getFont(FontFactory.HELVETICA,8,Font.BOLD)));
	    cell.setColspan(colspan);
	    cell.setBorder(PdfPCell.NO_BORDER);
	    cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
	    //cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
	    return cell;
	}
	PdfPCell getTitleCell(String s, int colspan){
		PdfPCell cell = new PdfPCell(new Paragraph(s, FontFactory.getFont(FontFactory.HELVETICA,8,Font.NORMAL)));
	    cell.setColspan(colspan);
	    cell.setBorder(PdfPCell.BOX);
	    cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
	    cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
	    return cell;
	}
	PdfPCell getTitleCellCentered(String s, int colspan){
		PdfPCell cell = new PdfPCell(new Paragraph(s, FontFactory.getFont(FontFactory.HELVETICA,8,Font.NORMAL)));
	    cell.setColspan(colspan);
	    cell.setBorder(PdfPCell.BOX);
	    cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
	    cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
	    cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
	    return cell;
	}
	PdfPCell getValueCell(String s, int colspan){
		PdfPCell cell = new PdfPCell(new Paragraph(s, FontFactory.getFont(FontFactory.HELVETICA,8,Font.NORMAL)));
	    cell.setColspan(colspan);
	    cell.setBorder(PdfPCell.BOX);
	    cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
	    return cell;
	}
	PdfPCell getValueCellCentered(String s, int colspan){
		PdfPCell cell = new PdfPCell(new Paragraph(s, FontFactory.getFont(FontFactory.HELVETICA,8,Font.NORMAL)));
	    cell.setColspan(colspan);
	    cell.setBorder(PdfPCell.BOX);
	    cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
	    cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
	    return cell;
	}
	PdfPCell getValueCellBold(String s, int colspan){
		PdfPCell cell = new PdfPCell(new Paragraph(s, FontFactory.getFont(FontFactory.HELVETICA,8,Font.BOLD)));
	    cell.setColspan(colspan);
	    cell.setBorder(PdfPCell.BOX);
	    cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
	    return cell;
	}
	PdfPCell getValueCellCenteredBold(String s, int colspan){
		PdfPCell cell = new PdfPCell(new Paragraph(s, FontFactory.getFont(FontFactory.HELVETICA,8,Font.BOLD)));
	    cell.setColspan(colspan);
	    cell.setBorder(PdfPCell.BOX);
	    cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
	    cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
	    return cell;
	}
	int[] increaseAgeValue(int age, int[] nArray){
		nArray[8]++;
		if(age<20) nArray[0]++;
		else if(age<25) nArray[1]++;
		else if(age<30) nArray[2]++;
		else if(age<35) nArray[3]++;
		else if(age<40) nArray[4]++;
		else if(age<45) nArray[5]++;
		else if(age<50) nArray[6]++;
		else nArray[7]++;
		return nArray;
	}
	String getPercent(int counter,int denominator){
		return new java.text.DecimalFormat("#0.#").format(new Double(counter)*100/new Double(denominator));
	}
%>
<%
	//Get blood donations
	Vector<BloodGift> bloodgifts = BloodGift.find(request.getParameter("begin"), request.getParameter("end"), SH.c(request.getParameter("cntssite")));
	//Prepare PDF document
	com.itextpdf.text.Document doc = new com.itextpdf.text.Document();
	ByteArrayOutputStream baosPDF = new ByteArrayOutputStream();
	PdfWriter docWriter = PdfWriter.getInstance(doc,baosPDF);	
    doc.addProducer();
    doc.addAuthor("OpenClinic Bloodbank Edition");
	doc.addCreationDate();
	doc.addCreator("OpenClinic Software");
    Rectangle rectangle=null;
    doc.setPageSize(PageSize.A4);
    doc.setMargins(10,10,10,10);
    doc.open();
    
    if(bloodgifts.size()==0){
		String title="Aucun don de sang enregistré dans la période choisie\n\n";
		PdfPTable table = new PdfPTable(100);
		table.addCell(getHeaderCell(title,100));	
    	doc.add(table);
    }
    else{
    	String sProject = checkString((String)session.getAttribute("activeProjectTitle")).toLowerCase();
		PdfPTable table = new PdfPTable(100);
		//TODO: Write header to document
        try{
            Image img = Miscelaneous.getImage("logo_"+sProject+".gif",sProject);
            img.scaleToFit(75, 75);
            PdfPCell cell = new PdfPCell(img);
            cell.setBorder(PdfPCell.NO_BORDER);
            cell.setColspan(25);
            table.addCell(cell);
        }
        catch(Exception e){
            Debug.println("WARNING : PDFPatientInvoiceGenerator --> IMAGE NOT FOUND : logo_"+sProject+".gif");
            e.printStackTrace();
            PdfPCell cell = new PdfPCell();
            cell.setBorder(PdfPCell.NO_BORDER);
            cell.setColspan(25);
            table.addCell(cell);
        }
		table.addCell(getHeaderCell("RAPPORT D'ACTIVITES POUR LA PERIODE DU "+request.getParameter("begin")+" AU "+request.getParameter("end")+"\n"+
        						   "CNTS/CRTS: "+getTranNoLink("cnts.sites",SH.c(request.getParameter("cntssite")),"fr"),75));
		table.addCell(getHeaderCell("\n\n", 100));
		
		//Write tables to document
		String title="TABLEAU I: REPARTITION DES SEANCES DE COLLECTE SELON LES MILIEUX\n\n";
		table.addCell(getHeaderCell(title,100));	
		table.addCell(getTitleCell("MILIEUX", 40));
		table.addCell(getTitleCellCentered("NOMBRE", 30));
		table.addCell(getTitleCellCentered("POURCENTAGE", 30));
		int nScolaire=0,nPolice=0,nCommunautaire=0,nConfessionnel=0,nSociete=0,nAutre=0;
		for(int n=0;n<bloodgifts.size();n++){
			BloodGift gift = bloodgifts.elementAt(n);
			if(SH.c(gift.getEnvironment()).equalsIgnoreCase("1")) nScolaire++;
			else if(SH.c(gift.getEnvironment()).equalsIgnoreCase("1")) nScolaire++;
			else if(SH.c(gift.getEnvironment()).equalsIgnoreCase("2")) nPolice++;
			else if(SH.c(gift.getEnvironment()).equalsIgnoreCase("3")) nCommunautaire++;
			else if(SH.c(gift.getEnvironment()).equalsIgnoreCase("4")) nConfessionnel++;
			else if(SH.c(gift.getEnvironment()).equalsIgnoreCase("5")) nSociete++;
			else nAutre++;
		}
		table.addCell(getValueCell("Scolaire", 40));
		table.addCell(getValueCellCentered(nScolaire+"", 30));
		table.addCell(getValueCellCentered(getPercent(nScolaire,bloodgifts.size())+"%",30));
		table.addCell(getValueCell("Police et miliatires", 40));
		table.addCell(getValueCellCentered(nPolice+"", 30));
		table.addCell(getValueCellCentered(getPercent(nPolice,bloodgifts.size())+"%",30));
		table.addCell(getValueCell("Milieux communautaires", 40));
		table.addCell(getValueCellCentered(nCommunautaire+"", 30));
		table.addCell(getValueCellCentered(getPercent(nCommunautaire,bloodgifts.size())+"%",30));
		table.addCell(getValueCell("Confessions réligieuses", 40));
		table.addCell(getValueCellCentered(nConfessionnel+"", 30));
		table.addCell(getValueCellCentered(getPercent(nConfessionnel,bloodgifts.size())+"%",30));
		table.addCell(getValueCell("Sociétés/institutions", 40));
		table.addCell(getValueCellCentered(nSociete+"", 30));
		table.addCell(getValueCellCentered(getPercent(nSociete,bloodgifts.size())+"%",30));
		table.addCell(getValueCell("Autres/non spécifié", 40));
		table.addCell(getValueCellCentered(nAutre+"", 30));
		table.addCell(getValueCellCentered(getPercent(nAutre,bloodgifts.size())+"%",30));
		table.addCell(getValueCellBold("Total", 40));
		table.addCell(getValueCellCenteredBold(bloodgifts.size()+"", 30));
		table.addCell(getValueCellCenteredBold("100%",30));
		doc.add(table);
		
		title="\nTABLEAU III: REPARTITION DES SITES DE COLLECTE\n\n";
		SortedMap<String,Integer> sites = new TreeMap();
		table = new PdfPTable(100);
		table.addCell(getHeaderCell(title,100));	
		table.addCell(getTitleCell("SITES", 40));
		table.addCell(getTitleCellCentered("NOMBRE", 30));
		table.addCell(getTitleCellCentered("POURCENTAGE", 30));
		for(int n=0;n<bloodgifts.size();n++){
			BloodGift gift = bloodgifts.elementAt(n);
			String site = gift.getCollectionLocation().toUpperCase()+" - "+SH.getTranNoLink("service",SH.c(gift.getCollectionLocation()),"fr");
			if(site.equalsIgnoreCase(" - ")){
				site="Non spécifié";
			}
			if(sites.get(site)==null){
				sites.put(site,1);
			}
			else{
				sites.put(site,sites.get(site)+1);
			}
		}
		Iterator iSites = sites.keySet().iterator();
		while(iSites.hasNext()){
			String sSite=(String)iSites.next();
			table.addCell(getValueCell(sSite, 40));
			table.addCell(getValueCellCentered(sites.get(sSite)+"", 30));
			table.addCell(getValueCellCentered(getPercent(sites.get(sSite),bloodgifts.size())+"%",30));
		}
		table.addCell(getValueCellBold("Total", 40));
		table.addCell(getValueCellCenteredBold(bloodgifts.size()+"", 30));
		table.addCell(getValueCellCenteredBold("100%",30));
		doc.add(table);
	
		title="\nTABLEAU IV: QUANTITE DE POCHES\n\n";
		table = new PdfPTable(100);
		table.addCell(getHeaderCell(title,100));	
		table.addCell(getTitleCell("POCHES", 40));
		table.addCell(getTitleCellCentered("NOMBRE", 60));
		int nCollecte=0,nTeste=0,nDistribue=0;
		for(int n=0;n<bloodgifts.size();n++){
			BloodGift gift = bloodgifts.elementAt(n);
			nCollecte+=gift.getCollected();
			nTeste+=gift.getTested();
			nDistribue+=gift.getDistributed();
		}	
		table.addCell(getValueCell("Collectées", 40));
		table.addCell(getValueCellCentered(nCollecte+"", 60));
		table.addCell(getValueCell("Testées", 40));
		table.addCell(getValueCellCentered(nTeste+"", 60));
		table.addCell(getValueCell("Distribuées", 40));
		table.addCell(getValueCellCentered(nDistribue+"", 60));
		doc.add(table);
		
		title="\nTABLEAU V: ENGAGEMENT FINANCIER\n\n";
		table = new PdfPTable(100);
		table.addCell(getHeaderCell(title,100));	
		PdfPCell cell = getTitleCell("LIBELLE", 40);
		cell.setRowspan(2);
		table.addCell(cell);
		table.addCell(getTitleCellCentered("PROVENANCE DU MONTANT", 40));
		cell = getTitleCellCentered("TOTAL", 20);
		cell.setRowspan(2);
		table.addCell(cell);
		table.addCell(getTitleCellCentered("CNTS", 20));
		table.addCell(getTitleCellCentered("PTFs", 20));
		double nMission=0,nCollation=0,nFuel=0,nMissionDonor=0,nCollationDonor=0,nFuelDonor=0,nTotal=0,nTotalDonor=0;
		for(int n=0;n<bloodgifts.size();n++){
			BloodGift gift = bloodgifts.elementAt(n);
			nMission+=gift.getMissioncost().getCnts();
			nMissionDonor+=gift.getMissioncost().getDonor();
			nCollation+=gift.getCollationcost().getCnts();
			nCollationDonor+=gift.getCollationcost().getDonor();
			nFuel+=gift.getFuelcost().getCnts();
			nFuelDonor+=gift.getFuelcost().getDonor();
			nTotal+=(gift.getMissioncost().getCnts()+gift.getCollationcost().getCnts()+gift.getFuelcost().getCnts());
			nTotalDonor+=(gift.getMissioncost().getDonor()+gift.getCollationcost().getDonor()+gift.getFuelcost().getDonor());
		}	
		table.addCell(getValueCell("Frais de mission", 40));
		table.addCell(getValueCellCentered(nMission+"", 20));
		table.addCell(getValueCellCentered(nMissionDonor+"", 20));
		table.addCell(getValueCellCentered((nMission+nMissionDonor)+"", 20));
		table.addCell(getValueCell("Frais de collation des donneurs", 40));
		table.addCell(getValueCellCentered(nCollation+"", 20));
		table.addCell(getValueCellCentered(nCollationDonor+"", 20));
		table.addCell(getValueCellCentered((nCollation+nCollationDonor)+"", 20));
		table.addCell(getValueCell("Frais de carburant", 40));
		table.addCell(getValueCellCentered(nFuel+"", 20));
		table.addCell(getValueCellCentered(nFuelDonor+"", 20));
		table.addCell(getValueCellCentered((nFuel+nFuelDonor)+"", 20));
		table.addCell(getValueCellBold("Total", 40));
		table.addCell(getValueCellCenteredBold(nTotal+"", 20));
		table.addCell(getValueCellCenteredBold(nTotalDonor+"", 20));
		table.addCell(getValueCellCenteredBold((nTotal+nTotalDonor)+"", 20));
		doc.add(table);
		
		
		title="\nTABLEAU VI: STATUT DES DONNEURS\n\n";
		table = new PdfPTable(100);
		table.addCell(getHeaderCell(title,100));	
		table.addCell(getTitleCell("DONNEURS",40));
		table.addCell(getTitleCellCentered("NOMBRE",30));
		table.addCell(getTitleCellCentered("POURCENTAGE",30));
		int nNew=0;
		for(int n=0;n<bloodgifts.size();n++){
			BloodGift gift = bloodgifts.elementAt(n);
			if(gift.isNewDonor()){
				nNew++;
			}
		}
		table.addCell(getValueCell("Nouveaux", 40));
		table.addCell(getValueCellCentered(nNew+"", 30));
		table.addCell(getValueCellCentered(getPercent(nNew,bloodgifts.size())+"%", 30));
		table.addCell(getValueCell("Anciens", 40));
		table.addCell(getValueCellCentered((bloodgifts.size()-nNew)+"", 30));
		table.addCell(getValueCellCentered(getPercent(bloodgifts.size()-nNew,bloodgifts.size())+"%", 30));
		table.addCell(getValueCellBold("Total", 40));
		table.addCell(getValueCellCenteredBold(bloodgifts.size()+"", 30));
		table.addCell(getValueCellCenteredBold("100%", 30));
		doc.add(table);
		
		title="\nTABLEAU VII: RECRUTEMENT DES DONNEURS\n\n";
		table = new PdfPTable(100);
		table.addCell(getHeaderCell(title,100));	
		cell = getTitleCell("STATUT", 40);
		cell.setRowspan(2);
		table.addCell(cell);
		table.addCell(getTitleCellCentered("ANCIENS DONNEURS",30));
		table.addCell(getTitleCellCentered("NOUVEAUX DONNEURS",30));
		table.addCell(getTitleCellCentered("NOMBRE",15));
		table.addCell(getTitleCellCentered("POURCENTAGE",15));
		table.addCell(getTitleCellCentered("NOMBRE",15));
		table.addCell(getTitleCellCentered("POURCENTAGE",15));
		int nOldAccepted=0,nNewAccepted=0,nOldRefused=0,nNewRefused=0;
		for(int n=0;n<bloodgifts.size();n++){
			BloodGift gift = bloodgifts.elementAt(n);
			if(gift.getRefused()==0){ //Accepted
				if(gift.isNewDonor()){
					nNewAccepted++;
				}
				else{
					nOldAccepted++;
				}
			}
			else{ //Refused
				if(gift.isNewDonor()){
					nNewRefused++;
				}
				else{
					nOldRefused++;
				}
			}
		}
		table.addCell(getValueCell("Acceptés", 40));
		table.addCell(getValueCellCentered(nOldAccepted+"", 15));
		table.addCell(getValueCellCentered(getPercent(nOldAccepted,bloodgifts.size())+"%", 15));
		table.addCell(getValueCellCentered(nNewAccepted+"", 15));
		table.addCell(getValueCellCentered(getPercent(nNewAccepted,bloodgifts.size())+"%", 15));
		table.addCell(getValueCell("Refusés", 40));
		table.addCell(getValueCellCentered(nOldRefused+"", 15));
		table.addCell(getValueCellCentered(getPercent(nOldRefused,bloodgifts.size())+"%", 15));
		table.addCell(getValueCellCentered(nNewRefused+"", 15));
		table.addCell(getValueCellCentered(getPercent(nNewRefused,bloodgifts.size())+"%", 15));
		table.addCell(getValueCellBold("Total", 40));
		table.addCell(getValueCellCenteredBold((nOldAccepted+nOldRefused)+"", 15));
		table.addCell(getValueCellCenteredBold(getPercent(nOldAccepted+nOldRefused,bloodgifts.size())+"%", 15));
		table.addCell(getValueCellCenteredBold((nNewAccepted+nNewRefused)+"", 15));
		table.addCell(getValueCellCenteredBold(getPercent(nNewAccepted+nNewRefused,bloodgifts.size())+"%", 15));
		doc.add(table);
		
		title="\nTABLEAU VIII: CAUSES DE REFUS DES DONS\n\n";
		table = new PdfPTable(100);
		table.addCell(getHeaderCell(title,100));	
		cell = getTitleCell("CAUSES DE REFUS", 40);
		cell.setRowspan(2);
		table.addCell(cell);
		table.addCell(getTitleCellCentered("EFFECTIFS",30));
		cell = getTitleCellCentered("TOTAL", 15);
		cell.setRowspan(2);
		table.addCell(cell);
		cell = getTitleCellCentered("POURCENTAGE", 15);
		cell.setRowspan(2);
		table.addCell(cell);
		table.addCell(getTitleCellCentered("TEMPORAIRES",15));
		table.addCell(getTitleCellCentered("DEFINITIFS",15));
		SortedMap<String,int[]> causes = new TreeMap();
		int nRefusals=0;
		for(int n=0;n<bloodgifts.size();n++){
			BloodGift gift = bloodgifts.elementAt(n);
			if(gift.getRefused()>0){
				nRefusals++;
				Vector<String> reasons = gift.getReasonsForRefusal();
				for(int i=0;i<reasons.size();i++){
					String reason = reasons.elementAt(i);
					int[] score = {0,0};
					if(causes.get(reason)==null){
						if(gift.getRefused()==1){
							score[0]=1;
						}
						else if(gift.getRefused()==2){
							score[1]=1;
						}
					}
					else{
						score = causes.get(reason);
						if(gift.getRefused()==1){
							score[0]++;
						}
						else if(gift.getRefused()==2){
							score[1]++;
						}
					}
					causes.put(reason,score);
				}
			}
		}
		Iterator<String> iCauses = causes.keySet().iterator();
		while(iCauses.hasNext()){
			String cause = iCauses.next();
			table.addCell(getValueCell(SH.getTranNoLink(cause.split(";")[0],cause.split(";")[1],"fr").replaceAll("<b>","").replaceAll("</b>",""), 40));
			table.addCell(getValueCellCentered(causes.get(cause)[0]+"", 15));
			table.addCell(getValueCellCentered(causes.get(cause)[1]+"", 15));
			table.addCell(getValueCellCentered((causes.get(cause)[0]+causes.get(cause)[1])+"", 15));
			table.addCell(getValueCellCentered(getPercent(causes.get(cause)[0]+causes.get(cause)[1],nRefusals)+"%", 15));
		}
		doc.add(table);

		title="\nTABLEAU IX: REPARTITION DES DONNEURS PAR SEXE ET PAR AGE\n\n";
		table = new PdfPTable(100);
		table.addCell(getHeaderCell(title,100));	
		cell = getTitleCell("SEXE", 40);
		cell.setRowspan(2);
		table.addCell(cell);
		table.addCell(getTitleCellCentered("EFFECTIFS/AGES (ans)",48));
		cell = getTitleCellCentered("Total", 6);
		cell.setRowspan(2);
		table.addCell(cell);
		cell = getTitleCellCentered("%", 6);
		cell.setRowspan(2);
		table.addCell(cell);
		table.addCell(getTitleCellCentered("15-19",6));
		table.addCell(getTitleCellCentered("20-24",6));
		table.addCell(getTitleCellCentered("25-29",6));
		table.addCell(getTitleCellCentered("30-34",6));
		table.addCell(getTitleCellCentered("35-39",6));
		table.addCell(getTitleCellCentered("40-44",6));
		table.addCell(getTitleCellCentered("45-50",6));
		table.addCell(getTitleCellCentered("50+",6));
		int[] male = {0,0,0,0,0,0,0,0,0}, female = {0,0,0,0,0,0,0,0,0};
		for(int n=0;n<bloodgifts.size();n++){
			BloodGift gift = bloodgifts.elementAt(n);
			if(SH.c(gift.getGender()).equalsIgnoreCase("m")){
				increaseAgeValue(gift.getAge(), male);
			}
			else{
				increaseAgeValue(gift.getAge(), female);
			}
		}
		table.addCell(getValueCell("Masculins",40));
		for(int n=0;n<9;n++){
			table.addCell(getValueCellCentered(male[n]+"",6));
		}
		table.addCell(getValueCellCentered(getPercent(male[8],male[8]+female[8])+"%",6));
		table.addCell(getValueCell("Féminins",40));
		for(int n=0;n<9;n++){
			table.addCell(getValueCellCentered(female[n]+"",6));
		}
		table.addCell(getValueCellCentered(getPercent(female[8],male[8]+female[8])+"%",6));
		table.addCell(getValueCellBold("Total",40));
		for(int n=0;n<9;n++){
			table.addCell(getValueCellCenteredBold((male[n]+female[n])+"",6));
		}
		table.addCell(getValueCellCenteredBold("100%",6));
		doc.add(table);

		title="\nTABLEAU X: REPARTITION DES DONNEURS MASCULINS PAR CO-INFECTION ET PAR AGE\n\n";
		table = new PdfPTable(100);
		table.addCell(getHeaderCell(title,100));	
		cell = getTitleCell("CO-INFECTION", 40);
		cell.setRowspan(2);
		table.addCell(cell);
		table.addCell(getTitleCellCentered("EFFECTIFS/AGES (ans)",48));
		cell = getTitleCellCentered("Total", 6);
		cell.setRowspan(2);
		table.addCell(cell);
		cell = getTitleCellCentered("%", 6);
		cell.setRowspan(2);
		table.addCell(cell);
		table.addCell(getTitleCellCentered("15-19",6));
		table.addCell(getTitleCellCentered("20-24",6));
		table.addCell(getTitleCellCentered("25-29",6));
		table.addCell(getTitleCellCentered("30-34",6));
		table.addCell(getTitleCellCentered("35-39",6));
		table.addCell(getTitleCellCentered("40-44",6));
		table.addCell(getTitleCellCentered("45-50",6));
		table.addCell(getTitleCellCentered("50+",6));
		int[][] coinfections = new int[11][9];
		for(int n=0;n<11;n++){
			for(int i=0;i<9;i++){
				coinfections[n][i]=0;
			}
		}
		int gendermatches=0;
		for(int n=0;n<bloodgifts.size();n++){
			BloodGift gift = bloodgifts.elementAt(n);
			if(SH.c(gift.getGender()).equalsIgnoreCase("m")){
				gendermatches++;
				if(gift.getHiv()>0 && gift.getHepatitisB()>0){
					increaseAgeValue(gift.getAge(), coinfections[0]);
				}
				else if(gift.getHiv()>0 && gift.getSyphilis()>0){
					increaseAgeValue(gift.getAge(), coinfections[1]);
				}
				else if(gift.getHiv()>0 && gift.getHepatitisC()>0){
					increaseAgeValue(gift.getAge(), coinfections[2]);
				}
				else if(gift.getHiv()>0 && gift.getHepatitisB()>0 && gift.getHepatitisC()>0){
					increaseAgeValue(gift.getAge(), coinfections[3]);
				}
				else if(gift.getHiv()>0 && gift.getSyphilis()>0 && gift.getHepatitisB()>0){
					increaseAgeValue(gift.getAge(), coinfections[4]);
				}
				else if(gift.getHiv()>0 && gift.getSyphilis()>0 && gift.getHepatitisC()>0){
					increaseAgeValue(gift.getAge(), coinfections[5]);
				}
				else if(gift.getHiv()>0 && gift.getSyphilis()>0 && gift.getHepatitisC()>0 && gift.getHepatitisB()>0){
					increaseAgeValue(gift.getAge(), coinfections[6]);
				}
				else if(gift.getHepatitisB()>0 && gift.getHepatitisC()>0){
					increaseAgeValue(gift.getAge(), coinfections[7]);
				}
				else if(gift.getSyphilis()>0 && gift.getHepatitisB()>0){
					increaseAgeValue(gift.getAge(), coinfections[8]);
				}
				else if(gift.getSyphilis()>0 && gift.getHepatitisC()>0){
					increaseAgeValue(gift.getAge(), coinfections[9]);
				}
				else if(gift.getSyphilis()>0 && gift.getHepatitisB()>0 && gift.getHepatitisC()>0){
					increaseAgeValue(gift.getAge(), coinfections[10]);
				}
			}
		}
		if(gendermatches>0){
			table.addCell(getValueCell("VIH/VHB",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[0][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[0][8],gendermatches)+"%",6));
			table.addCell(getValueCell("VIH/Syphilis",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[1][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[1][8],gendermatches)+"%",6));
			table.addCell(getValueCell("VIH/VHC",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[2][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[2][8],gendermatches)+"%",6));
			table.addCell(getValueCell("VIH/VHB/VHC",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[3][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[3][8],gendermatches)+"%",6));
			table.addCell(getValueCell("VIH/VHB/Syphilis",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[4][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[4][8],gendermatches)+"%",6));
			table.addCell(getValueCell("VIH/VHC/Syphilis",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[5][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[5][8],gendermatches)+"%",6));
			table.addCell(getValueCell("VIH/VHB/VHC/Syphilis",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[6][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[6][8],gendermatches)+"%",6));
			table.addCell(getValueCell("VHB/VHC",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[7][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[7][8],gendermatches)+"%",6));
			table.addCell(getValueCell("VHB/Syphilis",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[8][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[8][8],gendermatches)+"%",6));
			table.addCell(getValueCell("VHC/Syphilis",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[9][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[9][8],gendermatches)+"%",6));
			table.addCell(getValueCell("VHB/VHC/Syphilis",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[10][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[10][8],gendermatches)+"%",6));
		}
		doc.add(table);

		title="\nTABLEAU XI: REPARTITION DES DONNEURS FEMININS PAR CO-INFECTION ET PAR AGE\n\n";
		table = new PdfPTable(100);
		table.addCell(getHeaderCell(title,100));	
		cell = getTitleCell("CO-INFECTION", 40);
		cell.setRowspan(2);
		table.addCell(cell);
		table.addCell(getTitleCellCentered("EFFECTIFS/AGES (ans)",48));
		cell = getTitleCellCentered("Total", 6);
		cell.setRowspan(2);
		table.addCell(cell);
		cell = getTitleCellCentered("%", 6);
		cell.setRowspan(2);
		table.addCell(cell);
		table.addCell(getTitleCellCentered("15-19",6));
		table.addCell(getTitleCellCentered("20-24",6));
		table.addCell(getTitleCellCentered("25-29",6));
		table.addCell(getTitleCellCentered("30-34",6));
		table.addCell(getTitleCellCentered("35-39",6));
		table.addCell(getTitleCellCentered("40-44",6));
		table.addCell(getTitleCellCentered("45-50",6));
		table.addCell(getTitleCellCentered("50+",6));
		coinfections = new int[11][9];
		for(int n=0;n<11;n++){
			for(int i=0;i<9;i++){
				coinfections[n][i]=0;
			}
		}
		gendermatches=0;
		for(int n=0;n<bloodgifts.size();n++){
			BloodGift gift = bloodgifts.elementAt(n);
			if(!SH.c(gift.getGender()).equalsIgnoreCase("m")){
				gendermatches++;
				if(gift.getHiv()>0 && gift.getHepatitisB()>0){
					increaseAgeValue(gift.getAge(), coinfections[0]);
				}
				else if(gift.getHiv()>0 && gift.getSyphilis()>0){
					increaseAgeValue(gift.getAge(), coinfections[1]);
				}
				else if(gift.getHiv()>0 && gift.getHepatitisC()>0){
					increaseAgeValue(gift.getAge(), coinfections[2]);
				}
				else if(gift.getHiv()>0 && gift.getHepatitisB()>0 && gift.getHepatitisC()>0){
					increaseAgeValue(gift.getAge(), coinfections[3]);
				}
				else if(gift.getHiv()>0 && gift.getSyphilis()>0 && gift.getHepatitisB()>0){
					increaseAgeValue(gift.getAge(), coinfections[4]);
				}
				else if(gift.getHiv()>0 && gift.getSyphilis()>0 && gift.getHepatitisC()>0){
					increaseAgeValue(gift.getAge(), coinfections[5]);
				}
				else if(gift.getHiv()>0 && gift.getSyphilis()>0 && gift.getHepatitisC()>0 && gift.getHepatitisB()>0){
					increaseAgeValue(gift.getAge(), coinfections[6]);
				}
				else if(gift.getHepatitisB()>0 && gift.getHepatitisC()>0){
					increaseAgeValue(gift.getAge(), coinfections[7]);
				}
				else if(gift.getSyphilis()>0 && gift.getHepatitisB()>0){
					increaseAgeValue(gift.getAge(), coinfections[8]);
				}
				else if(gift.getSyphilis()>0 && gift.getHepatitisC()>0){
					increaseAgeValue(gift.getAge(), coinfections[9]);
				}
				else if(gift.getSyphilis()>0 && gift.getHepatitisB()>0 && gift.getHepatitisC()>0){
					increaseAgeValue(gift.getAge(), coinfections[10]);
				}
			}
		}
		if(gendermatches>0){
			table.addCell(getValueCell("VIH/VHB",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[0][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[0][8],gendermatches)+"%",6));
			table.addCell(getValueCell("VIH/Syphilis",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[1][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[1][8],gendermatches)+"%",6));
			table.addCell(getValueCell("VIH/VHC",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[2][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[2][8],gendermatches)+"%",6));
			table.addCell(getValueCell("VIH/VHB/VHC",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[3][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[3][8],gendermatches)+"%",6));
			table.addCell(getValueCell("VIH/VHB/Syphilis",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[4][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[4][8],gendermatches)+"%",6));
			table.addCell(getValueCell("VIH/VHC/Syphilis",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[5][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[5][8],gendermatches)+"%",6));
			table.addCell(getValueCell("VIH/VHB/VHC/Syphilis",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[6][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[6][8],gendermatches)+"%",6));
			table.addCell(getValueCell("VHB/VHC",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[7][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[7][8],gendermatches)+"%",6));
			table.addCell(getValueCell("VHB/Syphilis",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[8][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[8][8],gendermatches)+"%",6));
			table.addCell(getValueCell("VHC/Syphilis",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[9][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[9][8],gendermatches)+"%",6));
			table.addCell(getValueCell("VHB/VHC/Syphilis",40));
			for(int n=0;n<9;n++){
				table.addCell(getValueCellCentered(coinfections[10][n]+"",6));
			}
			table.addCell(getValueCellCentered(getPercent(coinfections[10][8],gendermatches)+"%",6));
		}
		doc.add(table);

		title="\nTABLEAU XII: CIRCONSTANCES DES DONS\n\n";
		table = new PdfPTable(100);
		table.addCell(getHeaderCell(title,100));	
		cell = getTitleCell("DONS", 40);
		cell.setRowspan(2);
		table.addCell(cell);
		table.addCell(getTitleCellCentered("ANCIENS DONNEURS",30));
		table.addCell(getTitleCellCentered("NOUVEAUX DONNEURS",30));
		table.addCell(getTitleCellCentered("NOMBRE",15));
		table.addCell(getTitleCellCentered("POURCENTAGE",15));
		table.addCell(getTitleCellCentered("NOMBRE",15));
		table.addCell(getTitleCellCentered("POURCENTAGE",15));
		int nAncienVolontaire=0,nNouveauVolontaire=0,nAncienFamilial=0,nNouveauFamilial=0,nAncienNonspecifie=0,nNouveauNonspecifie=0;
		for(int n=0;n<bloodgifts.size();n++){
			BloodGift gift = bloodgifts.elementAt(n);
			if(gift.isNewDonor()){
				if(SH.c(gift.getDonorType()).contains("1")){
					nNouveauVolontaire++;
				}
				else if(SH.c(gift.getDonorType()).contains("2")){
					nNouveauFamilial++;
				}
				else{
					nNouveauNonspecifie++;
				}
			}
			else{
				if(SH.c(gift.getDonorType()).contains("1")){
					nAncienVolontaire++;
				}
				else if(SH.c(gift.getDonorType()).contains("2")){
					nAncienFamilial++;
				}
				else{
					nAncienNonspecifie++;
				}
			}
		}		
		table.addCell(getValueCell("Volontaires",40));
		table.addCell(getValueCellCentered(nAncienVolontaire+"",15));
		table.addCell(getValueCellCentered(getPercent(nAncienVolontaire,bloodgifts.size())+"%",15));
		table.addCell(getValueCellCentered(nNouveauVolontaire+"",15));
		table.addCell(getValueCellCentered(getPercent(nNouveauVolontaire,bloodgifts.size())+"%",15));
		table.addCell(getValueCell("Familiaux",40));
		table.addCell(getValueCellCentered(nAncienFamilial+"",15));
		table.addCell(getValueCellCentered(getPercent(nAncienFamilial,bloodgifts.size())+"%",15));
		table.addCell(getValueCellCentered(nNouveauFamilial+"",15));
		table.addCell(getValueCellCentered(getPercent(nNouveauFamilial,bloodgifts.size())+"%",15));
		table.addCell(getValueCell("Non spécifié",40));
		table.addCell(getValueCellCentered(nAncienNonspecifie+"",15));
		table.addCell(getValueCellCentered(getPercent(nAncienNonspecifie,bloodgifts.size())+"%",15));
		table.addCell(getValueCellCentered(nNouveauNonspecifie+"",15));
		table.addCell(getValueCellCentered(getPercent(nNouveauNonspecifie,bloodgifts.size())+"%",15));
		table.addCell(getValueCellBold("Total",40));
		table.addCell(getValueCellCenteredBold((nAncienFamilial+nAncienVolontaire+nAncienNonspecifie)+"",15));
		table.addCell(getValueCellCenteredBold(getPercent(nAncienFamilial+nAncienVolontaire+nAncienNonspecifie,bloodgifts.size())+"%",15));
		table.addCell(getValueCellCenteredBold((nNouveauFamilial+nNouveauVolontaire+nNouveauNonspecifie)+"",15));
		table.addCell(getValueCellCenteredBold(getPercent(nNouveauFamilial+nNouveauVolontaire+nNouveauNonspecifie,bloodgifts.size())+"%",15));
		doc.add(table);

		title="\nTABLEAU XIII: REPARTITION DES DONS DE SANG EN FONCTION DU LIEU DE COLLECTE\n\n";
		table = new PdfPTable(100);
		table.addCell(getHeaderCell(title,100));	
		table.addCell(getTitleCell("LIEU DE PRELEVEMENT",40));
		table.addCell(getTitleCellCentered("NOMBRE",30));
		table.addCell(getTitleCellCentered("POURCENTAGE",30));
		int nFixed=0,nMobile=0,nUnknown=0;
		for(int n=0;n<bloodgifts.size();n++){
			BloodGift gift = bloodgifts.elementAt(n);
			if(SH.c(gift.getCollectionUnit()).length()>0 && "1,2,3,4,5".contains(gift.getCollectionUnit())){
				nFixed++;
			}
			else if(SH.c(gift.getCollectionUnit()).length()>0){
				nMobile++;
			}
			else{
				nUnknown++;
			}
		}
		table.addCell(getValueCell("CNTS/CRTS (fixe)",40));
		table.addCell(getValueCellCentered(nFixed+"",30));
		table.addCell(getValueCellCentered(getPercent(nFixed,bloodgifts.size())+"%",30));
		table.addCell(getValueCell("Equipes mobiles",40));
		table.addCell(getValueCellCentered(nMobile+"",30));
		table.addCell(getValueCellCentered(getPercent(nMobile,bloodgifts.size())+"%",30));
		table.addCell(getValueCell("Non spécifié",40));
		table.addCell(getValueCellCentered(nUnknown+"",30));
		table.addCell(getValueCellCentered(getPercent(nUnknown,bloodgifts.size())+"%",30));
		table.addCell(getValueCellBold("Total",40));
		table.addCell(getValueCellCenteredBold((nFixed+nMobile+nUnknown)+"",30));
		table.addCell(getValueCellCenteredBold("100%",30));
		doc.add(table);

		title="\nTABLEAU XIV: REPARTITION DES GROUPES SANGUINS SUR LE SANG DES DONNEURS\n\n";
		table = new PdfPTable(100);
		table.addCell(getHeaderCell(title,100));	
		table.addCell(getTitleCell("GROUPES SANGUINS",40));
		table.addCell(getTitleCellCentered("EFFECTIFS",30));
		table.addCell(getTitleCellCentered("POURCENTAGE",30));
		int aplus=0,amin=0,bplus=0,bmin=0,abplus=0,abmin=0,oplus=0,omin=0,unknown=0;
		for(int n=0;n<bloodgifts.size();n++){
			BloodGift gift = bloodgifts.elementAt(n);
			if(gift.getBloodgroup().equalsIgnoreCase("a+")) aplus++;
			else if(gift.getBloodgroup().equalsIgnoreCase("a-")) amin++;
			else if(gift.getBloodgroup().equalsIgnoreCase("b+")) bplus++;
			else if(gift.getBloodgroup().equalsIgnoreCase("b-")) bmin++;
			else if(gift.getBloodgroup().equalsIgnoreCase("ab+")) abplus++;
			else if(gift.getBloodgroup().equalsIgnoreCase("ab-")) abmin++;
			else if(gift.getBloodgroup().equalsIgnoreCase("o+")) oplus++;
			else if(gift.getBloodgroup().equalsIgnoreCase("o-")) omin++;
			else unknown++;
		}
		table.addCell(getValueCell("A+",40));
		table.addCell(getValueCellCentered(aplus+"",30));
		table.addCell(getValueCellCentered(getPercent(aplus,bloodgifts.size())+"%",30));
		table.addCell(getValueCell("A-",40));
		table.addCell(getValueCellCentered(amin+"",30));
		table.addCell(getValueCellCentered(getPercent(amin,bloodgifts.size())+"%",30));
		table.addCell(getValueCell("B+",40));
		table.addCell(getValueCellCentered(bplus+"",30));
		table.addCell(getValueCellCentered(getPercent(bplus,bloodgifts.size())+"%",30));
		table.addCell(getValueCell("B-",40));
		table.addCell(getValueCellCentered(bmin+"",30));
		table.addCell(getValueCellCentered(getPercent(bmin,bloodgifts.size())+"%",30));
		table.addCell(getValueCell("AB+",40));
		table.addCell(getValueCellCentered(abplus+"",30));
		table.addCell(getValueCellCentered(getPercent(abplus,bloodgifts.size())+"%",30));
		table.addCell(getValueCell("AB-",40));
		table.addCell(getValueCellCentered(abmin+"",30));
		table.addCell(getValueCellCentered(getPercent(abmin,bloodgifts.size())+"%",30));
		table.addCell(getValueCell("O+",40));
		table.addCell(getValueCellCentered(oplus+"",30));
		table.addCell(getValueCellCentered(getPercent(oplus,bloodgifts.size())+"%",30));
		table.addCell(getValueCell("O-",40));
		table.addCell(getValueCellCentered(omin+"",30));
		table.addCell(getValueCellCentered(getPercent(omin,bloodgifts.size())+"%",30));
		table.addCell(getValueCell("Indéterminé",40));
		table.addCell(getValueCellCentered(unknown+"",30));
		table.addCell(getValueCellCentered(getPercent(unknown,bloodgifts.size())+"%",30));
		table.addCell(getValueCellBold("Total",40));
		table.addCell(getValueCellCenteredBold(bloodgifts.size()+"",30));
		table.addCell(getValueCellCenteredBold("100%",30));
		doc.add(table);

		title="\nTABLEAU XV: SEROPREVALENCE DES INFECTIONS TRANSMISSIBLES PAR LE SANG\n\n";
		table = new PdfPTable(100);
		table.addCell(getHeaderCell(title,100));	
		cell = getTitleCell("STATUT DES DONNEURS", 20);
		cell.setRowspan(2);
		table.addCell(cell);
		cell = getTitleCell("RESULTATS SEROLOGIQUES", 20);
		cell.setRowspan(2);
		table.addCell(cell);
		table.addCell(getTitleCellCentered("VIH",15));
		table.addCell(getTitleCellCentered("VHB",15));
		table.addCell(getTitleCellCentered("VHC",15));
		table.addCell(getTitleCellCentered("SYPHILIS",15));
		table.addCell(getTitleCellCentered("Nombre",8));
		table.addCell(getTitleCellCentered("%",7));
		table.addCell(getTitleCellCentered("Nombre",8));
		table.addCell(getTitleCellCentered("%",7));
		table.addCell(getTitleCellCentered("Nombre",8));
		table.addCell(getTitleCellCentered("%",7));
		table.addCell(getTitleCellCentered("Nombre",8));
		table.addCell(getTitleCellCentered("%",7));
		int[][] statuses = new int[4][4];
		for(int n=0;n<bloodgifts.size();n++){
			BloodGift gift = bloodgifts.elementAt(n);
			if(gift.isNewDonor()){
				if(gift.getHiv()>0) statuses[2][0]++; else statuses[3][0]++;
				if(gift.getHepatitisB()>0) statuses[2][1]++; else statuses[3][1]++;
				if(gift.getHepatitisC()>0) statuses[2][2]++; else statuses[3][2]++;
				if(gift.getSyphilis()>0) statuses[2][3]++; else statuses[3][3]++;
			}
			else{
				if(gift.getHiv()>0) statuses[0][0]++; else statuses[1][0]++;
				if(gift.getHepatitisB()>0) statuses[0][1]++; else statuses[1][1]++;
				if(gift.getHepatitisC()>0) statuses[0][2]++; else statuses[1][2]++;
				if(gift.getSyphilis()>0) statuses[0][3]++; else statuses[1][3]++;
			}
		}		
		cell = getValueCell("Anciens", 20);
		cell.setRowspan(3);
		table.addCell(cell);
		table.addCell(getValueCell("Positif", 20));
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(statuses[0][n]+"", 8));
			table.addCell(getValueCellCentered(getPercent(statuses[0][n],bloodgifts.size())+"%", 7));
		}
		table.addCell(getValueCell("Négatif", 20));
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(statuses[1][n]+"", 8));
			table.addCell(getValueCellCentered(getPercent(statuses[1][n],bloodgifts.size())+"%", 7));
		}
		table.addCell(getValueCellBold("Total", 20));
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCenteredBold((statuses[0][n]+statuses[1][n])+"", 8));
			table.addCell(getValueCellCenteredBold(getPercent(statuses[0][n]+statuses[1][n],bloodgifts.size())+"%", 7));
		}
		cell = getValueCell("Nouveaux", 20);
		cell.setRowspan(3);
		table.addCell(cell);
		table.addCell(getValueCell("Positif", 20));
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(statuses[2][n]+"", 8));
			table.addCell(getValueCellCentered(getPercent(statuses[2][n],bloodgifts.size())+"%", 7));
		}
		table.addCell(getValueCell("Négatif", 20));
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(statuses[3][n]+"", 8));
			table.addCell(getValueCellCentered(getPercent(statuses[3][n],bloodgifts.size())+"%", 7));
		}
		table.addCell(getValueCell("Total", 20));
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCenteredBold((statuses[2][n]+statuses[3][n])+"", 8));
			table.addCell(getValueCellCenteredBold(getPercent(statuses[2][n]+statuses[3][n],bloodgifts.size())+"%", 7));
		}
		doc.add(table);

		title="\nTABLEAU XVI: SEROPREVALENCE DU VIH CHEZ LES DONNEURS SELON LE SEXE\n\n";
		table = new PdfPTable(100);
		table.addCell(getHeaderCell(title,100));	
		cell = getTitleCell("STATUT DES DONNEURS", 20);
		cell.setRowspan(3);
		table.addCell(cell);
		cell = getTitleCell("AGE", 20);
		cell.setRowspan(3);
		table.addCell(cell);
		table.addCell(getTitleCellCentered("RESULTATS",60));
		table.addCell(getTitleCellCentered("POSITIF",30));
		table.addCell(getTitleCellCentered("NEGATIF",30));
		table.addCell(getTitleCellCentered("FEMININ",15));
		table.addCell(getTitleCellCentered("MASCULIN",15));
		table.addCell(getTitleCellCentered("FEMININ",15));
		table.addCell(getTitleCellCentered("MASCULIN",15));
		int[][] anciens = new int[4][9], nouveaux = new int[4][9];
		for(int n=0;n<bloodgifts.size();n++){
			BloodGift gift = bloodgifts.elementAt(n);
			if(gift.isNewDonor()){ //Nouveau
				if(gift.getHiv()>0){ //Positif
					if(!SH.c(gift.getGender()).equalsIgnoreCase("m")){ //Féminin
						increaseAgeValue(gift.getAge(), nouveaux[0]);
					}
					else{ //Masculin
						increaseAgeValue(gift.getAge(), nouveaux[1]);
					}
					
				}
				else { //Négatif
					if(!SH.c(gift.getGender()).equalsIgnoreCase("m")){ //Féminin
						increaseAgeValue(gift.getAge(), nouveaux[2]);
					}
					else{ //Masculin
						increaseAgeValue(gift.getAge(), nouveaux[3]);
					}
					
				}
			}
			else{ //Ancien
				if(gift.getHiv()>0){ //Positif
					if(!SH.c(gift.getGender()).equalsIgnoreCase("m")){ //Féminin
						increaseAgeValue(gift.getAge(), anciens[0]);
					}
					else{ //Masculin
						increaseAgeValue(gift.getAge(), anciens[1]);
					}
					
				}
				else { //Négatif
					if(!SH.c(gift.getGender()).equalsIgnoreCase("m")){ //Féminin
						increaseAgeValue(gift.getAge(), anciens[2]);
					}
					else{ //Masculin
						increaseAgeValue(gift.getAge(), anciens[3]);
					}
					
				}
			}
		}		
		cell = getValueCell("Anciens", 20);
		cell.setRowspan(10);
		table.addCell(cell);
		table.addCell(getValueCell("15-19 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][0]+"",15));		
		}
		table.addCell(getValueCell("20-24 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][1]+"",15));		
		}
		table.addCell(getValueCell("25-29 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][2]+"",15));		
		}
		table.addCell(getValueCell("30-34 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][3]+"",15));		
		}
		table.addCell(getValueCell("35-39 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][4]+"",15));		
		}
		table.addCell(getValueCell("40-44 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][5]+"",15));		
		}
		table.addCell(getValueCell("45-50 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][6]+"",15));		
		}
		table.addCell(getValueCell("50+",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][7]+"",15));		
		}
		table.addCell(getValueCell("Total",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][8]+"",15));		
		}
		table.addCell(getValueCell("%",20));		
		for(int n=0;n<4;n++){
			if(anciens[0][8]+anciens[1][8]+anciens[2][8]+anciens[3][8]>0){
				table.addCell(getValueCellCentered(getPercent(anciens[n][8],(anciens[0][8]+anciens[1][8]+anciens[2][8]+anciens[3][8]))+"%",15));		
			}
			else{
				table.addCell(getValueCellCentered("?",15));		
			}
		}
		cell = getValueCell("Nouveaux", 20);
		cell.setRowspan(10);
		table.addCell(cell);
		table.addCell(getValueCell("15-19 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][0]+"",15));		
		}
		table.addCell(getValueCell("20-24 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][1]+"",15));		
		}
		table.addCell(getValueCell("25-29 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][2]+"",15));		
		}
		table.addCell(getValueCell("30-34 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][3]+"",15));		
		}
		table.addCell(getValueCell("35-39 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][4]+"",15));		
		}
		table.addCell(getValueCell("40-44 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][5]+"",15));		
		}
		table.addCell(getValueCell("45-50 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][6]+"",15));		
		}
		table.addCell(getValueCell("50+",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][7]+"",15));		
		}
		table.addCell(getValueCell("Total",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][8]+"",15));		
		}
		table.addCell(getValueCell("%",20));		
		for(int n=0;n<4;n++){
			if(nouveaux[0][8]+nouveaux[1][8]+nouveaux[2][8]+nouveaux[3][8]>0){
				table.addCell(getValueCellCentered(getPercent(nouveaux[n][8],(nouveaux[0][8]+nouveaux[1][8]+nouveaux[2][8]+nouveaux[3][8]))+"%",15));		
			}
			else{
				table.addCell(getValueCellCentered("?",15));		
			}
		}
		doc.add(table);

		title="\nTABLEAU XVII: SEROPREVALENCE DU VHB CHEZ LES DONNEURS SELON LE SEXE\n\n";
		table = new PdfPTable(100);
		table.addCell(getHeaderCell(title,100));	
		cell = getTitleCell("STATUT DES DONNEURS", 20);
		cell.setRowspan(3);
		table.addCell(cell);
		cell = getTitleCell("AGE", 20);
		cell.setRowspan(3);
		table.addCell(cell);
		table.addCell(getTitleCellCentered("RESULTATS",60));
		table.addCell(getTitleCellCentered("POSITIF",30));
		table.addCell(getTitleCellCentered("NEGATIF",30));
		table.addCell(getTitleCellCentered("FEMININ",15));
		table.addCell(getTitleCellCentered("MASCULIN",15));
		table.addCell(getTitleCellCentered("FEMININ",15));
		table.addCell(getTitleCellCentered("MASCULIN",15));
		anciens = new int[4][9];
		nouveaux = new int[4][9];
		for(int n=0;n<bloodgifts.size();n++){
			BloodGift gift = bloodgifts.elementAt(n);
			if(gift.isNewDonor()){ //Nouveau
				if(gift.getHepatitisB()>0){ //Positif
					if(!SH.c(gift.getGender()).equalsIgnoreCase("m")){ //Féminin
						increaseAgeValue(gift.getAge(), nouveaux[0]);
					}
					else{ //Masculin
						increaseAgeValue(gift.getAge(), nouveaux[1]);
					}
					
				}
				else { //Négatif
					if(!SH.c(gift.getGender()).equalsIgnoreCase("m")){ //Féminin
						increaseAgeValue(gift.getAge(), nouveaux[2]);
					}
					else{ //Masculin
						increaseAgeValue(gift.getAge(), nouveaux[3]);
					}
					
				}
			}
			else{ //Ancien
				if(gift.getHepatitisB()>0){ //Positif
					if(!SH.c(gift.getGender()).equalsIgnoreCase("m")){ //Féminin
						increaseAgeValue(gift.getAge(), anciens[0]);
					}
					else{ //Masculin
						increaseAgeValue(gift.getAge(), anciens[1]);
					}
					
				}
				else { //Négatif
					if(!SH.c(gift.getGender()).equalsIgnoreCase("m")){ //Féminin
						increaseAgeValue(gift.getAge(), anciens[2]);
					}
					else{ //Masculin
						increaseAgeValue(gift.getAge(), anciens[3]);
					}
					
				}
			}
		}		
		cell = getValueCell("Anciens", 20);
		cell.setRowspan(10);
		table.addCell(cell);
		table.addCell(getValueCell("15-19 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][0]+"",15));		
		}
		table.addCell(getValueCell("20-24 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][1]+"",15));		
		}
		table.addCell(getValueCell("25-29 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][2]+"",15));		
		}
		table.addCell(getValueCell("30-34 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][3]+"",15));		
		}
		table.addCell(getValueCell("35-39 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][4]+"",15));		
		}
		table.addCell(getValueCell("40-44 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][5]+"",15));		
		}
		table.addCell(getValueCell("45-50 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][6]+"",15));		
		}
		table.addCell(getValueCell("50+",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][7]+"",15));		
		}
		table.addCell(getValueCell("Total",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][8]+"",15));		
		}
		table.addCell(getValueCell("%",20));		
		for(int n=0;n<4;n++){
			if(anciens[0][8]+anciens[1][8]+anciens[2][8]+anciens[3][8]>0){
				table.addCell(getValueCellCentered(getPercent(anciens[n][8],(anciens[0][8]+anciens[1][8]+anciens[2][8]+anciens[3][8]))+"%",15));		
			}
			else{
				table.addCell(getValueCellCentered("?",15));		
			}
		}
		cell = getValueCell("Nouveaux", 20);
		cell.setRowspan(10);
		table.addCell(cell);
		table.addCell(getValueCell("15-19 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][0]+"",15));		
		}
		table.addCell(getValueCell("20-24 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][1]+"",15));		
		}
		table.addCell(getValueCell("25-29 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][2]+"",15));		
		}
		table.addCell(getValueCell("30-34 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][3]+"",15));		
		}
		table.addCell(getValueCell("35-39 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][4]+"",15));		
		}
		table.addCell(getValueCell("40-44 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][5]+"",15));		
		}
		table.addCell(getValueCell("45-50 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][6]+"",15));		
		}
		table.addCell(getValueCell("50+",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][7]+"",15));		
		}
		table.addCell(getValueCell("Total",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][8]+"",15));		
		}
		table.addCell(getValueCell("%",20));		
		for(int n=0;n<4;n++){
			if(nouveaux[0][8]+nouveaux[1][8]+nouveaux[2][8]+nouveaux[3][8]>0){
				table.addCell(getValueCellCentered(getPercent(nouveaux[n][8],(nouveaux[0][8]+nouveaux[1][8]+nouveaux[2][8]+nouveaux[3][8]))+"%",15));		
			}
			else{
				table.addCell(getValueCellCentered("?",15));		
			}
		}
		doc.add(table);

		title="\nTABLEAU XVII: SEROPREVALENCE DU VHC CHEZ LES DONNEURS SELON LE SEXE\n\n";
		table = new PdfPTable(100);
		table.addCell(getHeaderCell(title,100));	
		cell = getTitleCell("STATUT DES DONNEURS", 20);
		cell.setRowspan(3);
		table.addCell(cell);
		cell = getTitleCell("AGE", 20);
		cell.setRowspan(3);
		table.addCell(cell);
		table.addCell(getTitleCellCentered("RESULTATS",60));
		table.addCell(getTitleCellCentered("POSITIF",30));
		table.addCell(getTitleCellCentered("NEGATIF",30));
		table.addCell(getTitleCellCentered("FEMININ",15));
		table.addCell(getTitleCellCentered("MASCULIN",15));
		table.addCell(getTitleCellCentered("FEMININ",15));
		table.addCell(getTitleCellCentered("MASCULIN",15));
		anciens = new int[4][9];
		nouveaux = new int[4][9];
		for(int n=0;n<bloodgifts.size();n++){
			BloodGift gift = bloodgifts.elementAt(n);
			if(gift.isNewDonor()){ //Nouveau
				if(gift.getHepatitisC()>0){ //Positif
					if(!SH.c(gift.getGender()).equalsIgnoreCase("m")){ //Féminin
						increaseAgeValue(gift.getAge(), nouveaux[0]);
					}
					else{ //Masculin
						increaseAgeValue(gift.getAge(), nouveaux[1]);
					}
					
				}
				else { //Négatif
					if(!SH.c(gift.getGender()).equalsIgnoreCase("m")){ //Féminin
						increaseAgeValue(gift.getAge(), nouveaux[2]);
					}
					else{ //Masculin
						increaseAgeValue(gift.getAge(), nouveaux[3]);
					}
					
				}
			}
			else{ //Ancien
				if(gift.getHepatitisC()>0){ //Positif
					if(!SH.c(gift.getGender()).equalsIgnoreCase("m")){ //Féminin
						increaseAgeValue(gift.getAge(), anciens[0]);
					}
					else{ //Masculin
						increaseAgeValue(gift.getAge(), anciens[1]);
					}
					
				}
				else { //Négatif
					if(!SH.c(gift.getGender()).equalsIgnoreCase("m")){ //Féminin
						increaseAgeValue(gift.getAge(), anciens[2]);
					}
					else{ //Masculin
						increaseAgeValue(gift.getAge(), anciens[3]);
					}
					
				}
			}
		}		
		cell = getValueCell("Anciens", 20);
		cell.setRowspan(10);
		table.addCell(cell);
		table.addCell(getValueCell("15-19 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][0]+"",15));		
		}
		table.addCell(getValueCell("20-24 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][1]+"",15));		
		}
		table.addCell(getValueCell("25-29 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][2]+"",15));		
		}
		table.addCell(getValueCell("30-34 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][3]+"",15));		
		}
		table.addCell(getValueCell("35-39 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][4]+"",15));		
		}
		table.addCell(getValueCell("40-44 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][5]+"",15));		
		}
		table.addCell(getValueCell("45-50 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][6]+"",15));		
		}
		table.addCell(getValueCell("50+",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][7]+"",15));		
		}
		table.addCell(getValueCell("Total",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][8]+"",15));		
		}
		table.addCell(getValueCell("%",20));		
		for(int n=0;n<4;n++){
			if(anciens[0][8]+anciens[1][8]+anciens[2][8]+anciens[3][8]>0){
				table.addCell(getValueCellCentered(getPercent(anciens[n][8],(anciens[0][8]+anciens[1][8]+anciens[2][8]+anciens[3][8]))+"%",15));		
			}
			else{
				table.addCell(getValueCellCentered("?",15));		
			}
		}
		cell = getValueCell("Nouveaux", 20);
		cell.setRowspan(10);
		table.addCell(cell);
		table.addCell(getValueCell("15-19 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][0]+"",15));		
		}
		table.addCell(getValueCell("20-24 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][1]+"",15));		
		}
		table.addCell(getValueCell("25-29 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][2]+"",15));		
		}
		table.addCell(getValueCell("30-34 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][3]+"",15));		
		}
		table.addCell(getValueCell("35-39 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][4]+"",15));		
		}
		table.addCell(getValueCell("40-44 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][5]+"",15));		
		}
		table.addCell(getValueCell("45-50 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][6]+"",15));		
		}
		table.addCell(getValueCell("50+",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][7]+"",15));		
		}
		table.addCell(getValueCell("Total",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][8]+"",15));		
		}
		table.addCell(getValueCell("%",20));		
		for(int n=0;n<4;n++){
			if(nouveaux[0][8]+nouveaux[1][8]+nouveaux[2][8]+nouveaux[3][8]>0){
				table.addCell(getValueCellCentered(getPercent(nouveaux[n][8],(nouveaux[0][8]+nouveaux[1][8]+nouveaux[2][8]+nouveaux[3][8]))+"%",15));		
			}
			else{
				table.addCell(getValueCellCentered("?",15));		
			}
		}
		doc.add(table);

		title="\nTABLEAU XVII: SEROPREVALENCE DU SYPHILIS CHEZ LES DONNEURS SELON LE SEXE\n\n";
		table = new PdfPTable(100);
		table.addCell(getHeaderCell(title,100));	
		cell = getTitleCell("STATUT DES DONNEURS", 20);
		cell.setRowspan(3);
		table.addCell(cell);
		cell = getTitleCell("AGE", 20);
		cell.setRowspan(3);
		table.addCell(cell);
		table.addCell(getTitleCellCentered("RESULTATS",60));
		table.addCell(getTitleCellCentered("POSITIF",30));
		table.addCell(getTitleCellCentered("NEGATIF",30));
		table.addCell(getTitleCellCentered("FEMININ",15));
		table.addCell(getTitleCellCentered("MASCULIN",15));
		table.addCell(getTitleCellCentered("FEMININ",15));
		table.addCell(getTitleCellCentered("MASCULIN",15));
		anciens = new int[4][9];
		nouveaux = new int[4][9];
		for(int n=0;n<bloodgifts.size();n++){
			BloodGift gift = bloodgifts.elementAt(n);
			if(gift.isNewDonor()){ //Nouveau
				if(gift.getSyphilis()>0){ //Positif
					if(!SH.c(gift.getGender()).equalsIgnoreCase("m")){ //Féminin
						increaseAgeValue(gift.getAge(), nouveaux[0]);
					}
					else{ //Masculin
						increaseAgeValue(gift.getAge(), nouveaux[1]);
					}
					
				}
				else { //Négatif
					if(!SH.c(gift.getGender()).equalsIgnoreCase("m")){ //Féminin
						increaseAgeValue(gift.getAge(), nouveaux[2]);
					}
					else{ //Masculin
						increaseAgeValue(gift.getAge(), nouveaux[3]);
					}
					
				}
			}
			else{ //Ancien
				if(gift.getSyphilis()>0){ //Positif
					if(!SH.c(gift.getGender()).equalsIgnoreCase("m")){ //Féminin
						increaseAgeValue(gift.getAge(), anciens[0]);
					}
					else{ //Masculin
						increaseAgeValue(gift.getAge(), anciens[1]);
					}
					
				}
				else { //Négatif
					if(!SH.c(gift.getGender()).equalsIgnoreCase("m")){ //Féminin
						increaseAgeValue(gift.getAge(), anciens[2]);
					}
					else{ //Masculin
						increaseAgeValue(gift.getAge(), anciens[3]);
					}
					
				}
			}
		}		
		cell = getValueCell("Anciens", 20);
		cell.setRowspan(10);
		table.addCell(cell);
		table.addCell(getValueCell("15-19 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][0]+"",15));		
		}
		table.addCell(getValueCell("20-24 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][1]+"",15));		
		}
		table.addCell(getValueCell("25-29 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][2]+"",15));		
		}
		table.addCell(getValueCell("30-34 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][3]+"",15));		
		}
		table.addCell(getValueCell("35-39 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][4]+"",15));		
		}
		table.addCell(getValueCell("40-44 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][5]+"",15));		
		}
		table.addCell(getValueCell("45-50 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][6]+"",15));		
		}
		table.addCell(getValueCell("50+",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][7]+"",15));		
		}
		table.addCell(getValueCell("Total",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(anciens[n][8]+"",15));		
		}
		table.addCell(getValueCell("%",20));		
		for(int n=0;n<4;n++){
			if(anciens[0][8]+anciens[1][8]+anciens[2][8]+anciens[3][8]>0){
				table.addCell(getValueCellCentered(getPercent(anciens[n][8],(anciens[0][8]+anciens[1][8]+anciens[2][8]+anciens[3][8]))+"%",15));		
			}
			else{
				table.addCell(getValueCellCentered("?",15));		
			}
		}
		cell = getValueCell("Nouveaux", 20);
		cell.setRowspan(10);
		table.addCell(cell);
		table.addCell(getValueCell("15-19 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][0]+"",15));		
		}
		table.addCell(getValueCell("20-24 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][1]+"",15));		
		}
		table.addCell(getValueCell("25-29 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][2]+"",15));		
		}
		table.addCell(getValueCell("30-34 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][3]+"",15));		
		}
		table.addCell(getValueCell("35-39 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][4]+"",15));		
		}
		table.addCell(getValueCell("40-44 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][5]+"",15));		
		}
		table.addCell(getValueCell("45-50 ans",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][6]+"",15));		
		}
		table.addCell(getValueCell("50+",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][7]+"",15));		
		}
		table.addCell(getValueCell("Total",20));		
		for(int n=0;n<4;n++){
			table.addCell(getValueCellCentered(nouveaux[n][8]+"",15));		
		}
		table.addCell(getValueCell("%",20));		
		for(int n=0;n<4;n++){
			if(nouveaux[0][8]+nouveaux[1][8]+nouveaux[2][8]+nouveaux[3][8]>0){
				table.addCell(getValueCellCentered(getPercent(nouveaux[n][8],(nouveaux[0][8]+nouveaux[1][8]+nouveaux[2][8]+nouveaux[3][8]))+"%",15));		
			}
			else{
				table.addCell(getValueCellCentered("?",15));		
			}
		}
		doc.add(table);
    }
	
	//Write PDF report to servlet output stream
	if(doc!=null) doc.close();
    if(docWriter!=null) docWriter.close();
	response.setContentType("application/octet-stream; charset=windows-1252");
	response.setHeader("Content-Disposition","Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date())+".pdf\"");
    response.setContentLength(baosPDF.size());
    ServletOutputStream sos = response.getOutputStream();
    baosPDF.writeTo(sos);
    sos.flush();
    sos.close();
%>