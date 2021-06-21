<%@page import="be.mxs.common.util.system.HTMLEntities,
                be.openclinic.assets.Asset,
                java.util.*,
                java.io.*,
                org.dom4j.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%!
    //--- REIMBURSEMENT PLAN TO XML ---------------------------------------------------------------
    /*
        sConcatValue : date|capital|interest$ -->
        
        <ReimbursementPlans>
            <Plan>
                <Date>01/05/2013</Date>
                <Capital>20000</Capital>
                <Interest>3.25</Interest>
            </Plan>
        </ReimbursementPlans>
    */
    private String reimbursementPlanToXML(String sConcatValue){
        String sXML = "";
        
        if(sConcatValue.length() > 0){           
            org.dom4j.Document document = DocumentHelper.createDocument();
            Element rpElem = document.addElement("ReimbursementPlans"); 
              
            String sChild, sDate, sCapital, sInterest;
            while(sConcatValue.indexOf("$") > -1){
                Element planElem = rpElem.addElement("Plan"); 
                
                sChild = sConcatValue.substring(0,sConcatValue.indexOf("$")+1); 
                        
                // date
                sDate = sChild.substring(0,sChild.indexOf("|"));
                sChild = sChild.substring(sChild.indexOf("|")+1); 
                if(sDate.length() > 0){
                    planElem.addElement("Date").setText(sDate);
                }
                
                // capital
                sCapital = sChild.substring(0,sChild.indexOf("|")); 
                sChild = sChild.substring(sChild.indexOf("|")+1);
                if(sCapital.length() > 0){
                    planElem.addElement("Capital").setText(sCapital);
                }
                
                // interest
                sInterest = sChild.substring(0,sChild.indexOf("$"));  
                if(sInterest.length() > 0){
                    planElem.addElement("Interest").setText(sInterest);
                }
                
                // remaining childs
                sConcatValue = sConcatValue.substring(sConcatValue.indexOf("$")+1);
            }
            
            Debug.println("\n"+rpElem.asXML()+"\n");
            
            sXML = rpElem.asXML();
        }
        
        return sXML;
    }

    //--- GAINS TO XML ----------------------------------------------------------------------------
    /*
        sConcatValue : date|value$ -->
        
        <Gains>
            <Gain>
                <Date>01/05/2013</Date>
                <Value>20000</Value>
            </Gain>
        </Gains>
    */
    private String gainsToXML(String sConcatValue){
        String sXML = "";
        
        if(sConcatValue.length() > 0){           
            org.dom4j.Document document = DocumentHelper.createDocument();
            Element rpElem = document.addElement("Gains"); 
              
            String sChild, sDate, sValue;
            while(sConcatValue.indexOf("$") > -1){
                Element planElem = rpElem.addElement("Gain"); 
                
                sChild = sConcatValue.substring(0,sConcatValue.indexOf("$")+1); 
                        
                // date
                sDate = sChild.substring(0,sChild.indexOf("|"));
                sChild = sChild.substring(sChild.indexOf("|")+1); 
                if(sDate.length() > 0){
                    planElem.addElement("Date").setText(sDate);
                }
                
                // capital
                sValue = sChild.substring(0,sChild.indexOf("$")); 
                sChild = sChild.substring(sChild.indexOf("$")+1);
                if(sValue.length() > 0){
                    planElem.addElement("Value").setText(sValue);
                }
                                
                // remaining childs
                sConcatValue = sConcatValue.substring(sConcatValue.indexOf("$")+1);
            }
            
            Debug.println("\n"+rpElem.asXML()+"\n");
            
            sXML = rpElem.asXML();
        }
        
        return sXML;
    }

    //--- LOSSES TO XML ---------------------------------------------------------------------------
    /*
        sConcatValue : date|value$ -->
        
        <Losses>
            <Loss>
                <Date>01/05/2013</Date>
                <Value>20000</Value>
            </Loss>
        </Losses>
    */
    private String lossesToXML(String sConcatValue){
        String sXML = "";
        
        if(sConcatValue.length() > 0){           
            org.dom4j.Document document = DocumentHelper.createDocument();
            Element rpElem = document.addElement("Losses"); 
              
            String sChild, sDate, sValue;
            while(sConcatValue.indexOf("$") > -1){
                Element planElem = rpElem.addElement("Loss"); 
                
                sChild = sConcatValue.substring(0,sConcatValue.indexOf("$")+1); 
                        
                // date
                sDate = sChild.substring(0,sChild.indexOf("|"));
                sChild = sChild.substring(sChild.indexOf("|")+1); 
                if(sDate.length() > 0){
                    planElem.addElement("Date").setText(sDate);
                }
                
                // capital
                sValue = sChild.substring(0,sChild.indexOf("$")); 
                sChild = sChild.substring(sChild.indexOf("$")+1);
                if(sValue.length() > 0){
                    planElem.addElement("Value").setText(sValue);
                }
                                
                // remaining childs
                sConcatValue = sConcatValue.substring(sConcatValue.indexOf("$")+1);
            }
            
            Debug.println("\n"+rpElem.asXML()+"\n");
            
            sXML = rpElem.asXML();
        }
        
        return sXML;
    }
%>

<%
    String sEditAssetUID = checkString(request.getParameter("EditAssetUID"));

    String sCode          = checkString(request.getParameter("code")),
           sGMDNCode      = checkString(request.getParameter("gmdncode")),
           sNomenclature  = checkString(request.getParameter("nomenclature")),
           sParentUID     = checkString(request.getParameter("parentUID")),
           sDescription   = checkString(request.getParameter("description")),
           sSerialnumber  = checkString(request.getParameter("serialnumber")),
           sQuantity      = checkString(request.getParameter("quantity")),
           sAssetType     = checkString(request.getParameter("assetType")),
           sSupplierUID   = checkString(request.getParameter("supplierUID")),           
           sPurchaseDate  = checkString(request.getParameter("purchaseDate")),
           sPurchasePrice = checkString(request.getParameter("purchasePrice")),
           sReceiptBy     = checkString(request.getParameter("receiptBy")),
           sPurchaseDocuments = checkString(request.getParameter("purchaseDocuments")),
           sWriteOffMethod    = checkString(request.getParameter("writeOffMethod")),
           sWriteOffPeriod    = checkString(request.getParameter("writeOffPeriod")),
           sAnnuity           = checkString(request.getParameter("annuity")),
           sCharacteristics   = checkString(request.getParameter("characteristics")),
           sAccountingCode    = checkString(request.getParameter("accountingCode")),
           sGains             = checkString(request.getParameter("gains")),
           sLosses            = checkString(request.getParameter("losses")),
           sLockedBy            = checkString(request.getParameter("lockedby")),
           sComment1            = checkString(request.getParameter("comment1")),
           sComment2            = checkString(request.getParameter("comment2")),
           sComment3            = checkString(request.getParameter("comment3")),
           sComment4            = checkString(request.getParameter("comment4")),
           sComment5            = checkString(request.getParameter("comment5")),
           sComment6            = checkString(request.getParameter("comment6")),
           sComment7            = checkString(request.getParameter("comment7")),
           sComment8            = checkString(request.getParameter("comment8")),
           sComment9            = checkString(request.getParameter("comment9")),
           sComment10            = checkString(request.getParameter("comment10")),
           sComment11            = checkString(request.getParameter("comment11")),
           sComment12            = checkString(request.getParameter("comment12")),
           sComment13            = checkString(request.getParameter("comment13")),
           sComment14            = checkString(request.getParameter("comment14")),
           sComment15            = checkString(request.getParameter("comment15")),
           sComment16            = checkString(request.getParameter("comment16")),
           sComment17            = checkString(request.getParameter("comment17")),
           sComment18            = checkString(request.getParameter("comment18")),
           sComment19            = checkString(request.getParameter("comment19")),
           sComment20            = checkString(request.getParameter("comment20")),
           sServiceUid           = checkString(request.getParameter("serviceuid")),

           //*** loan ***
           sLoanDate                = checkString(request.getParameter("loanDate")),
           sLoanAmount              = checkString(request.getParameter("loanAmount")),
           sLoanInterestRate        = checkString(request.getParameter("loanInterestRate")),
           sLoanReimbursementPlan   = checkString(request.getParameter("loanReimbursementPlan")),
           sLoanReimbursementAmount = checkString(request.getParameter("loanReimbursementAmount")),
           sLoanComment             = checkString(request.getParameter("loanComment")),
           sLoanDocuments           = checkString(request.getParameter("loanDocuments")),
                                                           
           sSaleDate   = checkString(request.getParameter("saleDate")),
           sSaleValue  = checkString(request.getParameter("saleValue")),
           sSaleClient = checkString(request.getParameter("saleClient"));
           
    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n******************* assets/ajax/asset/saveAsset.jsp *******************");
        Debug.println("sEditAssetUID      : "+sEditAssetUID);
        Debug.println("sCode              : "+sCode);
        Debug.println("sGMDN              : "+sGMDNCode);
        Debug.println("sParentUID         : "+sParentUID);
        Debug.println("sDescription       : "+sDescription);
        Debug.println("sSerialnumber      : "+sSerialnumber);
        Debug.println("sQuantity          : "+sQuantity);
        Debug.println("sAssetType         : "+sAssetType);
        Debug.println("sSupplierUID       : "+sSupplierUID);
        Debug.println("sPurchaseDate      : "+sPurchaseDate);
        Debug.println("sPurchasePrice     : "+sPurchasePrice);
        Debug.println("sReceiptBy         : "+sReceiptBy);
        Debug.println("sPurchaseDocuments : "+sPurchaseDocuments);
        Debug.println("sWriteOffMethod    : "+sWriteOffMethod);
        Debug.println("sWriteOffPeriod    : "+sWriteOffPeriod);
        Debug.println("sAnnuity           : "+sAnnuity);
        Debug.println("sCharacteristics   : "+sCharacteristics);
        Debug.println("sAccountingCode    : "+sAccountingCode);
        Debug.println("sGains             : "+sGains);
        Debug.println("sLosses            : "+sLosses);
        Debug.println("sComment1          : "+sComment1);
        Debug.println("sComment2          : "+sComment2);
        Debug.println("sComment3          : "+sComment3);
        Debug.println("sComment4          : "+sComment4);
        Debug.println("sComment5          : "+sComment5);
        Debug.println("sComment6          : "+sComment6);
        Debug.println("sComment7          : "+sComment7);
        Debug.println("sComment8          : "+sComment8);
        Debug.println("sComment9          : "+sComment9);
        Debug.println("sComment10          : "+sComment10);
        Debug.println("sComment11          : "+sComment11);
        Debug.println("sComment12          : "+sComment12);
        Debug.println("sComment13          : "+sComment13);
        Debug.println("sComment14          : "+sComment14);
        Debug.println("sComment15          : "+sComment15);
        Debug.println("sComment16          : "+sComment16);
        Debug.println("sComment17          : "+sComment17);
        Debug.println("sComment18          : "+sComment18);
        Debug.println("sComment19          : "+sComment19);
        Debug.println("sComment20          : "+sComment20);
        Debug.println("sServiceUid         : "+sServiceUid);
        
        //*** loan ***
        Debug.println("loanDate                : "+sLoanDate);
        Debug.println("loanAmount              : "+sLoanAmount);
        Debug.println("loanInterestRate        : "+sLoanInterestRate);
        Debug.println("loanReimbursementPlan   : "+sLoanReimbursementPlan);
        Debug.println("loanReimbursementAmount : "+sLoanReimbursementAmount);
        Debug.println("loanComment             : "+sLoanComment);
        Debug.println("loanDocuments           : "+sLoanDocuments);

        Debug.println("saleDate           : "+sSaleDate);
        Debug.println("saleValue          : "+sSaleValue);
        Debug.println("saleClient         : "+sSaleClient+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////


    Asset asset = new Asset();
    String sMessage = "";
    
    if(sEditAssetUID.length() > 0 ){
        asset = Asset.get(sEditAssetUID);
    }
    else{
        asset.setUid("-1");
        asset.setCreateDateTime(getSQLTime());
    }

    // set dates
    if(sPurchaseDate.length() > 0){
        asset.purchaseDate = ScreenHelper.parseDate(sPurchaseDate);
    }
    if(sLoanDate.length() > 0){
        asset.loanDate = ScreenHelper.parseDate(sLoanDate);
    }
    if(sSaleDate.length() > 0){
        asset.saleDate = ScreenHelper.parseDate(sSaleDate);
    }

    asset.code = sCode;
    asset.gmdncode = sGMDNCode;
    asset.supplierUid = sParentUID;
    sDescription = sDescription.replaceAll("\r","");
    sDescription = sDescription.replaceAll("\r\n","<br>");
    asset.description = sDescription.replaceAll("\n","<br>");
    try{
    	asset.lockedBy=Integer.parseInt(sLockedBy);
    }
    catch(Exception e){
    	asset.lockedBy=-1;
    }
    
    asset.serialnumber = sSerialnumber;
    if(sQuantity.length() > 0){
        asset.quantity = Double.parseDouble(sQuantity);
    }
    asset.assetType = sAssetType;
    asset.supplierUid = sSupplierUID;
    if(sPurchasePrice.length() > 0){
        asset.purchasePrice = Double.parseDouble(sPurchasePrice);
    }
    asset.receiptBy = sReceiptBy;
    asset.purchaseDocuments = sPurchaseDocuments;
    asset.writeOffMethod = sWriteOffMethod;
    if(sWriteOffPeriod.length() > 0){
        asset.writeOffPeriod = Integer.parseInt(sWriteOffPeriod);
    }
    asset.annuity = sAnnuity;
    
    sCharacteristics = sCharacteristics.replaceAll("\r","");
    sCharacteristics = sCharacteristics.replaceAll("\r\n","<br>");
    asset.characteristics = sCharacteristics.replaceAll("\n","<br>");
    asset.accountingCode = sAccountingCode;
    
    asset.gains = sGains;
    asset.gains = gainsToXML(sGains);
    asset.losses = sLosses;
    asset.losses = lossesToXML(sLosses);
    
    //*** loan ***
    if(sLoanAmount.length() > 0){
        asset.loanAmount = Double.parseDouble(sLoanAmount);
    }
    
    if(sLoanInterestRate.length() > 0){
        asset.loanInterestRate = sLoanInterestRate;
    }
    asset.loanReimbursementPlan = reimbursementPlanToXML(sLoanReimbursementPlan);
    
    /* // --> calculated
    if(sLoanReimbursementAmount.length() > 0){
        asset.loanReimbursementAmount = Integer.parseInt(sLoanReimbursementAmount);
    }
    */

    sLoanComment = sLoanComment.replaceAll("\r","");
    sLoanComment = sLoanComment.replaceAll("\r\n","<br>");
    asset.loanComment = sLoanComment.replaceAll("\n","<br>");
    asset.loanDocuments = sLoanDocuments;
    
    if(sSaleValue.length() > 0){
        asset.saleValue = Double.parseDouble(sSaleValue);
    } 
    sSaleClient = sSaleClient.replaceAll("\r",""); 
    sSaleClient = sSaleClient.replaceAll("\r\n","<br>");
    asset.saleClient = sSaleClient.replaceAll("\n","<br>");      
    
    asset.setUpdateDateTime(ScreenHelper.getSQLDate(getDate()));
    asset.setUpdateUser(activeUser.userid);
	asset.setNomenclature(sNomenclature);
    asset.setComment1(sComment1);
    asset.setComment2(sComment2);
    asset.setComment3(sComment3);
    asset.setComment4(sComment4);
    asset.setComment5(sComment5);
    asset.setComment6(sComment6);
    asset.setComment7(sComment7);
    asset.setComment8(sComment8);
    asset.setComment9(sComment9);
    asset.setComment10(sComment10);
    asset.setComment11(sComment11);
    asset.setComment12(sComment12);
    asset.setComment13(sComment13);
    asset.setComment14(sComment14);
    asset.setComment15(sComment15);
    asset.setComment16(sComment16);
    asset.setComment17(sComment17);
    asset.setComment18(sComment18);
    asset.setComment19(sComment19);
    asset.setComment20(sComment20);
    asset.setServiceuid(sServiceUid);
    
    boolean errorOccurred = asset.store(activeUser.userid);
    
    if(!errorOccurred){
    	//initialize maintenance plans if new asset
    	if(SH.ci("loadDefaultMaintenancePlansForNewAsset",0)==1 && checkString(request.getParameter("newasset")).equals("1")){
    		asset.setDefaultMaintenancePlans();
    	}
        sMessage = "<font color='green'>"+getTranNoLink("web","dataIsSaved",sWebLanguage)+"</font>";
    }
    else{
        sMessage = "<font color='red'>"+getTranNoLink("web","error",sWebLanguage)+"</font>";
    }
%>

{
  "message":"<%=HTMLEntities.htmlentities(sMessage)%>",
  "newUID":"<%=asset.getUid()%>"
}