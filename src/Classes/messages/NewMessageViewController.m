//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "NewMessageViewController.h"

@implementation NewMessageViewController

- (void)dealloc
{
    [postButton release];
    [titleField release];
    [messageTextView release];
    [super dealloc];
}

- (IBAction)cancelSelected:(id)sender
{
    NSLog(@"Cancel new message selected");
    if (titleField.editing)
        [titleField resignFirstResponder];
    else if (messageViewEditing)
        [messageTextView resignFirstResponder];
    else
        [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)postSelected:(id)sender
{
    NSLog(@"Post new message selected");
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
