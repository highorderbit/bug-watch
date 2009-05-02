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

@end
