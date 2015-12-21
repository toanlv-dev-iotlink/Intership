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
    __weak IBOutlet UIImageView *imageCurrent;
    NSArray* weekday;
    NSMutableDictionary *dicImage;
    NSMutableDictionary *dicList;
    NSDictionary *dicIM;
}
@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    lbCity.text = nil;
    NSLog(@"%@",self.loc);
    dicImage = [[NSMutableDictionary alloc] init];
    dicList = [[NSMutableDictionary alloc] init];
    tbvWeather.tableFooterView = [[UITableView alloc] initWithFrame: CGRectZero];
    weekday = @[@"Monday",@"Tuesday",@"Webnesday",@"Thursday",@"Friday",@"Satturday",@"Sunday"];
    dicIM = @{@"01d":@"http://openweathermap.org/img/w/01d.png",
              @"02d":@"http://openweathermap.org/img/w/02d.png",
              @"03d":@"http://openweathermap.org/img/w/03d.png",
              @"04d":@"http://openweathermap.org/img/w/04d.png",
              @"09d":@"http://openweathermap.org/img/w/09d.png",
              @"10d":@"http://openweathermap.org/img/w/10d.png",
              @"11d":@"http://openweathermap.org/img/w/11d.png",
              @"13d":@"http://openweathermap.org/img/w/13d.png",
              @"50d":@"http://openweathermap.org/img/w/50d.png",
              @"01d":@"http://openweathermap.org/img/w/01n.png",
              @"02d":@"http://openweathermap.org/img/w/02n.png",
              @"03d":@"http://openweathermap.org/img/w/03n.png",
              @"04d":@"http://openweathermap.org/img/w/04n.png",
              @"09d":@"http://openweathermap.org/img/w/09n.png",
              @"010d":@"http://openweathermap.org/img/w/10n.png",
              @"011d":@"http://openweathermap.org/img/w/11n.png",
              @"013d":@"http://openweathermap.org/img/w/13n.png",
              @"050d":@"http://openweathermap.org/img/w/50n.png",};
    self.navigationItem.title = @"Weather";
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"dep.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
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
    cell.lbCmax.text = nil;
    cell.lbCmin.text = nil;
    cell.lbDay.text = nil;
    cell.ivIcon.image = nil;
    if ([dicList objectForKey: [weekday objectAtIndex:indexPath.row]]!=nil) {
        NSArray *list = [dicList objectForKey: [weekday objectAtIndex:indexPath.row]];
        NSString * timeStampString = [[list objectAtIndex:indexPath.row] objectForKey:@"dt"];
        NSTimeInterval _interval=[timeStampString doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        [self loadData:list date:date cell:cell index:indexPath];
        cell.ivIcon.image = [dicImage objectForKey:[weekday objectAtIndex:indexPath.row]];
        
        
    } else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//run background
            NSString *url;
            if ([self.loc  isEqual: @""]) {
                url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&cnt=7&mode=json&appid=2de143494c0b295cca9337e1e96b00e0&units=metric", self.lat,self.lon];
            } else {
                NSString *address= [self.loc stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&mode=json&units=metric&cnt=7&appid=2de143494c0b295cca9337e1e96b00e0", address];
            }
            NSURL *googleRequestURL=[NSURL URLWithString:url];
            NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
            NSError* error;
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&error];
            NSArray *list = [json objectForKey:@"list"];
            [dicList setObject:list forKey:[weekday objectAtIndex:indexPath.row]];
            dispatch_async(dispatch_get_main_queue(), ^{//main
                NSString * timeStampString = [[list objectAtIndex:indexPath.row] objectForKey:@"dt"];
                NSTimeInterval _interval=[timeStampString doubleValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
                [self loadData:[dicList objectForKey: [weekday objectAtIndex:indexPath.row]] date:date cell:cell index:indexPath];
                if ([dicImage objectForKey:[weekday objectAtIndex:indexPath.row]]!=nil) {//check image in dic
                    cell.ivIcon.image = [dicImage objectForKey:[weekday objectAtIndex:indexPath.row]];
                } else{
                    //cach 1: GCD
                    if ([dicImage objectForKey:lbName.text]!=nil) {
                        imageCurrent.image = [dicImage objectForKey:lbName.text];
                    }
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//run background
                        NSString *idimg = [[[[list objectAtIndex:indexPath.row] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"icon"];
                        NSLog(@"%@",idimg);
                        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dicIM objectForKey:idimg]]]];//down image
                        [dicImage setObject:img forKey:[weekday objectAtIndex:indexPath.row]];//set image for key
                        dispatch_async(dispatch_get_main_queue(), ^{//main
                            WeatherTableViewCell * cell = (WeatherTableViewCell *)[tbvWeather cellForRowAtIndexPath:indexPath];
                            cell.ivIcon.image = [dicImage objectForKey:[weekday objectAtIndex:indexPath.row]];
                            imageCurrent.image = [dicImage objectForKey:lbName.text];
                        });
                    });
                }
            });
        });
    }
    return cell;
}

- (NSString *)weekdays:(NSDate *)date {
    NSDateFormatter *wd = [[NSDateFormatter alloc] init];
    [wd setDateFormat: @"EEEE"];
    return [wd stringFromDate:date];
}

- (void)loadData:(NSArray *)list date:(NSDate *)date cell:(WeatherTableViewCell *)cell index:(NSIndexPath *)indexPath{
    cell.lbDay.text = [self weekdays:date];
    int i = [[[[list objectAtIndex:indexPath.row] objectForKey:@"temp"] objectForKey:@"min"] intValue];
    int j = [[[[list objectAtIndex:indexPath.row] objectForKey:@"temp"] objectForKey:@"max"] intValue];
    cell.lbCmin.text = [NSString stringWithFormat:@"%d °C",i];
    cell.lbCmax.text = [NSString stringWithFormat:@"%d °C",j];
    if (lbCity.text == nil) {
        if ([[self weekdays:date] isEqualToString: [self weekdays:[NSDate date]]]) {
            lbCity.text = self.loc;
            lbName.text = [self weekdays:date];
            int k = [[[[list objectAtIndex:indexPath.row] objectForKey:@"temp"] objectForKey:@"day"] intValue];
            lbCurrentDC.text = [NSString stringWithFormat:@"%d °C",k];
            //imageCurrent.image = [dicImage objectForKey:lbName.text];
        }
    }

}
@end
