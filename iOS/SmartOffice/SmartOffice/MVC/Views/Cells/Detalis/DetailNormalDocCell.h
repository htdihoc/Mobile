//
//  DetailNormalDocCell.h
//  SmartOffice
//
//  Created by Kaka on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailNormalDocCell : UITableViewCell{
	
}
@property (weak, nonatomic) IBOutlet UILabel *lblTitleCell;
@property (weak, nonatomic) IBOutlet UILabel *lblContentCell;

- (void)setupData:(id)model atIndex:(NSInteger)index;


@end
