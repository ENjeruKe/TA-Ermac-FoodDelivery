//
//  MealsViewController.h
//  Food Drlivery
//
//  Created by Borislav Boyadzhiev on 11/7/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mealsTableView;


@end
