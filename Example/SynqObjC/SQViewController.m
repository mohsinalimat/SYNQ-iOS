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

@interface SQViewController () {
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

- (IBAction)uploadButtonPushed:(id)sender {
    
}

- (IBAction)streamButtonPushed:(id)sender {
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"SynqStreamer" withExtension:@"bundle"]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Streamer" bundle:bundle];
    MainViewController *streamView = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    
    // Navigation controller
    AppNavigationController *navController = [[AppNavigationController alloc] initWithRootViewController:streamView];
    [self presentViewController:navController animated:YES completion:nil];
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
