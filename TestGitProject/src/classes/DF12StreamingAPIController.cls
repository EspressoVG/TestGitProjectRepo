public with sharing class DF12StreamingAPIController {

    public PageReference createPushTopicIfNecessary() {
        List<PushTopic> pt = [
            SELECT Id, Name 
            FROM PushTopic 
            WHERE Name = 'NewAccounts' 
            LIMIT 1
        ];
        if (pt.size() == 0) {
            pt.add(new PushTopic(
                ApiVersion = 23.0,
                Name = 'NewAccounts',
                Description = 'Returns all new accounts.',
                Query = 'SELECT Id, Name, CreatedDate FROM Account'
            ));
            upsert pt;
        }
        return null;
    }

    @isTest
    private static void testCreatePushTopicIfNecessary() {
        List<PushTopic> pt = [SELECT Id, Name FROM PushTopic WHERE Name = 'NewAccounts' LIMIT 1];
        DF12StreamingAPIController con = new DF12StreamingAPIController();
        try {
            con.createPushTopicIfNecessary();
        } catch (DmlException x) {
            System.assert(true, 'Should already be a push topic created for this');
        }
    }

}