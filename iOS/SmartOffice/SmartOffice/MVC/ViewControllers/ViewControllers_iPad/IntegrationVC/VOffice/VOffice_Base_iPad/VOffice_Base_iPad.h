//
//  VOffice_Base_iPad.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/27/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOffice_NavBase_iPad.h"
#import "VOffice_Protocol.h"
@interface VOffice_Base_iPad : BaseVC
@property(nonatomic,copy) NSString *VOffice_title;
@property(nonatomic,copy) NSString *VOffice_subTitle;
@property (nonatomic, copy) NSArray *VOffice_buttonTitles;
@property (assign) NSInteger jumpVC;
@property (assign) BOOL disableBackIcon;
@property(strong, nonatomic) VOffice_NavBase_iPad *nav_iPad;
- (void)setHiddenForFilterCopanyButton:(BOOL)isHidden;
- (void)didTapRightButton:(UIButton *)sender;
- (void)isTTNSVC:(BOOL)isTTNSVC;
@end
