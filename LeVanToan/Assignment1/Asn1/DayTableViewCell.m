//
//  DayTableViewCell.m
//  Asn1
//
//  Created by Z on 12/18/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "DayTableViewCell.h"

@implementation DayTableViewCell

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(load:) name:@"load xong" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)load:(NSNotification *)notification {
//lay dictionary cho ngay tuong ung
    NSDictionary *json = [[notification.object objectForKey:@"list"] objectAtIndex:_row];
//Lay ngay
    NSTimeInterval dt = [[json objectForKey:@"dt"] doubleValue];
    NSDate *day = [NSDate dateWithTimeIntervalSince1970:dt];
//Lay thu
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    [format setDateFormat:@"EEEE"];
    NSString *date = [format stringFromDate:day];
//hien thi thu ra ui
    dispatch_async(dispatch_get_main_queue(), ^{
        _DayLb.text = (NSString *)[NSString stringWithFormat:@"%@", date] ;
    });
//lay nhiet do
    int max = [[[json objectForKey:@"temp"] objectForKey:@"max"] intValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        _maxTempLb.text = [NSString stringWithFormat:@"%i°C",max];
    });
    int min = [[[json objectForKey:@"temp"] objectForKey:@"min"] intValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        _minTempLb.text = [NSString stringWithFormat:@"%i°C",min];
    });
//lay icon
    NSArray *weatherArray = [json objectForKey:@"weather"];
    
    NSDictionary *weather;
    if ([weatherArray count] > 0) {
        weather = [weatherArray objectAtIndex:0];
    }
    
    NSString *icon = [weather objectForKey:@"icon"];
    NSString *a = @"http://openweathermap.org/img/w/";
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",a,icon,@".png"];
    NSURL *url = [NSURL URLWithString:urlString];
    [self performSelectorInBackground:@selector(dowIcon:) withObject:url];
}
-(void)dowIcon:(NSURL *)url{
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    [self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:true];
}
-(void)setImage:(UIImage *) image{
    _weatherIcon.image = image;
}
@end
