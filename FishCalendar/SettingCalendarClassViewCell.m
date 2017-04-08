//
//  SettingCalendarClassViewCell.m
//  课程表设置-课程管理 列表项
//
//  Created by Hydra on 17/3/13.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "SettingCalendarClassViewCell.h"

#define kcellHeight 44
#define krightBtnW 45

@implementation SettingCalendarClassViewCell

# pragma mark 初始化方法

// 展示行
- (instancetype)initForLabel{
    self = [super init];
    if (self) {
        CGSize infoSizeDemo=[@"测试文字:" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTitleTextFontSize]}];
        _height = kcellHeight;
        _isediting = NO;
        // 课程名称展示
        _name = [UILabel new];
        _name.textColor = [UIColor whiteColor];
        _name.font = [UIFont systemFontOfSize:kTitleTextFontSize];
        [self.contentView addSubview:_name];
        // 课程名称：
        _nameFL = [UILabel new];
        _nameFL.text = @"课程名称:";
        _nameFL.textAlignment = NSTextAlignmentRight;
        _nameFL.textColor = [UIColor whiteColor];
        _nameFL.font = [UIFont systemFontOfSize:kTitleTextFontSize];
        _nameFL.frame = CGRectMake(15, kcellHeight/2 - infoSizeDemo.height/2, infoSizeDemo.width, infoSizeDemo.height);
        [_nameFL setHidden:YES];
        [self.contentView addSubview:_nameFL];
        // 课程名称输入框
        _nameF = [UITextField new];
        _nameF.textColor = [UIColor whiteColor];
        _nameF.font = [UIFont systemFontOfSize:kTitleTextFontSize];
        _nameF.placeholder = @"输入课程名称";
        UILabel *label = [_nameF valueForKeyPath:@"_placeholderLabel"];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:kTitleTextFontSize-3];
        _nameF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameF.frame = CGRectMake(15 + infoSizeDemo.width + 10, kcellHeight/2 - infoSizeDemo.height/2, viewBounds.size.width - infoSizeDemo.width - krightBtnW - 30, infoSizeDemo.height);
        [_nameF addTarget:self action:@selector(nameFChange) forControlEvents:UIControlEventEditingChanged];
        [_nameF setHidden:YES];
        [self.contentView addSubview:_nameF];
        // 课程名称输入框下划线
        _nameFLine = [UIView new];
        _nameFLine.backgroundColor=[UIColor lightGrayColor];
        _nameFLine.frame = CGRectMake(_nameF.frame.origin.x,_nameF.frame.origin.y+_nameF.frame.size.height + 1, _nameF.frame.size.width, 1);
        [_nameFLine setHidden:YES];
        [self.contentView addSubview:_nameFLine];
        // 编辑按钮
        _interactBtn = [UIButton new];
        [_interactBtn addTarget:self action:@selector(editor) forControlEvents:UIControlEventTouchUpInside];
        [_interactBtn setImage:[UIImage imageNamed:@"pen-checkbox-white.png"] forState:UIControlStateNormal];
        [_interactBtn setFrame:CGRectMake(viewBounds.size.width - krightBtnW, (kcellHeight - 30)/2, 30, 30)];
       
        [self.contentView addSubview:_interactBtn];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

// 第一行
- (instancetype)initForName{
    self = [super init];
    if (self) {
        CGSize infoSizeDemo=[@"测试文字:" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTitleTextFontSize]}];
        _height = kcellHeight;
        _isediting = NO;
        // 作业:
        _homeworknameL = [UILabel new];
        _homeworknameL.text = @"作业:";
        _homeworknameL.textAlignment = NSTextAlignmentRight;
        _homeworknameL.textColor = [UIColor whiteColor];
        _homeworknameL.font = [UIFont systemFontOfSize:kTitleTextFontSize];
        _homeworknameL.frame = CGRectMake(15, kcellHeight/2 - infoSizeDemo.height/2, infoSizeDemo.width, infoSizeDemo.height);
        [self.contentView addSubview:_homeworknameL];
        // 作业名输入框
        _homeworkname = [UITextField new];
        _homeworkname.textColor = [UIColor whiteColor];
        _homeworkname.font = [UIFont systemFontOfSize:kTitleTextFontSize];
        _homeworkname.clearButtonMode = UITextFieldViewModeWhileEditing;
        _homeworkname.placeholder = @"对应作业名称";
        UILabel *label = [_homeworkname valueForKeyPath:@"_placeholderLabel"];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:kTitleTextFontSize-3];
        _homeworkname.font = [UIFont systemFontOfSize:kTitleTextFontSize];
        _homeworkname.frame = CGRectMake(15 + infoSizeDemo.width + 10, kcellHeight/2 - infoSizeDemo.height/2, viewBounds.size.width - infoSizeDemo.width - krightBtnW - 30, infoSizeDemo.height);
        [_homeworkname addTarget:self action:@selector(homeworknameChange) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_homeworkname];
        // 作业名下划线
        _homeworknameLine = [UIView new];
        _homeworknameLine.backgroundColor=[UIColor lightGrayColor];
        _homeworknameLine.frame = CGRectMake(_homeworkname.frame.origin.x,_homeworkname.frame.origin.y+_homeworkname.frame.size.height + 1, _homeworkname.frame.size.width, 1);
        [self.contentView addSubview:_homeworknameLine];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

// 第二行
- (instancetype)initForImg{
    self = [super init];
    if (self) {
        CGSize infoSizeDemo=[@"测试文字:" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTitleTextFontSize]}];
        _height = kcellHeight;
        _isediting = NO;
        
        // 标识图:
        _nameimgL = [UILabel new];
        _nameimgL.text = @"标识图:";
        _nameimgL.textAlignment = NSTextAlignmentRight;
        _nameimgL.textColor = [UIColor whiteColor];
        _nameimgL.font = [UIFont systemFontOfSize:kTitleTextFontSize];
        _nameimgL.frame = CGRectMake(15, kcellHeight/2 - infoSizeDemo.height/2, infoSizeDemo.width, infoSizeDemo.height);
        [self.contentView addSubview:_nameimgL];
        
        // 标识图、左右按钮
        UIButton *_nameimgLeft = [UIButton new];
        [_nameimgLeft setFrame:CGRectMake(15 + infoSizeDemo.width + 10, 2, kcellHeight-4, kcellHeight-4)];
        [_nameimgLeft setImage:[UIImage imageNamed:@"triangle-left-white-s.png"] forState:UIControlStateNormal];
        [_nameimgLeft addTarget:self action:@selector(nameImgChangeLeft) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_nameimgLeft];
        _nameimg = [UIImageView new];
        _nameimg.frame = CGRectMake(15 + infoSizeDemo.width + 10 + kcellHeight + 15, 2, kcellHeight-4, kcellHeight-4);
        [self.contentView addSubview:_nameimg];
        UIButton *_nameimgRight = [UIButton new];
        [_nameimgRight setFrame:CGRectMake(15 + infoSizeDemo.width + 10 + 2*kcellHeight + 30, 2, kcellHeight-4, kcellHeight-4)];
        [_nameimgRight setImage:[UIImage imageNamed:@"triangle-right-white-s.png"] forState:UIControlStateNormal];
        [_nameimgRight addTarget:self action:@selector(nameImgChangeRight) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_nameimgRight];
        
        /* 170315 不在此处调用初始化方法getIconData了，因为代理还没设置+浪费资源，初始化放在左右按钮里
        NSArray *icons = [_celldelegate getIconData];
        _iconArray = [NSMutableArray new];
        for (Iconimg *ia in icons) {
            [_iconArray addObject:ia.imgname];
        }
         */
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

// 第三行
- (instancetype)initForHomework{
    self = [super init];
    if (self) {
        CGSize infoSizeDemo=[@"测试文字:" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTitleTextFontSize]}];
        _height = kcellHeight;
        _isediting = NO;
        // 作业类型:
        _homeworksL = [UILabel new];
        _homeworksL.text = @"作业类型:";
        _homeworksL.textAlignment = NSTextAlignmentRight;
        _homeworksL.textColor = [UIColor whiteColor];
        _homeworksL.font = [UIFont systemFontOfSize:kTitleTextFontSize];
        _homeworksL.frame = CGRectMake(15, kcellHeight/2 - infoSizeDemo.height/2, infoSizeDemo.width, infoSizeDemo.height);
        [self.contentView addSubview:_homeworksL];
        // 详情输入框
        _homeworktype = [UITextField new];
        _homeworktype.textColor = [UIColor whiteColor];
        _homeworktype.font = [UIFont systemFontOfSize:kTitleTextFontSize];
        _homeworktype.placeholder = @"常见作业类型，以;分割";
        UILabel *label = [_homeworktype valueForKeyPath:@"_placeholderLabel"];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:kTitleTextFontSize-3];
        _homeworktype.clearButtonMode = UITextFieldViewModeWhileEditing;
        _homeworktype.font = [UIFont systemFontOfSize:kTitleTextFontSize];
        _homeworktype.frame = CGRectMake(15 + infoSizeDemo.width + 10, kcellHeight/2 - infoSizeDemo.height/2, viewBounds.size.width - infoSizeDemo.width - krightBtnW - 36, infoSizeDemo.height);
        [_homeworktype addTarget:self action:@selector(homeworktypeChange) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_homeworktype];
        // 详情下划线
        _homeworktypeLine = [UIView new];
        _homeworktypeLine.backgroundColor=[UIColor lightGrayColor];
        _homeworktypeLine.frame = CGRectMake(_homeworktype.frame.origin.x,_homeworktype.frame.origin.y+_homeworktype.frame.size.height + 1, _homeworktype.frame.size.width, 1);
        [self.contentView addSubview:_homeworktypeLine];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

// 加载数据
-(void)loadClass:(ClassName*)classname withInfo:(NSDictionary*)infoDic{
    CGSize infoSize = CGSizeMake(0, 0);
    _theClassname = classname;
    switch ([infoDic[@"type"] intValue]) {
        case 0:
            _name.text = classname.name;
            infoSize=[_name.text sizeWithAttributes:@{NSFontAttributeName:_name.font}];
            _name.frame = CGRectMake(15, kcellHeight/2 - infoSize.height/2, infoSize.width, infoSize.height);
            _nameF.text = classname.name;
            break;
        case 1:
            _homeworkname.text = classname.homeworkname;
            break;
        case 2:
            _nameimg.image = [UIImage imageNamed:classname.img];
            _iconName = classname.img;
            break;
        case 3:{
            NSMutableString *homeworktyStr = [NSMutableString new];
            for (HomeworkType *homeworkty in classname.havehomework) {
                [homeworktyStr appendString:homeworkty.typename];
                [homeworktyStr appendString:@";"];
            }
            if (homeworktyStr.length>0) {
                _homeworktype.text = [homeworktyStr substringToIndex:homeworktyStr.length-1];
                _theClassname.attribute1 = _homeworktype.text;
            }
        }

            break;
        default:
            break;
    }
}   




# pragma mark 自定义方法

// 响应编辑按钮
-(void)editor{
    // 表格不在编辑状态时可以展开
    if (![self.celldelegate getablediting]) {
        if (_isediting) {
            int checksave = [_celldelegate checkcansave:_theClassname];
            if(checksave > 0){
                if (checksave == 1) {
                    _nameFLine.backgroundColor = [UIColor redColor];
                    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        _nameFLine.backgroundColor=[UIColor lightGrayColor];
                    } completion:^(BOOL finished) {
                        ;
                    }];
                }
                return;
            }
            // 结束编辑
            [_interactBtn setImage:[UIImage imageNamed:@"pen-checkbox-white.png"] forState:UIControlStateNormal];
            [self.celldelegate setEditingcells:(int)_indexPath.section forAdd:false];
            [_name setHidden:NO];
            [_nameFL setHidden:YES];
            [_nameF setHidden:YES];
            [_nameFLine setHidden:YES];
            CGSize infoSize=[_nameF.text sizeWithAttributes:@{NSFontAttributeName:_name.font}];
            _name.frame = CGRectMake(15, kcellHeight/2 - infoSize.height/2, infoSize.width, infoSize.height);
            _name.text = _nameF.text;
            // 保存
            [_celldelegate saveClass:_theClassname WithInfo:nil];
        }else{
            // 开启编辑
            [_interactBtn setImage:[UIImage imageNamed:@"Save.png"] forState:UIControlStateNormal];
            [self.celldelegate setEditingcells:(int)_indexPath.section forAdd:true];
            [_name setHidden:YES];
            [_nameFL setHidden:NO];
            [_nameF setHidden:NO];
            [_nameFLine setHidden:NO];
        }
        
        //[_celldelegate reloadcells];
        _isediting = !_isediting;
    }

}

// 不保存结束编辑，用于完全收起
-(void)stopEditForName{
    [self.celldelegate setEditingcells:(int)_indexPath.section forAdd:false];
    [_name setHidden:NO];
    [_nameFL setHidden:YES];
    [_nameF setHidden:YES];
    [_nameFLine setHidden:YES];
    _isediting = false;
}

// 按钮隐藏显示
-(void)hideBtn:(bool)hide{
    if(hide){
        [_interactBtn setHidden:YES];
    }else{
        [_interactBtn setHidden:NO];
    }
}

-(void)nameFChange{
    _theClassname.name = _nameF.text;
}

-(void)homeworknameChange{
    _theClassname.homeworkname = _homeworkname.text;
}

-(void)homeworktypeChange{
    _theClassname.attribute1 = _homeworktype.text;
}


// 标识图转换-上一个
-(void)nameImgChangeLeft{
    if (!_iconArray) {
        NSArray *icons = [_celldelegate getIconData];
        _iconArray = [NSMutableArray new];
        for (Iconimg *ia in icons) {
            [_iconArray addObject:ia.imgname];
        }
        _iconCheck = (int)[_iconArray indexOfObject:_iconName];
    }
    if(_iconCheck == 0){
        _iconCheck = (int)_iconArray.count - 1;
    }else{
        --_iconCheck;
    }
    [_nameimg setImage:[UIImage imageNamed:_iconArray[_iconCheck]]];
    _theClassname.img = _iconArray[_iconCheck];
}

// 标识图转换-下一个
-(void)nameImgChangeRight{
    if (!_iconArray) {
        NSArray *icons = [_celldelegate getIconData];
        _iconArray = [NSMutableArray new];
        for (Iconimg *ia in icons) {
            [_iconArray addObject:ia.imgname];
        }
        _iconCheck = (int)[_iconArray indexOfObject:_iconName];
    }
    if(_iconCheck == (int)_iconArray.count - 1){
        _iconCheck = 0;
    }else{
        ++_iconCheck;
    }
    [_nameimg setImage:[UIImage imageNamed:_iconArray[_iconCheck]]];
    _theClassname.img = _iconArray[_iconCheck];
}



@end
