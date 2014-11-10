//
//  ProfileViewController.h
//  Food Drlivery
//
//  Created by user on 08/11/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *email;
- (IBAction)editProfileButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *address;
- (IBAction)logoutButton:(id)sender;
@end
