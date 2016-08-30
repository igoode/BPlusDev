public class BPEmailFactory
{

    public static Messaging.SingleEmailMessage newEmailMessage(User currUser, String subject, String toAddress)
    {
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.setSenderDisplayName(currUser.Name);
        msg.setSubject(subject);
        msg.setToAddresses(new String[]{toAddress});
        return msg;
    }

    public static void addUserHtmlSignature(Messaging.SingleEmailMessage msg, User currUser)
    {
        String htmlBody = msg.getHtmlBody();
        htmlBody += '<br/><br/>' + currUser.Name;
        htmlBody += '<br/>' + currUser.Account_Name__c;
        htmlBody += '<br/>Email: ' + currUser.Email;
        if(currUser.MobilePhone != null) {
            htmlBody += '<br/>Mobile: ' + currUser.MobilePhone;
        }
        msg.setHtmlBody(htmlBody);
    }
}