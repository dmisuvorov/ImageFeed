//
//  ImageListViewController.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 16.12.2022.
//

import UIKit

class ImageListViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    
    func configCell(for cell: ImageListCell) { }
}

extension ImageListViewController: UITableViewDelegate {
    
}

extension ImageListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)
                
        guard let imageListCell = cell as? ImageListCell else {
                return UITableViewCell()
        }
                
        configCell(for: imageListCell)
            return imageListCell
    }
}
