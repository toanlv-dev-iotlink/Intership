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

+ (CoreDataManager *)shared{
    static CoreDataManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        shared = [[self alloc] init];
    });
    return shared;
}
#pragma mark INIT TEMPORARY CONTEXT
#pragma mark IMPLEMENT FUNCTION

-(NSFetchedResultsController *)fetchAllStudent{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Student"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:true]];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[[CoreDataManager shared] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
};
//-(void)childSaveContext{
//    NSManagedObjectContext *managedObjectContext = self.temporaryContext;
//    if (managedObjectContext != nil) {
//        NSError *error = nil;
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//}
@end