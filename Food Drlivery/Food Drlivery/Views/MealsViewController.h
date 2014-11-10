//
//  MealsViewController.h
//  Food Drlivery
//
//  Created by Borislav Boyadzhiev on 11/7/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meal.h"

@interface MealsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mealsTableView;
@property (nonatomic, strong) Meal *selected;
@end
