//
//  HighChartManager.swift
//  BIS
//
//  Created by TSSIT on 01/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation
import Highcharts

class HighChartManager {
    
    static let shared = HighChartManager()
    
    private init() { }
    
    static func getHighChart(with dataString: String) -> HIOptions? {
        
        let data = dataString.data(using: .utf8)!
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                print(json)     

                let chart = HIChart()
                if let chartJson = json["chart"] as? [String: Any] {
                    chart.animation = nil
                    chart.type = chartJson["type"] as? String
                    chart.zoomType = chartJson["zoomType"] as? String
                    chart.renderTo = chartJson["renderTo"] as? String
                    chart.inverted = chartJson["inverted"] as? NSNumber
                    chart.height = chartJson["height"] as? NSNumber
                    chart.parallelCoordinates = chartJson["parallelCoordinates"] as? NSNumber
                    if let parallelAxes = chartJson["parallelAxes"] as? [String: Any] {
                        chart.parallelAxes = HIParallelAxes()
                        chart.parallelAxes.min = parallelAxes["min"] as? NSNumber
                        chart.parallelAxes.tickAmount = parallelAxes["tickAmount"] as? NSNumber
                    }  
                }

                // Series
                var arrSeries = [HISeries]()
                if let seriesJSON = json["series"] as? [[String: Any]] {
                    arrSeries.append(contentsOf: seriesChart(seriesJSON: seriesJSON))
                }
                
                // Drilldown
                let drilldown = HIDrilldown()
                if let drilldownJSON = json["drilldown"] as? [String: Any] {
                    if let seriesJSON = drilldownJSON["series"] as? [[String: Any]] {
                        drilldown.series = seriesChart(seriesJSON: seriesJSON)
                    }
                    drilldown.drillUpButton = HIDrillUpButton()
                    drilldown.drillUpButton.position = HIAlignObject()
                    drilldown.drillUpButton.position.y = -10
                }
                
                // Title
                let title = HITitle()
                if let titleJson = json["title"] as? [String: Any] {
                    title.text = titleJson["text"] as? String ?? ""
                    title.align = titleJson["align"] as? String
                    title.margin = titleJson["margin"] as? NSNumber
                    title.verticalAlign = titleJson["verticalAlign"] as? String
                    title.y = titleJson["y"] as? NSNumber
                }
                
                // subtitle
                let subtitle = HISubtitle()
                if let subtitleJson = json["subtitle"] as? [String: Any] {
                    subtitle.text = subtitleJson["text"] as? String
                }

                // Credits
                let credits = HICredits()
                if let creditsJson = json["credits"] as? [String: Any] {
                    credits.enabled = creditsJson["enabled"] as? NSNumber
                }
                
                // tooltip
                let tooltip = HITooltip()
                if let tooltipJson = json["tooltip"] as? [String: Any] {
                    tooltip.pointFormat = tooltipJson["pointFormat"] as? String
                }
                
                // exporting
                let exporting = HIExporting()
                if let exportingJson = json["exporting"] as? [String: Any] {
                    exporting.enabled = exportingJson["enabled"] as? NSNumber
                }
                
                // plot options
                
                let plotOptions = HIPlotOptions()
                if let plotOptionsJson = json["plotOptions"] as? [String: Any] {
                    
                    //spline
                    if let splineJson = plotOptionsJson["spline"] as? [String: Any] {
                        splineChart(plotOptions: plotOptions, splineJson: splineJson)
                    }
                    
                    // Area
                    if let area = plotOptionsJson["area"] as? [String: Any] {
                        areaChart(plotOptions: plotOptions, areaJson: area)
                    }

                    // funnel
                    if let funnelJson = plotOptionsJson["funnel"] as? [String: Any] {
                        funnelChart(plotOptions: plotOptions, funnelJson: funnelJson)
                    }

                    // pie
                    if let pieJson = plotOptionsJson["pie"] as? [String: Any] {
                        pieChart(plotOptions: plotOptions, pieJson: pieJson)
                    }
                    
                    // bullet
                    if let bulletJson = plotOptionsJson["bullet"] as? [String: Any] {
                        bulletChart(plotOptions: plotOptions, bulletJson: bulletJson)
                    }
                }
                
                // legends
                let legend = HILegend()
                if let legendJson = json["legend"] as? [String: Any] {
                    legend.enabled = legendJson["enabled"] as? NSNumber
                }
                
                // xAxis
                let xAxis = HIXAxis()
                if let xAxisJson = json["xAxis"] as? [String: Any] {
                    xAxis.visible = xAxisJson["visible"] as? NSNumber
                    xAxis.type = xAxisJson["type"] as? String
                    xAxis.categories = xAxisJson["categories"] as? [String]
                    xAxis.gridLineWidth = xAxisJson["gridLineWidth"] as? NSNumber
                    
                    if let titleJson = xAxisJson["title"] as? [String: Any] {
                        xAxis.title = HITitle()
                        xAxis.title.text = titleJson["text"] as? String
                        xAxis.title.align = titleJson["align"] as? String
                        xAxis.title.margin = titleJson["margin"] as? NSNumber
                    }
                    
                    if let labelsJson = xAxisJson["labels"] as? [String: Any] {
                        let labels = HILabels()
                        labels.rotation = xAxisJson["rotation"] as? NSNumber
                        
                        if let styleJson = labelsJson["style"] as? [String: Any] {
                            labels.style = HICSSObject()
                            labels.style.fontSize = styleJson["fontSize"] as? String
                            labels.style.fontFamily = styleJson["fontFamily"] as? String
                        }
                        xAxis.labels = labels
                    }
                }
                
                // yAxis
                var yAxises = [HIYAxis]()
                if let yAxisData = json["yAxis"] as? [[String: Any]] {
                    
                    for yAxisJson in yAxisData {
                        let yAxis = HIYAxis()
                        yAxis.visible = yAxisJson["visible"] as? NSNumber
                        yAxis.min = yAxisJson["min"] as? NSNumber
                        yAxis.max = yAxisJson["max"] as? NSNumber
                        yAxis.gridLineWidth = yAxisJson["gridLineWidth"] as? NSNumber
                        yAxis.opposite = NSNumber.init(value: yAxisJson["opposite"] as? Bool ?? false) 
                        if let titleJson = yAxisJson["title"] as? [String: Any] {
                            yAxis.title = HITitle()
                            yAxis.title.text = titleJson["text"] as? String
                            yAxis.title.align = titleJson["align"] as? String
                            yAxis.title.margin = titleJson["margin"] as? NSNumber
                        }
                        yAxises.append(yAxis)
                    }
                    
                }
                
                if let plotBandsList = json["plotBands"] as? [[String: Any]] {
                    bandListChart(plotBandsList: plotBandsList, yAxis: yAxises.first ?? HIYAxis())
                }
                
                // navigation: used to hide hamburger button
                
                let navigation = HINavigation()
                navigation.buttonOptions = HIButtonOptions()
                navigation.buttonOptions.enabled = NSNumber.init(value: false)

                let options = HIOptions()
                options.xAxis = [xAxis]
                options.yAxis = yAxises
                options.chart = chart
                options.series = arrSeries
                options.title = title
                options.credits = credits
                options.tooltip = tooltip
                options.exporting = exporting
                options.legend = legend
                options.plotOptions = plotOptions
                options.navigation = navigation
                options.drilldown = drilldown
               
                return options
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }

}

func bandListChart(plotBandsList: [[String: Any]], yAxis: HIYAxis) {
    var plotBands = [HIPlotBands]()
    for plotBandJson in plotBandsList {
        let plotBand = HIPlotBands()
        plotBand.from = plotBandJson["from"] as? NSNumber
        plotBand.to = plotBandJson["to"] as? NSNumber
        plotBand.color = HIColor.init(name: plotBandJson["color"] as? String)
        //                        plotBand.color = HIColor.init(hexValue: "#bbb")
        plotBands.append(plotBand)
    }
    yAxis.plotBands = plotBands
}

func seriesChart(seriesJSON: [[String: Any]]) -> [HISeries] {
    var arrSeries = [HISeries]()
    for seriesData in seriesJSON {
        var series = HISeries()

        if (seriesData["type"] as? String) == "pie" {
            series = HIPie()
        }
        series.data = seriesData["data"] as? [Any]
        series.name = seriesData["name"] as? String
        series.type = seriesData["type"] as? String
        series.id = seriesData["id"] as? String
        series.yAxis = seriesData["yAxis"]
        series.enableMouseTracking = seriesData["enableMouseTracking"] as? NSNumber
        series.showInLegend = seriesData["showInLegend"] as? NSNumber
        series.animation = HIAnimationOptionsObject()
        if let animationJson = seriesData["animation"] as? [String: Any] {
            series.animation.duration = animationJson["duration"] as? NSNumber
        }

        series.color = HIColor.init(name: seriesData["color"] as? String)
        (series as? HIBar)?.pointWidth = seriesData["pointWidth"] as? NSNumber
        (series as? HIBar)?.borderWidth = seriesData["borderWidth"] as? NSNumber
        (series as? HIBar)?.grouping = seriesData["grouping"] as? NSNumber

        if let dataLabelsJson = seriesData["dataLabels"] as? [String: Any] {
            let dataLabels = HIDataLabels()
            dataLabels.className = dataLabelsJson["className"] as? String
            dataLabels.format = dataLabelsJson["format"] as? String
            dataLabels.enabled = dataLabelsJson["enabled"] as? NSNumber
            dataLabels.align = dataLabelsJson["align"] as? String
            dataLabels.inside = dataLabelsJson["inside"] as? NSNumber
            if let styleJson = dataLabelsJson["style"] as? [String: Any] {
                dataLabels.style = HIStyle()
                dataLabels.style.color = styleJson["color"] as? String
                dataLabels.style.textOutline = styleJson["color"] as? String
            }
            series.dataLabels = [dataLabels]
        }

        // marker
        if let markerJson = seriesData["marker"] as? [String: Any] {
            series.marker = HIMarker()
            series.marker.symbol = markerJson["symbol"] as? String
        }
        (series as? HIPie)?.innerSize = seriesData["innerSize"] as? String

        arrSeries.append(series)
    }
    return arrSeries
}

func splineChart(plotOptions: HIPlotOptions, splineJson: [String: Any]) {
    plotOptions.spline = HISpline()
    if let markerJson = splineJson["marker"] as? [String: Any] {
        plotOptions.spline.marker = HIMarker()
        plotOptions.spline.marker.radius = markerJson["radius"] as? NSNumber
        plotOptions.spline.marker.lineColor = markerJson["lineColor"] as? String
    }
}

func areaChart(plotOptions: HIPlotOptions, areaJson: [String: Any]) {
    plotOptions.area = HIArea()
    plotOptions.area.lineWidth = areaJson["lineWidth"] as? NSNumber
    if let fillColorJson = areaJson["fillColor"] as? [String: Any] {
        plotOptions.area.fillColor = HIColor.init(linearGradient: fillColorJson["linearGradient"] as? [AnyHashable: Any], stops: fillColorJson["stops"] as? [Any])
    }

    if let markerJson = areaJson["marker"] as? [String: Any] {
        plotOptions.area.marker = HIMarker()
        plotOptions.area.marker.radius = markerJson["radius"] as? NSNumber
    }

    if let statusJson = areaJson["status"] as? [String: Any] {
        plotOptions.area.states = HIStates()
        plotOptions.area.states.hover = HIHover()
        plotOptions.area.states.hover.lineWidth = (statusJson["hover"] as? [String: Any])?["lineWidth"] as? NSNumber
    }

    plotOptions.area.threshold = areaJson["threshold"] as? NSNumber
}

func funnelChart(plotOptions: HIPlotOptions, funnelJson: [String: Any]) {
    plotOptions.funnel = HIFunnel()
    plotOptions.funnel.center = funnelJson["center"] as? [Any]
    plotOptions.funnel.neckWidth = funnelJson["neckWidth"] as? String
    plotOptions.funnel.neckHeight = funnelJson["neckHeight"] as? String
    plotOptions.funnel.width = funnelJson["width"] as? String
    plotOptions.funnel.cursor = funnelJson["cursor"] as? String
}

func pieChart(plotOptions: HIPlotOptions, pieJson: [String: Any]) {
    plotOptions.pie = HIPie()
    if let dataLabelJson = pieJson["dataLabels"] as? [String: Any] {
        let dataLabel = HIDataLabels()
        dataLabel.enabled = dataLabelJson["enabled"] as? NSNumber
        dataLabel.distance = dataLabelJson["distance"] as? NSNumber
        dataLabel.format = dataLabelJson["format"] as? String
        dataLabel.crop = dataLabelJson["crop"] as? NSNumber
        if let styleJson = dataLabelJson["style"] as? [String: Any] {
            dataLabel.style = HIStyle()
            dataLabel.style.fontWeight = styleJson["fontWeight"] as? String
            dataLabel.style.color = styleJson["color"] as? String
        }

        plotOptions.pie.dataLabels = [dataLabel]
    }

    plotOptions.pie.startAngle = pieJson["startAngle"] as? NSNumber
    plotOptions.pie.endAngle = pieJson["endAngle"] as? NSNumber
    plotOptions.pie.size = pieJson["size"] as? String
    plotOptions.pie.center = pieJson["center"] as? [Any]
}

func bulletChart(plotOptions: HIPlotOptions, bulletJson: [String: Any]) {
    plotOptions.bullet = HIBullet()
    plotOptions.bullet.borderWidth = bulletJson["borderWidth"] as? NSNumber
    plotOptions.bullet.color = HIColor.init(name: bulletJson["color"] as? String)
    plotOptions.bullet.targetOptions = HITargetOptions()
    plotOptions.bullet.targetOptions.width = (bulletJson["targetOptions"] as? [String: Any])?["width"]

    if let dataLabelJson = bulletJson["dataLabels"] as? [String: Any] {
        let dataLabel = HIDataLabels()
        dataLabel.enabled = dataLabelJson["enabled"] as? NSNumber
        dataLabel.distance = dataLabelJson["distance"] as? NSNumber
        dataLabel.format = dataLabelJson["format"] as? String

        if let styleJson = dataLabelJson["style"] as? [String: Any] {
            dataLabel.style = HIStyle()
            dataLabel.style.fontWeight = styleJson["fontWeight"] as? String
            dataLabel.style.color = styleJson["color"] as? String
        }

        plotOptions.bullet.dataLabels = [dataLabel]
    }
}
