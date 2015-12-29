//
//  Top100ChartViewController.m
//  Asn5vs6
//
//  Created by Z on 12/25/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "Top100ChartViewController.h"
#import "Top100ChartTableViewCell.h"
#import "TrackDetailViewController.h"
#define apiString @"http://ws.audioscrobbler.com/2.0/?method=chart.gettoptracks&api_key=9a99a810c0b4eca80893d4f082a59704&format=json"
@interface Top100ChartViewController ()
@property (weak, nonatomic) IBOutlet UITableView *top100ChartTableView;
@property (strong, nonatomic) NSArray *tracks;
@end
@implementation Top100ChartViewController
static NSMutableDictionary *imageDict;
+(NSMutableDictionary *)imageDict{
    return imageDict;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Top 100 Chart";
    [self getdataDict];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma TABLEVIEW DATA SOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Top100ChartTableViewCell *cell = [_top100ChartTableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    if (_tracks.count != 0) {
        cell.dataDict = [_tracks objectAtIndex:indexPath.row];
        [cell load];
    }
    else{
        cell.index = (int)indexPath.row;
        [cell setListenNotify];
    }
    [cell load];
    return cell;
}
#pragma TABLEVIEW DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"Detail" sender:indexPath];
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    TrackDetailViewController *vc = segue.destinationViewController;
    Top100ChartTableViewCell *cell = (Top100ChartTableViewCell *)[_top100ChartTableView cellForRowAtIndexPath:sender];
    vc.track = cell.songLabel.text;
    vc.artist = cell.artistLabel.text;
}
#pragma GET DATA AND NOTIFY
-(void)getdataDict{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:apiString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError* error;
            _tracks = [[[NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&error] objectForKey:@"tracks"] objectForKey:@"track"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"get _tracks xong" object:_tracks];
        });
    });
}
@end
