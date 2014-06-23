//
//  ListViewTableTableViewController.m
//  dev
//
//  Created by Ian Lockerbie on 2014-06-16.
//  Copyright (c) 2014 LockLabs. All rights reserved.
//

#import "ListViewTableViewController.h"
#import "ListViewNavigationController.h"
#import "AddItemToListViewController.h"
#import "AppDelegate.h"
#import "ItemTableCell.h"
#import "ListItem.h"


@interface ListViewTableViewController ()

@end

@implementation ListViewTableViewController{
    
    CLLocationManager *manager;
    CLLocation *currentLocation;
    
    NSManagedObjectContext *managedContextObject;
    NSFetchRequest *fetchRequest;
    NSFetchedResultsController *fetchedResultsController;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    currentLocation = nil;
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    managedContextObject = appDelegate.managedObjectContext;
    
    
    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ListItem"];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"date"
                                        ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    fetchedResultsController = [[NSFetchedResultsController alloc]
                                initWithFetchRequest:fetchRequest
                                managedObjectContext:managedContextObject
                                sectionNameKeyPath:nil
                                cacheName:nil];
    fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    [fetchedResultsController performFetch:&error];
    
    if (error != nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    
    

    
}


-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"ListViewTableViewController Will appear");
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager startUpdatingLocation];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [manager stopUpdatingLocation];
    NSLog(@"ListViewTableViewcontroller will disappear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addButtonPress:(id)sender {
    NSLog(@"Add button pressed");
}

#pragma mark Unwind Segues from AddItemToListViewController

-(IBAction)cancelEditor:(UIStoryboardSegue *)segue{
    NSLog(@"Cancel editor");
}

-(IBAction)doneEditor:(UIStoryboardSegue*)segue{
    NSLog(@"Done editor");
    NSError *errr;
    [managedContextObject save:&errr];
    AddItemToListViewController *addItemController = segue.sourceViewController;

    ListItem *newItem = [NSEntityDescription
                         insertNewObjectForEntityForName:@"ListItem"
                         inManagedObjectContext:managedContextObject];
    
    newItem.date = [NSDate date];
    newItem.image = UIImagePNGRepresentation(addItemController.imageView.image);
    newItem.desc = addItemController.descript.text;
    NSNumber *cost;
    cost = [NSNumber numberWithInteger:[addItemController.cost.text integerValue]];
    newItem.cost = cost;

    

    
    if (errr != nil) {
        NSLog(@"Unresolved error %@, %@", errr, [errr userInfo]);
        abort();
    }
    [managedContextObject save:&errr];
    [fetchedResultsController performFetch:&errr];
}



#pragma mark CLLocationManager Delegate Methods
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error:%@",error);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    currentLocation = [locations lastObject];
    if (currentLocation != nil){
        NSLog(@"%@",[NSString stringWithFormat:@"%.8f",currentLocation.coordinate.latitude]);
        NSLog(@"%@",[NSString stringWithFormat:@"%.8f",currentLocation.coordinate.longitude]);}
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[fetchedResultsController sections] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FoodNDrinkCell";
    ItemTableCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier
                              forIndexPath:indexPath];
    NSLog(@"Row: %ld, Section: %ld", (long)indexPath.row, (long)indexPath.section);
    if (indexPath.row != 0){
        cell.item = [fetchedResultsController objectAtIndexPath:indexPath];
        [cell configureCell];
    }
    else {
        [cell configureEmptyCell];
    }
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
            //        case NSFetchedResultsChangeUpdate:
            //            code to update the content of the cell at indexPath
            //            break;
            
            //        case NSFetchedResultsChangeMove:
            //            [tableView deleteRowsAtIndexPaths:@[indexPath]
            //                             withRowAnimation:UITableViewRowAnimationFade];
            //            [tableView insertRowsAtIndexPaths:@[newIndexPath]
            //                             withRowAnimation:UITableViewRowAnimationFade];
            //            break;
            
    }
}
@end
