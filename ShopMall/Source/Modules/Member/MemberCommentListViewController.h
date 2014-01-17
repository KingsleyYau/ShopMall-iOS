//
//  MemberCommentListViewController.h
//  ShopMall
//
//  Created by KingsleyYau on 14-1-6.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"
#import "CommentTableView.h"

@interface MemberCommentListViewController : BaseViewController
@property (nonatomic, weak) IBOutlet CommentTableView *tableView;
@property (nonatomic, strong) Shop *item;
@end
