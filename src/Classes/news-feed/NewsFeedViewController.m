//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "NewsFeedItem.h"
#import "NewsFeedTableViewCell.h"

@implementation NewsFeedViewController

@synthesize delegate, newsItems;

- (void)dealloc
{
    [newsItems release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    newsItems = nil;
    [delegate viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSLog(@"News feed view controller will appear.");

    [delegate viewWillAppear];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tv
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsFeedItem * item = [newsItems objectAtIndex:indexPath.row];
    return [NewsFeedTableViewCell heightForContent:item];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tv
 numberOfRowsInSection:(NSInteger)section
{
    return newsItems.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"NewsFeedTableViewCell";

    NewsFeedTableViewCell * cell = (NewsFeedTableViewCell *)
        [tv dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        NSArray * nib =
        [[NSBundle mainBundle]
          loadNibNamed:@"NewsFeedTableViewCell"
                 owner:self
               options:nil];

        cell = [nib objectAtIndex:0];
    }

    cell.newsFeedItem = [newsItems objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tv
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [delegate userDidSelectNewsItem:[newsItems objectAtIndex:indexPath.row]];
}

#pragma mark Accessors

- (void)setNewsItems:(NSArray *)items
{
    NSArray * tmp = [items copy];
    [newsItems release];
    newsItems = tmp;

    [self.tableView reloadData];
}

@end
