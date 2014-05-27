global class mp_PassportInboundEmailHandler implements Messaging.Inboundemailhandler {
    global Messaging.Inboundemailresult handleInboundEmail(Messaging.inboundEmail email, Messaging.Inboundenvelope env){
    system.debug('---into Inbound Email Service---');
    Contact con = [Select Id, Name, Email, accountId From Contact Where Email = :email.fromAddress and name = 'warda Dirir' Limit 1];

        if(con != null){
            system.debug('---con---' + con);
            case c = new case();
            c.ContactId = con.Id;
            c.AccountId = con.accountId;
            c.Origin = 'Email';
            c.Subject = email.subject;
            c.Description = email.plainTextBody;
              
            insert c;
        }
    Case newCase = [Select Id, lastmodifieddate from Case order by lastmodifiedDate DESC LIMIT 1 ]; 
    System.debug('---newCase----' + newCase);
    List<Attachment> attachList = new List<Attachment>();
    if (email.textAttachments != null && email.textAttachments.size() > 0) {
        for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments)
        {    
            System.debug('---tAttachment----' + tAttachment.body);
            Attachment attachment = new Attachment();
        
            attachment.Name = tAttachment.fileName;
            attachment.Body = Blob.valueOf(tAttachment.body);
            attachment.ParentId = newCase.Id;
            attachList.add(attachment);
    
        }
    }
    if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
        for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
            Attachment attachment = new Attachment();
            // attach to the newly created contact record
            attachment.ParentId = newCase.Id;
            attachment.Name = email.binaryAttachments[i].filename;
            attachment.Body = email.binaryAttachments[i].body;
            attachList.add(attachment);
        }
    }
    insert attachList;
    return null;
  }
}