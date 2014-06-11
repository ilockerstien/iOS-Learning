//
//  devTests.m
//  devTests
//
//  Created by Ian Lockerbie on 2014-06-11.
//  Copyright (c) 2014 LockLabs. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface devTests : XCTestCase

@end

@implementation devTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
