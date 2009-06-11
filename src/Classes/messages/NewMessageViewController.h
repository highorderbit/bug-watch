//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMessageViewControllerDelegate.h"

@interface NewMessageViewController :
    UIViewController <UITextViewDelegate, UITextFieldDelegate>
{
    NSObject<NewMessageViewControllerDelegate> * delegate;

    IBOutlet UIBarButtonItem * postButton;
    IBOutlet UIBarButtonItem * cancelButton;
    IBOutlet UITextField * titleField;
    IBOutlet UITextView * messageTextView;

    BOOL messageViewEditing;
}

@property (nonatomic, assign)
    NSObject<NewMessageViewControllerDelegate> * delegate;

@property (nonatomic, readonly) UIBarButtonItem * postButton;
@property (nonatomic, readonly) UIBarButtonItem * cancelButton;

- (IBAction)cancelSelected:(id)sender;
- (IBAction)postSelected:(id)sender;
- (IBAction)editMessageText:(id)sender;

@end
