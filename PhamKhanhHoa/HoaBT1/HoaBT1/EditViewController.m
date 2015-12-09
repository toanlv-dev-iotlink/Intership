//
//  EditViewController.m
//  HoaBT1
//
//  Created by MrHoa on 12/8/15.
//  Copyright (c) 2015 MrHoa. All rights reserved.
//

#import "EditViewController.h"
#import "CDCarDAO.h"

@interface EditViewController ()<NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate> {
    __weak IBOutlet UITextField *tfModel;
    __weak IBOutlet UITextField *tfNumber;
    __weak IBOutlet UILabel *lbDate;
    __weak IBOutlet UITextField *tfNbOfSeat;
    __weak IBOutlet UITextField *tfFuel;
    __weak IBOutlet UITextField *tfMaxspeed;
    __weak IBOutlet UIDatePicker *dbCreateDate;
    __weak IBOutlet UIImageView *ivChangeImage;
}
@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //navigation
    self.navigationItem.title = @"Edit Car";
    UIBarButtonItem *doneBT = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];
    self.navigationItem.rightBarButtonItem = doneBT;
    //Data -> GUI
    tfModel.text = self.editModel;
    tfNumber.text = self.editNumber;
    tfNbOfSeat.text = self.editNumberOfSheat;
    tfFuel.text = self.editFuel;
    tfMaxspeed.text = self.editMaxSpeed;
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"dd/MM/yyyy"];
    NSString *dateS = [dateformate stringFromDate:self.editCreatedDate];
    lbDate.text = dateS;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)actionDone:(id)sender{
    [[CDCarDAO sharedData] deleteCar:_oldCar];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [dateFormat dateFromString:lbDate.text];
    NSData *data = UIImageJPEGRepresentation(ivChangeImage.image, 0.8);
    [[CDCarDAO sharedData] addCar:tfModel.text number:tfNumber.text createDate:date numberOfSheat:tfNbOfSeat.text fuel:tfFuel.text maxSpeed:tfMaxspeed.text carImage:data];
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (IBAction)pickerAction:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *formatedDate = [dateFormatter stringFromDate: dbCreateDate.date];
    lbDate.text =formatedDate;
}

- (IBAction)changeAvatar:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Change Avatar"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Take a Photo"
                                  otherButtonTitles:@"Choose from gallery", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
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
    } else if(buttonIndex == 1)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

#pragma mark -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    ivChangeImage.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
