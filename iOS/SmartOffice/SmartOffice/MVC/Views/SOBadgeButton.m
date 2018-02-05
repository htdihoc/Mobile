//
//  SONoteLabel.m
//  SmartOffice
//
//  Created by Kaka on 4/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOBadgeButton.h"

@implementation SOBadgeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    self.userInteractionEnabled = NO;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.borderWidth    = 0.0;
        self.cornerRadious  = 0.0;
       // [self customInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [self customInit];
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    [self setNeedsDisplay];
}


- (void)prepareForInterfaceBuilder {
    
    [self customInit];
}

- (void)customInit {
    self.layer.cornerRadius = self.cornerRadious;
    self.layer.borderWidth = self.borderWidth;
    [self setTitle:self.content forState:UIControlStateNormal];
    if (self.cornerRadious > 0) {
        //self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
    }
}

#pragma mark - Overide Variable
- (void)setContent:(NSString *)content{
    _content = content;
    [self setTitle:self.content forState:UIControlStateNormal];
}
- (void)setCornerRadious:(CGFloat)cornerRadious{
    _cornerRadious = cornerRadious;
    self.layer.cornerRadius = self.cornerRadious;

}
@end
