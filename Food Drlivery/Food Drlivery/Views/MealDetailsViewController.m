//
//  MealDetailsViewController.m
//  Food Drlivery
//
//  Created by Admin on 11/7/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import "MealDetailsViewController.h"
#import "CoreDataHelper.h"
#import "OrderMeal.h"

@interface MealDetailsViewController ()

@property (nonatomic, strong) NSUserDefaults *defaults;
@property(nonatomic, strong) CoreDataHelper* cdHelper;

@property (nonatomic, strong) NSMutableArray *temp;

@end

@implementation MealDetailsViewController

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
     self.defaults = [NSUserDefaults standardUserDefaults];
    self.mealTitleLabel.text = self.selectedMeal.title;
    self.mealTitleLabel.numberOfLines = 0;
    [self.mealTitleLabel sizeToFit];
    
    [self.selectedMeal.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            // image can now be set on a UIImageView
            self.mealImageView.image = image;
        }
    }];
    self.mealTypesLabel.text = [[self.selectedMeal.mealType valueForKey:@"description"] componentsJoinedByString:@", "];
    self.mealPriceLabel.text = [NSString stringWithFormat:@"Цена: %@ лв.", self.selectedMeal.price];
    self.mealDescriptionLabel.text = self.selectedMeal.mealDescription;
    
    NSLog(@"Selected meal: %@", self.selectedMeal.title);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addToOrderButton:(id)sender {
    // Add meal to order
    [self addMealToOrder];
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:YES];
//    BOOL found = NO;
//    NSLog(@"CHECKING NSUserDefaults");
//    if([self.defaults objectForKey:@"order"] != nil) {
//         self.temp = [[NSMutableArray alloc] initWithArray:[self.defaults objectForKey:@"order"]];
//        
//        for (NSString *mealid in self.temp) {
//            NSLog(@"\nINORDER: %@", mealid);
//            if (mealid == self.selectedMeal.objectId) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ястието е добавяно"
//                                                                message: @"Да го добавя ли пак?"
//                                                               delegate:self
//                                                      cancelButtonTitle:@"Cancel"
//                                                      otherButtonTitles:@"OK", nil];
//                [alert show];
//                found = YES;
//                break;
//            }
//        }
//        
//        if (!found) {
//            NSLog(@"NOT FOUND IN NSUserDefaults");
//            self.temp = [[NSMutableArray alloc] init];
//            [self updateOrder];
//        }
//    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self updateOrderNSUserDefaults];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (void)addMealToOrder {
    // Add meal to order
    // CoreData
    _cdHelper = [[CoreDataHelper alloc] init];
    [_cdHelper setupCoreData];
    
    // Check if meal is already in the current order
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"OrderMeal"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mealId == %@", self.selectedMeal.objectId];
    [request setPredicate:predicate];
    NSArray *fetchedObjects = [_cdHelper.context executeFetchRequest:request error:nil];
    OrderMeal* meal;
    
    if(fetchedObjects.count > 0){
        //Meal Already added, so updating count
        
       meal = [fetchedObjects objectAtIndex:0];
        NSLog(@"FOUND MEAL IN ORDER, %@", self.selectedMeal.title);
        NSNumber *currentQuantity = meal.quantity;
        meal.quantity = @([currentQuantity integerValue] + 1);

    } else {
        NSLog(@"ADDING NEW MEAL TO ORDER");
        meal = [NSEntityDescription insertNewObjectForEntityForName:@"OrderMeal" inManagedObjectContext:_cdHelper.context];
        meal.mealId = self.selectedMeal.objectId;
        meal.quantity = @1;
        [_cdHelper.context insertObject:meal];
    }
    
    [self.cdHelper saveContext];
    NSLog(@"OrderMeal saved to CoreData");
}

- (void)updateOrderNSUserDefaults {
    // NSUserDefaults
    [self.temp addObject:self.selectedMeal.objectId];
    NSArray *order = [NSArray arrayWithArray:self.temp];
    [self.defaults setObject:order forKey:@"order"];
    
    [self.defaults synchronize];
    
    NSLog(@"Order saved to NSUserDefaults");
    
}


@end
