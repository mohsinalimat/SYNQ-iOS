//
//  SQVideoUpload.m
//  Pods
//
//  Created by Kjartan Vestvik on 15.11.2016.
//
//

#import "SQVideoUpload.h"


@implementation SQVideoUpload


- (id) initWithPHAsset:(PHAsset *)asset
{
    if (self = [super init]) {
        self.phAsset = asset;
        self.uploadProgress = 0.0;
        self.exportProgress = 0.0;
    }
    return self;
}



@end
