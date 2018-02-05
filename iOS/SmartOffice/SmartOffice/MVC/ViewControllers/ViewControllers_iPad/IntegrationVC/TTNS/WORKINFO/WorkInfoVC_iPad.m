//
//  WorkListVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 4/25/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "WorkInfoVC_iPad.h"

@interface WorkInfoVC_iPad ()

@end

@implementation WorkInfoVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

-(void)setupUI{
    [self addBorderView];
    [self setupTitleForLB];
}

-(void)addBorderView {
    self.congPheDuyetView.layer.cornerRadius            = self.congPheDuyetView.bounds.size.width/2;
    self.congChuaPheDuyetView.layer.cornerRadius        = self.congChuaPheDuyetView.bounds.size.width/2;
    self.nghiKhongLuongView.layer.cornerRadius          = self.nghiKhongLuongView.bounds.size.width/2;
    self.chuaChamCongView.layer.cornerRadius            = self.chuaChamCongView.bounds.size.width/2;
    
    self.congPheDuyetView.layer.masksToBounds           = YES;
    self.congChuaPheDuyetView.layer.masksToBounds       = YES;
    self.nghiKhongLuongView.layer.masksToBounds         = YES;
    self.chuaChamCongView.layer.masksToBounds           = YES;
}

-(void)setupTitleForLB{
    self.workInfoLB.text            = LocalizedString(@"Thông tin công");
    self.congPheDuyetLB.text        = LocalizedString(@"Cônß phê duyệt");
    self.congChuaPheDuyetLB.text    = LocalizedString(@"Công chưa phê duyệt");
    self.nghiKhongLuongLB.text      = LocalizedString(@"Nghỉ không lương");
    self.chuaChamCongLB.text        = LocalizedString(@"Công chưa chấm");
    self.quanLyTrucLeLB.text        = LocalizedString(@"K_INFO_HUMAN_VC_MANAGER_HOLYDAY");
}


- (IBAction)calendarAction:(id)sender {
}

- (IBAction)quanLyTrucLeAction:(id)sender {
}
@end
