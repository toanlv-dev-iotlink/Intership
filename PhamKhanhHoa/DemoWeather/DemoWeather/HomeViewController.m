//
//  HomeViewController.m
//  DemoWeather
//
//  Created by MrHoa on 12/17/15.
//  Copyright (c) 2015 MrHoa. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()<MKMapViewDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate>
{
    __weak IBOutlet MKMapView *mymapView;
    CLLocationManager *locationManager;
    __weak IBOutlet UITextField *tfLat;
    __weak IBOutlet UITextField *tfLong;
    __weak IBOutlet UITextField *tfLocality;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tfLocality.text = nil;
    self.navigationItem.title = @"HomePage";
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    mymapView.showsBuildings = YES;
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(foundTap:)];
    tgr.delegate = self;
    [mymapView addGestureRecognizer:tgr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)actionDropin:(NSObject*)sender{
    //    if ([tfLocality.text  isEqual: @""]) {
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not find the Locality"
    //                                                        message:@"You must choose the correct location."
    //                                                       delegate:nil
    //                                              cancelButtonTitle:@"OK"
    //                                              otherButtonTitles:nil];
    //        [alert show];
    //    } else {
    WeatherViewController *wView = [[WeatherViewController alloc] init];
    wView.loc = tfLocality.text;
    wView.lat = [tfLat.text doubleValue];
    wView.lon = [tfLong.text doubleValue];
    [self.navigationController pushViewController:wView animated:true];
    //    }
}

-(void)foundTap:(UITapGestureRecognizer *)recognizer {
    
    
    CGPoint point = [recognizer locationInView:mymapView];
    CLLocationCoordinate2D tapPoint = [mymapView convertPoint:point toCoordinateFromView:mymapView];
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false",tapPoint.latitude, tapPoint.longitude];
    NSError* error;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    
    NSData *data = [locationString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    tfLat.text = [NSString stringWithFormat:@"%f",tapPoint.latitude];
    tfLong.text = [NSString stringWithFormat:@"%f",tapPoint.longitude];
    if ([[json objectForKey:@"results"] count] >= 3) {
        NSDictionary *dic = [[json objectForKey:@"results"] objectAtIndex:2];
        if ([[dic objectForKey:@"address_components"] count] >= 2) {
            NSDictionary *info = [[dic objectForKey:@"address_components"] objectAtIndex:1];
            if ([info objectForKey:@"long_name"]) {
                NSString *region = [info objectForKey:@"long_name"];
                tfLocality.text = region;

            }else{
                tfLocality.text = @"";
                return;
            }
            
        } else {
            tfLocality.text = @"";
            return;
        }
    }else{
        tfLocality.text = @"";
        return;
    }
}

//- (void)getLocation:(do){
//    CLGeocoder *ceo = [[CLGeocoder alloc]init];
//    CLLocation *loc = [[CLLocation alloc]initWithLatitude:26.93611 longitude:26.93611];
//    
//    [ceo reverseGeocodeLocation: loc completionHandler:
//     ^(NSArray *placemarks, NSError *error) {
//         CLPlacemark *placemark = [placemarks objectAtIndex:0];
//         NSLog(@"placemark %@",placemark);
//         //String to hold address
//         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//         NSLog(@"addressDictionary %@", placemark.addressDictionary);
//         
//         NSLog(@"placemark %@",placemark.region);
//         NSLog(@"placemark %@",placemark.country);  // Give Country Name
//         NSLog(@"placemark %@",placemark.locality); // Extract the city name
//         NSLog(@"location %@",placemark.name);
//         NSLog(@"location %@",placemark.ocean);
//         NSLog(@"location %@",placemark.postalCode);
//         NSLog(@"location %@",placemark.subLocality);
//         
//         NSLog(@"location %@",placemark.location);
//         //Print the location to console
//         NSLog(@"I am currently at %@",locatedAt);
//         
//         
//         
//         
//     }];
//}

- (IBAction)zoomIn:(id)sender {
    MKCoordinateSpan span;
    span.latitudeDelta = mymapView.region.span.latitudeDelta * 2;
    span.longitudeDelta = mymapView.region.span.latitudeDelta * 2;
    MKCoordinateRegion region;
    region.span = span;
    region.center = mymapView.region.center;
    
    [mymapView setRegion:region animated:YES];
}
- (IBAction)zoomOut:(id)sender {
    MKCoordinateSpan span;
    span.latitudeDelta = mymapView.region.span.latitudeDelta / 2;
    span.longitudeDelta = mymapView.region.span.latitudeDelta / 2;
    MKCoordinateRegion region;
    region.span = span;
    region.center = mymapView.region.center;
    
    [mymapView setRegion:region animated:YES];
}

-(void)loadData:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:mymapView];
    CLLocationCoordinate2D tapPoint = [mymapView convertPoint:point toCoordinateFromView:mymapView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//run background
        NSString *url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&cnt=2&mode=json&appid=2de143494c0b295cca9337e1e96b00e0",tapPoint.latitude,tapPoint.longitude];
        NSURL *googleRequestURL=[NSURL URLWithString:url];
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        NSError* error;
        NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        NSArray *list = [json objectForKey:@"list"];
        NSArray *city = [json objectForKey:@"city"];
    });
}
@end
