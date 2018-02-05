//
//  SOSearchBarNew.m
//  TestSearchBar
//
//  Created by NguyenVanTu on 7/31/17.
//  Copyright © 2017 NguyenVanTu. All rights reserved.
//

#import "SOSearchBarTextField.h"

@implementation SOSearchBarTextField
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView];
}
- (void)setupView
{
    [self setFont:[UIFont fontWithName:@"HelveticaNeue" size: 15]];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchIcon"]];
    self.leftView = imgView;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    self.clearButtonMode = UITextFieldViewModeAlways;
}
@end
