# 古诗文名句

数据采集自 [经典诗句_古诗文名句_古诗文网](https://so.gushiwen.org/mingju/)，共一万条。

## JSON

``` shell
$ jq '. | length' mingju.json
10000

$ jq ".[0]" mingju.json
{
  "contents": "夜月一帘幽梦，春风十里柔情。",
  "source": "秦观《八六子·倚危亭》"
}
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

## Web Users

https://mingju.vercel.app/

## HTTP API Users

总共有一万条名句，根据 ID 获得一条记录，ID 在 [0, 10000) 之间：

```
$ curl https://mingju.vercel.app/api/get?id=18
{
  "_id": "5f4e17aa6aed639f5c44258d",
  "contents": "春宵一刻值千金，花有清香月有阴。",
  "source": "苏轼《春宵·春宵一刻值千金》",
  "id": 18
}
```

随机获得一句（注意这个 API 是由服务器动态生成的，没法缓存，而如果用 `api/get?id=random` 则 CDN 有机会缓存）：

```
$ curl https://mingju.vercel.app/api/random
{
  "_id": "5f4e17aa6aed639f5c442885",
  "contents": "不论平地与山尖，无限风光尽被占。",
  "source": "罗隐《蜂》",
  "id": 778
}
```
