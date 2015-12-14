//
//  CoreData.h
//  HoaBT2
//
//  Created by MrHoa on 12/13/15.
//  Copyright (c) 2015 MrHoa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreData : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *tmpManagedOC;
@property (readonly, strong, nonatomic) NSManagedObjectContext *tmpManagedOC1;
@property (readonly, strong, nonatomic) NSManagedObjectContext *tmpManagedOC2;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (void)tmpSaveContext;
- (void)tmpSaveContext1;
- (void)tmpSaveContext2;
- (NSURL *)applicationDocumentsDirectory;
+ (id)shared;

@end