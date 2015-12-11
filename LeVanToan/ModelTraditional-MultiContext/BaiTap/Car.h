//
//  Car.h
//  BaiTap
//
//  Created by Z on 12/9/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Car : NSManagedObject

@property (nonatomic, retain) NSString * carNumber;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSString * fuelCapacity;
@property (nonatomic, retain) NSString * maxSpeed;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSString * numberOfSeats;
@property (nonatomic, retain) NSData * avatar;

@end
