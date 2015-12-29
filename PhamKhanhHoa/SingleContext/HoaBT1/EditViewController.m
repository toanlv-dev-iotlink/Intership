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
    __weak IBOutlet UIButton *btChooseLibrary;
    __weak IBOutlet UIButton *btTakePhoto;
    UIGestureRecognizer *tapper;
}
@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //hide keyboarb
    tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];

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
    ivChangeImage.image = [UIImage imageWithData:self.editCarImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
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

-(IBAction) getPhoto:(id) sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if((UIButton *) sender == btChooseLibrary) {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    } else {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == YES) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    ivChangeImage.image = chosenImage;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
