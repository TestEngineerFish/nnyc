//
//  YXUserInfoViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/30.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXUserInfoViewController: YXViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate {

    var avatarUrlStr     = YXUserModel.default.userAvatarPath
    var nick: String     = ""
    var sex: String      = ""
    var birthday: String = ""
    var area: String     = ""
    var grade: String    = ""

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.tableView.reloadData()
    }

    private func createSubviews() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
        }
    }

    private func bindProperty() {
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.register(YXUserInfoCell.classForCoder(), forCellReuseIdentifier: "kYXUserInfoCell")
    }

    // MARK: ==== Request ====
    private func uploadAvatar(image: UIImage) {

    }

    // MARK: ==== Event ====
    private func takePhoto() {
        let pickerView = UIImagePickerController()
        pickerView.sourceType    = .camera;
        pickerView.delegate      = self
        pickerView.allowsEditing = true
        self.present(pickerView, animated: true, completion: nil)
    }

    private func pickImage() {
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().barStyle = .default
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.navigationBar.isTranslucent = false
        picker.allowsEditing = true
        picker.navigationBar.tintColor = .black1
        self.present(picker, animated: true, completion: nil)
    }

    // MARK: ==== Tools ====


    // MARK: ==== UITableViewDelegate && UITableViewDataSource ====
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        } else {
            let headerView: UIView = {
                let view = UIView()
                view.backgroundColor = UIColor.hex(0xF6F8FA)
                return view
            }()
            return headerView
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kYXUserInfoCell") as? YXUserInfoCell else {
            return UITableViewCell()
        }
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.setData(title: "头像", detail: avatarUrlStr ?? "", hideAvatar: false)
            case 1:
                cell.setData(title: "昵称", detail: nick)
            case 2:
                cell.setData(title: "性别", detail: sex)
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.setData(title: "生日", detail: birthday)
            case 1:
                cell.setData(title: "地区", detail: area)
            case 2:
                cell.setData(title: "年级", detail: grade)
            default:
                break
            }
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.1 : AdaptSize(10)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0 {
            return AdaptSize(100)
        } else {
            return AdaptSize(44)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let leeAlert = LEEAlert.actionsheet()
                _ = leeAlert.config.leeAddAction({ [weak self] (action: LEEAction) in
                    action.type = .default
                    action.title = "拍照"
                    action.titleColor = .black1
                    action.font = UIFont.regularFont(ofSize: AdaptFontSize(18))
                    action.clickBlock = { [weak self] in
                        self?.takePhoto()
                    }
                }).leeAddAction({ [weak self] (action: LEEAction) in
                    action.type = .default
                    action.title = "从相册中选择"
                    action.titleColor = .black1
                    action.font = UIFont.regularFont(ofSize: AdaptFontSize(18))
                    action.clickBlock = { [weak self] in
                        self?.pickImage()
                    }
                }).leeAddAction({ (action: LEEAction) in
                    action.type = .default
                    action.title = "取消"
                    action.titleColor = .black1
                    action.font = UIFont.regularFont(ofSize: AdaptFontSize(18))
                }).leeActionSheetCancelActionSpaceColor(UIColor.hex(0xF6F8FA)).leeActionSheetBottomMargin(0).leeCornerRadius(0).leeConfigMaxWidth({ _ in
                    return screenWidth
                }).leeActionSheetBackgroundColor(.white).leeShow()
            default:
                break
            }
        } else if indexPath.section == 1 {

        }
    }

    // MARK: ==== UIImagePickerControllerDelegate ====
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker .dismiss(animated: true) { [weak self] in

        }
    }
}
