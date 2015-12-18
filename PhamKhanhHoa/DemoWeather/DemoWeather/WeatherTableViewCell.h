//
//  WeatherTableViewCell.h
//  DemoWeather
//
//  Created by MrHoa on 12/17/15.
//  Copyright (c) 2015 MrHoa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherTableViewCell : UITableViewCell
@property (weak,nonatomic) IBOutlet UILabel *lbDay;
@property (weak,nonatomic) IBOutlet UILabel *lbCmax;
@property (weak,nonatomic) IBOutlet UILabel *lbCmin;
@property (weak,nonatomic) IBOutlet UIImageView *ivIcon;

@end
