//
//  Meal.h
//  Food Drlivery
//
//  Created by Admin on 11/5/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface Meal : PFObject<PFSubclassing>
+(NSString *)parseClassName;

//@property (retain) NSString *objectId;
@property (retain) NSString *title;
@property (retain) NSString *mealDescription;
@property (retain) PFFile *image;
@property (retain) NSNumber *price;
@property (retain) NSArray *mealType;


@end
