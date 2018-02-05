//
//  VOffice_DetailWorkCell_iPad.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOfice_DetailBaseCell.h"
@class DetailWorkModel;

@interface VOffice_DetailWorkCell_iPad : VOfice_DetailBaseCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_Title;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Content;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_tittle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_content;

- (void)setupDataByModel:(DetailWorkModel *)model atIndex:(NSInteger)index segment:(NSInteger)segment;



@end
