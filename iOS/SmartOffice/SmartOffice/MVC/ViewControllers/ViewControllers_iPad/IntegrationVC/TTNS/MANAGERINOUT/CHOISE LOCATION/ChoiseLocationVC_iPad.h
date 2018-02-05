//
//  ChoiseLocationVC_iPad.h
//  SmartOffice
//
//  Created by Administrator on 5/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullWidthSeperatorTableView.h"
#import "ReasonContentCell.h"

@class ChoiseLocationVC_iPad;

@protocol ChoiseLocationDelegate <NSObject>

- (void) passingLocation:(ChoiseLocationVC_iPad *)controller didFinishSelectItem:(NSString *)item;

@end

@interface ChoiseLocationVC_iPad : UIViewController{
    
}

@property (weak, nonatomic) id<ChoiseLocationDelegate> delegate;

@property (weak, nonatomic) IBOutlet FullWidthSeperatorTableView *tableView;

@end
