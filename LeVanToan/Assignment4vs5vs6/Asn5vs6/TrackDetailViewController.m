//
//  TrackDetailViewController.m
//  Asn5vs6
//
//  Created by Z on 12/28/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "TrackDetailViewController.h"
#import "WebViewController.h"
#define apiString @"http://ws.audioscrobbler.com/2.0/?method=Track.getInfo&api_key=9a99a810c0b4eca80893d4f082a59704&format=json"

@interface TrackDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageTrack;
@property (strong, nonatomic) NSDictionary *dataDict;
@property (weak, nonatomic) IBOutlet UIButton *albumButton;
@end

@implementation TrackDetailViewController

- (void)viewDidLoad {
    self.navigationItem.title = _track;
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(void)getData{
    _artist = [_artist stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    _track = [_track stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *a = [NSString stringWithFormat:@"%@%@",@"&artist=",_artist];
    NSString *b = [NSString stringWithFormat:@"%@%@",@"&track=",_track];
    NSString *dataString = [NSString stringWithFormat:@"%@%@%@",apiString,a,b];
    NSURL *dataURL = [NSURL URLWithString:dataString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:dataURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self load:data];
        });
    });
}
-(void)load: (NSData *)data{
    NSError *error;
    _dataDict = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error] objectForKey:@"track"];
    int playCount = [[_dataDict objectForKey:@"playcount"] intValue];
    _playCountLabel.text = @(playCount).stringValue;
    if ([_dataDict objectForKey:@"album"]) {
        _albumLabel.text = [[_dataDict objectForKey:@"album"] objectForKey:@"title"];
        NSString *imageString = [[[[_dataDict objectForKey:@"album"] objectForKey:@"image"] objectAtIndex:1] objectForKey:@"#text"];
        NSURL *imageURL = [NSURL URLWithString:imageString];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                _imageTrack.image = [UIImage imageWithData:data];
            });
        });
    }
    else{
        _albumLabel.text = @"Not available";
        _albumButton.enabled = false;
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    WebViewController *vc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"track"]) {
        vc.urlString = [_dataDict objectForKey:@"url"];
    }
    else if ([segue.identifier isEqualToString:@"album"]) {
        vc.urlString = [[_dataDict objectForKey:@"album"] objectForKey:@"url"];
    }
    else if ([segue.identifier isEqualToString:@"artist"]) {
        vc.urlString = [[_dataDict objectForKey:@"artist"] objectForKey:@"url"];
    }
}
@end
