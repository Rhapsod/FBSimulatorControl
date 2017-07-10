/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/Foundation.h>

#import <XCTestBootstrap/FBTestManagerResultSummary.h>

NS_ASSUME_NONNULL_BEGIN

/**
 fbxtest's reporting protocol.
 */
@protocol FBXCTestReporter <NSObject>

/**
 Called when a process has been launched and is awaiting a debugger to be attached.

 @param pid the process identifer of the waiting process.
 */
- (void)processWaitingForDebuggerWithProcessIdentifier:(pid_t)pid;

/**
 Called when a process has resumed after a debugger has been attached.
 */
- (void)debuggerAttached;

/**
 Called when the test plan has started executing.
 */
- (void)didBeginExecutingTestPlan;

/**
 Called when the test plan has finished executing.
 */
- (void)didFinishExecutingTestPlan;

/**
 Called when the Test Suite has started.

 @param testSuite the started test suite
 @param startTime a string representation of the start time.
 */
- (void)testSuite:(NSString *)testSuite didStartAt:(NSString *)startTime;

/**
 Called when a test case has finished.

 @param testClass the test class that has finished.
 @param method the test method that has finished.
 @param status the status of the finish of the test case.
 @param duration the duration of the test case.
 */
- (void)testCaseDidFinishForTestClass:(NSString *)testClass method:(NSString *)method withStatus:(FBTestReportStatus)status duration:(NSTimeInterval)duration;

/**
 Called when a test case has failed.

 @param testClass the test class that has failed.
 @param method the test method that has failed.
 @param message the failure message.
 @param file the failing file.
 @param line the failing line number.
 */
- (void)testCaseDidFailForTestClass:(NSString *)testClass method:(NSString *)method withMessage:(NSString *)message file:(NSString *)file line:(NSUInteger)line;

/**
 Called when a test case has started

 @param testClass the test class that has started.
 @param method the test method that has started.
 */
- (void)testCaseDidStartForTestClass:(NSString *)testClass method:(NSString *)method;

/**
 Called to summarize the results of a test execution

 @param summary the test summary.
 */
- (void)finishedWithSummary:(FBTestManagerResultSummary *)summary;

/**
 Called when the test process has some output.

 @param output the test output.
 */
- (void)testHadOutput:(NSString *)output;

/**
 Called for some external event to be relayed.

 @param event the encoded event.
 */
- (void)handleExternalEvent:(NSString *)event;

/**
 Called when the results of the test should be written to the output.

 @param error an error for an error that occurs.
 */
- (BOOL)printReportWithError:(NSError **)error;

@end

NS_ASSUME_NONNULL_END