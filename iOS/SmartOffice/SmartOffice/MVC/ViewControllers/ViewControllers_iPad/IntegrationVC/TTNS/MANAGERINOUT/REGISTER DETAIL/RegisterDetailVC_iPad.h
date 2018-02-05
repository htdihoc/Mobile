//
//  RegisterDetailVC_iPad.h
//  SmartOffice
//
//  Created by Administrator on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseSubView_iPad.h"

//@protocol RegisterDetailVC_iPadDelegate <NSObject>
//
//- (NSInteger)getEmpRegOutId;
//
//@end

@interface RegisterDetailVC_iPad : TTNS_BaseSubView_iPad

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContraintStateView;

@property (weak, nonatomic) IBOutlet UIView *stateView;

@property (weak, nonatomic) IBOutlet UIView *reasonView;

@property (weak, nonatomic) IBOutlet UIView *botView;


@property (weak, nonatomic) IBOutlet UILabel *statusLB;

@property (weak, nonatomic) IBOutlet UILabel *statusContentLB;

@property (weak, nonatomic) IBOutlet UILabel *reasonLB;

@property (weak, nonatomic) IBOutlet UILabel *reasonContentLB;

@property (weak, nonatomic) IBOutlet UILabel *userReasonLB;

@property (weak, nonatomic) IBOutlet UILabel *userReasonContentLB;

@property (weak, nonatomic) IBOutlet UILabel *locationLB;

@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property (weak, nonatomic) IBOutlet UILabel *reasonRegisterLB;

@property (weak, nonatomic) IBOutlet UIButton *reasonRegisterButton;

@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@property (weak, nonatomic) IBOutlet UILabel *detailReasonLB;

@property (weak, nonatomic) IBOutlet UITextView *detailReasonTV;

@property (weak, nonatomic) IBOutlet UIButton *btnClearDetailReason;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *sendRegisterButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightStateConstraint;

@property (assign, nonatomic) NSInteger empOutRegId;

- (IBAction)sendRegisterAction:(id)sender;

- (IBAction)cancelAction:(id)sender;

- (void)loadingData:(NSInteger)empOutRegId;

- (IBAction)clearDetailReasonAction:(id)sender;


@end
