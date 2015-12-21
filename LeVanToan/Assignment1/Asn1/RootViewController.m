//
//  RootViewController.m
//  Asn1
//
//  Created by Z on 12/16/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "RootViewController.h"
#import "DayTableViewCell.h"

@interface RootViewController ()
@property (weak, nonatomic) IBOutlet UILabel *LocationLb;
@property (weak, nonatomic) IBOutlet UILabel *curentTemp;
@property (weak, nonatomic) IBOutlet UILabel *DayLb;
@property (weak, nonatomic) IBOutlet UITableView *TV;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (strong, nonatomic) NSString *search;

@end

@implementation RootViewController

- (void)viewDidLoad {
    //_search = [_region stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [_TV registerNib:[UINib nibWithNibName:@"DayTableViewCell" bundle:nil] forCellReuseIdentifier:@"DayTableViewCell"];
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"hn.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    [self getData5DayAndNotify];
    [self getDataCurrent];
    _TV.tableFooterView = [[UITableView alloc] initWithFrame:CGRectZero];
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DayTableViewCell *cell = [_TV dequeueReusableCellWithIdentifier:@"DayTableViewCell" forIndexPath:indexPath];
    cell.row = (int)indexPath.row;
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)getData5DayAndNotify{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *x = @(_coor.latitude).stringValue;
        NSString *y = @(_coor.longitude).stringValue;
        _search = [NSString stringWithFormat:@"%@%@%@%@",@"lat=",x,@"&lon=",y];
        NSString *a = @"http://api.openweathermap.org/data/2.5/forecast/daily?";
        NSString *b = @"&mode=json&units=metric&cnt=7&appid=2de143494c0b295cca9337e1e96b00e0";
        //NSString *urlString = @"http://api.openweathermap.org/data/2.5/forecast/daily?q=DaNang&mode=json&units=metric&cnt=7&appid=2de143494c0b295cca9337e1e96b00e0";
        NSString *urlString = [NSString stringWithFormat:@"%@%@%@",a,_search,b];
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data
                              
                              options:kNilOptions
                              error:&error];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"load xong" object:json];
    });

}
-(void)getDataCurrent{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *x = @(_coor.latitude).stringValue;
        NSString *y = @(_coor.longitude).stringValue;
        _search = [NSString stringWithFormat:@"%@%@%@%@",@"lat=",x,@"&lon=",y];
        NSString *a = @"http://api.openweathermap.org/data/2.5/weather?";
        NSString *b = @"&mode=json&units=metric&appid=2de143494c0b295cca9337e1e96b00e0";
        //NSString *urlString = @"http://api.openweathermap.org/data/2.5/weather?q=DaNang&mode=json&units=metric&appid=2de143494c0b295cca9337e1e96b00e0";
        NSString *urlString = [NSString stringWithFormat:@"%@%@%@",a,_search,b];
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data
                              
                              options:kNilOptions
                              error:&error];
        int temp = [[[json objectForKey:@"main"] objectForKey:@"temp" ] intValue];
        NSArray *weatherArray = [json objectForKey:@"weather"];
        
        NSDictionary *weather;
        if ([weatherArray count] > 0) {
            weather = [weatherArray objectAtIndex:0];
        }
        
        NSString *icon = [weather objectForKey:@"icon"];
        a = @"http://openweathermap.org/img/w/";
        urlString = [NSString stringWithFormat:@"%@%@%@",a,icon,@".png"];
        url = [NSURL URLWithString:urlString];
        [self performSelectorInBackground:@selector(dowIcon:) withObject:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![_region  isEqual: @""]) {
                _LocationLb.text = _region;
            }
            else{
                _LocationLb.text = [json objectForKey:@"name"];
            }
            _DayLb.text = @"To day";
            _curentTemp.text = [NSString stringWithFormat:@"%i°C",temp];
        });
    });
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
