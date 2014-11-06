//
//  Kitchen.m
//  Food Drlivery
//
//  Created by Admin on 11/6/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import "Kitchen.h"

@implementation Kitchen

@dynamic name;

+ (void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName{
    return @"Kitchen";
}
@end
