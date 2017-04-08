//
//  SettingCalendarClassViewCell.h
//  课程表设置-课程管理 列表项
//
//  Created by Hydra on 17/3/13.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"
#import "ClassName+CoreDataProperties.h"
#import "Iconimg+CoreDataProperties.h"

#pragma mark 任务页代理
@protocol SettingCalendarClassCellDelegate

-(void)setEditingcells:(int)sec forAdd:(bool)isadd; // 展示编辑列
-(void)reloadcells; // 刷新cells
-(int)checkcansave:(ClassName*)theClassName; // 检查是否可以保存
-(bool)saveClass:(ClassName*)theClassName WithInfo:(NSDictionary*)infoDic; // 保存数据
-(NSArray*)getIconData; // 获取icons
-(bool)getablediting; // 获取表格是否在编辑状态

@end

@interface SettingCalendarClassViewCell : UITableViewCell {
    bool _isediting; // 正在编辑
    ClassName *_theClassname;
    NSMutableArray *_iconArray; // 备选Icon名称数组
    
    UILabel *_name; // 课程名称
    UILabel *_nameFL; // 课程名称:
    UITextField *_nameF; // 课程名称输入框
    UIView *_nameFLine;
    UILabel *_homeworknameL; // 作业:
    UITextField *_homeworkname; // 课程作业名输入框
    UIView *_homeworknameLine;
    UILabel *_nameimgL; // 标识图:
    UIImageView *_nameimg; // 课程图像
    UILabel *_homeworksL; // 作业类型:
    NSMutableArray *_homeworks; // 课程作业类型
    UITextField *_homeworktype; // 课程作业类型框
    UIView *_homeworktypeLine;
    UIButton *_interactBtn; // 右侧按钮
    NSString *_iconName;
    int _iconCheck;
}

extern CGRect viewBounds;
extern int kTitleTextFontSize;

@property (assign,nonatomic) CGFloat height; // 单元格高度
@property (strong,nonatomic) NSIndexPath *indexPath; // 自己的indexPath
@property (strong,nonatomic) id<SettingCalendarClassCellDelegate> celldelegate; // 单元格高度

- (instancetype)initForLabel;
- (instancetype)initForName;
- (instancetype)initForImg;
- (instancetype)initForHomework;
- (void)stopEditForName;
- (void)hideBtn:(bool)hide;
- (void)loadClass:(ClassName*)classname withInfo:(NSDictionary*)infoDic; // 加载数据和列表行组信息

@end
