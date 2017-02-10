//
//  SynqUploader.h
//  Pods
//
//  Created by Kjartan Vestvik on 15.11.2016.
//
//

#import <Foundation/Foundation.h>
@import Photos;
#import "SQVideoUpload.h"

@protocol SQVideoUploadDelegate;


@interface SynqUploader : NSObject

@property (weak, nonatomic) id<SQVideoUploadDelegate> delegate;
@property (nonatomic) BOOL enableDownloadFromICloud;    // Set this to YES to enable videos stored in iCloud being downloaded before uploading to AWS

// A singleton instance
+ (SynqUploader *) sharedInstance;


/**
 *  Upload an array of SQVideoUpload objects (with upload parameters set) to Amazon servers
 *  The upload process will also export the assets to temporary files, and delete the temporary files
 *  before calling uploadSuccess or uploadError
 *
 *  @param videos        An array of SQVideoUpload objects
 *  @param progressBlock This block will be called with upload progress updates. Use this to update the UI (the block is executed on the main thread)
 *  @param successBlock  A block called when all assets are successfully uploaded
 *  @param errorBlock    A block called on upload error, containing error data
 */
- (void) uploadVideoArray:(NSArray *)videos
      exportProgressBlock:(void (^)(double))exportProgressBlock
      uploadProgressBlock:(void (^)(double))uploadProgressBlock;

@end


/**
 *  The SQVideoUploadDelegate is used to communicate video upload complete or failure
 *  messages to the client code. The delegate´s methods are optional to implement
 */
@protocol SQVideoUploadDelegate <NSObject>

@optional

/**
 *  Upload completed succesfully for all videos
 */
- (void) allVideosUploadedSuccessfully;

/**
 *  Upload completed succesfully for a video
 *
 *  @param video The video that completed uploading
 */
- (void) videoUploadCompleteForVideo:(SQVideoUpload *)video;

/**
 *  Upload failed for a video
 *
 *  @param video The video that failed uploading
 */
- (void) videoUploadFailedForVideo:(SQVideoUpload *)video;

@end
