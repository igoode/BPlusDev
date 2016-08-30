public with sharing class EmailUtilities 
{
	public static void sendHTMLMessage(String emailAddress, String subject, String body, String senderDisplayName, String replyTo)
	{
		sendMessage(new String[]{emailAddress}, null, subject, body, senderDisplayName, replyTo, true);
	}
	
	public static void sendMessage(String[] emailAddresses,
													ID targetObjectId,
													String subject,
													String body,
													String senderDisplayName,
													String replyTo,
													Boolean isHTML)
	{
		Messaging.Singleemailmessage message = new Messaging.Singleemailmessage();
		if(targetObjectId == null)
		{
			message.setToAddresses(emailAddresses);
		}
		else
		{
			message.setTargetObjectId(targetObjectId);
		}
		if(isHTML)
		{
			message.setHtmlBody(body);
		}
		else
		{
			message.setPlainTextBody(body);
		}
		message.setSaveAsActivity(false);
        message.setSenderDisplayName(senderDisplayName);
        message.setReplyTo(replyTo);
		message.setSubject(subject);
		Messaging.sendEmail(new Messaging.Singleemailmessage[]{message});
	}
}