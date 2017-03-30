//
//  iOS_Selectable_OverlayUITests.m
//  iOS_Selectable_OverlayUITests
//
//  Created by eidan on 17/1/17.
//  Copyright © 2017年 AutoNavi. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface iOS_Selectable_OverlayUITests : XCTestCase

@end

@implementation iOS_Selectable_OverlayUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    XCUIElement *centerElement = [[XCUIApplication alloc] init].otherElements[@"mamapview"];
    
    sleep(1);
    
    [centerElement tap];
    
    sleep(2);
    
    [centerElement tap];
    
    sleep(2);
}

@end
