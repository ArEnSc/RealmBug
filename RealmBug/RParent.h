//
//  RLMParent.h
//  RealmBug
//
//  Created by Michael Chung on 2015-05-26.
//  Copyright (c) 2015 Michael Chung. All rights reserved.
//

#import <Realm.h>
#import "RChild.h"
#import "RCore.h"
@interface RParent : RCore

@property RLMArray<RChild>* children;

@end
RLM_ARRAY_TYPE(RParent);