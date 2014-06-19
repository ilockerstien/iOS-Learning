//
//  DataModel.h
//  dev
//
//  Created by Ian Lockerbie on 2014-06-16.
//  Copyright (c) 2014 LockLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DataModelElement : NSObject

@property (strong, nonatomic) CLLocation *location;
@property  BOOL *isBooze;
@property  float *cost;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSDate *timeEntered;
@property (strong, nonatomic) UIImage *image;
@end
