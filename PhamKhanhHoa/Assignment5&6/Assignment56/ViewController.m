//
//  ViewController.m
//  Assignment56
//
//  Created by HTK-Hoa on 12/24/15.
//  Copyright (c) 2015 HTK-Hoa. All rights reserved.
//

#import "ViewController.h"
#import "Top100ChartTableViewCell.h"
#import "DetailViewController.h"

@interface ViewController ()
{
    __weak IBOutlet UITableView *tbvChart;
    NSMutableDictionary *dicTrack;
    NSMutableDictionary *dicImage;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dicTrack = [[NSMutableDictionary alloc] init];
    dicImage = [[NSMutableDictionary alloc] init];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Top100ChartTableViewCell *cell = [tbvChart dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.lbSinger.text = nil;
    cell.lbSong.text = nil;
    cell.imvPhoto.image = nil;
    if ([dicImage objectForKey:[[[[dicTrack objectForKey:@(indexPath.row).stringValue] objectForKey:@"image"] objectAtIndex:3] objectForKey:@"#text"]]!=nil) {
        NSDictionary *tmpTrack = [dicTrack objectForKey:@(indexPath.row).stringValue];
        NSDictionary *artist = [tmpTrack objectForKey:@"artist"];
        NSString *nameSinger = [artist objectForKey:@"name"];
        NSString *nameSong = [tmpTrack objectForKey:@"name"];
        cell.lbSong.text = nameSong;
        cell.lbSinger.text = nameSinger;
        cell.imvPhoto.image = [dicImage objectForKey:[[[tmpTrack objectForKey:@"image"] objectAtIndex:3] objectForKey:@"#text"]];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *tmpTrack = [dicTrack objectForKey:@(indexPath.row).stringValue];
                NSDictionary *artist = [tmpTrack objectForKey:@"artist"];
                NSString *nameSinger = [artist objectForKey:@"name"];
                NSString *nameSong = [tmpTrack objectForKey:@"name"];
                cell.lbSong.text = nameSong;
                cell.lbSinger.text = nameSinger;
                if ([dicImage objectForKey:[[[tmpTrack objectForKey:@"image"] objectAtIndex:3] objectForKey:@"#text"]]!=nil) {
                    cell.imvPhoto.image = [dicImage objectForKey:[[[tmpTrack objectForKey:@"image"] objectAtIndex:3] objectForKey:@"#text"]];
                } else{
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NSURL *urlIM = [NSURL URLWithString:[[[tmpTrack objectForKey:@"image"] objectAtIndex:3] objectForKey:@"#text"]];
                        NSData *dataIM = [NSData dataWithContentsOfURL:urlIM];
                        UIImage *im = [UIImage imageWithData:dataIM];
                        [dicImage setObject:im forKey:[[[tmpTrack objectForKey:@"image"] objectAtIndex:3] objectForKey:@"#text"]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            cell.imvPhoto.image = [dicImage objectForKey:[[[tmpTrack objectForKey:@"image"] objectAtIndex:3] objectForKey:@"#text"]];
                        });
                    });
                }
            });
        });
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *deVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [self.navigationController pushViewController:deVC animated:YES];
    deVC.playCount = [[dicTrack objectForKey:@(indexPath.row).stringValue] objectForKey:@"playcount"];
    NSDictionary *tmpTrack = [dicTrack objectForKey:@(indexPath.row).stringValue];
    NSDictionary *artist = [tmpTrack objectForKey:@"artist"];
    NSString *nameSinger = [artist objectForKey:@"name"];
    NSString *nameSong = [tmpTrack objectForKey:@"name"];
    NSString *url = [NSString stringWithFormat:@"http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=9a99a810c0b4eca80893d4f082a59704&format=json&artist=%@&track=%@",nameSinger,nameSong];
    deVC.url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
}

- (void)loadData {
    NSString *urlString = @"http://ws.audioscrobbler.com/2.0/?method=chart.gettoptracks&api_key=9a99a810c0b4eca80893d4f082a59704&format=json";
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSDictionary *objt = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *tracts = [objt objectForKey:@"tracks"];
    NSArray *arrayTrack = [tracts objectForKey:@"track"];
    for (int i = 0; i<arrayTrack.count; i++) {
        [dicTrack setObject:[arrayTrack objectAtIndex:i] forKey:@(i).stringValue];
    }
}
@end
