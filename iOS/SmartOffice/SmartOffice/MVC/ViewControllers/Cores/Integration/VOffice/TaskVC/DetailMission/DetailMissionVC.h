//
//  DetailMissionVC.h
//  SmartOffice
//
//  Created by Kaka on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseVC.h"
@class  MissionModel;

@interface DetailMissionVC : TTNS_BaseVC<UITableViewDataSource>{
	
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginTop;

@property (weak, nonatomic) IBOutlet UITableView *tblContent;

@property (assign, nonatomic) NSInteger *segmentCurrent;

//Passing data
@property (strong, nonatomic) MissionModel *missionModel;;

@property (strong, nonatomic) NSString *subTitle;
@end
