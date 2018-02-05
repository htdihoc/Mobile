//
//  DocView.m
//  SmartOffice
//
//  Created by Kaka on 4/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "DocView.h"

@interface DocView(){
    UIImageView *thumbImage;
    UILabel *lblContent;
}

@end

@implementation DocView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)init
{
    self = [super init];
    if(self){
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    return self;
}

#pragma mark - Main
- (void)setup{
    lblContent = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    lblContent.center = self.center;
    lblContent.textAlignment = NSTextAlignmentCenter;
    lblContent.textColor = [UIColor redColor];
    [self addSubview:lblContent];
    lblContent.text = self.content;
    [self setNeedsDisplay];
}

- (void)setContent:(NSString *)content{
    self.content = content;
    lblContent.text = self.content;
    [self setNeedsDisplay];
}

@end
