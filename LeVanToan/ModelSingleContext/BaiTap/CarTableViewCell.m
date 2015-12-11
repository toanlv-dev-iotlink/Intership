//
//  CarTableViewCell.m
//  BaiTap
//
//  Created by Z on 12/8/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "CarTableViewCell.h"

@interface CarTableViewCell ()

@property(weak, nonatomic) IBOutlet UILabel *model;
@property(weak,nonatomic) IBOutlet UILabel *carNumber;
@property(weak,nonatomic) IBOutlet UIImageView *avatar;

@end
@implementation CarTableViewCell



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
