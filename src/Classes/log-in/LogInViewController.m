//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()

@property (nonatomic, retain) UIBarButtonItem * logInButton;
@property (nonatomic, retain) UIBarButtonItem * cancelButton;

@end

@implementation LogInViewController

@synthesize delegate, logInButton, cancelButton;

- (void)dealloc
{
    self.delegate = nil;
    self.logInButton = nil;
    self.cancelButton = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    self.logInButton.target = self;
    self.logInButton.action = @selector(userDidSave);
    self.logInButton.enabled = NO;

    self.cancelButton.target = self;
    self.cancelButton.action = @selector(userDidCancel);

    [super viewDidLoad];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

#pragma mark UITableViewDelegate implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark Handling user actions

- (void)userDidSave
{
    [delegate userDidProvideAccount:nil username:nil password:nil];
}

- (void)userDidCancel
{
    [delegate userDidCancel];
}

@end
