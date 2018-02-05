//
//  ListRegisterFormCell.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListRegisterFormCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *typeRegisterImg;

@property (weak, nonatomic) IBOutlet UILabel *typeRegisterLB;

@property (weak, nonatomic) IBOutlet UILabel *addresLB;

@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (weak, nonatomic) IBOutlet UIImageView *stateIcon;

@property (weak, nonatomic) IBOutlet UILabel *stateLB;

@property (weak, nonatomic) IBOutlet UILabel *reasonLB;

@end
