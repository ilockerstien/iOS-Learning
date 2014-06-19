//
//  Location.h
//  dev
//
//  Created by Ian Lockerbie on 2014-06-11.
//  Copyright (c) 2014 LockLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject
@property (strong, nonatomic) NSString *address;

@property (strong, nonatomic) NSString *photoFileName;

@property (nonatomic) float latitude;

@property (nonatomic) float longitude;

@end
