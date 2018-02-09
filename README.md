
# TableViewSectionIndexChangeCallback
A Category of UITableView that stores a block property which can receive the callback from UITableViewIndex in the UITableView, you can use it to customize the behavior of your ViewController with the changing of sectionIndex and tracking state. 

hook UITableView内部的UITableViewIndex，实现滑动事件的监听回调

---
# TableViewSectionIndexChangeCallback
-------------

### 效果:
![image](https://)

### 示例:  
```oc
    __weak typeof(self) weakself = self;
    self.tableView.sectionIndexChanged = ^(NSInteger sectionIndex, BOOL isTracking) {
        weakself.indexIndicatorLabel.hidden = !isTracking;
        weakself.indexIndicatorLabel.text = !isTracking ? nil : [weakself sectionIndexTitlesForTableView:weakself.tableView][sectionIndex];
    };
```

### 特性

- 触摸结束等情况下，selectedSection会变为NSIntegerMax，这里重算该值，以避免外部使用该值导致越界等异常

### 原理说明

- 使用Category为UITableView添加block属性

- 使用runtime方法替换监听了UITableViewIndex的各个触摸事件，实现监听

### 使用方法
直接下载工程，拷贝UITableView+IndexPan.h与.m文件，*#import "UITableView+IndexPan.h"* 即可使用

### 注意事项
- 暂无

## License
none
