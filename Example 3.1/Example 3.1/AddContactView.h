//
//  AddContactView.h
//  Example 3.1
//
//  Created by Linh NGUYEN on 11/19/13.
//  Copyright (c) 2013 Nikmesoft Ltd. All rights reserved.
//

#import "NMView.h"

@class Contact;

@protocol AddContactDelegate;

@interface AddContactView : NMView

@property (nonatomic, weak) id<AddContactDelegate> delegate;

@end

@protocol AddContactDelegate <NSObject>

@optional

- (void)addContactView:(AddContactView*)addContactView didAdd:(Contact*)newContact;
- (void)addContactView:(AddContactView*)addContactView didCancel:(NSString*)message;

@end