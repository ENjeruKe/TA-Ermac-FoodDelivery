//
//  TableBarsViewController.m
//  Food Drlivery
//
//  Created by Admin on 11/6/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "CoreDataHelper.h"
#import "OrderMeal.h"

@interface MainTabBarViewController ()

@property(nonatomic, strong) CoreDataHelper* cdHelper;

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
   // [item1 setEnabled:NO];
    UIImage *mealIcon = [[UIImage imageNamed:@"meal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orderIcon = [[UIImage imageNamed:@"order.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *profileIcon = [[UIImage imageNamed:@"profile.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item0 setImage:mealIcon];
    [item0 setSelectedImage:mealIcon];
    [item1 setImage:orderIcon];
    [item1 setSelectedImage:orderIcon];
    [item2 setImage:profileIcon];
    [item2 setSelectedImage:profileIcon];
    _cdHelper = [[CoreDataHelper alloc] init];
    [_cdHelper setupCoreData];
    [self checkForUnfinishedOrder];
}

- (void) checkForUnfinishedOrder{
    NSLog(@"Check for unfinished order");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"OrderMeal"];
    NSArray *fetchedObjects = [_cdHelper.context executeFetchRequest:request error:nil];
    unsigned long orderMealsCount = 0;
    
    if(fetchedObjects.count > 0){
         NSLog(@"Unfinished order exists!");
        for (OrderMeal *orderMeal in fetchedObjects) {
            orderMealsCount = orderMealsCount + [orderMeal.quantity longValue];
        }
        [[[self.tabBar items] objectAtIndex:0] setBadgeValue:[NSString stringWithFormat:@"%lu", orderMealsCount]];
        [[[self.tabBar items] objectAtIndex:1] setBadgeValue:@"!"];
    } else {
        NSLog(@"No unfinished order");
        [[[self.tabBar items] objectAtIndex:1]setEnabled:FALSE];
    }
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
