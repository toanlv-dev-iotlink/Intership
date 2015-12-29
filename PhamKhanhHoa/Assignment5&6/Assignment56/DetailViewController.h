//
//  DetailViewController.h
//  Assignment56
//
//  Created by HTK-Hoa on 12/25/15.
//  Copyright (c) 2015 HTK-Hoa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btTrack;
@property (weak, nonatomic) IBOutlet UIButton *btAlbum;
@property (weak, nonatomic) IBOutlet UIButton *btAtrist;
@property (weak, nonatomic) IBOutlet UIImageView *imv;
@property (weak, nonatomic) IBOutlet UILabel *lbPlayCount;
@property (weak, nonatomic) IBOutlet UILabel *lbAlbum;
@property (strong,nonatomic) NSString *playCount;
@property (strong,nonatomic) NSString *urlAlbum;
@property (strong,nonatomic) NSString *urlAtrist;
@property (strong,nonatomic) NSString *urlTrack;
@property (strong,nonatomic) NSString *url;
@end
