//
//  AddItemToListViewController.h
//  dev
//
//  Created by Ian Lockerbie on 2014-06-17.
//  Copyright (c) 2014 LockLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModelElement.h"

@interface AddItemToListViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

-(IBAction)unwindFromAddListToListView:(UIStoryboardSegue*)segue;
@property (strong, nonatomic) DataModelElement *addItem;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;


@end
