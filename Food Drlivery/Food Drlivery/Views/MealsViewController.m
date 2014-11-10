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
#import "CoreDataHelper.h"
#import "OrderMeal.h"

@interface MealsViewController ()
{
    NSArray *titles;
    NSArray *images;
    NSMutableArray *mealsData;
    Meal *tempMeal;
    UIRefreshControl *refreshControl;
  //  PFImageView *mealImage;
    unsigned long orderMealsCount;
}
@property(nonatomic, strong) CoreDataHelper* cdHelper;

@end

@implementation MealsViewController

@synthesize mealsTableView;

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
     _cdHelper = [CoreDataHelper coreDataStorageInastance];
    mealsData = [[NSMutableArray alloc] init];
    tempMeal = [[Meal alloc] init];
    
    refreshControl = [[UIRefreshControl alloc] init];
//    refreshControl.backgroundColor = [UIColor whiteColor];
//    refreshControl.tintColor = [UIColor blackColor];
//    [refreshControl addTarget:self
//                       action:@selector(retrieveFromParse)
//             forControlEvents:UIControlEventValueChanged];
//    //[mealsTableView addSubview:refreshControl];
//    [mealsTableView insertSubview:refreshControl atIndex:0];
    
    [self retrieveFromParse];
    
    UINib *nib = [UINib nibWithNibName:@"MealTableViewCell"  bundle:nil];
    [self.mealsTableView registerNib:nib forCellReuseIdentifier:@"MealTableViewCellController"];
    // Do any additional setup after loading the view.

    
    [self.mealsTableView setDelegate:self];
    [self.mealsTableView setDataSource:self];
    
    [self addLongPressRecognizer];
}

-(void) retrieveFromParse{
    PFQuery *query = [PFQuery queryWithClassName: [Meal parseClassName]];
    
    [query orderByAscending:@"title"];
    
    //__weak id weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
             mealsData = [[NSMutableArray alloc] initWithArray:objects];
            //[self addFakeData];
           // Meal *meal = [[Meal alloc] init];
            //[mealsData addObject:meal];
            [self.mealsTableView reloadData];
            [refreshControl endRefreshing];
            
            NSLog(@"MEALS loeded:%lu", mealsData.count);
            for (Meal *m in mealsData) {
                NSLog(@"%@", m.title);
            }
            
        }else{
            NSLog(@"Error getting meals!");
        }
    }];
    
   
}

- (void)addMealToOrder: (Meal *) selectedMeal{
    // Add meal to order
    // CoreData
    NSLog(@"%@", selectedMeal.title);
    // Check if meal is already in the current order
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"OrderMeal"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mealId == %@", selectedMeal.objectId];
    [request setPredicate:predicate];
    NSArray *fetchedObjects = [_cdHelper.context executeFetchRequest:request error:nil];
    
    OrderMeal* orderMeal;
    if(fetchedObjects.count > 0){
        //Meal Already added, so updating count
     //   orderMealsCount = fetchedObjects.count + 1;
        orderMeal = [fetchedObjects objectAtIndex:0];
        NSNumber *currentQuantity = orderMeal.quantity;
        orderMeal.quantity = @([currentQuantity integerValue] + 1);
        
    } else {
        NSLog(@"ADDING NEW MEAL TO ORDER");
        orderMeal = [NSEntityDescription insertNewObjectForEntityForName:@"OrderMeal" inManagedObjectContext:_cdHelper.context];
        orderMeal.mealId = selectedMeal.objectId;
        orderMeal.quantity = @1;
        [_cdHelper.context insertObject:orderMeal];
    }
    
    [self.cdHelper saveContext];
    [self updateMealsTabBadge];
    NSLog(@"OrderMeal saved to CoreData");
}

- (void) updateMealsTabBadge{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"OrderMeal"];
    NSArray *fetchedObjects = [_cdHelper.context executeFetchRequest:request error:nil];
    orderMealsCount = 0;
    if(fetchedObjects.count > 0){
        for (OrderMeal *orderMeal in fetchedObjects) {
            orderMealsCount = orderMealsCount + [orderMeal.quantity longValue];
        }
        [[[[self.tabBarController tabBar] items] objectAtIndex:0] setBadgeValue:[NSString stringWithFormat:@"%lu", orderMealsCount]];
        [[[[self.tabBarController tabBar] items] objectAtIndex:1] setBadgeValue:@"*"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addLongPressRecognizer {
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.2; //seconds
   // lpgr.delegate = self;
    [self.view addGestureRecognizer:lpgr];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.mealsTableView];
    NSLog(@"LongPress");
    NSIndexPath *indexPath = [self.mealsTableView indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long press on table view at row %ld", indexPath.row);
        [self addMealToOrder:[mealsData objectAtIndex:indexPath.row]];
    } else {
        NSLog(@"gestureRecognizer.state = %ld", gestureRecognizer.state);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mealsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MealTableViewCellController";
    
   MealTableViewCellController *cell = (MealTableViewCellController *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    tempMeal = (Meal *)[mealsData objectAtIndex:indexPath.row];
    //tempMeal = [mealsData objectAtIndex:indexPath.row];
//    PFImageView *mealImage = [[PFImageView alloc] init];
//    mealImage.image = [UIImage imageNamed:@"emptyplate.jpg"]; // placeholder image
//    mealImage.file = (PFFile *)tempMeal.image;
//    [mealImage loadInBackground];
//    cell.mealImage = mealImage;
    
 
    
    [tempMeal.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            // image can now be set on a UIImageView
            cell.mealImage.image = image;
        }
    }];
    cell.mealTitle.text = tempMeal.title;
    cell.mealTypes.text = [[tempMeal.mealType valueForKey:@"description"] componentsJoinedByString:@", "];
   
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
