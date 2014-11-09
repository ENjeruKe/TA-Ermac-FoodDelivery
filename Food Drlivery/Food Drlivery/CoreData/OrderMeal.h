//
//  OrderMeal.h
//  Food Drlivery
//
//  Created by Borislav Boyadzhiev on 11/8/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OrderMeal : NSManagedObject

@property (nonatomic, retain) NSString * mealId;
@property (nonatomic, retain) NSNumber * quantity;

@end
