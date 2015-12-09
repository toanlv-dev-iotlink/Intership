//
//  AddViewController.m
//  BaiTap
//
//  Created by Z on 12/8/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "AddViewController.h"
#import "CarDAO.h"

@interface AddViewController ()
@property(weak, nonatomic) IBOutlet UITextField *model;
@property(weak, nonatomic) IBOutlet UITextField *carNumber;
@property(weak, nonatomic) IBOutlet UIImageView *avatar;
@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Add Car";
    
    // init barbuttonItems
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionDone:(id)sender
{
    
    NSDate* date = NSDate.date;
    NSData* dtAvatar = UIImageJPEGRepresentation(self.avatar.image, 1.0);
    [[CarDAO shared] addCar:self.model.text carNumber:self.carNumber.text fuelCapaticy:nil maxSpeed:nil numberOfSeats:nil createDay:date avatar:dtAvatar];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
