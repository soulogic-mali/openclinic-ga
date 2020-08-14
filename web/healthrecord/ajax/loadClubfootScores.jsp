<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String tranid=checkString(request.getParameter("tranid"));
	String rhf=checkString(request.getParameter("rhf"));
	String rmf=checkString(request.getParameter("rmf"));
	String lhf=checkString(request.getParameter("lhf"));
	String lmf=checkString(request.getParameter("lmf"));
	
	String rightHindfoot="",rightMidfoot="",rightTotal="",leftHindfoot="",leftMidfoot="",leftTotal="", dates="";
	double rh,rm,lh,lm;
	//Find all clubfootdata for this patient
	Vector transactions = MedwanQuery.getInstance().getTransactionsByType(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_CCBRT_CLUBFOOT");
	if(transactions.size()>0){
		TransactionVO transaction = (TransactionVO)transactions.elementAt(0);
		dates=ScreenHelper.formatDate(transaction.getUpdateTime());
		try{
			//Calculate right hindfoot score
			if((transaction.getServerId()+"."+transaction.getTransactionId()).equalsIgnoreCase(tranid)){
				rh=Double.parseDouble(rhf);
			}
			else{
				rh=Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_PC"))+Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_RE"))+Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_EH"));
			}
			rightHindfoot=""+rh;
		}
		catch(Exception e){
			rh=-1;
			rightHindfoot="-1";
		}
		try{
			//Calculate right midfoot score
			if((transaction.getServerId()+"."+transaction.getTransactionId()).equalsIgnoreCase(tranid)){
				rm=Double.parseDouble(rmf);
			}
			else{
				rm=Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_CLB"))+Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_MC"))+Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_LHT"));
			}
			rightMidfoot=""+rm;
		}
		catch(Exception e){
			rm=-1;
			rightMidfoot="-1";
		}
		//Calculate right total score
		if(rh>-1 && rm>-1){
			rightTotal=""+(rm+rh);
		}
		else{
			rightTotal="-1";
		}
		try{
			//Calculate left hindfoot score
			if((transaction.getServerId()+"."+transaction.getTransactionId()).equalsIgnoreCase(tranid)){
				lh=Double.parseDouble(lhf);
			}
			else{
				lh=Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_PC"))+Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_RE"))+Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_EH"));
			}
			leftHindfoot=""+lh;
		}
		catch(Exception e){
			lh=-1;
			leftHindfoot="-1";
		}
		try{
			//Calculate left midfoot score
			if((transaction.getServerId()+"."+transaction.getTransactionId()).equalsIgnoreCase(tranid)){
				lm=Double.parseDouble(lmf);
			}
			else{
				lm=Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_CLB"))+Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_MC"))+Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_LHT"));
			}
			leftMidfoot=""+lm;
		}
		catch(Exception e){
			lm=-1;
			leftMidfoot="-1";
		}
		//Calculate left total score
		if(lh>-1 && lm>-1){
			leftTotal=""+(lm+lh);
		}
		else{
			leftTotal="-1";
		}
		long day=24*3600*1000;
		transactions = MedwanQuery.getInstance().getTransactionsByTypeBetween(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_CCBRT_CLUBFOOT_FOLLOWUP",transaction.getUpdateTime(),new java.util.Date(new java.util.Date().getTime()+day));
		if(transactions.size()>0){
			Collections.reverse(transactions);
			for(int n=0;n<transactions.size();n++){
				transaction = (TransactionVO)transactions.elementAt(n);
				dates+=";"+ScreenHelper.formatDate(transaction.getUpdateTime());
				try{
					//Calculate right hindfoot score
					if((transaction.getServerId()+"."+transaction.getTransactionId()).equalsIgnoreCase(tranid)){
						rh=Double.parseDouble(rhf);
					}
					else{
						rh=Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_PC"))+Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_RE"))+Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_EH"));
					}
					rightHindfoot+=";"+rh;
				}
				catch(Exception e){
					rh=-1;
					rightHindfoot+=";-1";
				}
				try{
					//Calculate right midfoot score
					if((transaction.getServerId()+"."+transaction.getTransactionId()).equalsIgnoreCase(tranid)){
						rm=Double.parseDouble(rmf);
					}
					else{
						rm=Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_CLB"))+Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_MC"))+Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_RIGHT_LHT"));
					}
					rightMidfoot+=";"+rm;
				}
				catch(Exception e){
					rm=-1;
					rightMidfoot+=";-1";
				}
				//Calculate right total score
				if(rh>-1 && rm>-1){
					rightTotal+=";"+(rm+rh);
				}
				else{
					rightTotal+=";-1";
				}
				try{
					//Calculate right hindfoot score
					if((transaction.getServerId()+"."+transaction.getTransactionId()).equalsIgnoreCase(tranid)){
						lh=Double.parseDouble(lhf);
					}
					else{
						lh=Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_PC"))+Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_RE"))+Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_EH"));
					}
					leftHindfoot+=";"+lh;
				}
				catch(Exception e){
					lh=-1;
					leftHindfoot+=";-1";
				}
				try{
					//Calculate right midfoot score
					if((transaction.getServerId()+"."+transaction.getTransactionId()).equalsIgnoreCase(tranid)){
						lm=Double.parseDouble(lmf);
					}
					else{
						lm=Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_CLB"))+Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_MC"))+Double.parseDouble(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CLUBFOOT_LEFT_LHT"));
					}
					leftMidfoot+=";"+lm;
				}
				catch(Exception e){
					lm=-1;
					leftMidfoot+=";-1";
				}
				//Calculate right total score
				if(lh>-1 && lm>-1){
					leftTotal+=";"+(lm+lh);
				}
				else{
					leftTotal+=";-1";
				}
			}
		}
		if(tranid.contains("-")){
			try{
				rh=Double.parseDouble(rhf);
				rightHindfoot+=";"+rh;
			}
			catch(Exception e){
				rh=-1;
				rightHindfoot+=";-1";
			}
			try{
				rm=Double.parseDouble(rmf);
				rightMidfoot+=";"+rm;
			}
			catch(Exception e){
				rm=-1;
				rightMidfoot+=";-1";
			}
			//Calculate right total score
			if(rh>-1 && rm>-1){
				rightTotal+=";"+(rm+rh);
			}
			else{
				rightTotal+=";-1";
			}
			try{
				lh=Double.parseDouble(lhf);
				leftHindfoot+=";"+lh;
			}
			catch(Exception e){
				lh=-1;
				leftHindfoot+=";-1";
			}
			try{
				lm=Double.parseDouble(lmf);
				leftMidfoot+=";"+lm;
			}
			catch(Exception e){
				lm=-1;
				leftMidfoot+=";-1";
			}
			//Calculate right total score
			if(lh>-1 && lm>-1){
				leftTotal+=";"+(lm+lh);
			}
			else{
				leftTotal+=";-1";
			}
			dates+=";"+ScreenHelper.formatDate(new java.util.Date());
		}
	}
%>
{
	"rightHindfoot":"<%=rightHindfoot %>",
	"rightMidfoot":"<%=rightMidfoot %>",
	"rightTotal":"<%=rightTotal %>",
	"leftHindfoot":"<%=leftHindfoot %>",
	"leftMidfoot":"<%=leftMidfoot %>",
	"leftTotal":"<%=leftTotal %>",
	"dates":"<%=dates %>",
}
