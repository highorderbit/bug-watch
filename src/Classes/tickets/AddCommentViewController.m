//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "AddCommentViewController.h"

@interface AddCommentViewController (Private)

- (void)cancelSelected;
- (void)doneSelected;

@end

@implementation AddCommentViewController

@synthesize target, action;

- (void)dealloc
{
    [textView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [textView resignFirstResponder];
}

- (void)setTextViewText:(NSString *)text
{
    textView.text = text;
}

- (void)cancelSelected
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneSelected
{
    NSMethodSignature * sig =
        [[target class] instanceMethodSignatureForSelector:action];
    NSInvocation * invocation =
        [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:target];
    [invocation setSelector:action];
    NSString * text = textView.text;
    [invocation setArgument:&text atIndex:2];
    [invocation retainArguments];
    [invocation invoke];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setAutocorrectionType:(UITextAutocorrectionType)autocorrectionType
{
    textView.autocorrectionType = autocorrectionType;
}

- (UITextAutocorrectionType)autocorrectionType
{
    return textView.autocorrectionType;
}

@end
