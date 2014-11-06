//
//  Kitchen.h
//  Food Drlivery
//
//  Created by Admin on 11/6/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import <Parse/Parse.h>

@interface Kitchen : PFObject<PFSubclassing>
+(NSString *)parseClassName;

@property (retain) NSString* name;

@end
