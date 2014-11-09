//
//  OrderDetailsViewController.m
//  Food Drlivery
//
//  Created by Admin on 11/7/14.
//  Copyright (c) 2014 Borislav Boyadzhiev. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "Meal.h"
#import "Order.h"
#import "OrderDetailsTableViewCell.h"
#import "CoreDataHelper.h"
#import "OrderMeal.h"

@interface OrderDetailsViewController (){
    NSArray *titles;
    NSArray *images;
    NSMutableArray *orderMeals;
    NSMutableDictionary *mutableDict ;
    Meal *tempMeal;
    BOOL forHome;
    float total;
    
}
@property(nonatomic, strong) CoreDataHelper* cdHelper;
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
    [self.mealsInOrderTableView setDelegate:self];
    [self.mealsInOrderTableView setDataSource:self];
    [self.orderTypeSwitch addTarget:self action:@selector(setOrderType:) forControlEvents:UIControlEventValueChanged];
    
    //[self addFakeData];
    _cdHelper = [[CoreDataHelper alloc] init];
    [_cdHelper setupCoreData];
    
}
-(void) viewDidAppear:(BOOL)animated{
    mutableDict = [[NSMutableDictionary alloc] init];
    orderMeals = [[NSMutableArray alloc] init];
    tempMeal = [[Meal alloc] init];
    [self readMealsInOrder];
}

- (void)setOrderType:(id)sender
{
    BOOL state = [sender isOn];
    NSString *orderTypeText = state == YES ? @"Поръчка до адрес" : @"Поръчка до кухня";
    self.orderTypeLabel.text = orderTypeText;
}

-(void) cleanMealsOrder{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"OrderMeal"];
    NSArray *fetchedObjects = [_cdHelper.context executeFetchRequest:request error:nil];
    
    if(fetchedObjects.count > 0){
        for (OrderMeal *meal in fetchedObjects) {
            [_cdHelper.context deleteObject:meal];
            //[self viewDidAppear:YES];
        }
    } else {
        NSLog(@"No meals in order!");
    }
    mutableDict = [[NSMutableDictionary alloc] init];
    orderMeals = [[NSMutableArray alloc] init];
    tempMeal = [[Meal alloc] init];
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:FALSE];
    [self.tabBarController setSelectedIndex:0];
    
}


-(void) readMealsInOrder{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"OrderMeal"];
    NSArray *fetchedObjects = [_cdHelper.context executeFetchRequest:request error:nil];
    
    if(fetchedObjects.count > 0){
        NSLog(@"Found %lu meals in order", fetchedObjects.count);
        for (OrderMeal *meal in fetchedObjects) {
            NSLog(@"Fetching meal with id: %@", meal.mealId);
            [mutableDict setObject:[NSNumber numberWithShort:[meal.quantity shortValue]] forKey:meal.mealId];
            [self retrieveMealFromParse:meal];
        }
        
        
        //[refreshControl endRefreshing];
    } else {
        NSLog(@"No meals in order!");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Нямате добавени ястия!"
                                                        message: @" "
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert setTag:3];
        [alert show];
    }
    
}

-(void) retrieveMealFromParse: (OrderMeal*) requestedMeal{
    PFQuery *query = [PFQuery queryWithClassName: [Meal parseClassName]];
    [query whereKey:@"objectId" equalTo:requestedMeal.mealId];
    [query orderByAscending:@"title"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            Meal *m =(Meal *)[objects objectAtIndex:0];
            [orderMeals addObject:m];
            
            NSLog(@"MEAL: %@, x %@",  m.title, requestedMeal.quantity);
            [self.mealsInOrderTableView reloadData];
            NSLog(@"Total meals fetched: %lu", orderMeals.count);
            total = 0;
            
            for (Meal *meal in orderMeals) {
                int quantity = [[mutableDict objectForKey:meal.objectId] shortValue];
                total = total + [meal.price floatValue] * quantity;
            }
            self.totalPriceLabel.text = [NSString stringWithFormat:@"Обща сума: %.2f лв",total];
        }else{
            NSLog(@"Error getting meals!");
        }
    }];
}

//- (void)addFakeData
//{
//    titles = [NSArray arrayWithObjects:@"Яйце Benedict", @"Ризото с гъби", @"Цяла закуска", @"Хамбургер", @"Сандвич с шунка и яйце", @"Крем 'Брюле'", @"Донът с бял шоколад", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
//
//    images = [NSArray arrayWithObjects:@"egg_benedict.jpg", @"mushroom_risotto.jpg", @"full_breakfast.jpg", @"hamburger.jpg", @"ham_and_egg_sandwich.jpg", @"creme_brelee.jpg", @"white_chocolate_donut.jpg", @"starbucks_coffee.jpg", @"vegetable_curry.jpg", @"instant_noodle_with_egg.jpg", @"noodle_with_bbq_pork.jpg", @"japanese_noodle_with_pork.jpg", @"green_tea.jpg", @"thai_shrimp_cake.jpg", @"angry_birds_cake.jpg", @"ham_and_cheese_panini.jpg", nil];
//
//    for (int i=0; i< titles.count; i++) {
//        Meal *meal = [[Meal alloc] init];
//        meal.title = [titles objectAtIndex:i];
//        meal.mealDescription = @"Sample description";
//        NSData* data = UIImageJPEGRepresentation([UIImage imageNamed:[images objectAtIndex:i]], 0.5f);
//        PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"Image%d.jpg", i] data:data];
//
//        // NOT CORRECT - SAMPLE DATA
//        meal.objectId = [NSString stringWithFormat:@"Image%d.jpg", i];
//        // NOT CORRECT - SAMPLE DATA
//        meal.image = imageFile;
//       // int numChars = [[preProcessResult objectForKey:@"NumberChars"] intValue];
//     //   int quantity = [[mutableDict objectForKey:meal.objectId] integerValue];
//        meal.price = [NSNumber numberWithDouble:(i*3.14)];
//        [orderMeals addObject:meal];
//    }
//}

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
    int quantity = [[mutableDict objectForKey:tempMeal.objectId] shortValue];
    
    cell.mealPriceLabel.text =[NSString stringWithFormat:@"%d x %.2f лв.", quantity, tempMeal.price.floatValue ];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // ORDER BUTTON CLICKED
    if(alertView.tag == 1){
        if (buttonIndex == [alertView cancelButtonIndex]) {
            
        } else {
            if (self.orderTypeSwitch.isOn) {
                Order *order = [Order object];
                order.user = [PFUser currentUser];
                order.forHome = [NSNumber numberWithBool:YES];
                order.total = [NSNumber numberWithFloat:total];
                order.complete = @NO;
                NSLog(@"Saving order for home for userId %@", order.user.objectId);
                [order saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        
                        NSLog(@"ORDER ROW ID %@",[order objectId]);
                        [self storeOrderMealsForOrderId:order];
                    } else {
                        NSLog(@"ORDER STORING FAILED");
                        NSLog(@"%@",[[error userInfo] objectForKey:@"error"]);
                    }
                }];
            }else {
                // TODO Goto kitchen selection
            }
            
        }
        
    }
    
    //CANCEL ORDER CLICKED
    if(alertView.tag == 2) {
        if (buttonIndex == [alertView cancelButtonIndex]) {
            
        } else {
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"OrderMeal"];
            NSArray *fetchedObjects = [_cdHelper.context executeFetchRequest:request error:nil];
            for (OrderMeal *meal in fetchedObjects) {
                NSLog(@"Deleting OrderMeal '%@'", meal.mealId);
                [_cdHelper.context deleteObject:meal];
            }
            [_cdHelper saveContext];
            [self cleanMealsOrder];
        }

    }
    
    // NO MEALS IN ORDER
    if(alertView.tag == 3){
        if (buttonIndex == 0) {
            // GOTO MEALS TAB
            [self.tabBarController setSelectedIndex:0];
        }
    }
}



-(void) storeOrderMealsForOrderId: (Order*) order{
    NSLog(@"Storing OrdersMeals"); // BAD :)
    for (Meal *meal in orderMeals) {
        PFObject *parseOrderMeal = [PFObject objectWithClassName:@"OrdersMeals"];
        parseOrderMeal[@"order"] = order;
        parseOrderMeal[@"meal"] = meal;
        parseOrderMeal[@"complete"] = @NO;
        int quantity =[[mutableDict objectForKey:meal.objectId] shortValue];
        parseOrderMeal[@"quantity"] = [NSNumber numberWithInt:quantity];
        
        [parseOrderMeal saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"OrdersMeals ROW ID %@",[parseOrderMeal objectId]);
                
            } else {
                NSLog(@"OrdersMeals STORING FAILED");
                NSLog(@"%@",[[error userInfo] objectForKey:@"error"]);
            }
        }];
    }
    [self cleanMealsOrder];
}


- (IBAction)performOrderButtonAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Потвътждаване поръчката"
                                                    message: @"Моля потвърдете"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    [alert setTag:1];
    [alert show];
}

- (IBAction)cancelOrderButtonAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Отмяна на поръчката"
                                                    message: @"Сигурни ли сте, че отменяте поръчката?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    [alert setTag:2];
    [alert show];
    
}

@end
