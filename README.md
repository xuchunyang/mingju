# 古诗文名句

数据采集自 [经典诗句_古诗文名句_古诗文网](https://so.gushiwen.org/mingju/)，共一万条。

``` shell
bash-4.4$ jq ".[$(shuf -i 0-9999 -n 1)]" mingju.json
{
  "contents": "一骑红尘妃子笑，无人知是荔枝来。",
  "source": "杜牧《过华清宫绝句三首》"
}
```