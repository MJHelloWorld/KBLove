//
//  Circle_ShareViewController.m
//  KBLove
//
//  Created by 1124 on 14/10/22.
//  Copyright (c) 2014年 block. All rights reserved.
//

#import "Circle_ShareViewController.h"
#import "PositionCell.h"
#import "KBPositionInfo.h"
@interface Circle_ShareViewController ()
{
    SharePositionBlock _sblock;
    UIView *_headerView;
    KBPositionInfo *_selectPos;
}
@end

@implementation Circle_ShareViewController
- (void)setBlock:(SharePositionBlock)block
{
    _sblock=block;
    [self CreateUI];
    [self LoadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)CreateUI
{
    //创建 头部信息
    [self addBarItemWithImageName:@"NVBar_arrow_left.png" frame:CGRectMake(0, 0, 25, 25) Target:self Selector:@selector(BackClick:) isLeft:YES];
    [self addBarItemWithImageName:@"圈子创建_23" frame:CGRectMake(0, 0, 20, 20) Target:self Selector:@selector(FinishedClick:) isLeft:NO];
    self.navigationItem.titleView=[self makeTitleLable:@"位置" AndFontSize:18 isBold:YES];
    self.view.backgroundColor=[UIColor whiteColor];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth,ScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    UIImageView *bgimgv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"圈子1"]];
    bgimgv.frame=_tableView.bounds;
    _tableView.backgroundView=bgimgv;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorColor=[UIColor whiteColor];
    [self.view addSubview:_tableView];
    _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 240)];
    //加载地图控件
    _tableView.tableHeaderView=_headerView;

}
- (void)LoadData
{
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    //调用地图API获取附近信息
    
    
}
- (void)FinishedClick:(UIButton *)btn
{
    //创建地理位置模型，回调函数
}
- (void)BackClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellTag=@"PositionCell";
    PositionCell *cell=[tableView dequeueReusableCellWithIdentifier:cellTag];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:cellTag owner:self options:nil]lastObject];
    }
    return cell;
    
}
#pragma mark - UITableViewDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end