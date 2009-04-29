//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NewsFeedTableViewCell.h"
#import "NSDate+StringHelpers.h"
#import "UILabel+DrawingAdditions.h"

@interface NewsFeedTableViewCell (Private)

- (void)setAttributes:(NSDictionary *)attrs;

+ (UIColor *)ticketEntityColor;
+ (UIColor *)milestoneEntityColor;
+ (UIColor *)changesetEntityColor;

+ (UIColor *)colorForEntity:(NSString *)entity;
+ (UIColor *)messageEntityColor;

+ (NSDictionary *)entityColorMappings;

@end

@implementation NewsFeedTableViewCell

@synthesize attributes;

- (void)dealloc
{
    [authorLabel release];
    [pubDateLabel release];
    [bodyLabel release];
    [entityTypeLabel release];

    [attributes release];

    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    pubDateLabel.text = [[attributes objectForKey:@"pubDate"] shortDescription];
    [pubDateLabel sizeToFit:UILabelSizeToFitAlignmentRight];

    authorLabel.text = [attributes objectForKey:@"author"];
    [authorLabel
        sizeToFitWithinWidth:220.0 - pubDateLabel.frame.size.width - 5.0];

    NSString * body = [attributes objectForKey:@"body"];

    CGFloat bodyHeight = [bodyLabel heightForString:body];
    CGRect bodyLabelFrame = bodyLabel.frame;
    bodyLabelFrame.size.height = bodyHeight;
    bodyLabel.frame = bodyLabelFrame;

    bodyLabel.text = body;

    NSString * type = [attributes objectForKey:@"entityType"];
    entityTypeLabel.text = type;
    entityTypeLabel.backgroundColor = [[self class] colorForEntity:type];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)setAttributes:(NSDictionary *)attrs
{
    NSDictionary * tmp = [attrs copy];
    [attributes release];
    attributes = tmp;
}

+ (CGFloat)heightForContent:(NSDictionary *)attrs
{
    NSString * body = [attrs objectForKey:@"body"];

    CGSize maxSize = CGSizeMake(217.0, 999999.0);
    UIFont * font = [UIFont systemFontOfSize:14.0];
    UILineBreakMode mode = UILineBreakModeWordWrap;

    CGSize size =
        [body sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode];

    return 52.0 + size.height - 18.0;
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

+ (UIColor *)changesetEntityColor
{
    return [UIColor blackColor];
}

+ (UIColor *)messageEntityColor
{
    return [UIColor colorWithRed:1.000
                           green:0.600
                            blue:0.133
                           alpha:1.0];
}

+ (UIColor *)colorForEntity:(NSString *)entity
{
    return [[[self class] entityColorMappings] objectForKey:entity];
}

+ (NSDictionary *)entityColorMappings
{
    static NSDictionary * entityColorMappings = nil;
    if (entityColorMappings == nil) {
        entityColorMappings =
            [[NSDictionary alloc] initWithObjectsAndKeys:
            [[self class] ticketEntityColor], @"ticket",
            [[self class] milestoneEntityColor], @"milestone",
            [[self class] changesetEntityColor], @"changeset",
            [[self class] messageEntityColor], @"message",
            nil];
    }

    return entityColorMappings;
}

@end
