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


@interface ListViewTableViewController ()

@end

@implementation ListViewTableViewController{
    
    CLLocationManager *manager;
    CLLocation *currentLocation;
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
    self.dataModel = ((ListViewNavigationController *)self.navigationController).dataModel;
    manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    currentLocation = nil;
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
/*
    DataModelElement *newModel;
    newModel = [[DataModelElement alloc] init];
    newModel.timeEntered = [NSDate date];
 */
}

#pragma mark Unwind Segues from AddItemToListViewController

-(IBAction)cancelEditor:(UIStoryboardSegue *)segue{
    NSLog(@"Cancel editor");
}

-(IBAction)doneEditor:(UIStoryboardSegue*)segue{
    NSLog(@"Done editor");
    AddItemToListViewController *addItemController = segue.sourceViewController;
    DataModelElement *addItem = addItemController.addItem;
    if (currentLocation != nil){
        addItem.location = currentLocation;
        addItem.timeEntered = [NSDate date];
        if (addItem.image != nil){
            NSLog(@"NotNil");
        } else {
            NSLog(@"Nil");
        }
        addItem.description = [NSString stringWithFormat:@"Item#%lu", [self.dataModel count]+1];
        [self.dataModel addObject:addItem];
        [self.tableView reloadData];
    }
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataModel count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodNDrinkCell" forIndexPath:indexPath];
    
    // Configure the cell...

    if ([self.dataModel count] > 0){
        cell.textLabel.text = ((DataModelElement *)[self.dataModel objectAtIndex:indexPath.row]).description;
        cell.imageView.image = ((DataModelElement *)[self.dataModel objectAtIndex:indexPath.row]).image;
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

@end
