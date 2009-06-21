//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "NewMessageViewController.h"

@implementation NewMessageViewController

@synthesize delegate, postButton, cancelButton;

- (void)dealloc
{
    [postButton release];
    [cancelButton release];
    [titleField release];
    [messageTextView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationItem setLeftBarButtonItem:cancelButton animated:NO];
    [self.navigationItem setRightBarButtonItem:postButton animated:NO];
    self.navigationItem.title = NSLocalizedString(@"newmessage.title", @"");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    titleField.text = @"";
    messageTextView.text = @"";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [titleField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [titleField resignFirstResponder];
}

- (IBAction)cancelSelected:(id)sender
{
    NSLog(@"Cancel new message selected");
    if (titleField.editing)
        [titleField resignFirstResponder];
    else if (messageViewEditing)
        [messageTextView resignFirstResponder];
    else if ([self.navigationController.viewControllers count] == 1)
        [self dismissModalViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)postSelected:(id)sender
{
    NSLog(@"Post new message selected");
    NSString * message = messageTextView.text;
    NSString * title = titleField.text;
    [delegate postNewMessage:message withTitle:title];
}

- (IBAction)editMessageText:(id)sender
{
    [messageTextView becomeFirstResponder];
}

#pragma mark UITextViewDelegate implementation

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    messageViewEditing = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    messageViewEditing = NO;
}

#pragma mark UITextFieldDelegate implementation

- (void)textFieldDidBeginEditing:(UITextField *)textView
{
    postButton.enabled = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textView
{
    postButton.enabled = YES;
}

@end
