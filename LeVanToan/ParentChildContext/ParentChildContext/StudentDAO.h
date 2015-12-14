//
//  StudentDAO.h
//  ParentChildContext
//
//  Created by Z on 12/14/15.
//  Copyright (c) 2015 Z. All rights reserved.
//
#import "Student.h"
#import <Foundation/Foundation.h>
#import "CoreDataManager.h"
@interface StudentDAO : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *temporaryContext;
-(void)addStudent:(NSString *)name mssv:(NSString *)mssv;
-(void)deleteStudent: (Student *)student;
-(NSFetchedResultsController *)fetchAllStudent;
-(void)childSaveContext;
+ (StudentDAO *)shared;
@end
