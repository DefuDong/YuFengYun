//
//  LeftViewController.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-6-5.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "LeftViewController.h"

#import "ViewController.h"
#import "ChannelViewController.h"
#import "MLNavigationController.h"
#import "UIViewController+MMDrawerController.h"
#import "PictureViewController.h"
#import "VideoViewController.h"

#import "LeftPageCell.h"
#import "Common.h"


@interface LeftViewController ()
<
  UITableViewDataSource,
  UITableViewDelegate
>
{
    NSUInteger _selectedIndex;
}
@property (nonatomic, weak) IBOutlet UITableView *table;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation LeftViewController
- (NSArray *)titles {
    if (!_titles) {
        _titles = [NSArray arrayWithObjects:@"首页", @"御风云", @"科技动态", @"商务趋势", @"要闻趣事", @"图集", @"视频", nil];
    }
    return _titles;
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigationBarHidden:YES];
    
    self.view.backgroundColor = kRGBColor(69, 87, 101);//kRGBAColor(0, 147, 218, .9);
    
    if (SYSTEM_VERSION_MOER_THAN_7) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        headView.backgroundColor = [UIColor clearColor];
        self.table.tableHeaderView = headView;
    }
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *selectedIndexPath = [self.table indexPathForSelectedRow];
    if (!selectedIndexPath) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
        
        [self.table selectRowAtIndexPath:indexPath
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
    }
}



#pragma mark UITableView
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
	return self.titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = LeftPageCellIdentifier;
	
	LeftPageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[LeftPageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
		
	cell.cellTitle = self.titles[indexPath.row];
    	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YFYViewController *viewController = nil;
    if(indexPath.row==0){
        viewController = [[ViewController alloc] initFromNib];
    }
    else if (indexPath.row == 1) {
        viewController = [[ChannelViewController alloc] initWithChannelCode:CHANNEL_CODE_XINSHIDIAN];
    }
    else if (indexPath.row == 2) {
        viewController = [[ChannelViewController alloc] initWithChannelCode:CHANNEL_CODE_DONGTAI];
    }
    else if (indexPath.row == 3) {
        viewController = [[ChannelViewController alloc] initWithChannelCode:CHANNEL_CODE_SHIDIAN];
    }
    else if (indexPath.row == 4) {
        viewController = [[ChannelViewController alloc] initWithChannelCode:CHANNEL_CODE_GUANLI];
    }
    else if (indexPath.row == 5) {
        viewController = [[PictureViewController alloc] initFromNib];
    }
    else if (indexPath.row == 6) {
        viewController = [[VideoViewController alloc] initFromNib];
    }
    
    [self.mm_drawerController setCenterViewController:viewController
                               withFullCloseAnimation:YES
                                           completion:NULL];
    
    _selectedIndex = indexPath.row;
}


@end


//@interface LeftHeadView : UIView
//@end
//@implementation LeftHeadView
//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(context, kRGBColor(53, 75, 88).CGColor);
//    CGContextSetLineWidth(context, .5);
//    CGContextMoveToPoint(context, 0, rect.size.height);
//    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
//    CGContextStrokePath(context);
//}
//@end



