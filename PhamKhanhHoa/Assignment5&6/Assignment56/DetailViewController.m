//
//  DetailViewController.m
//  Assignment56
//
//  Created by HTK-Hoa on 12/25/15.
//  Copyright (c) 2015 HTK-Hoa. All rights reserved.
//

#import "DetailViewController.h"
#import "WebTop100ChartViewController.h"

@interface DetailViewController ()


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _btAlbum.layer.borderWidth = 1.0f;
    _btAlbum.layer.borderColor = [[UIColor blackColor] CGColor];
    _btAtrist.layer.borderWidth = 1.0f;
    _btAtrist.layer.borderColor = [[UIColor blackColor] CGColor];
    _btTrack.layer.borderWidth = 1.0f;
    _btTrack.layer.borderColor = [[UIColor blackColor] CGColor];
    _lbPlayCount.text = _playCount;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:_url];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSDictionary *objt = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *track = [objt objectForKey:@"track"];
            NSDictionary *album = [track objectForKey:@"album"];
            if (album==nil) {
                _imv.image = nil;
                _lbAlbum.text = @"Album not found";
                _urlAlbum = nil;
                _urlAtrist = [[track objectForKey:@"artist"] objectForKey:@"url"];
                _urlTrack = [track objectForKey:@"url"];

            }else{
                _lbAlbum.text = [album objectForKey:@"title"];
                _urlAlbum = [album objectForKey:@"url"];
                _urlAtrist = [[track objectForKey:@"artist"] objectForKey:@"url"];
                _urlTrack = [track objectForKey:@"url"];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString *urlim = [[[album objectForKey:@"image"] objectAtIndex:3] objectForKey:@"#text"];
                    UIImage *im = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlim]]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _imv.image = im;
                    });
                });
            }
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)actionTrack:(id)sender {
    [self performSegueWithIdentifier:@"segueWeb" sender:@"track"];
}

- (IBAction)actionAlbum:(id)sender {
    [self performSegueWithIdentifier:@"segueWeb" sender:@"album"];
}

- (IBAction)actionArtist:(id)sender {
    [self performSegueWithIdentifier:@"segueWeb" sender:@"artist"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueWeb"]) {
        WebTop100ChartViewController *webVC = segue.destinationViewController;
        if ([sender isEqualToString: @"artist"]) {
            webVC.url = _urlAtrist;
        } else if ([sender isEqualToString:@"album"]){
            webVC.url = _urlAlbum;
        } else if ([sender isEqualToString:@"track"]){
            webVC.url = _urlTrack;
        }
    }
}
@end
