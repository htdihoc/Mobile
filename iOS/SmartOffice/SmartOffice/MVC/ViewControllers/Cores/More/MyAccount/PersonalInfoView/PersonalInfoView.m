//
//  PersonalInfoView.m
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 4/16/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "PersonalInfoView.h"

@implementation PersonalInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self.imgAvatar setImage:[UIImage imageNamed:@"icon_avt_default"]];
}

+ (NSString *)identifier {
    return @"PersonalInfoViewIdentifier";
}

@end
