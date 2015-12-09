//
//  RootTableViewCell.m
//  HoaBT1
//
//  Created by MrHoa on 12/7/15.
//  Copyright (c) 2015 MrHoa. All rights reserved.
//

#import "RootTableViewCell.h"

@interface RootTableViewCell () {
}

@end

@implementation RootTableViewCell


- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) actionDetail:(NSString *)s{
    
}
- (IBAction)showAlertView:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.title = @"Car Details";
    alert.message = self.s;
    [alert addButtonWithTitle:@"OK"];
    [alert show];
}
@end
