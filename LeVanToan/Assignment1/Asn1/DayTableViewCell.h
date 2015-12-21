//
//  DayTableViewCell.h
//  Asn1
//
//  Created by Z on 12/18/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UILabel *DayLb;
@property(weak, nonatomic) IBOutlet UILabel *maxTempLb;
@property(weak, nonatomic) IBOutlet UILabel *minTempLb;
@property(weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property(nonatomic) int row;
-(void)load;
@end
