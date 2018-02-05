//
//  ContentTimeKeeping.h
//  Alert
//
//  Created by NguyenVanTu on 4/10/17.
//  Copyright © 2017 NguyenVanTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "UIPlaceHolderTextView.h"

@protocol DismissTimeKeepingDelegate
- (void)isEmpty:(BOOL)isEmpty;
@end
@interface DismissTimeKeeping : BaseVC
@property (weak, nonatomic) IBOutlet UILabel *lbl_Reason;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *tv_Content;
@property (weak, nonatomic) id<DismissTimeKeepingDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (assign) BOOL isManager;
- (IBAction)clearAction:(id)sender;

@end
