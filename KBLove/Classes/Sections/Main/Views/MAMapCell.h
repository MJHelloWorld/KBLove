//
//  TraceCell.h
//  KBLove
//
//  Created by Ming on 14-11-21.
//  Copyright (c) 2014年 block. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KBTracePart;
#import <MAMapKit/MAMapKit.h>

@interface MAMapCell : UITableViewCell <MAMapViewDelegate>

{
    void (^selectBlock)(int);
}

@property (nonatomic,copy)  NSString *device_sn;
@property (nonatomic, assign) long long startTime;
@property (nonatomic, assign) long long endTime;
@property (nonatomic ,strong) UIImageView *bottomImageview;
@property (nonatomic, strong) NSMutableArray* statusArray;      //

@property (nonatomic,strong) MAMapView *gaode_MapView;

- (void)setUpViewWithModel:(KBTracePart *)part selectedBlock:(void (^)(int))block;


@end