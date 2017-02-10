//
//  SQCollectionViewCell.m
//  SynqUploader
//
//  Created by Kjartan Vestvik on 15.11.2016.
//  Copyright © 2016 Kjartan. All rights reserved.
//

#import "SQCollectionViewCell.h"

@implementation SQCollectionViewCell

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        self.videoOverlay.hidden = NO;
    }
    else {
        self.videoOverlay.hidden = YES;
    }
}

@end
