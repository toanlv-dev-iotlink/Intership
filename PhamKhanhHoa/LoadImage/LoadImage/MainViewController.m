//
//  MainViewController.m
//  LoadImage
//
//  Created by MrHoa on 12/15/15.
//  Copyright (c) 2015 MrHoa. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
{
    __weak IBOutlet UITableView *tbView;
    NSArray *arrUrl;
    NSMutableDictionary *dicImage;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrUrl = [NSArray arrayWithObjects:@"http://farm8.static.flickr.com/7086/7044898577_97445ea260.jpg",
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
    dicImage = [[NSMutableDictionary alloc]init];
    [tbView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrUrl.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTableViewCell * cell = [tbView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.image.image = nil;
    cell.lbUrl.text = [arrUrl objectAtIndex:indexPath.row];
    if ([dicImage objectForKey:[arrUrl objectAtIndex:indexPath.row]]!=nil) {//check image in dic
        cell.image.image = [dicImage objectForKey:[arrUrl objectAtIndex:indexPath.row]];
    } else{
        //cach 1: GCD
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//run background
            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[arrUrl objectAtIndex:indexPath.row]]]];//down image
            [dicImage setObject:img forKey:[arrUrl objectAtIndex:indexPath.row]];//set image for key
            dispatch_async(dispatch_get_main_queue(), ^{//main
                MainTableViewCell * cell = (MainTableViewCell *)[tbView cellForRowAtIndexPath:indexPath];
                cell.image.image = [dicImage objectForKey:[arrUrl objectAtIndex:indexPath.row]];
            });
        });
        //cach 2: Operation
//        NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
//        [myQueue addOperationWithBlock:^{
//            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[arrUrl objectAtIndex:indexPath.row]]]];//down image
//            [dicImage setObject:img forKey:[arrUrl objectAtIndex:indexPath.row]];//set image for key
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                MainTableViewCell * cell = (MainTableViewCell *)[tbView cellForRowAtIndexPath:indexPath];
//                cell.image.image = [dicImage objectForKey:[arrUrl objectAtIndex:indexPath.row]];
//            }];
//        }];
        //cach 3:
//        [self performSelectorInBackground:@selector(loadImage:) withObject:indexPath];

    }
    return cell;
}
- (void)loadImage:(NSIndexPath *)indexPath{
    UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[arrUrl objectAtIndex:indexPath.row]]]];//down image
    [dicImage setObject:img forKey:[arrUrl objectAtIndex:indexPath.row]];
    [self performSelectorOnMainThread:@selector(setIm:) withObject:indexPath waitUntilDone:true];
}
- (void)setIm:(NSIndexPath *)indexPath{
    MainTableViewCell * cell = (MainTableViewCell *)[tbView cellForRowAtIndexPath:indexPath];
    cell.image.image = [dicImage objectForKey:[arrUrl objectAtIndex:indexPath.row]];
}
@end
