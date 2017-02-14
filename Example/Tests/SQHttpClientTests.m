//
//  SQHttpClientTests.m
//  SynqUploader
//
//  Created by Kjartan Vestvik on 23.01.2017.
//  Copyright © 2017 Kjartan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SynqObjC/SQHttpClient.h>
#import <SynqObjC/SQHttpClientExtension.h>


@interface SQHttpClientTests : XCTestCase

@property (nonatomic) SQHttpClient *client;

@end


@implementation SQHttpClientTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.client = [[SQHttpClient alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testUploadForm
{
    NSDictionary *uploadFormDict = [self.client getUploadFormFromParametersDictionary:nil];
    XCTAssertNil(uploadFormDict, @"Upload form not nil when passed nil dictionary");
    
    // Missing AWSAccessKeyId
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"SomeValue", @"Content-Type",
                            @"SomeValue", @"Policy",
                            @"SomeValue", @"Signature",
                            @"SomeValue", @"acl",
                            @"SomeValue", @"key", nil];
    uploadFormDict = [self.client getUploadFormFromParametersDictionary:params];
    XCTAssertNil(uploadFormDict, @"Upload form not nil when passed dictionary missing AWSAccessKeyId");
    
    // Missing Content-Type
    params = [NSDictionary dictionaryWithObjectsAndKeys:
              @"SomeValue", @"AWSAccessKeyId",
              @"SomeValue", @"Policy",
              @"SomeValue", @"Signature",
              @"SomeValue", @"acl",
              @"SomeValue", @"key", nil];
    uploadFormDict = [self.client getUploadFormFromParametersDictionary:params];
    XCTAssertNil(uploadFormDict, @"Upload form not nil when passed dictionary missing Content-Type");
    
    // Missing Policy
    params = [NSDictionary dictionaryWithObjectsAndKeys:
              @"SomeValue", @"AWSAccessKeyId",
              @"SomeValue", @"Content-Type",
              @"SomeValue", @"Signature",
              @"SomeValue", @"acl",
              @"SomeValue", @"key", nil];
    uploadFormDict = [self.client getUploadFormFromParametersDictionary:params];
    XCTAssertNil(uploadFormDict, @"Upload form not nil when passed dictionary missing Policy");
    
    // Missing Signature
    params = [NSDictionary dictionaryWithObjectsAndKeys:
              @"SomeValue", @"AWSAccessKeyId",
              @"SomeValue", @"Content-Type",
              @"SomeValue", @"Policy",
              @"SomeValue", @"acl",
              @"SomeValue", @"key", nil];
    uploadFormDict = [self.client getUploadFormFromParametersDictionary:params];
    XCTAssertNil(uploadFormDict, @"Upload form not nil when passed dictionary missing Signature");
    
    // Missing acl
    params = [NSDictionary dictionaryWithObjectsAndKeys:
              @"SomeValue", @"AWSAccessKeyId",
              @"SomeValue", @"Content-Type",
              @"SomeValue", @"Policy",
              @"SomeValue", @"Signature",
              @"SomeValue", @"key", nil];
    uploadFormDict = [self.client getUploadFormFromParametersDictionary:params];
    XCTAssertNil(uploadFormDict, @"Upload form not nil when passed dictionary missing acl");
    
    // Missing key
    params = [NSDictionary dictionaryWithObjectsAndKeys:
              @"SomeValue", @"AWSAccessKeyId",
              @"SomeValue", @"Content-Type",
              @"SomeValue", @"Policy",
              @"SomeValue", @"Signature",
              @"SomeValue", @"acl", nil];
    uploadFormDict = [self.client getUploadFormFromParametersDictionary:params];
    XCTAssertNil(uploadFormDict, @"Upload form not nil when passed dictionary missing key");
    
    // All params set:
    params = [NSDictionary dictionaryWithObjectsAndKeys:
              @"SomeValue", @"AWSAccessKeyId",
              @"SomeValue", @"Content-Type",
              @"SomeValue", @"Policy",
              @"SomeValue", @"Signature",
              @"SomeValue", @"acl",
              @"SomeValue", @"key", nil];
    uploadFormDict = [self.client getUploadFormFromParametersDictionary:params];
    XCTAssertNotNil(uploadFormDict, @"Upload form is nil when passed all parameters");
    
    NSString *accessKey = [uploadFormDict objectForKey:@"AWSAccessKeyId"];
    XCTAssertNotNil(accessKey, @"Missing object for key AWSAccessKeyId in upload form");
    
    NSString *contentType = [uploadFormDict objectForKey:@"Content-Type"];
    XCTAssertNotNil(contentType, @"Missing object for key Content-Type in upload form");
    
    NSString *policy = [uploadFormDict objectForKey:@"Policy"];
    XCTAssertNotNil(policy, @"Missing object for key Policy in upload form");
    
    NSString *signature = [uploadFormDict objectForKey:@"Signature"];
    XCTAssertNotNil(signature, @"Missing object for key Signature in upload form");
    
    NSString *acl = [uploadFormDict objectForKey:@"acl"];
    XCTAssertNotNil(acl, @"Missing object for key acl in upload form");
    
    NSString *key = [uploadFormDict objectForKey:@"key"];
    XCTAssertNotNil(key, @"Missing object for key key in upload form");
}

@end
