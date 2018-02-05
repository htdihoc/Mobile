//
//  SOErrorView.h
//  SmartOffice
//
//  Created by Kaka on 4/12/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SONoteButton;
@class SOErrorView;
@protocol SOErrorViewDelegate <NSObject>
@required
- (void)didRefreshOnErrorView:(SOErrorView *)errorView;

@end

@interface SOErrorView : UIView{
    
}

@property (weak, nonatomic) IBOutlet UILabel *lblErrorInfo;
@property (weak, nonatomic) IBOutlet SONoteButton *btnTyAgain;
@property (weak, nonatomic) id <SOErrorViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame inforError:(NSString *)errorInfo;
- (void)setErrorInfo:(NSString *)error;

@end
