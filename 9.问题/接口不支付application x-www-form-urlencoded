```
 @RequestMapping(value = "/mifu", method = RequestMethod.POST)
  public JsonResultVo test(@RequestBody MultiValueMap<String, Object> map) {
    merchantService.handleMiFuReturnInfo(map);
    return JsonResultVo.success();
  }
```
使用`MultiValueMap<String, Object> map`进行接收
