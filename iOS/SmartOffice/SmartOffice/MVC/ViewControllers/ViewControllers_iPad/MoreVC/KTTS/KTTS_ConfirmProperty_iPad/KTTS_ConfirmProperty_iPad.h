//
//  KTTS_ConfirmProperty_iPad.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNS_BaseVC.h"
#import "KPDropMenu.h"

@interface KTTS_ConfirmProperty_iPad : TTNS_BaseVC


@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, assign) BOOL showStatusBar;


@property (weak, nonatomic) IBOutlet UILabel *lbl_assetName;

@property (weak, nonatomic) IBOutlet UILabel *lbl_assetCount;

@property (weak, nonatomic) IBOutlet UILabel *lbl_assetSerial;

@property (weak, nonatomic) IBOutlet KPDropMenu *view_kindOfReport;
@property (weak, nonatomic) IBOutlet UILabel *lbl_DefaultKindOfReport;

@property (weak, nonatomic) IBOutlet UILabel *lbl_quantity;

@property (weak, nonatomic) IBOutlet UITextView *tv_quantity;

@property (weak, nonatomic) IBOutlet UILabel *lbl_unuseDays;

@property (weak, nonatomic) IBOutlet UIButton *btn_unuseDays;

@property (weak, nonatomic) IBOutlet UIButton *btn_ClearReason;

@property (weak, nonatomic) IBOutlet UITextView *tv_reason;

@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;

@property (weak, nonatomic) IBOutlet UIButton *btn_send;

@property (weak, nonatomic) IBOutlet UILabel *line_width;

@property (weak, nonatomic) IBOutlet UILabel *line_height;

@property (weak, nonatomic) IBOutlet UIView *view_unuseDays;


- (IBAction)chooseUnuseDays:(id)sender;

- (IBAction)cancelAction:(id)sender;

- (IBAction)sendAction:(id)sender;


@end
