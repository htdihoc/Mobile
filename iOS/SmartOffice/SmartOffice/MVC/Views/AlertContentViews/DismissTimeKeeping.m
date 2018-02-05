//
//  ContentTimeKeeping.m
//  Alert
//
//  Created by NguyenVanTu on 4/10/17.
//  Copyright © 2017 NguyenVanTu. All rights reserved.
//

#import "DismissTimeKeeping.h"
#import "UIView+BorderView.h"
@interface DismissTimeKeeping ()<UITextViewDelegate>
{
    BOOL _isValid;
}
@property (weak, nonatomic) IBOutlet UIView *container;
@end

@implementation DismissTimeKeeping

#pragma mark LifeCycler
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_tv_Content becomeFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isValid = YES;
    [self setupUI];
    [self addTappGesture];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
    [self.delegate isEmpty:[self.tv_Content.text isEqualToString:@""] ? YES:NO];
}

#pragma mark UI

- (void)setupUI{
    [self.clearButton setHidden:YES];
    self.lbl_Reason.textColor = AppColor_MainTextColor;
    self.lbl_Reason.text = LocalizedString(@"TTNS_DismissTimeKeeping_Lý_do");
    [self.container setBorderForView];
    self.tv_Content.delegate = self;
    if (self.isManager) {
       self.tv_Content.placeholder = LocalizedString(@"Nhập lý do từ chối duyệt công"); 
    }
    else
    {
       self.tv_Content.placeholder = LocalizedString(@"Nhập lý do huỷ chấm công");
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addTappGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark action

- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

#pragma mark UITextViewDelegate


- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self.clearButton setHidden:NO];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.clearButton setHidden:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        // Disable return key in keyboard
        //[textView resignFirstResponder];
        return NO;
    }
    if(textView.text.length + (text.length - range.length)> 256){
        DLog(@"Show Toast");
        [self showToastWithMessage: [NSString stringWithFormat:@"%@ %@", LocalizedString(@"Lý do hủy chấm công"), LocalizedString(@"Không vượt quá 256 ký tự")]];
    }
    return textView.text.length + (text.length - range.length) <= 256;
}

- (IBAction)clearAction:(id)sender {
    self.tv_Content.text = @"";
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"");
}
@end
