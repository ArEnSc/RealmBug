//
//  DataService.m
//  RealmBug
//
//  Created by Michael Chung on 2015-05-26.
//  Copyright (c) 2015 Michael Chung. All rights reserved.
//

#import "DataService.h"

@implementation DataService


-(NSString*) generateUUID {
    return [[NSUUID UUID] UUIDString];
}


-(void) saveOnlyRoot:(RParent*) root withCompleteBlock:(completeBlock) complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
       
        
        RLMRealm* db = [RLMRealm defaultRealm];
        
        [db beginWriteTransaction];
        
        
        if (root.isMarkedForDelete == YES) {
            [db deleteObjects:root];
            complete(@YES);
            return;
        }
        else {
            if (root.id == nil) {
                root.id = [self generateUUID];
            }
            
            [RParent createOrUpdateInDefaultRealmWithValue:root];
        }
        [db commitWriteTransaction];
        
        complete(@YES);
        
    });
}


-(void) saveRoot:(RParent*) root withCompleteBlock:(completeBlock) complete {
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        RLMRealm* db = [RLMRealm defaultRealm];
        
        [db beginWriteTransaction];
        
        if (root.isMarkedForDelete == YES) {
            [db deleteObject:root]; // Should delete corresponding children right ? This is my assumption.
            complete(YES);
            return;
        }
        else {
            if (root.id == nil) {
                root.id = [self generateUUID];
            }
            
            
            // check if there are children to save first.
            if(root.children !=nil) {
                
                for (RChild* child in root.children) {
                    
                    if (child.isMarkedForDelete == YES) {
                        [db deleteObject:child];
                    }
                    else {
                        
                        if (child.id == nil) {
                            child.id = [self generateUUID];
                        }
                        
                        [RChild createOrUpdateInDefaultRealmWithValue:child];
                    }
                }
            }
            
            [RParent createOrUpdateInDefaultRealmWithValue:root];
        }
        [db commitWriteTransaction];
    
        complete(@YES);
    });
    
    
}

@end
