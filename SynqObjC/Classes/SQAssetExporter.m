//
//  SQAssetExporter.m
//  Pods
//
//  Created by Kjartan Vestvik on 15.11.2016.
//
//

#import "SQAssetExporter.h"

@implementation SQAssetExporter



- (id) init
{
    if (self = [super init]) {
        
    }
    return self;
}



- (void) exportVideo:(SQVideoUpload *)video allowICloudDownload:(BOOL)iCloudDownload
{
    if (!video || !video.phAsset) {
        return;
    }
    
    __block BOOL _success;
    
    PHVideoRequestOptions *options = nil;
    if (iCloudDownload) {
        options = [[PHVideoRequestOptions alloc] init];
        [options setNetworkAccessAllowed:YES];
        [options setProgressHandler:^(double progress, NSError *error, BOOL* stop, NSDictionary *dict){
            
            // Set export progress in video object
            [video setExportProgress:progress];
        }];
    }
    
    [[PHImageManager defaultManager] requestExportSessionForVideo:video.phAsset
                                                          options:options
                                                     exportPreset:AVAssetExportPresetHighestQuality
                                                    resultHandler:^(AVAssetExportSession *session, NSDictionary *info) {
                                                        
                                                        // Create unique filename in temp directory
                                                        NSString *filename = [NSString stringWithFormat:@"%f.mov", [[NSDate date] timeIntervalSinceReferenceDate]];
                                                        NSURL *outputURL = [NSURL fileURLWithPath:
                                                                            [NSTemporaryDirectory() stringByAppendingPathComponent:filename]];
                                                        session.outputURL = outputURL;
                                                        session.outputFileType = AVFileTypeQuickTimeMovie;
                                                        
                                                        [session exportAsynchronouslyWithCompletionHandler:^{
                                                            switch ([session status]) {
                                                                case AVAssetExportSessionStatusCompleted:
                                                                    _success = true;
                                                                    break;
                                                                case AVAssetExportSessionStatusWaiting:
                                                                    NSLog(@"Export Waiting");
                                                                    break;
                                                                case AVAssetExportSessionStatusExporting:
                                                                    NSLog(@"Export Exporting");
                                                                    break;
                                                                case AVAssetExportSessionStatusFailed:
                                                                {
                                                                    NSError *error = [session error];
                                                                    NSLog(@"Export failed: %@", [error localizedDescription]);
                                                                    break;
                                                                }
                                                                case AVAssetExportSessionStatusCancelled:
                                                                    NSLog(@"Export canceled");
                                                                    break;
                                                                default:
                                                                    break;
                                                            }
                                                            
                                                            if (!_success) {
                                                                NSLog(@"An error occured during exporting");
                                                                return;
                                                            }
                                                            
                                                            // Set export progress to 1.0
                                                            [video setExportProgress:1.0];
                                                            
                                                            // Set file path in video object
                                                            [video setFilePath:[session.outputURL path]];
                                                            
                                                            if (self.delegate && [self.delegate respondsToSelector:@selector(assetExporter:finishedExportingVideo:)]) {
                                                                [self.delegate assetExporter:self finishedExportingVideo:video];
                                                            }
                                                        }];
                                                    }];
}


- (void) deleteExportedFileForVideo:(SQVideoUpload *)video
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[video filePath]]) {
        if ([[NSFileManager defaultManager] removeItemAtPath:[video filePath] error:nil]) {
            NSLog(@"File deleted");
        }
        else {
            NSLog(@"File delete error...");
        }
    }
    else {
        NSLog(@"ERROR: could not find file to delete");
    }
}


@end
