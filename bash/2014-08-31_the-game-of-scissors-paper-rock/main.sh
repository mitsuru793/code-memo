#!/bin/sh
hand=('グー' 'チョキ' 'パー')
win=0
lose=0
draw=0

#勝負の回数を決める
echo '--------------------------------------------------'
echo 'ジャンケンを始めます。'
echo '何回勝負しますか？'
read playCount
echo -e "\n"

for ((i=1; i<=$playCount; i++))
do
  echo "${i}回戦"
  echo "最初はグー、ジャンケン…"
  echo -e "\n"

  #プレイヤーの手を決める
  echo "グー：g    チョキ：c    パー：p"
  read myHand
  case ${myHand} in
    'g' ) myHand=0 ;;
    'c' ) myHand=1 ;;
    'p' ) myHand=2 ;;
  esac
  echo -e "\n"

  #相手の手を決める
  opponentHand=`expr $RANDOM % 2`
  echo "相手の手：${hand[1]}"
  case `expr $myHand - $opponentHand` in
    -1 | 2 ) win=`expr $win + 1`
      echo 'アナタの勝ちです'
      ;;
    1 | -2 ) lose=`expr $lose + 1`
      echo 'アナタの負けです'
      ;;
    0 )  draw=`expr $draw + 1`
      echo '引き分けです'
      ;;
  esac
echo '--------------------------------------------------'
done

#成績の表示
echo '成績'
echo "勝ち：${win} 負け：${lose} 引き分け：${draw}"
