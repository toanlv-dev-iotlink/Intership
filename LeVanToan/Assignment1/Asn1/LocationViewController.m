//
//  LocationViewController.m
//  Asn1
//
//  Created by Z on 12/16/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "LocationViewController.h"
#import <MapKit/MapKit.h>
#import "RootViewController.h"

@interface LocationViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UITextField *regionTf;
@property (weak, nonatomic) IBOutlet UITextField *XLocTf;
@property (weak, nonatomic) IBOutlet UITextField *YLocTf;
@property (nonatomic) CLLocationCoordinate2D coor;
@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foundTap:)];
    //tapRecognizer.numberOfTapsRequired = 1;
    //tapRecognizer.numberOfTouchesRequired = 1;
    [_map addGestureRecognizer:tapRecognizer];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)foundTap:(UITapGestureRecognizer *)recognizer {
    
    
    CGPoint point = [recognizer locationInView:_map];
    CLLocationCoordinate2D tapPoint = [_map convertPoint:point toCoordinateFromView:_map];
    _coor = tapPoint;
    _XLocTf.text = @(point.x).stringValue;
    _YLocTf.text = @(point.y).stringValue;
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false",tapPoint.latitude, tapPoint.longitude];
    NSError* error;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    
    NSData *data = [locationString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *list = [json objectForKey:@"results"];
    if (!(list.count>=3)) {
        _regionTf.text = @"";
        return;
    }
    NSDictionary *dic = [list objectAtIndex:2];
    NSArray *array = [dic objectForKey:@"address_components"];
    NSDictionary *info;
    if (array.count >= 2) {
        info = [array objectAtIndex:1];
        if ([info objectForKey:@"long_name"]) {
            NSString *region = [info objectForKey:@"long_name"];
            _regionTf.text = region;
        }
        else{
            _regionTf.text = @"";
            return;
        }
    }
    else{
        _regionTf.text = @"";
        return;
    }
    
}
-(IBAction)next:(id)sender{
    RootViewController *new = [[RootViewController alloc] init];
    new.coor = _coor;
    new.region = _regionTf.text;
    [self.navigationController pushViewController:new animated:true];
}
- (IBAction)zoomIn:(id)sender {
    MKCoordinateSpan span;
    span.latitudeDelta = _map.region.span.latitudeDelta * 2;
    span.longitudeDelta = _map.region.span.latitudeDelta * 2;
    MKCoordinateRegion region;
    region.span = span;
    region.center = _map.region.center;
    
    [_map setRegion:region animated:YES];
}
- (IBAction)zoomOut:(id)sender {
    MKCoordinateSpan span;
    span.latitudeDelta = _map.region.span.latitudeDelta / 2;
    span.longitudeDelta = _map.region.span.latitudeDelta / 2;
    MKCoordinateRegion region;
    region.span = span;
    region.center = _map.region.center;
    
    [_map setRegion:region animated:YES];
}
@end
