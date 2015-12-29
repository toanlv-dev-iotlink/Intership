//
//  ShowEarthQuakeViewController.m
//  Assignment56
//
//  Created by HTK-Hoa on 12/28/15.
//  Copyright (c) 2015 HTK-Hoa. All rights reserved.
//

#import "ShowEarthQuakeViewController.h"
#import "WebTop100ChartViewController.h"

@interface ShowEarthQuakeViewController ()

@end

@implementation ShowEarthQuakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
- (IBAction)actionWeb:(id)sender {
    [self performSegueWithIdentifier:@"web" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"web"]) {
        WebTop100ChartViewController *web = segue.destinationViewController;
        web.url = [_dicQuake objectForKey:@"url"];
    }
}
@end
