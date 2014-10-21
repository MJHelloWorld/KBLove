#import <UIKit/UIKit.h>
#import "PCPieChart.h"

@interface PCPieComponent : NSObject
{
    float value, startDeg, endDeg;
    NSString *title;
    UIColor *colour;
    
}
@property (nonatomic, assign) float value, startDeg, endDeg;
@property (nonatomic, retain) UIColor *colour;
@property (nonatomic, retain) NSString *title;


- (id)initWithTitle:(NSString*)_title value:(float)_value;
+ (id)pieComponentWithTitle:(NSString*)_title value:(float)_value;
@end

#define PCColorBlue [UIColor colorWithRed:0.0 green:153/255.0 blue:204/255.0 alpha:1.0]
#define PCColorGreen [UIColor colorWithRed:153/255.0 green:204/255.0 blue:51/255.0 alpha:1.0]
#define PCColorOrange [UIColor colorWithRed:1.0 green:153/255.0 blue:51/255.0 alpha:1.0]
#define PCColorRed [UIColor colorWithRed:1.0 green:51/255.0 blue:51/255.0 alpha:1.0]
#define PCColorYellow [UIColor colorWithRed:1.0 green:220/255.0 blue:0.0 alpha:1.0]
#define PCColorDefault [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]

@interface PCPieChart : UIView {
//    内容
    NSMutableArray *components;
//    直径
    int diameter;
//    字体
	UIFont *titleFont, *percentageFont;
//    显示箭头
	BOOL showArrow, sameColorLabel;
}
@property (nonatomic, assign) int diameter;
@property (nonatomic, retain) NSMutableArray *components;
@property (nonatomic, retain) UIFont *titleFont, *percentageFont;
@property (nonatomic, assign) BOOL showArrow, sameColorLabel;

@end
