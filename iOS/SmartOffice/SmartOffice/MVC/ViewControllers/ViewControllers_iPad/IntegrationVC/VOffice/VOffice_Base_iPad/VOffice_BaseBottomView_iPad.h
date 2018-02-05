//
//  VOffice_BaseBottomView_iPad.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOfficeBottomView.h"
#import "VOffice_Base_iPad.h"
@interface VOffice_BaseBottomView_iPad : VOffice_Base_iPad<VOfficeBottomViewDelegate>
- (void)hiddenBottomView:(BOOL)isHidden;
@end
