//
//  HomeViewController.m
//  DemoWeather
//
//  Created by MrHoa on 12/17/15.
//  Copyright (c) 2015 MrHoa. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()<MKMapViewDelegate>
{
    __weak IBOutlet MKMapView *mymapView;
    CLLocationManager *locatioManager;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"HomePage";
    [mymapView setShowsUserLocation:YES];
    mymapView.showsBuildings = YES;
    [self queryGooglePlaces];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) queryGooglePlaces
{
    NSString *url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=DaNang&appid=2de143494c0b295cca9337e1e96b00e0&units=metric"];
    //Formulate the string as URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    // Retrieve the results of the URL.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}
- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
//    NSArray* sys = [json objectForKey:@"sys"];
//    NSArray* weather = [json objectForKey:@"weather"];
//    NSArray* rain = [json objectForKey:@"rain"];
    NSArray* clouds = [json objectForKey:@"list"];
    NSDictionary *day1 = [clouds objectAtIndex:0];
    NSString * timeStampString = [day1 objectForKey:@"dt"];
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
    [weekday setDateFormat: @"EEEE"];

    //[day1 objectForKey:@"dt"];
//    NSArray* wind = [json objectForKey:@"wind"];
    //Write out the data to the console.
//    NSString * timeStampString = @"1450409400";
//    NSTimeInterval _interval=[timeStampString doubleValue];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
//    NSLog(@"%@", date);
    NSString *x = [weekday stringFromDate:date];
    NSLog(@"Google Data Sys: %@", [[day1 objectForKey:@"temp"] objectForKey:@"min"]);
    NSLog(@"Google Data Sys: %@", x);
//    NSLog(@"Google Data Weather: %@", weather);
//    NSLog(@"Google Data Rain: %@", rain);
//    NSLog(@"Google Data Clounds: %@", clouds);
//    NSLog(@"Google Data Wind: %@", wind);
}
- (IBAction)actionDropin:(NSObject*)sender{
    WeatherViewController *wView = [[WeatherViewController alloc] init];
    [self.navigationController pushViewController:wView animated:true];
}

    


@end
