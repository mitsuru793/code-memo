---
layout: code
title: PHPのテンプレートライブラリplatesのレンダリング処理を読む
tags: [php, read]
date: 2016-12-17 19:40:01 +0900
---

PHPのテンプレートライブラリである`thephpleague/plates`のソースコードを読みました。とてもシンプルな実装で、テンプレートは生のPHPを書きます。この記事では読みやすいようにコードを並び替えて記載しています。

+ [Github](https://github.com/thephpleague/plates)
+ [Document](http://platesphp.com/)

Engineから各クラスに委譲をしており、委譲先のクラスは小さいです。移譲と分割の参考になると思います。継承はExtensionInterface以外では使われておりません。

# テンプレートファイルのレンダリング

下記のコードがこのライブラリのメインとなる処理です。ここを見ていきます。

```php
// pathはEngineに委譲したDirectoryで管理されます。
// Directoryはpathを保持するだけのクラスで、pathはただの文字列として保持します。
$templates = new League\Plates\Engine('/path/to/templates');

// $templatesはEngineであることに注意です。renderを通じて、Engineに委譲したTemplateのrenderを実行します。
// profileのTemplateを生成して、その場でrenderを実行するということです。
echo $templates->render('profile', ['name' => 'Jonathan']);
```

## Engineの生成

Engine以外のクラスのインスタンスを持ちます。委譲されています。小さく分割されたクラスのオブジェクト（インスタンス）を組み合わせてEngineは作られています。他のクラスをEngineのAPI（メソッド）にまとめています。

make()はTemplateを生成するだけで、render()になるとmake()で生成してすぐにレンダリングがされます。

```php
// Engine.php
public function __construct($directory = null, $fileExtension = 'php')
{
    $this->directory = new Directory($directory);
    $this->fileExtension = new FileExtension($fileExtension);
    $this->folders = new Folders();
    $this->functions = new Functions();
    $this->data = new Data();
}

// Engine.php
public function render($name, array $data = array())
{
    return $this->make($name)->render($data);
}

// Engine.php
public function make($name)
{
    return new Template($this, $name);
}
```

## Templateの生成

Engineの他にロジックを持っているとしたら、このクラスです。

Template->dataプロパティはただの配列ですが、Engine->dataはdataクラスです。dataプロパティはEngineとTemplateの両方に持たせています。Engineのdataで全テンプレート共通のdataを設定することができます。デフォルト値ですね。

```php
// Template.php
public function __construct(Engine $engine, $name)
{
    $this->engine = $engine;
    $this->name = new Name($engine, $name);

    // Engine->addDataで、全テンプレート共通のDataをセットできます。
    $this->data($this->engine->getData($name));
}

// Engine.php
public function getData($template = null)
{
    // データはEngineに委譲されたDataインスタンスのgetメソッドを通す。
    return $this->data->get($template);
}

// Template.php
public function data(array $data)
{
    $this->data = array_merge($this->data, $data);
}
```


## Templateのレンダリング

templateファイルはrenderメソッドの中でincludeされます。そのためtemplate内はTemplateインスタンスの中なので、escapeなど使えるメソッドはTemplateに記述されているものです。

これでテンプレートファイルが描画される処理は終わりです。

```php
// Template.php
// layoutNameが設定されている場合は、再帰的に呼び出されます。
public function render(array $data = array())
{
    try {
        $this->data($data);

        // $this->dataは消えません。$dataはコピーされています。
        unset($data);

        // 2次元配列で変数定義をします。
        // このスコープでテンプレートをinluceすれば、テンプレート変数として扱えます。
        extract($this->data);

        ob_start();

        if (!$this->exists()) {
            throw new LogicException(
                'The template "' . $this->name->getName() . '" could not be found at "' . $this->path() . '".'
            );
        }

        // pathはただの文字列です。Name->getPathを実行します。
        include $this->path();

        $content = ob_get_clean();

        // layout()で内側のテンプレートから指定した、外側のテンプレートのレンダリングを行います。
        // layoutNameは、テンプレートファイルで$this->layout()を通じてセットされます。
        if (isset($this->layoutName)) {
            // $layoutはTemplateクラスです。
            $layout = $this->engine->make($this->layoutName);
            // sections['content']にテンプレートファイルの中身が入ります。
            $layout->sections = array_merge($this->sections, array('content' => $content));
            $content = $layout->render($this->layoutData);
        }

        return $content;
    } catch (LogicException $e) {
        // バッファにある文字数
        if (ob_get_length() > 0) {
            ob_end_clean();
        }

        throw $e;
    }
}

// Template.php
public function exists()
{
    return $this->name->doesPathExist();
}

// Name.php
public function doesPathExist()
{
    return is_file($this->getPath());
}

// Template.php
public function path()
{
    return $this->name->getPath();
}

// Name.php
public function getPath()
{
    if (is_null($this->folder)) {
        return $this->getDefaultDirectory() . DIRECTORY_SEPARATOR . $this->file;
    }

    $path = $this->folder->getPath() . DIRECTORY_SEPARATOR . $this->file;

    if (!is_file($path) and $this->folder->getFallback() and is_file($this->getDefaultDirectory() . DIRECTORY_SEPARATOR . $this->file)) {
        $path = $this->getDefaultDirectory() . DIRECTORY_SEPARATOR . $this->file;
    }

    return $path;
}

// Name.php
protected function getDefaultDirectory()
{
    $directory = $this->engine->getDirectory();

    if (is_null($directory)) {
        throw new LogicException(
            'The template name "' . $this->name . '" is not valid. '.
            'The default directory has not been defined.'
        );
    }

    return $directory;
}
```

# Nameの生成

Nameクラスはアクセサとbooleanを返すメソッドしかありません。engine, name, folder,  fileプロパティを持っています。

`'dirname::template file'`という命名規則をこのクラスで表しています。Folder, Directoryクラスで委譲されています。pathは別プロパティに分けています。

```php
// Name.php
public function __construct(Engine $engine, $name)
{
    $this->setEngine($engine);
    $this->setName($name);
}

// Name.php
public function setEngine(Engine $engine)
{
    $this->engine = $engine;

    return $this;
}

// Name.php
public function setName($name)
{
    $this->name = $name;

    $parts = explode('::', $this->name);

    if (count($parts) === 1) {
        $this->setFile($parts[0]);
    } elseif (count($parts) === 2) {
        $this->setFolder($parts[0]);
        $this->setFile($parts[1]);
    } else {
        throw new LogicException(
            'The template name "' . $this->name . '" is not valid. ' .
            'Do not use the folder namespace separator "::" more than once.'
        );
    }

    return $this;
}

// Name.php
// Foldersクラスのfoldersプロパティ（配列）から$folderを取得します。
public function setFolder($folder)
{
    $this->folder = $this->engine->getFolders()->get($folder);

    return $this;
}

// Name.php
public function setFile($file)
{
    // 空文字ではない前提なので、チェックしています。関数の独立性を高めます。
    if ($file === '') {
        throw new LogicException(
            'The template name "' . $this->name . '" is not valid. ' .
            'The template name cannot be empty.'
        );
    }

    $this->file = $file;

    if (!is_null($this->engine->getFileExtension())) {
        $this->file .= '.' . $this->engine->getFileExtension();
    }

    return $this;
}

// Engine.php
public function getFileExtension()
{
    return $this->fileExtension->get();
}
```

# データの保持するだけのクラス

どんなデータの形ごとにクラスが用意されています。目的はデータをクラスで表すだけなので、ロジックコードはありません。1つのプロパティしか持っていなくても、Engineに配列や変数で持たせずしっかりとクラス化しています。

## Folders
Folderのコレクションです。add, remove, get, existsメソッドしかありません。コンストラクタも定義されていません。

## Folder
name, path, fallbackプロパティを保持するだけです。アクセサはあります。

## FileExtension
fileExtensionプロパティを持っているだけです。アクセサ名はget, setでプロパティ名を含んでいません。

## Directory

pathプロパティを持っているだけです。FileExtensionと同じでメソッドはget, setしかありません。

# 命名規則

## 全体を表す

全体共通のテンプレート変数をentireやallではなく、sharedで表すのがいいなと思いました。

+ sharedVariables
+ templateVariables

## 複数形のクラス名

FoldersやFunctionsなど複数形で、値を束ねる意味を使っています。FolderListやFunctionListではありません。

## アクセサ

引数をそのままセットしない場合は、プリフィックスsetを付けていません。下記は$dataではなく$this->dataをセットしているという感覚でしょう。

```php
// Template.php
public function data(array $data)
{
    $this->data = array_merge($this->data, $data);
}
```

1つしかプロパティを持たないクラスの場合は、get/setという名前にしています。

```
// Directory.php
public function get()
{
    return $this->path;
}
```

isではなくdoesを使っているのは初めて見ました。

```php
public function doesFunctionExist($name)
{
    return $this->functions->exists($name);
}
```

# 参考になる書き方

どの条件にも当てはまらない場合は、最後にthrowを置きます。

```php
// Data.php
public function add(array $data, $templates = null)
{
    if (is_null($templates)) {
        return $this->shareWithAll($data);
    }

    if (is_array($templates)) {
        return $this->shareWithSome($data, $templates);
    }

    if (is_string($templates)) {
        // 上記に合わせて文字列は配列に変換します。
        return $this->shareWithSome($data, array($templates));
    }

    throw new LogicException(
        'The templates variable must be null, an array or a string, ' . gettype($templates) . ' given.'
    );
}
```

issetでまとめて2つの変数の存在を確認しています。&&を使う必要はありません。

```php
// Data.php
public function get($template = null)
{
    if (isset($template, $this->templateVariables[$template])) {
        return array_merge($this->sharedVariables, $this->templateVariables[$template]);
    }

    return $this->sharedVariables;
}
```

Engineを通してFoldersからFolderを取ってきています。Nameに直接Foldersは持たせていません。他のオブジェクトはEngineに集約しています。

```php
// Name.php
public function setFolder($folder)
{
    $this->folder = $this->engine->getFolders()->get($folder);

    return $this;
}
```

引数の形のチェックではなく、中身がの正常かどうかで例外を投げます。

```php
public function remove($name)
{
    if (!$this->exists($name)) {
        throw new LogicException(
            'The template function "' . $name . '" was not found.'
        );
    }

    unset($this->functions[$name]);

    return $this;
}
```
