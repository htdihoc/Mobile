//
//  VOffice_ListWorkCell.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/27/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WorkModel;

@interface VOffice_ListWorkCell_iPad : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitleWork;
@property (weak, nonatomic) IBOutlet UILabel *lblDeadline;
@property (weak, nonatomic) IBOutlet UILabel *lblAssigner;

@property (weak, nonatomic) IBOutlet UIImageView *imgWorkType;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_Assigner;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_ProfileImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_contentLB;

//Data
- (void)setupDataByModel:(WorkModel *)model withListWorkType:(ListWorkType)type;

@end
