//
//  Order.m
//  Food Drlivery
//
//  Created by Admin on 11/5/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import "Order.h"

@implementation Order

@dynamic orderId;
@dynamic forHome;
@dynamic total;

+ (void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName{
    return @"Order";
}

@end
