//
//  TTNS_NavBase_iPad.h
//  SmartOffice
//
//  Created by Administrator on 7/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+SizeOfString.h"
#import "NavButton_iPad.h"

@protocol TTNS_NavBase_iPadDelegate
-(void)didSelectButton:(NSInteger)index;
-(void)didTapRightButton:(UIButton *)sender;
-(void)didTapNotificationButton:(UIButton *)sender;
@end

@interface TTNS_NavBase_iPad : UIView

@property (weak, nonatomic) IBOutlet UIView *navView;

@property (weak, nonatomic) IBOutlet UIView *navRightView;

@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) id<TTNS_NavBase_iPadDelegate> delegate;

- (void)addButtons:(NSArray *)titles margin:(NSInteger )marginLeft fontSize:(NSInteger )fontSize;
- (void)addRightBarButton:(UIButton *)rightView;
//- (void)setHiddenForBtn_TreeMode:(BOOL)isHidden;
- (IBAction)showPopupNotification:(id)sender;
- (void)setIsTTNSVC:(BOOL)isTTNSVC;

@end
