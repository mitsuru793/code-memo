window.onload = function() {
  var tableLength = 3;
  var startBtn = document.getElementById("startBtn");
  var gameArea = document.getElementById("gameArea");


  // テーブルを作成し、初期化
  gameArea.appendChild(createGameBoard(tableLength));
  init(tableLength);

  startBtn.onclick = function() {
    // 重複してテーブルが作られるのを防止
    if (document.getElementById("gameBoard") != null) {
      gameBoard.remove();
    }
    // テーブルを作成し、初期化
    tableLength = parseInt(document.getElementById("boardLength").value);
    if (tableLength > 10) {
      tableLength = 10
      document.getElementById("boardLength").value = 10;
    }
    gameArea.appendChild(createGameBoard(tableLength));
    init(tableLength);
  };

};

// 縦横、同じ長さのtableを作成
function createGameBoard(tableLength) {
  var table =document.createElement("table");
  table.setAttribute("id", "gameBoard");

  // tr,tdの作成・追加
  for (var y = 0; y < tableLength; y++) {
    var tr = document.createElement("tr");
    for (var x = 0; x < tableLength; x++) {
      var td = document.createElement("td");
      td.setAttribute("id", x+","+y)
      tr.appendChild(td);
    }
    table.appendChild(tr);
  }
  return table;
}

function init(tableLength) {
  // テーブルのマス目を取得
  var domSquare = new Array(tableLength);
  
  var valSquare = new Array(tableLength);
  for (var i = 0; i < tableLength; i++) {
    valSquare[i] = new Array(tableLength);
  }
  // マス目の判定のため、全要素の値が重複しないようにする。
  // これをしておかないと、空要素同士がイコールになってしまう。
  var num = 1;
  for (var y = 0; y < tableLength; y++) {
    for (var x = 0; x < tableLength; x++) {
      valSquare[x][y] = num++;
    }
  }
  
  // 現在のプレイヤーを保持
  var player = 1;
  // 何手目かを管理
  var count = 1;

  var tr = gameBoard.childNodes;
  for (var i = 0; i < tableLength; i++) {
    // trを除き、tdだけ格納
    domSquare[i] =  tr[i].childNodes;
  }

  // マス目のイベントの設定
  for (var y = 0; y < tableLength; y++) {
    for (var x = 0; x < tableLength; x++) {
      domSquare[x][y].onclick = function() {
        var position;
        // 入力済みの値を変更できないようにする
        if (this.innerText) {
          return;
        }
        console.log(count+"手目");
        count++;

        // プレイヤーによって入力値を判断し、交代
        if (player == 1) {
          this.innerText = "○";
          player = 2;
          mySquare = this.innerText;

        } else {
          this.innerText = "×";
          player = 1;
          mySquare = this.innerText;
        }
        // 入力値を座標で保存
        position = this.getAttribute("id")
        var posX = position.charAt(0);
        var posY = position.charAt(2);
        valSquare[posX][posY] = this.innerText;

        /***** 判定開始 *****/
        // 横が揃っているか判定
        var success = true;
        for (var i = 0; i < tableLength; i++) {
          if (valSquare[i][posY] != mySquare ) {
            success = false;
            break;
          }
        }
        //縦が揃っているか判定
        if (success == false) {
          success = true;
          for (var i = 0; i < tableLength; i++) {
            if (valSquare[posX][i] != mySquare ) {
              success = false;
              break;
            }
          }
        }
        //右下斜めが揃っているか判定
        if (success == false) {
          success = true;
          for (var i = 0; i < tableLength; i++) {
            if (valSquare[i][i] != mySquare ) {
              success = false;
              break;
            }
          }
        }
        //右上斜めが揃っているか判定
        if (success == false) {
          success = true;
          for (var i = 0; i < tableLength; i++) {
            if (valSquare[i][(tableLength - 1) - i] != mySquare ) {
              success = false;
              // break;
            }
          }
        }
        /***** 判定終了 *****/
        if (success) {
          alert("1列揃いました。");
        }
      }
    }
  }
}
