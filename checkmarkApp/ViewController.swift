//
//  ViewController.swift
//  checkmarkApp
//
//  Created by Azat Chorekliev on 1/6/20.
//  Copyright © 2020 Azat Chorekliev. All rights reserved.
//

import UIKit

var doneList: [String] = []

private var groceryList = ["Milk","Beer","Juice", "Wine", "Bread", "Olive Oil", "Jam", "Muesli"]
private let addProductsAfterRefresh = ["Beef", "Snacks", "Coffee", "Tea", "Honey", "Rice", "Pasta"]


class ViewController: UIViewController {

    private var myTableView: UITableView!
    private var refreshControl: UIRefreshControl?

    private var activityIndicator: UIActivityIndicatorView?


    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()


        self.refreshControl = UIRefreshControl()

        if let refreshControl = refreshControl {
            refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
            myTableView.addSubview(refreshControl)
        }

        self.activityIndicator = UIActivityIndicatorView()
    }

    @objc func pullToRefresh() {

        // need to add new element in groceryList array


        let randomProduct = Int(arc4random_uniform(UInt32(addProductsAfterRefresh.count)))
        groceryList.didRefreshToAdd(addProductsAfterRefresh[randomProduct])

        myTableView.reloadData()

        refreshControl?.endRefreshing()
        activityIndicator?.stopAnimating()

    }

    func configureTableView() {
        // configure view
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        // configure tableView
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
    }
}

// MARK: UITableViewDataSource and UITableViewDelegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = groceryList[indexPath.row]
        return cell!
    }

    // Checking existing product in list
    // Deprecated: Added (func) extension to Array type

//    func checkProduct(_ product: String){
//        if doneList.contains(product) {
//            // filter
//            doneList = doneList.filter{$0 != product}
//        } else {
//            doneList.append(product)
//        }
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productIndexCell = groceryList[indexPath.row]

        if tableView.cellForRow(at: indexPath)?.accessoryType ==
            UITableViewCell.AccessoryType.none {
            doneList.addOrDeleteString(productIndexCell)

//            checkProduct(productIndexCell)

            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {

            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            doneList.addOrDeleteString(productIndexCell)

            myTableView.deselectRow(at: indexPath, animated: true)

//            checkProduct(productIndexCell)

        }
        print(doneList)
    }
}


extension Array where Element == String {
    // makes an array only type based of String
    func addOrDeleteString(_ product: String){
        if doneList.contains(product) {
            // filter
            doneList = doneList.filter{$0 != product}
        } else {
            doneList.append(product)
        }
    }
}

extension Array where Element == String {

    func didRefreshToAdd(_ product: String) {
        if groceryList.contains(product) {
            // filter
            print("there is yes")
        } else {
            groceryList.append(product)
        }
    }
}



