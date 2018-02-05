//
//  CreateNewFormVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "CreateNewFormVC_iPad.h"
#import "RegisterFormVC_iPad.h"

@interface CreateNewFormVC_iPad ()

@end

@implementation CreateNewFormVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    RegisterFormVC_iPad *registerFormVC = [[RegisterFormVC_iPad alloc]initWithNibName:@"RegisterFormVC_iPad" bundle:nil];
    [self displayContainerView:registerFormVC container:self.containerView1];
}

@end
