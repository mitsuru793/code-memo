$ = require("jquery")
require("chart.js")

$.getJSON("graph.json", (data) ->
  createGraph(data)
)

createGraph = (data) ->
  dataSet = {
    labels: data["tags"].map (tag) -> tag[0]
    datasets: [
      {
        label: "タグ別の記事数 合計:#{data["tags"].length}"
        strokeColor : "#dcdcdc"
        pointColor : "#dcdcdc"
        pointStrokeColor : "#ffffff"
        data: data["tags"].map (tag) -> tag[1]
      },
    ]
  }

  ctx = $("#chart").get(0).getContext("2d")
  new Chart(ctx, {
    # -- global options --
    animation: false
    responsive: true
    scaleShowLabels: false
    showTooltips: false
    type: 'bar'
    data: dataSet
  })
