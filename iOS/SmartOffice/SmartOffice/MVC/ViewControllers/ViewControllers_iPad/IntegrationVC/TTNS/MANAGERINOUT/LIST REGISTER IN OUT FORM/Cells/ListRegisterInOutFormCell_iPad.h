//
//  ListRegisterInOutFormCell_iPad.h
//  SmartOffice
//
//  Created by Administrator on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListRegisterInOutFormCell_iPad : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeRegisterLB;

@property (weak, nonatomic) IBOutlet UILabel *addresLB;

@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (weak, nonatomic) IBOutlet UIImageView *stateIcon;

@property (weak, nonatomic) IBOutlet UILabel *stateLB;

@property (weak, nonatomic) IBOutlet UILabel *reasonLB;
@property (weak, nonatomic) IBOutlet UILabel *reasonContentLB;

@end
