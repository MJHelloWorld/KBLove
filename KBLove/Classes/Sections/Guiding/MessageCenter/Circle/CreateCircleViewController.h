//
//  CreateCircleViewController.h
//  KBLove
//
//  Created by 1124 on 14-10-14.
//  Copyright (c) 2014年 block. All rights reserved.
//

#import "CircleRootViewController.h"
#import "DXsearchView.h"
@interface CreateCircleViewController : CircleRootViewController<UISearchBarDelegate,DXSearchDisplayDelegate>
- (void)setMembers:(NSArray *)arr andCircleID:(NSString *)circlr_id;
- (void)createStart;
@end
