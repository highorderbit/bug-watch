//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NewsFeedTableViewCell.h"
#import "NSDate+StringHelpers.h"

@interface NewsFeedTableViewCell (Private)

+ (UIColor *)ticketEntityColor;
+ (UIColor *)milestoneEntityColor;

@end

@implementation NewsFeedTableViewCell

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateView:(NSDictionary *)attrs
{
    authorLabel.text = [attrs objectForKey:@"author"];
    pubDateLabel.text = [[attrs objectForKey:@"pubDate"] shortDescription];
    bodyLabel.text = [attrs objectForKey:@"body"];

    NSString * type = [attrs objectForKey:@"entityType"];
    if ([type isEqualToString:@"ticket"])
        entityTypeLabel.backgroundColor = [[self class] ticketEntityColor];
    else if ([type isEqualToString:@"milestone"])
        entityTypeLabel.backgroundColor = [[self class] milestoneEntityColor];

    entityTypeLabel.text = type;
}

+ (UIColor *)ticketEntityColor
{
    return [UIColor colorWithRed:0.667
                           green:0.667
                            blue:0.667
                           alpha:1.0];
}

+ (UIColor *)milestoneEntityColor
{
    return [UIColor colorWithRed:0.533
                           green:0.067
                            blue:0.800
                           alpha:1.0];
}

@end
