//
//  WatchUtility.h
//  FlappyBirdCrossWatch
//
//  Created by Kevin Vishal on 9/29/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WatchUtility : NSObject


- (BOOL)getSpikeForAccelerometerValues:(double)xVal yValue:(double)yVal zValue:(double)zVal;
-(NSDictionary *)startTrackingMotionValuesForAccelerometerValues:(double)xVal yValue:(double)yVal zValue:(double)zVal ;
@end
