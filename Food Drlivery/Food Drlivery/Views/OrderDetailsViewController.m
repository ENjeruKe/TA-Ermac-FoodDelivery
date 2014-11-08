//
//  OrderDetailsViewController.m
//  Food Drlivery
//
//  Created by Admin on 11/7/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "Meal.h"
#import "OrderDetailsTableViewCell.h"

@interface OrderDetailsViewController (){
    NSArray *titles;
    NSArray *images;
    NSMutableArray *orderMeals;
    Meal *tempMeal;
}
@end

@implementation OrderDetailsViewController

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
    orderMeals = [[NSMutableArray alloc] init];
    tempMeal = [[Meal alloc] init];
    [self.mealsInOrderTableView setDelegate:self];
    [self.mealsInOrderTableView setDataSource:self];
    [self.orderTypeSwitch addTarget:self action:@selector(setOrderType:) forControlEvents:UIControlEventValueChanged];
    [self addFakeData];
    NSNumber *total = 0;
    for (Meal *meal in orderMeals) {
        total = @( [total floatValue] + [meal.price floatValue]);
    }
    self.totalPriceLabel.text = [NSString stringWithFormat:@"Обща сума: %@ лв",[total stringValue]];
}

- (void)setOrderType:(id)sender
{
    BOOL state = [sender isOn];
    NSString *orderTypeText = state == YES ? @"Поръчка до адрес" : @"Поръчка до кухня";
    self.orderTypeLabel.text = orderTypeText;
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
        [orderMeals addObject:meal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [orderMeals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"mealCell";
    
    OrderDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[OrderDetailsTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                             reuseIdentifier:cellIdentifier];
        NSLog(@"CELL");
    }

    
    tempMeal = (Meal *)[orderMeals objectAtIndex:indexPath.row];
    [tempMeal.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            // image can now be set on a UIImageView
            cell.mealImage.image = image;
         //   cell.mealImage.image = image;
        }
    }];
   
    cell.mealTitleLabel.text = tempMeal.title;
    cell.mealPriceLabel.text = [tempMeal.price stringValue];
    // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
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

- (IBAction)cancelOrderButtonAction:(id)sender {
}

- (IBAction)performOrderButtonAction:(id)sender {
}
@end
