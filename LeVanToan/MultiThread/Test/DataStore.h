//
//  DataStore.h
//  Test
//
//  Created by Z on 12/15/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DataStore:NSObject
+(id)shared;
@property(nonatomic, strong) NSMutableDictionary *imageDict;
-(NSMutableDictionary *)myDict;
@end