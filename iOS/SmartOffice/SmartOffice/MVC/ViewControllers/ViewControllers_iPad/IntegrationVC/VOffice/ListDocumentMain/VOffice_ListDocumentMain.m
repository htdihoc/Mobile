//
//  VOffice_ListDocumentMain.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_ListDocumentMain.h"

@interface VOffice_ListDocumentMain ()

@end

@implementation VOffice_ListDocumentMain

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = AppColor_MainAppBackgroundColor;
    [self addContainerViews];
}

- (void)addContainerViews
{
    VOffice_DocumentDetail_iPad *documentDetail = NEW_VC_FROM_NIB(VOffice_DocumentDetail_iPad, @"VOffice_DocumentDetail_iPad");
    
    [self displayContainerView:documentDetail container:self.listDocument];
    
    VOffice_DocumentTypicalDetail_iPad *documentTypicalProfileDetail = NEW_VC_FROM_NIB(VOffice_DocumentTypicalDetail_iPad, @"VOffice_DocumentTypicalDetail_iPad");
    [self displayContainerView:documentTypicalProfileDetail container:self.listDocumentDetail];
    
    
}

@end
