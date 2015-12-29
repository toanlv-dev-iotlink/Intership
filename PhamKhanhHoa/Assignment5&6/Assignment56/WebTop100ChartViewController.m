//
//  WebTop100ChartViewController.m
//  Assignment56
//
//  Created by HTK-Hoa on 12/27/15.
//  Copyright (c) 2015 HTK-Hoa. All rights reserved.
//

#import "WebTop100ChartViewController.h"

@interface WebTop100ChartViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebTop100ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)actionBack:(id)sender {
    [self.webView goBack];
}
@end
