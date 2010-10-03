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

#import <SenTestingKit/SenTestingKit.h>
#import "NLCocoaBenchSummaryFormatter.h"
#import "NLCBProfileStatsStub.h"


@interface NLCocoaBenchSummaryFormatterTest : SenTestCase {
    NLCocoaBenchSummaryFormatter *formatter;
}

@end


@implementation NLCocoaBenchSummaryFormatterTest

- (void)setUp
{
    formatter = [[[NLCocoaBenchSummaryFormatter alloc] init] autorelease];
}

- (void)testIteratesOverAllProfileNamesAndFormatsOutput
{
    NLCBProfileStatsStub *stub1 = [NLCBProfileStatsStub stub], *stub2 = [NLCBProfileStatsStub stub];
    [stub1 setDuration:1];
    [stub2 setDuration:2];
    NSArray *names = [NSArray arrayWithObjects:@"loop one", @"loop again", nil];
    NSDictionary *stats = [NSDictionary dictionaryWithObjectsAndKeys:
                           stub1, @"loop one",
                           stub2, @"loop again",
                           nil];
    NSString *summary = [formatter summarizeProfileNames:names forStats:stats];
    NSString *expected = @"Cocoa Bench Summary:\nloop one - 1 ns\nloop again - 2 ns";
    STAssertEqualObjects(summary, expected, nil);
}

@end
