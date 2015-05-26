//
//  DataService.h
//  RealmBug
//
//  Created by Michael Chung on 2015-05-26.
//  Copyright (c) 2015 Michael Chung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RParent.h"
typedef void(^completeBlock)(BOOL);
@interface DataService : NSObject

-(void) saveRoot:(RParent*) root withCompleteBlock:(completeBlock) complete;
-(void) saveOnlyRoot:(RParent*) root withCompleteBlock:(completeBlock) complete;
@end
