trigger AfterUpdateTest on Account (after Update) {
system.debug('---trigger.oldMap--' + trigger.oldMap);
system.debug('---trigger.NewMap--' + trigger.newMap);

}