//
//  HomeController.m
//  AppExtensition
//
//  Created by 李伟 on 16/9/2.
//  Copyright © 2016年 TFLH. All rights reserved.
//

#import "HomeController.h"
#import <arpa/inet.h>
#import <net/if.h>
#import <ifaddrs.h>
#import <net/if_dl.h>
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <QHSpeechSynthesizerQueue/QHSpeechSynthesizerQueue.h>
@interface HomeController ()
@property(nonatomic,strong)QHSpeechSynthesizerQueue *queue;
@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    double avaliMem = [self availableMemory];
    double userdMem = [self usedMemory];
    
    NSLog(@"<手机total>%f   《used》%f",avaliMem,userdMem);
  //  [self logMemoryInfo];
    
  //  [self getDataCounters];
  //  [self getInterfaceBytes];
    [self speech];
    
}

-(void)speech{
    
    [self.queue readLast:@"杭州同牛网络科技有限公司" withLanguage:@"zh-hans" andRate:0.2];
    [self.queue readNext:@"杭州市下城区同方财富大厦" withLanguage:@"zh-hans" andRate:.3 andClearQueue:(NO)];
    
}

#pragma mark   获取网络底层接口
- (void) getInterfaceBytes
{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1)
    {
        return;
    }
    
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
    {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        
        if (ifa->ifa_data == 0)
            continue;
        
        /* Not a loopback device. */
        if (strncmp(ifa->ifa_name, "lo", 2))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            
            iBytes += if_data->ifi_ibytes;
            NSLog(@"<接受>%f",iBytes/1024.0/1024.0);
          
            oBytes += if_data->ifi_obytes;
              NSLog(@"<发送>%f",oBytes/1024.0/1024.0);
        }
    }
    freeifaddrs(ifa_list);
}


- (NSArray *)getDataCounters
{
    BOOL   success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    int WiFiSent = 0;
    int WiFiReceived = 0;
    int WWANSent = 0;
    int WWANReceived = 0;
    
    NSString *name=[[NSString alloc]init];
    
    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
            NSLog(@"ifa_name %s == %@n", cursor->ifa_name,name);
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
                    NSLog(@"WiFiSent %d ==%d",WiFiSent,networkStatisc->ifi_obytes);
                    NSLog(@"WiFiReceived %d ==%d",WiFiReceived,networkStatisc->ifi_ibytes);
                }
                if ([name hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
                    NSLog(@"发送蜂窝数据 %f ==%d",WWANSent/1024/1024.0,networkStatisc->ifi_obytes);
                    NSLog(@"收到蜂窝数据 %d ==%d",WWANReceived/1024/1024,networkStatisc->ifi_ibytes);
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return [NSArray arrayWithObjects:[NSNumber numberWithInt:WiFiSent], [NSNumber numberWithInt:WiFiReceived],[NSNumber numberWithInt:WWANSent],[NSNumber numberWithInt:WWANReceived], nil];
}

-(void) logMemoryInfo {
    
    
    int mib[6];
    mib[0] = CTL_HW;
    mib[1] = HW_PAGESIZE;
    
    int pagesize;
    size_t length;
    length = sizeof (pagesize);
    if (sysctl (mib, 2, &pagesize, &length, NULL, 0) < 0)
    {
        fprintf (stderr, "getting page size");
    }
    
    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
    
    vm_statistics_data_t vmstat;
    if (host_statistics (mach_host_self (), HOST_VM_INFO, (host_info_t) &vmstat, &count) != KERN_SUCCESS)
    {
        fprintf (stderr, "Failed to get VM statistics.");
    }
    task_basic_info_64_data_t info;
    unsigned size = sizeof (info);
    task_info (mach_task_self (), TASK_BASIC_INFO_64, (task_info_t) &info, &size);
    
    double unit = 1024 * 1024;
    double total = (vmstat.wire_count + vmstat.active_count + vmstat.inactive_count + vmstat.free_count) * pagesize / unit;
    double wired = vmstat.wire_count * pagesize / unit;
    double active = vmstat.active_count * pagesize / unit;
    double inactive = vmstat.inactive_count * pagesize / unit;
    double free = vmstat.free_count * pagesize / unit;
    double resident = info.resident_size / unit;
    NSLog(@"===================================================");
    NSLog(@"Total:%.2lfMb", total);
    NSLog(@"Wired:%.2lfMb", wired);
    NSLog(@"Active:%.2lfMb", active);
    NSLog(@"Inactive:%.2lfMb", inactive);
    NSLog(@"Free:%.2lfMb", free);
    NSLog(@"Resident:%.2lfMb", resident);
}
- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount =HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                              HOST_VM_INFO,
                                              (host_info_t)&vmStats,
                                              &infoCount);
    
    if(kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount =TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if(kernReturn != KERN_SUCCESS
       ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;}


//+ (NSArray *)getDataCounters
//{
//    BOOL   success;
//    struct ifaddrs *addrs;
//    const struct ifaddrs *cursor;
//    const struct if_data *networkStatisc;
//    
//    int WiFiSent = 0;
//    int WiFiReceived = 0;
//    int WWANSent = 0;
//    int WWANReceived = 0;
//    
//    NSString *name=[[[NSString alloc]init]autorelease];
//    
//    success = getifaddrs(&addrs) == 0;
//    if (success)
//    {
//        cursor = addrs;
//        while (cursor != NULL)
//        {
//            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
//            NSLog(@"ifa_name %s == %@n", cursor->ifa_name,name);
//            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
//            if (cursor->ifa_addr->sa_family == AF_LINK)
//            {
//                if ([name hasPrefix:@"en"])
//                {
//                    networkStatisc = (const struct if_data *) cursor->ifa_data;
//                    WiFiSent+=networkStatisc->ifi_obytes;
//                    WiFiReceived+=networkStatisc->ifi_ibytes;
//                    NSLog(@"WiFiSent %d ==%d",WiFiSent,networkStatisc->ifi_obytes);
//                    NSLog(@"WiFiReceived %d ==%d",WiFiReceived,networkStatisc->ifi_ibytes);
//                }
//                if ([name hasPrefix:@"pdp_ip"])
//                {
//                    networkStatisc = (const struct if_data *) cursor->ifa_data;
//                    WWANSent+=networkStatisc->ifi_obytes;
//                    WWANReceived+=networkStatisc->ifi_ibytes;
//                    NSLog(@"WWANSent %d ==%d",WWANSent,networkStatisc->ifi_obytes);
//                    NSLog(@"WWANReceived %d ==%d",WWANReceived,networkStatisc->ifi_ibytes);
//                }
//            }
//            cursor = cursor->ifa_next;
//        }
//        freeifaddrs(addrs);
//    }
//    return [NSArray arrayWithObjects:[NSNumber numberWithInt:WiFiSent], [NSNumber numberWithInt:WiFiReceived],[NSNumber numberWithInt:WWANSent],[NSNumber numberWithInt:WWANReceived], nil];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
