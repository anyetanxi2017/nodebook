## 前台
template
```
<el-form-item>
  <el-date-picker
    v-model="listQuery.dates"
    type="datetimerange"
    :picker-options="pickerOptions"
    range-separator="至"
    start-placeholder="开始日期"
    end-placeholder="结束日期"
    >
  </el-date-picker>
</el-form-item>
```
js
```
const defaultListQuery = {
  pageNum: 1,
  pageSize: 10,
  uid: null,
  username: null,
  pid: null,
  dates: [new Date(new Date().setHours(0, 0, 0, 0)), new Date(new Date().setHours(23, 59, 59, 0))],
  type: null //1统计月分 2统计某天
};
data(){
  return {
    listQuery: Object.assign({}, defaultListQuery)
  }
}
```

## 服务器
reqVO
```
@Data
public class MoneyChangeStatisticsReqVo {
  private Integer type; //1统计月分 2统计某天
  private Integer year;
  private Integer month;
  private Integer day;
  private Date[] dates;
  private List<Integer> days = new ArrayList<>();
}
```
setDays
```
private void beforeSearch(MoneyChangeStatisticsReqVo vo) {
    List<Integer> days = vo.getDays();
    Date[] dates = vo.getDates();
    // 处理开始和结束日期
    if (DateUtil.month(dates[0]) != DateUtil.month(dates[1])) {
        dates[1] = DateUtil.endOfMonth(dates[0]);
    }
    //设置天数
    int begin = DateUtil.dayOfMonth(dates[0]);
    int end = DateUtil.dayOfMonth(dates[1]);
    for (int i = begin; i <= end; i++) {
        days.add(i);
    }
    vo.setMonth(DateUtil.month(dates[0]) + 1);
    vo.setYear(DateUtil.year(dates[0]));
}
```
