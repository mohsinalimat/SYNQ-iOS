//
//  SQHttpClient.h
//  Pods
//
//  Created by Kjartan Vestvik on 15.11.2016.
//
//  This class is used to post a multipart form to Amazon Web Services
//  to upload the given video file.
//  Parameters for the upload form must be set in the SQVideoUpload object,
//  as well as the path of the file to upload
//

#import <Foundation/Foundation.h>
#import "SQVideoUpload.h"


@interface SQHttpClient : NSObject

- (id) init;

/**
 *  Post a multipart form to Amazon
 *
 *  @param video        The video object containing the video to upload and the parameters
 *  @param successBlock A block called on upload success
 *  @param errorBlock   A block called on upload error
 */
- (void) uploadVideo:(SQVideoUpload *)video
       uploadSuccess:(void (^)(NSURLResponse *))successBlock
         uploadError:(void (^)(NSError *))errorBlock;

@end
