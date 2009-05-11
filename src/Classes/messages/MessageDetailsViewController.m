//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "MessageDetailsViewController.h"

@implementation MessageDetailsViewController

- (void)dealloc
{
    [headerView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationItem setRightBarButtonItem:self.editButtonItem
        animated:NO];

    self.tableView.tableHeaderView = headerView;
}

#pragma mark UITableViewDelegate implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell * cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...

    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end

