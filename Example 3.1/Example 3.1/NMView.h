//
//  NMView.h
//  Example 3.1
//
//  Created by Linh NGUYEN on 11/19/13.
//  Copyright (c) 2013 Nikmesoft Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMView : UIView

- (id)initWithXibName:(NSString*)xibName;
- (void)initVariables;
- (void)showInView:(UIView *)view;
- (void)hide;

@end
