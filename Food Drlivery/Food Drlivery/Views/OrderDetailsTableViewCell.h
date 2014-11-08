//
//  OrderDetailsTableViewCell.h
//  Food Drlivery
//
//  Created by Admin on 11/8/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mealImage;
@property (weak, nonatomic) IBOutlet UILabel *mealTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mealPriceLabel;

@end
