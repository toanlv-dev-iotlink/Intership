//
//  Contact.m
//  Example 3.1
//
//  Created by Linh NGUYEN on 11/15/13.
//  Copyright (c) 2013 Nikmesoft Ltd. All rights reserved.
//

#import "Contact.h"

@interface Contact()
{
    NSMutableArray *_array;
    NSMutableDictionary *_dict;
    
}

@end

@implementation Contact

- (NSString*)firstLetter
{
    if(_name != nil)
    {
        return  [_name substringToIndex:1];
    } else
    {
        return nil;
    }
}


@end
