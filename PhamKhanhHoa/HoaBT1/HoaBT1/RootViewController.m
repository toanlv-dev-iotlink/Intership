//
//  RootViewController.m
//  HoaBT1
//
//  Created by MrHoa on 12/7/15.
//  Copyright (c) 2015 MrHoa. All rights reserved.
//

#import "RootViewController.h"
#import "RootTableViewCell.h"
#import "AddViewController.h"
#import "EditViewController.h"


@interface RootViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
{
    
    __weak IBOutlet UITableView *carTBV;
}
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end


@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Car Details";
    UIBarButtonItem *addBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAdd:)];
    self.navigationItem.leftBarButtonItem = addBt;
    UIBarButtonItem *editBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionEdit:)];
    self.navigationItem.rightBarButtonItem = editBt;
    [carTBV registerNib:[UINib nibWithNibName:@"RootTableViewCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
    self.fetchedResultsController.delegate = self;
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(NSFetchedResultsController *)fetchedResultsController {
    if(_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    _fetchedResultsController = [[CDCarDAO sharedData] loadAllCarsController];
    return _fetchedResultsController;
}

-(IBAction)actionAdd:(id)sender {
    AddViewController *addVC = [[AddViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}

-(IBAction)actionEdit:(id)sender {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedResultsController.fetchedObjects.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RootTableViewCell *cell = [carTBV dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    CDCar *car = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.lbName.text = car.model;
    cell.lbNumber.text = car.number;
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"dd/MM/yyyy"];
    NSString *dateS = [dateformate stringFromDate:car.createdDate];
    cell.lbDate.text = dateS;
    cell.imPhoto.image = [UIImage imageWithData:car.carImage];
    cell.s = [NSString stringWithFormat:@"Name: %@ \nNumber: %@ \nDateCreate: %@", car.model, car.number, dateS];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CDCar *editCar = [self.fetchedResultsController objectAtIndexPath:indexPath];
    EditViewController * editVC = [[EditViewController alloc] init];
    editVC.editModel = editCar.model;
    editVC.editFuel = editCar.fuel;
    editVC.editMaxSpeed = editCar.maxSpeed;
    editVC.editNumberOfSheat = editCar.numberOfSheat;
    editVC.editNumber = editCar.number;
    editVC.editCreatedDate = editCar.createdDate;
    editVC.idPath = indexPath;
    editVC.oldCar = editCar;
    [self.navigationController pushViewController:editVC animated:true];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CDCar *delCar = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [[CDCarDAO sharedData] deleteCar:delCar];
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [carTBV beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [carTBV insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [carTBV deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [carTBV reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        case NSFetchedResultsChangeMove:
            [carTBV deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            [carTBV insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [carTBV endUpdates];
}

@end
