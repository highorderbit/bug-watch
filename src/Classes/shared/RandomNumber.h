//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomNumber : NSObject <NSCopying>
{
  @private
    NSNumber * number;
}

+ (id)randomNumber;
- (id)init;

@end