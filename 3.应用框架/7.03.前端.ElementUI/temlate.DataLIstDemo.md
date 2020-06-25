```
<template>
  <el-row><el-col :span="24">
  <div class="sky-app-container">
    <!--search-->
    <el-card class="sky-search-container" shadow="false">
      <i class="el-icon-search"></i>
      <span>筛选搜索</span>
      <el-button type="primary" size="mini" @click="searchList">搜索</el-button>
      <el-button size="mini" @click="resetSearch">重置</el-button>
      <el-form :inline="true" :model="listQuery" size="mini"></el-form>
    </el-card>
    <!--operation-->
    <el-card class="sky-operate-container" shadow="false">
      <i class="el-icon-tickets"></i>
      <span>数据列表</span>
      <el-button type="primary" size="mini">按钮</el-button>
    </el-card>
    <!--data-->
    <el-card class="sky-data-container" shadow="false">
      <el-table size="mini" :data="list" v-loading="loading" element-loading-text="拼命加载中">
        <el-table-column property="id" label="用户ID" width="60" align="center"/>
        <el-table-column property="username" label="用户名" width="100" align="center"/>
      </el-table>
    </el-card>
    <!--pagination-->
    <el-pagination
      class="sky-pagination-container"
      background
      @size-change="sizeChange"
      @current-change="currentChange"
      layout="total, sizes,prev, pager, next,jumper"
      :page-size="listQuery.pageSize"
      :page-sizes="[5,10,15]"
      :current-page.sync="listQuery.pageNum"
      :total="total">
    </el-pagination>
  </div>
  </el-col></el-row>
</template>

<script>
  const defaultListQuery = {
    pageNum: 1,
    pageSize: 10
  };
  export default {
    name: "groupChatList",
    data() {
      return {
        listQuery: Object.assign({}, defaultListQuery),
        total: 0,
        loading: false,
        list: []
      }
    },
    methods: {
      searchList() {
        this.getList();
      },
      resetSearch() {
        this.listQuery = Object.assign({}, defaultListQuery);
      },
      getList() {
      },
      sizeChange(val) {
        this.listQuery.pageNum = 1;
        this.listQuery.pageSize = val;
        this.getList();
      },
      currentChange(val) {
        this.listQuery.pageNum = val;
        this.getList();
      }
    }
  }
</script>

<style scoped>
</style>

```
