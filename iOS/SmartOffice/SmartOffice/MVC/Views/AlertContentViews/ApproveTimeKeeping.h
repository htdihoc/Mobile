//
//  ApproveTimeKeeping.h
//  SmartOffice
//
//  Created by NguyenVanTu on 6/23/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ApproveTimeKeepingDelegate <NSObject>
- (void)selectedReject;
- (void)selectedAccept;
@end
@interface ApproveTimeKeeping : UIViewController
@property (weak, nonatomic) id<ApproveTimeKeepingDelegate>delegate;
@end
