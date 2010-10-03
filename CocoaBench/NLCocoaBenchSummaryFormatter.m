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

#import "NLCocoaBenchSummaryFormatter.h"
#import "NLCBProfileStatsFormatter.h"

@implementation NLCocoaBenchSummaryFormatter

- (NSString *)summarizeProfileNames:(NSArray *)names forStats:(NSDictionary *)statsDict
{
    NLCBProfileStatsFormatter *formatter = [[[NLCBProfileStatsFormatter alloc] init] autorelease];
    NSMutableArray *lines = [NSMutableArray arrayWithCapacity:20];
    
    [lines addObject:@"Cocoa Bench Summary:"];
    
    for (NSString *name in names) {
        NLCBProfile *stats = [statsDict objectForKey:name];
        NSString *duration = [formatter stringFromStats:stats];
        NSString *line = [NSString stringWithFormat:@"%@ - %@", name, duration];
        [lines addObject:line];
    }
    
    return [lines componentsJoinedByString:@"\n"];
}

@end
