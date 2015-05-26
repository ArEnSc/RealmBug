//
//  RLMCore.h
//  RealmBug
//
//  Created by Michael Chung on 2015-05-26.
//  Copyright (c) 2015 Michael Chung. All rights reserved.
//

#import <Realm.h>
@interface RCore : RLMObject

@property NSString* id;
@property NSString* name;
@property BOOL isMarkedForDelete;

@end
