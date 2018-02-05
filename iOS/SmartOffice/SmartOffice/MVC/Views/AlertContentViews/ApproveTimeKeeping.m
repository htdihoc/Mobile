//
//  ApproveTimeKeeping.m
//  SmartOffice
//
//  Created by NguyenVanTu on 6/23/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "ApproveTimeKeeping.h"

@interface ApproveTimeKeeping ()
@property (weak, nonatomic) IBOutlet UIButton *btn_Accept;
@property (weak, nonatomic) IBOutlet UIButton *btn_Reject;

@end

@implementation ApproveTimeKeeping

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTextForViews];
}
- (void)setupTextForViews
{
    
    [self.btn_Accept setTitle:LocalizedString(@"TTNS_TimeKeepingPopup_Phê_duyệt") forState:UIControlStateNormal];
    [self.btn_Accept setTitleColor:AppColor_MainTextColor forState:UIControlStateNormal];
    
    [self.btn_Reject setTitle:LocalizedString(@"TTNS_TimeKeepingPopup_Từ_chối") forState:UIControlStateNormal];
    [self.btn_Reject setTitleColor:AppColor_MainTextColor forState:UIControlStateNormal];
    
}
- (IBAction)selectedAccept:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectedAccept)]) {
        [self.delegate selectedAccept];
    }
}
- (IBAction)selectedReject:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectedReject)]) {
        [self.delegate selectedReject];
    }
}

@end
