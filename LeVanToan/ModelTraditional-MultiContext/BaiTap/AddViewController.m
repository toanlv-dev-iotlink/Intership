//
//  AddViewController.m
//  BaiTap
//
//  Created by Z on 12/8/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "AddViewController.h"
#import "CarDAO.h"

@interface AddViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate>
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


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    self.avatar.image = image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
