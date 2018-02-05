//
//  DiscussionListVC.h
//  SmartOffice
//
//  Created by NguyenDucBien on 5/17/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListDetailCell.h"

@protocol DiscussionListVCDelegate
- (void)dismissVC;
@end

@interface DiscussionListVC : UIViewController <UITableViewDelegate, UITableViewDataSource, DiscussionListDelegate> {
    NSUInteger *currentIndex;
}

@property (weak, nonatomic) IBOutlet UIButton *btnDiscussionList;

@property (weak, nonatomic) IBOutlet UIButton *btnExchange;

@property (weak, nonatomic) id<DiscussionListVCDelegate> delegate;

- (IBAction)actionExchange:(id)sender;
- (IBAction)btnCloseAction:(id)sender;
- (IBAction)actionDismisList:(id)sender;


@end
