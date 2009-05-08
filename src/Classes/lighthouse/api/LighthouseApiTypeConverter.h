//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LighthouseApiTypeConverter : NSObject
{
}

+ (id)converter;

- (id)convert:(NSString *)value;

@end
