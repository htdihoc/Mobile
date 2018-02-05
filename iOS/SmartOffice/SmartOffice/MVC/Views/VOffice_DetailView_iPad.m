//
//  VOffice_DetailView_iPad.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_DetailView_iPad.h"

@implementation VOffice_DetailView_iPad

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.topView.backgroundColor = UIColorFromHex(0xf3f4f9);
    self.tbl_Detail.estimatedRowHeight = 80;
    self.tbl_Detail.rowHeight = UITableViewAutomaticDimension;
    [self.btn_VOffice setTitleColor:AppColor_MainAppTintColor forState:UIControlStateNormal];
    [self.btn_VOffice setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    self.btn_VOffice.titleLabel.font = [UIFont systemFontOfSize:14];
    self.btn_VOffice.backgroundColor = [UIColor clearColor];
    [self.btn_VOffice setTitle:LocalizedString(@"kVOFF_GOTO_VOFFICE_TITLE_BUTTON") forState:UIControlStateNormal];
}


- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
 
    return  self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    if (CGRectIsEmpty(frame)) {
        self.bounds = self.view.bounds;
    }
    
    return self;
}


- (void) setup;
{
    self.view = [[[NSBundle mainBundle] loadNibNamed:@"VOffice_DetailView_iPad" owner:self options:nil] firstObject];
    
    self.view.frame = self.bounds;
    
    [self addSubview:self.view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [self.tbl_Detail addGestureRecognizer:tap];
}
- (void)didTapOnTableView:(UIGestureRecognizer*) recognizer
{
    CGPoint tapLocation = [recognizer locationInView:self.tbl_Detail];
    NSIndexPath *indexPath = [self.tbl_Detail indexPathForRowAtPoint:tapLocation];
    
    if (indexPath) { //we are in a tableview cell, let the gesture be handled by the view
        recognizer.cancelsTouchesInView = NO;
    }
    [self endEditView];
}
- (void)endEditView
{
    
}
- (IBAction)showVOffice:(id)sender {
    [self didSelectVOffice];
}

- (void)didSelectVOffice
{
    
}
#pragma UITableViewDatasouece
@end
