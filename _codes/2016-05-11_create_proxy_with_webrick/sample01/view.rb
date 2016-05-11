#!/usr/bin/env ruby

$SAFE=1
require 'cgi'

cgi = CGI.new

cgi.out("type"    => "text/html",
        "charset" => "UTF-8") {
  get = cgi['get']

  <<-EOF
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title></title>
</head>
<body>
 <p>
  this is test page<br>
  get = #{get}
 </p>
</body>
</html>
  EOF
}
