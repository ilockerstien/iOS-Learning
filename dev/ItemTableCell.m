//
//  ItemTableCell.m
//  dev
//
//  Created by Ian Lockerbie on 2014-06-22.
//  Copyright (c) 2014 LockLabs. All rights reserved.
//

#import "ItemTableCell.h"
#import "ListItem.h"

@implementation ItemTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell{
    self.detailTextLabel.text = self.item.desc;
}


- (void)configureEmptyCell{
    self.detailTextLabel.text = @"No Entries";
}

@end
