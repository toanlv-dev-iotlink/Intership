//
//  RootTableViewCell.h
//  Test
//
//  Created by Z on 12/15/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *URLLb;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (nonatomic, strong) NSString *URLString;
@property (nonatomic) int stt;
@property (nonatomic, strong) UIImage *image;
-(void)customInit;
@end
