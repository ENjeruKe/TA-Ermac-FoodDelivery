//
//  MealsViewController.m
//  Food Drlivery
//
//  Created by Borislav Boyadzhiev on 11/7/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import "MealsViewController.h"
#import "MealTableViewCellController.h"
#import "Meal.h"
#import "MealDetailsViewController.h"

@interface MealsViewController ()
{
    NSArray *titles;
    NSArray *images;
    NSMutableArray *mealsData;
    Meal *tempMeal;
}
@end

@implementation MealsViewController

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
    UINib *nib = [UINib nibWithNibName:@"MealTableViewCell"  bundle:nil];
    [self.mealsTableView registerNib:nib forCellReuseIdentifier:@"MealTableViewCellController"];
    // Do any additional setup after loading the view.
    mealsData = [[NSMutableArray alloc] init];
    tempMeal = [[Meal alloc] init];
    
    [self addFakeData];
    
    [self.mealsTableView setDelegate:self];
    [self.mealsTableView setDataSource:self];
}

- (void)addFakeData
{
    titles = [NSArray arrayWithObjects:@"Яйце Benedict", @"Ризото с гъби", @"Цяла закуска", @"Хамбургер", @"Сандвич с шунка и яйце", @"Крем 'Брюле'", @"Донът с бял шоколад", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    
    images = [NSArray arrayWithObjects:@"egg_benedict.jpg", @"mushroom_risotto.jpg", @"full_breakfast.jpg", @"hamburger.jpg", @"ham_and_egg_sandwich.jpg", @"creme_brelee.jpg", @"white_chocolate_donut.jpg", @"starbucks_coffee.jpg", @"vegetable_curry.jpg", @"instant_noodle_with_egg.jpg", @"noodle_with_bbq_pork.jpg", @"japanese_noodle_with_pork.jpg", @"green_tea.jpg", @"thai_shrimp_cake.jpg", @"angry_birds_cake.jpg", @"ham_and_cheese_panini.jpg", nil];
    
    for (int i=0; i< titles.count; i++) {
        Meal *meal = [[Meal alloc] init];
        meal.title = [titles objectAtIndex:i];
        meal.mealDescription = @"Sample description";
        NSData* data = UIImageJPEGRepresentation([UIImage imageNamed:[images objectAtIndex:i]], 0.5f);
        PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"Image%d.jpg", i] data:data];
        
        // NOT CORRECT - SAMPLE DATA
        meal.mealId = [NSString stringWithFormat:@"Image%d.jpg", i];
        // NOT CORRECT - SAMPLE DATA
        meal.image = imageFile;
        meal.price = [NSNumber numberWithDouble:(i*3.14)];
        [mealsData addObject:meal];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MealTableViewCellController";
    
   MealTableViewCellController *cell = (MealTableViewCellController *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    if (cell == nil)
//    {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MealTableViewCell" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//            NSLog(@"CELL");
//    }
    tempMeal = (Meal *)[mealsData objectAtIndex:indexPath.row];
    [tempMeal.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            // image can now be set on a UIImageView
            cell.mealImage.image = image;
        }
    }];
    cell.mealTitle.text = tempMeal.title;
    cell.mealTypes.text =  @"Десерт, Ястие ...";
    // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selected = [mealsData objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"mealDetailsSegue" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"mealDetailsSegue"])
    {
        // Get reference to the destination view controller
        MealDetailsViewController *mealDetailsVc = [segue destinationViewController];
        // Pass any objects to the view controller here, like...
        NSLog(@"Going to meal %@ details", self.selected.title);
        mealDetailsVc.selectedMeal = self.selected;
    }
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

@end
