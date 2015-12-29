//
//  WebViewController.m
//  Asn5vs6
//
//  Created by Z on 12/28/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
