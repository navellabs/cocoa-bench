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
#import "NLCBProfile.h"


@interface NLCBProfileTest : SenTestCase {
    NLCBProfile *profile;
}

@end

@implementation NLCBProfileTest

- (void)setUp
{
    profile = [[[NLCBProfile alloc] init] autorelease];
}

- (void)testProfileNameProperty
{
    profile.name = @"someName";
    STAssertEqualObjects(profile.name, @"someName", nil);
}

- (void)testProfileStartTimeProperty
{
    profile.startTime = 1;
    STAssertEquals(profile.startTime, (UInt64)1, nil);
}

- (void)testProfileEndTimeProperty
{
    profile.stopTime = 1;
    STAssertEquals(profile.stopTime, (UInt64)1, nil);
}

- (void)testProfileDurationProperty
{
    profile.startTime = 1;
    profile.stopTime = 2;
    STAssertEquals(profile.duration, (UInt64)1, nil);
}

- (void)testWhenStartedPropertySetWhenStarted
{
    STAssertNil(profile.whenStarted, nil);
    [profile start];
    STAssertNotNil(profile.whenStarted, nil);
}

- (void)testWhenStoppedPropertySetWhenStopped
{
    STAssertNil(profile.whenStopped, nil);
    [profile stop];
    STAssertNotNil(profile.whenStopped, nil);
}

- (void)testTiming
{
    [profile start];
    [profile stop];
    STAssertFalse(profile.duration == 0, nil);
}

- (void)testDescription
{
    profile.name = @"some profile";
    profile.whenStopped = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    profile.startTime = 0;
    profile.stopTime = 1;
    STAssertEqualObjects([profile description], @"2000-12-31 19:00:00 -0500: some profile - 1 ns", nil);
}

@end
