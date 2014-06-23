//
//  ItemTableCell.h
//  dev
//
//  Created by Ian Lockerbie on 2014-06-22.
//  Copyright (c) 2014 LockLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ListItem;

@interface ItemTableCell : UITableViewCell

@property (strong, nonatomic) ListItem *item;


- (void) configureCell;
- (void) configureEmptyCell;
@end
