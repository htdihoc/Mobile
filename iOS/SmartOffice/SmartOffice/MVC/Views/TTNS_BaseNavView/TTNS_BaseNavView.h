//
//  TTNS_BaseNavView.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTNS_BaseNavViewDelegate
- (void)didTapBackButton;
- (void)didTapRightButton;
@end
@interface TTNS_BaseNavView : UIView
- (void)customInit:(NSString *)title subTitle:(NSString *)subTitle rightTitle:(NSString*)rightTitle;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subTitle;
@property(nonatomic, weak) id <TTNS_BaseNavViewDelegate> delegate;

- (void)addRightBarButton:(UIButton *)rightView isButtonTile:(BOOL)isButtonTile;
@end


