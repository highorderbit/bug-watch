//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "AddCommentViewController.h"

@implementation AddCommentViewController

- (void)dealloc
{
    [label release];
    [textView release];
    [super dealloc];
}

- (void)setLabelText:(NSString *)text
{
    label.text = text;
}

- (void)setTextViewText:(NSString *)text
{
    textView.text = text;
}

@end
