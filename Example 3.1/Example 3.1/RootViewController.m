//
//  RootViewController.m
//  Example 3.1
//
//  Created by Linh NGUYEN on 11/19/13.
//  Copyright (c) 2013 Nikmesoft Ltd. All rights reserved.
//

#import "RootViewController.h"
#import "Contact.h"
#import "AddContactView.h"

#define KEY_LETTER  @"KEY_LETTER"
#define KEY_ARRAY   @"KEY_ARRAY"

@interface RootViewController ()<UITableViewDataSource, UITableViewDelegate,AddContactDelegate>
{
    __weak IBOutlet UITableView *_tableView;
    NSMutableArray *_contactDictArray;
}

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)addContact:(id)sender
{
    AddContactView *addContactView = [[AddContactView alloc] initWithXibName:@"AddContactView"];
    addContactView.delegate = self;
    [addContactView showInView:self.view];
}

#pragma mark - init
- (void)initUI
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)initData
{
    _contactDictArray = [NSMutableArray array];
}

#pragma mark - process
- (void)sortArray
{
    NSArray *sortedArray;
    sortedArray = [_contactDictArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDictionary *dicta = (NSDictionary*)a;
        NSDictionary *dictb = (NSDictionary*)b;
        NSString *letterA = [dicta objectForKey:KEY_LETTER];
        NSString *letterB = [dictb objectForKey:KEY_LETTER];
        return [letterA compare:letterB];
    }];
    
    [_contactDictArray removeAllObjects];
    _contactDictArray = nil;
    _contactDictArray = [NSMutableArray arrayWithArray:sortedArray];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _contactDictArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = [_contactDictArray objectAtIndex:section];
    
    
    
    NSArray *contactArray = [dict objectForKey:KEY_ARRAY];
    if(contactArray != nil)
    {
        return contactArray.count;
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dict = [_contactDictArray objectAtIndex:indexPath.section];
    if(dict != nil)
    {
        NSArray *contactArray = [dict objectForKey:KEY_ARRAY];
        
        Contact *contact = [contactArray objectAtIndex:indexPath.row];
        
        
        cell.textLabel.text = contact.name;
    }
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 30.f)];
    label.backgroundColor = [UIColor grayColor];
    NSDictionary *dict = [_contactDictArray objectAtIndex:section];
    label.text = [dict objectForKey:KEY_LETTER];
    return label;
    
}

#pragma mark - AddContactViewDelegate
- (void)addContactView:(AddContactView*)addContactView didAdd:(Contact*)newContact
{
    NSString *firstLeter = [[newContact firstLetter] uppercaseString];
    
    
    BOOL added = FALSE;
    
    for (NSMutableDictionary *dict in _contactDictArray) {
        NSString *key = [dict objectForKey:KEY_LETTER];
        if([key isEqualToString:firstLeter])
        {
            NSMutableArray *array = [dict objectForKey:KEY_ARRAY];
            
            [array addObject:newContact];
            
            //sort
            NSArray *sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                Contact *contact1 = (Contact*)obj1;
                Contact *contact2 = (Contact*)obj2;
                return [contact1.name compare:contact2.name];
            }];
            array = [NSMutableArray arrayWithArray:sortedArray];
            [dict setObject:array forKey:KEY_ARRAY];
            added = TRUE;
        }
    }
    
    if(!added)
    {
        NSMutableArray *newArray = [NSMutableArray array];
        [newArray addObject:newContact];
        
        
        NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithObjects:@[newArray,firstLeter] forKeys:@[KEY_ARRAY,KEY_LETTER]];
        
        [_contactDictArray addObject:newDict];
    }
    [self sortArray];
    [_tableView reloadData];
}
@end

