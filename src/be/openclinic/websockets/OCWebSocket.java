package be.openclinic.websockets;

import java.io.IOException;
import javax.websocket.*;
import javax.websocket.server.*;

@ServerEndpoint("/endpoint")
public class OCWebSocket {
    
    @OnOpen
    public void onOpen(Session session) {
        System.out.println("Triggered onOpen event:" + session.getId());        
    }
    @OnClose
    public void onClose(Session session) {
        System.out.println("Triggered onClose event:" +  session.getId());
    }
    
    @OnMessage
    public void onMessage(String message, Session session) {
        System.out.println("Triggered onMessage event :From=" + session.getId() + " Message=" + message);
        
        try {
            session.getBasicRemote().sendText("Hello Client " + session.getId() + "!");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    @OnError
    public void onError(Throwable t) {
        System.out.println("Triggered onError event:" + t.getMessage());
    }
}