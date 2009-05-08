//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
{
    IBOutlet UILabel * authorLabel;
    IBOutlet UILabel * dateLabel;
    IBOutlet UILabel * projectLabel;
    IBOutlet UILabel * titleLabel;
    IBOutlet UILabel * commentLabel;
    IBOutlet UILabel * numResponsesLabel;
}

- (void)setAuthorName:(NSString *)authorName;
- (void)setDate:(NSDate *)date;
- (void)setProjectName:(NSString *)projectName;
- (void)setTitleText:(NSString *)text;
- (void)setCommentText:(NSString *)text;
- (void)setNumResponses:(NSUInteger *)numResponses;

+ (CGFloat)heightForTitle:(NSString *)title comment:(NSString *)comment;

@end
