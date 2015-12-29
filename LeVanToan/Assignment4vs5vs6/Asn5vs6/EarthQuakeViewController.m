//
//  EarthQuakeViewController.m
//  Asn5vs6
//
//  Created by Z on 12/28/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "EarthQuakeViewController.h"
#import "EarthquakeDetailViewController.h"
#import <MapKit/MapKit.h>
#import "MyPointAnnotation.h"

@interface EarthQuakeViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation EarthQuakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"EarthQuake";
    [self getData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)getData{
    NSString *urlString = @"http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/1.0_day.geojson";
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self load:data];
        });
    });
}
-(void)load:(NSData *)data{
    NSDictionary *objs = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *features = [objs objectForKey:@"features"];
    for (NSDictionary *event in features) {
        NSDictionary *geom = [event objectForKey:@"geometry"];
        NSArray *coords = [geom objectForKey:@"coordinates"];
        NSDictionary *properties = [event objectForKey:@"properties"];
        if (!geom||!coords||!properties) {
            continue;
        }
        MyPointAnnotation *ann = [[MyPointAnnotation alloc] init];
        ann.title = [NSString stringWithFormat:@"magnitude %@",[properties objectForKey:@"mag"]];
        ann.subtitle = [properties objectForKey:@"place"];
        ann.coords = coords;
        ann.properties = properties;
        CLLocationCoordinate2D coord;
        coord.latitude = [[coords objectAtIndex:1] doubleValue];
        coord.longitude = [[coords objectAtIndex:0] doubleValue];
        ann.coordinate = coord;
        [_mapView addAnnotation:ann];
    }
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    pinView.animatesDrop = false;
    pinView.canShowCallout = true;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pinView.rightCalloutAccessoryView = rightButton;
    return pinView;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    [self performSegueWithIdentifier:@"detail" sender:view.annotation];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    EarthquakeDetailViewController *vc = segue.destinationViewController;
    MyPointAnnotation *ann = sender;
    vc.coords = ann.coords;
    vc.properties = ann.properties;
}
- (IBAction)zoomOut:(id)sender {
    MKCoordinateSpan span;
    span.latitudeDelta = _mapView.region.span.latitudeDelta * 2;
    span.longitudeDelta = _mapView.region.span.latitudeDelta * 2;
    MKCoordinateRegion region;
    region.span = span;
    region.center = _mapView.region.center;
    
    [_mapView setRegion:region animated:YES];
}
- (IBAction)zoomIn:(id)sender {
    MKCoordinateSpan span;
    span.latitudeDelta = _mapView.region.span.latitudeDelta / 2;
    span.longitudeDelta = _mapView.region.span.latitudeDelta / 2;
    MKCoordinateRegion region;
    region.span = span;
    region.center = _mapView.region.center;
    
    [_mapView setRegion:region animated:YES];
}

@end
