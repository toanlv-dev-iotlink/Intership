//
//  EarthquakeDetailViewController.m
//  Asn5vs6
//
//  Created by Z on 12/28/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "EarthquakeDetailViewController.h"
#import "WebViewController.h"

@interface EarthquakeDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *rms;
@property (weak, nonatomic) IBOutlet UILabel *sources;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation EarthquakeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Eartquake Detail";
    //_place.text = [_properties objectForKey:@"place"];
    //_rms.text = [_properties objectForKey:@"rms"];
    //_sources.text = [_properties objectForKey:@"sources"];
    NSTimeInterval time = [[_properties objectForKey:@"time"] doubleValue];
    NSDate *day = [NSDate dateWithTimeIntervalSince1970:time];
    //Lay thu
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    NSString *date = [format stringFromDate:day];
    //_time.text = date;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    WebViewController *vc = segue.destinationViewController;
    vc.urlString = [_properties objectForKey:@"url"];
}


@end
