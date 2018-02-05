//
//  ListRegisterFormCell.m
//  SmartOffice
//
//  Created by Hien Tuong on 4/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ListRegisterFormCell.h"

@implementation ListRegisterFormCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// MARK : - UI

-(void)setupUI{
    [self.reasonLB setHidden:YES];
}

- (void)willTransitionToState:(UITableViewCellStateMask)state{
    [super willTransitionToState:state];
    if (state == UITableViewCellStateShowingDeleteConfirmationMask)
    {
        
        if ([self.subviews count] < 4) return;
        UIView *delBtn = [self.subviews objectAtIndex:3];
        delBtn.frame = CGRectOffset(delBtn.frame, 0, 10);
    }
}
@end
