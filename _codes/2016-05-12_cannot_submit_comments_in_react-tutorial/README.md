---
layout: code
title: Reactの公式チュートリアルでコメントを送信するとエラーになる
date: 2016-05-12 16:08:14 +0900
tags: [javascript, react]
---

[Reactの公式チュートリアル](https://facebook.github.io/react/docs/tutorial-ja-JP.html)でのエラーについてです。

# 発生エラー

コメントを送信した時に以下のエラーが発生しました。

```
jquery.min.js:4 POST http://localhost:3000/comments.json 405 (Method Not Allowed)
comments.json error Method Not Allowed
```

問題はコンポーネントに渡す`url`でした。

```javascript
// エラー
ReactDOM.render(
  <CommentBox url="comments.json" pollInterval={2000} />,
  document.getElementById('content')
);
```

`server.rb`ではドキュメントルートが`public`に指定されているので、`comments.json`を問い合わせるとは`/public/commnts.json`を取得するということです。`/public/comment.json`が置いてあれば、表示に問題はなく送信だけエラーが出ます。

```javascript
// 正常
ReactDOM.render(
  <CommentBox url="/api/comments" pollInterval={2000} />,
  document.getElementById('content')
);
```

`server.rb`に合わせるなら`url`を`comments.json`から`/api/comments`に変更して、`server.rb`と同じディレクトリに`comments.json`を置きましょう。その理由を知るために`server.rb`を見てみます。

# Rubyのserverファイル

```ruby
server.mount_proc '/api/comments' do |req, res|
  comments = JSON.parse(File.read('./comments.json', encoding: 'UTF-8'))

  if req.request_method == 'POST'
    # Assume it's well formed
    comment = { id: (Time.now.to_f * 1000).to_i }
    req.query.each do |key, value|
      comment[key] = value.force_encoding('UTF-8') unless key == 'id'
    end
    comments << comment
    File.write(
      './comments.json',
      JSON.pretty_generate(comments, indent: '    '),
      encoding: 'UTF-8'
    )
  end
  # ...
end
```

Rubyの場合はWEBrickを使って実装されています。`mount_proc`で`/api/comments`にアクセスされた場合に、`./comments.json`を読み込むようにしています。この時、`server.rb`があるパスからの相対パスとなります。`/public/comments.json`は読み込まれません。

```javascript
var CommentBox = React.createClass({
  // ...
  handleCommentSubmit: function(comment) {
    var comments = this.state.data;
    var newComments = comments.concat([comment]);
    this.setState({data: newComments});
    $.ajax({
      url :this.props.url,
      dataType: 'json',
      type: 'POST',
      data: comment,
      success: function(data) {
        this.setState({data: data});
      }.bind(this),
      error: function(xhr, status, err) {
        this.setState({data: comments});
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  // ...
  render: function() {
    return (
      <div className="commentBox">
        <h1>Comments</h1>
        <CommentList data={this.state.data} />
        <CommentForm onCommentSubmit={this.handleCommentSubmit} />
      </div>
    );
  }
});
```

`javascript`でコメントを送信時にはAPIを叩いているだけで保存しているわけではありません。`comments.json`を叩いても内容が取得できるだけです。これが最初のエラーが発生する理由でした。
