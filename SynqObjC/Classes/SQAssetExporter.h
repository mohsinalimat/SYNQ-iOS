//
//  SQAssetExporter.h
//  Pods
//
//  Created by Kjartan Vestvik on 15.11.2016.
//
//  This class is used to export PHAsset videos to temporary files for upload,
//  and to delete those temporary files after upload is complete
//

#import <Foundation/Foundation.h>
@import Photos;
#import "SQVideoUpload.h"


@protocol SQAssetExporterDelegate;


@interface SQAssetExporter : NSObject

@property (weak, nonatomic) id<SQAssetExporterDelegate> delegate;   // Delegate for reporting export result

/**
 *  Export a SQVideoUpload object to a file
 *  Set the path of the file in SQVideoUpload.filePath
 *
 *  @param video            The SQVideoUpload object containing a PHAsset object to export
 *  @param iCloudDownload   A bool indicating if the video should be downloaded from iCloud if not present on the device
 */
- (void) exportVideo:(SQVideoUpload *)video allowICloudDownload:(BOOL)iCloudDownload;

/**
 *  Delete the file at the location specified in SQVideoUpload.filePath
 *
 *  @param video The SQVideoUpload object
 */
- (void) deleteExportedFileForVideo:(SQVideoUpload *)video;

@end


/**
 *  This delegate protocol is implemented by SynqUploader to get notified when a video
 *  has finished exporting
 */
@protocol SQAssetExporterDelegate <NSObject>

@required

/**
 *  A SQVideoUpload finished exporting the video to a file
 *
 *  @param video The SQVideoUpload object that finished exporting
 */
- (void) assetExporter:(SQAssetExporter *)exporter finishedExportingVideo:(SQVideoUpload *)video;

// TODO: add error methods

@end
