//
//  TPMapDisclosureViewController.m
//  explorer
//
//  Created by Kosuke Hata on 12/23/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "TPMapDisclosureViewController.h"

@interface TPMapDisclosureViewController ()

@end

@implementation TPMapDisclosureViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[KHBase getCurrentCGRect]];
    view.backgroundColor = [UIColor whiteColor];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Location";
	// Do any additional setup after loading the view.
    
    CGSize size = CGSizeMake(self.width, self.barSize);
    UIColor *color = [UIColor colorWithRed:0.2 green:0.3 blue:0.4 alpha:1.0];
    KHButton *button = [[KHButton alloc] initWithButtonSize:size
                                                  withColor:color
                                                  withTitle:@"delete!"];
    button.frame = CGRectMake(0, self.height-self.barSize, self.width, self.barSize);
    button.delegate = self;
    
    //    [self.view addSubview:button];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonWasTouchedUpInside:(KHButton *)button
{
    
}

#pragma mark - UITableViewCell Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"CellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
