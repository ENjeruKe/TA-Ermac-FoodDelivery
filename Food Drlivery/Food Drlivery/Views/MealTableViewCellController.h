//
//  MealTableViewCellController.h
//  Food Drlivery
//
//  Created by Admin on 11/7/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealTableViewCellController : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mealTitle;
@property (weak, nonatomic) IBOutlet UILabel *mealTypes;
@property (weak, nonatomic) IBOutlet UIImageView *mealImage;

@end
