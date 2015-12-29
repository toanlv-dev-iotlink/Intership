//
//  Top100ChartTableViewCell.m
//  Asn5vs6
//
//  Created by Z on 12/25/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "Top100ChartTableViewCell.h"
#import "Top100ChartViewController.h"
@implementation Top100ChartTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setListenNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData:) name:@"get _tracks xong" object:nil];
}
-(void)loadData:(NSNotification *)notification{
    _dataDict = [notification.object objectAtIndex:_index];
    [self load];
}
-(void)prepareForReuse{
    [super prepareForReuse];
    _imageSongView.image = nil;
    _songLabel.text = @"";
    _artistLabel.text = @"";
}
-(void)load{
    _songLabel.text = [_dataDict objectForKey:@"name"];
    _artistLabel.text = [[_dataDict objectForKey:@"artist"] objectForKey:@"name"];
    NSString *imageString = [[[_dataDict objectForKey:@"image"] objectAtIndex:0] objectForKey:@"#text"];
    if ([[Top100ChartViewController imageDict] objectForKey:imageString]) {
        _imageSongView.image = [[Top100ChartViewController imageDict] objectForKey:imageString];
    }
    else{
        
        NSURL *imageURL = [NSURL URLWithString:imageString];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[Top100ChartViewController imageDict] setObject:[UIImage imageWithData:imageData] forKey:imageURL];
                _imageSongView.image = [UIImage imageWithData:imageData];
            });
        });
    }
}

@end
