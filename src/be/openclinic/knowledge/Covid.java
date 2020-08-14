package be.openclinic.knowledge;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Iterator;
import java.util.SortedMap;
import java.util.TreeMap;

import be.mxs.common.util.db.MedwanQuery;

public class Covid {
	public static double getHLHProbability(double score) {
		double risk = 0;
		try {
			SortedMap<Double,Double> scores = new TreeMap();
			Connection conn = MedwanQuery.getInstance().getIkireziConnection();
			PreparedStatement ps = conn.prepareStatement("select * from keyvalues where kv_type='hlh'");
			ResultSet rs =ps.executeQuery();
			while(rs.next()) {
				scores.put(rs.getDouble("kv_key"), rs.getDouble("kv_value"));
			}
			rs.close();
			ps.close();
			conn.close();
			Iterator<Double> i = scores.keySet().iterator();
			double minrisk=0,maxrisk=100, minscore=0,maxscore=500;
			while(i.hasNext()) {
				double kv_score = i.next();
				if(score==kv_score) {
					return scores.get(score);
				}
				else if(score>kv_score) {
					minscore=kv_score;
					minrisk=scores.get(kv_score);
				}
				else {
					maxscore=kv_score;
					maxrisk=scores.get(kv_score);
					break;
				}
			}
			risk = minrisk+(maxrisk-minrisk)*(score-minscore)/(maxscore-minscore);
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return risk;
	}
}
