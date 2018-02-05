//
//  MenuRootVC.h
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 4/2/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "LGSideMenuController.h"
#import "LeftViewController.h"
#import "RightViewController.h"

@interface MenuRootVC : LGSideMenuController

@property (assign, nonatomic) NSUInteger type;

- (void)setupWithType:(NSUInteger)type;

@end
