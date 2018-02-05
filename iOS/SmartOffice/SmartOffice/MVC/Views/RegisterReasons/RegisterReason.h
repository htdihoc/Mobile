//
//  RegisterReason.h
//  RegisterReason
//
//  Created by NguyenDucBien on 4/17/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReasonContentCell.h"
#import "FullWidthSeperatorTableView.h"
@class RegisterReason;

@protocol RegisterReasonDelegate <NSObject>

- (void) didFinishSelectReason:(RegisterReason *)vc reasonID:(NSInteger)reasonID title:(NSString*)title;

@end

@interface RegisterReason : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    
}

@property (weak, nonatomic) id<RegisterReasonDelegate> delegate;

- (void)passDataString:(NSInteger)index;


@end
