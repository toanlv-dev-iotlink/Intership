//
//  GameOverViewController.m
//  Asn2
//
//  Created by Z on 12/22/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "GameOverViewController.h"

@interface GameOverViewController ()


@end

@implementation GameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scoreLb.text = _score;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
