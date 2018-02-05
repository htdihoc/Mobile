//
//  AttachCell.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttachCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sttLB;
@property (weak, nonatomic) IBOutlet UILabel *numberLB;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@end
