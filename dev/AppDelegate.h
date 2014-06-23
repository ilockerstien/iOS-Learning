//
//  AppDelegate.h
//  dev
//
//  Created by Ian Lockerbie on 2014-06-11.
//  Copyright (c) 2014 LockLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#define MyModelURLFile          @"CDModel"
#define MySQLDataFileName       @"CDModel.sqlite"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
