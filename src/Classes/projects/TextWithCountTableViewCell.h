//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedRectLabel.h"

@interface TextWithCountTableViewCell : UITableViewCell
{
    IBOutlet UILabel * titleLabel;
    IBOutlet RoundedRectLabel * countLabel;
}

- (void)setText:(NSString *)text;
- (void)setCount:(NSUInteger)count;

@end
