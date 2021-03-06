//
//  BoundPetInfoController.m
//  KBLove
//
//  Created by qianfeng on 38-1-1.
//  Copyright (c) 2038年 block. All rights reserved.
//

#import "BoundPetInfoController.h"
#import "BoundEquipmentInfo.h"
#import "KBHttpRequestTool.h"

@interface BoundPetInfoController ()

@end

@implementation BoundPetInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置宠物类型的checkBoxes
    self.PetType.titleArray = @[@"大型", @"中型", @"小型"];
    self.PetType.normalImage = @"登录_20";
    self.PetType.selectedImage = @"登录_23";
    
    // 设置宠物性别的checkBoxes
    self.PetSex.titleArray = @[@"男", @"女"];
    self.PetSex.normalImage = @"登录_20";
    self.PetSex.selectedImage = @"登录_23";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)rightNavBarButtonClick:(id)sender
{
    //  完成按钮   点击事件
    BoundEquipmentInfo *_equipment=[BoundEquipmentInfo sharedInstance];
    KBHttpRequestTool *httptool=[KBHttpRequestTool sharedInstance];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:@"7" forKey:@"cmd"];
    [dic setObject:@"1" forKey:@"operate"];
    //token  user_id  缺少
    KBUserInfo *user=[KBUserInfo sharedInfo];
    [dic setObject:user.token forKey:@"token"];
    [dic setObject:user.user_id forKeyedSubscript:@"user_id"];
    [dic setObject:_equipment.EquipmentIMEINum forKey:@"device_sn"];
    //头像
//    [dic setObject:@"" forKey:@"icon"];//尚未添加
    [dic setObject:self.PetName.text forKey:@"name"];
    [dic setObject:self.PetBreed.text forKey:@"dog_breed"];
    [dic setObject:self.PetType.selectedTitle forKey:@"dog_figure"];
    [dic setObject:self.PetBithday.currentTitle forKey:@"birth"];
    [dic setObject:self.PetSex.selectedTitle forKey:@"gender"];
    [dic setObject:self.PetHeight.text forKey:@"height"];
    [dic setObject:self.PetWeight.text forKey:@"weight"];
    
    NSLog(@"-- %@ - %@", self.PetSex.selectedTitle, self.PetType.selectedTitle);
    NSString *urlstr=@"http://118.194.192.104:8080/api/device.edit.do?";
    NSLog(@"%@",dic);
    [httptool request:urlstr requestType:0 params:dic overBlock:^(BOOL IsSuccess, id result) {
        if (IsSuccess) {
            NSLog(@"%@",result);
            NSNumber *ret=[result objectForKey:@"ret"];
            switch ([ret integerValue]) {
                case 1:{
            UIStoryboard *stb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                    UIViewController *vc = [stb instantiateViewControllerWithIdentifier:@"MainNavigationViewController"];
            [self presentViewController:vc animated:YES completion:^{
                        
                    }];
                }break;
                case 2:{
                    [UIAlertView showWithTitle:@"提示" Message:[result objectForKey:@"desc"] cancle:@"确定" otherbutton:nil block:^(NSInteger index) {
                        
                    }];
                }break;
                case 3:{
                    [UIAlertView showWithTitle:@"提示" Message:[result objectForKey:@"desc"] cancle:@"确定" otherbutton:nil block:^(NSInteger index) {
                        
                    }];

                    
                }break;

                default:
                    break;
            }



        }else
        {
            
        }
    }];
}

- (void)backNavBarButtonClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
