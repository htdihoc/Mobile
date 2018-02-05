//
//  DetailMissionCell.h
//  SmartOffice
//
//  Created by Kaka on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailMissionModel;

@interface DetailMissionCell : UITableViewCell{
	
}
@property (weak, nonatomic) IBOutlet UILabel *lblTitleCell;
@property (weak, nonatomic) IBOutlet UILabel *lblContentCell;

- (void)setupDataByModel:(DetailMissionModel *)model atIndex:(NSInteger)index;

@end
