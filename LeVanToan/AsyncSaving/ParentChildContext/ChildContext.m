//
//  ChildContext.m
//  ParentChildContext
//
//  Created by Z on 12/14/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChildContext.h"
#import "Student.h"
@implementation ChildContext
- (id)init
{
    self = [super initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    if(self != nil)
    {
        self.parentContext = [[CoreDataManager shared] managedObjectContext];
    }
    return self;
}
-(void)addStudent:(NSString *)name mssv:(NSString *)mssv{
    Student *student = (Student *)[NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self];
    student.name = name;
    student.mssv = mssv;
};
-(void)saveContext{
    NSManagedObjectContext *managedObjectContext = self;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
@end
