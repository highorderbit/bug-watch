//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCommentViewController : UIViewController
{
    IBOutlet UITextView * textView;

    id target;
    SEL action;
}

@property (nonatomic, assign) id target;

// Takes method with signature like:
//    - (void)setText:(NSString *)text;
@property(nonatomic) SEL action;

- (void)setTextViewText:(NSString *)text;

@end
