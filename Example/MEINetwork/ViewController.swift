//
//  ViewController.swift
//  MEINetwork_Example
//
//  Created by maochaolong041 on 2019/4/18.
//  Copyright (c) 2019 maochaolong041. All rights reserved.
//

import UIKit
import MEINetwork

struct InstantInternalModel: Codable {
    let topic: String?
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(submitAction(sender:)))

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))

        let provider = NetworkProvider<AssistantService>(environment: AssistantService.environment)

        provider.request(.instantInternal(page: 1, pageSize: 10), type: [InstantInternalModel].self, keyPath: "data.currentPageResult") {
            if let error = $1 {
                print(error.localizedDescription)
            } else if let models = $0 {
                self.models = models
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        if let model = models?[indexPath.row],
            let topic = model.topic {
            cell.textLabel?.text = topic
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @objc func submitAction(sender: UIBarButtonItem) {
        let provider = NetworkProvider<AssistantService>(environment: AssistantService.environment)

        provider.request(.customization(name: "毛司机", phone: "15223452827",
                                        requirements: "1.年龄 25 岁以下\n2.温柔体贴，无不良嗜好\n3.活好不粘人",
                                        achievements: [], favorites: [])) {
                                            if let code = $0?["resultCode"] as? String, code == "0000" {
                                                print("提交成功")
                                            }
                                            if let error = $1 {
                                                print(error.localizedDescription)
                                            }
        }
    }

    @IBOutlet weak var tableView: UITableView!

    private var allModels: [InstantInternalModel]?

    private var models: [InstantInternalModel]? {
        get {
            return allModels
        }
        set {
            allModels = newValue
            tableView.reloadData()
        }
    }

}

