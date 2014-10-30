//
//  MainViewController.m
//  KBLove
//
//  Created by block on 14-10-13.
//  Copyright (c) 2014年 block. All rights reserved.
//

#import "MainViewController.h"
#import <ReactiveCocoa.h>
#import "KBDevices.h"
#import "KBUserManager.h"
#import "CircleViewController.h"
#import "KBDeviceManager.h"
@interface MainViewController (){
    CLLocationManager *_manager;
//    三种设备类型按钮
    UIButton *_petButton;
    UIButton *_carButton;
    UIButton *_personButton;
//    所有设备数组
    NSArray *_allDeviceArray;
//    三种类型设备数组
    NSMutableArray *_carDeviceArray;
    NSMutableArray *_petDeviceArray;
    NSMutableArray *_personDeviceArray;
//    三种类型设备是否含有
    BOOL _hasCarDevice;
    BOOL _hasPetDevice;
    BOOL _hasPersonDevice;
    
}

- (NSArray *)getFriendDeviceArray;
- (NSArray *)getCarDeviceArray;
- (NSArray *)getPetDeviceArray;
- (NSArray *)getPersonDeviceArray;


- (IBAction)click_car:(id)sender;
- (IBAction)click_person:(id)sender;
- (IBAction)click_pet:(id)sender;
- (IBAction)click_allDevices:(id)sender;
- (IBAction)click_friends:(id)sender;
- (IBAction)click_circle:(id)sender;
- (IBAction)click_devicesList:(id)sender;
- (IBAction)click_message:(id)sender;
- (IBAction)click_mine:(id)sender;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    [self setupData];
    [self setupView];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark 功能方法

//初始化一些界面参数
- (void)setupData{
    
    _personButton = (UIButton *)[self.view viewWithTag:100];
    _carButton = (UIButton *)[self.view viewWithTag:101];
    _petButton = (UIButton *)[self.view viewWithTag:102];
    
    _allDeviceArray = nil;
    
    _petDeviceArray = [NSMutableArray array];
    _personDeviceArray = [NSMutableArray array];
    _carDeviceArray = [NSMutableArray array];
    
    _hasPetDevice = NO;
    _hasCarDevice = NO;
    _hasPersonDevice = NO;
    
    
}

//加载设备数据
- (void)loadData{
    [KBDeviceManager getDeviceList:^(BOOL isSuccess, NSArray *resultArray) {
        if (isSuccess) {
            _allDeviceArray = resultArray;
            [self setupDeviceArray];
        }
    }];
}

//初始化界面
- (void)setupView{
    [self setupMapView];
    _petButton.enabled = false;
    [_petButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _carButton.enabled = false;
    [_carButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _personButton.enabled = false;
    [_personButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}

//初始化地图
- (void)setupMapView{
    [_mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
    _manager = [[CLLocationManager alloc]init];
    _manager.distanceFilter = kCLLocationAccuracyBest;
    //    _manager.delegate = self;
    [_manager startUpdatingLocation];
    
    CLLocationCoordinate2D cl2d = CLLocationCoordinate2DMake(40.035139, 116.311655);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion re = MKCoordinateRegionMake(cl2d, span);
    [_mapView setRegion:re];
}

- (void)setupDeviceArray{
    for (KBDevices *device in _allDeviceArray) {
        if ([device.type isEqualToNumber:@1]) {
            [_carDeviceArray addObject:device];
            _hasCarDevice = YES;
            _carButton.enabled = YES;
            [_carButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else if([device.type isEqualToNumber:@2]){
            [_petDeviceArray addObject:device];
            _hasPetDevice = YES;
            _petButton.enabled = YES;
            [_petButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else if([device.type isEqualToNumber:@3]){
            [_personDeviceArray addObject:device];
            _hasPersonDevice = YES;
            _personButton.enabled = YES;
            [_personButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

#pragma mark -
#pragma mark 界面点击事件
- (IBAction)click_car:(id)sender {
}


- (IBAction)click_person:(id)sender{
}

- (IBAction)click_pet:(id)sender{
}

- (IBAction)click_allDevices:(id)sender{
    
    [KBDeviceManager getDeviceList:^(BOOL isSuccess, NSArray *resultArray) {
        
    }];
    
}

- (IBAction)click_friends:(id)sender{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"FriendsStoryBoard" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"FriendsListTableViewController"];
    [self.navigationController pushViewController:vc animated:YES];
//    [self presentViewController:vc animated:YES completion:^{
//        
//    }];
}

- (IBAction)click_circle:(id)sender{
    CircleViewController *vc = [[CircleViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)click_devicesList:(id)sender{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceListViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)click_message:(id)sender{
}

- (IBAction)click_mine:(id)sender{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Me_StoryBoardN" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"MineViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
