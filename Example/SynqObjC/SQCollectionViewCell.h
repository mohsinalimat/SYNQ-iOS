//
//  SQCollectionViewCell.h
//  SynqUploader
//
//  Created by Kjartan Vestvik on 15.11.2016.
//  Copyright © 2016 Kjartan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UIView *videoOverlay;

@end
