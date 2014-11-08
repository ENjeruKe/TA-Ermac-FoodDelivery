//
//  ProfileViewController.m
//  Food Drlivery
//
//  Created by user on 08/11/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import <Parse/Parse.h>
#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFQuery* queryPhoto = [PFQuery queryWithClassName:@"User"];
    [queryPhoto whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [queryPhoto findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // Verify if there are no errors
        if (!error) {
            
            PFObject* profilePhotoObject = objects[0];
            PFFile* currentUserPhoto = (PFFile *)[profilePhotoObject objectForKey:@"profilePic"];
            UIImageView* currentUserImage = [[UIImageView alloc]initWithImage:[UIImage imageWithData:currentUserPhoto.getData]];
            self.profilePic = currentUserImage;

        }else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
            
        }
    }];

    
    self.username.text = [PFUser currentUser].username;
    self.email.text =[PFUser currentUser].email;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
