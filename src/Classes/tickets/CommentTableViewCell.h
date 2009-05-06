//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
{
    IBOutlet UILabel * authorLabel;
    IBOutlet UILabel * dateLabel;
    IBOutlet UILabel * stateChangeLabel;
    IBOutlet UILabel * commentLabel;
}

- (void)setAuthorName:(NSString *)authorName;
- (void)setDate:(NSDate *)date;
- (void)setStateChangeText:(NSString *)text;
- (void)setCommentText:(NSString *)text;

+ (CGFloat)heightForContent:(NSString *)comment;

@end
