//
//  RootTableViewCell.h
//  HoaBT1
//
//  Created by MrHoa on 12/7/15.
//  Copyright (c) 2015 MrHoa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTableViewCell : UITableViewCell
@property (weak,nonatomic) IBOutlet UILabel *lbName;
@property (weak,nonatomic) IBOutlet UILabel *lbNumber;
@property (weak,nonatomic) IBOutlet UILabel *lbDate;
@property (weak,nonatomic) IBOutlet UIImageView *imPhoto;
@property (nonatomic) NSString *s;
@end
