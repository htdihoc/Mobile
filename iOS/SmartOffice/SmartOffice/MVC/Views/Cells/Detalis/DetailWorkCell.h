//
//  DetailWorkCell.h
//  SmartOffice
//
//  Created by Kaka on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailWorkModel;

@interface DetailWorkCell : UITableViewCell{
	
}
@property (weak, nonatomic) IBOutlet UILabel *lblTitleCell;
@property (weak, nonatomic) IBOutlet UILabel *lblContentCell;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_titlecell;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_contentcell;

//Data
- (void)setupDataByModel:(DetailWorkModel *)model atIndex:(NSUInteger)index withSegment:(ListWorkType)segmsent;

@end
