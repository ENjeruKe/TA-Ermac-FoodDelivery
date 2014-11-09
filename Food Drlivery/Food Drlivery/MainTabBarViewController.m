//
//  TableBarsViewController.m
//  Food Drlivery
//
//  Created by Admin on 11/6/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import "MainTabBarViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITabBar *tabBar = self.tabBar;
    
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    [item1 setEnabled:NO];
    UIImage *mealIcon = [[UIImage imageNamed:@"meal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orderIcon = [[UIImage imageNamed:@"order.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *profileIcon = [[UIImage imageNamed:@"profile.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item0 setImage:mealIcon];
    [item0 setSelectedImage:mealIcon];
    [item1 setImage:orderIcon];
    [item1 setSelectedImage:orderIcon];
    [item2 setImage:profileIcon];
    [item2 setSelectedImage:profileIcon];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
     NSLog(@"Going to somewhere");
}


@end
