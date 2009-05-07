//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectHomeTableViewCell : UITableViewCell
{
    IBOutlet UILabel * label;
    IBOutlet UIImageView * iconView;
    
    UIImage * icon;
    UIImage * highlightedIcon;
}

- (void)setLabelText:(NSString *)text;
- (void)setImage:(UIImage *)icon;
- (void)setHighlightedImage:(UIImage *)highlightedIcon;

@end
