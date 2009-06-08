//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ProjectsViewController.h"
#import "TextWithCountTableViewCell.h"

@implementation ProjectsViewController

@synthesize delegate;

- (void)dealloc
{
    [names release];
    [openTicketCounts release];
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
    return names ? [[names allKeys] count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"TextWithCountTableViewCell";

    TextWithCountTableViewCell * cell =
        (TextWithCountTableViewCell *)
        [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray * nib =
            [[NSBundle mainBundle] loadNibNamed:@"TextWithCountTableViewCell"
            owner:self options:nil];

        cell = [nib objectAtIndex:0];
    }

    id key = [[names allKeys] objectAtIndex:indexPath.row];
    NSString * name = [names objectForKey:key];
    NSUInteger openTicketsCount =
        [[openTicketCounts objectForKey:key] intValue];

    [cell setText:name];
    [cell setCount:openTicketsCount];

    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id key = [[names allKeys] objectAtIndex:indexPath.row];
    [delegate selectedProjectKey:key];
}

- (void)setNames:(NSDictionary *)someNames
    openTicketCounts:(NSDictionary *)someOpenTicketCounts
{
    NSDictionary * tempNames = [someNames copy];
    [names release];
    names = tempNames;

    NSDictionary * tempOpenTicketCounts = [someOpenTicketCounts copy];
    [openTicketCounts release];
    openTicketCounts = tempOpenTicketCounts;

    [self.tableView reloadData];
}

@end
