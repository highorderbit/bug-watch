//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ProjectTableViewCell.h"

@implementation ProjectTableViewCell

- (void)dealloc
{
    [projectNameLabel release];
    [openTicketsLabel release];
    [super dealloc];
}

- (void)awakeFromNib
{
    projectNameLabel.highlightedTextColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setProjectName:(NSString *)projectName
{
    projectNameLabel.text = projectName;
}

- (void)setNumOpenTickets:(NSUInteger)numOpenTickets
{
    openTicketsLabel.text = [NSString stringWithFormat:@"%d", numOpenTickets];
}

@end
