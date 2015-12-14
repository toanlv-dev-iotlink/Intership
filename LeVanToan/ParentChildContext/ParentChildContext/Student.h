//
//  Student.h
//  ParentChildContext
//
//  Created by Z on 12/14/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Student : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * mssv;

@end
