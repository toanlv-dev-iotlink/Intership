//
//  EditViewController.h
//  HoaBT1
//
//  Created by MrHoa on 12/8/15.
//  Copyright (c) 2015 MrHoa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDCar.h"
@interface EditViewController : UIViewController
    @property (nonatomic) NSString * editNumber;
    @property (nonatomic) NSString * editModel;
    @property (nonatomic) NSDate * editCreatedDate;
    @property (nonatomic) NSString * editNumberOfSheat;
    @property (nonatomic) NSString * editFuel;
    @property (nonatomic) NSString * editMaxSpeed;
    @property (nonatomic) NSIndexPath * idPath;
    @property (nonatomic) CDCar *oldCar;
@end
