//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NewsFeedTableViewCell.h"
#import "NewsFeedItem.h"
#import "NSDate+StringHelpers.h"
#import "UILabel+DrawingAdditions.h"

@interface NewsFeedTableViewCell (Private)

- (void)setAttributes:(NSDictionary *)attrs;

+ (UIColor *)dateLabelColor;

+ (UIColor *)colorForEntity:(NSString *)entity;
+ (UIColor *)messageEntityColor;

+ (NSDictionary *)entityColorMappings;

@end

@implementation NewsFeedTableViewCell

@synthesize newsFeedItem;

- (void)dealloc
{
    [authorLabel release];
    [pubDateLabel release];
    [bodyLabel release];
    [entityTypeLabel release];

    [newsFeedItem release];

    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
    }

    return self;
}

- (void)awakeFromNib
{
    UIImage * backgroundImage =
        [UIImage imageNamed:@"TableViewCellGradient.png"];
    self.backgroundView =
        [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
    self.backgroundView.contentMode =  UIViewContentModeBottom;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    pubDateLabel.text = [newsFeedItem.published shortDescription];
    [pubDateLabel sizeToFit:UILabelSizeToFitAlignmentRight];

    authorLabel.text = newsFeedItem.author;
    [authorLabel
        sizeToFitWithinWidth:220.0 - pubDateLabel.frame.size.width - 5.0];

    NSString * body = newsFeedItem.title;

    CGFloat bodyHeight = [bodyLabel heightForString:body];
    CGRect bodyLabelFrame = bodyLabel.frame;
    bodyLabelFrame.size.height = bodyHeight;
    bodyLabel.frame = bodyLabelFrame;

    bodyLabel.text = body;

    NSString * type = newsFeedItem.type;
    entityTypeLabel.text = type;
    entityTypeLabel.backgroundColor = [[self class] colorForEntity:type];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (selected) {
        authorLabel.textColor = [UIColor whiteColor];
        pubDateLabel.textColor = [UIColor whiteColor];
        bodyLabel.textColor = [UIColor whiteColor];
    } else {
        authorLabel.textColor = [UIColor blackColor];
        pubDateLabel.textColor = [[self class] dateLabelColor];
        bodyLabel.textColor = [UIColor blackColor];
    }
}

+ (CGFloat)heightForContent:(NewsFeedItem *)item
{
    NSString * body = item.title;

    CGSize maxSize = CGSizeMake(211.0, 999999.0);
    UIFont * font = [UIFont systemFontOfSize:14.0];
    UILineBreakMode mode = UILineBreakModeWordWrap;

    CGSize size =
        [body sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode];

    return 34.0 + size.height;
}

+ (UIColor *)dateLabelColor
{
    return [UIColor colorWithRed:0 green:0.3 blue:0.7 alpha:1.0];
}

+ (UIColor *)ticketEntityColor
{
    return [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:1.0];
}

+ (UIColor *)milestoneEntityColor
{
    return [UIColor colorWithRed:0.533 green:0.067 blue:0.8 alpha:1.0];
}

+ (UIColor *)changesetEntityColor
{
    return [UIColor blackColor];
}

+ (UIColor *)messageEntityColor
{
    return [UIColor colorWithRed:1.0 green:0.6 blue:0.133 alpha:1.0];
}

+ (UIColor *)pageEntityColor
{
    return [UIColor colorWithRed:0 green:.667 blue:.133 alpha:1.0];
}

+ (UIColor *)colorForEntity:(NSString *)entity
{
    UIColor * color = [[[self class] entityColorMappings] objectForKey:entity];
    return color ? color : [[self class] ticketEntityColor];
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
            [[self class] pageEntityColor], @"page",
            nil];
    }

    return entityColorMappings;
}

@end
