//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ItemSelectionTableViewController.h"
#import "UIColor+BugWatchColors.h"
#import "HOTableViewCell.h"

@implementation ItemSelectionTableViewController

@synthesize selectedItem;

- (void)dealloc
{
    [items release];
    [labelText release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor bugWatchBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return items ? [[items allKeys] count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"Cell";
    
    UITableViewCell * cell =
        [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell =
            [[[HOTableViewCell alloc]
            initWithFrame:CGRectZero reuseIdentifier:cellIdentifier
            tableViewStyle:UITableViewStyleGrouped]
            autorelease];
    }
    
    id itemAtIndexPath = [[items allKeys] objectAtIndex:indexPath.row];
    cell.text = [items objectForKey:itemAtIndexPath];
    cell.textColor =
        [itemAtIndexPath isEqual:selectedItem] ?
        [UIColor bugWatchCheckedColor] : [UIColor blackColor];

    return cell;
}

- (void)tableView:(UITableView *)aTableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedItem = [[items allKeys] objectAtIndex:indexPath.row];
    [aTableView reloadData];
}

- (NSString *)tableView:(UITableView *)aTableView
    titleForHeaderInSection:(NSInteger)section
{
    return labelText;
}

#pragma mark UITableViewDelegate implementation

- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView
    accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    id itemAtIndexPath = [[items allKeys] objectAtIndex:indexPath.row];
    return [itemAtIndexPath isEqual:selectedItem] ?
        UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (void)setItems:(NSDictionary *)someItems
{
    NSDictionary * tempItems = [someItems copy];
    [items release];
    items = tempItems;
}

- (void)setLabelText:(NSString *)text
{
    NSString * tempText = [text copy];
    [labelText release];
    labelText = tempText;
}

@end
