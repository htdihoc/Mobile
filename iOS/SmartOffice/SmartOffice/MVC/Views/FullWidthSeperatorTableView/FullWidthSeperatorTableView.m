//
//  FullWidthSeperatorTableView.m
//  SmartOffice
//
//  Created by Nguyen Van Tu on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "FullWidthSeperatorTableView.h"

@implementation FullWidthSeperatorTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setupSeperatorLine];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupSeperatorLine];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSeperatorLine];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSeperatorLine];
    }
    return self;
}
//- (void)layoutSubviews{
//	[super layoutSubviews];
//	[self setupSeperatorLine];
//}
- (void)setupSeperatorLine
{
	//self.separatorColor = RGBA(170, 170, 170, 0.5);
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Remove seperator inset
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [self setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
