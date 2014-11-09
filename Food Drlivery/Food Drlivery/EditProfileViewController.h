//
//  EditProfileViewController.h
//  Food Drlivery
//
//  Created by user on 09/11/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UIButton *selectProfilePic;
@property (weak, nonatomic) IBOutlet UIButton *takeProfilePic;
@property (weak, nonatomic) IBOutlet UIButton *updateProfileButton;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@end
