//
//  SQVideoHandler.m
//  SynqUploader
//
//  Created by Kjartan Vestvik on 15.11.2016.
//  Copyright © 2016 Kjartan. All rights reserved.
//

#import "SQVideoHandler.h"
@import Photos;
#import <SynqObjC/SQVideoUpload.h>


@interface SQVideoHandler () {
    // Fetch result for PHAssets
    PHFetchResult *videoFetchResult;
}
@end


@implementation SQVideoHandler


+ (SQVideoHandler *) sharedInstance
{
    static dispatch_once_t once;
    static SQVideoHandler *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (id) init
{
    if (self = [super init]) {
        [self fetchDeviceVideos];
    }
    return self;
}


- (void) fetchDeviceVideos
{
    // Initialize array
    self.deviceVideos = [NSMutableArray array];
    
    // Fetch video assets
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES],];
    videoFetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:fetchOptions];
    
    // Create SQVideoUpload object for each video on the device
    // and add them to the deviceVideos array
    for (PHAsset *asset in videoFetchResult) {
        
        SQVideoUpload *video = [[SQVideoUpload alloc] initWithPHAsset:asset];
        
        [self.deviceVideos addObject:video];
    }
}

@end
