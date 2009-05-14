//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketSearchMgr.h"

@interface TicketSearchMgr (Private)

- (void)cancelSelected;
- (void)updateNavigationBarForNotSearching:(BOOL)animated;
- (void)initDarkTransparentView;
- (void)searchCurrentText;

@end

@implementation TicketSearchMgr

@synthesize delegate;

- (void)dealloc
{
    [delegate release];

    [searchField release];
    [addButton release];
    [cancelButton release];
    [navigationItem release];
    [binViewController release];
    [parentView release];
    
    [darkTransparentView release];

    [super dealloc];
}

- (id)initWithSearchField:(UITextField *)aSearchField
    addButton:(UIBarButtonItem *)anAddButton
    cancelButton:(UIBarButtonItem *)aCancelButton
    navigationItem:(UINavigationItem *)aNavigationItem
    ticketBinViewController:(TicketBinViewController *)aBinViewController
    parentView:(UIView *)aParentView
    dataSource:(TicketBinDataSource *)aDataSource
{
    if (self = [super init]) {
        searchField = [aSearchField retain];
        addButton = [anAddButton retain];
        cancelButton = [aCancelButton retain];
        navigationItem = [aNavigationItem retain];
        binViewController = [aBinViewController retain];
        parentView = [aParentView retain];
        dataSource = [aDataSource retain];

        searchField.delegate = self;
        // Can't be set in IB, so setting it here
        CGRect frame = searchField.frame;
        frame.size.height = 28;
        searchField.frame = frame;
        searchField.clearButtonMode = UITextFieldViewModeWhileEditing;

        cancelButton.target = self;
        cancelButton.action = @selector(cancelSelected);

        [navigationItem setLeftBarButtonItem:nil];
        [self updateNavigationBarForNotSearching:NO];
        
        [self initDarkTransparentView];
    }

    return self;
}

- (void)initDarkTransparentView
{
    CGRect darkTransparentViewFrame = CGRectMake(0, 44, 320, 480);
    darkTransparentView =
        [[UIView alloc] initWithFrame:darkTransparentViewFrame];
    
    CGRect transparentViewFrame = CGRectMake(0, 0, 320, 480);
    UIView * transparentView =
        [[[UIView alloc] initWithFrame:transparentViewFrame] autorelease];
    transparentView.backgroundColor = [UIColor blackColor];
    transparentView.alpha = 0.8;
    [darkTransparentView addSubview:transparentView];
    
    CGRect activityIndicatorFrame = CGRectMake(142, 45, 37, 37);
    UIActivityIndicatorView * activityIndicator =
        [[UIActivityIndicatorView alloc] initWithFrame:activityIndicatorFrame];
    activityIndicator.activityIndicatorViewStyle =
        UIActivityIndicatorViewStyleWhiteLarge;
    [activityIndicator startAnimating];
    [darkTransparentView addSubview:activityIndicator];
    
    CGRect loadingLabelFrame = CGRectMake(21, 80, 280, 65);
    UILabel * loadingLabel =
        [[[UILabel alloc] initWithFrame:loadingLabelFrame] autorelease];
    loadingLabel.text = @"Loading ticket bins...";
    loadingLabel.textAlignment = UITextAlignmentCenter;
    loadingLabel.font = [UIFont boldSystemFontOfSize:20];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.backgroundColor = [UIColor clearColor];
    [darkTransparentView addSubview:loadingLabel];
}

- (void)cancelSelected
{
    [searchField resignFirstResponder];
    [self updateNavigationBarForNotSearching:YES];
    [darkTransparentView removeFromSuperview];
    [binViewController.view removeFromSuperview];
}

- (void)updateNavigationBarForNotSearching:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone
            forView:searchField cache:YES];
    }

    CGRect frame = searchField.frame;
    frame.size.width = 300;
    searchField.frame = frame;
    
    if (animated)
        [UIView commitAnimations];

    [navigationItem setRightBarButtonItem:addButton animated:animated];
}

#pragma mark UITextFieldDelegate implementation

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone
        forView:searchField cache:YES];

    CGRect frame = searchField.frame;
    frame.size.width = 252;
    searchField.frame = frame;

    [UIView commitAnimations];

    [navigationItem setRightBarButtonItem:cancelButton animated:YES];

    NSLog(@"parent view: %@", parentView);

    [parentView addSubview:darkTransparentView];
    [dataSource fetchAllTicketBins];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"Ticket search text field returning...");
    [self searchCurrentText];

    return YES;
}

#pragma mark TicketBinDataSourceDelegate implementation

- (void)receivedTicketBinsFromDataSource:(NSArray *)someTicketBins
{
    [binViewController setTicketBins:someTicketBins];
    [parentView addSubview:binViewController.view];
}

#pragma mark TicketBinViewControllerDelegate implementation

- (void)ticketBinSelectedWithQuery:(NSString *)query
{
    searchField.text = query;
    [self searchCurrentText];
}

#pragma mark Private helper methods

- (void)searchCurrentText
{
    [delegate ticketsFilteredByFilterString:searchField.text];
    [self cancelSelected];
}

@end
