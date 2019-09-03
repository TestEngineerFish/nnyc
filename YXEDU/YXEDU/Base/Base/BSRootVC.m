
#import "BSRootVC.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "BSCommon.h"

@interface BSRootVC ()

@end

@implementation BSRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


//左侧一个图片按钮的情况
- (void)addLeftBarButtonWithImage:(UIImage *)image action:(SEL)action {
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    firstButton.backgroundColor = [UIColor redColor];
    firstButton.frame = CGRectMake(0, 0, 44, 44);
    [firstButton setImage:image forState:UIControlStateNormal];
    [firstButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
//    if (!SYSTEM_VERSION_LESS_THAN(11)) {
        firstButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
//        [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5 *SCREEN_WIDTH /375.0,0,0)];
//    }

    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:firstButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}
//右侧一个图片按钮的情况
- (void)addRightBarButtonWithFirstImage:(UIImage *)firstImage action:(SEL)action {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0,44,44)];
    view.backgroundColor = [UIColor clearColor];

    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 44, 44);
    [firstButton setImage:firstImage forState:UIControlStateNormal];
    [firstButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

    if (!SYSTEM_VERSION_LESS_THAN(11)) {
        firstButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
        [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0, -5 *SCREEN_WIDTH /375.0)];
    }
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:firstButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}
//右侧为文字item的情况
- (void)addRightBarButtonItemWithTitle:(NSString *)itemTitle action:(SEL)action {
    UIButton *rightbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,88,44)];
    [rightbBarButton setTitle:itemTitle forState:(UIControlStateNormal)];
    [rightbBarButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    rightbBarButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [rightbBarButton addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    if (!SYSTEM_VERSION_LESS_THAN(11.0)) {
        rightbBarButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
        [rightbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0, -5 * SCREEN_WIDTH/375.0)];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbBarButton];
}
//左侧为文字item的情况
- (void)addLeftBarButtonItemWithTitle:(NSString *)itemTitle action:(SEL)action {
    UIButton *leftbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44,44)];
    [leftbBarButton setTitle:itemTitle forState:(UIControlStateNormal)];
    [leftbBarButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    leftbBarButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [leftbBarButton addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    if (!SYSTEM_VERSION_LESS_THAN(11)) {
        leftbBarButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        [leftbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -5  *SCREEN_WIDTH/375.0,0,0)];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftbBarButton];
}

//右侧两个图片item的情况
- (void)addRightTwoBarButtonsWithFirstImage:(UIImage *)firstImage firstAction:(SEL)firstAction secondImage:(UIImage *)secondImage secondAction:(SEL)secondAction {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0,80,44)];
    view.backgroundColor = [UIColor clearColor];

    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(44, 6, 30, 30);
    [firstButton setImage:firstImage forState:UIControlStateNormal];
    [firstButton addTarget:self action:firstAction forControlEvents:UIControlEventTouchUpInside];
    if (!SYSTEM_VERSION_LESS_THAN(11)) {
        firstButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
        [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0, -5 * SCREEN_WIDTH/375.0)];
    }
    [view addSubview:firstButton];
    UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondButton.frame = CGRectMake(6, 6, 30, 30);
    [secondButton setImage:secondImage forState:UIControlStateNormal];
    [secondButton addTarget:self action:secondAction forControlEvents:UIControlEventTouchUpInside];
    if (!SYSTEM_VERSION_LESS_THAN(11)) {
        secondButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
        [secondButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0, -5 * SCREEN_WIDTH/375.0)];
    }
    [view addSubview:secondButton];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}
- (void)dealloc {
    
}

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
