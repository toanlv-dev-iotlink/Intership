//
//  RootViewController.h
//  Asn1
//
//  Created by Z on 12/16/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface RootViewController : UIViewController
@property (strong, nonatomic) NSString *region;
@property (nonatomic) CLLocationCoordinate2D coor;
@end
