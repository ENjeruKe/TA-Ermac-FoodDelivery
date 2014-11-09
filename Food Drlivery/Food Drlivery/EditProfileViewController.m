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
    
    PFQuery *userQuery = [PFUser query];
    
    [userQuery getObjectInBackgroundWithId:[PFUser currentUser].objectId
                                     block:^(PFObject *userInfo, NSError *error) {
        if (!error) {
                PFFile* currentUserPhoto = (PFFile *)[userInfo objectForKey:@"profilePic"];

                self.profilePic.image =[UIImage imageWithData:currentUserPhoto.getData];
                self.profilePic.contentMode = UIViewContentModeScaleAspectFill;
                self.profilePic.clipsToBounds = YES;
            
                self.address.text = userInfo[@"address"];
        }else {
            NSLog(@"ERROR!!!");
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                     message:errorString
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
            [errorAlertView show];
        }
    }];
    
    
    self.username.text = [PFUser currentUser].username;
    self.password.text =[PFUser currentUser].password;
    self.email.text =[PFUser currentUser].email;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Устройството няма камера"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [errorAlertView show];
        
    }
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

- (IBAction)takeProfilePic:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectProfilePic:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.profilePic.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)updateProfileButton:(id)sender {
    PFQuery *userQuery = [PFUser query];
    //force refresh in order to get the data if it is updated
    [[PFUser currentUser] fetchInBackground];
    
    [userQuery getObjectInBackgroundWithId:[PFUser currentUser].objectId
                                     block:^(PFObject *userInfo, NSError *error) {
        if (!error) {
           // userInfo[@"profilePic"] = self.profilePic.image;
            userInfo[@"email"] = self.email.text;
            userInfo[@"username"] = self.username.text;
            
            //TODO check if this is the right way to update
            [PFUser currentUser].password = self.password.text;
            
            [userInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    UIStoryboard *storyboard = self.storyboard;
                    UIViewController *svc = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
                    [self presentViewController:svc animated:NO completion:nil];
                } else{
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                             message:errorString
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"Ok"
                                                                   otherButtonTitles:nil];
                    [errorAlertView show];
                }
            }];

        }else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                     message:errorString
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
            [errorAlertView show];
        }
    }];
    
}

- (IBAction)addCurrentLocation:(id)sender {
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            //NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);
            
            // Reverse Geocoding
            CLLocation *location = [[CLLocation alloc] initWithLatitude:geoPoint.latitude
                                                              longitude:geoPoint.longitude];
            
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder reverseGeocodeLocation:location
                           completionHandler:^(NSArray *placemarks, NSError *error) {
                NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
                if (error == nil && [placemarks count] > 0) {
                    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:[placemarks count]];
                    for (CLPlacemark *placemark in placemarks) {
                        [tempArray addObject:[NSString stringWithFormat:@"%@ %@, %@ %@, %@, %@",
                                              placemark.subThoroughfare == nil ? @"" : placemark.subThoroughfare,
                                              placemark.thoroughfare== nil ? @"" : placemark.thoroughfare,
                                              placemark.postalCode== nil ? @"" : placemark.postalCode,
                                              placemark.locality== nil ? @"" : placemark.locality,
                                              placemark.administrativeArea== nil ? @"" : placemark.administrativeArea,
                                              placemark.country== nil ? @"" : placemark.country]];
                    }
                  //  addressOutput = [tempArray copy];
                   // NSLog(@"%@", [tempArray description]);
                    self.address.text = [tempArray description];
                }
                else {
                  //  addressOutput = nil;
                    NSLog(@"%@", error.debugDescription);
                }
            }];
            
            [[PFUser currentUser] setObject:geoPoint forKey:@"currentLocation"];
            [[PFUser currentUser] saveInBackground];
        }else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                     message:errorString
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
            [errorAlertView show];
        }
    }];
    
}

@end
