//
//  LocationDataController.m
//  dev
//
//  Created by Ian Lockerbie on 2014-06-11.
//  Copyright (c) 2014 LockLabs. All rights reserved.
//

#import "LocationDataController.h"

@implementation LocationDataController

- (Location*)getPointOfInterest
{
    Location *myLocation = [[Location alloc] init];
    myLocation.address = @"Philz Coffee, 399 Golden Gate Ave, San Francisco, CA 94102";
    myLocation.photoFileName = @"coffeebeans.png";
    myLocation.latitude = 37.781453;
    myLocation.longitude = -122.417158;
    
    return myLocation;
}
@end
