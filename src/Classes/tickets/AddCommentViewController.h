//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCommentViewController : UIViewController
{
    IBOutlet UILabel * label;
    IBOutlet UITextView * textView;
}

- (void)setLabelText:(NSString *)text;
- (void)setTextViewText:(NSString *)text;

@end
