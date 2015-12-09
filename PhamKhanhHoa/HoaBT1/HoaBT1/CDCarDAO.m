//
//  CDCarDAO.m
//  HoaBT1
//
//  Created by MrHoa on 12/7/15.
//  Copyright (c) 2015 MrHoa. All rights reserved.
//

#import "CDCarDAO.h"
#import "CDCar.h"

@interface CDCarDAO ()
{
    
}

@end
@implementation CDCarDAO
+ (id)sharedData {
    static CDCarDAO *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(NSFetchedResultsController *)loadAllCarsController{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: @"CDCar"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"model" ascending:true]];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext: [[CarData sharedData] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
}

-(void)addCar:(NSString *)model number:(NSString *)number createDate:(NSDate *)createDate numberOfSheat:(NSString *)numberOfSheat fuel:(NSString *)fuel maxSpeed:(NSString *)maxSpeed carImage:(NSData *)carImage{
    CDCar *newCar = [NSEntityDescription insertNewObjectForEntityForName:@"CDCar" inManagedObjectContext:[[CarData sharedData] managedObjectContext]];
    newCar.number = number;
    newCar.model = model;
    newCar.createdDate = createDate;
    newCar.numberOfSheat = numberOfSheat;
    newCar.fuel = fuel;
    newCar.maxSpeed = maxSpeed;
    newCar.carImage = carImage;
    [[CarData sharedData] saveContext];
        
}
-(void)deleteCar:(CDCar *)car
{
    [[[CarData sharedData] managedObjectContext] deleteObject:car];
    [[CarData sharedData] saveContext];
}

@end