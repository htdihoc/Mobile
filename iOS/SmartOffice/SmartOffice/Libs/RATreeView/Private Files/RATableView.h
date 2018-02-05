//
//  RATableView.h
//  Pods
//
//  Created by Rafal Augustyniak on 15/11/15.
//
//


#import <UIKit/UIKit.h>
#import "FullWidthSeperatorTableView.h"

@interface RATableView : FullWidthSeperatorTableView

@property (nonatomic, nullable, weak) id<UITableViewDelegate> tableViewDelegate;
@property (nonatomic, nullable, weak) id<UIScrollViewDelegate> scrollViewDelegate;

@end
