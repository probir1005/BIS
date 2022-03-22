//
//  BISSpreadSheetView.swift
//  BIS
//
//  Created by TSSIT on 15/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class BISSpreadSheetView: UIView {

    var sheetCollectionView: UICollectionView!
    var tableDataSource: [RowModel]?
    var numberOfRows = 0
    let customLayout = SpreadSheetCollectionViewLayout()
    var widthOfColumns = [CGFloat]()
    
    var tableDetails: TableDetailsModel? {
        didSet {
            var rowModels = [RowModel]() 
            if let columnList = tableDetails?.columns {
                let columns = columnList.map({ RowModel(rowValue: $0, isColumn: true) })
                rowModels = columns
                numberOfRows = columns.count
            }
            
            if let rows = tableDetails?.rows {
                let flatRows = rows.flatMap({$0})
                let rows = flatRows.map({ RowModel(rowValue: $0, isColumn: false) })
                rowModels += rows
            }
            tableDataSource = rowModels
            setMaxRowWidth()
            sheetCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // TODO: Use custom layout instead:
        initializeCollectionView()
    }
    
    private func initializeCollectionView() {
        sheetCollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: customLayout)
        sheetCollectionView.delegate = self
        sheetCollectionView.dataSource = self
        sheetCollectionView.register(cell: BISSpreadSheetCVCell.self)
        sheetCollectionView.register(cell: BISSpreadSheetColumnCVCell.self)
        sheetCollectionView.register(nib: "BISSpreadSheetHeaderView", forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ssheader")
        sheetCollectionView.bounces = false
        sheetCollectionView.clipsToBounds = true
        sheetCollectionView.backgroundColor = .clear
        sheetCollectionView.autoresizingMask = UIView.AutoresizingMask.init(arrayLiteral: [.flexibleHeight, .flexibleWidth])
        
        addSubview(sheetCollectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sheetCollectionView.collectionViewLayout.invalidateLayout()
        sheetCollectionView.layoutIfNeeded()
    }
    
    private func setMaxRowWidth() {
        var arrWidth = [CGFloat]()
        if let columns = tableDetails?.columns {
            let widths = columns.map { (str) -> CGFloat in
                let font = BISFont.bodyText.bold
                let width = str.width(withConstrainedHeight: 33.0, font: font) + 20 // 20 for side margin
                return width
            }
            arrWidth = widths
        }
        
        //TODO: calculate max width from column
        if let rows = tableDetails?.rows {
            for row in rows {
                for cell in row.enumerated() {
                    if let cellStr = (cell.element as? String) ?? (cell.element as? NSNumber)?.decimalValue.formattedWithSeparator {
                        let font = BISFont.bodyText.semibold
                        let width = cellStr.width(withConstrainedHeight: 33.0, font: font) + 20 // 20 for side margin
                        
                        if width > arrWidth[cell.offset] {
                            arrWidth[cell.offset] = width
                        }
                    }
                }
            }
        }
        customLayout.widthOfColumns = arrWidth
        widthOfColumns = arrWidth
    }
}

extension BISSpreadSheetView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableDataSource?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let model = tableDataSource?[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        if model.isColumn {
            let columnCell: BISSpreadSheetColumnCVCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            columnCell.backgroundColor = .white
            columnCell.dataLabel.text = (model.rowValue as? String) ?? (model.rowValue as? NSNumber)?.stringValue ?? ""
            return columnCell
        } else {
            let desCell: BISSpreadSheetCVCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            desCell.backgroundColor = .white
            desCell.dataLabel.text = (model.rowValue as? String) ?? (model.rowValue as? NSNumber)?.decimalValue.formattedWithSeparator ?? ""
            desCell.dataLabel.textColor = (desCell.dataLabel.text?.hasPrefix("-") ?? false) ? UIColor.scarlet : UIColor.textGray
            return desCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header: BISSpreadSheetHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ssheader", for: indexPath) as! BISSpreadSheetHeaderView
        header.configureHeader(with: tableDetails?.columns ?? [], widths: widthOfColumns)
        return header
    }
}

struct TableDetailsModel: BaseDashboardDTOProtocol {
    var title: String?
    var columns: [String]?
    var rows: [[Any?]]?
    var optionList: [PopoverOptionModel] = [PopoverOptionModel(title: "Annotations", image: #imageLiteral(resourceName: "menuAnnotation"))]
    
    static func getTableDetails(from dataString: String) -> TableDetailsModel? {
        let data = dataString.data(using: .utf8)!
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                if let tableJSON = json["tableData"] as? [String: Any] {
                    let name = tableJSON["name"] as? String
                    let headers = tableJSON["headers"] as? [String]
                    let rows = tableJSON["rows"] as? [[Any]]
                    let tableDetails = TableDetailsModel(title: name, columns: headers, rows: rows)
                    return tableDetails  
                }
            }
        } catch {
            print(error)
        }
        return nil
    }
}

struct RowModel {
    var rowValue: Any?
    var isColumn = false
}
