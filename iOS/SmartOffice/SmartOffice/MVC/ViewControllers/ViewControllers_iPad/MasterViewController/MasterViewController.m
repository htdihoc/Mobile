//
//  MasterViewController.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 6/12/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "MasterViewController.h"
#import "MasterCell.h"

static NSString *HIGHTLIGHT = @"hightlight";

// image name
static NSString *TABBAR_ITEM_INTEGRATION    = @"integration";
static NSString *TABBAR_ITEM_SOCIAL         = @"social";
static NSString *TABBAR_ITEM_CONVERSATION	= @"conversation";
static NSString *TABBAR_ITEM_CONTACT        = @"contact";
static NSString *TABBAR_ITEM_SETTINGS       = @"setting";
static NSString *TABBAR_ITEM_REMINDER       = @"reminder";
static NSString *TABBAR_ITEM_STORAGE        = @"storage";
static NSString *TABBAR_ITEM_SURVEY         = @"survey";
static NSString *TABBAR_ITEM_PMTC           = @"pmtc";
static NSString *TABBAR_ITEM_KNOWLEDGES     = @"knowledge";
static NSString *TABBAR_ITEM_LOGOUT         = @"logout";

// title
static NSString *TABBAR_TITLE_INTEGRATION   = @"Integration";
static NSString *TABBAR_TITLE_SOCIAL        = @"Social";
static NSString *TABBAR_TITLE_CONVERSATION  = @"Conversation";
static NSString *TABBAR_TITLE_CONTACT       = @"Contact";
static NSString *TABBAR_TITLE_SETTINGS      = @"Settings";
static NSString *TABBAR_TITLE_REMINDER      = @"Reminder";
static NSString *TABBAR_TITLE_STORAGE       = @"KTTS";
static NSString *TABBAR_TITLE_SURVEY        = @"Survey";
static NSString *TABBAR_TITLE_PMTC          = @"PMTC";
static NSString *TABBAR_TITLE_KNOWLEDGES    = @"QLTT";
static NSString *TABBAR_TITLE_LOGOUT        = @"Logout";

@interface MasterViewController () <UITableViewDelegate, UITableViewDataSource> {

}
@property (weak, nonatomic) IBOutlet UIView *view_account;
@property (weak, nonatomic) IBOutlet UITableView *masterTableView;
@property (strong, nonatomic) NSMutableArray *icon_tabbar;
@property (strong, nonatomic) NSMutableArray *title_tabbar;
@property (assign, nonatomic) NSInteger isSelected;

@end

@implementation MasterViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil controllers:(NSMutableArray *)controllers {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.borderWidth = 0;
    self.view_account.backgroundColor = AppColor_MainAppTintColor;
    
    self.isSelected = 0;
    
    self.icon_tabbar = [NSMutableArray arrayWithObjects: TABBAR_ITEM_INTEGRATION, TABBAR_ITEM_SOCIAL, TABBAR_ITEM_CONVERSATION, TABBAR_ITEM_CONTACT, TABBAR_ITEM_SETTINGS, TABBAR_ITEM_REMINDER, TABBAR_ITEM_STORAGE, TABBAR_ITEM_SURVEY, TABBAR_ITEM_PMTC, TABBAR_ITEM_KNOWLEDGES, TABBAR_ITEM_LOGOUT, nil];
    
    self.title_tabbar = [[NSMutableArray alloc] initWithObjects: TABBAR_TITLE_INTEGRATION, TABBAR_TITLE_SOCIAL, TABBAR_TITLE_CONVERSATION, TABBAR_TITLE_CONTACT, TABBAR_TITLE_SETTINGS, TABBAR_TITLE_REMINDER, TABBAR_TITLE_STORAGE, TABBAR_TITLE_SURVEY, TABBAR_TITLE_PMTC, TABBAR_TITLE_KNOWLEDGES, TABBAR_TITLE_LOGOUT, nil];
    
    self.masterTableView.showsVerticalScrollIndicator = NO;
    [self.masterTableView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    self.masterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.icon_tabbar.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MasterCell *masterCell = [tableView dequeueReusableCellWithIdentifier:@"masterCell"];
    if (masterCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MasterCell" owner:self options:nil];
        masterCell = [nib objectAtIndex:0];
    }
    
    if (indexPath.row == self.isSelected) {
        masterCell.image_tabbar.image = [UIImage imageNamed: [NSString stringWithFormat:@"%@_%@", [self.icon_tabbar objectAtIndex:indexPath.row], HIGHTLIGHT]];
    } else {
        masterCell.image_tabbar.image = [UIImage imageNamed:[self.icon_tabbar objectAtIndex:indexPath.row]];
    }
    
    masterCell.name_tabbar.text = [self.title_tabbar objectAtIndex:indexPath.row];
    masterCell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return masterCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.isSelected = indexPath.row;
    [self.masterTableView reloadData];
    [self.delegate selectFuntioninTab:(int)indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
