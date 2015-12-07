//
//  AddContactView.m
//  Example 3.1
//
//  Created by Linh NGUYEN on 11/19/13.
//  Copyright (c) 2013 Nikmesoft Ltd. All rights reserved.
//

#import "AddContactView.h"
#import "Contact.h"

@interface AddContactView()
{
    __weak IBOutlet UITextField *_tfName;
}

@end

@implementation AddContactView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (IBAction)back:(id)sender
{
    if([_delegate respondsToSelector:@selector(addContactView:didCancel:)])
    {
        [_delegate addContactView:self didCancel:nil];
    }
    
    [self hide];
}

- (IBAction)add:(id)sender
{
    NSString *name = [_tfName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(name.length > 0)
    {
        Contact *contact = [[Contact alloc] init];
        contact.name = name;
        
        if([_delegate respondsToSelector:@selector(addContactView:didAdd:)])
        {
            [_delegate addContactView:self didAdd:contact];
        }
        
        [self hide];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Example 3.1" message:@"Name is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
@end
