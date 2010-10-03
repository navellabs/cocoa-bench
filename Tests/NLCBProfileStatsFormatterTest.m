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
#import "NLCBProfileStatsFormatter.h"
#import "NLCBProfileStub.h"

@interface NLCBProfileStatsFormatterTest : SenTestCase {
    NLCBProfileStatsFormatter *formatter;
    NLCBProfileStub *profile;
}

@end


@implementation NLCBProfileStatsFormatterTest

- (void)setUp
{
    profile = [NLCBProfileStub stub];
    formatter = [[[NLCBProfileStatsFormatter alloc] init] autorelease];
}

- (void)testFormattingLessThan1Second
{
    [profile setDuration:10];
    NSString *stringTime = [formatter stringFromProfile:profile];
    STAssertEqualObjects(stringTime, @"10 ns", nil);
}

- (void)testFormattingGreaterThan1Millisecond
{
    [profile setDuration:1540000];
    NSString *stringTime = [formatter stringFromProfile:profile];
    STAssertEqualObjects(stringTime, @"1.54 ms", nil);    
}

- (void)testFormattingGreaterThan1Second
{
    [profile setDuration:1542000000];
    NSString *stringTime = [formatter stringFromProfile:profile];
    STAssertEqualObjects(stringTime, @"1.542 s", nil);    
}

@end
