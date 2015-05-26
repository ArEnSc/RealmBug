//
//  AppDelegate.m
//  RealmBug
//
//  Created by Michael Chung on 2015-05-26.
//  Copyright (c) 2015 Michael Chung. All rights reserved.
//

#import "AppDelegate.h"
#import <Realm.h>
#import "DataService.h"
#import "RParent.h"
#import "RChild.h"

@interface AppDelegate ()
@property (strong,nonatomic) DataService* dataservice;
@end

@implementation AppDelegate

-(void) documents {
    NSString *appFolderPath = [[NSBundle mainBundle] resourcePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSLog(@"App Directory is: %@", appFolderPath);
    NSLog(@"Directory Contents:\n%@", [fileManager directoryContentsAtPath: appFolderPath]);
}



-(RParent*) giveMeParentObject {
    
    RParent* parent = [[RParent alloc] init];
    parent.name = @"Jimmy";
    RChild* child = [[RChild alloc] init];
    child.name = @"Child Andrew";
    [parent.children addObject:child];
    
    return parent;
}

-(RParent*) giveMeJustParentObject{
    RParent* parent = [[RParent alloc] init];
    parent.name = @"Jimmy";
    return parent;
}

-(void) parentIsSaved {
    
    
    [self.dataservice saveOnlyRoot:[self giveMeJustParentObject] withCompleteBlock:^(BOOL yes) {
       
        RLMResults* results = [RParent allObjects];
        
        RParent* parent = [results objectAtIndex:[results count]-1];
        
        // updating parent object
        
        RParent* updatingParent = [[RParent alloc] initWithValue:parent];
        updatingParent.name = @"Parent Name is updated!!";
        
        
        [self.dataservice saveOnlyRoot:updatingParent withCompleteBlock:^(BOOL yes) {
            
        }];
        
        
    }];
}

-(void) tooMuchCodeButWorks {
    
    [self.dataservice saveRoot:[self giveMeParentObject] withCompleteBlock:^(BOOL no) {
        
        RLMResults* results = [RParent allObjects];
        
        RParent* parent = [results objectAtIndex:[results count]-1];
        
        // updating parent object
        
        RParent* updatingParent = [[RParent alloc] init];
        
        updatingParent.name = @"Updated Parent name";
        updatingParent.id = parent.id;
        
        RChild* updatingChild = [[RChild alloc] init];
        
        RChild* child = [[parent children] objectAtIndex:0];
        
        updatingChild.id = child.id;
        updatingChild.name = @"New Child Name";
        
        [updatingParent.children addObject:updatingChild];
        
        // this will not a thread error.
        // but requires quite a bit of work inorder to do a save alot of type
        
        [self.dataservice saveRoot:updatingParent withCompleteBlock:^(BOOL Yep) {
            
        }];
        
        
    }];

    
}
-(void) threadIssueTwo {
    
    [self.dataservice saveRoot:[self giveMeParentObject] withCompleteBlock:^(BOOL no) {
        
        RLMResults* results = [RParent allObjects];
        
        RParent* parent = [results objectAtIndex:[results count]-1];
        
        // updating parent object
        
        RParent* updatingParent = [[RParent alloc] init];
        
        updatingParent.name = @"Updated Parent name";
        updatingParent.id = parent.id;
        
        updatingParent.children = parent.children;
        
        // this will not a thread error.
        // but requires quite a bit of work inorder to do a save alot of type
        
        [self.dataservice saveRoot:updatingParent withCompleteBlock:^(BOOL Yep) {
            
        }];
        
        
    }];

    
    
}

-(void) threadIssue {
    
    
    // This piece of code WILL cause a thread access error.
    
    [self.dataservice saveRoot:[self giveMeParentObject] withCompleteBlock:^(BOOL Yep) {
        
        RLMResults* results = [RParent allObjects];
        
        RParent* parent = [results objectAtIndex:[results count]-1];
        
        // updating parent object
        
        RParent* updatingParent = [[RParent alloc] initWithValue:parent];
        
        updatingParent.name = @"Updated Parent name";
        
        [self.dataservice saveRoot:updatingParent withCompleteBlock:^(BOOL Yep) {
            
        }];
        
    }];
    
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self documents];
    self.dataservice = [[DataService alloc] init];
    // Make sure you run one case at a time since these are async.
   
    /**
     This shows what I am trying to achieve that is reduce the amount of reference copying by coding by hand.
     **/
    //[self tooMuchCodeButWorks];
    
    /**
     This shows that init with value does appear to work for my case and copies over the references.
     **/
    //[self parentIsSaved];

    
    /**
     This shows iusing init with value with children 
     I add children to the mix it causes a thread access error.
     **/
    //[self threadIssue];
    
    
    /**
     This shows if I just provide a reference to the children it says I am acessing it from a different thread.
     **/
    [self threadIssueTwo];
    
    
    // Conclusion initWithValue:(RLMObject*) does not properly reference the children ? 
    
    // This piece of code WILL not cause a thread access error.
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
