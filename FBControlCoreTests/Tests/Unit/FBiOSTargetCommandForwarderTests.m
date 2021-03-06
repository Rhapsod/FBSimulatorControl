/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <XCTest/XCTest.h>

#import <FBControlCore/FBControlCore.h>

#import "FBiOSTargetDouble.h"

static NSUInteger fooConstructed = 0;
static NSUInteger foo1Called = 0;
static NSUInteger foo2Called = 0;
static NSUInteger barConstructed = 0;
static NSUInteger bar2Called = 0;

@protocol FBiOSTargetCommandForwarder_Proto1 <NSObject>

- (void)doFoo;

@end

@protocol FBiOSTargetCommandForwarder_Proto2 <NSObject>

- (void)doBar;

@end

@interface FBiOSTargetCommandForwarder_Impl1 : NSObject <FBiOSTargetCommand, FBiOSTargetCommandForwarder_Proto1>

@end

@implementation FBiOSTargetCommandForwarder_Impl1

- (void)doFoo
{
  foo1Called++;
}


+ (instancetype)commandsWithTarget:(id<FBiOSTarget>)target
{
  fooConstructed++;
  return [self new];
}

@end

@interface FBiOSTargetCommandForwarder_Impl2 : NSObject <FBiOSTargetCommand, FBiOSTargetCommandForwarder_Proto1, FBiOSTargetCommandForwarder_Proto2>

@end

@implementation FBiOSTargetCommandForwarder_Impl2

- (void)doFoo
{
  foo2Called++;
}

- (void)doBar
{
  bar2Called++;
}

+ (instancetype)commandsWithTarget:(id<FBiOSTarget>)target
{
  barConstructed++;
  return [self new];
}

@end

@interface FBiOSTargetCommandForwarderTests : XCTestCase

@end

@implementation FBiOSTargetCommandForwarderTests

- (void)setUp
{
  fooConstructed = 0;
  foo1Called = 0;
  foo2Called = 0;
  barConstructed = 0;
  bar2Called = 0;
}

+ (NSArray<Class> *)commandResponders
{
  return @[FBiOSTargetCommandForwarder_Impl1.class, FBiOSTargetCommandForwarder_Impl2.class];
}

- (void)testForwardsToFirstInArrayWithNoState
{
  id forwarder = [FBiOSTargetCommandForwarder forwarderWithTarget:FBiOSTargetDouble.new commandClasses:FBiOSTargetCommandForwarderTests.commandResponders statefulCommands:NSSet.set];
  [forwarder doFoo];
  [forwarder doFoo];
  [forwarder doBar];

  XCTAssertEqual(foo1Called, 2);
  XCTAssertEqual(foo2Called, 0);
  XCTAssertEqual(bar2Called, 1);
  XCTAssertEqual(fooConstructed, 2);
  XCTAssertEqual(barConstructed, 1);
}

- (void)testForwardsToFirstInArrayWithState
{
  id forwarder = [FBiOSTargetCommandForwarder forwarderWithTarget:FBiOSTargetDouble.new commandClasses:FBiOSTargetCommandForwarderTests.commandResponders statefulCommands:[NSSet setWithArray:FBiOSTargetCommandForwarderTests.commandResponders]];
  [forwarder doFoo];
  [forwarder doFoo];
  [forwarder doBar];

  XCTAssertEqual(foo1Called, 2);
  XCTAssertEqual(foo2Called, 0);
  XCTAssertEqual(bar2Called, 1);
  XCTAssertEqual(fooConstructed, 1);
  XCTAssertEqual(barConstructed, 1);
}

@end
