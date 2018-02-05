//
//  KiDetailInfoAndKi.m
//  SmartOffice
//
//  Created by NguyenVanTu on 6/20/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "KiDetailInfoAndKi.h"

@interface KiDetailInfoAndKi ()
{
    NSString *_title;
    NSString *_ki;
}
@property (weak, nonatomic) IBOutlet UILabel *lbl_Title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_KiTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_KiValue;

@end

@implementation KiDetailInfoAndKi

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lbl_Title.textColor = AppColor_MainTextColor;
    _lbl_KiTitle.textColor = AppColor_MainTextColor;
    
    _lbl_KiTitle.text = [NSString stringWithFormat:@"%@:", LocalizedString(@"Điểm Ki")];
    [self setTitleAndKi];
}
- (void)setTitleAndKi
{
    _lbl_Title.text = _title;
    _lbl_KiValue.text = _ki;
}
- (void)setTitle:(NSString *)title ki:(NSString *)ki
{
    _title = title;
    _ki = ki;
}

@end
