//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LogInViewController.h"

static const int NUM_SECTIONS = 2;
enum Sections
{
    kAccountSection,
    kCredentialsSection
};

static const int NUM_ACCOUNT_ROWS = 1;
enum AccountRows
{
    kAccountRow
};

static const int NUM_CREDENTIAL_ROWS = 2;
enum CredentialRows
{
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

- (void)resetForm;
- (void)enableForm;
- (void)disableForm;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self resetForm];
}

#pragma mark UITableViewDelegate implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSInteger nrows = 0;

    switch (section) {
        case kAccountSection:
            nrows = NUM_ACCOUNT_ROWS;
            break;
        case kCredentialsSection:
            nrows = NUM_CREDENTIAL_ROWS;
            break;
    }

    return nrows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case kAccountSection:
            switch (indexPath.row) {
                case kAccountRow:
                    return self.accountCell;
            }
            break;
        case kCredentialsSection:
            switch (indexPath.row) {
                case kUsernameRow:
                    return self.usernameCell;
                case kPasswordRow:
                    return self.passwordCell;
            }
            break;
    }

    return nil;
}

- (NSString *)tableView:(UITableView *)tableView
titleForFooterInSection:(NSInteger)section
{
    if (section == kAccountSection) {
        NSString * account = self.accountTextField.text;

        if (account.length == 0)
            account = self.accountTextField.placeholder;

        return [NSString stringWithFormat:@"https://%@.lighthouseapp.com",
            account];
    }

    return nil;
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

- (void)promptForLogIn
{
    [self enableForm];
    [self.accountTextField becomeFirstResponder];
}

#pragma mark Handling user actions

- (void)userDidSave
{
    [self.accountTextField resignFirstResponder];
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];

    [self disableForm];

    [delegate userDidProvideAccount:self.accountTextField.text
                           username:self.usernameTextField.text
                           password:self.passwordTextField.text];
}

- (void)userDidCancel
{
    [delegate userDidCancel];
}

#pragma mark Helper functions

- (void)resetForm
{
    self.accountTextField.text = @"";
    self.usernameTextField.text = @"";
    self.passwordTextField.text = @"";
}

- (void)enableForm
{
    self.logInButton.enabled = YES;
    self.cancelButton.enabled = YES;

    self.accountTextField.enabled = YES;
    self.usernameTextField.enabled = YES;
    self.passwordTextField.enabled = YES;
}

- (void)disableForm
{
    self.logInButton.enabled = NO;
    self.cancelButton.enabled = NO;

    self.accountTextField.enabled = NO;
    self.usernameTextField.enabled = NO;
    self.passwordTextField.enabled = NO;
}

@end
