//
//  WeatherViewController.m
//  DemoWeather
//
//  Created by MrHoa on 12/17/15.
//  Copyright (c) 2015 MrHoa. All rights reserved.
//

#import "WeatherViewController.h"

@interface WeatherViewController ()
{
    __weak IBOutlet UITableView *tbvWeather;
    __weak IBOutlet UILabel *lbName;
    __weak IBOutlet UILabel *lbCity;
    __weak IBOutlet UILabel *lbCurrentDC;
    NSArray* idImageDic;
    NSArray* urlImageDic;
    NSMutableDictionary *dicImage;
}
@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    lbCity.text = nil;
    //clouds = [[NSMutableArray alloc] init];
    //[self queryGooglePlaces];
    idImageDic = @[@"01d" ,
                   @"02d" ,
                   @"03d" ,
                   @"04d" ,
                   @"09d" ,
                   @"10d" ,
                   @"11d" ,
                   @"13d" ,
                   @"50d" ,
                   @"01n" ,
                   @"02n" ,
                   @"03n" ,
                   @"04n" ,
                   @"09n" ,
                   @"10n" ,
                   @"11n" ,
                   @"13n" ,
                   @"50n" ,];
    urlImageDic =@[@"http://openweathermap.org/img/w/01d.png",
                   @"http://openweathermap.org/img/w/02d.png",
                   @"http://openweathermap.org/img/w/03d.png",
                   @"http://openweathermap.org/img/w/04d.png",
                   @"http://openweathermap.org/img/w/09d.png",
                   @"http://openweathermap.org/img/w/10d.png",
                   @"http://openweathermap.org/img/w/11d.png",
                   @"http://openweathermap.org/img/w/13d.png",
                   @"http://openweathermap.org/img/w/50d.png",
                   @"http://openweathermap.org/img/w/01n.png",
                   @"http://openweathermap.org/img/w/02n.png",
                   @"http://openweathermap.org/img/w/03n.png",
                   @"http://openweathermap.org/img/w/04n.png",
                   @"http://openweathermap.org/img/w/09n.png",
                   @"http://openweathermap.org/img/w/10n.png",
                   @"http://openweathermap.org/img/w/11n.png",
                   @"http://openweathermap.org/img/w/13n.png",
                   @"http://openweathermap.org/img/w/50n.png",];
    dicImage = [[NSMutableDictionary alloc] init];
    self.navigationItem.title = @"Weather";
    [tbvWeather registerNib:[UINib nibWithNibName:@"WeatherTableViewCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeatherTableViewCell *cell = [tbvWeather dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    //    if ([clouds objectAtIndex:indexPath.row]!=nil) {
    //        NSString * timeStampString = [[clouds objectAtIndex:indexPath.row] objectForKey:@"dt"];
    //        NSTimeInterval _interval=[timeStampString doubleValue];
    //        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    //        NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
    //        [weekday setDateFormat: @"EEEE"];
    //        cell.lbDay.text = [weekday stringFromDate:date];
    //        cell.lbCmin.text = [[[clouds objectAtIndex:indexPath.row] objectForKey:@"temp"] objectForKey:@"min"];
    //        cell.lbCmax.text = [[[clouds objectAtIndex:indexPath.row] objectForKey:@"temp"] objectForKey:@"max"];
    //    } else{
    cell.lbDay.text = nil;
    cell.lbCmin.text = nil;
    cell.lbCmax.text = nil;
    cell.ivIcon.image = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//run background
        NSString *url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=Paris&appid=2de143494c0b295cca9337e1e96b00e0&units=metric"];
        NSURL *googleRequestURL=[NSURL URLWithString:url];
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        NSArray *list = [json objectForKey:@"list"];
//        NSArray *weather = [json objectForKey:@"weather"];
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[urlImageDic objectAtIndex:indexPath.row]]]];//down image
        [dicImage setObject:img forKey:[idImageDic objectAtIndex:indexPath.row]];//set image for k
        dispatch_async(dispatch_get_main_queue(), ^{//main
            NSString * timeStampString = [[list objectAtIndex:indexPath.row] objectForKey:@"dt"];
            NSTimeInterval _interval=[timeStampString doubleValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
            NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
            [weekday setDateFormat: @"EEEE"];
            cell.lbDay.text = [weekday stringFromDate:date];
            //NSLog(@"%@", list);
            NSString * id = [[[[list objectAtIndex:indexPath.row] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"icon"];
            //NSLog(@"%@",weather);
            int i = [[[[list objectAtIndex:indexPath.row] objectForKey:@"temp"] objectForKey:@"min"] intValue];
            int j = [[[[list objectAtIndex:indexPath.row] objectForKey:@"temp"] objectForKey:@"max"] intValue];
            cell.lbCmin.text = @(i).stringValue;
            cell.lbCmax.text = @(j).stringValue;

            cell.ivIcon.image = [dicImage objectForKey:id];
            if (lbCity.text == nil) {
                if ([[weekday stringFromDate:date] isEqualToString: [weekday stringFromDate:[NSDate date]]]) {
                    lbCity.text =[weekday stringFromDate:date];
                    lbName.text = @"Paris";
                    int k = [[[[list objectAtIndex:indexPath.row] objectForKey:@"temp"] objectForKey:@"day"] intValue];
                    lbCurrentDC.text = @(k).stringValue;
                }
            }
        });
    });
    //}
    return cell;
}
//-(void) queryGooglePlaces
//{
//    NSString *url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=DaNang&appid=2de143494c0b295cca9337e1e96b00e0&units=metric"];
//    NSURL *googleRequestURL=[NSURL URLWithString:url];
//
//    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
////        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
////    });
//    [self fetchedData:data];
//}
//- (void)fetchedData:(NSData *)responseData {
//    //parse out the json data
//    NSError* error;
//    NSDictionary* json = [NSJSONSerialization
//                          JSONObjectWithData:responseData
//                          options:kNilOptions
//                          error:&error];
//    clouds = [json objectForKey:@"list"];
//}
@end
