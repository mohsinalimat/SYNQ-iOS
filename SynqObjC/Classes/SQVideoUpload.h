//
//  SQVideoUpload.h
//  Pods
//
//  Created by Kjartan Vestvik on 15.11.2016.
//
//  This class represents a video object to upload
//  It must be configured with a PHAsset, the path to the exported
//  video file for the asset, and parameters used when posting to Amazon servers
//  When uploading, the parameter uploadProgress will reflect the current upload
//  progress in percentage.
//

#import <Foundation/Foundation.h>
@import Photos;


@interface SQVideoUpload : NSObject

@property (nonatomic) PHAsset *phAsset;                 // The PHAsset object representing the video
@property (nonatomic) NSString *filePath;               // Path to the exported video file
@property (nonatomic) NSString *videoId;                // The id of the video object when posted to the Synq API
@property (nonatomic) NSDictionary *uploadParameters;   // Upload parameters fetched from the Synq API, to be used when uploading
@property (nonatomic) double uploadProgress;            // Upload progress percentage, between 0.0 and 100.0
@property (nonatomic) double exportProgress;            // Video file export progress percentage, between 0.0 and 100.0
@property (nonatomic) BOOL exportComplete;              // BOOL set to YES if video file is exported

/**
 *  Create a new SQVideoUpload object for a PHAsset
 *
 *  @param asset The PHAsset representing the video
 */
- (id) initWithPHAsset:(PHAsset *)asset;


@end
