//
//  Top100ChartTableViewCell.h
//  Assignment56
//
//  Created by HTK-Hoa on 12/25/15.
//  Copyright (c) 2015 HTK-Hoa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Top100ChartTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbSong;
@property (weak, nonatomic) IBOutlet UILabel *lbSinger;
@property (weak, nonatomic) IBOutlet UIImageView *imvPhoto;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;


@end
