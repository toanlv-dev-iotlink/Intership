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
    WeatherViewController *wView = [[WeatherViewController alloc] init];
    wView.loc = tfLocality.text;
    wView.lat = [tfLat.text doubleValue];
    wView.lon = [tfLong.text doubleValue];
    [self.navigationController pushViewController:wView animated:true];
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
                [mymapView removeAnnotations:[mymapView annotations]];
                MKPointAnnotation *poinAn = [[MKPointAnnotation alloc] init];
                poinAn.title = [info objectForKey:@"long_name"];
                poinAn.coordinate = tapPoint;
                [mymapView addAnnotation:poinAn];
                
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
@end
