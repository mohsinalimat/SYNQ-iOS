//
//  SQAssetExporter.h
//  Pods
//
//  Created by Kjartan Vestvik on 15.11.2016.
//
//  This class is used to export PHAsset videos to temporary files,
//  and to delete those temporary files
//

#import <Foundation/Foundation.h>
@import Photos;
#import "SQVideoUpload.h"


@protocol SQAssetExporterDelegate;


@interface SQAssetExporter : NSObject

@property (weak, nonatomic) id<SQAssetExporterDelegate> delegate;

/**
 *  Export a SQVideoUpload object to a file
 *  Set the path of the file in SQVideoUpload.filePath
 *
 *  @param video The SQVideoUpload object containing a PHAsset object to export
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
 *  This delegate protocol is implemented by SynqLib to get notified when a video
 *  has finished exporting
 */
@protocol SQAssetExporterDelegate <NSObject>

@required
- (void) assetExporter:(SQAssetExporter *)exporter finishedExportingVideo:(SQVideoUpload *)video;

// TODO: add error methods

@end
