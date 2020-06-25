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
