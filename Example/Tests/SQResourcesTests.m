//
//  SQResourcesTests.m
//  SynqObjC
//
//  Created by Kjartan Vestvik on 16.02.2017.
//  Copyright © 2017 kjartanvest. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SynqStreamer/SynqStreamer.h>


@interface SQResourcesTests : XCTestCase

@end

@implementation SQResourcesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testResourceBundle {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"SynqStreamerResources" withExtension:@"bundle"];
    XCTAssertNotNil(bundleURL, @"SynqStreamerResources bundle is nil");
    
    NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
    XCTAssertNotNil(bundle, @"Bundle is nil");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Streamer" bundle:bundle];
    XCTAssertNotNil(storyboard, @"Streamer storyboard in bundle is nil");
}

-(void)testStreamerViewController {
    
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"SynqStreamerResources" withExtension:@"bundle"]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Streamer" bundle:bundle];
    
    // MainViewConroller
    MainViewController *streamView = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    XCTAssertNotNil(streamView, @"MainViewController is nil");
    
    // Navigation controller
    AppNavigationController *navController = [[AppNavigationController alloc] initWithRootViewController:streamView];
    XCTAssertNotNil(navController, @"AppNavigationController is nil");
}

@end
