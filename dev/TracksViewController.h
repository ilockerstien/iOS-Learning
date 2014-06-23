//
//  FirstViewController.h
//  dev
//
//  Created by Ian Lockerbie on 2014-06-11.
//  Copyright (c) 2014 LockLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationDataController.h"
#import "Location.h"
#import <CoreLocation/CoreLocation.h>

@interface TracksViewController : UIViewController <CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
