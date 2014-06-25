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
    BOOL locationIsFresh;
    float lastLatitude;
    float lastLongitude;
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
    NSError *error = nil;
    
    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ListItem"];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"date"
                                        ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
   // [fetchRequest setFetchLimit:20];
    fetchedResultsController = [[NSFetchedResultsController alloc]
                                initWithFetchRequest:fetchRequest
                                managedObjectContext:managedContextObject
                                sectionNameKeyPath:nil
                                cacheName:nil];
    fetchedResultsController.delegate = self;
    [fetchedResultsController performFetch:&error];
    NSLog(@"fetchedResultsController #Objects:%ld", [[fetchedResultsController fetchedObjects] count]);
    
    if (error != nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    self.navigationItem.leftBarButtonItem = self.editButton;
    

    
}


-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"ListViewTableViewController Will appear");
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager startUpdatingLocation];
    [manager stopUpdatingLocation];
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

#pragma mark Unwind Segues from AddItemToListViewController

-(IBAction)cancelEditor:(UIStoryboardSegue *)segue{
    NSLog(@"Cancel editor");
    [manager stopUpdatingLocation];
}


- (IBAction)editTableView:(id)sender {
    BOOL startEdit = (sender == self.editButton);
    
    UIBarButtonItem *nextButton = (startEdit) ?
    self.doneButton : self.editButton;
    
    [self.navigationItem setLeftBarButtonItem:nextButton animated:YES];
    [self.tableView setEditing:startEdit animated:YES];
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
    if (addItemController.imageView.image != nil){
        newItem.image = UIImagePNGRepresentation(addItemController.imageView.image);
    }
    newItem.desc = addItemController.descript;
    NSNumber *cost;
    cost = [NSNumber numberWithInteger:[addItemController.cost integerValue]];
    newItem.cost = cost;
    NSLog(locationIsFresh?@"Fresh location":@"Location is NOT fresh");

    newItem.latitude = [NSNumber numberWithFloat:lastLatitude];
    newItem.longitude = [NSNumber numberWithFloat:lastLongitude];
    [manager stopUpdatingLocation];

    

    
    if (errr != nil) {
        NSLog(@"Unresolved error %@, %@", errr, [errr userInfo]);
        abort();
    }
    [managedContextObject save:&errr];
}



#pragma mark CLLocationManager Delegate Methods
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error:%@",error);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    currentLocation = [locations lastObject];
    if (currentLocation != nil){
        locationIsFresh = YES;
        NSLog(@"%@",[NSString stringWithFormat:@"%.8f",currentLocation.coordinate.latitude]);
        NSLog(@"%@",[NSString stringWithFormat:@"%.8f",currentLocation.coordinate.longitude]);}
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[fetchedResultsController sections] count];
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo;
    sectionInfo = [fetchedResultsController sections][section];
    
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FoodNDrinkCell";
    ItemTableCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier
                              forIndexPath:indexPath];
    NSLog(@"tableView cellforrowatindexpath Row:%ld Section:%ld", indexPath.row, indexPath.section);
    cell.item = [fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"tableView cellforrowatindexpath Date:%@", cell.item.date);
    [cell configureCell];
    
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [managedContextObject deleteObject:[fetchedResultsController
                                            objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        
        [managedContextObject save:&error];
        
        if (error != nil) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    locationIsFresh = NO;


    if ([segue.identifier isEqualToString:@"AddButtonSegue"]){
        [manager startUpdatingLocation];
    }
    if ([segue.identifier isEqualToString:@"ReviewItemSegue"]){
        AddItemToListViewController *destinationController = [segue destinationViewController];
        ItemTableCell *itemCell = (ItemTableCell *)sender;
        NSLog(@"%@",itemCell.item.desc);
        NSLog(@"%@",[NSString stringWithFormat:@"%@",itemCell.item.cost]);
        destinationController.cost = [NSString stringWithFormat:@"%@",itemCell.item.cost];
        destinationController.descript = itemCell.item.desc;
    }
    //AddItemToListViewController *destinationController= [segue destinationViewController];

}

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
            NSLog(@"newIndexPath: Row%ld, Section %ld", newIndexPath.row, newIndexPath.section);
            NSLog(@"Number of table rows:%ld", [tableView numberOfRowsInSection:0]);
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
            case NSFetchedResultsChangeUpdate:
                NSLog(@"ChangeUpdate");
                break;
            
            case NSFetchedResultsChangeMove:
                [tableView deleteRowsAtIndexPaths:@[indexPath]
                                    withRowAnimation:UITableViewRowAnimationFade];
                [tableView insertRowsAtIndexPaths:@[newIndexPath]
                                    withRowAnimation:UITableViewRowAnimationFade];
            break;
            
    }
}
@end
