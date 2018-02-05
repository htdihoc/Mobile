//
//  VOfficeBaseSubView.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOInsectTextLabel.h"
#import "BaseVC.h"
#import "VOffice_Protocol.h"
#import "BaseDetailVC.h"
@interface VOffice_BaseSubView_iPad : BaseDetailVC
@property (strong, nonatomic) SOInsectTextLabel *lblTitle;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIButton *btn_VOffice;
- (void)didSelectVOffice;
@end
