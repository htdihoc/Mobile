//
//  QLTT_DetailVC_iPad.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/24/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOffice_Base_iPad.h"
#import "SOInsectTextLabel.h"
#import "QLTT_DetailVCBase.h"
@interface QLTT_DetailVC_iPad : BaseVC
@property (weak, nonatomic) IBOutlet UILabel *lbl_Title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_subTitle;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *detailView;

@property (weak, nonatomic) IBOutlet UIScrollView *sv_Container;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) QLTT_DetailVCBase *detailVC;
- (void)setConstantForTopGuildLayout:(CGFloat)constant;
- (void)setTitleLabel:(NSString *)title;
- (void)setSubTitleLabel:(NSString *)title;
-(void)reloadData;
-(void)clearData;
@end
