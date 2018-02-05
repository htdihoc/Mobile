//
//  SearchHandler_iPad.h
//  SmartOffice
//
//  Created by NguyenDucBien on 5/12/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChooseHandler;
@protocol ChooseHandlerDelegate <NSObject>

- (void) passingString:(ChooseHandler *)controller didFinishChooseItem:(NSString *) item;

@end

@interface SearchHandler_iPad : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSIndexPath *lastIndex;
    NSInteger indexString;
}


@property (weak, nonatomic) IBOutlet UITableView *checkOutHandlerTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarTool;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (nonatomic, weak) id<ChooseHandlerDelegate> delegate;
- (IBAction)actionClose:(id)sender;
- (void)passDataBack;
@end
