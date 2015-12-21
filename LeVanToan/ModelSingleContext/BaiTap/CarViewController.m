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
@property(nonatomic, weak) IBOutlet UITableView *carTV;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation CarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSError *error = nil;
    _fetchedResultsController = [CarDAO.shared fetchAllCar];
    _fetchedResultsController.delegate = self;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    [_carTV registerNib:[UINib nibWithNibName:@"CarTableViewCell" bundle:nil] forCellReuseIdentifier:@"CarTableViewCell"];
    self.navigationItem.title = @"Car List";
    
    // init barbuttonItems
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAdd:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    //init fetch
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Core Data

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarTableViewCell *cell = (CarTableViewCell *)[_carTV dequeueReusableCellWithIdentifier:@"CarTableViewCell" forIndexPath:indexPath];
    Car *car = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.model.text = car.model;
    cell.carNumber.text = car.carNumber;
    cell.avatar.image = [[UIImage alloc] initWithData:car.avatar];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Car* car = (Car*)[_fetchedResultsController objectAtIndexPath:indexPath];
    EditCarViewController* newVC = [[EditCarViewController alloc] init];
    newVC.myCar = car;
    newVC.myIndex = indexPath;
    [self.navigationController pushViewController:newVC animated:true];
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Car* car = [_fetchedResultsController objectAtIndexPath:indexPath];
        [[CarDAO shared] deleteCar:car];
    }
}

#pragma mark IBAction
- (IBAction)actionAdd:(id)sender
{
    AddViewController *addVC = [[AddViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [_carTV beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = _carTV;
    
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
    [_carTV endUpdates];
}
@end
