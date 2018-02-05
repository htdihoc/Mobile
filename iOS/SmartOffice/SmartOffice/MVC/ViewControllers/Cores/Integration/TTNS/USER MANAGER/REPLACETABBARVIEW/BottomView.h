//
//  BottomView.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/19/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReplaceTabBarProtocol.h"
#import "BottomButton.h"
@interface BottomView : UIView
@property (strong, nonatomic) BottomButton *leftBtnAttribute;
@property (strong, nonatomic) BottomButton *rightBtnAttribute;
- (instancetype)initWithAttributes:(BottomButton *)leftBtnAttribute rightAttributes:(BottomButton*)rightBtnAttribute;
@end
