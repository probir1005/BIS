//
//  SalesPICReportJson.swift
//  BIS
//
//  Created by TSSIT on 23/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

let salesPICReportChart1 = """
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
        "name": "Turnover",
        "marker": {
            "symbol": "P-V Net Sales"
        },
        "data": [20442,
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
        "data": [21052,
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
      "headers": ["Months", "Turnover", "Budgeted"],
      "rows": [
        ["Jan", 20442, 21052],
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

let salesPICReportChart2 = """
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
        "name": "AR-TOver%",
        "marker": {
            "symbol": "P-V Net Sales"
        },
        "data": [97,
            82,
            14,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0]

    }, {
        "name": "AR-Profit%",
        "marker": {
            "symbol": "Budgeted"
        },
        "data": [88,
            107,
            36,
            2,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0]
    }],

    "tableData": {
           "name": "Table",
           "headers": ["Months", "AR-Tover%", "AR-Profit%"],
           "rows": [
             ["Jan", 97, 88],
             ["Feb", 82, 107],
             ["Mar", 14, 36],
             ["Apr", 0, 2],
             ["May", 0, 0],
             ["Jun", 0, 0],
             ["Jul", 0, 0],
             ["Aug", 0, 0],
             ["Sep", 0, 0],
             ["Oct", 0, 0],
             ["Nov", 0, 0],
             ["Dec", 0, 0]
           ]
         }
}
"""

let salesPICReportTable1 = """
{
"tableData": 
{
    "name": "2019",
    "headers": ["Month", "Bud-TOver", "Bud-Profit", "Bud-Profit%", "Act-TOver", "Act-Profit", "Act-Profit%", "AR-TOver%", "AR-Profit%", "AR-Profit Bal"],
    "rows": [
        ["Jan", 21052, 2487, 12, 20442, 2197, 11, 97, 88, -290],
        ["Feb", 19461, 2439, 13, 16027, 2613, 16, 82, 107, 174],
        ["Mar", 30949, 3859, 12, 4390, 1374, 31, 14, 36, -2486],
        ["Apr", 46283, 5969, 13, 214, 119, 55, 0, 2, -5850],
        ["May", 62806, 7725, 12, 3, 0, 7, 0, 0, -7725],
        ["Jun", 62769, 7917, 13, 0, 0, 0, 0, 0, -7917],
        ["Jul", 59517, 8158, 14, 0, 0, 0, 0, 0, -8158],
        ["Aug", 50831, 7100, 14, 3, -8, -228, 0, 0, -7108],
        ["Sep", 56918, 7806, 14, 0, 0, 0, 0, 0, -7806],
        ["Oct", 47093, 6505, 14, 9, -14, -170, 0, 0, -6520],
        ["Nov", 32680, 4358, 13, 0, 0, 0, 0, 0, -4358],
        ["Dec", 30255, 3860, 13, 0, 0, 0, 0, 0, -3860],
        ["Total", 520614, 68184, 13, 41088, 6281, 15, 8, 9, -61903]
    ]
}
}
"""
