//
//  ListViewTableTableViewController.h
//  dev
//
//  Created by Ian Lockerbie on 2014-06-16.
//  Copyright (c) 2014 LockLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>

@interface ListViewTableViewController : UITableViewController <CLLocationManagerDelegate, NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end
