//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LighthouseApiNumber.h"

@implementation LighthouseApiNumber

@synthesize number;

- (void)dealloc
{
    [number release];
    [super dealloc];
}

@end