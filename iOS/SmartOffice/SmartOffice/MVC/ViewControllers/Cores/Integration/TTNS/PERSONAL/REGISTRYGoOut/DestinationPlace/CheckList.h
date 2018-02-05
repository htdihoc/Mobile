//
//  CheckList.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseListView.h"


@class CheckList;

@protocol CheckListDelegate <NSObject>

- (void) didFinishChoiseWorkPlace:(CheckList*)vc workPlaceId:(NSInteger)workPlaceId address:(NSString*)address;

@end

@interface CheckList : BaseListView {

}

@property (weak, nonatomic) id<CheckListDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *lastIndex;
@property (assign, nonatomic) NSInteger indexSelect;

//- (void)passingString;

- (void)putBackData;


@end
