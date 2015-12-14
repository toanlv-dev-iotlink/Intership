//
//  CoreDataManager.h
//  ParentChildContext
//
//  Created by Z on 12/14/15.
//  Copyright (c) 2015 Z. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+(id) shared;

@end