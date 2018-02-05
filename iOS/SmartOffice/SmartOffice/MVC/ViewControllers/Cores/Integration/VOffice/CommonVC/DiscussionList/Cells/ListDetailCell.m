//
//  ListDetailCell.m
//  SmartOffice
//
//  Created by NguyenDucBien on 5/17/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "ListDetailCell.h"
#import "DiscussionListVC.h"
#import "EmployeeModel.h"


@implementation ListDetailCell
@synthesize delegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)btnDeleteCell:(UIButton *)sender {

//    [self.delegate didPressButtonAtCell: self.indexPath];

//    [self.delegate didPressButtonAtCell: self];
    
}

#pragma mark - setup UI
- (void)setupDataFromModel:(EmployeeModel *)model{
	if (model) {
		_lbName.text = model.memberName;
	}
}
@end
