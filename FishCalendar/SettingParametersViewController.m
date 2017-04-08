//
//  SettingParametersViewController.m
//  参数设置
//
//  Created by Hydra on 17/3/8.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "SettingParametersViewController.h"

#import "RootViewController.h"

#define kLightBGColor [UIColor colorWithRed:48/255.0 green:50/255.0 blue:86/255.0 alpha:1] // 浅色背景
#define kDarkBGColor [UIColor colorWithRed:23/255.0 green:23/255.0 blue:23/255.0 alpha:1]// 深色背景
#define kDarkCellColor [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1]// 深色列背景
#define kLightTextColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]// 浅色列字体
#define kGreenTextColor [UIColor colorWithRed:12/255.0 green:180/255.0 blue:12/255.0 alpha:1]

@interface SettingParametersViewController ()

@end

@implementation SettingParametersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBarView]; // 顶部栏设置
    [self getPlistdata]; // 获取plist数据
    [self addTableCellView]; // 列表预设置
    [self initTableView]; // 列表设置
    
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
    titleL.text = @"参数设置";
    titleL.textColor = [UIColor whiteColor];
    titleL.font = [UIFont systemFontOfSize:17];
    CGSize infoSize=[titleL.text sizeWithAttributes:@{NSFontAttributeName:titleL.font}];
    [titleL setFrame:CGRectMake((viewBounds.size.width - infoSize.width)/2, 34, infoSize.width, infoSize.height)];
    [_navigationBarView addSubview:titleL];
    
    // 右侧返回主页按钮
    UIButton *btnHome = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnHome setBackgroundImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
    [btnHome setFrame:kbtn4rect];
    [btnHome addTarget:self action:@selector(btnReturnin) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:btnHome];
    
    [self.view addSubview:_navigationBarView];
}

// 获取plist数据
-(void)getPlistdata{
    _settings = ksettingsAll[@"setting"];
}

// 列表预设置
- (void)addTableCellView{
    _switch0 = [[UISwitch alloc] init];
    _switch0.on = [_settings[@"0"] boolValue];
    _switch0.transform = CGAffineTransformScale(_switch0.transform, 0.7, 0.7);
    _switch0.transform = CGAffineTransformTranslate(_switch0.transform, -10, 0);
    [_switch0 addTarget:self action:@selector(switch0) forControlEvents:UIControlEventValueChanged];
    _switch0View = [UIView new];
    _switch0View.frame = CGRectMake(0, 0, _switch0.frame.size.width+_switch0.frame.origin.x*2, _switch0.frame.size.height+_switch0.frame.origin.y*2);
    [_switch0View addSubview:_switch0];
    
    _str1 = _settings[@"1"];
    if([_settings[@"4"] isEqualToString:@"黑色木纹"] || [_settings[@"4"] isEqualToString:@"黑色花纹"]){
        _str4 = _settings[@"4"];
    }else{
        _str4 = @"自定义";
    }
    _label6 = [UILabel new];
    _label6.textColor = kGreenTextColor;
    [self setUILabel:_label6 withText:_settings[@"6"][_settings[@"6"][@"0"]]];
    _label7 = [UILabel new];
    _label7.textColor = kGreenTextColor;
    [self setUILabel:_label7 withText:_settings[@"7"][_settings[@"7"][@"0"]]];
    _label8 = [UILabel new];
    _label8.textColor = kGreenTextColor;
    [self setUILabel:_label8 withText:[NSString stringWithFormat:@"%i:00",[_settings[@"8"] intValue]]];
    _label9 = [UILabel new];
    _label9.textColor = kGreenTextColor;
    [self setUILabel:_label9 withText:_settings[@"9"][_settings[@"9"][@"0"]]];
    _label10 = [UILabel new];
    _label10.textColor = kGreenTextColor;
    [self setUILabel:_label10 withText:_settings[@"10"][_settings[@"10"][@"0"]]];
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











#pragma mark Tableview 数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
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
    static NSString *cellIdentifier1=@"UITableViewCellForSub";
    static NSString *cellIdentifier2=@"UITableViewCellForV1";
    UITableViewCell *cell;
    if(indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5){
        // 首先根据标识去缓存池取
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        // 如果缓存池没有到则重新创建并放到缓存池中
        if(!cell){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier2];
        }
        switch (indexPath.row) {
            case 1:
                cell.textLabel.text=@"字体";
                cell.detailTextLabel.text = _str1;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 2:
                cell.textLabel.text=@"字体颜色";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 3:
                cell.textLabel.text=@"高亮颜色";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 4:
                cell.textLabel.text=@"课程表背景";
                cell.detailTextLabel.text = _str4;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 5:
                cell.textLabel.text=@"外框颜色";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
        }
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:kTitleTextFontSize];
        cell.detailTextLabel.textColor = kGreenTextColor;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kInfoTextFontSize];// 这些detail是右侧的
        cell.backgroundColor = kDarkCellColor;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];
    }else{
        // 首先根据标识去缓存池取
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        // 如果缓存池没有到则重新创建并放到缓存池中
        if(!cell){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier1];
        }
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text=@"节能模式";
                cell.detailTextLabel.text = @"高频使用时，略微降低内存占用";
                cell.accessoryView = _switch0View;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            case 6:
                cell.textLabel.text=@"表头显示方式";
                cell.accessoryView = _label6;
                break;
            case 7:
                cell.textLabel.text=@"环按钮点击延迟";
                cell.accessoryView = _label7;
                break;
            case 8:
                cell.textLabel.text=@"每日分割点";
                cell.detailTextLabel.text = @"定义当日作业时段，即当日、明日分割点之间的24时";
                cell.accessoryView = _label8;
                break;
            case 9:
                cell.textLabel.text=@"默认打开作业标签";
                cell.accessoryView = _label9;
                break;
            case 10:
                cell.textLabel.text=@"作业进度显示方式";
                cell.detailTextLabel.text = @"位于作业页面上方导航栏进度条右侧";
                cell.accessoryView = _label10;
                break;
        }
        
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:kTitleTextFontSize];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kSecTitleTextFontSize];// 这些detail是下侧的
        cell.backgroundColor = kDarkCellColor;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];
    }
    
    

    
    return cell;
}

// 选中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int _setting0;
    switch (indexPath.row) {
        case 0:
            break;
        case 1:{
            SettingParametersFontViewController *settingcontroller = [[SettingParametersFontViewController alloc]init];
            settingcontroller.parDelegate = self;
            [self.navigationController pushViewController:settingcontroller animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        case 2:{
            SettingColorPickerViewController *colorCV = [[SettingColorPickerViewController alloc]initWithColor:_settings[@"2"] for:@"2"];
            colorCV.colorDelegate = self;
            [self.navigationController pushViewController:colorCV animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        case 3:{
            SettingColorPickerViewController *colorCV = [[SettingColorPickerViewController alloc]initWithColor:_settings[@"3"] for:@"3"];
            colorCV.colorDelegate = self;
            [self.navigationController pushViewController:colorCV animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        case 4:{
            SettingParametersBgViewController *settingcontroller = [[SettingParametersBgViewController alloc]init];
            settingcontroller.parDelegate = self;
            [self.navigationController pushViewController:settingcontroller animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        case 5:{
            SettingColorPickerViewController *colorCV = [[SettingColorPickerViewController alloc]initWithColor:_settings[@"5"] for:@"5"];
            colorCV.colorDelegate = self;
            [self.navigationController pushViewController:colorCV animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        case 6:
            _setting0 = [_settings[@"6"][@"0"] intValue];
            if(++_setting0 == [_settings[@"6"] count]){
                _setting0 = 1;
            }
            _settings[@"6"][@"0"] = [NSString stringWithFormat:@"%i",_setting0];
            [self setUILabel:_label6 withText:(_settings[@"6"][_settings[@"6"][@"0"]])];
            break;
        case 7:
            _setting0 = [_settings[@"7"][@"0"] intValue];
            if(++_setting0 == [_settings[@"7"] count]){
                _setting0 = 1;
            }
            _settings[@"7"][@"0"] = [NSString stringWithFormat:@"%i",_setting0];
            [self setUILabel:_label7 withText:(_settings[@"7"][_settings[@"7"][@"0"]])];
            break;
        case 8:
            _setting0 = [_settings[@"8"] intValue];
            if(++_setting0 == 10){
                _setting0 = 0;
            }
            _settings[@"8"] = [NSString stringWithFormat:@"%i",_setting0];
            [self setUILabel:_label8 withText:([NSString stringWithFormat:@"%i:00",_setting0])];
            break;
        case 9:
            _setting0 = [_settings[@"9"][@"0"] intValue];
            if(++_setting0 == [_settings[@"9"] count]){
                _setting0 = 1;
            }
            _settings[@"9"][@"0"] = [NSString stringWithFormat:@"%i",_setting0];
            [self setUILabel:_label9 withText:(_settings[@"9"][_settings[@"9"][@"0"]])];
            break;
        case 10:
            _setting0 = [_settings[@"10"][@"0"] intValue];
            if(++_setting0 == [_settings[@"10"] count]){
                _setting0 = 1;
            }
            _settings[@"10"][@"0"] = [NSString stringWithFormat:@"%i",_setting0];
            [self setUILabel:_label10 withText:(_settings[@"10"][_settings[@"10"][@"0"]])];
            break;
    }
    ksettingsAll[@"setting"] = _settings;
    [Constant saveplist:ksettingsAll tofile:@"setting.plist"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    return;
}











# pragma mark SettingParametersFont代理方法

-(void)checkin:(NSString *)fontStr{
    _str1 = fontStr;
    [_tableView reloadData];
}







# pragma mark SettingParametersBg代理方法

-(void)checkbg:(NSString *)bgStr{
    _str4 = bgStr;
    [_tableView reloadData];
}

// 打开一个UIImagePickerController
-(void)switchPic{
    picker4 = [[UIImagePickerController alloc]init]; // 初始化
    picker4.view.backgroundColor = [UIColor orangeColor];
    picker4.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//指定使用模式（数据来源类型）
    picker4.delegate = self;
    picker4.allowsEditing = NO; // 拍照完或在相册选完照片后，跳到编辑模式进行图片剪裁
    [self presentViewController:picker4 animated:YES completion:nil];
}








# pragma mark UIImagePickerController代理

//成功获得相片后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //通过UIImagePickerControllerMediaType判断返回的是照片还是视频
    NSString* type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:(NSString*)kUTTypeImage]&&picker.sourceType==UIImagePickerControllerSourceTypePhotoLibrary) {
        UIImage *edit = [info objectForKey:UIImagePickerControllerEditedImage]; // TODO 裁剪保存
        //获取图片的url
        NSURL* url = [info objectForKey:UIImagePickerControllerReferenceURL];
        _settings[@"4"] = [url absoluteString];
        _str4 = @"自定义";
        ksettingsAll[@"setting"] = _settings;
        [Constant saveplist:ksettingsAll tofile:@"setting.plist"];
        [_tableView reloadData];
    }else{
        return;
    }
    [picker4 dismissViewControllerAnimated:YES completion:nil];
}

//取消照相机的回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker4 dismissViewControllerAnimated:YES completion:nil];//模态方式退出uiimagepickercontroller
}








# pragma mark SettingColorPickerViewController代理

-(void)checkin:(NSString *)colorStr for:(NSString *)pknum{
    _settings[pknum] = colorStr;
    ksettingsAll[@"setting"] = _settings;
    [Constant saveplist:ksettingsAll tofile:@"setting.plist"];
}










#pragma mark 自定义方法

// 封装方法 用于初始化右侧accessoryView里的UILabel
-(UILabel*)setUILabel:(UILabel*)label withText:(NSString*)text{
    label.text = text;
    label.font = [UIFont systemFontOfSize:kInfoTextFontSize];
    CGSize infoSize=[label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    [label setFrame:CGRectMake(0,0, infoSize.width, infoSize.height)];
    return label;
}

// switch0 开关响应
-(void)switch0{
    _settings[@"0"] = [[NSNumber alloc]initWithBool:[_switch0 isOn]];
    ksettingsAll[@"setting"] = _settings;
    [Constant saveplist:ksettingsAll tofile:@"setting.plist"];
}

// 响应按钮：关闭模态窗口
-(void)btnReturnin{
    [Constant getSetting];
    RootViewController *rootctrl = self.navigationController.viewControllers[0];
    [rootctrl removeAllCtrls];
    [rootctrl drawCalendar];
    [rootctrl addBtns];
    [rootctrl updateSumTask];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)btnBack{
    [Constant getSetting];
    RootViewController *rootctrl = self.navigationController.viewControllers[0];
    [rootctrl removeAllCtrls];
    [rootctrl drawCalendar];
    [rootctrl addBtns];
    [rootctrl updateSumTask];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
