//
//  RootTableViewCell.m
//  Test
//
//  Created by Z on 12/15/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "DataStore.h"
#import "RootTableViewCell.h"

@implementation RootTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)loadImage:(NSURL *)urlImage{
        NSData *dataImage = [NSData dataWithContentsOfURL:urlImage];
        UIImage *image = [UIImage imageWithData:dataImage];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setImage:image];
    });
}
-(void)setImage:(UIImage *)image{

        _image = image;
        _imageV.image = image;
    [[[DataStore shared] myDict] setObject:image forKey:_URLString];

}
-(void)customInit{
    NSString *a = _URLString;
    NSString *b = @(_stt).stringValue;
    a = [NSString stringWithFormat:@"%@%@", b, _URLString];
    _URLLb.text = a;
    NSURL *imageURL = [NSURL URLWithString:_URLString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadImage:imageURL];
    });
}
@end
