//
//  EditCarViewController.m
//  BaiTap
//
//  Created by Z on 12/9/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "EditCarViewController.h"
#import "CarDAO.h"

@interface EditCarViewController (){
    
__weak IBOutlet UITextField* tfModel;
__weak IBOutlet UITextField* tfCarNumber;
__weak IBOutlet UITextField* tfFuelCapaticy;
__weak IBOutlet UITextField* tfMaxSpeed;
__weak IBOutlet UITextField* tfNumberOfSeats;
__weak IBOutlet UIDatePicker* dpCreateDate;
}

@end

@implementation EditCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Edit car";
    tfModel.text = self.myCar.model;
    tfCarNumber.text = self.myCar.carNumber;
    tfFuelCapaticy.text = self.myCar.fuelCapacity;
    tfMaxSpeed.text = self.myCar.maxSpeed;
    tfNumberOfSeats.text = self.myCar.numberOfSeats;
    dpCreateDate.date = self.myCar.createDate;
    //tao button save
    UIBarButtonItem* btSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(actionSave:)];
    self.navigationItem.rightBarButtonItem = btSave;
}
-(IBAction)actionSave:(id)sender{
    [[CarDAO shared] deleteCar:_myCar];
    [[CarDAO shared] addCar:tfModel.text carNumber:tfCarNumber.text fuelCapaticy:tfFuelCapaticy.text maxSpeed:tfMaxSpeed.text numberOfSeats:tfNumberOfSeats.text createDay:dpCreateDate.date avatar:nil];
    [self.navigationController popViewControllerAnimated:true];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
