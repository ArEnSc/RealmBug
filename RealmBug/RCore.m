//
//  RLMCore.m
//  RealmBug
//
//  Created by Michael Chung on 2015-05-26.
//  Copyright (c) 2015 Michael Chung. All rights reserved.
//

#import "RCore.h"

@implementation RCore

+(NSString *)primaryKey
{
    return @"id";
}

+(NSDictionary *)defaultPropertyValues {
    return @{@"name":@"default"};
}

@end
