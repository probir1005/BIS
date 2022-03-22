//
//  DashboardChartJson.swift
//  BIS
//
//  Created by TSSIT on 03/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

// MARK: - Management charts:

// MARK: managementSplineChartJSON
let managementSplineChartJSON = """
{
    "chart": {
        "type": "spline"

    },
    "credits": {
        "enabled": 0
    },
    "exporting": {
        "enabled": 0
    },
    "title": {
        "text": ""
    },
    "xAxis": {
        "categories": ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    },
    "yAxis": [{
        "title": {
            "text": "Net Sales"
        },
        "labels": {
            "formatter": ""
        }
    }],
    "tooltip": {
        "crosshairs": 1,
        "shared": 1
    },
    "plotOptions": {
        "spline": {
            "marker": {
                "radius": 4,
                "lineColor": "#666666",
                "lineWidth": 1
            }
        }
    },
    "series": [{
        "name": "2019 Profit",
        "marker": {
            "symbol": "square"
        },
        "data": [97223648 , 115634024, 143409344, 230611760, 308016320, 311916704 , 274953536 , 241565568, 247182448, 192083504 , 100256896  , 86528680  ]

    }, {
        "name": "2018 Profit",
        "marker": {
            "symbol": "diamond"
        },
        "data": [85414856  , 114250152  , 134883008  , 217618320  , 275417216  , 332986400  , 273018880  , 243250480  , 246509536  , 171760192  , 87144528  , 85280592  ]
    }],
    "tableData": {
        "name": "Table",
        "headers": ["Months", "2019 Profit", "2018 Profit"],
        "rows": [
            ["Jan", 97223648, 85414856],
            ["Feb", 115634024, 114250152],
            ["Mar", 143409344, 134883008],
            ["Apr", 230611760, 217618320],
            ["May", 308016320, 275417216],
            ["Jun", 311916704, 332986400],
            ["Jul", 274953536, 273018880],
            ["Aug", 241565568, 246509536],
            ["Sep", 247182448, 246509536],
            ["Oct", 192083504, 171760192],
            ["Nov", 100256896, 87144528],
            ["Dec", 86528680, 85280592]
        ]
    }

}
"""

// MARK: managementColumnChartJSON
let managementColumnChartJSON = """
{
    "chart": {
        "type": "column"

    },
    "credits": {
        "enabled": 0
    },
    "exporting": {
        "enabled": 0
    },
    "title": {
        "text": ""
    },
    "xAxis": {
        "categories": ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
        ],
        "crosshair": 1
    },

    "yAxis": [{
        "title": {
            "text": "Net Sales"
        },
        "labels": {
            "formatter": ""
        },
        "min": 0
    }],
    "tooltip": {
        "shared": 1
    },
    "plotOptions": {
        "column": {
            "pointPadding": 0.2,
            "borderWidth": 0
        }
    },
    "series": [{
        "name": "P-V Net Sales",
        "marker": {
            "symbol": "P-V Net Sales"
        },
        "data": [19363762,24843486,32641764,45910028,59177064,60527852,49814076,16219251,2356395.5,15680954,11846105,10667611]

    }, {
        "name": "Budgeted",
        "marker": {
            "symbol": "Budgeted"
        },
        "data": [17187000,23972000,28773000,43531000,54774000,66235000,59763000,49895000,54529000,44315000,29516000,27554000]
    }],
    "tableData": {
        "name": "Table",
        "headers": ["Months", "P-V Net Sales", "Budgeted"],
        "rows": [
            ["Jan", 19363762, 17187000],
            ["Feb", 24843486, 23972000],
            ["Mar", 32641764, 28773000],
            ["Apr", 45910028, 43531000],
            ["May", 59177064, 54774000],
            ["Jun", 60527852, 66235000],
            ["Jul", 49814076, 59763000],
            ["Aug", 16219251, 49895000],
            ["Sep", 2356395.5, 54529000],
            ["Oct", 15680954, 44315000],
            ["Nov", 11846105, 29516000],
            ["Dec", 10667611, 27554000]
        ]
    }
}
"""

// MARK: managementFunnelChartJson
let managementFunnelChartJson = """
{
    "chart": {
        "type": "funnel"
    },
    "credits": {
        "enabled": 0
    },
    "exporting": {
        "enabled": 0
    },
    "title": {
        "text": ""
    },
    "plotOptions": {
        "funnel": {
            "dataLabels": {
                "enabled": 1,
                "format": "<b>{point.name}</b><br>({point.y:,.0f})",
                "softConnector": 1
            },
            "center": ["40%", "50%"],
            "neckWidth": "30%",
            "neckHeight": "25%",
            "width": "60%",
            "cursor": "pointer"
        }
    },
    "legend": {
        "enabled": 0
    },
    "tooltip": {
        "shared": 1
    },
    "series": [{
        "name": "Net Sales",
        "data": [
            ["*03 - *06", 552096130],
            ["W01", 561877700],
            ["P", 40511960],
            ["D-V", 874069060]
        ]
    }],
    "tableData": {
        "name": "Detail",
        "headers": ["Status", "Net Sales"],
        "rows": [
            ["*03 - *06", 552096130],
            ["W01", 561877700],
            ["P", 40511960],
            ["D-V", 874069060]
        ]
    }
}
"""

// MARK: managementPieChartJSON
let managementPieChartJSON = """

{
    "chart": {
        "type": "pie"
    },
    "title": {
        "text": ""
    },
    "tooltip": {
        "pointFormat": "{series.name}: <b>{point.percentage:.0f}%</b>"
    },
    "plotOptions": {
        "pie": {
            "allowPointSelect": 1,
            "cursor": "pointer",
            "dataLabels": {
                "enabled": 1,
                "format": "<b>{point.name}</b>: {point.percentage:.0f} %"
            }
        }
    },
    "credits": {
        "enabled": 0
    },
    "exporting": {
        "enabled": 0
    },
    "series": [{
        "name": "Market",
        "colorByPoint": 1,
        "data": [{
            "name": "AMERICAS",
            "y": 2.81
        }, {
            "name": "ASIA PACIFIC",
            "y": 39.40
        }, {
            "name": "CHINA & HONG KONG",
            "y": 20.09
        }, {
            "name": "EUROPE",
            "y": 3.70
        }, {
            "name": "JAPAN",
            "y": 34.00
        }, {
            "name": "MICE",
            "y": 0.00
        }]
    }]
}
"""

// MARK: managementAreaChartJson
let managementAreaChartJson = """
{
    "chart": {
        "zoomType": "x"

    },
    "credits": {
        "enabled": 0
    },
    "exporting": {
        "enabled": 0
    },
    "title": {
        "text": null
    },
    "subtitle": {
        "text": null
    },
    "xAxis": {
        "type": "datetime",
        "title": {
            "text": "Time"
        }
    },
    "yAxis": [{
        "min": 0,
        "title": {
            "text": "Turnover"
        }
    }],
    "legend": {
        "enabled": 0
    },
    "plotOptions": {
        "area": {
            "fillColor": {
                "linearGradient": {
                    "x1": 0,
                    "y1": 0,
                    "x2": 0,
                    "y2": 1
                },
                "stops": [
                   [0, "#3DACF7"],
                   [1, "#3DACF700"]
                ]
            },
            "marker": {
                "radius": 2
            },
            "lineWidth": 1,
            "states": {
                "hover": {
                    "lineWidth": 1
                }
            }
        }
    },

    "series": [{
        "type": "area",
        "name": "Turnover",
        "data": [
            ["Date.UTC(2018,0,1)",85414852.094],
            ["Date.UTC(2018,1,1)",114250154.838],
            ["Date.UTC(2018,2,1)",134883015.938],
            ["Date.UTC(2018,3,1)",217618320.336],
            ["Date.UTC(2018,4,1)",275417225.924],
            ["Date.UTC(2018,5,1)",332986414.650],
            ["Date.UTC(2018,6,1)",273018874.135],
            ["Date.UTC(2018,7,1)",243250480.207],
            ["Date.UTC(2018,8,1)",246509531.923],
            ["Date.UTC(2018,9,1)",171760193.623],
            ["Date.UTC(2018,10,1)",87144525.956],
            ["Date.UTC(2018,11,1)",85280590.151],
            ["Date.UTC(2019,0,1)",97223649.510],
            ["Date.UTC(2019,1,1)",115634023.700],
            ["Date.UTC(2019,2,1)",143409350.790],
            ["Date.UTC(2019,3,1)",230611760.040],
            ["Date.UTC(2019,4,1)",308016305.430],
            ["Date.UTC(2019,5,1)",311916706.830],
            ["Date.UTC(2019,6,1)",274953542.400],
            ["Date.UTC(2019,7,1)",241565562.210],
            ["Date.UTC(2019,8,1)",247182444.860],
            ["Date.UTC(2019,9,1)",192083497.780],
            ["Date.UTC(2019,10,1)",100256898.450],
            ["Date.UTC(2019,11,1)",86528679.810]
        ]
    }],
    "tableData": {
        "name": "Detail",
        "headers": ["Time", "Turnover"],
        "rows": [
            ["Jan '18", 85414852.094],
            ["Feb '18", 114250154.838],
            ["Mar '18", 134883015.938],
            ["Apr '18", 217618320.336],
            ["May '18", 275417225.924],
            ["Jun '18", 332986414.650],
            ["Jul '18", 273018874.135],
            ["Aug '18", 243250480.207],
            ["Sep '18", 246509531.923],
            ["Oct '18", 171760193.623],
            ["Nov '18", 87144525.956],
            ["Dec '18", 85280590.151],
            ["Jan '19", 97223649.510],
            ["Feb '19", 115634023.700],
            ["Mar '19", 143409350.790],
            ["Apr '19", 230611760.040],
            ["May '19", 308016305.430],
            ["Jun '19", 311916706.830],
            ["Jul '19", 274953542.400],
            ["Aug '19", 241565562.210],
            ["Sep '19", 247182444.860],
            ["Oct '19", 192083497.780],
            ["Nov '19", 100256898.450],
            ["Dec '19", 86528679.810]
        ]
    }

}
"""

// MARK: managementPerformanceChart
let managementPerformanceChart = """
{
    "chart": {
        "plotBackgroundColor": null,
        "plotBorderWidth": 0,
        "plotShadow": 0
    },
    "title": {
        "text": "Performance <br>2019",
        "align": "center",
        "verticalAlign": "middle",
        "y": 20
    },
    "tooltip": {
        "pointFormat": "{series.name}: <b>{point.percentage:.1f}%</b>"
    },
    "plotOptions": {
        "pie": {
            "dataLabels": {
                "enabled": 1,
                "distance": -25,
                "crop": 0,
                "style": {
                    "fontWeight": "bold",
                    "color": "white"
                }
            },

            "startAngle": -90,
            "endAngle": 90,
            "center": ["50%", "60%"],
            "size": "110%"
        }
    },
    "credits": {
        "enabled": 0
    },
    "exporting": {
        "enabled": 0
    },
    "series": [{
        "type": "pie",
        "name": "",
        "innerSize": "60%",
        "data": [
            ["Bad", 13],
            ["Good", 13.29],
            ["Excellent", 58.9]
        ]
    }]
}
"""

// MARK: - Sales charts:

let salesBulletChartJson1 = """
{
    "chart": {
        "inverted": 1,
        "marginLeft": 135,
        "type": "bullet",
        "height": 100
    },
    "title": {
        "text": null
    },
    "legend": {
        "enabled": 0
    },
    "xAxis": {
        "visible": 0,
        "title": {
            "text": ""
        }
    },
    "yAxis": [{
        "gridLineWidth": 0,
        "max": 550000000
    }],
    "plotOptions": {
        "bullet": {
            "pointPadding": 0.25,
            "borderWidth": 0,
            "color": "DarkSlateGrey",
            "targetOptions": {
                "width": "200%"
            }
        }
    },
    "plotBands": [{
            "from": 0,
            "to": 210000000,
            "color": "SteelBlue"
        },
        {
            "from": 210000000,
            "to": 600000000,
            "color": "lightskyblue"
    }],
    "credits": {
        "enabled": 0
    },
    "exporting": {
        "enabled": 0
    },
    "series": [
        {
            "type": "bullet",
            "data": [{
                "y": 40000000,
                "target": 530000000
            }],
            "targetOptions": {
                "width": "140%",
                "height": 3,
                "borderWidth": 0,
                "borderColor": "black",
                "color": "black"
            }
        }
    ]
}
"""

let salesBulletChartJson2 = """
{
    "chart": {
        "inverted": 1,
        "marginLeft": 135,
        "type": "bullet",
        "height": 100
    },
    "title": {
        "text": null
    },
    "legend": {
        "enabled": 0
    },
    "xAxis": {
        "visible": 0,
        "title": {
            "text": ""
        }
    },
    "yAxis": [{
        "gridLineWidth": 0,
        "max": 75000000
    }],
    "plotOptions": {
        "bullet": {
            "pointPadding": 0.25,
            "borderWidth": 0,
            "color": "DarkSlateGrey",
            "targetOptions": {
                "width": "200%"
            }
        }
    },
    "plotBands": [{
            "from": 0,
            "to": 75000000,
            "color": "lightskyblue"
    }],
    "credits": {
        "enabled": 0
    },
    "exporting": {
        "enabled": 0
    },
    "series": [
        {
            "type": "bullet",
            "data": [{
                "y": 6000000,
                "target": 68000000
            }],
            "targetOptions": {
                "width": "200%",
                "height": 3,
                "borderWidth": 0,
                "borderColor": "black",
                "color": "black"
            }
        }
    ]
}
"""

// MARK: salesColumnChartJSON
let salesColumnChartJSON = """
{
    "chart": {
        "type": "column"

    },
    "credits": {
        "enabled": 0
    },
    "exporting": {
        "enabled": 0
    },
    "title": {
        "text": ""
    },
    "xAxis": {
        "categories": ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
        "crosshair": 1
    },

    "yAxis": [{
        "title": {
            "text": "Net Sales"
        },
        "labels": {
            "formatter": ""
        },
        "min": 0
    }],
    "tooltip": {
        "shared": 1
    },
    "plotOptions": {
        "column": {
            "pointPadding": 0.2,
            "borderWidth": 0
        }
    },
    "series": [{
        "name": "P-V Net Sales",
        "marker": {
            "symbol": "P-V Net Sales"
        },
        "data":
            [20422,
            16027,
            4390,
            214,
            3,
            0,
            0,
            3,
            0,
            9,
            0,
            0]
    }, {
        "name": "Budgeted",
        "marker": {
            "symbol": "Budgeted"
        },
        "data":
            [21052,
            19461,
            30949,
            46283,
            62806,
            62769,
            59517,
            50831,
            56918,
            47093,
            32680,
            30255]
    }],
    "tableData": {
        "name": "Table",
        "headers": ["Months", "P-V Net Sales", "Budgeted"],
        "rows": [
            ["Jan", 20422, 21052],
            ["Feb", 16027, 19461],
            ["Mar", 4390, 30949],
            ["Apr", 214, 46283],
            ["May", 3, 62806],
            ["Jun", 0, 62769],
            ["Jul", 0, 59517],
            ["Aug", 3, 50831],
            ["Sep", 0, 56918],
            ["Oct", 9, 47093],
            ["Nov", 0, 32680],
            ["Dec", 0, 30255]
        ]
    }
}
"""

// MARK: salesSplineChartJSON
let salesSplineChartJSON = """
{
    "chart": {
        "type": "spline"

    },
    "credits": {
        "enabled": 0
    },
    "exporting": {
        "enabled": 0
    },
    "title": {
        "text": ""
    },
    "xAxis": {
        "categories": ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    },
    "yAxis": [{
        "title": {
            "text": "Net Sales"
        },
        "labels": {
            "formatter": ""
        }
    }],
    "tooltip": {
        "crosshairs": 1,
        "shared": 1
    },
    "plotOptions": {
        "spline": {
            "marker": {
                "radius": 4,
                "lineColor": "#666666",
                "lineWidth": 1
            }
        }
    },
    "series": [{
        "name": "2020 Pipeline Net Sales",
        "marker": {
            "symbol": "square"
        },
        "data":  [34989,
            32638,
            26664,
            44853,
            62311,
            80687,
            73657,
            58381,
            67624,
            45255,
            15762,
            29438]
    }, {
        "name": "2019 Pipeline Net Sales",
        "marker": {
            "symbol": "diamond"
        },
        "data": [33098,
            40917,
            50032,
            101816,
            148495,
            138839,
            105326,
            87730,
            69043,
            46192,
            9775,
            4688]
    }, {
        "name": "2019 Finalized",
        "marker": {
            "symbol": "circle"
        },
        "data": [19741,
            24554,
            33499,
            46965,
            60751,
            62397,
            58017,
            46427,
            52021,
            47369,
            30596,
            26537]
    }],
    "tableData": {
        "name": "Table",
        "headers": ["Months", "2020 Pipeline Net Sales", "2019 Pipeline Net Sales", "2019 Finalized"],
        "rows": [
            ["Jan", 34989, 33098, 19741],
            ["Feb", 32638, 40917, 24554],
            ["Mar", 26664, 50032, 33499],
            ["Apr", 44853, 101816, 46965],
            ["May", 62311, 148495, 60751],
            ["Jun", 80687, 138839, 62397],
            ["Jul", 73657, 105326, 58017],
            ["Aug", 58381, 87730, 46427],
            ["Sep", 67624, 69043, 52021],
            ["Oct", 45255, 46192, 47369],
            ["Nov", 15762, 9775, 30596],
            ["Dec", 29438, 4688, 26537]
        ]
    }
}
"""

// MARK: saleAllChartsJson
let saleAllChartsJson = """
{

    "title": {
        "text": ""
    },
    "chart": {},
    "credits": {
        "enabled": 0
    },
    "exporting": {
        "enabled": 0
    },
    "yAxis": [{
        "min": 0,
        "title": {
            "text": "Net Sales"
        }
    }],
    "xAxis": {
        "categories": ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
        ]
    },
    "labels": {
        "items": [{
            "html": "",
            "style": {
                "left": "50px",
                "top": "18px"
            }
        }]
    },
    "tooltip": {
        "shared": 1
    },
    "series": [{
        "type": "column",
        "name": "Pipeline Net Sales",
        "data": [34989,
            32638,
            26664,
            44853,
            62311,
            80687,
            73657,
            58381,
            67624,
            45255,
            15762,
            29438]
    }, {
        "type": "spline",
        "name": "Predictive P-V Net Sales",
        "data": [20706,
        16071,
        4008,
        127,
        4055,
        28912,
        31232,
        24012,
        30663,
        18208,
        1874,
        1263]

    }, {
        "type": "spline",
        "name": "Predictive Pipeline",
        "data": [22287,
        20498,
        16582,
        24303,
        33455,
        52324,
        52281,
        42912,
        68306,
        61416,
        71357,
        506045]
    }],
    "tableData": {
        "name": "Table",
        "headers": ["Months", "Pipeline Net Sales", "Predictive P-V Net Sales", "Predictive Pipeline"],
        "rows": [
            ["Jan", 34989, 20706, 22287],
            ["Feb", 32638, 16071, 20498],
            ["Mar", 26664, 4008, 16582],
            ["Apr", 44853, 127, 24303],
            ["May", 62311, 4055, 33455],
            ["Jun", 80687, 28912, 52324],
            ["Jul", 73657, 31232, 52281],
            ["Aug", 58381, 24012, 42912],
            ["Sep", 67624, 30663, 68306],
            ["Oct", 45255, 18208, 61416],
            ["Nov", 15762, 1874, 71357],
            ["Dec", 29438, 1263, 506045]
        ]
    }
}
"""

// MARK: - Sales Pipeline
// MARK: operationFunnel1
let operationFunnel1 = """
{
    "chart": {
        "type": "funnel"
    },
    "credits": {
        "enabled": 0
    },
    "exporting": {
        "enabled": 0
    },
    "title": {
        "text": ""
    },
    "plotOptions": {
        "funnel": {
            "dataLabels": {
                "enabled": 1,
                "format": "<b>{point.name}</b><br>({point.y:,.0f})"
            },
            "center": ["40%", "50%"],
            "neckWidth": "30%",
            "neckHeight": "25%",
            "width": "60%",
            "cursor": "pointer"
        }
    },
    "legend": {
        "enabled": 0
    },
    "tooltip": {
        "shared": 1
    },
    "series": [{
        "name": "Net Sales",
        "data": [
            ["*03 - *06", 445904],
            ["W01", 48856],
            ["P", 137803],
            ["D-V", 203387]
        ]
    }],

    "tableData": {
        "name": "Detail",
        "headers": ["Status", "Net Sales"],
        "rows": [
            ["*03 - *06", 445904],
            ["W01", 48856],
            ["P", 137803],
            ["D-V", 203387]
        ]
    }
}
"""

// MARK: operationFunnel2
let operationFunnel2 = """
{
    "chart": {
        "type": "funnel"
    },
    "credits": {
        "enabled": 0
    },
    "exporting": {
        "enabled": 0
    },
    "title": {
        "text": ""
    },
    "plotOptions": {
        "funnel": {
            "dataLabels": {
                "enabled": 1,
                "format": "<b>{point.name}</b><br>({point.y:,.0f})",
                "softConnector": 1
            },
            "center": ["40%", "50%"],
            "neckWidth": "30%",
            "neckHeight": "25%",
            "width": "60%",
            "cursor": "pointer"
        }
    },
    "legend": {
        "enabled": 0
    },
    "tooltip": {
        "shared": 1
    },
    "series": [{
        "name": "Net Sales",
        "data": [
            ["*03 - *06", 368926],
            ["W01", 46418],
            ["P", 79690],
            ["D-V", 77223]
        ]
    }],

    "tableData": {
        "name": "Detail",
        "headers": ["Status", "Net Sales"],
        "rows": [
            ["None", 263694],
            ["*03 - *06", 368926],
            ["W01", 46418],
            ["P", 79690],
            ["D-V", 77223]
        ]
    }
}
"""

// MARK: operationSplineChartJSON
let operationSplineChartJSON = """
{
    "chart": {
        "type": "spline"

    },
    "credits": {
        "enabled": 0
    },
    "exporting": {
        "enabled": 0
    },
    "title": {
        "text": ""
    },
    "xAxis": {
        "categories": ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    },
    "yAxis": [{
        "title": {
            "text": "Net Sales"
        },
        "labels": {
            "formatter": ""
        }
    }],
    "tooltip": {
        "crosshairs": 1,
        "shared": 1
    },
    "plotOptions": {
        "spline": {
            "marker": {
                "radius": 4,
                "lineColor": "#666666",
                "lineWidth": 1
            }
        }
    },
    "series": [{
        "name": "2020 Pipeline Net Sales",
        "marker": {
            "symbol": "square"
        },
        "data":  [34989,
            32638,
            26664,
            44853,
            62311,
            80687,
            73657,
            58381,
            67624,
            45255,
            15762,
            29438]
    }, {
        "name": "2019 Pipeline Net Sales",
        "marker": {
            "symbol": "diamond"
        },
        "data": [33098,
            40917,
            50032,
            101816,
            148495,
            138839,
            105326,
            87730,
            69043,
            46192,
            9775,
            4688]
    }, {
        "name": "2019 Finalized",
        "marker": {
            "symbol": "circle"
        },
        "data": [19741,
            24554,
            33499,
            46965,
            60751,
            62397,
            58017,
            46427,
            52021,
            47369,
            30596,
            26537]
    }],
    "tableData": {
        "name": "2019",
        "headers": ["Months", "2020 Pipeline Net Sales", "2019 Pipeline Net Sales", "2019 Finalized"],
        "rows": [
            ["Jan", 34989, 33098, 19741],
            ["Feb", 32638, 40917, 24554],
            ["Mar", 26664, 50032, 33499],
            ["Apr", 44853, 101816, 46965],
            ["May", 62311, 148495, 60751],
            ["Jun", 80687, 138839, 62397],
            ["Jul", 73657, 105326, 58017],
            ["Aug", 58381, 87730, 46427],
            ["Sep", 67624, 69043, 52021],
            ["Oct", 45255, 46192, 47369],
            ["Nov", 15762, 9775, 30596],
            ["Dec", 29438, 4688, 26537]
        ]
    }
}
"""

// MARK: operationSplineChartJSON
let operationSplineChartJSON2 = """
{
    "chart": {
        "type": "spline"

    },
    "credits": {
        "enabled": 0
    },
    "exporting": {
        "enabled": 0
    },
    "title": {
        "text": ""
    },
    "xAxis": {
        "categories": ["W 4", "W 6", "W 7", "W 8", "W 9", "W 10", "W 11", "W 12", "W 13", "W 14"]
    },
    "yAxis": [{
        "title": {
            "text": "Net Sales"
        },
        "labels": {
            "formatter": ""
        }
    }, {
        "title": {
            "text": "% Changes",
            "align": "right"
        },
        "labels": {
            "formatter": ""
        },
        "opposite": true
    }],
    "tooltip": {
        "crosshairs": 1,
        "shared": 1
    },
    "plotOptions": {
        "spline": {
            "marker": {
                "radius": 4,
                "lineColor": "#666666",
                "lineWidth": 1
            }
        }
    },
    "series": [{
        "name": "Net Sales 2020",
        "marker": {
            "symbol": "square"
        },
        "data":  [730796,
            744521,
            751232,
            758188,
            759026,
            743079,
            727605,
            717454,
            609385,
            572257]
    }, {
        "name": "Net Sales 2019",
        "marker": {
            "symbol": "diamond"
        },
        "data": [511603,
            576329,
            590158,
            618828,
            638588,
            661773,
            681546,
            782662,
            807090,
            835951]
    }, {
        "name": "% Change",
        "marker": {
            "symbol": "circle"
        },
        "yAxis": 1,
        "data": [42.84,
        29.18,
        27.29,
        22.52,
        18.86,
        12.29,
        6.76,
        -8.33,
        -24.5,
        -31.54]
    }],

    "tableData": {
        "name": "Table",
        "headers": ["Week", "% Change", "Net Sales 2019", "Net Sales 2020"],
        "rows": [
            ["W 4", 42.84, 511603, 730796],
            ["W 6", 29.18, 576329, 744521],
            ["W 7", 27.29, 590158, 751232],
            ["W 8", 22.52, 618828, 758188],
            ["W 9", 18.86, 638588, 759026],
            ["W 10", 12.29, 661773, 743079],
            ["W 11", 6.76, 681546, 727605],
            ["W 12", -8.33, 782662, 717454],
            ["W 13", -24.5, 807090, 609385],
            ["W 14", -31.54, 835951, 572257]
        ]
    }
}
"""

// MARK: operationColumnChartJSON
let operationColumnChartJSON = """
{
    "chart": {
        "type": "column"

    },
    "credits": {
        "enabled": 0
    },
    "exporting": {
        "enabled": 0
    },
    "title": {
        "text": ""
    },
    "xAxis": {
        "categories": ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
        ],
        "crosshair": 1
    },

    "yAxis": [{
        "title": {
            "text": "Net Sales"
        },
        "labels": {
            "formatter": ""
        },
        "min": 0
    }],
    "tooltip": {
        "shared": 1
    },
    "plotOptions": {
        "column": {
            "pointPadding": 0.2,
            "borderWidth": 0
        }
    },
    "series": [{
        "name": "P-V Net Sales",
        "marker": {
            "symbol": "P-V Net Sales"
        },
        "data":
            [20533,
            16058,
            3937,
            120,
            3421,
            27615,
            27479,
            21794,
            21938,
            12090,
            1229,
            699]
    }, {
        "name": "Budgeted",
        "marker": {
            "symbol": "Budgeted"
        },
        "data":
            [21052,
            19461,
            30949,
            46283,
            62806,
            62769,
            59517,
            50831,
            56918,
            47093,
            32680,
            30255]
    }],

    "tableData": {
        "name": "2019",
        "headers": ["Months", "Net Sales", "Budgeted"],
        "rows": [
            ["Jan", 20533, 21052],
            ["Feb", 16058, 19461],
            ["Mar", 3937, 30949],
            ["Apr", 120, 46283],
            ["May", 3421, 62806],
            ["Jun", 27615, 62769],
            ["Jul", 27479, 59517],
            ["Aug", 21794, 50831],
            ["Sep", 21938, 56918],
            ["Oct", 12090, 47093],
            ["Nov", 1229, 32680],
            ["Dec", 699, 30255]
        ]
    }
}
"""

// MARK: operationAllChartsJson
let operationAllChartsJson = """
{

    "title": {
        "text": ""
    },
    "chart": {},
    "credits": {
        "enabled": 0
    },
    "exporting": {
        "enabled": 0
    },
    "yAxis": [{
        "min": 0,
        "title": {
            "text": "Net Sales"
        }
    }],
    "xAxis": {
        "categories": ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
        ]
    },
    "labels": {
        "items": [{
            "html": "",
            "style": {
                "left": "50px",
                "top": "18px"
            }
        }]
    },
    "tooltip": {
        "shared": 1
    },
    "series": [{
        "type": "column",
        "name": "Pipeline Net Sales",
        "data": [34989,
            32638,
            26664,
            44853,
            62311,
            80687,
            73657,
            58381,
            67624,
            45255,
            15762,
            29438]
    }, {
        "type": "spline",
        "name": "Predictive P-V Net Sales",
        "data": [20740,
            16157,
            4008,
            127,
            4055,
            28912,
            31232,
            24012,
            30663,
            18208,
            1874,
            1263]
    }, {
        "type": "spline",
        "name": "Predictive Pipeline",
        "data": [22287,
            20498,
            16582,
            24303,
            33455,
            52324,
            52281,
            42912,
            68306,
            61416,
            71357,
            506045]
    }],

    "tableData": {
        "name": "Table",
        "headers": ["Months", "Pipeline Net Sales", "Predictive P-V Net Sales", "Predictive Pipeline"],
        "rows": [
            ["Jan", 34989, 20740, 22287],
            ["Feb", 32638, 16157, 20498],
            ["Mar", 26664, 4008, 16582],
            ["Apr", 44853, 127, 24303],
            ["May", 62311, 4055, 33455],
            ["Jun", 80687, 28912, 52324],
            ["Jul", 73657, 31232, 52281],
            ["Aug", 58381, 24012, 42912],
            ["Sep", 67624, 30663, 68306],
            ["Oct", 45255, 18208, 61416],
            ["Nov", 15762, 1874, 71357],
            ["Dec", 29438, 1263, 506045]
        ]
    }
}
"""

let lineChartJSON = """
{
    "chart": {
        "type": "line",
        "parallelCoordinates": 1,
        "parallelAxes": {
            "tickAmount": 2,
            "min": 0
        }
    },
    "title": {
        "text": ""
    },

    "plotOptions": {
        "series": {
            "lineWidth": 1,
            "marker": {
                "enabled": 0
            }
        }
    },
    "xAxis": {
        "categories": ["Mpg", "Cylinders", "Displacement", "HP", "Lbs", "Acceleration", "Year", "Origin"],
        "gridLineWidth": 0
    },
    "series": [{
        "name": "chevrolet chevelle malibu",
        "data": [25, 8, 400, 130, 504, 12, 70, 1]
    }, {
        "name": "buick skylark 320",
        "data": [15, 8, 500, 165, 693, 11.5, 70, 1]
    }, {
        "name": "plymouth satellite",
        "data": [20, 8, 350, 150, 436, 11, 70, 1]
    }, {
        "name": "amc rebel sst",
        "data": [10, 8, 250, 150, 433, 12, 70, 1]
    }]
}
"""

let columnChartJSON = """
{
    "chart": {
        "type": "column"

    },
    "credits": {
        "enabled": 0
    },
    "exporting": {
        "enabled": 0
    },
    "title": {
        "text": ""
    },
    "xAxis": {
        "categories": ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
        ],
        "crosshair": 1
    },

    "yAxis": [{
        "title": {
            "text": "Net Sales"
        },
        "labels": {
            "formatter": ""
        },
        "min": 0
    }],
    "tooltip": {
        "shared": 1
    },
    "plotOptions": {
        "column": {
            "pointPadding": 0.2,
            "borderWidth": 0
        }
    },
    "series": [{
        "name": "2019 Profit",
        "marker": {
            "symbol": "square"
        },
        "data": [97223648, 115634024, 143409344, 230611760, 308016320, 311916704, 274953536, 241565568, 247182448, 192083504, 100256896, 86528680]

    }, {
        "name": "2018 Profit",
        "marker": {
            "symbol": "diamond"
        },
        "data": [85414856, 114250152, 134883008, 217618320, 275417216, 332986400, 273018880, 243250480, 246509536, 171760192, 87144528, 85280592]
    }]
}
"""

let funnelChartJson = """
{
    "chart": {
        "type": "funnel"
    },
    "credits": {
        "enabled": 0
    },
    "exporting": {
        "enabled": 0
    },
    "title": {
        "text": ""
    },
    "plotOptions": {
        "funnel": {
            "dataLabels": {
                "enabled": 1,
                "format": "<b>{point.name}</b><br>({point.y:,.0f})",
                "softConnector": 1
            },
            "center": ["40%", "50%"],
            "neckWidth": "30%",
            "neckHeight": "25%",
            "width": "60%",
            "cursor": "pointer"
        }
    },
    "legend": {
        "enabled": 0
    },
    "tooltip": {
        "shared": 1
    },
    "series": [{
        "name": "Net Sales",
        "data": [
            ["*03 - *06", 552096130],
            ["W01", 561877700],
            ["P", 40511960],
            ["D-V", 874069060]
        ]
    }]
}
"""

let areaChartJson = """
{
    "chart": {
        "zoomType": "x"

    },
    "credits": {
        "enabled": 0
    },
    "exporting": {
        "enabled": 0
    },
    "title": {
        "text": null
    },
    "subtitle": {
        "text": null
    },
    "xAxis": {
        "type": "datetime",
        "title": {
            "text": "Time"
        }
    },
    "yAxis": [{
        "min": 0,
        "title": {
            "text": "Turnover"
        }
    }],
    "legend": {
        "enabled": 0
    },
    "plotOptions": {
        "area": {
            "fillColor": {
                "linearGradient": {
                    "x1": 0,
                    "y1": 0,
                    "x2": 0,
                    "y2": 1
                },
                "stops": [
                   [0, "#3DACF7"],
                   [1, "#3DACF700"]
                ]
            },
            "marker": {
                "radius": 2
            },
            "lineWidth": 1,
            "states": {
                "hover": {
                    "lineWidth": 1
                }
            },
            "threshold": null
        }
    },

    "series": [{
        "type": "area",
        "name": "Turnover",
        "data": [
            ["Date.UTC(2018,0,1)",85414852.094],
            ["Date.UTC(2018,1,1)",114250154.838],
            ["Date.UTC(2018,2,1)",134883015.938],
            ["Date.UTC(2018,3,1)",217618320.336],
            ["Date.UTC(2018,4,1)",275417225.924],
            ["Date.UTC(2018,5,1)",332986414.650],
            ["Date.UTC(2018,6,1)",273018874.135],
            ["Date.UTC(2018,7,1)",243250480.207],
            ["Date.UTC(2018,8,1)",246509531.923],
            ["Date.UTC(2018,9,1)",171760193.623],
            ["Date.UTC(2018,10,1)",87144525.956],
            ["Date.UTC(2018,11,1)",85280590.151],
            ["Date.UTC(2019,0,1)",97223649.510],
            ["Date.UTC(2019,1,1)",115634023.700],
            ["Date.UTC(2019,2,1)",143409350.790],
            ["Date.UTC(2019,3,1)",230611760.040],
            ["Date.UTC(2019,4,1)",308016305.430],
            ["Date.UTC(2019,5,1)",311916706.830],
            ["Date.UTC(2019,6,1)",274953542.400],
            ["Date.UTC(2019,7,1)",241565562.210],
            ["Date.UTC(2019,8,1)",247182444.860],
            ["Date.UTC(2019,9,1)",192083497.780],
            ["Date.UTC(2019,10,1)",100256898.450],
            ["Date.UTC(2019,11,1)",86528679.810]
        ]
    }]
}
"""

//"[0, Highcharts.getOptions().colors[0]]",
//                   "[1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]"

let bulletChartJson = """
{
    "chart": {
        "inverted": 1,
        "marginLeft": 135,
        "type": "bullet"
    },
    "title": {
        "text": null
    },
    "legend": {
        "enabled": 0
    },
    "yAxis": [{
        "gridLineWidth": 0
    }],
    "plotOptions": {
        "series": {
            "pointPadding": 0.25,
            "borderWidth": 0,
            "color": "#3DACF7",
            "targetOptions": {
                "width": "200%"
            }
        }
    },
    "credits": {
        "enabled": 0
    },
    "exporting": {
        "enabled": 0
    },
    "series": [
        {
            "type": "bullet",
            "data": [{
                "y": 275,
                "target": 250
            }],
            "targetOptions": {
                "width": "140%",
                "height": 3,
                "borderWidth": 0,
                "borderColor": "black",
                "color": "black"
            }
        }
    ]
}
"""
