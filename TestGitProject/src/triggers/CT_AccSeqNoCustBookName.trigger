trigger CT_AccSeqNoCustBookName on Account (before insert) {
    if(Trigger.new != null && Trigger.new.size() > 0){
            Account seqNoAccSrc = null ;
            Decimal seqNumber = 0;
            String seqNumberStr = '';
            
            List<Account> accTempList = [select a.SequenceNo__c from Account a where a.SequenceNo__c > 0 order by a.SequenceNo__c desc ];
            if(accTempList != null && accTempList.size() > 0) {
                seqNoAccSrc = accTempList.get(0);
            }
                                    
            if(seqNoAccSrc != null && seqNoAccSrc.SequenceNo__c > 0) {
                seqNumber = seqNoAccSrc.SequenceNo__c;
            } else {
                seqNumber = 0;
            }
            
            for(Account acc : Trigger.new){
                if(seqNumber == 0 || Trigger.isInsert){
                    seqNumber += 1;
                    acc.SequenceNo__c = seqNumber;
                }
                if(seqNumber != null){
                    seqNumber = acc.SequenceNo__c;
                }
                
                if(String.valueOf(Integer.valueOf(seqNumber)).length() == 1) {
                    seqNumberStr = '00000' + String.valueOf(Integer.valueOf(seqNumber));
                } else if(String.valueOf(Integer.valueOf(seqNumber)).length() == 2) {
                    seqNumberStr = '0000' + String.valueOf(Integer.valueOf(seqNumber));
                } else if(String.valueOf(Integer.valueOf(seqNumber)).length() == 3) {
                    seqNumberStr = '000' + String.valueOf(Integer.valueOf(seqNumber));
                } else if(String.valueOf(Integer.valueOf(seqNumber)).length() == 4) {
                    seqNumberStr = '00' + String.valueOf(Integer.valueOf(seqNumber));
                } else if(String.valueOf(Integer.valueOf(seqNumber)).length() == 5) {
                    seqNumberStr = '0' + String.valueOf(Integer.valueOf(seqNumber));
                } else {
                    seqNumberStr = String.valueOf(Integer.valueOf(seqNumber));
                }
                
                String accStr = acc.Name ;
                accStr = accStr.replaceAll(' ','');
                if(accStr.length() <= 4){
                    accStr = String.valueOf(accStr);
                }else{ 
                    accStr = accStr.substring(0 , 4) ;
                }
                accStr = accStr.toUpperCase();
                
                acc.CustomerBookName__c = accStr + seqNumberStr;
            }
        }
}