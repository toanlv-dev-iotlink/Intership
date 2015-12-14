//
//  CarDAO.h
//  HoaBT2
//
//  Created by MrHoa on 12/13/15.
//  Copyright (c) 2015 MrHoa. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "CoreData.h"

@interface CarDAO : NSObject

- (void)addCar:(NSString *)stt name:(NSString *)name;
- (void)deleteAllCar;
- (NSFetchedResultsController*)loadAllCarsController;
+ (id)shared;

@end
