//
//  QLTT_DetailSubVC_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 6/1/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "QLTT_DetailSubVC_iPad.h"
#import "QLTT_DetailVC_iPad.h"
#import "NSString+SizeOfString.h"
@interface QLTT_DetailSubVC_iPad ()

@end

@implementation QLTT_DetailSubVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *contentButtons = [NSMutableArray arrayWithArray:@[LocalizedString(@"KTABBAR_ITEM_MORE_TITLE"), LocalizedString(@"QLTT_MasterVC_Quản_lý_tri_thức")]];
    if (_isTreeVC) {
        [contentButtons addObject:LocalizedString(@"QLTT_MasterVC_Danh_mục_dạng_cây")];
    }
    self.VOffice_buttonTitles = contentButtons;
    QLTT_DetailVC_iPad *detailVC = NEW_VC_FROM_NIB(QLTT_DetailVC_iPad, @"QLTT_DetailVC_iPad");
    detailVC.detailVC.isTreeVC = self.isTreeVC;
    detailVC.detailVC.delegate = self.delegate;
    [detailVC reloadData];
    [detailVC setTitleLabel:self.titleLabel];
    [detailVC setSubTitleLabel:self.titleSubLabel];
    [self displayVC:detailVC container:self.containerView];
}
@end
