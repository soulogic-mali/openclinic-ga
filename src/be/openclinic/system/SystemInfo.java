package be.openclinic.system;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.Enumeration;

import be.mxs.common.util.db.MedwanQuery;

public class SystemInfo {
	private String vpnDomain="?";
	private String vpnName="?";
	private String vpnAddress="?";
	private String vpnPort="80";
	private long upTime=-1;
	private long diskSpace=-1;
	private int usersConnected=-1;
	
	public String serialize() {
		return vpnDomain+";"+vpnName+";"+vpnAddress+";"+upTime+";"+diskSpace+";"+usersConnected+";"+vpnPort;
	}
	
	public String getVpnPort() {
		return vpnPort;
	}

	public void setVpnPort(String vpnPort) {
		this.vpnPort = vpnPort;
	}

	public static SystemInfo parse(String s) {
		SystemInfo systemInfo = new SystemInfo();
		if(s.split(";").length>=6) {
			systemInfo.setVpnDomain(s.split(";")[0]);
			systemInfo.setVpnName(s.split(";")[1]);
			systemInfo.setVpnAddress(s.split(";")[2]);
			try {
				systemInfo.setUpTime(Long.parseLong(s.split(";")[3]));
			}
			catch(Exception e) {e.printStackTrace();}
			try {
				systemInfo.setDiskSpace(Long.parseLong(s.split(";")[4]));
			}
			catch(Exception e) {e.printStackTrace();}
			try {
				systemInfo.setUsersConnected(Integer.parseInt(s.split(";")[5]));
			}
			catch(Exception e) {e.printStackTrace();}
		}
		if(s.split(";").length>=7) {
			systemInfo.setVpnPort(s.split(";")[6]);
		}
		return systemInfo;
	}
	
	public String getVpnDomain() {
		return vpnDomain;
	}

	public void setVpnDomain(String vpnDomain) {
		this.vpnDomain = vpnDomain;
	}

	public String getVpnName() {
		return vpnName;
	}


	public void setVpnName(String vpnName) {
		this.vpnName = vpnName;
	}


	public String getVpnAddress() {
		return vpnAddress;
	}


	public void setVpnAddress(String vpnAddress) {
		this.vpnAddress = vpnAddress;
	}


	public long getUpTime() {
		return upTime;
	}

	public String getUpTimeFormatted() {
		long minute = 60;
		long hour = 60*minute;
		long day = 24*hour;
		return upTime/day+"d "+(upTime%day)/hour+"h "+(upTime%hour)/minute+"m "+(upTime%minute)+"s";
	}

	public static String getUpTimeFormatted(long upTime) {
		long minute = 60;
		long hour = 60*minute;
		long day = 24*hour;
		return upTime/day+"d "+(upTime%day)/hour+"h "+(upTime%hour)/minute+"m "+(upTime%minute)+"s";
	}

	public void setUpTime(long upTime) {
		this.upTime = upTime;
	}

	public void setUpTime(String upTime) {
		try {
			this.upTime = Long.parseLong(upTime);
		}
		catch(Exception e) {e.printStackTrace();}
	}


	public long getDiskSpace() {
		return diskSpace;
	}

	public void setDiskSpace(long diskSpace) {
		this.diskSpace = diskSpace;
	}

	public void setDiskSpace(String diskSpace) {
		try {
			this.diskSpace = Long.parseLong(diskSpace);
		}
		catch(Exception e) {e.printStackTrace();}
	}

	public int getUsersConnected() {
		return usersConnected;
	}

	public void setUsersConnected(int usersConnected) {
		this.usersConnected = usersConnected;
	}

	public void setUsersConnected(String usersConnected) {
		try {
			this.usersConnected = Integer.parseInt(usersConnected);
		}
		catch(Exception e) {e.printStackTrace();}
	}

	public static String getVPNIpAddress() {
		String s = "";
		try {
			Enumeration e = NetworkInterface.getNetworkInterfaces();
			while(e.hasMoreElements())
			{
			    NetworkInterface n = (NetworkInterface) e.nextElement();
			    Enumeration ee = n.getInetAddresses();
			    while (ee.hasMoreElements())
			    {
			        InetAddress i = (InetAddress) ee.nextElement();
			        if(i.getHostAddress().startsWith(MedwanQuery.getInstance().getConfigString("vpnPrefix","10.8.")) || i.getHostAddress().startsWith(MedwanQuery.getInstance().getConfigString("vpnPrefix","10.9."))) {
			        	s=i.getHostAddress();
			        	break;
			        }
			    }
			}		
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return s;
	}

	public static long getSystemUptime() {
		long systemUptime = -1;
		systemUptime= new oshi.SystemInfo().getHardware().getProcessor().getSystemUptime();
		return systemUptime;
	}
	
	public static long getSystemDiskSpace() {
		long systemDiskSpace = new java.io.File(MedwanQuery.getInstance().getConfigString("datacenterDataPartition","/")).getUsableSpace();
		return systemDiskSpace;
	}
	
	public static int getActiveUserCount() {
		int userCount = MedwanQuery.getSessions().size();
		return userCount;
	}
}
