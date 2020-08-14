package be.openclinic.adt;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.StatFunctions;

public class Queue {
	private int objectid=-1;
	private String id;
	private String subjecttype;
	private String subjectuid;
	private java.util.Date begin;
	private String beginuid;
	private java.util.Date end;
	private String enduid;
	private String endreason;
	private String transferto;
	private int ticketnumber;
	
	public int getObjectid() {
		return objectid;
	}

	public int getTicketnumber() {
		return ticketnumber;
	}

	public void setTicketnumber(int ticketnumber) {
		this.ticketnumber = ticketnumber;
	}

	public void setObjectid(int objectid) {
		this.objectid = objectid;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getSubjecttype() {
		return subjecttype;
	}

	public void setSubjecttype(String subjecttype) {
		this.subjecttype = subjecttype;
	}

	public String getSubjectuid() {
		return subjectuid;
	}

	public void setSubjectuid(String subjectuid) {
		this.subjectuid = subjectuid;
	}

	public java.util.Date getBegin() {
		return begin;
	}

	public void setBegin(java.util.Date begin) {
		this.begin = begin;
	}

	public String getBeginuid() {
		return beginuid;
	}

	public void setBeginuid(String beginuid) {
		this.beginuid = beginuid;
	}

	public java.util.Date getEnd() {
		return end;
	}

	public void setEnd(java.util.Date end) {
		this.end = end;
	}

	public String getEnduid() {
		return enduid;
	}

	public void setEnduid(String enduid) {
		this.enduid = enduid;
	}

	public String getEndreason() {
		return endreason;
	}

	public void setEndreason(String endreason) {
		this.endreason = endreason;
	}

	public String getTransferto() {
		return transferto;
	}

	public void setTransferto(String transferto) {
		this.transferto = transferto;
	}
	
	public static boolean activePatientQueueExists(String queueid,String personid){
		boolean bExists=false;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			PreparedStatement ps = conn.prepareStatement("select * from oc_queues where oc_queue_subjecttype='patient' and oc_queue_subjectuid=? and oc_queue_id=? and oc_queue_end is null");
			ps.setString(1,personid);
			ps.setString(2,queueid);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				bExists=true;
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return bExists;
	}
	
	public String getEstimatedTime(){
		String time="?";
		int interval = MedwanQuery.getInstance().getConfigInt("queuestats.median."+this.getId(),0);
		if(interval>0){
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			try {			
				PreparedStatement ps = conn.prepareStatement("select count(*) total from oc_queues where oc_queue_subjecttype='patient' and oc_queue_id=? and oc_queue_end is null and oc_queue_begin<?");
				ps.setString(1,this.getId());
				ps.setTimestamp(2,new java.sql.Timestamp(this.getBegin().getTime()));
				ResultSet rs = ps.executeQuery();
				if(rs.next()){
					int total = rs.getInt("total");
					time=new SimpleDateFormat("HH:mm").format(new java.util.Date(new java.util.Date().getTime()+total*interval));
				}
				rs.close();
				ps.close();
				conn.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		return time;
	}
	
	public void store(){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps=null;
		try {
			if(this.getObjectid()>-1){
				ps = conn.prepareStatement("delete from oc_queues where oc_queue_objectid=?");
				ps.setInt(1, this.getObjectid());
				ps.execute();
				ps.close();
			}
			else {
				this.setObjectid(MedwanQuery.getInstance().getOpenclinicCounter("QUEUEID"));
				this.setTicketnumber(MedwanQuery.getInstance().getOpenclinicCounter("QUEUETICKETNUMBER"));
			}
			ps=conn.prepareStatement("insert into oc_queues(oc_queue_objectid,oc_queue_id,oc_queue_begin,oc_queue_beginuid,oc_queue_end,oc_queue_enduid,"+
									"oc_queue_endreason,oc_queue_subjecttype,oc_queue_subjectuid,oc_queue_transferto,oc_queue_ticketnumber) values (?,?,?,?,?,?,?,?,?,?,?)");
			ps.setInt(1, this.getObjectid());
			ps.setString(2, this.getId());
			ps.setTimestamp(3, this.getBegin()==null?null:new java.sql.Timestamp(this.getBegin().getTime()));
			ps.setString(4, this.getBeginuid());
			ps.setTimestamp(5, this.getEnd()==null?null:new java.sql.Timestamp(this.getEnd().getTime()));
			ps.setString(6, this.getEnduid());
			ps.setString(7, this.getEndreason());
			ps.setString(8, this.getSubjecttype());
			ps.setString(9, this.getSubjectuid());
			ps.setString(10, this.getTransferto());
			ps.setInt(11, this.getTicketnumber());
			ps.execute();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}

	public static void resetQueues(String endreason, int enduser){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			PreparedStatement ps = conn.prepareStatement("update oc_queues set oc_queue_end=?, oc_queue_endreason=?, oc_queue_enduid=? where oc_queue_subjecttype='patient' and oc_queue_end is null");
			ps.setTimestamp(1,new java.sql.Timestamp(new java.util.Date().getTime()));
			ps.setString(2,endreason);
			ps.setInt(3, enduser);
			ps.execute();
			ps.close();
			conn.close();
			MedwanQuery.getInstance().setOpenclinicCounter("QUEUETICKETNUMBER", 0);
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public static void closeTicket(int objectid,String endreason,int enduser){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			PreparedStatement ps = conn.prepareStatement("update oc_queues set oc_queue_end=?, oc_queue_endreason=?, oc_queue_enduid=? where oc_queue_objectid=?");
			ps.setTimestamp(1,new java.sql.Timestamp(new java.util.Date().getTime()));
			ps.setString(2,endreason);
			ps.setInt(3, enduser);
			ps.setInt(4, objectid);
			ps.execute();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public static Vector getActivePatientQueues(String personid){
		Vector v=new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			PreparedStatement ps = conn.prepareStatement("select * from oc_queues where oc_queue_subjecttype='patient' and oc_queue_subjectuid=? and oc_queue_end is null");
			ps.setString(1,personid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				Queue queue =new Queue();
				queue.setBegin(rs.getTimestamp("oc_queue_begin"));
				queue.setBeginuid(rs.getString("oc_queue_beginuid"));
				queue.setEnd(rs.getTimestamp("oc_queue_end"));
				queue.setEnduid(rs.getString("oc_queue_enduid"));
				queue.setEndreason(rs.getString("oc_queue_endreason"));
				queue.setId(rs.getString("oc_queue_id"));
				queue.setObjectid(rs.getInt("oc_queue_objectid"));
				queue.setSubjecttype(rs.getString("oc_queue_subjecttype"));
				queue.setSubjectuid(rs.getString("oc_queue_subjectuid"));
				queue.setTransferto(rs.getString("oc_queue_transferto"));
				queue.setTicketnumber(rs.getInt("oc_queue_ticketnumber"));
				v.add(queue);
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return v;
	}

	public static SortedMap calculateStats(){
		long d = 24*3600*1000;
		return calculateStats(new java.util.Date(new java.util.Date().getTime()-MedwanQuery.getInstance().getConfigInt("queueStatsDurationInDays",90)*d),new java.util.Date());
	}
	
	public static SortedMap calculateStats(java.util.Date begin, java.util.Date end){
		SortedMap stats = new TreeMap();
		Hashtable queues = new Hashtable();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			PreparedStatement ps = conn.prepareStatement("select * from oc_queues where oc_queue_subjecttype='patient' and oc_queue_end is not null and oc_queue_begin>=? and oc_queue_begin<? and oc_queue_endreason=?");
			ps.setTimestamp(1,new java.sql.Timestamp(begin.getTime()));
			ps.setTimestamp(2,new java.sql.Timestamp(end.getTime()));
			ps.setString(3, MedwanQuery.getInstance().getConfigString("queueSeenValue","1"));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				String id = rs.getString("oc_queue_id");
				if(queues.get(id)==null){
					queues.put(id, new Vector());
				}
				((Vector)queues.get(id)).add(rs.getTimestamp("oc_queue_end").getTime()-rs.getTimestamp("oc_queue_begin").getTime());
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		//For each queue, calculate stats
		Enumeration eQueues = queues.keys();
		while(eQueues.hasMoreElements()){
			String queueid = (String)eQueues.nextElement();
			Vector durations = (Vector)queues.get(queueid);
			Long median = (Long)StatFunctions.getMedian(durations);
			stats.put(queueid, median);
			MedwanQuery.getInstance().setConfigString("queuestats.median."+queueid, median+"");
		}
		return stats;
	}
	
	public static Vector getPassivePatientQueues(String personid){
		Vector v=new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			PreparedStatement ps = conn.prepareStatement("select * from oc_queues where oc_queue_subjecttype='patient' and oc_queue_subjectuid=? and oc_queue_end is not null order by oc_queue_end desc");
			ps.setString(1,personid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				Queue queue =new Queue();
				queue.setBegin(rs.getTimestamp("oc_queue_begin"));
				queue.setBeginuid(rs.getString("oc_queue_beginuid"));
				queue.setEnd(rs.getTimestamp("oc_queue_end"));
				queue.setEnduid(rs.getString("oc_queue_enduid"));
				queue.setEndreason(rs.getString("oc_queue_endreason"));
				queue.setId(rs.getString("oc_queue_id"));
				queue.setObjectid(rs.getInt("oc_queue_objectid"));
				queue.setSubjecttype(rs.getString("oc_queue_subjecttype"));
				queue.setSubjectuid(rs.getString("oc_queue_subjectuid"));
				queue.setTransferto(rs.getString("oc_queue_transferto"));
				queue.setTicketnumber(rs.getInt("oc_queue_ticketnumber"));
				v.add(queue);
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return v;
	}

	public static Vector getActiveQueue(String queueid){
		Vector v=new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			PreparedStatement ps = conn.prepareStatement("select * from oc_queues where oc_queue_subjecttype='patient' and oc_queue_id=? and oc_queue_end is null order by oc_queue_begin");
			ps.setString(1,queueid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				Queue queue =new Queue();
				queue.setBegin(rs.getTimestamp("oc_queue_begin"));
				queue.setBeginuid(rs.getString("oc_queue_beginuid"));
				queue.setEnd(rs.getTimestamp("oc_queue_end"));
				queue.setEnduid(rs.getString("oc_queue_enduid"));
				queue.setEndreason(rs.getString("oc_queue_endreason"));
				queue.setId(rs.getString("oc_queue_id"));
				queue.setObjectid(rs.getInt("oc_queue_objectid"));
				queue.setSubjecttype(rs.getString("oc_queue_subjecttype"));
				queue.setSubjectuid(rs.getString("oc_queue_subjectuid"));
				queue.setTransferto(rs.getString("oc_queue_transferto"));
				queue.setTicketnumber(rs.getInt("oc_queue_ticketnumber"));
				v.add(queue);
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return v;
	}

	public static Vector getTodayQueue(String queueid){
		Vector v=new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			PreparedStatement ps = conn.prepareStatement("select * from oc_queues where oc_queue_subjecttype='patient' and oc_queue_id=? and oc_queue_begin>=? order by oc_queue_begin");
			ps.setString(1,queueid);
			ps.setDate(2, new java.sql.Date(new java.util.Date().getTime()));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				Queue queue =new Queue();
				queue.setBegin(rs.getTimestamp("oc_queue_begin"));
				queue.setBeginuid(rs.getString("oc_queue_beginuid"));
				queue.setEnd(rs.getTimestamp("oc_queue_end"));
				queue.setEnduid(rs.getString("oc_queue_enduid"));
				queue.setEndreason(rs.getString("oc_queue_endreason"));
				queue.setId(rs.getString("oc_queue_id"));
				queue.setObjectid(rs.getInt("oc_queue_objectid"));
				queue.setSubjecttype(rs.getString("oc_queue_subjecttype"));
				queue.setSubjectuid(rs.getString("oc_queue_subjectuid"));
				queue.setTransferto(rs.getString("oc_queue_transferto"));
				queue.setTicketnumber(rs.getInt("oc_queue_ticketnumber"));
				v.add(queue);
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return v;
	}

	public static Queue get(int objectid){
		Queue queue=null;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			PreparedStatement ps = conn.prepareStatement("select * from oc_queues where oc_queue_objectid=?");
			ps.setInt(1,objectid);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				queue =new Queue();
				queue.setBegin(rs.getTimestamp("oc_queue_begin"));
				queue.setBeginuid(rs.getString("oc_queue_beginuid"));
				queue.setEnd(rs.getTimestamp("oc_queue_end"));
				queue.setEnduid(rs.getString("oc_queue_enduid"));
				queue.setEndreason(rs.getString("oc_queue_endreason"));
				queue.setId(rs.getString("oc_queue_id"));
				queue.setObjectid(rs.getInt("oc_queue_objectid"));
				queue.setSubjecttype(rs.getString("oc_queue_subjecttype"));
				queue.setSubjectuid(rs.getString("oc_queue_subjectuid"));
				queue.setTransferto(rs.getString("oc_queue_transferto"));
				queue.setTicketnumber(rs.getInt("oc_queue_ticketnumber"));
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return queue;
	}
	
	public static Queue getByActiveTicketNumber(int ticketnumber){
		Queue queue=null;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			PreparedStatement ps = conn.prepareStatement("select * from oc_queues where oc_queue_ticketnumber=? and oc_queue_end is null");
			ps.setInt(1,ticketnumber);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				queue =new Queue();
				queue.setBegin(rs.getTimestamp("oc_queue_begin"));
				queue.setBeginuid(rs.getString("oc_queue_beginuid"));
				queue.setEnd(rs.getTimestamp("oc_queue_end"));
				queue.setEnduid(rs.getString("oc_queue_enduid"));
				queue.setEndreason(rs.getString("oc_queue_endreason"));
				queue.setId(rs.getString("oc_queue_id"));
				queue.setObjectid(rs.getInt("oc_queue_objectid"));
				queue.setSubjecttype(rs.getString("oc_queue_subjecttype"));
				queue.setSubjectuid(rs.getString("oc_queue_subjectuid"));
				queue.setTransferto(rs.getString("oc_queue_transferto"));
				queue.setTicketnumber(rs.getInt("oc_queue_ticketnumber"));
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return queue;
	}
}
