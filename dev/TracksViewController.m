//
//  FirstViewController.m
//  dev
//
//  Created by Ian Lockerbie on 2014-06-11.
//  Copyright (c) 2014 LockLabs. All rights reserved.
//

#import "TracksViewController.h"
#import "LocationDataController.h"
#import "Location.h"
#import "RootTabBarController.h"

@interface TracksViewController ()


@end

@implementation TracksViewController {

CLLocationManager *manager;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    _mapView.showsUserLocation = YES;
    self.dataModel = ((RootTabBarController *)self.tabBarController).dataModel;
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"View Will appear");
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager startUpdatingLocation];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [manager stopUpdatingLocation];
    NSLog(@"Tracksviewcontroller will disappear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CLLocationManager Delegate Methods
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error:%@",error);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
    if (currentLocation != nil){
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance
        (currentLocation.coordinate, 2000, 2000);
        [self.mapView setRegion:viewRegion];
        NSLog(@"%@",[NSString stringWithFormat:@"%.8f",currentLocation.coordinate.latitude]);
        NSLog(@"%@",[NSString stringWithFormat:@"%.8f",currentLocation.coordinate.longitude]);}
    
}


@end
