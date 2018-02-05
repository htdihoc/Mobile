//
//  KTTS_DetailPropertyView_iPad.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/10/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOInsectTextLabel.h"
#import "FullWidthSeperatorTableView.h"


@protocol KTTS_DetailPropertyViewDelegate_iPad <NSObject>

- (void)buttonShowConfirmVC:(UIButton *)sender;

@end

@interface KTTS_DetailPropertyView_iPad : UIView

@property (weak, nonatomic) IBOutlet SOInsectTextLabel *lbl_title;
@property (weak, nonatomic) IBOutlet FullWidthSeperatorTableView *tbl_Detail;
@property (weak, nonatomic) IBOutlet UIButton *btn_Confirm;
@property (nonatomic, strong) UIView *view;
@property (weak, nonatomic) IBOutlet UIView *titleView;
- (IBAction)action_Confirm:(id)sender;

@property (nonatomic, assign) BOOL isConfirm;

- (void)setup;
@property (weak, nonatomic) id<KTTS_DetailPropertyViewDelegate_iPad> delegate;

@end
