//
//  SQViewController.h
//  SynqObjC
//
//  Created by kjartanvest on 02/10/2017.
//  Copyright (c) 2017 kjartanvest. All rights reserved.
//

@import UIKit;

@interface SQViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet UIButton *streamButton;

- (IBAction)uploadButtonPushed:(id)sender;
- (IBAction)streamButtonPushed:(id)sender;


@end
