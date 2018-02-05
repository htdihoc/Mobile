//
//  RegisterMainView.h
//  RegisterWorkOff
//
//  Created by NguyenDucBien on 4/14/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonCheckBox.h"
#import "BaseListView.h"
#import "RegisterOtherFreeDay.h"
#import "TTNS_WorkList.h"
#import "UIButton+BorderDefault.h"
#import "RegisterWatchCell.h"
#import "RegisterAbsentCell.h"
#import "FullWidthSeperatorTableView.h"

@interface RegisterWatch : TTNS_BaseVC{
    
}
@property (weak, nonatomic) IBOutlet UIButton *btnWorkContent;
@property (weak, nonatomic) IBOutlet UIButton *btnrRegistrationStatus;

@property (weak, nonatomic) IBOutlet UILabel *MoreRegisterLabel;
@property (weak, nonatomic) IBOutlet UIButton *RegisterMoreButton;
- (IBAction)RegisterMoreAction:(id)sender;

@end
