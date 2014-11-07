//
//  MealDetailsViewController.h
//  Food Drlivery
//
//  Created by Admin on 11/7/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meal.h"

@interface MealDetailsViewController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *mealImageView;

@property (nonatomic, strong) Meal *selectedMeal;
@property (weak, nonatomic) IBOutlet UILabel *mealTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mealTypesLabel;
@property (weak, nonatomic) IBOutlet UILabel *mealDescriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *mealPriceLabel;
- (IBAction)addToOrderButton:(id)sender;

@end
