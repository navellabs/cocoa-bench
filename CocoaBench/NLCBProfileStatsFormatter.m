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

 http://github.com/navellabs/cocoa-bench
 */

#import "NLCBProfileStatsFormatter.h"
#import <IOKit/IOTypes.h>

@implementation NLCBProfileStatsFormatter


#pragma mark Memory Management

- (void)dealloc
{
    [numberFormatter release];
    [super dealloc];
}


#pragma mark Initialization

- (id)init
{
    if (self = [super init]) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    return self;
}


#pragma mark Public Methods

- (NSString *)stringFromStats:(NLCBProfileStats *)stats
{
    NSDecimalNumber *scale = nil, *adjustedDuration = nil;
    NSDecimalNumber *nsDuraction = [[NSDecimalNumber alloc] initWithUnsignedLongLong:stats.duration];
    NSString *units = nil;
    
    if (stats.duration > kSecondScale) {
        scale = [[NSDecimalNumber alloc] initWithUnsignedLong:kSecondScale];
        adjustedDuration = [nsDuraction decimalNumberByDividingBy:scale];
        units = @"s";
        [scale release];
        [nsDuraction release];
    } else if (stats.duration > kMillisecondScale) {
        scale = [[NSDecimalNumber alloc] initWithUnsignedLongLong:kMillisecondScale];
        adjustedDuration = [nsDuraction decimalNumberByDividingBy:scale];
        units = @"ms";
        [scale release];
        [nsDuraction release];
    } else {
        units = @"ns";
        adjustedDuration = [nsDuraction autorelease];
    }
    
    NSString *numberString = [numberFormatter stringFromNumber:adjustedDuration];
    return [NSString stringWithFormat:@"%@ %@", numberString, units];
}

@end

