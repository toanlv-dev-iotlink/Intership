//
//  DataStore.m
//  Test
//
//  Created by Z on 12/15/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStore.h"
@implementation DataStore
+(id)shared{
    static DataStore *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        shared = [[self alloc] init];
    });
    return shared;
}
-(NSMutableDictionary *)myDict{
    if(!_imageDict){
        _imageDict = [[NSMutableDictionary alloc] init];
    }
    return _imageDict;
}
@end