//
//  SearchCityViewController.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-18.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "SearchCityViewController.h"
#import "DataCenter.h"
#import "NSString+Pinyin.h"

@interface CityHeaderView : UIView
@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) BOOL drawLine;
@end

@interface SearchCityViewController ()
<
  UITableViewDataSource,
  UITableViewDelegate,
  UISearchDisplayDelegate
>
@property (nonatomic, weak) IBOutlet UITableView *mainTableView;

@property (nonatomic, strong) NSMutableArray *cityKeys;
@property (nonatomic, strong) NSMutableArray *searchResultArray;

@end

@implementation SearchCityViewController
- (NSMutableArray *)cityKeys {
    if (!_cityKeys) {
        NSArray *keys = [[DATA cityDataDic_pinyin] allKeys];
        _cityKeys = [NSMutableArray arrayWithArray:[keys sortedArrayUsingSelector:@selector(compare:)]];
        [_cityKeys insertObject:@"定位到的城市" atIndex:0];
    }
    return _cityKeys;
}
- (NSMutableArray *)searchResultArray {
    if (!_searchResultArray) {
        _searchResultArray = [[NSMutableArray alloc] init];
    }
    return _searchResultArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBackNavButtonActionPop];
    self.navigationBar.title = @"选择城市";
    
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.mainTableView) {
        return self.cityKeys.count;
    } else if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.mainTableView) {
        if (section == 0) return 1;
        return [[[DATA cityDataDic_pinyin] objectForKey:self.cityKeys[section]] count];
    } else if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResultArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.mainTableView) {
        return 40;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.mainTableView) {
        CityHeaderView *headView = [[CityHeaderView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                    tableView.frame.size.width,
                                                                                    tableView.sectionHeaderHeight)];
        headView.title = self.cityKeys[section];
        if (section == 0) {
            headView.drawLine = NO;
        }
        return headView;
    }
    return nil;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.mainTableView) {
        NSMutableArray *sectionTitles = [self.cityKeys mutableCopy];
        sectionTitles[0] = @"#";
        return sectionTitles;
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSString *cityName = nil;
    
    if (tableView == self.mainTableView) {
        if (indexPath.section == 0) {
            cityName = @"北京";
        }else {
            NSArray *citys = [[DATA cityDataDic_pinyin] objectForKey:self.cityKeys[indexPath.section]];
            cityName = citys[indexPath.row];
        }
    }else {
        cityName = self.searchResultArray[indexPath.row];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.text = cityName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    UISearchDisplayController
}


- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    [UIView animateWithDuration:.25 animations:^{
        CGRect navFrame = self.navigationBar.frame;
        navFrame.origin.y = -44;
        self.navigationBar.frame = navFrame;
        
        self.mainTableView.frame = self.view.bounds;
    }];
}
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    CGRect navFrame = self.navigationBar.frame;
    navFrame.origin.y = 0;
    self.navigationBar.frame = navFrame;
    
    self.mainTableView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44);
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self sortResultWith:searchString];
    return YES;
}


-(void)sortResultWith:(NSString *)sText {

	sText = [sText lowercaseString];
	
	if ([sText length]) {
		
		if (self.searchResultArray.count) 
			[self.searchResultArray removeAllObjects];
		
        NSArray *allKeys = [[DATA cityDataDic_pinyin] allKeys];
        for (NSString *key in allKeys) {
            NSArray *citys = [[DATA cityDataDic_pinyin] objectForKey:key];
            
            for (NSString *city in citys) {
                NSString *pinyin = [city pinyinString];
                if ([[pinyin lowercaseString] rangeOfString:sText].location != NSNotFound ||
                    [[city lowercaseString] rangeOfString:sText].location != NSNotFound) 
                    [self.searchResultArray addObject:city];
                
            }
        }
    }
}


@end



@implementation CityHeaderView {
    UILabel *_label;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self perset];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self perset];
    }
    return self;
}
- (void)perset {
    self.backgroundColor = [UIColor clearColor];
    self.drawLine = YES;
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 30)];
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = UITextAlignmentLeft;
    _label.font = [UIFont boldSystemFontOfSize:17];
    [self addSubview:_label];
}
- (void)setTitle:(NSString *)title {
    _label.text = title;
}
- (NSString *)title {
    return _label.text;
}
- (void)setDrawLine:(BOOL)drawLine {
    _drawLine = drawLine;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (self.drawLine) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
        CGContextMoveToPoint(context, 20, 0);
        CGContextAddLineToPoint(context, rect.size.width-20, 0);
        CGContextStrokePath(context);
    }
}

@end







