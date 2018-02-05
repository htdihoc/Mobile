//
//  RegisterFormCell_iPad.h
//  SmartOffice
//
//  Created by Administrator on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterFormCell_iPad : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconTypeRegister;
@property (weak, nonatomic) IBOutlet UILabel *typeRegisterLB;
@property (weak, nonatomic) IBOutlet UILabel *overDateLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeRegLBCenterY;

@end
