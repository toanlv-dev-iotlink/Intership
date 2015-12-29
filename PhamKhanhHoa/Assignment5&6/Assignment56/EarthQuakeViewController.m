//
//  EarthQuakeViewController.m
//  Assignment56
//
//  Created by HTK-Hoa on 12/28/15.
//  Copyright (c) 2015 HTK-Hoa. All rights reserved.
//

#import "EarthQuakeViewController.h"
#import "ShowEarthQuakeViewController.h"

@interface EarthQuakeViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapEarth;

@end

@interface urlMKPoint : MKPointAnnotation
@property (strong,nonatomic) NSDictionary *dicQuake;
@end
@implementation urlMKPoint
@end


@implementation EarthQuakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mapEarth.showsBuildings = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlString = @"http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/1.0_day.geojson";
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *features = [json objectForKey:@"features"];
            for (NSDictionary *objt in features) {
                NSDictionary *geometry = [objt objectForKey:@"geometry"];
                NSDictionary *properties = [objt objectForKey:@"properties"];
                urlMKPoint *point = [[urlMKPoint alloc] init];
                CLLocationCoordinate2D coord;
                coord.latitude = [[[geometry objectForKey:@"coordinates"] objectAtIndex:1] doubleValue];
                coord.longitude = [[[geometry objectForKey:@"coordinates"] objectAtIndex:0] doubleValue];
                point.coordinate = coord;
                point.title = [NSString stringWithFormat:@"Magnitude %@",[properties objectForKey:@"mag"]];
                point.subtitle = [properties objectForKey:@"place"];
                point.dicQuake = properties;
                [[self mapEarth] addAnnotation:point];
            }
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData{
   
}
- (IBAction)zoomIn:(id)sender {
    MKCoordinateSpan span;
    span.latitudeDelta = _mapEarth.region.span.latitudeDelta * 2;
    span.longitudeDelta = _mapEarth.region.span.latitudeDelta * 2;
    MKCoordinateRegion region;
    region.span = span;
    region.center = _mapEarth.region.center;
    
    [_mapEarth setRegion:region animated:YES];
}
- (IBAction)zoomOut:(id)sender {
    MKCoordinateSpan span;
    span.latitudeDelta = _mapEarth.region.span.latitudeDelta / 2;
    span.longitudeDelta = _mapEarth.region.span.latitudeDelta / 2;
    MKCoordinateRegion region;
    region.span = span;
    region.center = _mapEarth.region.center;
    
    [_mapEarth setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    pinView.animatesDrop = NO;
    pinView.canShowCallout = YES;
    UIButton *rightBt = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pinView.rightCalloutAccessoryView = rightBt;
    return pinView;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    [self performSegueWithIdentifier:@"urlLink" sender:view.annotation];
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    urlMKPoint *point = sender;
    ShowEarthQuakeViewController *show = segue.destinationViewController;
    show.dicQuake = point.dicQuake;
}
@end
