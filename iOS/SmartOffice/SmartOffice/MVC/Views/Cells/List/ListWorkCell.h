//
//  ListWorkCell.h
//  SmartOffice
//
//  Created by Kaka on 4/13/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WorkModel;

@interface ListWorkCell : UITableViewCell{
	
}
@property (weak, nonatomic) IBOutlet UILabel *lblTitleWork;
@property (weak, nonatomic) IBOutlet UILabel *lblDeadline;
@property (weak, nonatomic) IBOutlet UILabel *lblAssigner;

@property (weak, nonatomic) IBOutlet UIImageView *imgWorkType;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_Assigner;


//Data
- (void)setupDataByModel:(WorkModel *)model withListWorkType:(ListWorkType)type;

@end
