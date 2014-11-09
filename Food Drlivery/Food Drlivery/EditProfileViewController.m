//
//  EditProfileViewController.m
//  Food Drlivery
//
//  Created by user on 09/11/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import <Parse/Parse.h>
#import "EditProfileViewController.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFQuery *queryPhoto = [PFUser query];
    [queryPhoto whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    
    [queryPhoto findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                PFObject* profilePhotoObject = objects[0];
                PFFile* currentUserPhoto = (PFFile *)[profilePhotoObject objectForKey:@"profilePic"];

                self.profilePic.image =[UIImage imageWithData:currentUserPhoto.getData];
                self.profilePic.contentMode = UIViewContentModeScaleAspectFill;
                self.profilePic.clipsToBounds = YES;
            }
        }else {
            NSLog(@"ERROR!!!");
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
