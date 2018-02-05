//
//  DiscussionListVC.m
//  SmartOffice
//
//  Created by NguyenDucBien on 5/17/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "DiscussionListVC.h"

@interface DiscussionListVC () {
    NSMutableArray *nameAcount;
    NSMutableArray *status;
}

@property (weak, nonatomic) IBOutlet UITableView *discussionListTable;

@end

@implementation DiscussionListVC

- (void)viewDidLoad {
    [super viewDidLoad];
	// This will remove extra separators from tableview
	self.discussionListTable.tableFooterView = [UIView new];
	// Force your tableview margins (this may be a bad idea)
	if ([self.discussionListTable respondsToSelector:@selector(setSeparatorInset:)]) {
		[self.discussionListTable setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([self.discussionListTable respondsToSelector:@selector(setLayoutMargins:)]) {
		[self.discussionListTable setLayoutMargins:UIEdgeInsetsZero];
	}
    nameAcount = [[NSMutableArray alloc] initWithObjects:@"AnhPH", @"HoangPX", @"TuanNA", @"LuanNH", @"HanhNK", @"MyNT", nil];
    status = [[NSMutableArray alloc] initWithObjects:@"Ký duyệt", @"Ký duyệt", @"Người trình ký", @"Người trình ký", @"Người trình ký", @"Ký duyệt", nil];
    [self setButtonExchange];
    [self.btnDiscussionList setTitle:LocalizedString(@"Danh sách thảo luận Tờ trình") forState:UIControlStateNormal];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setButtonExchange {
    [_btnExchange setTitle:@"Trao đổi" forState:UIControlStateNormal];
    [_btnExchange setTintColor:[UIColor whiteColor]];
}


#pragma mark Tableview Datasource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return nameAcount.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ListDetailCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
    
    cell.delegate = self;
    cell.lbName.text = [NSString stringWithFormat:@"%@", nameAcount[indexPath.row]];
    cell.lbPosition.text = [NSString stringWithFormat:@"%@", status[indexPath.row]];
    cell.indexPath = indexPath;
	cell.layoutMargins = UIEdgeInsetsZero;
	cell.preservesSuperviewLayoutMargins = NO;
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

//Button Action

- (void)deleteCell:(NSIndexPath *)indexPath {
    [nameAcount removeObjectAtIndex:indexPath.row];
    [status removeObjectAtIndex:indexPath.row];
    [self.discussionListTable reloadData];
}

- (void)didPressButtonAtCell:(NSIndexPath *)indexPath {
    [self deleteCell:indexPath];
}

- (IBAction)actionExchange:(id)sender {
    
}

- (IBAction)btnCloseAction:(id)sender {
    if (self.delegate) {
        [self.delegate dismissVC];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (IBAction)actionDismisList:(id)sender {
    if (self.delegate) {
        [self.delegate dismissVC];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



@end
