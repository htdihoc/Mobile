//
//  RegisterWatchCell.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/21/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "ButtonCheckBox.h"

@protocol RegisterWatchCellDelegate <NSObject>

- (void)pressButtonExpand:(UIButton *)sender;

- (void)pressButtonUnExpand:(UIButton *)sender;

@end

@interface RegisterWatchCell : UITableViewCell

@property (weak, nonatomic) id<RegisterWatchCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet ButtonCheckBox *ckOff2;

@property (weak, nonatomic) IBOutlet ButtonCheckBox *ckWork2;

@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property (weak, nonatomic) IBOutlet UIButton *btn_WorkType;

@property (weak, nonatomic) IBOutlet UIButton *btn_MoreOption;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfContentWorkView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfRegisterMoreView;

@property (weak, nonatomic) IBOutlet UIView *contentWorkView;

@property (weak, nonatomic) IBOutlet UIView *locationView;

@property (weak, nonatomic) IBOutlet UIView *registerMoreView;

@property (weak, nonatomic) IBOutlet UILabel *lbl_RegisterType;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Absent;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Watch;
@property (weak, nonatomic) IBOutlet UILabel *lbl_WorkContent;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Place;
@property (weak, nonatomic) IBOutlet UILabel *lbl_MoreDay;


- (IBAction)LocationAction:(id)sender;


@end
