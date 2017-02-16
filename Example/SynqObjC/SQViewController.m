//
//  SQViewController.m
//  SynqObjC
//
//  Created by kjartanvest on 02/10/2017.
//  Copyright (c) 2017 kjartanvest. All rights reserved.
//

#import "SQViewController.h"
#import "SQCollectionViewCell.h"
#import "SQVideoHandler.h"
#import "SQServerController.h"
#import <SynqObjC/SynqUploader.h>
#import <SynqStreamer/SynqStreamer.h>

@interface SQViewController () <SQVideoUploadDelegate> {
    PHCachingImageManager *cachingImageManager;
    CGSize cellSize;
    NSMutableArray *selectedVideos;     // Array of selected videos for uploading
    int numberOfPostedVideos;   // The number of videos that have have been posted to the Synq API
    SQServerController *server;       // An instance of the server controller
}

@property (nonatomic, strong) NSMutableArray *videos;

@end


@implementation SQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [_collectionView setAllowsMultipleSelection:YES];
    
    // Init caching manager for video thumbnails
    cachingImageManager = [[PHCachingImageManager alloc] init];
    
    // Init the server controller
    server = [[SQServerController alloc] init];
    
    // Set delegate to handle upload results
    [[SynqUploader sharedInstance] setDelegate:self];
    
    // Initialize array and counter
    selectedVideos = [NSMutableArray array];
    numberOfPostedVideos = 0;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Set collectionView cell size depending on screen size
    int screenWidth = self.view.frame.size.width;
    double cellWidth = (screenWidth - 6) / 3.0;  // 3 cells per row, 3 points margin between each cell
    UICollectionViewFlowLayout *layout = (id) self.collectionView.collectionViewLayout;
    cellSize = CGSizeMake(cellWidth, cellWidth);
    layout.itemSize = cellSize;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Check Photos authorization
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            
            // Get device videos
            self.videos = [[SQVideoHandler sharedInstance] deviceVideos];
            
            // Reload collection view data, on main thread!
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
    }];
    
    // Try logging in user (if unsuccessful, a user will be created and then logged in)
    [server loginUser];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button actions


- (IBAction)uploadButtonPushed:(id)sender {
    NSLog(@"Upload %lu videos", (unsigned long)selectedVideos.count);
    
    if (selectedVideos.count == 0) {
        return;
    }
    
    // Post all selected videos
    [self postAllVideos];
}


- (IBAction)streamButtonPushed:(id)sender {
    
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"SynqStreamerResources" withExtension:@"bundle"]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Streamer" bundle:bundle];
    StreamerViewController *streamView = [storyboard instantiateViewControllerWithIdentifier:@"StreamerViewController"];
    
    // Navigation controller
    AppNavigationController *navController = [[AppNavigationController alloc] initWithRootViewController:streamView];
    [self presentViewController:navController animated:YES completion:nil];
}


#pragma mark - Private helper methods


- (void) postAllVideos
{
    // Do nothing if no videos are selected
    if (selectedVideos.count == 0) {
        return;
    }
    
    // Post all selected videos
    for (SQVideoUpload *video in selectedVideos) {
        [self createVideoObjectForVideo:video];
    }
}


- (void) deselectAllCells
{
    //[self updateMyClipsWithConnectionsForSelectedMoment];
    [self removeAllSelections];
    
    // Empty selected items array and update upload button state
    [selectedVideos removeAllObjects];
    
    // Reload collectionView
    [self.collectionView reloadData];
}


- (void) removeAllSelections
{
    for (NSIndexPath *indexPath in [self.collectionView indexPathsForSelectedItems]) {
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
}



#pragma mark - Video methods calling SynqAPI


- (void) createVideoObjectForVideo:(SQVideoUpload *)sqVideo
{
    [server createVideoWithSuccessBlock:^(NSDictionary *jsonResponse)
    {
        //NSLog(@"SynqAPI: get upload params success, params: %@", jsonResponse);
        
        // Set uploadParameters in SQVideoUpload object
        [sqVideo setUploadParameters:jsonResponse];
        
        // Increment counter
        numberOfPostedVideos++;
        
        // If all videos are done posting, upload the video array
        if (numberOfPostedVideos == selectedVideos.count) {
            NSLog(@"All done, start uploading...");
            [self uploadVideoArray:selectedVideos];
        }
    }
    httpFailureBlock:^(NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"MV: video create error: %@", error);
    }];
}



- (void) uploadVideoArray:(NSMutableArray *)videoArray
{
    // Create an array of videos to upload (in this case only one video)
    //NSArray *videosArray = [NSArray arrayWithObjects:sqVideo, nil];
    
    // Use SynqUploader to initiate exporting and uploading the videos in the array
    [[SynqUploader sharedInstance] uploadVideoArray:videoArray
                                exportProgressBlock:^(double exportProgress)
    {
        NSLog(@"Export progress: %f", exportProgress);
        // Report progress to UI
        [self.progressView setProgress:exportProgress];
    }
    uploadProgressBlock:^(double uploadProgress)
    {
        NSLog(@"Upload progress: %f", uploadProgress);
                                    
        // We need progress between 0 and 1, so must divide percent by 100
        double progressBelowOne = uploadProgress / 100.0;
        // Report progress to UI
        [self.progressView setProgress:progressBelowOne];
    }];
}


#pragma mark - SQVideoUploadDelegate methods


- (void) allVideosUploadedSuccessfully
{
    // Handle video upload complete
    NSLog(@"All videos uploaded successfully");
    
    // Reset selections and counter
    [self deselectAllCells];
    numberOfPostedVideos = 0;
    
    // Reset progress view
    [self.progressView setProgress:0.0];
    
}

- (void) videoUploadCompleteForVideo:(SQVideoUpload *)video
{
    // Handle upload complete for the video (for instance, update database of uploaded videos)
    NSLog(@"Upload complete for video with id %@", video.videoId);
}

- (void) videoUploadFailedForVideo:(SQVideoUpload *)video
{
    // Handle error
    NSLog(@"Upload failed for video with id %@", video.videoId);
}


#pragma mark - UICollectionView delegate


- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // Add video to selectedVideos array
    SQVideoUpload *video = [self.videos objectAtIndex:indexPath.row];
    [selectedVideos addObject:video];
}

- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove video from selectedVideos array
    SQVideoUpload *video = [self.videos objectAtIndex:indexPath.row];
    [selectedVideos removeObject:video];
}


#pragma mark - UICollectionView datasource


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.videos count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"SQCell";
    
    SQCollectionViewCell *cell = (SQCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell.tag) {
        [cachingImageManager cancelImageRequest:(PHImageRequestID)cell.tag];
    }
    
    SQVideoUpload *video = [self.videos objectAtIndex:indexPath.row];
    PHAsset *asset = [video phAsset];
    
    cell.tag = [cachingImageManager requestImageForAsset:asset
                                              targetSize:cellSize
                                             contentMode:PHImageContentModeAspectFill
                                                 options:nil
                                           resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                               cell.videoImageView.image = result;
                                           }];
    
    return cell;
}



@end
