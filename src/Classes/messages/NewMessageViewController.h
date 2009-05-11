//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMessageViewController :
    UIViewController <UITextViewDelegate, UITextFieldDelegate>
{
    IBOutlet UIBarButtonItem * postButton;
    IBOutlet UITextField * titleField;
    IBOutlet UITextView * messageTextView;
    
    BOOL messageViewEditing;
}

- (IBAction)cancelSelected:(id)sender;
- (IBAction)postSelected:(id)sender;
- (IBAction)editMessageText:(id)sender;

@end
