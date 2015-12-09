//
//  CarDAO.m
//  BaiTap
//
//  Created by Z on 12/8/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarDAO.h"
#import "CoreDataManager.h"

@implementation CarDAO
+ (id)shared{
    static CarDAO *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}
-(void) addCar:(NSString *)model carNumber:(NSString *)number fuelCapaticy:(NSString*)capaticy maxSpeed:(NSString*)speed numberOfSeats:(NSString*)seats createDay:(NSDate*)date avatar:(NSData*)avatar{
    Car *car = (Car *)[NSEntityDescription insertNewObjectForEntityForName:@"Car" inManagedObjectContext:[[CoreDataManager shared] managedObjectContext]];
    car.model = model;
    car.carNumber = number;
    car.createDate = date;
    car.fuelCapacity = capaticy;
    car.maxSpeed = speed;
    car.numberOfSeats = seats;
    car.avatar = avatar;
    [CoreDataManager.shared saveContext];
}
-(void) deleteCar:(Car *) car{
    [[[CoreDataManager shared] managedObjectContext] deleteObject:car];
    [[CoreDataManager shared] saveContext];
}
-(NSFetchedResultsController *) fetchAllCar{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Car"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"model" ascending:true]];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[[CoreDataManager shared] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
}

@end