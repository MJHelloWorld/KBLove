//
//  TraceCell.m
//  KBLove
//
//  Created by Ming on 14-11-21.
//  Copyright (c) 2014年 block. All rights reserved.
//

#import "TraceCell.h"
#import <UIImageView+AFNetworking.h>
#import "TraceInfoView.h"
#import "KBTracePart.h"
#import "BMapKit.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "CCDeviceStatus.h"
#import "ZWL_MapUtils.h"
#import "TrackerReplayViewController.h"
#import "CCReplayGaoDeAnnotationView.h"

@implementation TraceCell

{
    TraceInfoView *infoView;
    
    BMKGeoPoint         _lastBMapPoint;
    CCDeviceStatus*     _startStatus;
    BMKPolyline*        _trackBMapPath;
    BMKPointAnnotation* _startBMapPoint;
    NSMutableArray*     _colorsTrack;
    
    BMKPointAnnotation* _endBMapPoint;
    BMKPointAnnotation* _currentBMapPoint;
    CCReplayAnnotationView* _currentPointBMapView;
    CCDeviceStatus*     _endStatus;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _statusArray = [[NSMutableArray alloc] init];
        _colorsTrack = [[NSMutableArray alloc] init];
        
        [self createInfo];
        
        [self addLocusListViewSwipe];
        
        [self createImageView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)createImageView
{
    self.bottomImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 65, kScreenWidth, 135)];
    _baidu_MapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 135)];
    [_bottomImageview addSubview:_baidu_MapView];
    [self.contentView insertSubview:_bottomImageview atIndex:0];
}

-(void)addLocusListViewSwipe
{
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeClick:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [infoView.locusListView addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeClick:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [infoView.locusListView addGestureRecognizer:rightSwipe];
}

-(void)swipeClick:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [UIView animateWithDuration:0.3 animations:^{
            infoView.locusListView.frame = CGRectMake(-160, 0, kScreenWidth + 160, 65);
            selectBlock(-1);
        }];
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [UIView animateWithDuration:0.3 animations:^{
            infoView.locusListView.frame = CGRectMake(0, 0, kScreenWidth + 160, 65);
            selectBlock(1);
        }];
    }
}

- (void)setUpViewWithModel:(KBTracePart *)part selectedBlock:(void (^)(int))block{
    _startTime =[part.endSpot.receive longLongValue];
    _endTime =[part.startSpot.receive longLongValue];
    
    [self requestBMapData];
    
    selectBlock = [block copy];
    
    
    infoView.startPlaceLabel.text = part.startSpot.addr;
    infoView.endPlaceLabel.text = part.endSpot.addr;
    
    infoView.startTimeLabel.text = [NSString stringFromDateNumber:part.startTime];
    infoView.endTimeLabel.text = [NSString stringFromDateNumber:part.endTime];
    
    infoView.travelDistanceLabel.text = [NSString stringWithFormat:@"%@ km",part.distance];
    float traveltravel = (-[part.endTime floatValue]+[part.startTime floatValue])/1000.0;
    traveltravel /=60.0*60.0;
    infoView.travelLastTimeLabel.text = [NSString stringWithFormat:@"%.1f 小时",traveltravel];
}

-(void)createInfo
{
//    NSArray *subArray = [self.contentView subviews];
//    for (id obj in subArray) {
//        if ([obj class] == [[[[NSBundle mainBundle] loadNibNamed:@"TraceInfoView" owner:self options:nil] lastObject] class]) {
//            return;
//        }
//    }
    infoView = [[[NSBundle mainBundle] loadNibNamed:@"TraceInfoView" owner:self options:nil] lastObject];
    [self.contentView addSubview:infoView];
}

-(void)requestBMapData
{
    AFHTTPRequestOperationManager *manager=[[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"application/json"];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:@"14" forKey:@"cmd"];
    [dic setObject:[KBUserInfo sharedInfo].token forKey:@"token"];
    [dic setObject:[KBUserInfo sharedInfo].user_id forKey:@"user_id"];
    [dic setObject:self.device_sn forKey:@"device_sn"];
    [dic setObject:[NSNumber numberWithDouble:self.startTime] forKey:@"begin"];
    [dic setObject:[NSNumber numberWithDouble:self.endTime] forKey:@"end"];
    [dic setObject:@"1" forKey:@"page_number"];
    [dic setObject:@"20" forKey:@"page_size"];
    [dic setObject:@"M2616_BD" forKey:@"app_name"];
    //
    [manager GET:Url_GetTrack parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSLog(@"%@",responseObject);
            NSDictionary *data=(NSDictionary *)responseObject;
            NSArray *data_Array=data[@"track"];
            for (int i=0; i< data_Array.count; i++) {
                CCDeviceStatus * device=[[CCDeviceStatus alloc]init];
                NSString *lngstr=data_Array[i][@"lng"];
                device.lang=[lngstr doubleValue]*1e6;
                device.lat=[data_Array[i][@"lat"] doubleValue]*1e6;
                device.speed=[data_Array[i][@"speed"] floatValue];
                device.receive=[data_Array[i][@"receive"] longLongValue];
                device.sn=data_Array[i][@"deviceSn"];
                device.stayed=[data_Array[i][@"stayed"] floatValue];
                device.heading=[data_Array[i][@"direction"] floatValue];
                BMKGeoPoint point={(int)device.lat,(int)device.lang};
                device.point=point;
                [_statusArray addObject:device];
                
            }
            
                [self loadDataOnBMap];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error :%@",error.localizedDescription);
        
    }];
}

-(void) loadDataOnBMap
{
    _baidu_MapView.delegate = self;

    [self addStartAndEndBMap];

    // 添加轨迹
    [self addTrackPathBMap];
}


-(void) addStartAndEndBMap
{
    BMKGeoPoint start;
    BMKGeoPoint end;
    
    _startStatus = [_statusArray lastObject];
    start = _startStatus.point;
    _endStatus = [_statusArray objectAtIndex:0];
    end = _endStatus.point;
    
    
    [ZWL_MapUtils adjustMapCenterAndSpan:_baidu_MapView statusInfo:_statusArray];

    
    if (_startBMapPoint) {
        [_baidu_MapView removeAnnotation:_startBMapPoint];
    }
    
    _startBMapPoint = [[BMKPointAnnotation alloc] init];
    _startBMapPoint.coordinate =[ZWL_MapUtils geoPoint2Coordinate2D:start];
    _startBMapPoint.title= [NSString stringWithFormat:@"%f %f",_startBMapPoint.coordinate.latitude,_startBMapPoint.coordinate.longitude];
    _startBMapPoint.subtitle=@"2sdvc24";
    [_baidu_MapView addAnnotation:_startBMapPoint];
    
    if (_endBMapPoint) {
        [_baidu_MapView removeAnnotation:_endBMapPoint];
    }
    
    _endBMapPoint = [[BMKPointAnnotation alloc] init];
    
    _endBMapPoint.subtitle=@"sjdfklwje";
    _endBMapPoint.coordinate =[ZWL_MapUtils geoPoint2Coordinate2D:end];
    _endBMapPoint.title=[NSString stringWithFormat:@"%f %f",_endBMapPoint.coordinate.latitude,_endBMapPoint.coordinate.longitude];
    [_baidu_MapView addAnnotation:_endBMapPoint];
}

-(void) addTrackPathBMap
{
    _lastBMapPoint = _startStatus.point;
    
    [_baidu_MapView removeOverlay:_trackBMapPath];
    
    [_baidu_MapView removeOverlays:_colorsTrack];
    
    [_colorsTrack removeAllObjects];


        NSInteger size = _statusArray.count;

    CLLocationCoordinate2D points[10000] = {0};
    
        for(int idx = (int)size - 1; idx >= 0; idx--)
        {
            CCDeviceStatus* current = [_statusArray objectAtIndex:idx];
            points[idx] = [ZWL_MapUtils geoPoint2Coordinate2D:current.point];
        }
        //添加
        _trackBMapPath = [BMKPolyline polylineWithCoordinates:points count:size];
        [_baidu_MapView addOverlay:_trackBMapPath];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    static NSString* annotationIdentifier = @"warningPin";

    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        if (annotation == _startBMapPoint) {
            BMKPinAnnotationView* annView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:annotationIdentifier];
            annView.image =  [UIImage imageNamed:@"dt_start.png"];
            return annView;
            
        } else if (annotation == _endBMapPoint) {
            BMKPinAnnotationView* annView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:annotationIdentifier];
            annView.image =  [UIImage imageNamed:@"dt_end.png"];
            return annView;
        } else if (annotation == _currentBMapPoint) {
            _currentPointBMapView = [[CCReplayAnnotationView alloc] initWithAnnotation:annotation
                                                                   reuseIdentifier:annotationIdentifier];
            
            return _currentPointBMapView;
        }
    }
    return nil;
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id )overlay
{
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = GRAY_LINE_COLOR;
        polylineView.lineWidth = TRACK_LINE_SIZE;
        return polylineView;
}

@end
