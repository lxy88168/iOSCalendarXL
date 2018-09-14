//
//  rqhsTableViewController.m
//  SKCalendarView
//
//  Created by tangming on 2018/8/2.
//  Copyright © 2018年 武汉思古科技有限公司. All rights reserved.
//

#import "rqhsTableViewController.h"

#import "SolarDatePickerView.h"
#import "LunarDatePickerView.h"
#import "CalendarHeader.h"
#import "TXSakuraKit.h"

@interface rqhsTableViewController () <SolarDatePickerViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *YangLiView;
@property (weak, nonatomic) IBOutlet UIView *YingLiView;
@property (weak, nonatomic) IBOutlet UIView *firstDateView;
@property (weak, nonatomic) IBOutlet UIView *secondDateView;
@property (weak, nonatomic) IBOutlet UIButton *solarResultBtn;
@property (weak, nonatomic) IBOutlet UIButton *lunarResultBtn;
@property (weak, nonatomic) IBOutlet UILabel *HeLabel;
@property (weak, nonatomic) SolarDatePickerView *solarDateView;
@property (weak, nonatomic) LunarDatePickerView *lunarDateView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (strong, nonatomic) UIButton *btn;
@property (weak, nonatomic) IBOutlet UIView *rqhzView;
@property (weak, nonatomic) IBOutlet UIView *rqjgView;
@property (weak, nonatomic) IBOutlet UIView *rqtsView;
@property (weak, nonatomic) IBOutlet UIButton *firstDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondDateBtn;
@property (weak, nonatomic) IBOutlet UILabel *YangLiLabel;
@property (weak, nonatomic) IBOutlet UILabel *YingLiLabel;
@property (weak, nonatomic) IBOutlet UILabel *JianGeLabel;
@property (weak, nonatomic) IBOutlet UIView *xuanzheriqiView;
@property (weak, nonatomic) IBOutlet UIView *jiangetianshuView;
@property (weak, nonatomic) IBOutlet UIButton *selectDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *qianBtn;
@property (weak, nonatomic) IBOutlet UIButton *houBtn;
@property (weak, nonatomic) IBOutlet UITextField *JianGeTextField;
@property (weak, nonatomic) IBOutlet UILabel *TSJianGeLabel;
@property (weak, nonatomic) IBOutlet UILabel *TSYangLiLabel;
@property (weak, nonatomic) IBOutlet UILabel *TSYingLiLabel;
@property (weak, nonatomic) IBOutlet UILabel *TSYangLi;
@property (weak, nonatomic) IBOutlet UILabel *TSYingLi;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnQueryTS;
@property (weak, nonatomic) IBOutlet UIButton *btnQueryJG;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCalendar;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCalendarHZ1;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCalendarHZ2;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCalendarTS1;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCalendarTS2;

@end

static NSString *solarDate = NULL;
static NSString *lunarDate = NULL;
static int qianBtnSelected = 0;
static int houBtnSelected = 0;

@implementation rqhsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.sakura.titleTextAttributes(@"navBarTitleColor");
    self.navigationController.navigationBar.sakura.tintColor(@"accentColor");
    self.segControl.sakura.tintColor(@"accentColor");
    self.TSJianGeLabel.sakura.textColor(@"accentColor");
    self.TSYangLiLabel.sakura.textColor(@"accentColor");
    self.TSYingLiLabel.sakura.textColor(@"accentColor");
    self.btnQueryJG.sakura.backgroundColor(@"accentColor");
    self.btnQueryTS.sakura.backgroundColor(@"accentColor");
    self.YangLiLabel.sakura.backgroundColor(@"accentColor");
    self.YingLiLabel.sakura.backgroundColor(@"accentColor");
    self.JianGeLabel.sakura.textColor(@"accentColor");
    self.qianBtn.sakura.titleColor(@"accentColor", UIControlStateSelected);
    self.qianBtn.selected = true;
    self.houBtn.sakura.titleColor(@"accentColor", UIControlStateSelected);
    self.imageViewCalendar.sakura.image(@"calendarImage");
    self.imageViewCalendarHZ1.sakura.image(@"calendarImage");
    self.imageViewCalendarHZ2.sakura.image(@"calendarImage");
    self.imageViewCalendarTS1.sakura.image(@"calendarImage");
    self.imageViewCalendarTS2.sakura.image(@"calendarImage");
    
    //View设置
    self.firstDateView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.firstDateView.layer.borderWidth =0.3;
    self.firstDateView.layer.cornerRadius=5.0;
    self.secondDateView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.secondDateView.layer.borderWidth =0.3;
    self.secondDateView.layer.cornerRadius=5.0;
    self.YangLiView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.YangLiView.layer.borderWidth =0.3;
    self.YangLiView.layer.cornerRadius=5.0;
    self.YingLiView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.YingLiView.layer.borderWidth =0.3;
    self.YingLiView.layer.cornerRadius=5.0;
    self.xuanzheriqiView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.xuanzheriqiView.layer.borderWidth =0.3;
    self.xuanzheriqiView.layer.cornerRadius=5.0;
    self.jiangetianshuView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.jiangetianshuView.layer.borderWidth =0.3;
    self.jiangetianshuView.layer.cornerRadius=5.0;
    
    self.btnQueryJG.layer.cornerRadius = 5;
    self.btnQueryTS.layer.cornerRadius = 5;
    
    [self SwitchViews:NULL];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到view上
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    //Button设置
    self.solarResultBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.lunarResultBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.firstDateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.secondDateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    //其他设置
    [self.JianGeTextField addTarget:self action:@selector(textFieldDidchange:) forControlEvents:UIControlEventEditingChanged];
    self.JianGeTextField.delegate = self;
//    [self.qianBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [self.houBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //自定义button
    self.btn = [[UIButton alloc] initWithFrame:self.view.bounds];
    self.btn.backgroundColor = [UIColor blackColor];
    self.btn.hidden = YES;
    self.btn.alpha = 0.3;
    [self.view addSubview:self.btn];
    
    //button隐藏
    self.HeLabel.alpha = 0;
    self.YangLiLabel.alpha = 0;
    self.YingLiLabel.alpha = 0;
    self.JianGeLabel.alpha = 0;
    self.TSJianGeLabel.alpha = 0;
    self.TSYangLiLabel.alpha = 0;
    self.TSYingLiLabel.alpha = 0;
    self.TSYangLi.alpha = 0;
    self.TSYingLi.alpha = 0;
    
    [self qianBtnClick:NULL];
    
    SolarDatePickerView *solarDateView = [[SolarDatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300)];
    solarDateView.delegate = self;
    solarDateView.hidden = YES;
    
    LunarDatePickerView *lunarDateView = [[LunarDatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300)];
    lunarDateView.delegate = self;
    lunarDateView.hidden = YES;
    
    //Button初始化显示
    NSDate *date=[NSDate date];
    NSDateFormatter *formatCurrentTime=[[NSDateFormatter alloc] init];
    [formatCurrentTime setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr;
    dateStr=[formatCurrentTime stringFromDate:date];
    
    [self.solarResultBtn setTitle: dateStr forState: UIControlStateNormal];
    [self.firstDateBtn setTitle: dateStr forState: UIControlStateNormal];
    [self.selectDateBtn setTitle: dateStr forState: UIControlStateNormal];
    solarDate = dateStr;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    
    int solarYear =(int) [dateComponent year];
    int solarMonth = (int) [dateComponent month];
    int solarDay = (int) [dateComponent day];
    
    lunarDate = [NSString stringWithFormat:@"%d-%d-%d",solarYear,solarMonth,solarDay];
    
    Solar *s = [[Solar alloc]initWithYear:solarYear
                                 andMonth:solarMonth
                                   andDay:solarDay];
    Lunar *l = [CalendarDisplyManager obtainLunarFromSolar:s];
    
    [CalendarDisplyManager resultWithLunar:l resultFormat:^(NSString *year,
                                                            NSString *month,
                                                            NSString *day) {
        [self.lunarResultBtn setTitle: [NSString stringWithFormat:@"%@年 %@ %@",year,month,day] forState: UIControlStateNormal];
        [self.secondDateBtn setTitle: [NSString stringWithFormat:@"%@年 %@ %@",year,month,day] forState: UIControlStateNormal];
    }];
    
    //加载dataView
    solarDateView.title = @"请选择时间";
    [self.view addSubview:solarDateView];
    self.solarDateView = solarDateView;
    
    lunarDateView.title = @"请选择时间";
    [self.view addSubview:lunarDateView];
    self.lunarDateView = lunarDateView;
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_JianGeTextField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //返回一个BOOL值，指明是否允许在按下回车键时结束编辑
    //如果允许要调用resignFirstResponder 方法，这回导致结束编辑，而键盘会被收起
    [self.JianGeTextField resignFirstResponder];//查一下resign这个单词的意思就明白这个方法了
    return YES;
}

- (void)textFieldDidchange:(UITextField *)textField {
    NSString *textString = textField.text;
    if (![self inputShouldNumber:textString] && textString.length > 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请输入数字!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *centain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:centain];
        [self presentViewController:alert animated:YES completion:nil];
        
        //textField.text = self.JianGeTextField.text;
        [self.JianGeTextField setText:@""];
        return;
    }
    self.JianGeTextField.text = textString;
}

- (BOOL)inputShouldNumber:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex =@"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}


// 显示
- (IBAction)solarResultBtnClick:(id)sender {
    self.btn.hidden = NO;
    self.solarDateView.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.solarDateView.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
        [self.solarDateView show];
    }];
}

- (IBAction)lunarResultBtnClick:(id)sender {
    self.btn.hidden = NO;
    self.lunarDateView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.lunarDateView.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
        [self.lunarDateView show];
    }];
}

- (IBAction)firstDateBtnClick:(id)sender {
    self.btn.hidden = NO;
    self.solarDateView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.solarDateView.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
        [self.solarDateView show];
    }];
}

- (IBAction)secondDateBtnClick:(id)sender {
    self.btn.hidden = NO;
    self.lunarDateView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.lunarDateView.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
        [self.lunarDateView show];
    }];
}

- (IBAction)selectDateBtnClick:(id)sender {
    self.btn.hidden = NO;
    self.solarDateView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.solarDateView.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
        [self.solarDateView show];
    }];
}


//Segment视图切换
- (IBAction)SwitchViews:(id)sender {
    switch (self.segControl.selectedSegmentIndex) {
        case 0:
            self.rqhzView.alpha = 1;
            self.rqjgView.alpha = 0;
            self.rqtsView.alpha = 0;
            break;
        case 1:
            self.rqhzView.alpha = 0;
            self.rqjgView.alpha = 1;
            self.rqtsView.alpha = 0;
            break;
        case 2:
            self.rqhzView.alpha = 0;
            self.rqjgView.alpha = 0;
            self.rqtsView.alpha = 1;
            break;
        default:
            break;
    }
    
}

- (IBAction)firstSecondBtnSearch:(id)sender {
    self.HeLabel.alpha = 1;
    self.YangLiLabel.alpha = 1;
    self.YingLiLabel.alpha = 1;
    self.JianGeLabel.alpha = 1;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *firstDate = [dateFormatter dateFromString:solarDate];
    NSString *tempSecondDate = lunarDate;
    
    NSArray *array = [tempSecondDate componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
    NSString *lunarYear, *lunarMonth, *lunarDay;
    if([array count] >= 3){
        lunarYear = array[0];
        lunarMonth = array[1];
        lunarDay = array[2];
    }
    
    Lunar *l = [[Lunar alloc]initWithYear:[lunarYear intValue]
                                 andMonth:[lunarMonth intValue]
                                   andDay:[lunarDay intValue]];
    //得出阳历
    Solar *s = [CalendarDisplyManager obtainSolarFromLunar:l];
    
    NSDate *secondDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%i-%i-%i",s.solarYear,s.solarMonth,s.solarDay]];
    
    //secondDate = [NSString stringWithFormat:@"%i-%i-%i",s.solarYear,s.solarMonth,s.solarDay];
    
    NSTimeInterval time = [secondDate timeIntervalSinceDate:firstDate];
    
    int days = ((int)time)/(3600*24);
    
    
    //Label的日期显示
    [self.YangLiLabel setText:[NSString stringWithFormat:@"阳历%@",solarDate]];
    self.YangLiLabel.textAlignment = NSTextAlignmentLeft;
    self.YangLiLabel.numberOfLines = 0;
    
    [CalendarDisplyManager resultWithLunar:l resultFormat:^(NSString *year,
                                                            NSString *month,
                                                            NSString *day) {
        [self.YingLiLabel setText:[NSString stringWithFormat:@"阴历%@年 %@ %@",year,month,day]];
    }];
    self.YingLiLabel.textAlignment = NSTextAlignmentLeft;
    self.YingLiLabel.numberOfLines = 0;
    
    [self.JianGeLabel setText:[NSString stringWithFormat:@"相差%i天",days]];
    self.JianGeLabel.textAlignment = NSTextAlignmentLeft;
    self.JianGeLabel.numberOfLines = 0;
}

#pragma mark - SolarDatePickerViewDelegate
/**
 保存按钮代理方法
 @param timer 选择的数据
 */
- (void)SolarDatePickerViewSaveBtnClickDelegate:(NSString *)timer {
    NSLog(@"保存点击");
    solarDate = timer;
    //初始化solarResultBtn显示日期
    [self.solarResultBtn setTitle: timer forState: UIControlStateNormal];
    [self.firstDateBtn setTitle: timer forState: UIControlStateNormal];
    [self.selectDateBtn setTitle: timer forState: UIControlStateNormal];
    
    self.btn.hidden = YES;
    self.solarDateView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.solarDateView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
    }];
    
    //阳历转阴历
    NSString *string =timer;
    NSString *solarYear, *solarMonth, *solarDay;
    
    NSArray *array = [string componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
    if([array count] >= 3){
        solarYear = array[0];
        solarMonth = array[1];
        solarDay = array[2];
    }
    
    Solar *s = [[Solar alloc]initWithYear:[solarYear intValue]
                                 andMonth:[solarMonth intValue]
                                   andDay:[solarDay intValue]];
    //得出阴历
    Lunar *l = [CalendarDisplyManager obtainLunarFromSolar:s];
    [CalendarDisplyManager resultWithLunar:l resultFormat:^(NSString *year,
                                                            NSString *month,
                                                            NSString *day) {
        [self.lunarResultBtn setTitle: [NSString stringWithFormat:@"%@年 %@ %@",year,month,day] forState: UIControlStateNormal];
    }];
}

- (void)LunarDatePickerViewSaveBtnClickDelegate:(NSString *)timer {
    NSLog(@"保存点击");
    lunarDate = timer;
    //阴历转阳历
    NSString *string =timer;
    NSString *lunarYear, *lunarMonth, *lunarDay;
    
    NSArray *array = [string componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
    if([array count] >= 3){
        lunarYear = array[0];
        lunarMonth = array[1];
        lunarDay = array[2];
    }
    
    Lunar *l = [[Lunar alloc]initWithYear:[lunarYear intValue]
                                 andMonth:[lunarMonth intValue]
                                   andDay:[lunarDay intValue]];
    //得出阳历
    Solar *s = [CalendarDisplyManager obtainSolarFromLunar:l];
    //    [CalendarDisplyManager resultWithLunar:l resultFormat:^(NSString *year,
    //                                                            NSString *month,
    //                                                            NSString *day) {
    //        [self.lunarResultBtn setTitle: [NSString stringWithFormat:@"%@年 %@ %@",year,month,day] forState: UIControlStateNormal];
    //    }];
    [self.solarResultBtn setTitle: [NSString stringWithFormat:@"%i-%i-%i",s.solarYear,s.solarMonth,s.solarDay] forState: UIControlStateNormal];
    
    //初始化lunarResultBtn上面显示阴历日期并转换
    Solar *ss = [[Solar alloc]initWithYear:s.solarYear
                                  andMonth:s.solarMonth
                                    andDay:s.solarDay];
    //得出阴历
    Lunar *ll = [CalendarDisplyManager obtainLunarFromSolar:ss];
    [CalendarDisplyManager resultWithLunar:ll resultFormat:^(NSString *year,
                                                             NSString *month,
                                                             NSString *day) {
        [self.lunarResultBtn setTitle: [NSString stringWithFormat:@"%@年 %@ %@",year,month,day] forState: UIControlStateNormal];
        [self.secondDateBtn setTitle: [NSString stringWithFormat:@"%@年 %@ %@",year,month,day] forState: UIControlStateNormal];
    }];
    
    //    [self.lunarResultBtn setTitle: timer forState: UIControlStateNormal];
    self.btn.hidden = YES;
    self.lunarDateView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.lunarDateView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
    }];
}
- (IBAction)qianBtnClick:(id)sender {
//    [self.qianBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:103/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];
    self.qianBtn.selected = true;
    qianBtnSelected = 1;
    houBtnSelected = 0;
//    [self.houBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.houBtn.selected = false;
}

- (IBAction)houBtnClick:(id)sender {
//    [self.houBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:103/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];
    self.houBtn.selected = true;
    qianBtnSelected = 0;
    houBtnSelected = 1;
//    [self.qianBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.qianBtn.selected = false;
}

- (IBAction)JianGeTextFieldClick:(id)sender {
//    [self.JianGeTextField setText:@""];
    [self.JianGeTextField resignFirstResponder];
}

- (IBAction)JianGeSearchBtnClick:(id)sender {
    self.TSJianGeLabel.alpha = 1;
    self.TSYangLiLabel.alpha = 1;
    self.TSYingLiLabel.alpha = 1;
    self.TSYangLi.alpha = 1;
    self.TSYingLi.alpha = 1;
    
    if([self.JianGeTextField.text isEqual:@"请输入间隔天数"] || [self.JianGeTextField.text isEqual:@""])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请输入间隔天数" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *centain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:centain];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        if(houBtnSelected == 0 && qianBtnSelected == 0){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择前或后按钮" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *centain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:centain];
            [self presentViewController:alert animated:YES completion:nil];
        }else if(houBtnSelected == 1){
            //后多少天
            NSInteger dis = [self.JianGeTextField.text intValue];
            //提取solarDate的日期
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *nowDate = [dateFormatter dateFromString:solarDate];
            NSDate *theDateSolar;
            if(dis!=0){
                NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
                theDateSolar = [nowDate initWithTimeIntervalSinceNow: +oneDay*dis ];
                //or
                //theDate = [nowDate initWithTimeIntervalSinceNow: -oneDay*dis ];
            }else{
                theDateSolar = nowDate;
            }
            
            //阳历转阴历
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            
            [formatter setDateFormat:@"yyyy"];
            NSInteger solarYear=[[formatter stringFromDate:theDateSolar] integerValue];
            [formatter setDateFormat:@"MM"];
            NSInteger solarMonth=[[formatter stringFromDate:theDateSolar]integerValue];
            [formatter setDateFormat:@"dd"];
            NSInteger solarDay=[[formatter stringFromDate:theDateSolar] integerValue];
            
            
            Solar *s = [[Solar alloc]initWithYear:(int)solarYear
                                         andMonth:(int)solarMonth
                                           andDay:(int)solarDay];
            //得出阴历
            Lunar *l = [CalendarDisplyManager obtainLunarFromSolar:s];
            [CalendarDisplyManager resultWithLunar:l resultFormat:^(NSString *year,
                                                                    NSString *month,
                                                                    NSString *day) {
                [self.TSYingLiLabel setText:[NSString stringWithFormat:@"%@年 %@ %@",year,month,day]];
            }];
            
            [self.TSJianGeLabel setText:[NSString stringWithFormat:@"%li天后是",dis]];
            [self.TSYangLiLabel setText:[NSString stringWithFormat:@"%i-%i-%i",s.solarYear,s.solarMonth,s.solarDay]];
            
        }else if (qianBtnSelected == 1){
            //前多少天
            NSInteger dis = [self.JianGeTextField.text intValue];
            //提取solarDate的日期
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *nowDate = [dateFormatter dateFromString:solarDate];
            NSDate *theDateSolar;
            if(dis!=0){
                NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
                //                theDateSolar = [nowDate initWithTimeIntervalSinceNow: +oneDay*dis ];
                //or
                theDateSolar = [nowDate initWithTimeIntervalSinceNow: -oneDay*dis ];
            }else{
                theDateSolar = nowDate;
            }
            
            //阳历转阴历
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            
            [formatter setDateFormat:@"yyyy"];
            NSInteger solarYear=[[formatter stringFromDate:theDateSolar] integerValue];
            [formatter setDateFormat:@"MM"];
            NSInteger solarMonth=[[formatter stringFromDate:theDateSolar]integerValue];
            [formatter setDateFormat:@"dd"];
            NSInteger solarDay=[[formatter stringFromDate:theDateSolar] integerValue];
            
            
            Solar *s = [[Solar alloc]initWithYear:(int)solarYear
                                         andMonth:(int)solarMonth
                                           andDay:(int)solarDay];
            //得出阴历
            Lunar *l = [CalendarDisplyManager obtainLunarFromSolar:s];
            [CalendarDisplyManager resultWithLunar:l resultFormat:^(NSString *year,
                                                                    NSString *month,
                                                                    NSString *day) {
                [self.TSYingLiLabel setText:[NSString stringWithFormat:@"%@年 %@ %@",year,month,day]];
            }];
            
            [self.TSJianGeLabel setText:[NSString stringWithFormat:@"%li天前是",dis]];
            [self.TSYangLiLabel setText:[NSString stringWithFormat:@"%i-%i-%i",s.solarYear,s.solarMonth,s.solarDay]];
        }
    }
}

/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate {
    NSLog(@"取消点击");
    self.btn.hidden = YES;
    self.solarDateView.hidden = YES;
    self.lunarDateView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.solarDateView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
        self.lunarDateView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

