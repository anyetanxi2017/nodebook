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
    listQuery: Object.assign({}, defaultListQuery),
    pickerOptions: {
      shortcuts: [{
        text: '今天',
        onClick(picker) {
          const end = new Date(new Date().setHours(23, 59, 59, 0));
          const start = new Date(new Date().setHours(0, 0, 0, 0));
          picker.$emit('pick', [start, end]);
        }
      }, {
        text: ' 昨天',
        onClick(picker) {
          const end = new Date(new Date().setHours(23, 59, 59, 0));
          const start = new Date(new Date().setHours(0, 0, 0, 0));
          start.setTime(start.getTime() - 1000 * 3600 * 24);
          end.setTime(end.getTime() - 1000 * 3600 * 24)
          picker.$emit('pick', [start, end]);
        }
      },
        {
          text: '最近一周',
          onClick(picker) {
            const end = new Date();
            const start = new Date();
            start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
            picker.$emit('pick', [start, end]);
          }
        },
        {
          text: '本月',
          onClick(picker) {
            const start = new Date();
            start.setDate(1);
            start.setMonth(start.getMonth())
            start.setHours(0, 0, 0, 0)
            const date = new Date();
            const day = new Date(date.getFullYear(), date.getMonth(), 0).getDate();
            const end = new Date(new Date().getFullYear(), new Date().getMonth(), day);
            end.setHours(23, 59, 59, 0)
            picker.$emit('pick', [start, end]);
          }
        },
        {
          text: '上月',
          onClick(picker) {
            const start = new Date();
            start.setDate(1);
            start.setMonth(start.getMonth() - 1)
            start.setHours(0, 0, 0, 0)
            const date = new Date();
            const day = new Date(date.getFullYear(), date.getMonth(), 0).getDate();
            const end = new Date(new Date().getFullYear(), new Date().getMonth() - 1, day);
            end.setHours(23, 59, 59, 0)
            picker.$emit('pick', [start, end]);
          }
        }]
    }
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
