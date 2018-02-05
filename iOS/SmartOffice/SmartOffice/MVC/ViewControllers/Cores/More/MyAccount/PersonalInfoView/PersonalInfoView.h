//
//  PersonalInfoView.h
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 4/16/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalInfoView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbJobTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbMobile;
@property (weak, nonatomic) IBOutlet UIButton *btnCaptureAvatar;
@property (weak, nonatomic) IBOutlet UIButton *btnDetailInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnEditInfo;


+ (NSString *)identifier;

@end
