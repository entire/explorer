//
//  TPProfileViewController.m
//  explorer
//
//  Created by Kosuke Hata on 12/11/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "TPProfileViewController.h"
#import "TPUserManager.h"
#import "UIViewController+MMDrawerController.h"

@interface TPProfileViewController ()

@end

@implementation TPProfileViewController
{
    BOOL drawerIsOpen;
}

- (id)init
{
    self = [super init];
    if (self) {
        drawerIsOpen = NO;
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[KHBase getCurrentCGRect]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.width, self.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [view addSubview:self.tableView];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"Users";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_icon"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(openMenu:)];
    [[TPUserManager sharedStore] fetchAllUsersWithCompletion:^(BOOL finished, NSArray *users) {

        self.users = [NSMutableArray arrayWithArray:users];
        [self.tableView reloadData];
    }];

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Target Action Methods

- (void)openMenu:(id)sender
{
    if (!drawerIsOpen) {
        [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            drawerIsOpen = YES;
        }];
    } else {
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            drawerIsOpen = NO;
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewCell Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"CellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    PFUser *user = self.users[indexPath.row];
    
    cell.textLabel.text = user.username;
    cell.detailTextLabel.text = user[@"email"];
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
