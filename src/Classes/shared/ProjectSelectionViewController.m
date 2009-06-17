//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ProjectSelectionViewController.h"
#import "UIColor+BugWatchColors.h"

@interface ProjectSelectionViewController (Private)

- (void)cancelSelected;

@end

@implementation ProjectSelectionViewController

@synthesize projects;
@synthesize target, action;

- (void)dealloc
{
    [projects release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.backgroundColor = [UIColor bugWatchBackgroundColor];
    self.navigationItem.title = @"Select Project";
    
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] init];
    cancelButton.title = @"Cancel";
    cancelButton.target = self;
    cancelButton.action = @selector(cancelSelected);
    [self.navigationItem setLeftBarButtonItem:cancelButton];
}

#pragma mark TableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return [[projects allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"UITableViewCell";
    
    UITableViewCell * cell =
        [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell =
            [[[UITableViewCell alloc]
            initWithFrame:CGRectZero reuseIdentifier:cellIdentifier]
            autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    id projectKey = [[projects allKeys] objectAtIndex:indexPath.row];
    NSString * project = [projects objectForKey:projectKey];

#if defined (__IPHONE_3_0)

    cell.textLabel.text = project;

#else

    cell.text = project;

#endif
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMethodSignature * sig =
        [[target class] instanceMethodSignatureForSelector:action];
    NSInvocation * invocation =
        [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:target];
    [invocation setSelector:action];
    id key = [[projects allKeys] objectAtIndex:indexPath.row];
    [invocation setArgument:&key atIndex:2];
    [invocation retainArguments];
    [invocation invoke];
}

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section
{
    return @"Please select a project";
}

#pragma mark ProjectSelectionViewController implementation

- (void)cancelSelected
{
    [self dismissModalViewControllerAnimated:YES];
}

@end

