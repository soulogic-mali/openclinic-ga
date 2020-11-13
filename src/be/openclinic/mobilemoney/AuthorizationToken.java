package be.openclinic.mobilemoney;

import java.util.Date;

public class AuthorizationToken {
	private String token;
	private Date expires;
	
	public AuthorizationToken(String token, Date expires) {
		super();
		this.token = token;
		this.expires = expires;
	}
	public String getToken() {
		return token;
	}
	public void setToken(String token) {
		this.token = token;
	}
	public Date getExpires() {
		return expires;
	}
	public void setExpires(Date expires) {
		this.expires = expires;
	}
}
