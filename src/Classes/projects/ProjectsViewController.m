//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ProjectsViewController.h"

@implementation ProjectsViewController

- (void)dealloc
{
    [super dealloc];
}

#pragma mark UITableViewDataSource implementationp

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"ProjectTableViewCell";
    
    UITableViewCell * cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray * nib =
            [[NSBundle mainBundle] loadNibNamed:@"ProjectTableViewCell"
            owner:self options:nil];

        cell = [nib objectAtIndex:0];
    }

    // Set up the cell...

    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end

