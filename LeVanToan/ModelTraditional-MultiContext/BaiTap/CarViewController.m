//
//  CarViewController.m
//  BaiTap
//
//  Created by Z on 12/8/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "CarViewController.h"
#import <CoreData/CoreData.h>
#import "CarDAO.h"
#import "CarTableViewCell.h"
#import "CarTableViewCell.m"
#import "AddViewController.h"
#import "EditCarViewController.h"


@interface CarViewController ()<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
{
    __weak IBOutlet UITableView *carTV;
    
}
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation CarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [carTV registerNib:[UINib nibWithNibName:@"CarTableViewCell" bundle:nil] forCellReuseIdentifier:@"CarTableViewCell"];
    self.navigationItem.title = @"Car List";
    
    // init barbuttonItems
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAdd:)];
    self.navigationItem.rightBarButtonItem = addButton;
    //CLEAR DATA
    
    
    // tao luong background
    NSManagedObjectContext *moc =[[CoreDataManager shared] managedObjectContext];
    dispatch_queue_t _backgroundQueue = dispatch_queue_create("htk", nil);
    dispatch_async(_backgroundQueue, ^{

        
        NSMutableString *model = [NSMutableString stringWithString:@"Model x"];
        NSMutableString *carNumber = [NSMutableString stringWithString:@"Car Number x"];
        NSString *stt;
        for (int i = 1; i <= 10000; i++) {
            stt = @(i).stringValue;
            Car *car = (Car *)[NSEntityDescription insertNewObjectForEntityForName:@"Car" inManagedObjectContext:[[CoreDataManager shared] tmpMoc] ];
            car.model = model;
            car.carNumber = carNumber;
            [[CoreDataManager shared] tmpSaveContext];
            NSLog(@"------>%i",i);
        }
    });
    
    //init fetch
    NSError *error = nil;
    self.fetchedResultsController.delegate = self;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark cac ham chay trong thread


#pragma mark - FETCH RESULT CONTROLLER
- (NSFetchedResultsController*)fetchedResultsController
{
    if(_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    _fetchedResultsController = [CarDAO.shared fetchAllCar];
    
    return _fetchedResultsController;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarTableViewCell *cell = (CarTableViewCell *)[carTV dequeueReusableCellWithIdentifier:@"CarTableViewCell" forIndexPath:indexPath];
    Car *car = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.model.text = car.model;
    cell.carNumber.text = car.carNumber;
    cell.avatar.image = [[UIImage alloc] initWithData:car.avatar];
    return cell;
}

#pragma mark tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Car* car = (Car*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    EditCarViewController* newVC = [[EditCarViewController alloc] init];
    newVC.myCar = car;
    newVC.myIndex = indexPath;
    [self.navigationController pushViewController:newVC animated:true];
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Car* car = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [[CarDAO shared] deleteCar:car];
    }
}

#pragma mark IBAction
- (IBAction)actionAdd:(id)sender
{
    AddViewController *addVC = [[AddViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark fetchcontrollerDelegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [carTV beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = carTV;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [carTV endUpdates];
}

#pragma mark ham xu ly trong background

-(void)importData{
    
}
@end
