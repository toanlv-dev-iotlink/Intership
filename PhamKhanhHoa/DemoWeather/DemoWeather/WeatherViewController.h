//
//  WeatherViewController.h
//  DemoWeather
//
//  Created by MrHoa on 12/17/15.
//  Copyright (c) 2015 MrHoa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherTableViewCell.h"

@interface WeatherViewController : UIViewController
@property(nonatomic, strong) NSString *loc;
@property double lat;
@property double lon;
@end
