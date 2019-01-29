# WQTaskScheduler 
iOS 任务调度器，为 CPU 和内存减负 

## 特性

- 命令模式：将任务用容器管理起来延迟执行，实现任务执行频率控制、任务总量控制。
- 策略模式：利用 C++ 栈、队列、优先队列实现三种调度策略，性能优越。
- 应用场景一：主线程任务量过大导致掉帧（利用组件为任务调度降频）。
- 应用场景二：短时间内执行的任务量过大，而某些任务失去了执行的意义（利用组件的任务淘汰策略）。
- 应用场景三：需要将任务按自定义的优先级调度（利用组件的优先队列策略）


### 基本使用


```
初始化 （有三种策略类型选择）
let schedule = WQTaskSchedule(strategy: .taskFIFO)

schedule.addTask {
    // 具体的操作任务，比较耗时费性能的
    /*
    -------------- 具体业务代码
    */

    ///注意：主线程操作一定要写在这里面
    DispatchQueue.main.async {

    }
}
```
注意该组件使用实例化方式使用，为了避免任务调度器提前释放，需要外部对其进行强持有（建议作为调用方的属性或实例变量）。

### 任务调度策略

任务调度策略有三种：
```/// 调度器的调度规则方式
///
/// - taskLIFO: 后进先出（后进任务优先级高）  队列的方式
/// - taskFIFO: //先进先出（先进任务优先级高）栈的方式
/// - taskPriority）: //优先级调度（自定义任务的优先级
enum WQTaskSchedulerMethodType: Int {
    case taskLIFO
    case taskFIFO
    case taskPriority   
}
```
用于区分是先添加的调度，还是后添加的进行调度。

比如在一个 UITableView 的列表中，每一个 Cell 都有一个将头像图片异步裁剪为圆角的任务，当快速滑动的时候，理所应当是后加入的任务应该调用，所以应该选择 .taskLIFO。

当业务中的任务需要按照你自己指定的优先级来调度，就选择 . taskPriority   。(未完成)



### 任务淘汰机制

很多时候你需要淘汰掉一部分已经添加到`WQTaskSchedule`的任务。

比如一个屏幕显示 10 个 图片， 当你滚动到第 100个图片的时， 前面的 90张图片已经离开屏幕， 就需要将任务队列中前面添加的任务移除， 他们的异步任务已经不需要了,
控制队列最大存储的任务数目
```schedule.maxTaskNum = 20
```
这里设置最大任务数量为 20，若添加的任务大于了这个数量，会删除掉优先级低的任务。
不同的策略会删除不同位置的任务。

### 任务调用频率控制

控制线程最大执行任务的个数：
/// 每次最大并发数目 10
```schedule.executeMaxTaskNum = 10
```
默认是每次 RunLoop 循环调用一个任务，比如你这么做：
可以控制每次消息循环调用几个任务。 这里可以根据不同的机型做不同的处理，来适配不同机型的性能
```
scheduler.executeFrequency = 1;
```




