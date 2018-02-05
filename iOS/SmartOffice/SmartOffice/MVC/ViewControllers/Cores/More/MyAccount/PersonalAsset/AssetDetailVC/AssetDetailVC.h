//
//  AssetDetailVC.h
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 4/6/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BaseVC.h"

@interface AssetDetailVC : BaseVC<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tbAssetDetail;

@end
