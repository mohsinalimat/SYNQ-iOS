//
//  SQViewController.m
//  SynqObjC
//
//  Created by kjartanvest on 02/10/2017.
//  Copyright (c) 2017 kjartanvest. All rights reserved.
//

#import "SQViewController.h"
#import "SQCollectionViewCell.h"
#import <SynqObjC/SynqUploader.h>

@interface SQViewController () {
    PHCachingImageManager *cachingImageManager;
    CGSize cellSize;
    //NSIndexPath *selectedIndexPath;     // The index path of a selected video
    NSMutableArray *selectedVideos;     // Array of selected videos for uploading
    int numberOfPostedVideos;   // The number of videos that have have been posted to the Synq API
    //SQNetworkController *network;       // An instance of the network controller
}

@property (nonatomic, strong) NSMutableArray *videos;

@end


@implementation SQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)uploadButtonPushed:(id)sender {
    
}

- (IBAction)streamButtonPushed:(id)sender {
    
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
