# 古诗文名句

数据采集自 [经典诗句_古诗文名句_古诗文网](https://so.gushiwen.org/mingju/)，共一万条。

``` shell
bash-4.4$ jq ".[$(shuf -i 0-9999 -n 1)]" mingju.json
{
  "contents": "一骑红尘妃子笑，无人知是荔枝来。",
  "source": "杜牧《过华清宫绝句三首》"
}
bash-4.4$ jq ".[$(shuf -i 0-9999 -n 1)]" mingju.json | jq -r '.contents + " -- " + .source'
此情可待成追忆？只是当时已惘然。 -- 李商隐《锦瑟》
```

## Emacs Users

`M-x mingju` 随机获得一条名句。

### Eshell Users

``` emacs-lisp
(setq eshell-banner-message
      '(concat (mapconcat #'identity (mingju) " -- ")
               "\n\n"))
```

## Command Line Users

[`mj`](./mj) 是个 Bash 脚本，依赖 `jq(1)` 和 GNU Coreuilts 的 `realpath(1)`。

``` shell
~ $ mj
人生如逆旅，我亦是行人。
		-- 苏轼《临江仙·送钱穆父》
```
