//
//  CDCar.h
//  HoaBT1
//
//  Created by MrHoa on 12/9/15.
//  Copyright (c) 2015 MrHoa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDCar : NSManagedObject

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * fuel;
@property (nonatomic, retain) NSString * maxSpeed;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * numberOfSheat;
@property (nonatomic, retain) NSData * carImage;

@end
