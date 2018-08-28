//
//  rqhsViewController.m
//  SKCalendarView
//
//  Created by tangming on 2018/8/2.
//  Copyright © 2018年 武汉思古科技有限公司. All rights reserved.
//

#import "rqhsViewController.h"

#import "SolarDatePickerView.h"
#import "LunarDatePickerView.h"
#import "CalendarHeader.h"

@interface rqhsViewController () <SolarDatePickerViewDelegate>
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


@end

static NSString *solarDate = NULL;
static NSString *lunarDate = NULL;
static int qianBtnSelected = 0;
static int houBtnSelected = 0;

@implementation rqhsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //View设置
    self.firstDateView.layer.borderColor = [UIColor grayColor].CGColor;
    self.firstDateView.layer.borderWidth =0.3;
    self.firstDateView.layer.cornerRadius=5.0;
    self.secondDateView.layer.borderColor = [UIColor grayColor].CGColor;
    self.secondDateView.layer.borderWidth =0.3;
    self.secondDateView.layer.cornerRadius=5.0;
    self.YangLiView.layer.borderColor = [UIColor grayColor].CGColor;
    self.YangLiView.layer.borderWidth =0.3;
    self.YangLiView.layer.cornerRadius=5.0;
    self.YingLiView.layer.borderColor = [UIColor grayColor].CGColor;
    self.YingLiView.layer.borderWidth =0.3;
    self.YingLiView.layer.cornerRadius=5.0;
    self.xuanzheriqiView.layer.borderColor = [UIColor grayColor].CGColor;
    self.xuanzheriqiView.layer.borderWidth =0.3;
    self.xuanzheriqiView.layer.cornerRadius=5.0;
    self.jiangetianshuView.layer.borderColor = [UIColor grayColor].CGColor;
    self.jiangetianshuView.layer.borderWidth =0.3;
    self.jiangetianshuView.layer.cornerRadius=5.0;
    
    //Button设置
    self.solarResultBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.lunarResultBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.firstDateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.secondDateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    //其他设置
    [self.JianGeTextField addTarget:self action:@selector(textFieldDidchange:) forControlEvents:UIControlEventEditingChanged];
    [self.qianBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.houBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //自定义button
    self.btn = [[UIButton alloc] initWithFrame:self.view.bounds];
    self.btn.backgroundColor = [UIColor blackColor];
    self.btn.hidden = YES;
    self.btn.alpha = 0.3;
    [self.view addSubview:self.btn];
    
    self.HeLabel.alpha = 0;
    
    
    SolarDatePickerView *solarDateView = [[SolarDatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300)];
    solarDateView.delegate = self;
    
    LunarDatePickerView *lunarDateView = [[LunarDatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300)];
    lunarDateView.delegate = self;
    
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
    
    [UIView animateWithDuration:0.3 animations:^{
        self.solarDateView.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
        [self.solarDateView show];
    }];
}

- (IBAction)lunarResultBtnClick:(id)sender {
    self.btn.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lunarDateView.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
        [self.lunarDateView show];
    }];
}

- (IBAction)firstDateBtnClick:(id)sender {
    self.btn.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.solarDateView.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
        [self.solarDateView show];
    }];
}

- (IBAction)secondDateBtnClick:(id)sender {
    self.btn.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lunarDateView.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
        [self.lunarDateView show];
    }];
}

- (IBAction)selectDateBtnClick:(id)sender {
    self.btn.hidden = NO;
    
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
    [UIView animateWithDuration:0.3 animations:^{
        self.lunarDateView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
    }];
}
- (IBAction)qianBtnClick:(id)sender {
    [self.qianBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:103/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];
    qianBtnSelected = 1;
    houBtnSelected = 0;
    [self.houBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (IBAction)houBtnClick:(id)sender {
    [self.houBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:103/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];
    qianBtnSelected = 0;
    houBtnSelected = 1;
    [self.qianBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (IBAction)JianGeTextFieldClick:(id)sender {
    [self.JianGeTextField setText:@""];
}

- (IBAction)JianGeSearchBtnClick:(id)sender {
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
    [UIView animateWithDuration:0.3 animations:^{
        self.solarDateView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
    }];
}

@end
