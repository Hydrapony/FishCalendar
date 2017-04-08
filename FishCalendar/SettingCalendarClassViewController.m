//
//  SettingCalendarClassViewController.m
//  课程表设置-课程管理
//
//  Created by Hydra on 17/3/13.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "SettingCalendarClassViewController.h"

#import "RootViewController.h"
#import "ClassName+CoreDataProperties.h"

#define kLightBGColor [UIColor colorWithRed:48/255.0 green:50/255.0 blue:86/255.0 alpha:1] // 浅色背景
#define kDarkBGColor [UIColor colorWithRed:23/255.0 green:23/255.0 blue:23/255.0 alpha:1]// 深色背景
#define kDarkCellColor [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1]// 深色列背景
#define kLightTextColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]// 浅色列字体
#define kGreenTextColor [UIColor colorWithRed:12/255.0 green:180/255.0 blue:12/255.0 alpha:1]

@interface SettingCalendarClassViewController ()

@end

@implementation SettingCalendarClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    zdbcontext = [Constant createDbContext];
    [self addData]; // 查询备选数据
    [self initNavigationBarView]; // 顶部栏设置
    [self initTableView]; // 列表设置
    
    ablankView = [blankView new];
    [self.view addSubview:ablankView];
    
    // 增加键盘收起手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;   // 设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    [self.view addGestureRecognizer:tapGestureRecognizer]; // 将触摸事件添加到view上，这样view和其他控件上都可以用手势触发事件了
}

// 查询备选数据、填充所有cell
-(void)addData{
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"ClassName"];  // 查询所有课程名
    //NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    //request.sortDescriptors = @[sort];
    _classes = [[zdbcontext executeFetchRequest:request error:nil] mutableCopy];
    int rowc = (int)_classes.count;
    
    _cells = [[NSMutableArray alloc]init];
    _rowStates = [NSMutableArray new];
    for (int i = 0; i<rowc; ++i) {
        // 初始化编辑状态
        [_rowStates addObject:@0];
        
        NSMutableArray *_cellrows = [[NSMutableArray alloc]init];
        // 加入对应的cell(4行)
        SettingCalendarClassViewCell *cell = [[SettingCalendarClassViewCell alloc]initForLabel];
        ClassName *theClass = _classes[i];
        [cell loadClass:theClass withInfo:@{@"type":@0}];
        cell.celldelegate = self;
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.backgroundColor = kDarkCellColor;
        cell.indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];
        [_cellrows addObject:cell];
        
        SettingCalendarClassViewCell *cell1 = [[SettingCalendarClassViewCell alloc]initForName];
        [cell1 loadClass:theClass withInfo:@{@"type":@1}];
        cell1.celldelegate = self;
        cell1.selectionStyle = UITableViewCellAccessoryNone;
        cell1.backgroundColor = kDarkCellColor;
        cell1.indexPath = [NSIndexPath indexPathForRow:1 inSection:i];
        cell1.selectedBackgroundView = [[UIView alloc] initWithFrame:cell1.frame];
        cell1.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];
        [_cellrows addObject:cell1];
        
        SettingCalendarClassViewCell *cell2 = [[SettingCalendarClassViewCell alloc]initForImg];
        [cell2 loadClass:theClass withInfo:@{@"type":@2}];
        cell2.celldelegate = self;
        cell2.selectionStyle = UITableViewCellAccessoryNone;
        cell2.backgroundColor = kDarkCellColor;
        cell2.indexPath = [NSIndexPath indexPathForRow:2 inSection:i];
        cell2.selectedBackgroundView = [[UIView alloc] initWithFrame:cell2.frame];
        cell2.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];
        [_cellrows addObject:cell2];
        
        SettingCalendarClassViewCell *cell3 = [[SettingCalendarClassViewCell alloc]initForHomework];
        [cell3 loadClass:theClass withInfo:@{@"type":@3}];
        cell3.celldelegate = self;
        cell3.selectionStyle = UITableViewCellAccessoryNone;
        cell3.backgroundColor = kDarkCellColor;
        cell3.indexPath = [NSIndexPath indexPathForRow:3 inSection:i];
        cell3.selectedBackgroundView = [[UIView alloc] initWithFrame:cell3.frame];
        cell3.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];
        [_cellrows addObject:cell3];
        
        [_cells addObject:_cellrows];
    }
    
    request=[NSFetchRequest fetchRequestWithEntityName:@"Iconimg"];  // 查询所有img
    _icones = [zdbcontext executeFetchRequest:request error:nil];
}

// 顶部栏设置
- (void)initNavigationBarView{
    _navigationBarView=[[UIView alloc]initWithFrame:CGRectMake(viewBounds.origin.x, viewBounds.origin.y, viewBounds.size.width, kNavigationBarViewHigh)];
    _navigationBarView.backgroundColor = kLightBGColor;
    
    // 左侧返回按钮
    UIButton *btnReturn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnReturn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnReturn setFrame:kbtn1rect];
    [btnReturn addTarget:self action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:btnReturn];
    
    // 中部标签
    UILabel *titleL = [UILabel new];
    titleL.text = @"课程管理";
    titleL.textColor = [UIColor whiteColor];
    titleL.font = [UIFont systemFontOfSize:17];
    CGSize infoSize=[titleL.text sizeWithAttributes:@{NSFontAttributeName:titleL.font}];
    [titleL setFrame:CGRectMake((viewBounds.size.width - infoSize.width)/2, 34, infoSize.width, infoSize.height)];
    [_navigationBarView addSubview:titleL];
    
    // 右侧添加按钮
    UIButton *btnAddClass = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnAddClass setBackgroundImage:[UIImage imageNamed:@"new.png"] forState:UIControlStateNormal];
    [btnAddClass setFrame:kbtn3rect];
    [btnAddClass addTarget:self action:@selector(btnAddClass) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:btnAddClass];
    
    // 右侧删除按钮
    UIButton *btnDelClass = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnDelClass setBackgroundImage:[UIImage imageNamed:@"Trash.png"] forState:UIControlStateNormal];
    [btnDelClass setFrame:kbtn4rect];
    [btnDelClass addTarget:self action:@selector(btnDelClass) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:btnDelClass];
    
    [self.view addSubview:_navigationBarView];
}

// 列表设置
- (void)initTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(viewBounds.origin.x, viewBounds.origin.y + kNavigationBarViewHigh, viewBounds.size.width, viewBounds.size.height - kNavigationBarViewHigh) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = kDarkBGColor;
    [_tableView setSeparatorColor:[UIColor darkGrayColor]];
    _tableView.showsVerticalScrollIndicator = NO; // 去掉横向滚动条
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}

// 状态栏改为亮色样式
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}












#pragma mark TableView代理方法

// 设置行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingCalendarClassViewCell *cell= _cells[indexPath.section][indexPath.row];
    return cell.height;
}

// 改写删除按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

// 删除响应
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        if ([ClassName removeClassName:_classes[indexPath.section] withDbcx:zdbcontext]) {
            [_tableView beginUpdates]; // 更新
            [_classes removeObject:_classes[indexPath.section]]; //删除数据源
            [_cells removeObjectAtIndex:indexPath.section];
            int nowRowStates = (int)_rowStates.count - 1;
            [_rowStates removeAllObjects];
            for(int i = 0; i<nowRowStates; ++i){
                [_rowStates addObject:@0];
            }
            for(int i = (int)indexPath.section; i<nowRowStates; ++i){
                for(int j = 0;j<4;++j){
                    SettingCalendarClassViewCell *cellch= _cells[i][j];
                    cellch.indexPath = [NSIndexPath indexPathForRow:cellch.indexPath.row inSection:cellch.indexPath.section - 1];
                }
            }
            [_tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
            [_tableView endUpdates]; // 结束更新
        }
    }
}








#pragma mark Tableview 数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _classes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[_rowStates objectAtIndex:section] intValue] == 0) {
        return 1;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;//section头部高度
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;//底部间距
}

// 返回列表行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cells[indexPath.section][indexPath.row];
}





 

# pragma mark SettingCalendarClassViewCell代理方法

// 查询所有图示名
-(NSArray*)getIconData{
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Iconimg"];
    return [zdbcontext executeFetchRequest:request error:nil];
}

// 展示编辑格
-(void)setEditingcells:(int)sec forAdd:(bool)isadd{
    if(isadd){
        [_rowStates replaceObjectAtIndex:sec withObject:@1];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:sec],
                                                 [NSIndexPath indexPathForRow:2 inSection:sec],
                                                 [NSIndexPath indexPathForRow:3 inSection:sec]]
                              withRowAnimation:UITableViewRowAnimationTop];
        
    }else{
        [_rowStates replaceObjectAtIndex:sec withObject:@0];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:sec],
                                                 [NSIndexPath indexPathForRow:2 inSection:sec],
                                                 [NSIndexPath indexPathForRow:3 inSection:sec]]
                              withRowAnimation:UITableViewRowAnimationTop];
    }
}

-(bool)getablediting{
    return _tableView.isEditing;
}

-(void)reloadcells{
    [self.tableView reloadData];
}

// 检查是否可以保存，返回0为正常
-(int)checkcansave:(ClassName*)theClassName{
    // Name必填
    if(theClassName.name.length == 0){
        return 1;
    }
    // 检查重名
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"ClassName"];  // 查询所有任务名
    request.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name = '%@'",theClassName.name]];
    NSArray *result = [[zdbcontext executeFetchRequest:request error:nil] mutableCopy];
    // 实例池里有两个一样名字的，就不能更新数据库
    if (result.count > 1) {
        return 1;
    }
    return 0;
}

// 保存指定的ClassName
-(bool)saveClass:(ClassName*)theClassName WithInfo:(NSDictionary*)infoDic{
    
    if (theClassName.attribute1.length > 0) {
        NSMutableSet *homeworktypeset = [NSMutableSet new];
        NSArray *oa = [theClassName.attribute1 componentsSeparatedByString:@";"];
        for (NSString* typeStr in oa) {
            if(typeStr.length > 0){
                HomeworkType *htype = [HomeworkType addWithDictionary:@{@"typename":typeStr} withDbcx:zdbcontext];
                [homeworktypeset addObject:htype];
            }
        }
        theClassName.havehomework = homeworktypeset;
    }
    [ClassName modifyClassName:theClassName withDictionary:infoDic withDbcx:zdbcontext];
    return true;
}









#pragma mark UITextFieldDelegate代理方法

// 当点击键盘的返回键（右下角）时，执行该方法隐藏键盘 所有输入框通用
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}












#pragma mark 自定义方法

// 响应按钮：新建
-(void)btnAddClass{
    [_tableView beginUpdates]; // 更新
    int newClassNameSection = (int)_classes.count;
    int newClassNameSectionAddi = newClassNameSection + 1;
    
    // 检查是否有了"新课程%i"
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"ClassName"];  // 查询所有任务名
    NSString *newClassName = [NSString stringWithFormat:@"新课程%i",newClassNameSectionAddi];
    request.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name = '%@'",newClassName]];
    NSArray *checkArray = [[zdbcontext executeFetchRequest:request error:nil] mutableCopy];
    while(checkArray.count > 0){
        ++newClassNameSectionAddi;
        newClassName = [NSString stringWithFormat:@"新课程%i",newClassNameSectionAddi];
        request.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name = '%@'",newClassName]];
        checkArray = [[zdbcontext executeFetchRequest:request error:nil] mutableCopy];
    }
    NSDictionary *newdic = @{@"name":newClassName,@"img":@"Signature-01-128.png"};
    [ClassName addWithDictionary:newdic withDbcx:zdbcontext];

    NSArray *resultArray = [[zdbcontext executeFetchRequest:request error:nil] mutableCopy];
    if(resultArray.count == 1){
        ClassName *theClass = resultArray[0];
        [_classes addObject:theClass];
        // 初始化编辑状态
        [_rowStates addObject:@0];
        NSMutableArray *_cellrows = [[NSMutableArray alloc]init];
        // 加入对应的cell(4行)
        SettingCalendarClassViewCell *cell = [[SettingCalendarClassViewCell alloc]initForLabel];
        [cell loadClass:theClass withInfo:@{@"type":@0}];
        cell.celldelegate = self;
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.backgroundColor = kDarkCellColor;
        cell.indexPath = [NSIndexPath indexPathForRow:0 inSection:newClassNameSection];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];
        [_cellrows addObject:cell];
        
        if([_tableView isEditing]){
            [cell hideBtn:YES];
        }
        
        SettingCalendarClassViewCell *cell1 = [[SettingCalendarClassViewCell alloc]initForName];
        [cell1 loadClass:theClass withInfo:@{@"type":@1}];
        cell1.celldelegate = self;
        cell1.selectionStyle = UITableViewCellAccessoryNone;
        cell1.backgroundColor = kDarkCellColor;
        cell1.indexPath = [NSIndexPath indexPathForRow:1 inSection:newClassNameSection];
        cell1.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell1.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];
        [_cellrows addObject:cell1];
        
        SettingCalendarClassViewCell *cell2 = [[SettingCalendarClassViewCell alloc]initForImg];
        [cell2 loadClass:theClass withInfo:@{@"type":@2}];
        cell2.celldelegate = self;
        cell2.selectionStyle = UITableViewCellAccessoryNone;
        cell2.backgroundColor = kDarkCellColor;
        cell2.indexPath = [NSIndexPath indexPathForRow:2 inSection:newClassNameSection];
        cell2.selectedBackgroundView = [[UIView alloc] initWithFrame:cell2.frame];
        cell2.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];
        [_cellrows addObject:cell2];
        
        SettingCalendarClassViewCell *cell3 = [[SettingCalendarClassViewCell alloc]initForHomework];
        [cell3 loadClass:theClass withInfo:@{@"type":@3}];
        cell3.celldelegate = self;
        cell3.selectionStyle = UITableViewCellAccessoryNone;
        cell3.backgroundColor = kDarkCellColor;
        cell3.indexPath = [NSIndexPath indexPathForRow:3 inSection:newClassNameSection];
        cell3.selectedBackgroundView = [[UIView alloc] initWithFrame:cell3.frame];
        cell3.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];
        [_cellrows addObject:cell3];
        
        [_cells addObject:_cellrows];
    }else{
        // 报错TODO
    }
    
    [_tableView insertSections:[NSIndexSet indexSetWithIndex:newClassNameSection] withRowAnimation:UITableViewRowAnimationLeft];
    [_tableView endUpdates]; // 结束更新
}

// 打开删除状态
-(void)btnDelClass{
    if(!_tableView.editing){
        [self stopAllEditingcell];
    }else{
        [self endstopAllEditingcell];
    }
    [_tableView setEditing:!_tableView.editing animated:YES];
}

-(void)btnBack{
    //[ablankView becomeFirstResponder]; // 键盘收起
    //[ablankView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

// 收起所有cell
-(void)stopAllEditingcell{
    [_tableView beginUpdates]; // 更新
    for (int i=0; i<_rowStates.count; ++i) {
        SettingCalendarClassViewCell *cell = _cells[i][0];
        [cell hideBtn:true];
        if ([_rowStates[i] isEqual:@1]) {
            [cell stopEditForName];
            [_rowStates replaceObjectAtIndex:i withObject:@0];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:i],
                                                     [NSIndexPath indexPathForRow:2 inSection:i],
                                                     [NSIndexPath indexPathForRow:3 inSection:i]]
                                  withRowAnimation:UITableViewRowAnimationTop];
        }
    }
    [_tableView endUpdates];
}

// 停止收起所有cell
-(void)endstopAllEditingcell{
    [_tableView beginUpdates]; // 更新
    for (int i=0; i<_rowStates.count; ++i) {
        SettingCalendarClassViewCell *cell = _cells[i][0];
        [cell hideBtn:false];
    }
    [_tableView endUpdates];
}

// 键盘收起手势
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [ablankView becomeFirstResponder];
    //[ablankView resignFirstResponder];
}


@end
