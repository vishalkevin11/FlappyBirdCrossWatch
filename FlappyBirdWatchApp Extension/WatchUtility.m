//
//  WatchUtility.m
//  FlappyBirdCrossWatch
//
//  Created by Kevin Vishal on 9/29/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

#import "WatchUtility.h"


typedef struct{ double x,y,z; }vec_d3;

#define RECENT_COUNT 10
#define SMOOTH_IP(x,x_new,fac) x = fac * x + (1. -fac) * x_new
#define DOUBLE_EMPTY DBL_MAX

#define THRESHOLD_IMPLUSE .15


@implementation WatchUtility {
    //BOOL didFindLocation;
//    float maxX;
//    float maxY;
//    float maxZ;
    
   // CMMotionManager *motionManager;
    
    //NSInteger bumpCounter;
    
    
    
    double cuurentX;
    double cuurentY;
    double cuurentZ;
    double previousX;
    double previousY;
    double previousZ;
    double currentTotalDistance;
    double previousTotalDistance;
    
    NSDate *currentDate;
    NSDate *previousDate;
    
    BOOL didFindLocation;
    float maxX;
    float maxY;
    float maxZ;
    
   // CMMotionManager *motionManager;
    
    NSInteger bumpCounter;
}



-(instancetype)init {
    
    self = [super init];
    if (self) {
        
        cuurentX = 0.0;
        cuurentY = 0.0;
        cuurentZ = 0.0;
        previousX = 0.0;
        previousY = 0.0;
        previousZ = 0.0;
        
        currentTotalDistance = 0.0;
        previousTotalDistance = 0.0;
        
        currentDate  = [NSDate date];
        previousDate  = [NSDate date];
        
        bumpCounter = 0;
      //  motionManager = [[CMMotionManager alloc]init];
       // self.isPeakNotified =  YES;
    }
    return self;
}


#pragma mark -  Gyro Delgate

-(NSDictionary *)startTrackingMotionValuesForAccelerometerValues:(double)xVal yValue:(double)yVal zValue:(double)zVal  {
    
    
   // [motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
        
//        cuurentX = gyroData.rotationRate.x;
//        cuurentY = gyroData.rotationRate.y;
//        cuurentZ = gyroData.rotationRate.z;
    
    cuurentX=xVal;
    cuurentY=yVal;
    cuurentZ=zVal;
    
        previousDate = currentDate;
        
        currentDate = [NSDate date];
        
        if (cuurentX > 0.09 || cuurentY > 0.09 || cuurentZ > 0.09)  {
            
            
            
            
           return [self findSquareRootOfSumOfDifferencesBetweenPoints];
            
            
        }
        
        
        previousX = cuurentX;
        previousY = cuurentY;
        previousZ = cuurentZ;
        
   // }];
    return @{@"1":@"",@"2" : @"",@"3":@""};
}

#pragma mark -  Calculate diffeence between two path


- (NSDictionary *)findSquareRootOfSumOfDifferencesBetweenPoints {
    double diffX = (cuurentX - previousX);
    double diffY = (cuurentY - previousY);
    double diffZ = (cuurentZ - previousZ);
    
    double powX  = pow(diffX, 2);
    double powY  = pow(diffY, 2);
    double powZ  = pow(diffZ, 2);
    
    double sumOfDiff = powX + powY + powZ;
    double sqrtOfSum = sqrt(sumOfDiff);
    
    previousTotalDistance = currentTotalDistance;
    currentTotalDistance += sqrtOfSum;
    //NSLog(@"%d",(int)totalDistance);
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
                                               fromDate:previousDate
                                                 toDate:currentDate
                                                options:0];
    
    //  NSLog(@"Difference in date components: %i/%i/%i", components.day, components.month, components.year);
    
    
    //double deltaTotalDistance = fabs(currentTotalDistance - previousTotalDistance);
    //double deltaTime = [currentDate timeIntervalSinceDate:previousDate];
    
    // double speed = deltaTotalDistance / deltaTime;
    
    // Calculate the km traveed assumption 1 unit = 1 mt
    
    NSString *allValues = [NSString stringWithFormat:@"x %.2f y %.2f z %.2f",cuurentX,cuurentY,cuurentZ];
    
    
    NSString *xv = [NSString stringWithFormat:@"%.2f",cuurentX];
    NSString *yv = [NSString stringWithFormat:@"%.2f",cuurentY];
    NSString *zv = [NSString stringWithFormat:@"%.2f",cuurentZ];
    NSDictionary *dict = @{@"1":xv,@"2" : yv,@"3":zv};
    return dict;
 //   [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyCurrentDistance" object:nil userInfo:@{@"distance" : @(currentTotalDistance),@"xVal":@(cuurentX),@"yVal":@(cuurentY),@"zVal":@(cuurentZ)}];
}


- (BOOL)getSpikeForAccelerometerValues:(double)xVal yValue:(double)yVal zValue:(double)zVal {

    
    
   // [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        
        // NSLog(@"gyre  %f %f %f",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z);
        
        static vec_d3 smooth = {DOUBLE_EMPTY,0,0};
        {
//            if(smooth.x == DOUBLE_EMPTY){
//                smooth.x=accelerometerData.acceleration.x;
//                smooth.y=accelerometerData.acceleration.y;
//                smooth.z=accelerometerData.acceleration.z;
//                
//                return;
//            }
//            SMOOTH_IP(smooth.x, accelerometerData.acceleration.x, 0.9);
//            SMOOTH_IP(smooth.y, accelerometerData.acceleration.y, 0.9);
//            SMOOTH_IP(smooth.z, accelerometerData.acceleration.z, 0.9);
            
            if(smooth.x == DOUBLE_EMPTY){
                smooth.x=xVal;
                smooth.y=yVal;
                smooth.z=zVal;
                
                return false;
            }
            SMOOTH_IP(smooth.x, xVal, 0.9);
            SMOOTH_IP(smooth.y, yVal, 0.9);
            SMOOTH_IP(smooth.z, zVal, 0.9);
        }
        
        // keep track of last k smoother acceleration values
        static vec_d3 recent[RECENT_COUNT];
        {
            static int ptr=0;
            static BOOL gotEnoughData = NO;
            
            recent[ptr]= smooth;
            ptr++;
            if(ptr==RECENT_COUNT){
                ptr=0;
                gotEnoughData=YES;
            }
            if (!gotEnoughData) {
                return false;
            }
        }
        //get the resultant variation in acceleration over the whole array
        double variation;
        {
            vec_d3 min = smooth,max=smooth;
            for (int i=0; i< RECENT_COUNT; i++) {
                min.x = MIN(min.x, recent[i].x);
                min.y = MIN(min.y, recent[i].y);
                min.z = MIN(min.z, recent[i].z);
                
                max.x = MAX(max.x, recent[i].x);
                max.y = MAX(max.y, recent[i].y);
                max.z = MAX(max.z, recent[i].z);
            }
            vec_d3 V = (vec_d3)
            {
                .x = max.x - min.x,
                .y = max.y - min.y,
                .z = max.z - min.z
            };
            variation =sqrt(
                            V.x * V.x +
                            V.y * V.y +
                            V.z * V.z
                            );
        }
        //smooth it
        static double var_smoothed = DOUBLE_EMPTY;
        {
            if (var_smoothed == DOUBLE_EMPTY) {
                var_smoothed = variation;
                return false;
            }
            SMOOTH_IP(var_smoothed, variation, 0.9);
        }
        
        // see if it's just passed a peak
        {
            static double varSmoothed_last = DOUBLE_EMPTY;
            if (varSmoothed_last == DOUBLE_EMPTY) {
                varSmoothed_last=var_smoothed;
                return false;
            }
            static double varSmoother_preLast = DOUBLE_EMPTY;
            if (varSmoother_preLast == DOUBLE_EMPTY) {
                varSmoother_preLast = varSmoothed_last;
                varSmoothed_last = var_smoothed;
                return false;
            }
            
            //#define THRESHOLD_IMPLUSE .20
            
            if (varSmoothed_last > varSmoother_preLast &&
                varSmoothed_last > var_smoothed &&
                varSmoothed_last > THRESHOLD_IMPLUSE) {
            //    didFindLocation=NO;
                
            }
            
            varSmoother_preLast = varSmoothed_last;
            varSmoothed_last = var_smoothed;
            
            
            
           // @synchronized (self) {
                
//                var defaults = NSUserDefaults(suiteName: "com.tuffytiffany.flappybird")
//                
//                defaults?.setBool(false, forKey: "isPeakNotified")
//                defaults?.synchronize()
//                NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.tuffytiffany.flappybird"];
//                [defaults synchronize];
//        
//            
//            BOOL isPeakNotified = [defaults boolForKey:@"isPeakNotified"];
            
                //if ((varSmoothed_last  > 0.3) && (varSmoothed_last  < 0.5) && (isPeakNotified == false)) {
            
                  if ((varSmoothed_last  > 0.3) && (varSmoothed_last  < 0.7)) {
                    
                
                    
                //    [defaults setBool:true forKey:@"isPeakNotified"];
                 ///   [defaults synchronize];
                    
                    //self.isPeakNotified = false;
                   // varSmoothed_last = 0.0;
                   // varSmoother_preLast = 0.0;
//                    if (self.isPeakNotified) {
//                        self.isPeakNotified = false;
//                        varSmoothed_last = 0.0;
//                        varSmoother_preLast = 0.0;
//                        
//                        
//                        [self performSelector:@selector(notifyThePeak) withObject:nil afterDelay:0.5];
//                        
//                        return  true;
//                    }
//                    
                    
                    //   varSmoothed_last = 0.0;
                    // varSmoother_preLast = 0.0;
                    //  if (varSmoothed_last  > 0.9) {
                    //      NSLog(@"var_smoothed1 : %f",var_smoothed);
                    //         //[self.labelGyroscope setBackgroundColor:[UIColor lightGrayqColor]];
                    //                if (isPeakNotified) {
                    //                    isPeakNotified = NO;
                    //                    bumpCounter ++;
                    ////                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyBumpOnRoad" object:nil userInfo:@{@"BumpCounter" : @(bumpCounter)}];
                    ////                    [self performSelector:@selector(notifyTheBump) withObject:nil afterDelay:2.];
                    //                }
                    return  true;
                    
                }
                else {
                    return false;
                }
//}
           
            
            
            
            
          
              //  if ((varSmoothed_last  > 0.8)) {
//                    NSLog(@"var_smoothed1 : %f",var_smoothed);
//                    //         //[self.labelGyroscope setBackgroundColor:[UIColor lightGrayqColor]];
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        varSmoothed_last = 0.0;
//                        var_smoothed = 0.0;
//                        varSmoother_preLast = 0.0;
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyCrashOnRoad" object:nil userInfo:nil];
//                        [motionManager stopAccelerometerUpdates];
//                        motionManager = nil;
//                        return;
//                    });
                    
            }
            
       // }
        
    //}];
    return false;
}
//
//-(void)notifyThePeak {
//    self.isPeakNotified = true;
//}

@end
