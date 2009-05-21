//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ItemSelectionTableViewController.h"
#import "UIColor+BugWatchColors.h"
#import "HOTableViewCell.h"

@interface ItemSelectionTableViewController (Private)

- (NSArray *)sortedKeys;
- (void)doneSelected;
- (void)cancelSelected;

@end

@implementation ItemSelectionTableViewController

@synthesize selectedItem;
@synthesize target, action;

- (void)dealloc
{
    [items release];
    [labelText release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor bugWatchBackgroundColor];

    UIBarButtonItem * doneButton = [[[UIBarButtonItem alloc] init] autorelease];
    doneButton.title = @"Done";
    doneButton.target = self;
    doneButton.action = @selector(doneSelected);
    [self.navigationItem setRightBarButtonItem:doneButton];
    doneButton.style = UIBarButtonItemStyleDone;

    UIBarButtonItem * cancelButton =
        [[[UIBarButtonItem alloc] init] autorelease];
    cancelButton.title = @"Cancel";
    cancelButton.target = self;
    cancelButton.action = @selector(cancelSelected);
    [self.navigationItem setLeftBarButtonItem:cancelButton];
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
    

    id itemAtIndexPath = [[self sortedKeys] objectAtIndex:indexPath.row];
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
    self.selectedItem = [[self sortedKeys] objectAtIndex:indexPath.row];
    [aTableView reloadData];
}

- (NSString *)tableView:(UITableView *)aTableView
    titleForHeaderInSection:(NSInteger)section
{
    return [labelText isEqual:@""] ? nil : labelText;
}

#pragma mark UITableViewDelegate implementation

- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView
    accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    id itemAtIndexPath = [[self sortedKeys] objectAtIndex:indexPath.row];
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

#pragma mark ItemSelectionTableViewController implementation

- (NSArray *)sortedKeys
{
    return [[items allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

- (void)doneSelected
{
    NSMethodSignature * sig =
        [[target class] instanceMethodSignatureForSelector:action];
    NSInvocation * invocation =
        [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:target];
    [invocation setSelector:action];
    [invocation setArgument:&selectedItem atIndex:2];
    [invocation retainArguments];
    [invocation invoke];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelSelected
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
