//
//  OrderDetailsViewController.h
//  Food Drlivery
//
//  Created by Admin on 11/7/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mealsInOrderTableView;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *orderTypeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
- (IBAction)cancelOrderButtonAction:(id)sender;
- (IBAction)performOrderButtonAction:(id)sender;

@end
