//
//  DeFeatViewController.m
//  demo
//
//  Created by HTK-Hoa on 12/22/15.
//  Copyright (c) 2015 HTK-Hoa. All rights reserved.
//

#import "DeFeatViewController.h"

@interface DeFeatViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbScore;


@end

@implementation DeFeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _lbScore.text = @(_score).stringValue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
