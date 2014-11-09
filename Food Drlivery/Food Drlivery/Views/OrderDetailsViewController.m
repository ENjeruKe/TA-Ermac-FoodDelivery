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
    unsigned long allMealsCount;
    
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
    self.mealsInOrderTableView.allowsMultipleSelectionDuringEditing = NO;
    
    _cdHelper = [CoreDataHelper coreDataStorageInastance];
    
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

-(void) removeMealFromOrder: (Meal *) meal{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"OrderMeal"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mealId == %@", meal.objectId];
    
    [request setPredicate:predicate];
    NSArray *fetchedObjects = [_cdHelper.context executeFetchRequest:request error:nil];
    
    OrderMeal* orderMeal;
    
    if(fetchedObjects.count > 0){
        //Meal Already added, so updating count
        orderMeal = [fetchedObjects objectAtIndex:0];
        [_cdHelper.context deleteObject:orderMeal];
        [mutableDict removeObjectForKey:orderMeal.mealId];
        [self refreshTotalLabel];
        [self updateTabBadges];
    }
    [_cdHelper saveContext];
}

- (void)lockOrderTabAndExit {
    allMealsCount = 0;
    [self updateTabBadges];
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:FALSE];
    [self.tabBarController setSelectedIndex:0];
}

-(void) cleanMealsOrder{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"OrderMeal"];
    NSArray *fetchedObjects = [_cdHelper.context executeFetchRequest:request error:nil];
    
    if(fetchedObjects.count > 0){
        for (OrderMeal *meal in fetchedObjects) {
            [_cdHelper.context deleteObject:meal];
            //[self viewDidAppear:YES];
        }
        [_cdHelper saveContext];
    } else {
        NSLog(@"No meals in order!");
    }
    mutableDict = [[NSMutableDictionary alloc] init];
    orderMeals = [[NSMutableArray alloc] init];
    tempMeal = [[Meal alloc] init];
    
    [self lockOrderTabAndExit];
    
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

- (void)refreshTotalLabel {
    total = 0;
    allMealsCount = 0;
    for (Meal *meal in orderMeals) {
        int quantity = [[mutableDict objectForKey:meal.objectId] shortValue];
        total = total + [meal.price floatValue] * quantity;
        allMealsCount = allMealsCount + quantity;
    }
    self.totalPriceLabel.text = [NSString stringWithFormat:@"Обща сума: %.2f лв",total];
     [self updateTabBadges];
}

- (void) updateTabBadges{
    if(allMealsCount > 0){
        [[[[self.tabBarController tabBar] items] objectAtIndex:0] setBadgeValue:[NSString stringWithFormat:@"%lu", allMealsCount]];
        [[[[self.tabBarController tabBar] items] objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%.2f", total]];
    } else {
        [[[[self.tabBarController tabBar] items] objectAtIndex:0] setBadgeValue:nil];
        [[[[self.tabBarController tabBar] items] objectAtIndex:1] setBadgeValue:nil];
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
            [self refreshTotalLabel];
            
        }else{
            NSLog(@"Error getting meals!");
        }
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Откажи";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [self removeMealFromOrder:[orderMeals objectAtIndex:indexPath.row]];
         [orderMeals removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (orderMeals.count == 0) {
            [self lockOrderTabAndExit];
        }
    }
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
            [self lockOrderTabAndExit];
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
