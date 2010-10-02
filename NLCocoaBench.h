/*
 Copyright (c) 2010 Navel Labs, Ltd.

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */

#import <Foundation/Foundation.h>
#include <mach/clock.h>


@interface NLCocoaBench : NSObject {
    NSMutableArray *activeProfileNames;
    NSMutableArray *allProfileNames;
    NSMutableDictionary *profileStats;
}

@property (nonatomic, readonly) NSArray *activeProfileNames;
@property (nonatomic, readonly) NSString *summary;

- (void)startProfile:(NSString *)profileName;
- (void)finishProfile:(NSString *)profileName;
- (UInt64)profileTime:(NSString *)profileName;

#ifdef __BLOCKS__

typedef void (^NLCocoaBenchBlock)();

- (void)startProfile:(NSString *)profileName withBlock:(NLCocoaBenchBlock)block;

#endif

@end


@interface NLCBProfileStats : NSObject {
    NSString *name;
    UInt64 startTime, stopTime;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic) UInt64 startTime, stopTime;
@property (nonatomic, readonly) UInt64 duration;

- (void)start;
- (void)stop;

@end


@interface NLCBProfileStatsFormatter : NSObject {
    NSNumberFormatter *numberFormatter;
}
- (NSString *)stringFromStats:(NLCBProfileStats *)stats;
@end


@interface NLCocoaBenchSummaryFormatter : NSObject {
}

- (NSString *)summarizeProfileNames:(NSArray *)names forStats:(NSDictionary *)stats;

@end
