//
//  VOffice_DetailMissionCell_iPad.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailMissionModel.h"
#import "VOfice_DetailBaseCell.h"
@interface VOffice_DetailMissionCell_iPad : VOfice_DetailBaseCell


@property (weak, nonatomic) IBOutlet UILabel *lbl_Title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Content;

- (void)setupDataByModel:(DetailMissionModel *)model atIndex:(NSInteger)index;

@end
