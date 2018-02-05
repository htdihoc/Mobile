//
//  ConfirmRefueAllVC_iPad.h
//  SmartOffice
//
//  Created by NguyenDucBien on 6/22/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@class ConfirmRefueAllVC;
@protocol ConfirmRefueAllDelegate <NSObject>



@end

@interface ConfirmRefueAllVC_iPad : BaseVC
@property (weak, nonatomic) IBOutlet UILabel *tittleLB;

@property (weak, nonatomic) IBOutlet UILabel *reasonLB;

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *reasonTV;

@property (weak, nonatomic) IBOutlet UIButton *btnClearTV;

@property (weak, nonatomic) IBOutlet UIButton *btnOK;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (nonatomic, weak) id<ConfirmRefueAllDelegate> delegate;

- (IBAction)clearTVButtonAction:(id)sender;

- (IBAction)okButtonAction:(id)sender;

- (IBAction)cancelButtonAction:(id)sender;

@end
