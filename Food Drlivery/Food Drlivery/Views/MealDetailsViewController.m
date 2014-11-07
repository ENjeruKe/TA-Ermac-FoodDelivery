//
//  MealDetailsViewController.m
//  Food Drlivery
//
//  Created by Admin on 11/7/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import "MealDetailsViewController.h"

@interface MealDetailsViewController ()

@property (nonatomic, strong) NSUserDefaults *defaults;
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

    self.mealPriceLabel.text = [NSString stringWithFormat:@"%@ лв.", self.selectedMeal.price];
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
    BOOL found = NO;
    
    if([self.defaults objectForKey:@"order"] != nil) {
         self.temp = [[NSMutableArray alloc] initWithArray:[self.defaults objectForKey:@"order"]];
        
        for (NSString *mealid in self.temp) {
            NSLog(@"\nINORDER: %@", mealid);
            if (mealid == self.selectedMeal.mealId) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ястието е добавяно"
                                                                message: @"Да го добавя ли пак?"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"OK", nil];
                [alert show];
                found = YES;
                break;
            }
        }
        
        if (!found) {
            self.temp = [[NSMutableArray alloc] init];
            [self updateOrder];
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self updateOrder];
        
        
    }
}

- (void)updateOrder {
    // Add meal to order
    
    [self.temp addObject:self.selectedMeal.mealId];
    NSArray *order = [NSArray arrayWithArray:self.temp];
    [self.defaults setObject:order forKey:@"order"];
    
    [self.defaults synchronize];
    
    NSLog(@"Order saved");
    [self.navigationController popViewControllerAnimated:YES];
}


@end
