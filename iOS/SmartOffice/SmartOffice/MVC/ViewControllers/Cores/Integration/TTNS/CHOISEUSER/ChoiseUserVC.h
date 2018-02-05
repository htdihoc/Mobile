//
//  ChoiseUserVC.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/20/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseVC.h"

@protocol userIdChoiseDelegate <NSObject>
@optional
-(void) choiseUserId:(NSInteger)ID;
@end

@interface ChoiseUserVC : TTNS_BaseVC{
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) id<userIdChoiseDelegate> delegate;
@end
