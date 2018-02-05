//
//  RegisterDetail.h
//  CheckINAndOUT
//
//  Created by NguyenVanTu on 4/17/17.
//  Copyright © 2017 NguyenVanTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePersonRuleCheckInAndOut.h"
@interface NormalRegisterDetail : BasePersonRuleCheckInAndOut

@property (weak, nonatomic) IBOutlet UIView *containterView;

@property (assign, nonatomic) NSInteger empOutRegId;

@end
