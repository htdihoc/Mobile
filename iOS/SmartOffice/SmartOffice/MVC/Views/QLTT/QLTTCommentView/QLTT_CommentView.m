//
//  QLTTCommentView.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "QLTT_CommentView.h"
#import "FullWidthSeperatorTableView.h"
#import "BaseSubView.h"
#import "SoInsectTextField.h"
#import "NSString+Util.h"
#import "QLTT_CommentVC.h"
#import "IQKeyboardManager.h"
#define MaxTVHeight 70
#define MinTVHeight 55
#define MaxCharacters 2000
@interface QLTT_CommentView() <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tv_CstHeight;
@property (weak, nonatomic) IBOutlet UIButton *btn_ClearText;


@end
@implementation QLTT_CommentView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tbl_Comments.estimatedRowHeight = 80;
    self.tbl_Comments.rowHeight = UITableViewAutomaticDimension;
    [self.tbl_Comments setSeparatorColor:AppColor_BorderForView];
    self.tv_Comment.placeholder = LocalizedString(@"QLTT_CommentView_Nhập_bình_luận_của_bạn");
    self.tv_Comment.placeholderFont = [UIFont fontWithName:@"HelveticaNeue-Italic" size:15];
    [self.tv_Comment setFont: [UIFont fontWithName:@"HelveticaNeue" size:15]];
    self.tv_Comment.delegate = self;
    self.tv_Comment.layer.cornerRadius = 5;
    self.tv_Comment.layer.borderWidth = 1;
    self.tv_Comment.layer.borderColor = [AppColor_BorderForView CGColor];
    [self.btn_ClearText setHidden:YES];
    [[self.btn_ClearText imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [self.btn_ClearText setTitleColor:AppColor_MainTextColor forState:UIControlStateNormal];
    [self.btn_ClearText setTitleColor:AppColor_HightLightTextColor forState:UIControlStateHighlighted];
    [self setDisableButtonSend];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard:)];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(myNotificationMethod:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hiddenKeyBoard)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
	
    [self.view addGestureRecognizer:tap];
    [self.tv_Comment setTextContainerInset:UIEdgeInsetsMake(8, 5, 8, MinTVHeight)];
    [self setDisableButtonSend];
    [self checkSpaceTableviewWithBottonView];
    [self addBorderTopForSearchView];
}

- (void)addBorderTopForSearchView{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.searchView.bounds.size.width, 1)];
    topView.opaque = YES;
    topView.backgroundColor = CommonColor_LightGray;
    topView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.searchView addSubview:topView];
}


- (void)checkSpaceTableviewWithBottonView {
    if (IS_IPHONE) {
        self.cst_spaceBottomTableView.constant = 0;
    } else {
        self.cst_spaceBottomTableView.constant = 16;
    }
}

- (void)hiddenKeyBoard:(NSNotification *)notification
{
    [self hiddenKeyBoard];
}
- (void)hiddenKeyBoard
{
    self.cst_BottomView.constant = 0;
    self.tv_CstHeight.constant = MinTVHeight;
}
- (void)dismissKeyboard:(UIGestureRecognizer*) recognizer
{
    [self hiddenKeyBoard];
    if ([self.delegate respondsToSelector:@selector(dismissVC:)])
    {
        [self.delegate dismissVC:recognizer];
    }
}

- (IBAction)sendMessage:(id)sender {
    [self.btn_ClearText setHidden:YES];
    [self hiddenKeyBoard];
    NSString *string = self.tv_Comment.text;
    NSString *trimmedString = [string noSpaceString];
    [self.delegate sendComment:trimmedString];
    self.tv_Comment.text = @"";
    [self setDisableButtonSend];
    
}

- (void)myNotificationMethod:(NSNotification*)notification
{
	NSDictionary* keyboardInfo = [notification userInfo];
	NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
	CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
	self.cst_BottomView.constant = keyboardFrameBeginRect.size.height;
}
- (NSInteger)numberOfLine
{
    return self.tv_Comment.contentSize.height/self.tv_Comment.font.lineHeight;
}

- (void)textViewDidChange:(UIPlaceHolderTextView *)textView
{
    if ([self numberOfLine] > 2) {
        self.tv_CstHeight.constant = MaxTVHeight;
    }
    else
    {
        self.tv_CstHeight.constant = MinTVHeight;
    }
    if ([textView.text checkSpace] || textView.text == nil) {
        [self setDisableButtonSend];
        [self.btn_ClearText setHidden:YES];
    }
    else
    {
        [self setEnableButtonSend];
        [self.btn_ClearText setHidden:NO];
//        [_tv_Comment setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [IQKeyboardManager sharedManager].enable = NO;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text checkSpace] || text == nil) {
        [self setDisableButtonSend];
        [self.btn_ClearText setHidden:YES];
    }
    BOOL isValid = textView.text.length + (text.length - range.length) <= MaxCharacters;
    if (!isValid) {
        [self.delegate showError:LocalizedString(@"Không nhập quá 2000 ký tự")];
    }
    return isValid;
}
- (IBAction)clearText:(id)sender {
    self.tv_Comment.text = @"";
    [self setDisableButtonSend];
    self.tv_CstHeight.constant = MinTVHeight;
    [self.btn_ClearText setHidden:YES];
}

- (void)setDisableButtonSend {
    [self.btn_SendMess setEnabled:NO];
    [self.btn_SendMess setImage:[UIImage imageNamed:@"sendMessage.png"] forState:UIControlStateNormal];
    [self.btn_SendMess setAlpha:0.45];
}

- (void)setEnableButtonSend {
    [self.btn_SendMess setEnabled:YES];
    [self.btn_SendMess setImage:[UIImage imageNamed:@"sendMessageEnable.png"] forState:UIControlStateNormal];
    [self.btn_SendMess setAlpha:1];
}
@end
