//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketBinViewController.h"
#import "TextWithCountTableViewCell.h"
#import "TicketBin.h"

@implementation TicketBinViewController

@synthesize delegate;

- (void)dealloc
{
    [ticketBins release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = 44;
    self.view.frame = viewFrame;
}

#pragma mark UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return [[ticketBins allKeys] count];
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
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    id ticketBinId = [[ticketBins allKeys] objectAtIndex:indexPath.row];
    TicketBin * ticketBin = [ticketBins objectForKey:ticketBinId];

    [cell setText:ticketBin.name];
    [cell setCount:ticketBin.ticketCount];

    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id ticketBinId = [[ticketBins allKeys] objectAtIndex:indexPath.row];
    [delegate ticketBinSelectedWithId:ticketBinId];
}

#pragma mark TicketBinViewController implementation

- (void)setTicketBins:(NSDictionary *)someTicketBins
{
    [someTicketBins retain];
    [ticketBins release];
    ticketBins = someTicketBins;
    
    [self.tableView reloadData];
}

@end
