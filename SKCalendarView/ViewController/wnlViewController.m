//
//  wnlViewController.m
//  SKCalendarView
//
//  Created by tangming on 2018/8/2.
//  Copyright © 2018年 武汉思古科技有限公司. All rights reserved.
//

#import "wnlViewController.h"
#import "SKConstant.h"

@interface wnlViewController () <SKCalendarViewDelegate>
@property (nonatomic, strong) SKCalendarView * calendarView;
@property (nonatomic, strong) UIView * lunarView;
@property (nonatomic, strong) UIButton * nextButton;
@property (nonatomic, strong) UIButton * lastButton;
@property (nonatomic, strong) UILabel * chineseYearLabel;// 农历年
@property (nonatomic, strong) UILabel * chineseMonthAndDayLabel;
@property (nonatomic, strong) UILabel * yearLabel;// 公历年
@property (nonatomic, strong) UILabel * dayLabel;// 公历年
@property (nonatomic, strong) UILabel * holidayLabel;//节日&节气
@property (nonatomic, strong) UIButton * backToday;// 返回今天

@property (nonatomic, assign) NSUInteger lastMonth;
@property (nonatomic, assign) NSUInteger nextMonth;

@end

@implementation wnlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.calendarView];
    [self.view addSubview:self.lunarView];
    
    
    // 查看下个月
    self.nextButton = [UIButton new];
    [self.view addSubview:self.nextButton];
    [self.nextButton setTitle:[NSString stringWithFormat:@"%@月", @(self.nextMonth)] forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.calendarView.mas_top).with.offset(-30);
        make.right.equalTo(self.calendarView.mas_right).with.offset(-10);
    }];
    [self.nextButton addTarget:self action:@selector(checkNextMonthCalendar) forControlEvents:UIControlEventTouchUpInside];
    
    // 查看上个月
    self.lastButton = [UIButton new];
    [self.view addSubview:self.lastButton];
    [self.lastButton setTitle:[NSString stringWithFormat:@"%@月", @(self.lastMonth)] forState:UIControlStateNormal];
    [self.lastButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.calendarView.mas_top).with.offset(-30);
        make.left.equalTo(self.calendarView.mas_left).with.offset(10);
    }];
    [self.lastButton addTarget:self action:@selector(checkLastMonthCalendar) forControlEvents:UIControlEventTouchUpInside];
    
    // 公历年
    self.yearLabel = [UILabel new];
    [self.view addSubview:self.yearLabel];
    self.yearLabel.font = [UIFont systemFontOfSize:18];
    self.yearLabel.text = [NSString stringWithFormat:@"%@年%@月", @(self.calendarView.year), @(self.calendarView.month)];
    [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.calendarView.mas_top).with.offset(-25);
        make.centerX.equalTo(self.calendarView);
    }];
    
    // 公历日
    self.dayLabel = [UILabel new];
    [self.lunarView addSubview:self.dayLabel];
    self.dayLabel.font = [UIFont systemFontOfSize:18];
    self.dayLabel.text = [NSString stringWithFormat:@"%@", self.calendarView.gongcalendarDate[self.calendarView.todayInMonth]];
    self.dayLabel.textAlignment = NSTextAlignmentCenter;
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.calendarView.mas_bottom).with.offset(50);
        make.centerX.equalTo(self.calendarView.mas_left).with.offset(20);
    }];
    
    // 农历年
    self.chineseYearLabel = [UILabel new];
    [self.lunarView addSubview:self.chineseYearLabel];
    self.chineseYearLabel.font = [UIFont systemFontOfSize:18];
    self.chineseYearLabel.text = [NSString stringWithFormat:@"%@年", self.calendarView.chineseYear];
    self.chineseYearLabel.textAlignment = NSTextAlignmentCenter;
    [self.chineseYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.calendarView.mas_bottom).with.offset(50);
        make.centerX.equalTo(self.calendarView.mas_left).with.offset(100);
    }];
    
    // 农历月日
    self.chineseMonthAndDayLabel = [UILabel new];
    [self.lunarView addSubview:self.chineseMonthAndDayLabel];
    self.chineseMonthAndDayLabel.font = [UIFont systemFontOfSize:15];
    self.chineseMonthAndDayLabel.textColor = [UIColor redColor];
    // 默认农历日期 今天
    self.chineseMonthAndDayLabel.text = [NSString stringWithFormat:@"%@%@", self.calendarView.chineseCalendarMonth[self.calendarView.todayInMonth - 1], getNoneNil(self.calendarView.chineseCalendarDay[self.calendarView.todayInMonth])];
    self.chineseMonthAndDayLabel.textAlignment = NSTextAlignmentCenter;
    [self.chineseMonthAndDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chineseYearLabel.mas_bottom).with.offset(5);
        make.centerX.equalTo(self.chineseYearLabel);
    }];
    
    // 节日&节气
    self.holidayLabel = [UILabel new];
    [self.lunarView addSubview:self.holidayLabel];
    self.holidayLabel.font = [UIFont systemFontOfSize:15];
    self.holidayLabel.textColor = [UIColor purpleColor];
    self.holidayLabel.textAlignment = NSTextAlignmentCenter;
    // 获取节日，注意：此处传入的参数为chineseCalendarDay(包含不节日等信息)
    self.holidayLabel.text = [self.calendarView getHolidayAndSolarTermsWithChineseDay:getNoneNil(self.calendarView.chineseCalendarDay[self.calendarView.todayInMonth])];
    [self.holidayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chineseMonthAndDayLabel.mas_bottom).with.offset(5);
        make.centerX.equalTo(self.chineseMonthAndDayLabel);
    }];
    
    // 返回今天
    self.backToday = [UIButton new];
    [self.view addSubview:self.backToday];
    [self.backToday setTitle:@"返回今天" forState:UIControlStateNormal];
    [self.backToday setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.backToday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.calendarView.mas_bottom).with.offset(30);
        make.centerX.equalTo(self.calendarView);
    }];
    [self.backToday addTarget:self action:@selector(clickBackToday) forControlEvents:UIControlEventTouchUpInside];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 添加显示农历的view
- (UIView *)lunarView
{
    if (!_lunarView) {
        _lunarView = [[UIView alloc] initWithFrame:CGRectMake(0, 400, [UIScreen mainScreen].bounds.size.width, 70)];
        _lunarView.layer.borderColor = [UIColor blackColor].CGColor;
        _lunarView.layer.borderWidth =0.3;
        //view添加阴影
        _lunarView.layer.masksToBounds = NO;
        _lunarView.layer.shadowColor = [UIColor blackColor].CGColor;
        _lunarView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
        _lunarView.layer.shadowOpacity = 0.2f;

    }
    
    return _lunarView;
}

#pragma mark - 日历设置
- (SKCalendarView *)calendarView
{
    if (!_calendarView) {
        _calendarView = [[SKCalendarView alloc] initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 300)];
        //_calendarView.layer.cornerRadius = 0;
        _calendarView.layer.borderColor = [UIColor blackColor].CGColor;
        _calendarView.layer.borderWidth = 0.1;
        //view添加阴影
        _calendarView.layer.masksToBounds = NO;
        _calendarView.layer.shadowColor = [UIColor blackColor].CGColor;
        _calendarView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
        _calendarView.layer.shadowOpacity = 0.1f;
        
        _calendarView.delegate = self;// 获取点击日期的方法，一定要遵循协议
        _calendarView.calendarTodayTitleColor = [UIColor redColor];// 今天标题字体颜色
        _calendarView.calendarTodayTitle = @"今日";// 今天下标题
        _calendarView.dateColor = [UIColor orangeColor];// 今天日期数字背景颜色
        _calendarView.calendarTodayColor = [UIColor whiteColor];// 今天日期字体颜色
        _calendarView.dayoffInWeekColor = [UIColor redColor];
        _calendarView.springColor = [UIColor colorWithRed:48 / 255.0 green:200 / 255.0 blue:104 / 255.0 alpha:1];// 春季节气颜色
        _calendarView.summerColor = [UIColor colorWithRed:18 / 255.0 green:96 / 255.0 blue:0 alpha:8];// 夏季节气颜色
        _calendarView.autumnColor = [UIColor colorWithRed:232 / 255.0 green:195 / 255.0 blue:0 / 255.0 alpha:1];// 秋季节气颜色
        _calendarView.winterColor = [UIColor colorWithRed:77 / 255.0 green:161 / 255.0 blue:255 / 255.0 alpha:1];// 冬季节气颜色
        _calendarView.holidayColor = [UIColor redColor];//节日字体颜色
        self.lastMonth = _calendarView.lastMonth;// 获取上个月的月份
        self.nextMonth = _calendarView.nextMonth;// 获取下个月的月份
    }
    
    return _calendarView;
}

#pragma mark - 查看上/下一月份日历
- (void)checkNextMonthCalendar
{
    self.calendarView.checkNextMonth = YES;// 查看下月
    [self changeButton:self.nextButton isNext:YES];
    [SKCalendarAnimationManage animationWithView:self.calendarView andEffect:SK_ANIMATION_REVEAL isNext:YES];
    self.chineseYearLabel.text = [NSString stringWithFormat:@"%@年", self.calendarView.chineseYear];// 农历年
    self.yearLabel.text = [NSString stringWithFormat:@"%@年%@月", @(self.calendarView.year), @(self.calendarView.month)];// 公历年
}

- (void)checkLastMonthCalendar
{
    self.calendarView.checkLastMonth = YES;// 查看上月
    [self changeButton:self.lastButton isNext:NO];
    [SKCalendarAnimationManage animationWithView:self.calendarView andEffect:SK_ANIMATION_REVEAL isNext:NO];
    self.chineseYearLabel.text = [NSString stringWithFormat:@"%@年", self.calendarView.chineseYear];// 农历年
    self.yearLabel.text = [NSString stringWithFormat:@"%@年%@月", @(self.calendarView.year), @(self.calendarView.month)];// 公历年
}

// 改变上/下月按钮的月份
- (void)changeButton:(UIButton *)button isNext:(BOOL)next
{
    if (next == YES) {
        self.lastMonth = self.lastMonth + 1;
        self.nextMonth = self.nextMonth + 1;
        if (self.lastMonth > 12) {
            self.lastMonth = 1;
        }
        if (self.nextMonth > 12) {
            self.nextMonth = 1;
        }
    } else {
        self.lastMonth = self.lastMonth - 1;
        self.nextMonth = self.nextMonth - 1;
        if (self.lastMonth < 1) {
            self.lastMonth = 12;
        }
        if (self.nextMonth < 1) {
            self.nextMonth = 12;
        }
    }
    [self.lastButton setTitle:[NSString stringWithFormat:@"%@月", @(self.lastMonth)] forState:UIControlStateNormal];
    [self.nextButton setTitle:[NSString stringWithFormat:@"%@月", @(self.nextMonth)] forState:UIControlStateNormal];
}

#pragma mark - 点击日期
- (void)selectDateWithRow:(NSUInteger)row
{
    self.dayLabel.text = [NSString stringWithFormat:@"%@", self.calendarView.gongcalendarDate[row]];
    self.chineseMonthAndDayLabel.text = [NSString stringWithFormat:@"%@%@", self.calendarView.chineseCalendarMonth[row], getNoneNil(self.calendarView.chineseCalendarDay[row])];
    // 获取节日，注意：此处传入的参数为chineseCalendarDay(不包含节日等信息)
    self.holidayLabel.text = [self.calendarView getHolidayAndSolarTermsWithChineseDay:getNoneNil(self.calendarView.chineseCalendarDay[row])];
}

#pragma mark - 返回今日
- (void)clickBackToday
{
    [self.calendarView checkCalendarWithAppointDate:[NSDate date]];
    self.lastMonth = _calendarView.lastMonth;// 获取上个月的月份
    self.nextMonth = _calendarView.nextMonth;// 获取下个月的月份
    [self.lastButton setTitle:[NSString stringWithFormat:@"%@月", @(self.lastMonth)] forState:UIControlStateNormal];
    [self.nextButton setTitle:[NSString stringWithFormat:@"%@月", @(self.nextMonth)] forState:UIControlStateNormal];
}

@end
