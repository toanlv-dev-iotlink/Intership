//
//  CDCarDAO.h
//  HoaBT1
//
//  Created by MrHoa on 12/7/15.
//  Copyright (c) 2015 MrHoa. All rights reserved.
//

#import "CarData.h"
@class CDCar;

@interface CDCarDAO : NSObject 

- (void)addCar:(NSString *)model number:(NSString *)number createDate:(NSDate *)createDate numberOfSheat:(NSString *)numberOfSheat fuel:(NSString *)fuel maxSpeed:(NSString *)maxSpeed carImage:(NSData *)carImage;
- (void)deleteCar:(CDCar*) car;
- (NSFetchedResultsController*)loadAllCarsController;
+ (id)sharedData;

@end


