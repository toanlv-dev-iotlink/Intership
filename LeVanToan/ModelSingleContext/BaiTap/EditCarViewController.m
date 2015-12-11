//
//  EditCarViewController.m
//  BaiTap
//
//  Created by Z on 12/9/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "EditCarViewController.h"
#import "CarDAO.h"

@interface EditCarViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate>{
    
    __weak IBOutlet UITextField* tfModel;
    __weak IBOutlet UITextField* tfCarNumber;
    __weak IBOutlet UITextField* tfFuelCapaticy;
    __weak IBOutlet UITextField* tfMaxSpeed;
    __weak IBOutlet UITextField* tfNumberOfSeats;
    __weak IBOutlet UIDatePicker* dpCreateDate;
    __weak IBOutlet UIImageView* ivAvatar;

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
    UIImage *image = [[UIImage alloc] initWithData:self.myCar.avatar];
    ivAvatar.image = image;
    //tao button save
    UIBarButtonItem* btSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(actionSave:)];
    self.navigationItem.rightBarButtonItem = btSave;
}
// IBAction
-(IBAction)actionSave:(id)sender{
    [[CarDAO shared] deleteCar:_myCar];
    NSData* dtAvatar = UIImageJPEGRepresentation(ivAvatar.image, 1.0);
    [[CarDAO shared] addCar:tfModel.text carNumber:tfCarNumber.text fuelCapaticy:tfFuelCapaticy.text maxSpeed:tfMaxSpeed.text numberOfSeats:tfNumberOfSeats.text createDay:dpCreateDate.date avatar:dtAvatar];
    [self.navigationController popViewControllerAnimated:true];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(IBAction)atChangeAvatar:(id)sender{
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Sharing option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"choose picture form your device",
                            @"take a photo",
                            @"dowload from internet",
                            nil];
    [popup showInView:self.view];
}

//action sheet selegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        UIImagePickerController* ipc = [[UIImagePickerController alloc] init];
        ipc.delegate = self;
        ipc.allowsEditing = YES;
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:ipc animated:YES completion:NULL];
    }
    else if (buttonIndex == 1){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera] == YES)
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    ivAvatar.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    ivAvatar.image = image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
@end
