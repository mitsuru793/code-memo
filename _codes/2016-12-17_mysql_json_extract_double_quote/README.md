---
layout: code
title:  MySQLのJSON_EXTRACTで文字列を取得するとダブルクオートも含まれる
tags: [mysql]
date: 2016-12-17 22:05:46 +0900
---

MySQLのJSON_EXTRACT()は囲んでいるダブルクオートも含まれて取得されます。JSON_REPLACE()だと、置換元を囲んでいるダブルクオートは置換対象になりません。
そのまま既存のjsonの値で置換しようとすると、二重ダブルクオートになるので注意です。内側のクオートはエスケープされます。
そのため、jsonの文字列はTRIMにかけてから使うとよいです。

それを実際にコードで確認していきます。MySQLのバージョンは5.7.16-logです。`SELECT version()`で確認できます。

```sql
SELECT JSON_EXTRACT('{"url": "http"}', '$.url');
-- "http"

SELECT JSON_EXTRACT('{"url": 1}', '$.url');
-- 1

SELECT JSON_REPLACE('{"url": "http"}', '$.url', 'ftp');
-- {"url": "ftp"}

SET @json = '{"url": "http://hoge.com"}';
SELECT REPLACE(JSON_EXTRACT(@json, '$.url'), 'http://', 'https://');
-- "https://hoge.com"

SET @json = '{"url": "http://hoge.com"}';
SELECT JSON_EXTRACT(@json, '$.url') REGEXP '^http';
-- ヒットしない
-- 0

SET @json = '{"url": "http://hoge.com"}';
SELECT JSON_EXTRACT(@json, '$.url') REGEXP '^"http';
-- ヒット 囲んでいるダブルクオートも検索対象
-- 1

SET @json = '{"url": "http://hoge.com"}';
SET @path='$.url';
SELECT JSON_REPLACE(@json, @path, REPLACE(JSON_EXTRACT(@json, @path), 'http://', 'https://'));
-- エスケープされたクオートが入ってしまう
-- 置換する時は、置換元を囲んでいるダブルクオートが置換対象にならない。
-- {"url": "\"https://hoge.com\""}

-- TRIMを使えば取得時にクオートを消せる
SET @json = '{"url": "http://hoge.com"}';
SELECT TRIM(BOTH '"' FROM REPLACE(JSON_EXTRACT(@json, '$.url'), 'http://', 'https://'));
-- https://hoge.com

-- 解決
SET @json = '{"url": "http://hoge.com"}';
SET @path='$.url';
SELECT JSON_REPLACE(@json, @path, REPLACE(TRIM(BOTH '"' FROM JSON_EXTRACT(@json, @path)), 'http://', 'https://'));
-- {"url": "https://hoge.com"}
```
