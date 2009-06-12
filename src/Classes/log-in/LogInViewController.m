//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LogInViewController.h"

static const int NUM_CREDENTIAL_ROWS = 3;
enum CredentialRows
{
    kAccountRow,
    kUsernameRow,
    kPasswordRow
};

@interface LogInViewController ()

@property (nonatomic, retain) UITableView * tableView;

@property (nonatomic, retain) UIBarButtonItem * logInButton;
@property (nonatomic, retain) UIBarButtonItem * cancelButton;

@property (nonatomic, retain) UITableViewCell * accountCell;
@property (nonatomic, retain) UITableViewCell * usernameCell;
@property (nonatomic, retain) UITableViewCell * passwordCell;

@property (nonatomic, retain) UITextField * accountTextField;
@property (nonatomic, retain) UITextField * usernameTextField;
@property (nonatomic, retain) UITextField * passwordTextField;


- (void)userDidSave;
- (void)userDidCancel;

@end

@implementation LogInViewController

@synthesize delegate, tableView;
@synthesize logInButton, cancelButton;
@synthesize accountCell, usernameCell, passwordCell;
@synthesize accountTextField, usernameTextField, passwordTextField;

- (void)dealloc
{
    self.delegate = nil;

    self.tableView = nil;

    self.logInButton = nil;
    self.cancelButton = nil;

    self.accountCell = nil;
    self.usernameCell = nil;
    self.passwordCell = nil;

    self.accountTextField = nil;
    self.usernameTextField = nil;
    self.passwordTextField = nil;

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.logInButton.target = self;
    self.logInButton.action = @selector(userDidSave);
    self.logInButton.enabled = NO;

    self.cancelButton.target = self;
    self.cancelButton.action = @selector(userDidCancel);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.accountTextField becomeFirstResponder];
}

#pragma mark UITableViewDelegate implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return NUM_CREDENTIAL_ROWS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case kAccountRow:
            return self.accountCell;
        case kUsernameRow:
            return self.usernameCell;
        case kPasswordRow:
            return self.passwordCell;
    }

    return nil;
}

- (NSString *)tableView:(UITableView *)tableView
titleForFooterInSection:(NSInteger)section
{
    NSString * account = self.accountTextField.text;

    if (account.length == 0)
        account = self.accountTextField.placeholder;

    return [NSString stringWithFormat:@"https://%@.lighthouseapp.com", account];
}

#pragma mark UITextFieldDelegate implementation

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string
{
    NSString * account = self.accountTextField.text;
    NSString * username = self.usernameTextField.text;
    NSString * password = self.passwordTextField.text;

    if (textField == self.accountTextField) {
        account = [account stringByReplacingCharactersInRange:range
                                                   withString:string];
        [self.tableView reloadData];
    } else if (textField == self.usernameTextField)
        username = [username stringByReplacingCharactersInRange:range
                                                     withString:string];
    else if (textField == self.passwordTextField)
        password = [password stringByReplacingCharactersInRange:range
                                                     withString:string];
   

    logInButton.enabled = account.length && username.length && password.length;

    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == self.accountTextField)
        [self.tableView reloadData];

    logInButton.enabled = NO;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.accountTextField) {
        [self.usernameTextField becomeFirstResponder];
        return YES;
    } else if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
        return YES;
    } else if (textField == self.passwordTextField) {
        NSString * account = self.accountTextField.text;
        NSString * username = self.usernameTextField.text;
        NSString * password = self.passwordTextField.text;

        if (account.length && username.length && password.length) {
            [self userDidSave];
            return YES;
        } else
            return NO;
    }

    return NO;
}

#pragma mark Handling user actions

- (void)userDidSave
{
    [delegate userDidProvideAccount:self.accountTextField.text
                           username:self.usernameTextField.text
                           password:self.passwordTextField.text];
}

- (void)userDidCancel
{
    [delegate userDidCancel];
}

@end
