package com.acadify.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.io.UnsupportedEncodingException;
import java.util.Properties;

public class EmailUtil {

	public static void sendVerificationEmail(String toEmail, String username, String token) throws MessagingException {
	    final String fromEmail = "mahekvatyani17@gmail.com"; // your email
	    final String password = "ztosunkyspdgemyb";          // app password

	    String subject = "Acadify - Verify your Email";
	    String content = "Hello " + username + ",\n\n"
	                   + "Please verify your email by clicking the link below:\n"
	                   + "http://localhost:8080/Acadify/verify?token=" + token
	                   + "\n\nThank you,\nAcadify Team";

	    Properties props = new Properties();
	    props.put("mail.smtp.auth", "true");
	    props.put("mail.smtp.starttls.enable", "true");
	    props.put("mail.smtp.host", "smtp.gmail.com");
	    props.put("mail.smtp.port", "587");

	    Session session = Session.getInstance(props, new Authenticator() {
	        protected PasswordAuthentication getPasswordAuthentication() {
	            return new PasswordAuthentication(fromEmail, password);
	        }
	    });

	    Message message = new MimeMessage(session);
	    try {
	        message.setFrom(new InternetAddress(fromEmail, "Acadify"));
	    } catch (UnsupportedEncodingException e) {
	        e.printStackTrace();
	        throw new MessagingException("Failed to set sender name encoding", e);
	    }

	    message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
	    message.setSubject(subject);
	    message.setText(content);

	    Transport.send(message);
	}
	
	public static void sendEmail(String toEmail, String subject, String body) throws MessagingException {
	    final String fromEmail = "mahekvatyani17@gmail.com"; // your email
	    final String password = "ztosunkyspdgemyb";          // app password

	    Properties props = new Properties();
	    props.put("mail.smtp.auth", "true");
	    props.put("mail.smtp.starttls.enable", "true");
	    props.put("mail.smtp.host", "smtp.gmail.com");
	    props.put("mail.smtp.port", "587");

	    Session session = Session.getInstance(props, new Authenticator() {
	        protected PasswordAuthentication getPasswordAuthentication() {
	            return new PasswordAuthentication(fromEmail, password);
	        }
	    });

	    Message message = new MimeMessage(session);
	    try {
	        message.setFrom(new InternetAddress(fromEmail, "Acadify"));
	    } catch (UnsupportedEncodingException e) {
	        e.printStackTrace();
	        throw new MessagingException("Failed to set sender name encoding", e);
	    }

	    message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
	    message.setSubject(subject);
	    message.setText(body);

	    Transport.send(message);
	}


}
