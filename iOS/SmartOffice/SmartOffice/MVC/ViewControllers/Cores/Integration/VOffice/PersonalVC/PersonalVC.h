//
//  PersonalVC.h
//  SmartOffice
//
//  Created by Kaka on 4/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BaseVC.h"
#import <Foundation/Foundation.h>

@interface PersonalVC : BaseVC<UITableViewDelegate, UITableViewDataSource>{
    
}

@property (weak, nonatomic) IBOutlet UITableView *tblContentView;

- (void)loadData;

@end
