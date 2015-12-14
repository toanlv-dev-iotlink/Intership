//
//  RootViewController.m
//  ParentChildContext
//
//  Created by Z on 12/14/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "RootViewController.h"
#import "StudentDAO.h"
#import "RootTableViewCell.h"

@interface RootViewController () <UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Strudent list";
    [self.rootTBV registerNib:[UINib nibWithNibName:@"RootTableViewCell" bundle:nil] forCellReuseIdentifier:@"RootTableViewCell"];
    [[CoreDataManager shared] managedObjectContext];
    [self performSelectorInBackground:@selector(loaddata1) withObject:nil];
    [self performSelectorInBackground:@selector(loaddata2) withObject:nil];
    [self fetchResultsController];
    NSError *error = nil;
    self.fetchedResultsController.delegate = self;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark FETCH ALL STUDENT
-(NSFetchedResultsController *)fetchResultsController{
    if(_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }

    _fetchedResultsController = [[StudentDAO shared] fetchAllStudent];
    
    return _fetchedResultsController;
}
#pragma mark TABLE VIEW DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RootTableViewCell *cell = (RootTableViewCell *)[_rootTBV dequeueReusableCellWithIdentifier:@"RootTableViewCell" forIndexPath:indexPath];
    Student *student = (Student *)[self.fetchResultsController objectAtIndexPath:indexPath];
    cell.nameLB.text = student.name;
    cell.mssvLB.text = student.mssv;
    return cell;
}
#pragma mark fetchcontrollerDelegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [_rootTBV beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = _rootTBV;
    
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
    [_rootTBV endUpdates];
}
-(void)loaddata1{
    
    
    [[[StudentDAO shared] temporaryContext] performBlock:^{
        NSString *name;
        NSString *mssv = @"mssv";
        for (int i = 1; i <=10000; i++) {
            name = @(i).stringValue;
            Student *student = (Student *)[NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:[[StudentDAO shared] temporaryContext]];
            student.name = name;
            student.mssv = mssv;
            
            [[StudentDAO shared] childSaveContext];
            [[[CoreDataManager shared] managedObjectContext] performBlock:^{
                [[CoreDataManager shared] saveContext];
                
            }];
            NSLog(@"---------1");
            
        }
        }];
}
-(void)loaddata2{
    NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = [[CoreDataManager shared] managedObjectContext];
    
    [temporaryContext performBlock:^{
        NSString *name=@"gjhgg";
        NSString *mssv = @"mssv";
        for (int i = 1; i <=10000; i++) {
            mssv = @(i).stringValue;
            Student *student = (Student *)[NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:temporaryContext];
            student.name = name;
            student.mssv = mssv;
            NSError *error = nil;
            [temporaryContext save:&error];
            [[[CoreDataManager shared] managedObjectContext] performBlock:^{
                [[CoreDataManager shared] saveContext];
                
            }];
            NSLog(@"_______2");
            
        }
    }];
}

@end
