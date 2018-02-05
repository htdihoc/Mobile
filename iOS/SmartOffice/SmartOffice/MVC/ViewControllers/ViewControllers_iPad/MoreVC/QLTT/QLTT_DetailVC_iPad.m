//
//  QLTT_DetailVC_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/24/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "QLTT_DetailVC_iPad.h"
#import "UIView+BorderView.h"
#import "NSString+SizeOfString.h"

@interface QLTT_DetailVC_iPad () <PassingMasterDocumentModel>
{
    CGFloat _margin;
    CGSize _screenSize;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_topGuildLayout;

@end

@implementation QLTT_DetailVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    _screenSize = screenRect.size;
    _margin = 8;
    self.detailVC = [[QLTT_DetailVCBase alloc] init];
    [self displayVC:self.detailVC container:self.detailView];
    [self setupForTitle];
	[self addLeftAndRightRecognizer];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self endEditCommentView];
}
- (void)addLeftAndRightRecognizer
{
	UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
	swipeleft.direction=UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:swipeleft];
	
	UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
	swiperight.direction=UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:swiperight];
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self.detailVC swipeleft];
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self.detailVC swiperight];
}
- (void)endEditCommentView
{
	[_detailVC endEditCommentView];
}
- (void)setConstantForTopGuildLayout:(CGFloat)constant
{
    self.cst_topGuildLayout.constant = constant;
}
- (void)setTitleLabel:(NSString *)title
{
    [self.sv_Container setScrollEnabled:NO];
    self.lbl_Title.text = title;
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.containerView.frame.size.height > _screenSize.height*0.5) {
        [[self sv_Container] setScrollEnabled:YES];
    }
}
- (CGFloat)getSpaceLinesHeight:(CGFloat)height font:(UIFont *)font
{
    NSInteger numberOfLines = height/font.lineHeight;
    if (numberOfLines > 1) {
        if (numberOfLines < 3) {
            return 20;
        }
        else
        {
            return 28;
        }
    }
    return 0;
}
- (void)setSubTitleLabel:(NSString *)title
{
    self.lbl_subTitle.text = title;
}

- (void)setupForTitle
{
    [self.topView setRectBorderForView];
    self.lbl_Title.numberOfLines = 0;
    self.lbl_subTitle.numberOfLines = 1;
    self.topView.backgroundColor = UIColorFromHex(0xf3f4f9);
    self.lbl_Title.text = @"";
}
- (void)reloadData
{
    //44 is size of title
    [self.detailVC createUI:0];
    
    
}

- (CGFloat)getHeight:(NSString *)text font:(UIFont *)font
{
    return [text findHeightForText:self.view.frame.size.width andFont:font].height;
}

-(void)clearData
{
    
}

@end
