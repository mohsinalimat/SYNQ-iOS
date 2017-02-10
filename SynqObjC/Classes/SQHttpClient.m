//
//  SQHttpClient.m
//  Pods
//
//  Created by Kjartan Vestvik on 15.11.2016.
//
//

#import "SQHttpClient.h"
#import "AFNetworking.h"


@interface SQHttpClient () {
    AFHTTPSessionManager *backgroundSessionManager;
}
@end


@implementation SQHttpClient


- (id) init
{
    if (self = [super init]) {
        
    }
    return self;
}


- (void) uploadVideo:(SQVideoUpload *)video
       uploadSuccess:(void (^)(NSURLResponse *))successBlock
         uploadError:(void (^)(NSError *))errorBlock
{
    
    // Check that file exists at path
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:video.filePath]) {
        // Notify error
        NSLog(@"No file exist at given path");
        return;
    }
    
    // Check that all parameters are present,
    // build upload form
    NSDictionary *uploadForm = [self getUploadFormFromParametersDictionary:video.uploadParameters];
    if (!uploadForm) {
        NSLog(@"Could not get upload form. A parameter might be missing");
        return;
    }
    
    // Get action (where to post)
    NSString *action = [video.uploadParameters objectForKey:@"action"];
    if (!action) {
        NSLog(@"Missing action parameter.");
        return;
    }
    
    // Post to AWS
    [self postUploadFormWithAction:action
                     andParameters:uploadForm
                       forFilePath:video.filePath
                          andVideo:video
                     uploadSuccess:successBlock
                       uploadError:errorBlock];
}


// Video posting
- (void) postUploadFormWithAction:(NSString *)action
                    andParameters:(NSDictionary *)paramsDict
                      forFilePath:(NSString *)filePath
                         andVideo:(SQVideoUpload *)video
                   uploadSuccess:(void (^)(NSURLResponse *))successBlock
                      uploadError:(void (^)(NSError *))errorBlock
{
    
    // Build the multipart form request
    NSMutableURLRequest *request =
    [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                               URLString:action
                                                              parameters:paramsDict
                                               constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                   
                                                   NSError *error;
                                                   [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath]
                                                                              name:@"file"
                                                                          fileName:@"video.mp4"
                                                                          mimeType:@"video/mp4"
                                                                             error:&error];
                                               } error:nil];
    
    
    // Prepare a temporary file to store the multipart request prior to sending it to the server due to an alleged
    // bug in NSURLSessionTask.
    NSString* tmpFilename = [NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]];
    NSURL* tmpFileUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:tmpFilename]];
    
    [[AFHTTPRequestSerializer serializer]
     requestWithMultipartFormRequest:request
         writingStreamContentsToFile:tmpFileUrl
                   completionHandler:^(NSError *error) {
         
                       // Once the multipart form is serialized into a temporary file, we can initialize
                       // the actual HTTP request using session manager.
                       if (!backgroundSessionManager) {
                           // Session configuration
                           NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.SynqBGTransfer"];
                           [configuration setSessionSendsLaunchEvents:YES];
                           
                           backgroundSessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
                           [backgroundSessionManager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
                       }
                       
                       NSURLSessionUploadTask *uploadTask =
                       [backgroundSessionManager uploadTaskWithRequest:request
                                                              fromFile:tmpFileUrl
                                                              progress:^(NSProgress * _Nonnull uploadProgress) {
                                                                  
                                                                  // This is not called back on the main queue.
                                                                  // Dispatching to the main queue for UI updates
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      
                                                                      video.uploadProgress = uploadProgress.fractionCompleted;
                                                                      //NSLog(@"Video upload progress %f", progress);
                                                                  });
                                                              }
                                                     completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                         if (error) {
                                                             NSLog(@"Error: %@", error);
                                                             errorBlock(error);
                                                         } else {
                                                             // Set upload progress to 1.0 to indicate upload complete (this might not reach 1.0 in progress callback)
                                                             video.uploadProgress = 1.0;
                                                             
                                                             successBlock(response);
                                                         }
                                                         
                                                         // Delete temp file
                                                         if ([[NSFileManager defaultManager] fileExistsAtPath:[tmpFileUrl path]]) {
                                                             [[NSFileManager defaultManager] removeItemAtPath:[tmpFileUrl path] error:nil];
                                                         }
                                                     }];
                       [uploadTask resume];
                   }];
}


#pragma mark - Helper methods

- (NSDictionary *) getUploadFormFromParametersDictionary:(NSDictionary *)paramsDict
{
    // check paramsDict
    if (!paramsDict) {
        NSLog(@"Parameters dictionary is missing");
        return nil;
    }
    
    // Get all needed parameters
    // return nil if one is missing
    NSString *awsAccessKeyId = [paramsDict objectForKey:@"AWSAccessKeyId"];
    if (!awsAccessKeyId) { return nil; }
    
    NSString *contentType = [paramsDict objectForKey:@"Content-Type"];
    if (!contentType) { return nil; }
    
    NSString *policy = [paramsDict objectForKey:@"Policy"];
    if (!policy) { return nil; }
    
    NSString *signature = [paramsDict objectForKey:@"Signature"];
    if (!signature) { return nil; }
    
    NSString *acl = [paramsDict objectForKey:@"acl"];
    if (!acl) { return nil; }
    
    NSString *key = [paramsDict objectForKey:@"key"];
    if (!key) { return nil; }
    
    // Create dictionary with all parameters
    NSDictionary *uploadDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      awsAccessKeyId, @"AWSAccessKeyId",
                                      contentType, @"Content-Type",
                                      policy, @"Policy",
                                      signature, @"Signature",
                                      acl, @"acl",
                                      key, @"key",
                                      nil];
    
    return uploadDictionary;
}



@end
