//
//  ChildContext.h
//  ParentChildContext
//
//  Created by Z on 12/14/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"
@interface ChildContext : NSManagedObjectContext
-(void)saveContext;
-(void)addStudent:(NSString *)name mssv:(NSString *)mssv;
-(void)saveContext;
@end
