//
//  CarDAO.m
//  HoaBT2
//
//  Created by MrHoa on 12/13/15.
//  Copyright (c) 2015 MrHoa. All rights reserved.
//
#import "CDCar.h"
#import "CarDAO.h"

@interface CarDAO ()

@end

@implementation CarDAO : NSObject

+ (id)shared{
    static CarDAO *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

-(NSFetchedResultsController *)loadAllCarsController{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: @"CDCar"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"stt" ascending:true]];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext: [[CoreData shared] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
}

-(void)addCar:(NSString *)stt name:(NSString *)name{
    CDCar *newCar = [NSEntityDescription insertNewObjectForEntityForName:@"CDCar" inManagedObjectContext:[[CoreData shared] managedObjectContext]];
    newCar.stt = stt;
    newCar.name = name;
    [[CoreData shared] saveContext];
    
}
-(void)deleteAllCar{
    NSArray *mangCar = [[self loadAllCarsController] fetchedObjects];
    for (CDCar *car in mangCar) {
        [[[CoreData shared] managedObjectContext] deleteObject:car];
    }

}

@end
