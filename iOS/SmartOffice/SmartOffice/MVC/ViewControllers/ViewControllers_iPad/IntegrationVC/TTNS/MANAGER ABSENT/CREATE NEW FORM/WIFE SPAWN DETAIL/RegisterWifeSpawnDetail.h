//
//  RegisterWifeSpawnDetail.h
//  SmartOffice
//
//  Created by NguyenDucBien on 5/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_BaseSubView_iPad.h"
#import "UIPlaceHolderTextView.h"

@interface RegisterWifeSpawnDetail : TTNS_BaseSubView_iPad;

@property (weak, nonatomic) IBOutlet UILabel *timeOff;
@property (weak, nonatomic) IBOutlet UIButton *TimeButton;
@property (weak, nonatomic) IBOutlet UILabel *lbTimeOff;

@property (weak, nonatomic) IBOutlet UILabel *offPlace;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *offPlaceTextview;
@property (weak, nonatomic) IBOutlet UILabel *telNumber;
@property (weak, nonatomic) IBOutlet UITextField *telNumberTextfile;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseHandlerButton;
@property (weak, nonatomic) IBOutlet UILabel *unitCommanderLabel;
@property (weak, nonatomic) IBOutlet UIButton *unitCommanderButton;
@property (weak, nonatomic) IBOutlet UIButton *registryButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UILabel *contentHandlerChoose;
@property (weak, nonatomic) IBOutlet UILabel *contentManagerUnit;
@property (weak, nonatomic) IBOutlet UIButton *btnClearLocation;
- (IBAction)clearLocationAction:(id)sender;
- (IBAction)handlerButtonAction:(id)sender;
- (IBAction)commanderButtonAction:(id)sender;
- (IBAction)registryButtonAction:(id)sender;
- (IBAction)recordButtonAction:(id)sender;
- (IBAction)TimeAction:(id)sender;

@end
