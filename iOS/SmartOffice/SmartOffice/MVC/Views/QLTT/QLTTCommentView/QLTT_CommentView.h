//
//  QLTTCommentView.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSubView.h"
#import "FullWidthSeperatorTableView.h"
#import "UIView+BorderView.h"
#import "SoInsectTextField.h"
#import "UIPlaceHolderTextView.h"
@protocol QLTT_CommentViewDelegate <NSObject>
- (void)sendComment:(NSString *)Comment;
- (void)dismissVC:(UIGestureRecognizer *)recognizer;
- (void)showError:(NSString *)errorContent;
@end
@interface QLTT_CommentView : BaseSubView
@property (weak, nonatomic) IBOutlet UITableView *tbl_Comments;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *tv_Comment;
@property (weak, nonatomic) id<QLTT_CommentViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btn_SendMess;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_BottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_spaceBottomTableView;

@property (weak, nonatomic) IBOutlet UIView *searchView;


@end
