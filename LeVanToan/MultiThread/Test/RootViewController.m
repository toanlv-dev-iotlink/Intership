//
//  RootViewController.m
//  Test
//
//  Created by Z on 12/15/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "RootViewController.h"
#import "RootTableViewCell.h"
#import "DataStore.h"

@interface RootViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) NSArray *URLStringArray;
@property(weak, nonatomic) IBOutlet UITableView *TBV;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _URLStringArray = [NSArray arrayWithObjects:@"http://farm8.static.flickr.com/7086/7044898577_97445ea260.jpg",
                       @"http://farm8.static.flickr.com/7138/7047749565_8b20628acf.jpg",
                       @"http://farm8.static.flickr.com/7196/7070072209_d1f393c797.jpg",
                       @"http://farm8.static.flickr.com/7272/7071326439_a16c53092c.jpg",
                       @"http://farm8.static.flickr.com/7279/7073096965_f5392cbd9e.jpg",
                       @"http://farm8.static.flickr.com/7189/7091087059_37824d10de.jpg",
                       @"http://farm8.static.flickr.com/7233/7098322101_c77ac97dfa.jpg",
                       @"http://farm8.static.flickr.com/7071/7105582489_73a0aa9b74.jpg",
                       @"http://farm8.static.flickr.com/7132/7113300435_26a77ddc4a.jpg",
                       @"http://farm8.static.flickr.com/7184/7121785089_40e969da0f.jpg",
                       @"http://farm9.static.flickr.com/8009/7142179315_633aa6db7d.jpg",
                       @"http://farm8.static.flickr.com/7239/7171902074_2d9b462d9c.jpg",
                       @"http://farm6.static.flickr.com/5236/7182691108_4f3635a83d.jpg",
                       @"http://farm8.static.flickr.com/7100/7216746262_3e5fffe975.jpg",
                       @"http://farm1.static.flickr.com/42/91957795_5a27611762.jpg",
                       @"http://farm1.static.flickr.com/33/63452603_b3a5b5448d.jpg",
                       @"http://farm1.static.flickr.com/100/317184224_fffde7547e.jpg",
                       @"http://farm2.static.flickr.com/1156/942938486_65b6d1efe7.jpg",
                       @"http://farm1.static.flickr.com/28/41942696_ac7de727a7.jpg",
                       @"http://farm1.static.flickr.com/27/45599281_0e33a17e35.jpg", nil];
    [self.TBV registerNib:[UINib nibWithNibName:@"RootTableViewCell" bundle:nil] forCellReuseIdentifier:@"RootTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _URLStringArray.count;
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RootTableViewCell *cell = (RootTableViewCell *)[_TBV dequeueReusableCellWithIdentifier:@"RootTableViewCell" forIndexPath:indexPath];
    cell.stt = indexPath.row;
    NSString *s = [_URLStringArray objectAtIndex:indexPath.row];
    if (![[[DataStore shared] myDict] objectForKey:s]) {
        cell.URLString = s;
        [cell customInit];
    }
    else{
        NSString *b = @(indexPath.row).stringValue;
        NSString *a = [NSString stringWithFormat:@"%@%@", b, s];
        cell.URLLb.text = a;
        cell.imageV.image = [[[DataStore shared] myDict] objectForKey:s];
    }
    return cell;
};



@end
