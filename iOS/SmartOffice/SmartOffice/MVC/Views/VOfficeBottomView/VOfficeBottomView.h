//
//  VOfficeBottomVIew.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/20/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol VOfficeBottomViewDelegate
- (void)didSelectChatButton;
- (void)didSelectReminderButton;
@end
@interface VOfficeBottomView : UIView
@property (nonatomic, weak, nullable) id <VOfficeBottomViewDelegate> delegate;
@end
