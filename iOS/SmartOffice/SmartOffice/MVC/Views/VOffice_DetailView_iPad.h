//
//  VOffice_DetailView_iPad.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOInsectTextLabel.h"
#import "FullWidthSeperatorTableView.h"
@interface VOffice_DetailView_iPad : UIView
@property (weak, nonatomic) IBOutlet SOInsectTextLabel *lbl_Title;

@property (nonatomic, strong) UIView *view;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet FullWidthSeperatorTableView *tbl_Detail;
@property (weak, nonatomic) IBOutlet UIButton *btn_VOffice;
- (void)didSelectVOffice;
- (void)endEditView;
@end
