//
//  SQInfoPlistTests.m
//  SynqObjC
//
//  This class will test that the required usage descriptions for accessing the camera, microphone and Photos Library are added to the Info.plist. It will also test that Allow Arbitrary Loads it set to YES to allow requests via non-https (used for http://localhost:/)
//
//  Created by Kjartan Vestvik on 14.02.2017.
//  Copyright © 2017 kjartanvest. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface SQInfoPlistTests : XCTestCase

@end

@implementation SQInfoPlistTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAppTransportSecurity
{
    NSDictionary *appTransport = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSAppTransportSecurity"];
    XCTAssertTrue(appTransport != nil, @"App Transport Sec is nil");
    XCTAssertTrue([[appTransport objectForKey:@"NSAllowsArbitraryLoads"] boolValue], @"NSAllowsArbitraryLoads entry missing");
}

- (void)testCameraUsageDescription
{
    NSString *cameraUsage = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSCameraUsageDescription"];
    XCTAssertNotNil(cameraUsage, @"Camera usage description is missing");
}

- (void)testMicrophoneUsageDescription
{
    NSString *microphoneUsage = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSMicrophoneUsageDescription"];
    XCTAssertNotNil(microphoneUsage, @"Microphone usage description is missing");
}

- (void)testPhotoLibraryUsageDescription
{
    NSString *photosUsage = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSPhotoLibraryUsageDescription"];
    XCTAssertNotNil(photosUsage, @"Photo Library usage description is missing");
}



@end
