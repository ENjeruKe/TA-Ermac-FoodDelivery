//
//  Order.h
//  Food Drlivery
//
//  Created by Admin on 11/5/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import <Parse/Parse.h>

@interface Order : PFObject<PFSubclassing>
+(NSString *)parseClassName;

@property (retain) NSString *orderId;
@property (retain) NSNumber *forHome;
@property (retain) NSNumber *total;

@end
