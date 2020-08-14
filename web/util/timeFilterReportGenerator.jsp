<%@page import="be.mxs.common.util.system.Miscelaneous"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	boolean evaluateString(Element value,String s,SortedMap rows,Object rowid){
		s=ScreenHelper.checkString(s);
		if(value.attributeValue("compare").equalsIgnoreCase("equals")){
			if(value.attributeValue("type").equalsIgnoreCase("constant")){
				return s.equalsIgnoreCase(value.getText());
			}
			else if(value.attributeValue("type").equalsIgnoreCase("config")){
				return s.equalsIgnoreCase(MedwanQuery.getInstance().getConfigString(value.getText(),checkString(value.attributeValue("default"))));
			}
			else{
				return s.equalsIgnoreCase((String)((Hashtable)rows.get(rowid)).get(value.getText()));
			}
		}
		else if(value.attributeValue("compare").equalsIgnoreCase("notequals")){
			if(value.attributeValue("type").equalsIgnoreCase("constant")){
				return !s.equalsIgnoreCase(value.getText());
			}
			else if(value.attributeValue("type").equalsIgnoreCase("config")){
				return !s.equalsIgnoreCase(MedwanQuery.getInstance().getConfigString(value.getText(),checkString(value.attributeValue("default"))));
			}
			else{
				return !s.equalsIgnoreCase((String)((Hashtable)rows.get(rowid)).get(value.getText()));
			}
		}
		else if(value.attributeValue("compare").equalsIgnoreCase("contains")){
			if(value.attributeValue("type").equalsIgnoreCase("constant")){
				return s.contains(value.getText());
			}
			else if(value.attributeValue("type").equalsIgnoreCase("config")){
				return s.contains(MedwanQuery.getInstance().getConfigString(value.getText(),checkString(value.attributeValue("default"))));
			}
			else{
				return s.contains((String)((Hashtable)rows.get(rowid)).get(value.getText()));
			}
		}
		else if(value.attributeValue("compare").equalsIgnoreCase("notcontains")){
			if(value.attributeValue("type").equalsIgnoreCase("constant")){
				return !s.contains(value.getText());
			}
			else if(value.attributeValue("type").equalsIgnoreCase("config")){
				return !s.contains(MedwanQuery.getInstance().getConfigString(value.getText(),checkString(value.attributeValue("default"))));
			}
			else{
				return !s.contains((String)((Hashtable)rows.get(rowid)).get(value.getText()));
			}
		}
		else if(value.attributeValue("compare").equalsIgnoreCase("in")){
			boolean bReturn = false;
			if(value.attributeValue("type").equalsIgnoreCase("config")){
				String elements[] = MedwanQuery.getInstance().getConfigString(value.getText(),checkString(value.attributeValue("default"))).split(";");
				for(int n=0;n<elements.length;n++){
					if(elements[n].equalsIgnoreCase(s)){
						bReturn = true;
						break;
					}
				}
			}
			else{
				Iterator elements = value.elementIterator("element");
				while(elements.hasNext()){
					Element element = (Element)elements.next();
					if(element.getText().equalsIgnoreCase(s)){
						bReturn = true;
						break;
					}
				}
			}
			return bReturn;
		}
		else{
			return true;
		}
	}

	boolean evaluateInt(Element value,String s,SortedMap rows,Object rowid){
		s=ScreenHelper.checkString(s);
		try{
			if(value.attributeValue("compare").equalsIgnoreCase("equals")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return Integer.parseInt(s)==Integer.parseInt(value.getText());
				}
				else if(value.attributeValue("type").equalsIgnoreCase("config")){
					return Integer.parseInt(s)==MedwanQuery.getInstance().getConfigInt(value.getText(),Integer.parseInt(value.attributeValue("default")));
				}
				else{
					return Integer.parseInt(s)==Integer.parseInt(((String)((Hashtable)rows.get(rowid)).get(value.getText())));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("notequals")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return Integer.parseInt(s)!=Integer.parseInt(value.getText());
				}
				else if(value.attributeValue("type").equalsIgnoreCase("config")){
					return Integer.parseInt(s)!=MedwanQuery.getInstance().getConfigInt(value.getText(),Integer.parseInt(value.attributeValue("default")));
				}
				else{
					return Integer.parseInt(s)!=Integer.parseInt(((String)((Hashtable)rows.get(rowid)).get(value.getText())));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("greaterthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return Integer.parseInt(s)>Integer.parseInt(value.getText());
				}
				else if(value.attributeValue("type").equalsIgnoreCase("config")){
					return Integer.parseInt(s)>MedwanQuery.getInstance().getConfigInt(value.getText(),Integer.parseInt(value.attributeValue("default")));
				}
				else{
					return Integer.parseInt(s)>Integer.parseInt(((String)((Hashtable)rows.get(rowid)).get(value.getText())));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("smallerthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return Integer.parseInt(s)<Integer.parseInt(value.getText());
				}
				else if(value.attributeValue("type").equalsIgnoreCase("config")){
					return Integer.parseInt(s)<MedwanQuery.getInstance().getConfigInt(value.getText(),Integer.parseInt(value.attributeValue("default")));
				}
				else{
					return Integer.parseInt(s)<Integer.parseInt(((String)((Hashtable)rows.get(rowid)).get(value.getText())));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("equalsorsmallerthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return Integer.parseInt(s)<=Integer.parseInt(value.getText());
				}
				else if(value.attributeValue("type").equalsIgnoreCase("config")){
					return Integer.parseInt(s)<=MedwanQuery.getInstance().getConfigInt(value.getText(),Integer.parseInt(value.attributeValue("default")));
				}
				else{
					return Integer.parseInt(s)<=Integer.parseInt(((String)((Hashtable)rows.get(rowid)).get(value.getText())));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("equalsorgreaterthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return Integer.parseInt(s)>=Integer.parseInt(value.getText());
				}
				else if(value.attributeValue("type").equalsIgnoreCase("config")){
					return Integer.parseInt(s)>=MedwanQuery.getInstance().getConfigInt(value.getText(),Integer.parseInt(value.attributeValue("default")));
				}
				else{
					return Integer.parseInt(s)>=Integer.parseInt(((String)((Hashtable)rows.get(rowid)).get(value.getText())));
				}
			}
			else{
				return true;
			}
		}
		catch(Exception e){
			//e.printStackTrace();
			return false;
		}
	}
	
	boolean evaluateDate(Element value,java.util.Date d,SortedMap rows,Object rowid,java.util.Date dateConstant){
		try{
			if(value.attributeValue("compare").equalsIgnoreCase("equals")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return d.equals(dateConstant);
				}
				else{
					return d.equals((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("notequals")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return !d.equals(dateConstant);
				}
				else{
					return !d.equals((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("greaterthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return d.after(dateConstant);
				}
				else{
					return d.after((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("smallerthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return d.before(dateConstant);
				}
				else{
					return d.before((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("equalsorsmallerthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return !d.after(dateConstant);
				}
				else{
					return !d.after((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("equalsorgreaterthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return !d.before(dateConstant);
				}
				else{
					return !d.before((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else{
				return true;
			}
		}
		catch(Exception e){
			//e.printStackTrace();
			return false;
		}
	}
	
	boolean evaluateDuration(Element value,java.util.Date dBegin,java.util.Date dEnd,SortedMap rows,Object rowid){
		long day = 24*3600*1000;
		try{
			if(value.attributeValue("compare").equalsIgnoreCase("equals")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return dEnd.getTime()-dBegin.getTime()==Integer.parseInt(value.getText());
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("notequals")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return dEnd.getTime()-dBegin.getTime()!=Integer.parseInt(value.getText());
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("greaterthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return dEnd.getTime()-dBegin.getTime()>Integer.parseInt(value.getText());
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("smallerthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return dEnd.getTime()-dBegin.getTime()<Integer.parseInt(value.getText());
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("equalsorsmallerthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return dEnd.getTime()-dBegin.getTime()<=Integer.parseInt(value.getText());
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("equalsorgreaterthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return dEnd.getTime()-dBegin.getTime()>=Integer.parseInt(value.getText());
				}
			}
			else{
				return true;
			}
		}
		catch(Exception e){
			//e.printStackTrace();
			return false;
		}
		return true;
	}
	
	boolean evaluateDateReverse(Element value,java.util.Date d,SortedMap rows,Object rowid,java.util.Date dateConstant){
		try{
			if(value.attributeValue("compare").equalsIgnoreCase("equals")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return d.equals(dateConstant);
				}
				else{
					return d.equals((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("notequals")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return !d.equals(dateConstant);
				}
				else{
					return !d.equals((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("greaterthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return !d.after(dateConstant);
				}
				else{
					return !d.after((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("smallerthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return !d.before(dateConstant);
				}
				else{
					return !d.before((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("equalsorsmallerthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return d.after(dateConstant);
				}
				else{
					return d.after((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("equalsorgreaterthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return d.before(dateConstant);
				}
				else{
					return d.before((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else{
				return true;
			}
		}
		catch(Exception e){
			//e.printStackTrace();
			return false;
		}
	}
	
	boolean evaluateDate(Element value,java.util.Date d,SortedMap rows,Object rowid){
		try{
			if(value.attributeValue("compare").equalsIgnoreCase("equals")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return d.equals(ScreenHelper.parseDate(value.getText()));
				}
				else{
					return d.equals((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("notequals")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return !d.equals(ScreenHelper.parseDate(value.getText()));
				}
				else{
					return !d.equals((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("greaterthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return d.after(ScreenHelper.parseDate(value.getText()));
				}
				else{
					return d.after((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("smallerthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return d.before(ScreenHelper.parseDate(value.getText()));
				}
				else{
					return d.before((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("equalsorsmallerthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return !d.after(ScreenHelper.parseDate(value.getText()));
				}
				else{
					return !d.after((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("equalsorgreaterthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return !d.before(ScreenHelper.parseDate(value.getText()));
				}
				else{
					return !d.before((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else{
				return true;
			}
		}
		catch(Exception e){
			//e.printStackTrace();
			return false;
		}
	}
	
	boolean evaluateDateReverse(Element value,java.util.Date d,SortedMap rows,Object rowid){
		try{
			if(value.attributeValue("compare").equalsIgnoreCase("equals")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return d.equals(ScreenHelper.parseDate(value.getText()));
				}
				else{
					return d.equals((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("notequals")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return !d.equals(ScreenHelper.parseDate(value.getText()));
				}
				else{
					return !d.equals((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("greaterthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return !d.after(ScreenHelper.parseDate(value.getText()));
				}
				else{
					return !d.after((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("smallerthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return !d.before(ScreenHelper.parseDate(value.getText()));
				}
				else{
					return !d.before((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("equalsorsmallerthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return d.after(ScreenHelper.parseDate(value.getText()));
				}
				else{
					return d.after((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else if(value.attributeValue("compare").equalsIgnoreCase("equalsorgreaterthan")){
				if(value.attributeValue("type").equalsIgnoreCase("constant")){
					return d.before(ScreenHelper.parseDate(value.getText()));
				}
				else{
					return d.before((java.util.Date)((Hashtable)rows.get(rowid)).get(value.getText()));
				}
			}
			else{
				return true;
			}
		}
		catch(Exception e){
			//e.printStackTrace();
			return false;
		}
	}
	
	void addParameter(Element value, Vector parameters, Hashtable variables){
		if(value.attributeValue("type").equalsIgnoreCase("constant")){
			parameters.add(value.getText());
		}
		else if(value.attributeValue("type").equalsIgnoreCase("config")){
			parameters.add(MedwanQuery.getInstance().getConfigString(value.getText(),checkString(value.attributeValue("default"))));
		}
		else{
			parameters.add(variables.get(value.getText()));
		}
	}
	
	void setParameter(Object p, PreparedStatement ps, int n){
		try{
			if(p.getClass().getName().equalsIgnoreCase("java.sql.Date")){
				ps.setDate(n+1,(java.sql.Date)p);
			}
			else if(p.getClass().getName().equalsIgnoreCase("java.util.Date")){
				ps.setDate(n+1,new java.sql.Date(((java.util.Date)p).getTime()));
			}
			else if(p.getClass().getName().equalsIgnoreCase("java.lang.String")){
				ps.setString(n+1,(java.lang.String)p);
			}
			else if(p.getClass().getName().equalsIgnoreCase("java.lang.Integer")){
				ps.setInt(n+1,(java.lang.Integer)p);
			}
			else if(p.getClass().getName().equalsIgnoreCase("java.lang.Float")){
				ps.setFloat(n+1,(java.lang.Float)p);
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	String setSelectDate(Element value,String sSelect,Vector parameters,String fieldname,java.util.Date fieldvalue){
		if(value.attributeValue("compare").equalsIgnoreCase("equalsorgreaterthan")){
			sSelect+=" AND "+fieldname+" >= ?";
			parameters.add(fieldvalue);
		}
		else if(value.attributeValue("compare").equalsIgnoreCase("equalsorsmallerthan")){
			sSelect+=" AND "+fieldname+" <= ?";
			parameters.add(fieldvalue);
		}
		else if(value.attributeValue("compare").equalsIgnoreCase("greaterthan")){
			sSelect+=" AND "+fieldname+" > ?";
			parameters.add(fieldvalue);
		}
		else if(value.attributeValue("compare").equalsIgnoreCase("smallerthan")){
			sSelect+=" AND "+fieldname+" < ?";
			parameters.add(fieldvalue);
		}
		return sSelect;
	}
	
	String setSelectDateReverse(Element value,String sSelect,Vector parameters,String fieldname,java.util.Date fieldvalue){
		if(value.attributeValue("compare").equalsIgnoreCase("equalsorgreaterthan")){
			sSelect+=" AND "+fieldname+" < ?";
			parameters.add(fieldvalue);
		}
		else if(value.attributeValue("compare").equalsIgnoreCase("equalsorsmallerthan")){
			sSelect+=" AND "+fieldname+" > ?";
			parameters.add(fieldvalue);
		}
		else if(value.attributeValue("compare").equalsIgnoreCase("greaterthan")){
			sSelect+=" AND "+fieldname+" <= ?";
			parameters.add(fieldvalue);
		}
		else if(value.attributeValue("compare").equalsIgnoreCase("smallerthan")){
			sSelect+=" AND "+fieldname+" >= ?";
			parameters.add(fieldvalue);
		}
		return sSelect;
	}
	
	String setSelectInt(Element value,String sSelect,Vector parameters,String fieldname,Integer fieldvalue){
		if(value.attributeValue("compare").equalsIgnoreCase("equals")){
			sSelect+=" AND "+fieldname+" = ?";
			parameters.add(fieldvalue);
		}
		else if(value.attributeValue("compare").equalsIgnoreCase("notequals")){
			sSelect+=" AND "+fieldname+" <> ?";
			parameters.add(fieldvalue);
		}
		else if(value.attributeValue("compare").equalsIgnoreCase("equalsorgreaterthan")){
			sSelect+=" AND "+fieldname+" >= ?";
			parameters.add(fieldvalue);
		}
		else if(value.attributeValue("compare").equalsIgnoreCase("equalsorsmallerthan")){
			sSelect+=" AND "+fieldname+" <= ?";
			parameters.add(fieldvalue);
		}
		else if(value.attributeValue("compare").equalsIgnoreCase("greaterthan")){
			sSelect+=" AND "+fieldname+" > ?";
			parameters.add(fieldvalue);
		}
		else if(value.attributeValue("compare").equalsIgnoreCase("smallerthan")){
			sSelect+=" AND "+fieldname+" < ?";
			parameters.add(fieldvalue);
		}
		return sSelect;
	}
	
	String setSelectString(Element value,String sSelect,Vector parameters,String fieldname,String fieldvalue){
		if(value.attributeValue("compare").equalsIgnoreCase("equals")){
			sSelect+=" AND "+fieldname+" = ?";
			if(value.attributeValue("type").equalsIgnoreCase("config")){
				parameters.add(MedwanQuery.getInstance().getConfigString(fieldvalue,checkString(value.attributeValue("default"))));
			}
			else{
				parameters.add(fieldvalue);
			}
		}
		else if(value.attributeValue("compare").equalsIgnoreCase("like")){
			sSelect+=" AND "+fieldname+" like ?"+MedwanQuery.getInstance().concatSign()+"'%'";
			if(value.attributeValue("type").equalsIgnoreCase("config")){
				parameters.add(MedwanQuery.getInstance().getConfigString(fieldvalue,checkString(value.attributeValue("default"))));
			}
			else{
				parameters.add(fieldvalue);
			}
		}
		else if(value.attributeValue("compare").equalsIgnoreCase("contains")){
			sSelect+=" AND "+fieldname+" collate "+MedwanQuery.getInstance().getConfigString("collateCaseSensitive","Latin1_General_cs")+" like '%'"+MedwanQuery.getInstance().concatSign()+"?"+MedwanQuery.getInstance().concatSign()+"'%'";
			if(value.attributeValue("type").equalsIgnoreCase("config")){
				parameters.add(MedwanQuery.getInstance().getConfigString(fieldvalue,checkString(value.attributeValue("default"))));
			}
			else{
				parameters.add(fieldvalue);
			}
		}
		else if(value.attributeValue("compare").equalsIgnoreCase("notcontains")){
			sSelect+=" AND "+fieldname+" collate "+MedwanQuery.getInstance().getConfigString("collateCaseSensitive","Latin1_General_cs")+" not like '%'"+MedwanQuery.getInstance().concatSign()+"?"+MedwanQuery.getInstance().concatSign()+"'%'";
			if(value.attributeValue("type").equalsIgnoreCase("config")){
				parameters.add(MedwanQuery.getInstance().getConfigString(fieldvalue,checkString(value.attributeValue("default"))));
			}
			else{
				parameters.add(fieldvalue);
			}
		}
		else if(value.attributeValue("compare").equalsIgnoreCase("notequals")){
			sSelect+=" AND "+fieldname+" <> ?";
			if(value.attributeValue("type").equalsIgnoreCase("config")){
				parameters.add(MedwanQuery.getInstance().getConfigString(fieldvalue,checkString(value.attributeValue("default"))));
			}
			else{
				parameters.add(fieldvalue);
			}
		}
		else if(value.attributeValue("compare").equalsIgnoreCase("in")){
			sSelect+=" AND "+fieldname+" in ";
			String values = "";
			if(value.attributeValue("type").equalsIgnoreCase("config")){
				String elements[] = MedwanQuery.getInstance().getConfigString(value.getText(),checkString(value.attributeValue("default"))).split(";");
				for(int n=0;n<elements.length;n++){
					if(values.length()>0){
						values+=",";
					}
					values+="'"+elements[n]+"'";
				}
			}
			else{
				Iterator elements = value.elementIterator("element");
				while(elements.hasNext()){
					Element element = (Element)elements.next();
					if(values.length()>0){
						values+=",";
					}
					values+="'"+element.getText()+"'";
				}
			}
			sSelect+="("+values+")";
		}
		return sSelect;
	}
	
	String setSelectObjectId(Element value,String sSelect,Vector parameters,String fieldname,String fieldvalue){
		if(value.attributeValue("compare").equalsIgnoreCase("equals")){
			sSelect+=" AND "+fieldname+" = replace(?,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')";
			parameters.add(fieldvalue);
		}
		return sSelect;
	}
	
	String setSelectItemType(String type,String sSelect,Vector parameters){
		sSelect+=" AND type=?";
		parameters.add(type);
		return sSelect;
	}

	String setSelectItemValue(Element value,String sSelect,Vector parameters,SortedMap rows,Object rowid){
		if(value.attributeValue("compare").equalsIgnoreCase("equals")){
			sSelect+=" AND value=?";
			if(value.attributeValue("type").equalsIgnoreCase("constant")){
				parameters.add(value.getText());
			}
			else if(value.attributeValue("type").equalsIgnoreCase("config")){
				parameters.add(MedwanQuery.getInstance().getConfigString(value.getText(),checkString(value.attributeValue("default"))));
			}
			else{
				parameters.add(((Hashtable)rows.get(rowid)).get(value.getText()));
			}
		}
		else if(value.attributeValue("compare").equalsIgnoreCase("like")){
			sSelect+=" AND value like '%'"+MedwanQuery.getInstance().concatSign()+"?"+MedwanQuery.getInstance().concatSign()+"'%'";
			if(value.attributeValue("type").equalsIgnoreCase("constant")){
				parameters.add(value.getText());
			}
			else if(value.attributeValue("type").equalsIgnoreCase("config")){
				parameters.add(MedwanQuery.getInstance().getConfigString(value.getText(),checkString(value.attributeValue("default"))));
			}
			else{
				parameters.add(((Hashtable)rows.get(rowid)).get(value.getText()));
			}
		}
		return sSelect;
	}
%>
<table width='100%'>
<%
		long day=24*3600*1000;
		StringBuffer csvResults = new StringBuffer();
		String reportTemplate = checkString(request.getParameter("template"));
		String begin = checkString(request.getParameter("begin"));
		String end = ScreenHelper.formatDate(new java.util.Date(ScreenHelper.parseDate(checkString(request.getParameter("end"))).getTime()+day));
		
		
		//reportTemplate = MedwanQuery.getInstance().getConfigString("nationalReportTemplate","http://localhost/openclinic/_common/xml/senegalmonthlyreportPS.xml")+"?ts="+getTs();
		
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		SAXReader reader = new SAXReader(false);
		Document document = reader.read(new URL(reportTemplate));
		Element root = document.getRootElement();
		Iterator results = root.elementIterator("result");
		while(results.hasNext()){
			SortedMap rows = new TreeMap();
			Element result = (Element)results.next();
			if(result.attributeValue("type").equalsIgnoreCase("title")){
				out.println("<tr class='admin'><td colspan='2'>"+result.element("label").getText()+"</td></tr>");
				out.flush();
				csvResults.append(result.element("label").getText()+"\n");
			}
			else if(result.attributeValue("type").equalsIgnoreCase("subtitle")){
				out.println("<tr><td class='titleadmin' colspan='2'>"+result.element("label").getText()+"</td></tr>");
				out.flush();
				csvResults.append(result.element("label").getText()+"\n");
			}
			else if(result.attributeValue("type").equalsIgnoreCase("configvalue")){
				out.println("<tr><td class='titleadmin'>"+result.element("label").getText()+"</td><td>"+MedwanQuery.getInstance().getConfigString(result.element("label").getText(),result.element("label").attributeValue("default"))+"</td></tr>");
				out.flush();
			}
			else if(result.attributeValue("type").equalsIgnoreCase("value")){
				Element filter = result.element("filter");
				if(filter.attributeValue("type").equalsIgnoreCase("encounter")){
					//We must create a select query
					String sSelect="select sum("+MedwanQuery.getInstance().datediff("day", "oc_encounter_begindate", "oc_encounter_enddate")+") as duration from oc_encounters_view"+
								   " where 1=1";
					Vector parameters = new Vector();
					if(filter.attributeValue("periodfilter").equalsIgnoreCase("true")){
						sSelect+=" AND OC_ENCOUNTER_BEGINDATE>=?"+
								" AND OC_ENCOUNTER_BEGINDATE<?";
						parameters.add(new java.sql.Date(ScreenHelper.parseDate(begin).getTime()));
						parameters.add(new java.sql.Date(ScreenHelper.parseDate(end).getTime()));
					}
					//Also add extra select criteria
					Element selectElement = filter.element("select");
					Iterator selectfields = selectElement.elementIterator("field");
					while(selectfields.hasNext()){
						Element selectField = (Element)selectfields.next();
						if(selectField.attributeValue("name").equalsIgnoreCase("encountertype")){
							Element value = selectField.element("value");
							sSelect=setSelectString(value, sSelect, parameters, "OC_ENCOUNTER_TYPE", value.getText());
						}
						else if(selectField.attributeValue("name").equalsIgnoreCase("situation")){
							Element value = selectField.element("value");
							sSelect=setSelectString(value, sSelect, parameters, "OC_ENCOUNTER_SITUATION", value.getText());
						}
						else if(selectField.attributeValue("name").equalsIgnoreCase("outcome")){
							Element value = selectField.element("value");
							sSelect=setSelectString(value, sSelect, parameters, "OC_ENCOUNTER_OUTCOME", value.getText());
						}
						else if(selectField.attributeValue("name").equalsIgnoreCase("serviceuid")){
							System.out.println("1");
							Element value = selectField.element("value");
							sSelect=setSelectString(value, sSelect, parameters, "OC_ENCOUNTER_SERVICEUID", value.getText());
						}
						else if(selectField.attributeValue("name").equalsIgnoreCase("duration")){
							System.out.println("2");
							Element value = selectField.element("value");
							sSelect=setSelectInt(value, sSelect, parameters, MedwanQuery.getInstance().datediff("day", "OC_ENCOUNTER_BEGINDATE", "OC_ENCOUNTER_ENDDATE"), Integer.parseInt(value.getText()));
						}
						else if(selectField.attributeValue("name").equalsIgnoreCase("origin")){
							Element value = selectField.element("value");
							sSelect=setSelectString(value, sSelect, parameters, "OC_ENCOUNTER_ORIGIN", value.getText());
						}
					}
					System.out.println(sSelect);
					ps=conn.prepareStatement(sSelect);
					for(int n=0;n<parameters.size();n++){
						Object p = parameters.elementAt(n);
						setParameter(p, ps, n);
						System.out.println("parameter="+p);
					}
					rs=ps.executeQuery();
					if(rs.next()){
						if(filter.elementText("outputvalue").equalsIgnoreCase("duration")){
							out.println("<tr><td class='admin'>"+result.element("label").getText()+"</td><td class='admin2'>"+rs.getInt("duration")+"</td></tr>");
							out.flush();
							csvResults.append(result.element("label").getText()+";"+rs.getInt("duration")+"\n");
						}
					}
					rs.close();
					ps.close();
				}
				else if(filter.attributeValue("type").equalsIgnoreCase("income")){
					//We must create a select query
					String sSelect="select count(distinct oc_debet_encounteruid) total, sum(oc_debet_amount) as patientincome,"+
								   " sum(oc_debet_insuraramount) as insurerincome, "+
								   " sum(oc_debet_extrainsuraramount) as extrainsurerincome "+
								   " from oc_patientinvoices, oc_debets, oc_insurances "+
							       " where "+
								   " oc_patientinvoice_status='closed'"+
								   " and oc_insurance_objectid=replace(oc_debet_insuranceuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')"+
								   " and oc_debet_patientinvoiceuid='"+MedwanQuery.getInstance().getConfigString("serverId")+".'"+MedwanQuery.getInstance().concatSign()+"OC_PATIENTINVOICE_OBJECTID";
					Vector parameters = new Vector();
					if(filter.attributeValue("periodfilter").equalsIgnoreCase("true")){
						sSelect+=" AND OC_PATIENTINVOICE_DATE>=?"+
								" AND OC_PATIENTINVOICE_DATE<?";
						parameters.add(new java.sql.Date(ScreenHelper.parseDate(begin).getTime()));
						parameters.add(new java.sql.Date(ScreenHelper.parseDate(end).getTime()));
					}
					Element selectElement = filter.element("select");
					if(selectElement!=null){
						Iterator fields = selectElement.elementIterator("field");
						while(fields.hasNext()){
							Element field = (Element)fields.next();
							if(field.attributeValue("name").equalsIgnoreCase("insureruid")){
								Element value = field.element("value");
								sSelect=setSelectString(value, sSelect, parameters, "oc_insurance_insuraruid", value.getText());
							}
							else if(field.attributeValue("name").equalsIgnoreCase("extrainsureruid")){
								Element value = field.element("value");
								sSelect=setSelectString(value, sSelect, parameters, "oc_debet_extrainsuraruid", value.getText());
							}
							else if(field.attributeValue("name").equalsIgnoreCase("insureramount")){
								Element value = field.element("value");
								sSelect=setSelectInt(value, sSelect, parameters, "oc_debet_insuraramount", Integer.parseInt(value.getText()));
							}
							else if(field.attributeValue("name").equalsIgnoreCase("serviceuid")){
								Element value = field.element("value");
								sSelect=setSelectString(value, sSelect, parameters, "oc_debet_serviceuid", checkString(value.getText()));
							}
							else if(field.attributeValue("name").equalsIgnoreCase("patientamount")){
								Element value = field.element("value");
								sSelect=setSelectInt(value, sSelect, parameters, "oc_debet_amount", Integer.parseInt(value.getText()));
							}
						}
					}
					ps=conn.prepareStatement(sSelect);
					for(int n=0;n<parameters.size();n++){
						Object p = parameters.elementAt(n);
						setParameter(p, ps, n);
					}
					rs=ps.executeQuery();
					if(rs.next()){
						if(filter.elementText("outputvalue").equalsIgnoreCase("patientincome")){
							String income=new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#.00")).format(rs.getDouble("patientincome"));
							out.println("<tr><td class='admin'>"+result.element("label").getText()+"</td><td class='admin2'>"+income+"</td></tr>");
							out.flush();
							csvResults.append(result.element("label").getText()+";"+income+"\n");
						}
						else if(filter.elementText("outputvalue").equalsIgnoreCase("insurerincome")){
							String income=new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#.00")).format(rs.getDouble("insurerincome"));
							out.println("<tr><td class='admin'>"+result.element("label").getText()+"</td><td class='admin2'>"+income+"</td></tr>");
							out.flush();
							csvResults.append(result.element("label").getText()+";"+income+"\n");
						}
						else if(filter.elementText("outputvalue").equalsIgnoreCase("extrainsurerincome")){
							String income=new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#.00")).format(rs.getDouble("extrainsurerincome"));
							out.println("<tr><td class='admin'>"+result.element("label").getText()+"</td><td class='admin2'>"+income+"</td></tr>");
							out.flush();
							csvResults.append(result.element("label").getText()+";"+income+"\n");
						}
						else if(filter.elementText("outputvalue").equalsIgnoreCase("totalincome")){
							String income=new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#.00")).format(rs.getDouble("patientincome")+rs.getDouble("insurerincome")+rs.getDouble("extrainsurerincome"));
							out.println("<tr><td class='admin'>"+result.element("label").getText()+"</td><td class='admin2'>"+income+"</td></tr>");
							out.flush();
							csvResults.append(result.element("label").getText()+";"+income+"\n");
						}
						else if(filter.elementText("outputvalue").equalsIgnoreCase("count")){
							out.println("<tr><td class='admin'>"+result.element("label").getText()+"</td><td class='admin2'>"+rs.getString("total")+"</td></tr>");
							out.flush();
							csvResults.append(result.element("label").getText()+";"+rs.getString("total")+"\n");
						}
					}
					rs.close();
					ps.close();
				}
			}
			else if(result.attributeValue("type").equalsIgnoreCase("counter")){
				//Run through the different filters
				boolean bFirstFilter=true;
				Iterator filters = result.elementIterator("filter");
				while(filters.hasNext()){
					Element filter = (Element)filters.next();
					///////////////////////////////////////////////
					// Encounter filter
					///////////////////////////////////////////////
					if(filter.attributeValue("type").equalsIgnoreCase("encounter")){
						if(bFirstFilter){
							bFirstFilter=false;
							//We must create a select query
							String sSelect="select * from OC_ENCOUNTERS_VIEW where 1=1";
							Vector parameters = new Vector();
							if(filter.attributeValue("periodfilter").equalsIgnoreCase("true")){
								sSelect+=" AND OC_ENCOUNTER_BEGINDATE>=?"+
										" AND OC_ENCOUNTER_BEGINDATE<?";
								parameters.add(new java.sql.Date(ScreenHelper.parseDate(begin).getTime()));
								parameters.add(new java.sql.Date(ScreenHelper.parseDate(end).getTime()));
							}
							//Also add extra select criteria
							Element selectElement = filter.element("select");
							Iterator selectfields = selectElement.elementIterator("field");
							while(selectfields.hasNext()){
								Element selectField = (Element)selectfields.next();
								if(selectField.attributeValue("name").equalsIgnoreCase("encountertype")){
									Element value = selectField.element("value");
									sSelect=setSelectString(value, sSelect, parameters, "OC_ENCOUNTER_TYPE", value.getText());
								}
								else if(selectField.attributeValue("name").equalsIgnoreCase("situation")){
									Element value = selectField.element("value");
									sSelect=setSelectString(value, sSelect, parameters, "OC_ENCOUNTER_SITUATION", value.getText());
								}
								else if(selectField.attributeValue("name").equalsIgnoreCase("outcome")){
									Element value = selectField.element("value");
									sSelect=setSelectString(value, sSelect, parameters, "OC_ENCOUNTER_OUTCOME", value.getText());
								}
								else if(selectField.attributeValue("name").equalsIgnoreCase("serviceuid")){
									System.out.println("1");
									Element value = selectField.element("value");
									sSelect=setSelectString(value, sSelect, parameters, "OC_ENCOUNTER_SERVICEUID", value.getText());
								}
								else if(selectField.attributeValue("name").equalsIgnoreCase("duration")){
									System.out.println("2");
									Element value = selectField.element("value");
									sSelect=setSelectInt(value, sSelect, parameters, MedwanQuery.getInstance().datediff("day", "OC_ENCOUNTER_BEGINDATE", "OC_ENCOUNTER_ENDDATE"), Integer.parseInt(value.getText()));
								}
								else if(selectField.attributeValue("name").equalsIgnoreCase("origin")){
									Element value = selectField.element("value");
									sSelect=setSelectString(value, sSelect, parameters, "OC_ENCOUNTER_ORIGIN", value.getText());
								}
							}
							System.out.println(sSelect);
							ps=conn.prepareStatement(sSelect);
							for(int n=0;n<parameters.size();n++){
								Object p = parameters.elementAt(n);
								setParameter(p, ps, n);
								System.out.println("parameter="+p);
							}
							rs=ps.executeQuery();
							while(rs.next()){
								String uid = rs.getInt("OC_ENCOUNTER_SERVERID")+"."+rs.getInt("OC_ENCOUNTER_OBJECTID")+"."+rs.getString("OC_ENCOUNTER_SERVICEUID");
								boolean bMatch = true;
								//First we evaluate the criteria on each resulting row
								Iterator fields = filter.elementIterator("field");
								while(fields.hasNext()){
									Element field = (Element)fields.next();
									if(field.attributeValue("name").equalsIgnoreCase("encountertype")){
										if(!evaluateString(field.element("value"),rs.getString("OC_ENCOUNTER_TYPE"),rows,uid)){
											bMatch=false;
											break;
										}
									}
									else if(field.attributeValue("name").equalsIgnoreCase("outcome")){
										if(!evaluateString(field.element("value"),rs.getString("OC_ENCOUNTER_OUTCOME"),rows,uid)){
											bMatch=false;
											break;
										}
									}
									else if(field.attributeValue("name").equalsIgnoreCase("serviceuid")){
										if(!evaluateString(field.element("value"),rs.getString("OC_ENCOUNTER_SERVICEUID"),rows,uid)){
											bMatch=false;
											break;
										}
									}
									else if(field.attributeValue("name").equalsIgnoreCase("situation")){
										if(!evaluateString(field.element("value"),rs.getString("OC_ENCOUNTER_SITUATION"),rows,uid)){
											bMatch=false;
											break;
										}
									}
									else if(field.attributeValue("name").equalsIgnoreCase("duration")){
										if(!evaluateDuration(field.element("value"),rs.getDate("OC_ENCOUNTER_BEGINDATE"),rs.getDate("OC_ENCOUNTER_ENDDATE"),rows,uid)){
											bMatch=false;
											break;
										}
									}
									else if(field.attributeValue("name").equalsIgnoreCase("origin")){
										if(!evaluateString(field.element("value"),rs.getString("OC_ENCOUNTER_ORIGIN"),rows,uid)){
											bMatch=false;
											break;
										}
									}
								}
								if(bMatch){
									if(rows.get(uid)==null){
										rows.put(uid,new Hashtable());
									}
									Hashtable variables = (Hashtable)rows.get(uid);
									Iterator outputs = filter.elementIterator("output");
									while(outputs.hasNext()){
										Element output = (Element)outputs.next();
										if(output.getText().equalsIgnoreCase("encounteruid")){
											variables.put("encounteruid",rs.getString("OC_ENCOUNTER_SERVERID")+"."+rs.getString("OC_ENCOUNTER_OBJECTID"));
										}
										else if(output.getText().equalsIgnoreCase("patientuid")){
											variables.put("patientuid",rs.getString("OC_ENCOUNTER_PATIENTUID"));
										}
										else if(output.getText().equalsIgnoreCase("serviceuid")){
											variables.put("serviceuid",rs.getString("OC_ENCOUNTER_SERVICEUID"));
										}
									}
								}
							}
							rs.close();
							ps.close();
						}
						else{
							//This is not a first filter, we have to base ourselves on the remaining rows
							Vector rowsToRemove = new Vector();
							Iterator iRows = rows.keySet().iterator();
							while(iRows.hasNext()){
								Object uid = iRows.next();
								Hashtable variables = (Hashtable)rows.get(uid);
								//We must create a select query
								String sSelect="select * from OC_ENCOUNTERS_VIEW where 1=1";
								Vector parameters = new Vector();
								if(filter.attributeValue("periodfilter").equalsIgnoreCase("true")){
									sSelect+=" AND OC_ENCOUNTER_BEGINDATE>=?"+
											" AND OC_ENCOUNTER_BEGINDATE<?";
									parameters.add(new java.sql.Date(ScreenHelper.parseDate(begin).getTime()));
									parameters.add(new java.sql.Date(ScreenHelper.parseDate(end).getTime()));
								}
								//Also add extra select criteria
								Element selectElement = filter.element("select");
								Iterator selectfields = selectElement.elementIterator("field");
								while(selectfields.hasNext()){
									Element selectField = (Element)selectfields.next();
									Element value = selectField.element("value");
									Object v = value.getText();
									if(value.attributeValue("type").equalsIgnoreCase("variable")){
										v=variables.get(value.getText());
									}
									else if(value.attributeValue("type").equalsIgnoreCase("config")){
										v=MedwanQuery.getInstance().getConfigString(value.getText(),checkString(value.attributeValue("default")));
									}
									if(selectField.attributeValue("name").equalsIgnoreCase("encountertype")){
										sSelect=setSelectString(value, sSelect, parameters, "OC_ENCOUNTER_TYPE", (String)v);
									}
									else if(selectField.attributeValue("name").equalsIgnoreCase("outcome")){
										sSelect=setSelectString(value, sSelect, parameters, "OC_ENCOUNTER_OUTCOME", (String)v);
									}
									else if(selectField.attributeValue("name").equalsIgnoreCase("serviceuid")){
										sSelect=setSelectString(value, sSelect, parameters, "OC_ENCOUNTER_SERVICEUID", (String)v);
									}
									else if(selectField.attributeValue("name").equalsIgnoreCase("situation")){
										sSelect=setSelectString(value, sSelect, parameters, "OC_ENCOUNTER_SITUATION", (String)v);
									}
									else if(selectField.attributeValue("name").equalsIgnoreCase("duration")){
										sSelect=setSelectInt(value, sSelect, parameters, MedwanQuery.getInstance().datediff("day", "OC_ENCOUNTER_BEGINDATE", "OC_ENCOUNTER_ENDDATE"), Integer.parseInt((String)v));
									}
									else if(selectField.attributeValue("name").equalsIgnoreCase("patientuid")){
										sSelect=setSelectString(value, sSelect, parameters, "OC_ENCOUNTER_PATIENTUID", (String)v);
									}
									else if(selectField.attributeValue("name").equalsIgnoreCase("origin")){
										sSelect=setSelectString(value, sSelect, parameters, "OC_ENCOUNTER_ORIGIN", (String)v);
									}
									else if(selectField.attributeValue("name").equalsIgnoreCase("encounteruid")){
										sSelect=setSelectObjectId(value, sSelect, parameters, "OC_ENCOUNTER_OBJECTID", (String)v);
									}
								}
								ps=conn.prepareStatement(sSelect);
								for(int n=0;n<parameters.size();n++){
									Object p = parameters.elementAt(n);
									setParameter(p, ps, n);
								}
								rs=ps.executeQuery();
								boolean bNoMatch=true;
								while(rs.next()){
									bNoMatch=false;
									boolean bMatch = true;
									//First we evaluate the criteria on each resulting row
									Iterator fields = filter.elementIterator("field");
									while(fields.hasNext()){
										Element field = (Element)fields.next();
										if(field.attributeValue("name").equalsIgnoreCase("encountertype")){
											if(!evaluateString(field.element("value"),rs.getString("OC_ENCOUNTER_TYPE"),rows,uid)){
												bMatch=false;
												break;
											}
										}
										else if(field.attributeValue("name").equalsIgnoreCase("situation")){
											if(!evaluateString(field.element("value"),rs.getString("OC_ENCOUNTER_SITUATION"),rows,uid)){
												bMatch=false;
												break;
											}
										}
										else if(field.attributeValue("name").equalsIgnoreCase("outcome")){
											if(!evaluateString(field.element("value"),rs.getString("OC_ENCOUNTER_OUTCOME"),rows,uid)){
												bMatch=false;
												break;
											}
										}
										else if(field.attributeValue("name").equalsIgnoreCase("duration")){
											if(!evaluateDuration(field.element("value"),rs.getDate("OC_ENCOUNTER_BEGINDATE"),rs.getDate("OC_ENCOUNTER_ENDDATE"),rows,uid)){
												bMatch=false;
												break;
											}
										}
										else if(field.attributeValue("name").equalsIgnoreCase("serviceuid")){
											if(!evaluateString(field.element("value"),rs.getString("OC_ENCOUNTER_SERVICEUID"),rows,uid)){
												bMatch=false;
												break;
											}
										}
										else if(field.attributeValue("name").equalsIgnoreCase("origin")){
											if(!evaluateString(field.element("value"),rs.getString("OC_ENCOUNTER_ORIGIN"),rows,uid)){
												bMatch=false;
												break;
											}
										}
									}
									if(!bMatch){
										//This filter does not match the criteria, remove the row
										rowsToRemove.add(uid);
									}
									else {
										break;
									}
								}
								rs.close();
								ps.close();
								if(bNoMatch){
									//This filter does not match the criteria, remove the row
									rowsToRemove.add(uid);
								}
							}
							for(int n=0;n<rowsToRemove.size();n++){
								rows.remove(rowsToRemove.elementAt(n));
							}
						}
					}
					///////////////////////////////////////////////
					// Admin filter
					///////////////////////////////////////////////
					else if(filter.attributeValue("type").equalsIgnoreCase("admin")){
						if(bFirstFilter){
							bFirstFilter=false;
							//We must create a select query
							String sSelect="select a.*,b.sector from AdminView a,PrivateView b where a.personid=b.personid";
							Vector parameters = new Vector();
							//Add select criteria
							Element selectElement = filter.element("select");
							Iterator selectfields = selectElement.elementIterator("field");
							while(selectfields.hasNext()){
								Element selectField = (Element)selectfields.next();
								if(selectField.attributeValue("name").equalsIgnoreCase("patientuid")){
									Element value = selectField.element("value");
									sSelect=setSelectInt(value, sSelect, parameters, "a.personid", Integer.parseInt(value.getText()));
								}
								else if(selectField.attributeValue("name").equalsIgnoreCase("sector")){
									Element value = selectField.element("value");
									sSelect=setSelectString(value, sSelect, parameters, "sector", value.getText());
								}
								else if(selectField.attributeValue("name").equalsIgnoreCase("gender")){
									Element value = selectField.element("value");
									sSelect=setSelectString(value, sSelect, parameters, "gender", value.getText());
								}
								else if(selectField.attributeValue("name").equalsIgnoreCase("age")){
									Element value = selectField.element("value");
									java.util.Date birthdate = Miscelaneous.addMonthsToDate(new java.util.Date(), -Integer.parseInt(value.getText()));
									sSelect=setSelectDateReverse(value, sSelect, parameters, "dateofbirth", birthdate);
								}
							}
							ps=conn.prepareStatement(sSelect);
							for(int n=0;n<parameters.size();n++){
								Object p = parameters.elementAt(n);
								setParameter(p, ps, n);
							}
							rs=ps.executeQuery();
							while(rs.next()){
								String uid = rs.getString("personid");
								boolean bMatch = true;
								//First we evaluate the criteria on each resulting row
								Iterator fields = filter.elementIterator("field");
								while(fields.hasNext()){
									Element field = (Element)fields.next();
									if(field.attributeValue("name").equalsIgnoreCase("patientuid")){
										if(!evaluateInt(field.element("value"),rs.getString("personid"),rows,Integer.parseInt(uid))){
											bMatch=false;
											break;
										}
									}
									else if(field.attributeValue("name").equalsIgnoreCase("gender")){
										if(!evaluateString(field.element("value"),rs.getString("gender"),rows,uid)){
											bMatch=false;
											break;
										}
									}
									else if(field.attributeValue("name").equalsIgnoreCase("sector")){
										if(!evaluateString(field.element("value"),rs.getString("sector"),rows,uid)){
											bMatch=false;
											break;
										}
									}
									else if(field.attributeValue("name").equalsIgnoreCase("age")){
										java.util.Date birthdate = Miscelaneous.addMonthsToDate(new java.util.Date(), -Integer.parseInt(field.element("value").getText()));
										if(!evaluateDateReverse(field.element("value"),rs.getDate("dateofbirth"),rows,uid,birthdate)){
											bMatch=false;
											break;
										}
									}
								}
								if(bMatch){
									if(rows.get(uid)==null){
										rows.put(uid,new Hashtable());
									}
									Hashtable variables = (Hashtable)rows.get(uid);
									Iterator outputs = filter.elementIterator("output");
									while(outputs.hasNext()){
										Element output = (Element)outputs.next();
										if(output.getText().equalsIgnoreCase("patientuid")){
											variables.put("patientuid",uid);
										}
										else if(output.getText().equalsIgnoreCase("gender")){
											variables.put("gender",rs.getString("gender"));
										}
										else if(output.getText().equalsIgnoreCase("sector")){
											variables.put("sector",rs.getString("sector"));
										}
									}
								}
							}
							rs.close();
							ps.close();
						}
						else{
							//This is not a first filter, we have to base ourselves on the remaining rows
							Vector rowsToRemove = new Vector();
							Iterator iRows = rows.keySet().iterator();
							while(iRows.hasNext()){
								Object uid = iRows.next();
								Hashtable variables = (Hashtable)rows.get(uid);
								//We must create a select query
								String sSelect="select a.*,b.sector from AdminView a,PrivateView b where a.personid=b.personid";
								Vector parameters = new Vector();
								//Add select criteria
								Element selectElement = filter.element("select");
								Iterator selectfields = selectElement.elementIterator("field");
								while(selectfields.hasNext()){
									Element selectField = (Element)selectfields.next();
									Element value = selectField.element("value");
									Object v = value.getText();
									if(value.attributeValue("type").equalsIgnoreCase("variable")){
										v=variables.get(value.getText());
									}
									else if(value.attributeValue("type").equalsIgnoreCase("config")){
										v=MedwanQuery.getInstance().getConfigString(value.getText(),checkString(value.attributeValue("default")));
									}
									if(selectField.attributeValue("name").equalsIgnoreCase("patientuid")){
										sSelect=setSelectInt(value, sSelect, parameters, "a.personid", Integer.parseInt((String)v));
									}
									else if(selectField.attributeValue("name").equalsIgnoreCase("gender")){
										sSelect=setSelectString(value, sSelect, parameters, "gender", (String)v);
									}
									else if(selectField.attributeValue("name").equalsIgnoreCase("sector")){
										sSelect=setSelectString(value, sSelect, parameters, "sector", (String)v);
									}
									else if(selectField.attributeValue("name").equalsIgnoreCase("age")){
										java.util.Date birthdate = Miscelaneous.addMonthsToDate(new java.util.Date(), -Integer.parseInt((String)v));
										sSelect=setSelectDateReverse(value, sSelect, parameters, "dateofbirth", birthdate);
									}
								}
								ps=conn.prepareStatement(sSelect);
								for(int n=0;n<parameters.size();n++){
									Object p = parameters.elementAt(n);
									setParameter(p, ps, n);
								}
								rs=ps.executeQuery();
								boolean bNoMatch=true;
								while(rs.next()){
									boolean bMatch = true;
									bNoMatch=false;
									//First we evaluate the criteria on each resulting row
									Iterator fields = filter.elementIterator("field");
									while(fields.hasNext()){
										Element field = (Element)fields.next();
										if(field.attributeValue("name").equalsIgnoreCase("patientuid")){
											if(!evaluateInt(field.element("value"),rs.getString("personid"),rows,uid)){
												bMatch=false;
												break;
											}
										}
										else if(field.attributeValue("name").equalsIgnoreCase("gender")){
											if(!evaluateString(field.element("value"),rs.getString("gender"),rows,uid)){
												bMatch=false;
												break;
											}
										}
										else if(field.attributeValue("name").equalsIgnoreCase("sector")){
											if(!evaluateString(field.element("value"),rs.getString("sector"),rows,uid)){
												bMatch=false;
												break;
											}
										}
										else if(field.attributeValue("name").equalsIgnoreCase("age")){
											java.util.Date birthdate = Miscelaneous.addMonthsToDate(new java.util.Date(), -Integer.parseInt(field.element("value").getText()));
											if(!evaluateDateReverse(field.element("value"),rs.getDate("dateofbirth"),rows,uid,birthdate)){
												bMatch=false;
												break;
											}
										}
									}
									if(!bMatch){
										//This filter does not match the criteria, remove the row
										rowsToRemove.add(uid);
									}
									else {
										break;
									}
								}
								rs.close();
								ps.close();
								if(bNoMatch){
									//This filter does not match the criteria, remove the row
									rowsToRemove.add(uid);
								}
							}
							for(int n=0;n<rowsToRemove.size();n++){
								rows.remove(rowsToRemove.elementAt(n));
							}
						}
					}
					///////////////////////////////////////////////
					// Transaction filter
					///////////////////////////////////////////////
					else if(filter.attributeValue("type").equalsIgnoreCase("transaction")){
						if(bFirstFilter){
							bFirstFilter=false;
							//We must create a select query
							String sSelect="select * from Healthrecord h,Transactions t where h.healthrecordid=t.healthrecordid";
							//If there are also item criteria in the select, then we have to adapt the query
							if(filter.element("select")!=null && filter.element("select").element("item")!=null){
								sSelect="select * from Healthrecord h,Transactions t,Items i where h.healthrecordid=t.healthrecordid and t.serverid=i.serverid and t.transactionid=i.transactionid";
							}
							Vector parameters = new Vector();
							if(filter.attributeValue("periodfilter").equalsIgnoreCase("true")){
								sSelect+=" AND t.updatetime>=?"+
										" AND t.updatetime<?";
								parameters.add(new java.sql.Date(ScreenHelper.parseDate(begin).getTime()));
								parameters.add(new java.sql.Date(ScreenHelper.parseDate(end).getTime()));
							}
							//Add select criteria
							Element selectElement = filter.element("select");
							Iterator selectfields = selectElement.elementIterator("field");
							while(selectfields.hasNext()){
								Element selectField = (Element)selectfields.next();
								if(selectField.attributeValue("name").equalsIgnoreCase("patientuid")){
									Element value = selectField.element("value");
									sSelect=setSelectInt(value, sSelect, parameters, "personid", Integer.parseInt(value.getText()));
								}
								else if(selectField.attributeValue("name").equalsIgnoreCase("transactiontype")){
									Element value = selectField.element("value");
									sSelect=setSelectString(value, sSelect, parameters, "transactiontype", value.getText());
								}
							}
							Iterator itemfields = selectElement.elementIterator("item");
							while(itemfields.hasNext()){
								Element itemfield = (Element)itemfields.next();
								if(checkString(itemfield.attributeValue("type")).length()>0){
									sSelect=setSelectItemType(itemfield.attributeValue("type"), sSelect,parameters);
								}
								Element value = itemfield.element("value");
								if(value!=null){
									sSelect=setSelectItemValue(value, sSelect,parameters,rows,null);
								}
							}
							ps=conn.prepareStatement(sSelect);
							for(int n=0;n<parameters.size();n++){
								Object p = parameters.elementAt(n);
								setParameter(p, ps, n);
							}
							rs=ps.executeQuery();
							while(rs.next()){
								String uid = rs.getString("transactionid");
								boolean bMatch = true;
								//First we evaluate the criteria on each resulting row
								Iterator fields = filter.elementIterator("field");
								while(fields.hasNext()){
									Element field = (Element)fields.next();
									if(field.attributeValue("name").equalsIgnoreCase("patientuid")){
										if(!evaluateInt(field.element("value"),rs.getString("personid"),rows,Integer.parseInt(uid))){
											bMatch=false;
											break;
										}
									}
									else if(field.attributeValue("name").equalsIgnoreCase("transactiontype")){
										if(!evaluateString(field.element("value"),rs.getString("transactiontype"),rows,uid)){
											bMatch=false;
											break;
										}
									}
								}
								if(filter.element("item")!=null){
									//We must now load all items from the transaction
									TransactionVO transaction = MedwanQuery.getInstance().loadTransaction(MedwanQuery.getInstance().getConfigInt("serverId"), rs.getInt("transactionid"));
									Iterator items = filter.elementIterator("item");
									while(items.hasNext()){
										Element itemelement = (Element)items.next();
										if(checkString(itemelement.attributeValue("type")).length()>0){
											ItemVO itemVO = transaction.getItem(itemelement.attributeValue("type"));
											if(itemVO==null){
												bMatch=false;
												break;
											}
											else{
												Element value = itemelement.element("value");
												if(value!=null && !evaluateString(value,itemVO.getValue(), rows, uid)){
													bMatch=false;
													break;
												}
											}
										}
									}
								}
								if(bMatch){
									if(rows.get(uid)==null){
										rows.put(uid,new Hashtable());
									}
									Hashtable variables = (Hashtable)rows.get(uid);
									Iterator outputs = filter.elementIterator("output");
									while(outputs.hasNext()){
										Element output = (Element)outputs.next();
										if(output.getText().equalsIgnoreCase("patientuid")){
											variables.put("patientuid",rs.getString("personid"));
										}
										else if(output.getText().equalsIgnoreCase("transactionid")){
											variables.put("transactionid",uid);
										}
										else if(output.getText().equalsIgnoreCase("transactiontype")){
											variables.put("transactiontype",rs.getString("transactiontype"));
										}
										else if(output.getText().equalsIgnoreCase("itemvalue")){
											variables.put("itemvalue",rs.getString("value"));
										}
									}
								}
							}
							rs.close();
							ps.close();
						}
						else{
							//This is not a first filter, we have to base ourselves on the remaining rows
							Vector rowsToRemove = new Vector();
							Iterator iRows = rows.keySet().iterator();
							while(iRows.hasNext()){
								Object uid = iRows.next();
								Hashtable variables = (Hashtable)rows.get(uid);
								//We must create a select query
								String sSelect="select * from Healthrecord h,Transactions t where h.healthrecordid=t.healthrecordid";
								//If there are also item criteria in the select, then we have to adapt the query
								if(filter.element("select")!=null && filter.element("select").element("item")!=null){
									sSelect="select * from Healthrecord h,Transactions t,Items i where h.healthrecordid=t.healthrecordid and t.serverid=i.serverid and t.transactionid=i.transactionid";
								}
								Vector parameters = new Vector();
								if(filter.attributeValue("periodfilter").equalsIgnoreCase("true")){
									sSelect+=" AND t.updatetime>=?"+
											" AND t.updatetime<?";
									parameters.add(new java.sql.Date(ScreenHelper.parseDate(begin).getTime()));
									parameters.add(new java.sql.Date(ScreenHelper.parseDate(end).getTime()));
								}
								//Add select criteria
								Element selectElement = filter.element("select");
								Iterator selectfields = selectElement.elementIterator("field");
								while(selectfields.hasNext()){
									Element selectField = (Element)selectfields.next();
									Element value = selectField.element("value");
									Object v = value.getText();
									if(value.attributeValue("type").equalsIgnoreCase("variable")){
										v=variables.get(value.getText());
									}
									else if(value.attributeValue("type").equalsIgnoreCase("config")){
										v=MedwanQuery.getInstance().getConfigString(value.getText(),checkString(value.attributeValue("default")));
									}
									if(selectField.attributeValue("name").equalsIgnoreCase("patientuid")){
										sSelect=setSelectInt(value, sSelect, parameters, "personid", Integer.parseInt((String)v));
									}
									else if(selectField.attributeValue("name").equalsIgnoreCase("transactiontype")){
										sSelect=setSelectString(value, sSelect, parameters, "transactiontype", (String)v);
									}
								}
								if(uid.equals("1.102918")){
									System.out.println("select = "+selectElement.asXML());
									System.out.println("has item field: "+(selectElement.element("item")!=null));
								}
								Iterator itemfields = selectElement.elementIterator("item");
								while(itemfields.hasNext()){
									Element itemfield = (Element)itemfields.next();
									if(checkString(itemfield.attributeValue("type")).length()>0){
										sSelect=setSelectItemType(itemfield.attributeValue("type"), sSelect,parameters);
									}
									Element value = itemfield.element("value");
									if(value!=null){
										sSelect=setSelectItemValue(value, sSelect,parameters, rows, uid);
									}
								}
								if(uid.equals("1.102918")){
									System.out.println(sSelect);
								}
								ps=conn.prepareStatement(sSelect);
								for(int n=0;n<parameters.size();n++){
									Object p = parameters.elementAt(n);
									setParameter(p, ps, n);
									if(uid.equals("1.102918")){
										System.out.println("parameter="+p);
									}
								}
								rs=ps.executeQuery();
								boolean bNoMatch=true;
								while(rs.next()){
									boolean bMatch = true;
									bNoMatch=false;
									//First we evaluate the criteria on each resulting row
									Iterator fields = filter.elementIterator("field");
									while(fields.hasNext()){
										Element field = (Element)fields.next();
										if(field.attributeValue("name").equalsIgnoreCase("patientuid")){
											if(!evaluateInt(field.element("value"),rs.getString("personid"),rows,uid)){
												bMatch=false;
												break;
											}
										}
										else if(field.attributeValue("name").equalsIgnoreCase("transactiontype")){
											if(!evaluateString(field.element("value"),rs.getString("transactiontype"),rows,uid)){
												bMatch=false;
												break;
											}
										}
									}
									if(filter.element("item")!=null){
										//We must now load all items from the transaction
										TransactionVO transaction = MedwanQuery.getInstance().loadTransaction(MedwanQuery.getInstance().getConfigInt("serverId"), rs.getInt("transactionid"));
										if(uid.equals("1.102918")){
											System.out.println("transactionitems="+transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_PRENATAL_CPNORDER"));
										}
										Iterator items = filter.elementIterator("item");
										while(items.hasNext()){
											Element itemelement = (Element)items.next();
											if(checkString(itemelement.attributeValue("type")).length()>0){
												ItemVO itemVO = transaction.getItem(itemelement.attributeValue("type"));
												if(itemVO==null){
													bMatch=false;
													break;
												}
												else{
													Element value = itemelement.element("value");
													if(value!=null && !evaluateString(value,itemVO.getValue(), rows, uid)){
														bMatch=false;
														break;
													}
												}
											}
										}
									}
									if(!bMatch){
										//This filter does not match the criteria, remove the row
										rowsToRemove.add(uid);
									}
									else {
										break;
									}
								}
								rs.close();
								ps.close();
								if(bNoMatch){
									//This filter does not match the criteria, remove the row
									rowsToRemove.add(uid);
								}
							}
							for(int n=0;n<rowsToRemove.size();n++){
								rows.remove(rowsToRemove.elementAt(n));
							}
						}
					}
					///////////////////////////////////////////////
					// RFE filter
					///////////////////////////////////////////////
					else if(filter.attributeValue("type").equalsIgnoreCase("rfe")){
						if(bFirstFilter){
							bFirstFilter=false;
							//We must create a select query
							String sSelect="select * from OC_RFE where 1=1";
							Vector parameters = new Vector();
							if(filter.attributeValue("periodfilter").equalsIgnoreCase("true")){
								sSelect+=" AND oc_rfe_date>=?"+
										" AND oc_rfe_date<?";
								parameters.add(new java.sql.Date(ScreenHelper.parseDate(begin).getTime()));
								parameters.add(new java.sql.Date(ScreenHelper.parseDate(end).getTime()));
							}
							//Add select criteria
							Element selectElement = filter.element("select");
							Iterator selectfields = selectElement.elementIterator("field");
							while(selectfields.hasNext()){
								Element selectField = (Element)selectfields.next();
								if(selectField.attributeValue("name").equalsIgnoreCase("encounteruid")){
									Element value = selectField.element("value");
									sSelect=setSelectString(value, sSelect, parameters, "oc_rfe_encounteruid", value.getText());
								}
								else if(selectField.attributeValue("name").equalsIgnoreCase("rfeflags")){
									Element value = selectField.element("value");
									sSelect=setSelectString(value, sSelect, parameters, "oc_rfe_flags", value.getText());
								}
								else if(selectField.attributeValue("name").equalsIgnoreCase("rfecodetype")){
									Element value = selectField.element("value");
									sSelect=setSelectString(value, sSelect, parameters, "oc_rfe_codetype", value.getText());
								}
								else if(selectField.attributeValue("name").equalsIgnoreCase("rfecode")){
									Element value = selectField.element("value");
									sSelect=setSelectString(value, sSelect, parameters, "oc_rfe_code", value.getText());
								}
							}
							rs=ps.executeQuery();
							while(rs.next()){
								String uid = rs.getString("oc_rfe_serverid")+"."+rs.getString("oc_rfe_objectid");
								boolean bMatch = true;
								//First we evaluate the criteria on each resulting row
								Iterator fields = filter.elementIterator("field");
								while(fields.hasNext()){
									Element field = (Element)fields.next();
									if(field.attributeValue("name").equalsIgnoreCase("encounteruid")){
										if(!evaluateString(field.element("value"),rs.getString("oc_rfe_encounteruid"),rows,uid)){
											bMatch=false;
											break;
										}
									}
									else if(field.attributeValue("name").equalsIgnoreCase("rfeflags")){
										if(!evaluateString(field.element("value"),rs.getString("oc_rfe_flags"),rows,uid)){
											bMatch=false;
											break;
										}
									}
									else if(field.attributeValue("name").equalsIgnoreCase("rfecodetype")){
										if(!evaluateString(field.element("value"),rs.getString("oc_rfe_codetype"),rows,uid)){
											bMatch=false;
											break;
										}
									}
									else if(field.attributeValue("name").equalsIgnoreCase("rfecode")){
										if(!evaluateString(field.element("value"),rs.getString("oc_rfe_code"),rows,uid)){
											bMatch=false;
											break;
										}
									}
								}
								if(bMatch){
									if(rows.get(uid)==null){
										rows.put(uid,new Hashtable());
									}
									Hashtable variables = (Hashtable)rows.get(uid);
									Iterator outputs = filter.elementIterator("output");
									while(outputs.hasNext()){
										Element output = (Element)outputs.next();
										if(output.getText().equalsIgnoreCase("encounteruid")){
											variables.put("encounteruid",rs.getString("oc_rfe_encounteruid"));
										}
										else if(output.getText().equalsIgnoreCase("rfeuid")){
											variables.put("rfeuid",uid);
										}
										else if(output.getText().equalsIgnoreCase("rfeflags")){
											variables.put("rfeflags",rs.getString("oc_rfe_flags"));
										}
										else if(output.getText().equalsIgnoreCase("rfecodetype")){
											variables.put("rfecodetype",rs.getString("oc_rfe_codetype"));
										}
										else if(output.getText().equalsIgnoreCase("rfecode")){
											variables.put("rfecode",rs.getString("oc_rfe_code"));
										}
									}
								}
							}
							rs.close();
							ps.close();
						}
						else{
							//This is not a first filter, we have to base ourselves on the remaining rows
							Vector rowsToRemove = new Vector();
							Iterator iRows = rows.keySet().iterator();
							while(iRows.hasNext()){
								Object uid = iRows.next();
								Hashtable variables = (Hashtable)rows.get(uid);
								//We must create a select query
								String sSelect="select * from OC_RFE where 1=1";
								Vector parameters = new Vector();
								if(filter.attributeValue("periodfilter").equalsIgnoreCase("true")){
									sSelect+=" AND oc_rfe_date>=?"+
											" AND oc_rfe_date<?";
									parameters.add(new java.sql.Date(ScreenHelper.parseDate(begin).getTime()));
									parameters.add(new java.sql.Date(ScreenHelper.parseDate(end).getTime()));
								}
								//Add select criteria
								Element selectElement = filter.element("select");
								Iterator selectfields = selectElement.elementIterator("field");
								while(selectfields.hasNext()){
									Element selectField = (Element)selectfields.next();
									Element value = selectField.element("value");
									Object v = value.getText();
									if(value.attributeValue("type").equalsIgnoreCase("variable")){
										v=variables.get(value.getText());
									}
									else if(value.attributeValue("type").equalsIgnoreCase("config")){
										v=MedwanQuery.getInstance().getConfigString(value.getText(),checkString(value.attributeValue("default")));
									}
									if(selectField.attributeValue("name").equalsIgnoreCase("encounteruid")){
										sSelect=setSelectString(value, sSelect, parameters, "oc_rfe_encounteruid", (String)v);
									}
									else if(selectField.attributeValue("name").equalsIgnoreCase("rfeflags")){
										sSelect=setSelectString(value, sSelect, parameters, "oc_rfe_flags", (String)v);
									}
									else if(selectField.attributeValue("name").equalsIgnoreCase("rfecodetype")){
										sSelect=setSelectString(value, sSelect, parameters, "oc_rfe_codetype", (String)v);
									}
									else if(selectField.attributeValue("name").equalsIgnoreCase("rfecode")){
										sSelect=setSelectString(value, sSelect, parameters, "oc_rfe_code", (String)v);
									}
								}
								ps=conn.prepareStatement(sSelect);
								for(int n=0;n<parameters.size();n++){
									Object p = parameters.elementAt(n);
									setParameter(p, ps, n);
								}
								rs=ps.executeQuery();
								boolean bNoMatch=true;
								while(rs.next()){
									boolean bMatch = true;
									bNoMatch=false;
									//First we evaluate the criteria on each resulting row
									Iterator fields = filter.elementIterator("field");
									while(fields.hasNext()){
										Element field = (Element)fields.next();
										if(field.attributeValue("name").equalsIgnoreCase("encounteruid")){
											if(!evaluateString(field.element("value"),rs.getString("oc_rfe_encounteruid"),rows,uid)){
												bMatch=false;
												break;
											}
										}
										else if(field.attributeValue("name").equalsIgnoreCase("rfeflags")){
											if(!evaluateString(field.element("value"),rs.getString("oc_rfe_flags"),rows,uid)){
												bMatch=false;
												break;
											}
										}
										else if(field.attributeValue("name").equalsIgnoreCase("rfecodetype")){
											if(!evaluateString(field.element("value"),rs.getString("oc_rfe_codetype"),rows,uid)){
												bMatch=false;
												break;
											}
										}
										else if(field.attributeValue("name").equalsIgnoreCase("rfecode")){
											if(!evaluateString(field.element("value"),rs.getString("oc_rfe_code"),rows,uid)){
												bMatch=false;
												break;
											}
										}
									}
									if(!bMatch){
										//This filter does not match the criteria, remove the row
										rowsToRemove.add(uid);
									}
									else {
										break;
									}
								}
								rs.close();
								ps.close();
								if(bNoMatch){
									//This filter does not match the criteria, remove the row
									rowsToRemove.add(uid);
								}
							}
							for(int n=0;n<rowsToRemove.size();n++){
								rows.remove(rowsToRemove.elementAt(n));
							}
						}
					}
					///////////////////////////////////////////////
					// Diagnosis filter
					///////////////////////////////////////////////
					else if(filter.attributeValue("type").equalsIgnoreCase("diagnosis")){
						if(bFirstFilter){
							bFirstFilter=false;
							//We must create a select query
							String sSelect="select * from OC_DIAGNOSES where 1=1";
							Vector parameters = new Vector();
							if(filter.attributeValue("periodfilter").equalsIgnoreCase("true")){
								sSelect+=" AND oc_diagnosis_date>=?"+
										" AND oc_diagnosis_date<?";
								parameters.add(new java.sql.Date(ScreenHelper.parseDate(begin).getTime()));
								parameters.add(new java.sql.Date(ScreenHelper.parseDate(end).getTime()));
							}
							//Add select criteria
							Element selectElement = filter.element("select");
							Iterator selectfields = selectElement.elementIterator("field");
							while(selectfields.hasNext()){
								Element selectField = (Element)selectfields.next();
								if(selectField.attributeValue("name").equalsIgnoreCase("encounteruid")){
									Element value = selectField.element("value");
									sSelect=setSelectString(value, sSelect, parameters, "oc_diagnosis_encounteruid", value.getText());
								}
								else if(selectField.attributeValue("name").equalsIgnoreCase("diagnosisflags")){
									Element value = selectField.element("value");
									sSelect=setSelectString(value, sSelect, parameters, "oc_diagnosis_flags", value.getText());
								}
								else if(selectField.attributeValue("name").equalsIgnoreCase("diagnosiscodetype")){
									Element value = selectField.element("value");
									sSelect=setSelectString(value, sSelect, parameters, "oc_diagnosis_codetype", value.getText());
								}
								else if(selectField.attributeValue("name").equalsIgnoreCase("diagnosiscode")){
									Element value = selectField.element("value");
									sSelect=setSelectString(value, sSelect, parameters, "oc_diagnosis_code", value.getText());
								}
							}
							rs=ps.executeQuery();
							while(rs.next()){
								String uid = rs.getString("oc_diagnosis_serverid")+"."+rs.getString("oc_diagnosis_objectid");
								boolean bMatch = true;
								//First we evaluate the criteria on each resulting row
								Iterator fields = filter.elementIterator("field");
								while(fields.hasNext()){
									Element field = (Element)fields.next();
									if(field.attributeValue("name").equalsIgnoreCase("encounteruid")){
										if(!evaluateString(field.element("value"),rs.getString("oc_diagnosis_encounteruid"),rows,uid)){
											bMatch=false;
											break;
										}
									}
									else if(field.attributeValue("name").equalsIgnoreCase("diagnosisflags")){
										if(!evaluateString(field.element("value"),rs.getString("oc_diagnosis_flags"),rows,uid)){
											bMatch=false;
											break;
										}
									}
									else if(field.attributeValue("name").equalsIgnoreCase("diagnosiscodetype")){
										if(!evaluateString(field.element("value"),rs.getString("oc_diagnosis_codetype"),rows,uid)){
											bMatch=false;
											break;
										}
									}
									else if(field.attributeValue("name").equalsIgnoreCase("diagnosiscode")){
										if(!evaluateString(field.element("value"),rs.getString("oc_diagnosis_code"),rows,uid)){
											bMatch=false;
											break;
										}
									}
								}
								if(bMatch){
									if(rows.get(uid)==null){
										rows.put(uid,new Hashtable());
									}
									Hashtable variables = (Hashtable)rows.get(uid);
									Iterator outputs = filter.elementIterator("output");
									while(outputs.hasNext()){
										Element output = (Element)outputs.next();
										if(output.getText().equalsIgnoreCase("encounteruid")){
											variables.put("encounteruid",rs.getString("oc_diagnosis_encounteruid"));
										}
										else if(output.getText().equalsIgnoreCase("diagnosisuid")){
											variables.put("diagnosisuid",uid);
										}
										else if(output.getText().equalsIgnoreCase("diagnosisflags")){
											variables.put("diagnosisflags",rs.getString("oc_diagnosis_flags"));
										}
										else if(output.getText().equalsIgnoreCase("rfecodetype")){
											variables.put("diagnosiscodetype",rs.getString("oc_rfe_codetype"));
										}
										else if(output.getText().equalsIgnoreCase("rfecode")){
											variables.put("diagnosiscode",rs.getString("oc_diagnosis_code"));
										}
									}
								}
							}
							rs.close();
							ps.close();
						}
						else{
							//This is not a first filter, we have to base ourselves on the remaining rows
							Vector rowsToRemove = new Vector();
							Iterator iRows = rows.keySet().iterator();
							while(iRows.hasNext()){
								Object uid = iRows.next();
								Hashtable variables = (Hashtable)rows.get(uid);
								//We must create a select query
								String sSelect="select * from OC_DIAGNOSES where 1=1";
								Vector parameters = new Vector();
								if(filter.attributeValue("periodfilter").equalsIgnoreCase("true")){
									sSelect+=" AND oc_diagnosis_date>=?"+
											" AND oc_diagnosis_date<?";
									parameters.add(new java.sql.Date(ScreenHelper.parseDate(begin).getTime()));
									parameters.add(new java.sql.Date(ScreenHelper.parseDate(end).getTime()));
								}
								//Add select criteria
								Element selectElement = filter.element("select");
								Iterator selectfields = selectElement.elementIterator("field");
								while(selectfields.hasNext()){
									Element selectField = (Element)selectfields.next();
									Element value = selectField.element("value");
									Object v = value.getText();
									if(value.attributeValue("type").equalsIgnoreCase("variable")){
										v=variables.get(value.getText());
									}
									else if(value.attributeValue("type").equalsIgnoreCase("config")){
										v=MedwanQuery.getInstance().getConfigString(value.getText(),checkString(value.attributeValue("default")));
									}
									if(selectField.attributeValue("name").equalsIgnoreCase("encounteruid")){
										sSelect=setSelectString(value, sSelect, parameters, "oc_diagnosis_encounteruid", (String)v);
									}
									else if(selectField.attributeValue("name").equalsIgnoreCase("diagnosisflags")){
										sSelect=setSelectString(value, sSelect, parameters, "oc_diagnosis_flags", (String)v);
									}
									else if(selectField.attributeValue("name").equalsIgnoreCase("diagnosiscodetype")){
										sSelect=setSelectString(value, sSelect, parameters, "oc_diagnosis_codetype", (String)v);
									}
									else if(selectField.attributeValue("name").equalsIgnoreCase("diagnosiscode")){
										sSelect=setSelectString(value, sSelect, parameters, "oc_diagnosis_code", (String)v);
									}
								}
								ps=conn.prepareStatement(sSelect);
								for(int n=0;n<parameters.size();n++){
									Object p = parameters.elementAt(n);
									setParameter(p, ps, n);
								}
								rs=ps.executeQuery();
								boolean bNoMatch=true;
								while(rs.next()){
									boolean bMatch = true;
									bNoMatch=false;
									//First we evaluate the criteria on each resulting row
									Iterator fields = filter.elementIterator("field");
									while(fields.hasNext()){
										Element field = (Element)fields.next();
										if(field.attributeValue("name").equalsIgnoreCase("encounteruid")){
											if(!evaluateString(field.element("value"),rs.getString("oc_diagnosis_encounteruid"),rows,uid)){
												bMatch=false;
												break;
											}
										}
										else if(field.attributeValue("name").equalsIgnoreCase("diagnosisflags")){
											if(!evaluateString(field.element("value"),rs.getString("oc_diagnosis_flags"),rows,uid)){
												bMatch=false;
												break;
											}
										}
										else if(field.attributeValue("name").equalsIgnoreCase("diagnosiscodetype")){
											if(!evaluateString(field.element("value"),rs.getString("oc_diagnosis_codetype"),rows,uid)){
												bMatch=false;
												break;
											}
										}
										else if(field.attributeValue("name").equalsIgnoreCase("diagnosiscode")){
											if(!evaluateString(field.element("value"),rs.getString("oc_diagnosis_code"),rows,uid)){
												bMatch=false;
												break;
											}
										}
									}
									if(!bMatch){
										//This filter does not match the criteria, remove the row
										rowsToRemove.add(uid);
									}
									else {
										break;
									}
								}
								rs.close();
								ps.close();
								if(bNoMatch){
									//This filter does not match the criteria, remove the row
									rowsToRemove.add(uid);
								}
							}
							for(int n=0;n<rowsToRemove.size();n++){
								rows.remove(rowsToRemove.elementAt(n));
							}
						}
					}
					///////////////////////////////////////////////
					// Labanalysis filter
					///////////////////////////////////////////////
					else if(filter.attributeValue("type").equalsIgnoreCase("labanalysis")){
						if(bFirstFilter){
							bFirstFilter=false;
							//We must create a select query
							String sSelect="select * from requestedlabanalyses where 1=1";
							Vector parameters = new Vector();
							if(filter.attributeValue("periodfilter").equalsIgnoreCase("true")){
								sSelect+=" AND resultdate>=?"+
										" AND resultdate<?";
								parameters.add(new java.sql.Date(ScreenHelper.parseDate(begin).getTime()));
								parameters.add(new java.sql.Date(ScreenHelper.parseDate(end).getTime()));
							}
							//Add select criteria
							Element selectElement = filter.element("select");
							Iterator selectfields = selectElement.elementIterator("field");
							while(selectfields.hasNext()){
								Element selectField = (Element)selectfields.next();
								if(selectField.attributeValue("name").equalsIgnoreCase("transactionid")){
									Element value = selectField.element("value");
									sSelect=setSelectInt(value, sSelect, parameters, "transactionid", Integer.parseInt(value.getText()));
								}
								else if(selectField.attributeValue("name").equalsIgnoreCase("patientuid")){
									Element value = selectField.element("value");
									sSelect=setSelectInt(value, sSelect, parameters, "patientid", Integer.parseInt(value.getText()));
								}
								else if(selectField.attributeValue("name").equalsIgnoreCase("analysiscode")){
									Element value = selectField.element("value");
									sSelect=setSelectString(value, sSelect, parameters, "analysiscode", value.getText());
								}
								else if(selectField.attributeValue("name").equalsIgnoreCase("analysisresult")){
									Element value = selectField.element("value");
									sSelect=setSelectString(value, sSelect, parameters, "resultvalue", value.getText());
								}
							}
							ps=conn.prepareStatement(sSelect);
							for(int n=0;n<parameters.size();n++){
								Object p = parameters.elementAt(n);
								setParameter(p, ps, n);
							}
							rs=ps.executeQuery();
							while(rs.next()){
								String uid = rs.getString("serverid")+"."+rs.getString("transactionid")+"."+rs.getString("analysiscode");
								boolean bMatch = true;
								//First we evaluate the criteria on each resulting row
								Iterator fields = filter.elementIterator("field");
								while(fields.hasNext()){
									Element field = (Element)fields.next();
									if(field.attributeValue("name").equalsIgnoreCase("transactionid")){
										if(!evaluateString(field.element("value"),rs.getString("transactionid"),rows,uid)){
											bMatch=false;
											break;
										}
									}
									else if(field.attributeValue("name").equalsIgnoreCase("patientuid")){
										if(!evaluateString(field.element("value"),rs.getString("patientid"),rows,uid)){
											bMatch=false;
											break;
										}
									}
									else if(field.attributeValue("name").equalsIgnoreCase("analysiscode")){
										if(!evaluateString(field.element("value"),rs.getString("analysiscode"),rows,uid)){
											bMatch=false;
											break;
										}
									}
									else if(field.attributeValue("name").equalsIgnoreCase("analysisresult")){
										if(!evaluateString(field.element("value"),rs.getString("resultvalue"),rows,uid)){
											bMatch=false;
											break;
										}
									}
								}
								if(bMatch){
									if(rows.get(uid)==null){
										rows.put(uid,new Hashtable());
									}
									Hashtable variables = (Hashtable)rows.get(uid);
									Iterator outputs = filter.elementIterator("output");
									while(outputs.hasNext()){
										Element output = (Element)outputs.next();
										if(output.getText().equalsIgnoreCase("transactionid")){
											variables.put("transactionid",rs.getString("transactionid"));
										}
										else if(output.getText().equalsIgnoreCase("labanalysisuid")){
											variables.put("labanalysisuid",uid);
										}
										else if(output.getText().equalsIgnoreCase("patientuid")){
											variables.put("patientuid",rs.getString("patientid"));
										}
										else if(output.getText().equalsIgnoreCase("analysiscode")){
											variables.put("analysiscode",rs.getString("analysiscode"));
										}
									}
								}
							}
							rs.close();
							ps.close();
						}
						else{
							//This is not a first filter, we have to base ourselves on the remaining rows
							Vector rowsToRemove = new Vector();
							Iterator iRows = rows.keySet().iterator();
							while(iRows.hasNext()){
								Object uid = iRows.next();
								Hashtable variables = (Hashtable)rows.get(uid);
								//We must create a select query
								String sSelect="select * from requestedlabanalyses where 1=1";
								Vector parameters = new Vector();
								if(filter.attributeValue("periodfilter").equalsIgnoreCase("true")){
									sSelect+=" AND resultdate>=?"+
											" AND resultdate<?";
									parameters.add(new java.sql.Date(ScreenHelper.parseDate(begin).getTime()));
									parameters.add(new java.sql.Date(ScreenHelper.parseDate(end).getTime()));
								}
								//Add select criteria
								Element selectElement = filter.element("select");
								Iterator selectfields = selectElement.elementIterator("field");
								while(selectfields.hasNext()){
									Element selectField = (Element)selectfields.next();
									Element value = selectField.element("value");
									Object v = value.getText();
									if(value.attributeValue("type").equalsIgnoreCase("variable")){
										v=variables.get(value.getText());
									}
									else if(value.attributeValue("type").equalsIgnoreCase("config")){
										v=MedwanQuery.getInstance().getConfigString(value.getText(),checkString(value.attributeValue("default")));
									}
									if(selectField.attributeValue("name").equalsIgnoreCase("transactionid")){
										sSelect=setSelectInt(value, sSelect, parameters, "transactionid", Integer.parseInt((String)v));
									}
									else if(selectField.attributeValue("name").equalsIgnoreCase("patientuid")){
										sSelect=setSelectInt(value, sSelect, parameters, "patientid", Integer.parseInt((String)v));
									}
									else if(selectField.attributeValue("name").equalsIgnoreCase("analysiscode")){
										sSelect=setSelectString(value, sSelect, parameters, "analysiscode", (String)v);
									}
									else if(selectField.attributeValue("name").equalsIgnoreCase("analysisresult")){
										sSelect=setSelectString(value, sSelect, parameters, "resultvalue", value.getText());
									}
								}
								ps=conn.prepareStatement(sSelect);
								for(int n=0;n<parameters.size();n++){
									Object p = parameters.elementAt(n);
									setParameter(p, ps, n);
								}
								rs=ps.executeQuery();
								boolean bNoMatch=true;
								while(rs.next()){
									boolean bMatch = true;
									bNoMatch=false;
									//First we evaluate the criteria on each resulting row
									Iterator fields = filter.elementIterator("field");
									while(fields.hasNext()){
										Element field = (Element)fields.next();
										if(field.attributeValue("name").equalsIgnoreCase("transactionid")){
											if(!evaluateInt(field.element("value"),rs.getString("transactionid"),rows,uid)){
												bMatch=false;
												break;
											}
										}
										else if(field.attributeValue("name").equalsIgnoreCase("patientuid")){
											if(!evaluateInt(field.element("value"),rs.getString("patientid"),rows,uid)){
												bMatch=false;
												break;
											}
										}
										else if(field.attributeValue("name").equalsIgnoreCase("analysiscode")){
											if(!evaluateString(field.element("value"),rs.getString("analysiscode"),rows,uid)){
												bMatch=false;
												break;
											}
										}
										else if(field.attributeValue("name").equalsIgnoreCase("analysisresult")){
											if(!evaluateString(field.element("value"),rs.getString("resultvalue"),rows,uid)){
												bMatch=false;
												break;
											}
										}
									}
									if(!bMatch){
										//This filter does not match the criteria, remove the row
										rowsToRemove.add(uid);
									}
									else {
										break;
									}
								}
								rs.close();
								ps.close();
								if(bNoMatch){
									//This filter does not match the criteria, remove the row
									rowsToRemove.add(uid);
								}
							}
							for(int n=0;n<rowsToRemove.size();n++){
								rows.remove(rowsToRemove.elementAt(n));
							}
						}
					}
				}
				//This is the end of the counter result, output the counter
				int counter=rows.size();
				if(checkString(result.attributeValue("count")).length()>0){
					//We must count distinct values from the result rows
					HashSet hRows = new HashSet();
					Iterator iRows = rows.keySet().iterator();
					while(iRows.hasNext()){
						Object uid = iRows.next();
						Object value = ((Hashtable)rows.get(uid)).get(result.attributeValue("count"));
						if(value!=null){
							hRows.add(value);
						}
						counter=hRows.size();
					}
				}
				System.out.println("counter="+counter);
				out.println("<tr><td class='admin'>"+result.element("label").getText()+"</td><td class='admin2'>"+counter+"</td></tr>");
				out.flush();
				csvResults.append(result.element("label").getText()+";"+counter+"\n");
			}
			if(rs!=null) rs.close();
			if(ps!=null) ps.close();
		}
		System.out.println(csvResults);
		conn.close();
%>
</table>
