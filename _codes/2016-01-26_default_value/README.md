---
layout: code
title: 変数のデフォルト値
tags: [bash]
date: 2016-01-26 00:00:00 +0900
---

```bash
name=${name:-taro}
echo "1:${name}"
# => 1:taro

echo "2:${age:-18}"
# => 2:18

age=20
echo "3:${age:-9}"
# => 3:20

from=
echo "4:${from:-japan}"
# => 4:japan
```