

#import <UIKit/UIKit.h>

@interface WBQRCodeVC : UIViewController

@property (nonatomic,copy) void (^WBQRCodeVCBlock)(NSString *text);


@end
