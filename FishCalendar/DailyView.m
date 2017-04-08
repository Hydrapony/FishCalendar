//
//  DailyView.m
//  日常增加页
//
//  Created by Hydra on 17/2/23.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "DailyView.h"

#import "ClassName+CoreDataProperties.h"
#import "Iconimg+CoreDataClass.h"

@implementation DailyView

#pragma mark 初始化

// 初始化并设置代理
- (instancetype)initWithDelegate:(id<DailyViewDelegate>)theDelegate
{
    self = [super init];
    if (self) {
        self.dailyViewDelegate = theDelegate;
        
        [self setFrame:viewBounds];
        [self setContentSize:viewBounds.size];
        [self setContentSize:CGSizeMake(viewBounds.size.width, viewBounds.size.height * 1.64)];
        self.scrollEnabled = NO;
        
        [self addDate]; // 加载当前日期数据
        [self initData]; // 加载备选数据
        [self addControl]; // 加载控件
        [self addControlWithNew]; // 新建任务，填充默认数据
    }
    return self;
}

// 加载当前日期数据
-(void)addDate{
    _dateNow = [NSDate date];
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _compsNow = [_calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:_dateNow];
    _compsenddate = [_calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:_dateNow];
}

// 加载备选数据
-(void)initData{
    NSMutableArray *adata = [self.dailyViewDelegate addData];
    _classNameArray = [adata objectAtIndex:0];
    NSArray *iconimgs = [adata objectAtIndex:1];
    _iconArray = [NSMutableArray new];
    for (Iconimg *ia in iconimgs) {
        [_iconArray addObject:ia.imgname];
    }
}

// 加载控件
-(void)addControl{
    
    // 名称 （标签、选择控件、输入控件、下划线、输入方式切换按钮）
    _nameL = [UILabel new];
    _nameL.text = @"作业名称：";
    _nameL.textColor = [UIColor whiteColor];
    _nameL.font = [UIFont systemFontOfSize:kLabelTextFontSize];
    CGSize infoSize=[_nameL.text sizeWithAttributes:@{NSFontAttributeName:_nameL.font}];
    [_nameL setFrame:CGRectMake(kLeftX - infoSize.width, 80, infoSize.width, infoSize.height)];
    [self addSubview:_nameL];
    
    _name = [[UIPickerView alloc]initWithFrame:CGRectMake(kRightX, 80 + infoSize.height/2 - 65, viewBounds.size.width - kRightX - 100, 65 * 2)];
    _name.delegate = self;
    _name.dataSource = self;
    [self addSubview:_name];
    
    _nameE = [UITextField new];
    _nameE.textColor = [UIColor whiteColor];
    _nameE.borderStyle = UITextBorderStyleNone;
    _nameE.font = [UIFont systemFontOfSize:kLabelTextFontSize];
    _nameE.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameE.keyboardType = UIKeyboardTypeDefault;
    _nameE.autocorrectionType = UITextAutocorrectionTypeNo;
    _nameE.delegate = self;
    [_nameE setFrame:CGRectMake(kRightX, 80 - 1, _name.frame.size.width, infoSize.height)];
    [_nameE setHidden:YES];
    [self addSubview:_nameE];
    
    UIView *nameELine=[[UIView alloc]initWithFrame:CGRectMake(_nameE.frame.origin.x,_nameE.frame.origin.y+_nameE.frame.size.height + 1, _nameE.frame.size.width, 1)];
    nameELine.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:nameELine];
    
    UIButton *_nameChangeBtn = [UIButton new];
    [_nameChangeBtn setFrame:CGRectMake(_nameE.frame.origin.x + _nameE.frame.size.width + 10, _nameE.frame.origin.y, infoSize.height, infoSize.height)];
    [_nameChangeBtn setImage:[UIImage imageNamed:@"pen-checkbox-white.png"] forState:UIControlStateNormal];
    [_nameChangeBtn addTarget:self action:@selector(nameImputChange) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nameChangeBtn];
    
    // 标识图 （标签、左右选择按钮、图示）
    _nameimgL = [UILabel new];
    _nameimgL.text = @"标识图：";
    _nameimgL.textColor = [UIColor whiteColor];
    _nameimgL.font = [UIFont systemFontOfSize:kLabelTextFontSize];
    infoSize=[_nameimgL.text sizeWithAttributes:@{NSFontAttributeName:_nameimgL.font}];
    [_nameimgL setFrame:CGRectMake(kLeftX - infoSize.width, _nameL.frame.origin.y + 90, infoSize.width, infoSize.height)];
    [self addSubview:_nameimgL];
    
    UIButton *_nameimgLeft = [UIButton new];
    [_nameimgLeft setFrame:CGRectMake(kRightX + 13, _nameimgL.frame.origin.y, 24, 24)];
    [_nameimgLeft setImage:[UIImage imageNamed:@"triangle-left-white.png"] forState:UIControlStateNormal];
    [_nameimgLeft addTarget:self action:@selector(nameImgChangeLeft) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nameimgLeft];
    
    _nameimg = [[UIImageView alloc]init];
    [_nameimg setFrame:CGRectMake(_nameimgLeft.frame.origin.x + 24 + 16, _nameimgL.frame.origin.y + infoSize.height/2 - 24, 24 * 2, 24 * 2)];
    [self addSubview:_nameimg];
   
    UIButton *_nameimgRight = [UIButton new];
    [_nameimgRight setFrame:CGRectMake(_nameimg.frame.origin.x + 48 + 16, _nameimgL.frame.origin.y, 24, 24)];
    [_nameimgRight setImage:[UIImage imageNamed:@"triangle-right-white.png"] forState:UIControlStateNormal];
    [_nameimgRight addTarget:self action:@selector(nameImgChangeRight) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nameimgRight];
    
    // 计划耗时 （标签、选择控件、两个说明标签）
    _havedoneL = [UILabel new];
    _havedoneL.text = @"耗时：";
    _havedoneL.textColor = [UIColor whiteColor];
    _havedoneL.font = [UIFont systemFontOfSize:kLabelTextFontSize];
    infoSize=[_havedoneL.text sizeWithAttributes:@{NSFontAttributeName:_havedoneL.font}];
    [_havedoneL setFrame:CGRectMake(kLeftX - infoSize.width, _nameimgL.frame.origin.y + 95, infoSize.width, infoSize.height)];
    [self addSubview:_havedoneL];
    
    _havedone = [[UIPickerView alloc]initWithFrame:CGRectMake(kRightX, 265 + infoSize.height/2 - 65, viewBounds.size.width - kRightX - 100, 65 * 2)];
    _havedone.delegate = self;
    _havedone.dataSource = self;
    [self addSubview:_havedone];
    
    UILabel *_havedoneMen = [UILabel new];
    _havedoneMen.text = @"时";
    _havedoneMen.textColor = [UIColor whiteColor];
    _havedoneMen.font = [UIFont systemFontOfSize:kLittleLabelTextFontSize];
    infoSize=[_havedoneMen.text sizeWithAttributes:@{NSFontAttributeName:_havedoneMen.font}];
    _havedoneMen.frame = CGRectMake(_havedone.frame.origin.x + _havedone.frame.size.width/2 - infoSize.width/2, _havedone.frame.origin.y + _havedone.frame.size.height/2 - infoSize.height/2,infoSize.width,infoSize.height);
    [self addSubview:_havedoneMen];
    
    UILabel *_havedoneMen2 = [UILabel new];
    _havedoneMen2.text = @"分";
    _havedoneMen2.textColor = [UIColor whiteColor];
    _havedoneMen2.font = [UIFont systemFontOfSize:kLittleLabelTextFontSize];
    _havedoneMen2.frame = CGRectMake(_havedoneMen.frame.origin.x + _havedone.frame.size.width/2 + 9, _havedoneMen.frame.origin.y ,infoSize.width,infoSize.height);
    [self addSubview:_havedoneMen2];
    
    // 截止日期 （标签、选择控件、三个说明标签）
    _enddateL = [UILabel new];
    _enddateL.text = @"计划日期：";
    _enddateL.textColor = [UIColor whiteColor];
    _enddateL.font = [UIFont systemFontOfSize:kLabelTextFontSize];
    infoSize=[_enddateL.text sizeWithAttributes:@{NSFontAttributeName:_enddateL.font}];
    [_enddateL setFrame:CGRectMake(kLeftX - infoSize.width, _havedoneL.frame.origin.y + 132, infoSize.width, infoSize.height)];
    [self addSubview:_enddateL];
    
    _lastDayOfDate = [self getLastDayOfDate:_dateNow];
    
    _enddate = [UIPickerView new];
    _enddate.frame = CGRectMake(kRightX, _enddateL.frame.origin.y + infoSize.height/2 - 65,viewBounds.size.width - kRightX - 70, 65 * 2);
    _enddate.delegate = self;
    _enddate.dataSource = self;
    [self addSubview:_enddate];
    
    UILabel *_enddateY = [UILabel new];
    _enddateY.text = @"年";
    _enddateY.textColor = [UIColor whiteColor];
    _enddateY.font = [UIFont systemFontOfSize:kLittleLabelTextFontSize];
    infoSize=[_enddateY.text sizeWithAttributes:@{NSFontAttributeName:_enddateY.font}];
    _enddateY.frame = CGRectMake(_enddate.frame.origin.x + _enddate.frame.size.width/3 - infoSize.width/2, _enddate.frame.origin.y + _enddate.frame.size.height/2 - infoSize.height/2,infoSize.width,infoSize.height);
    [self addSubview:_enddateY];
    
    UILabel *_enddateM = [UILabel new];
    _enddateM.text = @"月";
    _enddateM.textColor = [UIColor whiteColor];
    _enddateM.font = [UIFont systemFontOfSize:kLittleLabelTextFontSize];
    _enddateM.frame = CGRectMake(_enddate.frame.origin.x + _enddate.frame.size.width/3 * 2 - infoSize.width/2, _enddate.frame.origin.y + _enddate.frame.size.height/2 - infoSize.height/2,infoSize.width,infoSize.height);
    [self addSubview:_enddateM];
    
    UILabel *_enddateD = [UILabel new];
    _enddateD.text = @"日";
    _enddateD.textColor = [UIColor whiteColor];
    _enddateD.font = [UIFont systemFontOfSize:kLittleLabelTextFontSize];
    _enddateD.frame = CGRectMake(_enddate.frame.origin.x + _enddate.frame.size.width - infoSize.width/2, _enddate.frame.origin.y + _enddate.frame.size.height/2 - infoSize.height/2,infoSize.width,infoSize.height);
    [self addSubview:_enddateD];
    
    _dateenddate = [_calendar dateFromComponents:_compsenddate];
    
    // 是否添加详细信息
    _isInfoL = [UILabel new];
    _isInfoL.text = @"添加详细信息";
    _isInfoL.textColor = [UIColor whiteColor];
    _isInfoL.font = [UIFont systemFontOfSize:kLabelTextFontSize];
    infoSize=[_isInfoL.text sizeWithAttributes:@{NSFontAttributeName:_isInfoL.font}];
    [_isInfoL setFrame:CGRectMake(viewBounds.size.width - infoSize.width - 90, viewBounds.size.height*7/8 - infoSize.height * 2.2, infoSize.width, infoSize.height)];
    [self addSubview:_isInfoL];
    
    _isInfoCheckbox = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_isInfoCheckbox setFrame:CGRectMake(_isInfoL.frame.origin.x + infoSize.width + 25, _isInfoL.frame.origin.y + infoSize.height/2 - 16, 32, 32)];
    [_isInfoCheckbox setImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
    [_isInfoCheckbox setImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateSelected];
    [_isInfoCheckbox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_isInfoCheckbox];
    
    // 详细信息
    _infoL = [UILabel new];
    _infoL.text = @"详细信息：";
    _infoL.textColor = [UIColor whiteColor];
    _infoL.font = [UIFont systemFontOfSize:kLabelTextFontSize];
    infoSize=[_infoL.text sizeWithAttributes:@{NSFontAttributeName:_infoL.font}];
    [_infoL setFrame:CGRectMake(kLeftX - infoSize.width, viewBounds.size.height + 30, infoSize.width, infoSize.height)];
    [self addSubview:_infoL];
    
    _info = [[UIPickerView alloc]initWithFrame:CGRectMake(kRightX, viewBounds.size.height*7/8 + infoSize.height/2 + 13, viewBounds.size.width - kRightX - 100, 35 * 2)];
    _info.delegate = self;
    _info.dataSource = self;
    [self addSubview:_info];
    
    _addInfoHomeworkBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_addInfoHomeworkBtn setBackgroundImage:[UIImage imageNamed:@"new.png"] forState:UIControlStateNormal];
    [_addInfoHomeworkBtn setFrame:CGRectMake(_info.frame.origin.x + _info.frame.size.width + 15, _info.frame.origin.y + _info.frame.size.height/2 - 15, 30, 30)];
    [_addInfoHomeworkBtn addTarget:self action:@selector(addInfoHomework) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addInfoHomeworkBtn];
    
    _infoE = [UITextView new];
    _infoE.textColor = [UIColor whiteColor];
    [_infoE setBackgroundColor: [UIColor clearColor]];
    _infoE.scrollEnabled = NO;
    _infoE.font = [UIFont systemFontOfSize:kLittleLabelTextFontSize];
    [_infoE setFrame:CGRectMake(kRightX, _info.frame.origin.y +  _info.frame.size.height + 5,viewBounds.size.width - kRightX - 40, viewBounds.size.height/2)];
    _infoE.autocorrectionType = UITextAutocorrectionTypeNo;
    _infoE.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _infoE.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _infoE.layer.borderWidth = 1;
    [self addSubview:_infoE];
    
    // 增加键盘收起手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;   // 设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    [self addGestureRecognizer:tapGestureRecognizer]; // 将触摸事件添加到view上，这样view和其他控件上都可以用手势触发事件了
    
}

// 新建任务，填充默认数据
-(void)addControlWithNew{
    ClassName *cn = _classNameArray[0]; // 默认Class
    _nameE.text = cn.homeworkname;
    _nameimg.image = [UIImage imageNamed:cn.img];
    _iconCheck = (int)[_iconArray indexOfObject:cn.img];
    [_enddate selectRow:15 inComponent:0 animated:NO];
    [_enddate selectRow:[_compsNow month] - 1 inComponent:1 animated:NO];
    [_enddate selectRow:[_compsNow day] - 1 inComponent:2 animated:NO];
}







#pragma mark UITextFieldDelegate代理方法

// 当点击键盘的返回键（右下角）时，执行该方法隐藏键盘 所有输入框通用
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}










#pragma mark 选择器代理方法

// 控件包含的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    if(pickerView == _havedone){
        return 2;
    }
    if(pickerView == _enddate){
        return 3;
    }
    return 1;
}

// 行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 23;
}

// 控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView == _havedone){
        if(component == 0){
            return 13;
        }
        if(component == 1){
            return 6;
        }
    }
    if(pickerView == _name){
        return _classNameArray.count;
    }
    if(pickerView == _enddate){
        if(component == 0){
            return 31; // 前后15年
        }
        if(component == 1){
            return 12;
        }
        if(component == 2){
            return 31;
        }
    }
    if(pickerView == _info){
        ClassName *cn = _classNameArray[[_name selectedRowInComponent:0]];
        return cn.havehomework.count; 
    }
    return 1;
}

// 返回指定列和列表项的View
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *genderLabel = [UILabel new];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.textColor = [UIColor whiteColor];
    if(pickerView == _name){
        ClassName *cn = _classNameArray[row];
        genderLabel.text = cn.homeworkname;
        return genderLabel;
    }
    if(pickerView == _havedone){
        if (component == 0) {
            genderLabel.text = [NSString stringWithFormat: @"%ld",(long)row];
            return genderLabel;
        }else{
            genderLabel.text = [NSString stringWithFormat: @"%ld",(long)row * 10];
            return genderLabel;
        }
    }
    if(pickerView == _enddate){
        if (component == 0) {
            genderLabel.text = [NSString stringWithFormat: @"%ld",[_compsNow year] - 15 + (long)row];
            return genderLabel;
        }else{
            genderLabel.text = [NSString stringWithFormat: @"%ld",(long)row + 1];
            return genderLabel;
        }
    }
    if(pickerView == _info){
        ClassName *cn = _classNameArray[[_name selectedRowInComponent:0]];
        NSArray *homeworksArray = [cn.havehomework allObjects];
        HomeworkType *hTypeOfClass = homeworksArray[row];
        genderLabel.text = hTypeOfClass.typename;
        return genderLabel;
    }
    genderLabel.text = @"error";
    return genderLabel;
}

// 选中指定列和列表项时激发
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView == _name){
        ClassName *cn = _classNameArray[row];
        _nameE.text = cn.homeworkname;
        [_info reloadComponent:0]; // 重置homeworkType选择器
        _nameimg.image = [UIImage imageNamed:cn.img];// 改对应标示图
        _iconCheck = (int)[_iconArray indexOfObject:cn.img];
        return;
    }
    if(_enddate == pickerView){
        // 设置控件记录当天,_dateenddate形如"YYYY年MM月01日"
        int tempDay = (int)[_compsenddate day]; // 临时记录下之前记录的日
        if(component == 0){
            [_compsenddate setYear:[_compsNow year] - 15 + (long)row];
        }else if(component == 1){
            [_compsenddate setMonth:(long)row + 1];
        }
        [_compsenddate setDay:1]; // 临时将_compsenddate置为一日，用于计算当月天数
        _dateenddate = [_calendar dateFromComponents:_compsenddate];
        
        // 计算当月最后一天，无效日期自动回滚
        _lastDayOfDate = [self getLastDayOfDate:_dateenddate];
        if(component == 2){
            if((long)row + 1 > _lastDayOfDate){
                [_enddate selectRow:_lastDayOfDate - 1 inComponent:2 animated:YES];
                [_compsenddate setDay:_lastDayOfDate - 1];
            }else{
                [_compsenddate setDay:(long)row + 1];
            }
        }else{
            if(tempDay > _lastDayOfDate){
                [_enddate selectRow:_lastDayOfDate - 1 inComponent:2 animated:YES];
                [_compsenddate setDay:_lastDayOfDate - 1];
            }else{
                [_compsenddate setDay:tempDay]; // 将_compsenddate置回
            }
        }
        _dateenddate = [_calendar dateFromComponents:_compsenddate];
    }
    
}









#pragma mark 自定义方法

// 键盘收起手势
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_nameE resignFirstResponder];
    [_infoE resignFirstResponder];
}

// 变更名称输入方式
-(void)nameImputChange{
    [_nameE setHidden:!_nameE.isHidden];
    [_name setHidden:!_name.isHidden];
    if(_name.isHidden){
        [_nameE becomeFirstResponder];
    }else{
        [_nameE resignFirstResponder];
    }
}

// 标识图转换-上一个
-(void)nameImgChangeLeft{
    if(_iconCheck == 0){
        _iconCheck = (int)_iconArray.count - 1;
    }else{
        --_iconCheck;
    }
    [_nameimg setImage:[UIImage imageNamed:_iconArray[_iconCheck]]];
}

// 标识图转换-下一个
-(void)nameImgChangeRight{
    if(_iconCheck == (int)_iconArray.count - 1){
        _iconCheck = 0;
    }else{
        ++_iconCheck;
    }
    [_nameimg setImage:[UIImage imageNamed:_iconArray[_iconCheck]]];
}

// 是否有详细信息单选框
-(void)checkboxClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    if(btn.selected){
        [self setContentOffset:CGPointMake(0, btn.frame.origin.y - 30) animated:YES];
        self.scrollEnabled = YES;
    }else{
        [self setContentOffset:CGPointMake(0, 0) animated:YES];
        self.scrollEnabled = NO;
    }
}

// 增加选中详细信息按钮
-(void)addInfoHomework{
    ClassName *cn = _classNameArray[[_name selectedRowInComponent:0]];
    NSArray *homeworksArray = [cn.havehomework allObjects];
    if(homeworksArray.count > 0){
        HomeworkType *hTypeOfClass = homeworksArray[[_info selectedRowInComponent:0]];
        _infoE.text = [NSString stringWithFormat:@"%@%@\n", _infoE.text, hTypeOfClass.typename];
    }
}

// 获取某日期当月最后一天
-(int)getLastDayOfDate:(NSDate*)date{
    NSInteger monthlength = [_calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length; // 获取当月天数
    return (int)monthlength;
}

// 保存
-(void)save{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CCD"]];
    
    long havedoneAll = [_havedone selectedRowInComponent:0]*60+[_havedone selectedRowInComponent:1]*10;
    
    NSDictionary *dailyDic = @{@"saveType":@"Daily",
                               @"name":_nameE.text,
                               @"imgname":_iconArray[_iconCheck],
                               @"havedone":@(havedoneAll),
                               @"enddate":[formatter stringFromDate:[[NSDate alloc] initWithTimeInterval:60*60*12 sinceDate:_dateenddate]], // 加12小时，防止时区问题，不必精确因为enddate只保存日期
                               @"info":(_isInfoCheckbox.selected?[_infoE text]:_nameE.text)};
    if(![self.dailyViewDelegate saveData:(NSDictionary*)dailyDic]){
        // 保存报错，数据错误
        [Constant alertError:(UIViewController*)_dailyViewDelegate];
        return;
    }
    
    // 若在第二天凌晨天隙间前增加上一天的任务，算作是正在执行的，需要更新进度条
    int daycutTime = [kSlashTime intValue];
    NSDate *tempDate = _dateNow;
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // UTC时间
    [cal setTimeZone:[NSTimeZone timeZoneWithName:@"CCD"]];
    NSDateComponents *comps = [cal components:NSCalendarUnitHour fromDate:_dateNow]; // 取数据（北京时间）
    if([comps hour] < daycutTime){
        tempDate = [[NSDate alloc] initWithTimeInterval:-60*60*24 sinceDate:_dateNow];
    }
    NSString *nowDateStr = [formatter stringFromDate:tempDate];
    NSDate *nowDate0 = [formatter dateFromString:nowDateStr]; // 当天时间的日期（0点）
    
    if ([nowDate0 compare:_dateenddate] == NSOrderedSame) {
        [_dailyViewDelegate updateListAndProgressView:havedoneAll];
    }else if([nowDate0 compare:_dateenddate] == NSOrderedDescending){
        [_dailyViewDelegate updateList];
    }
    [self removeTheEffeView];
}

// 保存为日常
-(void)saveDaily{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CCD"]];
    
    // 不使用_dateenddate，而是从当天开始增加任务
    /* 0323 改回使用_dateenddate
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CCD"]];
     formatter.dateFormat = @"yyyyMMdd";
     NSString *nowDateStr = [formatter stringFromDate:]; // _dateNow
     NSDate *nowDate0 = [formatter dateFromString:nowDateStr]; // 当天时间的日期（0点）
     */
    // 若在第二天凌晨天隙间前增加上一天的任务，算作是正在执行的，需要更新进度条
    
    int daycutTime = [kSlashTime intValue];
    NSDate *tempDate = _dateNow;
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // UTC时间
    [cal setTimeZone:[NSTimeZone timeZoneWithName:@"CCD"]];
    NSDateComponents *comps = [cal components:NSCalendarUnitHour fromDate:_dateNow]; // 取数据（北京时间）
    if([comps hour] < daycutTime){
        tempDate = [[NSDate alloc] initWithTimeInterval:-60*60*24 sinceDate:_dateNow];
    }
    NSString *nowDateStr = [formatter stringFromDate:tempDate];
    NSDate *nowDate0 = [formatter dateFromString:nowDateStr]; // 当天时间的日期（0点）
    
    // 若是_dateenddate在今天之前，警示“计划日期”标签后返回
    if ([nowDate0 compare:_dateenddate] == NSOrderedDescending) {
        _enddateL.textColor = [UIColor redColor];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reienddateL) userInfo:nil repeats:NO];
        return;
    }
    
    long havedoneAll = [_havedone selectedRowInComponent:0]*60+[_havedone selectedRowInComponent:1]*10;
    
    NSDictionary *dailyLDic = @{@"saveType":@"DailyLong",
                               @"name":_nameE.text,
                               @"imgname":_iconArray[_iconCheck],
                               @"havedone":@(havedoneAll),
                               @"recentdate":[formatter stringFromDate:[[NSDate alloc] initWithTimeInterval:3600*36 sinceDate:_dateenddate]], // 加1天零12小时，防止时区问题，不必精确因为enddate只保存日期 加一天是因为当天的直接在下面生成出来
                               @"fromdate":[formatter stringFromDate:[[NSDate alloc] initWithTimeInterval:3600*12 sinceDate:_dateenddate]],
                               @"info":(_isInfoCheckbox.selected?[_infoE text]:_nameE.text)};
    if(![self.dailyViewDelegate saveData:(NSDictionary*)dailyLDic]){
        // 保存报错，数据错误
        [Constant alertError:(UIViewController*)_dailyViewDelegate];
        return;
    }
    NSDictionary *dailyDic = @{@"saveType":@"Daily",
                               @"name":_nameE.text,
                               @"imgname":_iconArray[_iconCheck],
                               @"havedone":@(havedoneAll),
                               @"enddate":[formatter stringFromDate:[[NSDate alloc] initWithTimeInterval:3600*12 sinceDate:_dateenddate]], // 加12小时，防止时区问题，不必精确因为enddate只保存日期
                               @"info":(_isInfoCheckbox.selected?[_infoE text]:_nameE.text)};
    if(![self.dailyViewDelegate saveData:(NSDictionary*)dailyDic]){
        // 保存报错，数据错误
        [Constant alertError:(UIViewController*)_dailyViewDelegate];
        return;
    }
    if([nowDate0 compare:_dateenddate] == NSOrderedSame){
        [_dailyViewDelegate updateListAndProgressView:havedoneAll];
    }
    [self removeTheEffeView];
}

// 取消
-(void)cancel{
    [self removeTheEffeView];
}

// 警示“计划日期”标签后还原标签 计时器触发
-(void)reienddateL{
    _enddateL.textColor = [UIColor whiteColor];
}

-(void)removeTheEffeView{
    // 一个普通动画，使毛玻璃View变透明后移除
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionCurveEaseIn animations:^{
        self.superview.alpha = 0;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}

@end
