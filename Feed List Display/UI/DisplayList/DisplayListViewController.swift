//
//  DisplayListViewController.swift
//  Feed List Display
//
//  Created by Szymon Lorenz on 26/6/19.
//  Copyright © 2019 Szymon Lorenz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class DisplayListViewController: ViewController {
    typealias ViewModelType = DisplayListViewModel
    var viewModel: DisplayListViewModel!
    private let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Adding foother, to prevent display of empty section/rows separators
        tableView.tableFooterView = UIView()
        
        //Configure pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        //Setup Rx
        viewModel.data.asObservable().bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, item, cell) in
                if let titleLabel = cell.viewWithTag(2) as? UILabel {
                    titleLabel.text = item.title
                }
                if let bodyLabel = cell.viewWithTag(3) as? UILabel {
                    bodyLabel.text = item.body
                }
                if let imageView = cell.viewWithTag(1) as? UIImageView {
                    let url = URL(string: item.thumbnailUrl)
                    imageView.kf.setImage(with: url)
                }
            }
            .disposed(by: disposeBag)
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        viewModel.refreshData(sender)
    }
}

