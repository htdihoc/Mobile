//
//  ListRegisterTakeLeave.h
//  SmartOffice
//
//  Created by NguyenDucBien on 5/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_BaseSubView_iPad.h"

@class ListRegisterTakeLeave;
@protocol TTNS_ListTypeOff_iPadDelegate <NSObject>

- (void)passingData:(ListRegisterTakeLeave *)controller didFinishChooseItem:(NSInteger) item;

@end

@interface ListRegisterTakeLeave : TTNS_BaseSubView_iPad <UITableViewDelegate, UITableViewDataSource> {
    NSIndexPath *lastIndex;
    NSInteger currentIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *checkOutListTableview;

@property (nonatomic, weak) id<TTNS_ListTypeOff_iPadDelegate> delegate;

- (void)passDataBack;

@end
