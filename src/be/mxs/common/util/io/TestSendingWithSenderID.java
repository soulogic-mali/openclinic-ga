package be.mxs.common.util.io;

import com.africastalking.Callback;
import com.africastalking.SmsService;
import com.africastalking.sms.Message;
import com.africastalking.sms.Recipient;
import com.africastalking.AfricasTalking;

import java.util.List;
import java.io.IOException;

public class TestSendingWithSenderID {

    public static void main(String[] args) {
		/* Set your app credentials */
		String USERNAME = "sandbox";
		String API_KEY = "83332bd8adb9681a90962ad6377e461a68101175168fc75d9f05e05555c33f34";

		/* Initialize SDK */
		AfricasTalking.initialize(USERNAME, API_KEY);

		/* Get the SMS service */
		SmsService sms = AfricasTalking.getService(AfricasTalking.SERVICE_SMS);

		/* Set the numbers you want to send to in international format */
		String[] recipients = new String[] {
			"+25768350265"
		};

		/* Set your message */
		String message = "This is a test message";

		/* Set your shortCode or senderId */
		String from = "OpenClinic"; // or "ABCDE"

		/* That’s it, hit send and we’ll take care of the rest */
		try {
			List<Recipient> response = sms.send(message, from, recipients, true);
			for (Recipient recipient : response) {
				System.out.print(recipient.number);
				System.out.print(" : ");
				System.out.println(recipient.status);
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		}
   	}
}