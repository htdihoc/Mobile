//
//  ManagerInOutVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ManagerInOutVC_iPad.h"
#import "ListRegisterFormVC_iPad.h"

@interface ManagerInOutVC_iPad ()

@end

@implementation ManagerInOutVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    ListRegisterFormVC_iPad *listRegister       = NEW_VC_FROM_NIB(ListRegisterFormVC_iPad, @"ListRegisterFormVC_iPad");
    
    [self displayContainerView:listRegister container:self.container1View];
}

@end
