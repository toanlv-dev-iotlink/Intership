//
//  CarDAO.h
//  BaiTap
//
//  Created by Z on 12/8/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "car.h"
#import "CoreDataManager.h"

@interface CarDAO: CoreDataManager
-(void) addCar:(NSString *)model carNumber:(NSString *)number fuelCapaticy:(NSString*)capaticy maxSpeed:(NSString*)speed numberOfSeats:(NSString*)seats createDay:(NSDate*)date avatar:(NSData*)avatar;
-(void) deleteCar:(Car *) car;
-(NSFetchedResultsController *) fetchAllCar;
+(id) shared;
@end
