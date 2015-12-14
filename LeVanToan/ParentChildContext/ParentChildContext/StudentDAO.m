//
//  StudentDAO.m
//  ParentChildContext
//
//  Created by Z on 12/14/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudentDAO.h"
#import <CoreData/CoreData.h>
#import "CoreDataManager.h"
@implementation StudentDAO
@synthesize temporaryContext = _temporaryContext;
+ (CoreDataManager *)shared{
    static CoreDataManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        shared = [[self alloc] init];
    });
    return shared;
}
#pragma mark INIT TEMPORARY CONTEXT
-(NSManagedObjectContext *)temporaryContext {
    if (_temporaryContext != nil) {
        return _temporaryContext;
    }
    _temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    _temporaryContext.parentContext = [[CoreDataManager shared] managedObjectContext];
    return _temporaryContext;
}
#pragma mark IMPLEMENT FUNCTION
-(void)addStudent:(NSString *)name mssv:(NSString *)mssv{
    Student *student = (Student *)[NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.temporaryContext];
    student.name = name;
    student.mssv = mssv;
};
-(void)deleteStudent: (Student *)student{
    [self.temporaryContext deleteObject:student];
};
-(NSFetchedResultsController *)fetchAllStudent{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Student"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:true]];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[[CoreDataManager shared] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
};
-(void)childSaveContext{
    NSManagedObjectContext *managedObjectContext = self.temporaryContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
};
@end