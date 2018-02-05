//
//  ListDocCell.h
//  SmartOffice
//
//  Created by Kaka on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DocModel;
@class SORoundLabel;

@interface ListDocCell : UITableViewCell{
	
}
@property (weak, nonatomic) IBOutlet UILabel *lblDocTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblRaiseMember;
@property (weak, nonatomic) IBOutlet UILabel *lblSignedDate;
@property (weak, nonatomic) IBOutlet UILabel *lblPriority;
@property (weak, nonatomic) IBOutlet UIImageView *imgPriority;

@property (weak, nonatomic) IBOutlet SORoundLabel *lblUrgentStatus;





//Data
- (void)setupDataByModel:(id)model;

@end
