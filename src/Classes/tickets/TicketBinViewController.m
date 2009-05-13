//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketBinViewController.h"
#import "TextWithCountTableViewCell.h"

@implementation TicketBinViewController

- (void)dealloc
{
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
    return 10;
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
    
    // Set up the cell...

    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end

