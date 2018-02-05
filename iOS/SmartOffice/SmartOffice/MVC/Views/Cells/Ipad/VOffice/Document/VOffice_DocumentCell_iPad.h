//
//  VOffice_DocumentCell_iPad.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/26/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOfice_DetailBaseCell.h"
@class SumDocModel;
@interface VOffice_DocumentCell_iPad : VOfice_DetailBaseCell
- (void)updateValue:(SumDocModel *)model forType:(DocType)type;
@end
