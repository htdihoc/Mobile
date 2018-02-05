//
//  TTNV_BaseVC.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "BottomButton.h"
#import "BottomView.h"
@interface TTNS_BaseVC : BaseVC <BottomViewDelegate>
@property (strong, nonatomic) BottomButton *leftBtnAttribute;
@property (strong, nonatomic) BottomButton *rightBtnAttribute;
- (void)didselectLeftButton;
- (void)didSelectRightButton;
- (void)disableButtons:(BOOL)isDisable;
@end
