//
//  Top100ChartTableViewCell.h
//  Asn5vs6
//
//  Created by Z on 12/25/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Top100ChartTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imageSongView;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) NSDictionary *dataDict;
@property (nonatomic) int index;
-(void)setListenNotify;
-(void)load;
@end
