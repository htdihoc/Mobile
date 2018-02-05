//
//  NavBase.h
//  SampleNav
//
//  Created by NguyenVanTu on 4/27/17.
//  Copyright © 2017 NguyenVanTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+SizeOfString.h"
#import "NavButton_iPad.h"

@protocol VOffice_NavBase_iPadDelegate
-(void)didSelectButton:(NSInteger)index;
-(void)didSelectFilterButton:(UIButton *)sender;
-(void)didTapRightButton:(UIButton *)sender;
-(void)didTapNotificationButton:(UIButton *)sender;
@end

@interface VOffice_NavBase_iPad : UIView

@property (weak, nonatomic) IBOutlet UIButton *btn_Filter;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_subTitle;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UIView *navRightView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_CenterSubTitle;

@property (weak, nonatomic) id<VOffice_NavBase_iPadDelegate> delegate;
- (void)addButtons:(NSArray *)titles margin:(NSInteger )marginLeft fontSize:(NSInteger )fontSize disableBackIcon:(BOOL)disableBackIcon;
- (void)setHiddenForBtn_Filter:(BOOL)isHidden;
- (void)addRightBarButton:(UIButton *)rightView;
- (void)setHiddenForBtn_TreeMode:(BOOL)isHidden;
- (IBAction)showPopupNotification:(id)sender;
- (void)setIsTTNSVC:(BOOL)isTTNSVC;
@end
