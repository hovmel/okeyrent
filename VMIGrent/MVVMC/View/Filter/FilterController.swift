//
//  FilterController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 28.06.2022.
//

import UIKit

enum FilterSection {
    case price(Int, Int, Int, Int)
    case type([ObjectsTypeDefinition])
    case rooms([RoomType])
    case featurs([FeatureModel])
    case beds(Int)
    
    var title: String {
        switch self {
        case .price:
            return "Цена за сутки"
        case .type:
            return "Варианты размещения"
        case .rooms:
            return "Количество комнат"
        case .featurs:
            return "Удобства"
        case .beds:
            return "Количество гостей"
        }
    }
}

class FilterController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var acceptButton: VmigButton!
    @IBOutlet weak var botView: UIView!
    
    var sections: [FilterSection] {
        return [.price(self.filterModel.minPrice ?? self.filterModel.meta?.price_day_min ?? 0,
                       self.filterModel.maxPrice ?? self.filterModel.meta?.price_day_max ?? 20000,
                       self.filterModel.meta?.price_day_min ?? 0,
                       self.filterModel.meta?.price_day_max ?? 20000),
                .beds(self.filterModel.bed ?? 0),
                .type(DefinitionManager.shared.objectsTypeDefinition),
                .rooms(RoomType.allCases),
                .featurs(DefinitionManager.shared.features)]
    }
    var filterModel: FilterModel = FilterModel()
    var action: ((FilterModel) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        self.commonSetup()
        self.commonTableViewSetup(tableView: self.tableView, cells: [FilterPriceCell.self, FilterCollectionCellView.self, FilterBedsCellView.self])
        self.tableView.register(UINib(nibName: String(describing: TitleTableHeader.self), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: TitleTableHeader.self))
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        self.botView.layer.cornerRadius = 20
        self.botView.makeCenterShadow()
        self.botView.backgroundColor = Colors.f2f2f2
        self.acceptButton.isEnabled = true
        self.acceptButton.action = {
            self.dismiss(animated: true) { 
                self.action?(self.filterModel)
            }
        }
    }
    
    @IBAction func clearPressed() {
        self.filterModel.clear()
        self.action?(self.filterModel)
        self.tableView.reloadData()
    }
    
    @IBAction func closePressed() {
        self.dismiss(animated: true)
    }
    
}

extension FilterController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TitleTableHeader") as! TitleTableHeader
        view.titleLabel.text = self.sections[section].title
        return view
   }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = self.sections[indexPath.section]
        switch type {
        case .price(let min, let max, let metaMin, let metaMax):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FilterPriceCell.self), for: indexPath) as? FilterPriceCell {
                cell.minPriceLabel.text = min.price
                cell.maxPriceLabel.text = max.price
                cell.priceSlider.maximumValue = CGFloat(metaMax/100)
                cell.priceSlider.minimumValue = CGFloat(metaMin/100)
                cell.priceSlider.value = [CGFloat(min/100), CGFloat(max/100)]
                cell.minAction = { value in
                    self.filterModel.minPrice = value
                }
                cell.maxAction = { value in
                    self.filterModel.maxPrice = value
                }
                return cell
            }
        case .type(let types):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FilterCollectionCellView.self), for: indexPath) as? FilterCollectionCellView {
                cell.collectionViewHeightConstr.constant = CGFloat((types.count * 24) + ((types.count - 1) * 8))
                cell.setModels(types.map({ type in
                    return FilterCellModel(isSelected: self.filterModel.types.contains(where: {$0.id == type.id}),
                                           title: type.title)
                }))
                cell.action = { index in
                    let type = types[index]
                    self.filterModel.types.contains(where: {$0.id == type.id}) ? self.filterModel.types.removeAll(where: {$0.id == type.id}) : self.filterModel.types.append(type)
                    self.tableView.reloadData()
                }
                return cell
            }
        case .rooms(let rooms):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FilterCollectionCellView.self), for: indexPath) as? FilterCollectionCellView {
                cell.collectionViewHeightConstr.constant = CGFloat((rooms.count * 24) + ((rooms.count - 1) * 8))
                cell.setModels(rooms.map({ room in
                    return FilterCellModel(isSelected: self.filterModel.rooms.contains(where: {$0.value == room.value}),
                                           title: room.title)
                }))
                cell.action = { index in
                    let room = rooms[index]
                    self.filterModel.rooms.contains(where: {$0.value == room.value}) ? self.filterModel.rooms.removeAll(where: {$0.value == room.value}) : self.filterModel.rooms.append(room)
                    self.tableView.reloadData()
                }
                return cell
            }
        case .featurs(let features):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FilterCollectionCellView.self), for: indexPath) as? FilterCollectionCellView {
                cell.collectionViewHeightConstr.constant = CGFloat((features.count * 24) + ((features.count - 1) * 8))
                cell.setModels(features.map({ feature in
                    return FilterCellModel(isSelected: self.filterModel.features.contains(where: {$0.id == feature.id}),
                                           title: feature.name)
                }))
                cell.action = { index in
                    let feature = features[index]
                    self.filterModel.features.contains(where: {$0.id == feature.id}) ? self.filterModel.features.removeAll(where: {$0.id == feature.id}) : self.filterModel.features.append(feature)
                    self.tableView.reloadData()
                }
                return cell
            }
        case .beds(let beds):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FilterBedsCellView.self), for: indexPath) as? FilterBedsCellView {
                cell.setGuests(count: beds)
                cell.addAction = { [unowned self] in
                    self.filterModel.bed = (self.filterModel.bed ?? 0) + 1
                    self.tableView.reloadData()
                }
                cell.reduceAction = { [unowned self] in
                    self.filterModel.bed = (self.filterModel.bed ?? 0) - 1
                    self.tableView.reloadData()
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}
