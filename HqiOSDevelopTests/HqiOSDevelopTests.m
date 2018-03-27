//
//  HqiOSDevelopTests.m
//  HqiOSDevelopTests
//
//  Created by macpro on 2018/3/27.
//  Copyright © 2018年 macpro. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HqGetUserInfo.h"
@interface HqiOSDevelopTests : XCTestCase

@end

@implementation HqiOSDevelopTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
  
    HqGetUserInfo *getInfo = [[HqGetUserInfo alloc] init];
    
//    [getInfo addTarget:self action:@selector(infoCallback)];
    [getInfo addTarget:self action:@selector(infoCallback:)];

    [getInfo startGetInfo];
}
- (void)infoCallback{
    NSLog(@"已获取用户信息2");
}
- (void)infoCallback:(HqGetUserInfo *)userInfo{
   
    NSLog(@"已获取用户信息==%@",userInfo.userId);
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
