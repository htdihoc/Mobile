//
//  KTTS_ContentBBBGView_iPad.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/24/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "KTTS_ContentBBBGView_iPad.h"
#import "BBBGAssetModel.h"

@implementation KTTS_ContentBBBGView_iPad

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.topView.layer.borderWidth                      = 1;
    self.topView.layer.borderColor                      = AppColor_BorderForView.CGColor;
    
    self.middleView.layer.borderWidth                   = 1;
    self.middleView.layer.borderColor                   = AppColor_BorderForView.CGColor;
    
    self.searchView.layer.borderWidth                   = 1;
    self.searchView.layer.borderColor                   = AppColor_BorderForView.CGColor;
    
    self.bottomView.layer.borderWidth                   = 1;
    self.bottomView.layer.borderColor                   = AppColor_BorderForView.CGColor;
    
    self.searchBar.placeholder = @"Tìm kiếm theo mã Serial, tên tài sản...";
    
    [self.btn_confirm setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    self.btn_confirm.backgroundColor                    = RGB(14, 133, 188);
    self.btn_confirm.layer.borderWidth                  = 1;
    self.btn_confirm.layer.borderColor                  = RGB(14, 133, 188).CGColor;
    self.btn_confirm.layer.cornerRadius                 = 3;
    [self.btn_confirm setTitle:@"Xác nhận tài sản" forState:UIControlStateNormal];
    
    [self.btn_refuse setTitleColor: RGB(240, 82, 83) forState:UIControlStateNormal];
    self.btn_refuse.backgroundColor                     = [UIColor whiteColor];
    self.btn_refuse.layer.borderWidth                   = 1;
    self.btn_refuse.layer.borderColor                   = RGB(240, 82, 83).CGColor;
    self.btn_refuse.layer.cornerRadius                  = 3;
    [self.btn_refuse setTitle:@"Từ chối" forState:UIControlStateNormal];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.view = [[[NSBundle mainBundle] loadNibNamed:@"KTTS_ContentBBBGView_iPad" owner:self options:nil] firstObject];
    self.view.frame = self.bounds;
    [self addSubview:self.view];
}

- (IBAction)actionConfirm:(id)sender {
    [self.delegate actionShowConfirmAlert];
}

- (IBAction)actionRefuse:(id)sender {
    [self.delegate actionShowRefuseAlert];
}



@end
