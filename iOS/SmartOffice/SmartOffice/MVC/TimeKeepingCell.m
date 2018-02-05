//
//  TimeKeepingCell.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/21/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TimeKeepingCell.h"
#import "Common.h"
#import "TTNS_ApproveTimeKeepingController.h"

#import "UIImage+Resize.h"

@implementation TimeKeepingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lblTitle.textColor = AppColor_MainTextColor;
    self.lblTitle.text = LocalizedString(@"");
    self.lblName.text = @"";
    self.lblSubTitle.text = @"";
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)loadEmployeeInfo:(TTNS_EmployeeTimeKeeping *)employee
{
    NSLog(@"");
    if ([employee isLoaded]) {
        [self setDataForCell:employee];
    }
    else
    {
        [TTNS_ApproveTimeKeepingController loadDetailEmployee:employee.employeeId completion:^(BOOL success, NSDictionary *employeeDetail, NSException *exception, BOOL isConnectNetwork, NSDictionary *error) {
            //        TTNS_EmployeeTimeKeeping *model = [[TTNS_EmployeeTimeKeeping alloc] initWithDictionary:emloyeeDetail error:nil];
            employee.fullName = [employeeDetail valueForKey:@"fullName"] == [NSNull null] ? @"" : [employeeDetail valueForKey:@"fullName"];
            employee.email = [employeeDetail valueForKey:@"email"] == [NSNull null] ? @"" :[employeeDetail valueForKey:@"email"];
            employee.positionName = [employeeDetail valueForKey:@"positionName"] == [NSNull null] ? @"" :[employeeDetail valueForKey:@"positionName"];
            employee.imagePath = [employeeDetail valueForKey:@"imagePath"] == [NSNull null] ? @"" : [employeeDetail valueForKey:@"imagePath"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setDataForCell:employee];
            });
        }];
    }
    
}
- (void)setDataForCell:(TTNS_EmployeeTimeKeeping *)model
{
//    imgProfile;
//    lblName;
//    lblTitle;
//    lblSubTitle;
    self.lblName.text = model.fullName;
    self.lblTitle.text = model.email;
    if (!model.positionName || [model.positionName isEqualToString:@""]) {
        self.cst_Top.constant = 16;
        self.lblSubTitle.hidden = YES;
    }
    else
    {
        self.lblSubTitle.hidden = NO;
        self.cst_Top.constant = 4;
        self.lblSubTitle.text = model.positionName;
    }
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        if ([model.imagePath containsString:@"http"]) {
            NSData *resultData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.imagePath]];
            if (resultData == nil) {
                _imgProfile.image = [UIImage imageNamed:@"icon_avt_default"];
            }
            else
            {
                UIImage *image = [UIImage imageWithImageCache:[UIImage imageWithData:resultData] key:model.imagePath];
                if (image) {
                    dispatch_sync(dispatch_get_main_queue(), ^(void) {
                        _imgProfile.image = image;
                    });
                }
                else
                {
                    dispatch_sync(dispatch_get_main_queue(), ^(void) {
                        _imgProfile.image = [UIImage imageNamed:@"icon_avt_default"];
                    });
                }
            }
            
        }
    });
}
@end
