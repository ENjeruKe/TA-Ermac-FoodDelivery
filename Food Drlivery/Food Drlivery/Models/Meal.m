//
//  Meal.m
//  Food Drlivery
//
//  Created by Admin on 11/5/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import "Meal.h"

@implementation Meal

//@dynamic objectId;
@dynamic title;
@dynamic price;
@dynamic image;
@dynamic mealDescription;
@dynamic mealType;


+ (void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName{
    return @"Meal";
}
@end
