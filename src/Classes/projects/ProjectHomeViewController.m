//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ProjectHomeViewController.h"
#import "ProjectHomeTableViewCell.h"
#import "UIColor+BugWatchColors.h"

@implementation ProjectHomeViewController

@synthesize delegate;

#pragma mark TableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"ProjectHomeTableViewCell";
    
    ProjectHomeTableViewCell * cell =
        (ProjectHomeTableViewCell *)
        [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray * nib =
            [[NSBundle mainBundle] loadNibNamed:@"ProjectHomeTableViewCell"
            owner:self options:nil];

        cell = [nib objectAtIndex:0];
    }
    
    switch (indexPath.row)
    {
        case kProjectHome:
            [cell setLabelText:@"Home"];
            [cell setImage:[UIImage imageNamed:@"HomeIcon.png"]];
            [cell
                setHighlightedImage:
                [UIImage imageNamed:@"HomeIconSelected.png"]];
            break;
        case kProjectTickets:
            [cell setLabelText:@"Tickets"];
            [cell setImage:[UIImage imageNamed:@"Bug.png"]];
            [cell setHighlightedImage:[UIImage imageNamed:@"BugSelected.png"]];
            break;
        case kProjectMilestones:
            [cell setLabelText:@"Milestones"];
            [cell setImage:[UIImage imageNamed:@"Calendar.png"]];
            [cell
                setHighlightedImage:
                [UIImage imageNamed:@"CalendarSelected.png"]];
            break;
        case kProjectMessages:
            [cell setLabelText:@"Messages"];
            [cell setImage:[UIImage imageNamed:@"Thumbtack.png"]];
            [cell
                setHighlightedImage:
                [UIImage imageNamed:@"ThumbtackSelected.png"]];
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end

