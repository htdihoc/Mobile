//
//  SO_TitleSegment.h
//  QLTT_TitleSegment
//
//  Created by NguyenVanTu on 8/16/17.
//  Copyright © 2017 NguyenVanTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSubView.h"
@protocol SO_TitleSegmentDelegate<NSObject>
- (void)didSelectFirstButton;
- (void)didSelectSecondButton;
- (void)didSelectThirdButton;
@end
@interface SO_TitleSegment : BaseSubView
@property (weak, nonatomic) IBOutlet UIButton *btn_First;
@property (weak, nonatomic) IBOutlet UIButton *btn_Second;
@property (weak, nonatomic) IBOutlet UIButton *btn_Third;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_ButtonFirstNornalWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_ButtonSecondNornalWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_ButtonThirdNornalWidth;

@property (assign) CGFloat screenWidth;
@property (weak, nonatomic) id<SO_TitleSegmentDelegate>delegate;
- (void)setTitleForButtons:(NSString *)firstTitle second:(NSString *)secondTitle third:(NSString *)thirdTitle;
- (void)setFontForButtons:(UIFont *)font;
- (void)touchAt:(NSInteger)index;
@end
