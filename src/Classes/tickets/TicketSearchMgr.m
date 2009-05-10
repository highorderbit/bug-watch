//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketSearchMgr.h"

@interface TicketSearchMgr (Private)

- (void)cancelSelected;
- (void)addSelected;
- (void)updateNavigationBarForNotSearching:(BOOL)animated;

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

    [super dealloc];
}

- (id)initWithSearchField:(UITextField *)aSearchField
    addButton:(UIBarButtonItem *)anAddButton
    cancelButton:(UIBarButtonItem *)aCancelButton
    navigationItem:(UINavigationItem *)aNavigationItem
{
    if (self = [super init]) {
        searchField = [aSearchField retain];
        addButton = [anAddButton retain];
        cancelButton = [aCancelButton retain];
        navigationItem = [aNavigationItem retain];

        searchField.delegate = self;
        // Can't be set in IB, so setting it here
        CGRect frame = searchField.frame;
        frame.size.height = 28;
        searchField.frame = frame;
        searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
                
        addButton.target = self;
        addButton.action = @selector(addSelected);
        
        cancelButton.target = self;
        cancelButton.action = @selector(cancelSelected);
        
        [navigationItem setLeftBarButtonItem:nil];
        [self updateNavigationBarForNotSearching:NO];
    }

    return self;
}

- (void)cancelSelected
{
    [searchField resignFirstResponder];
    [self updateNavigationBarForNotSearching:YES];
}

- (void)addSelected
{}

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
    frame.size.width = 245;
    searchField.frame = frame;

    [UIView commitAnimations];

    [navigationItem setRightBarButtonItem:cancelButton animated:YES];
}
    
@end
