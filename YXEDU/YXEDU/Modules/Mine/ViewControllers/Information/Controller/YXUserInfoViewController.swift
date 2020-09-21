//
//  YXUserInfoViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/30.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXUserInfoViewController: YXViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, YXBasePickverViewDelegate {

    var nick: String     = ""
    var sex: String      = ""
    var birthday: String = ""
    var area: String     = ""
    var grade: String    = ""
    var selectedIndexPath: IndexPath?

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        view.layer.opacity = 0
        view.isUserInteractionEnabled = false
        return view
    }()
    let cameraPicker = UIImagePickerController()
    let imagePicker  = UIImagePickerController()
    var basePicker: YXBasePickverView?

    deinit {
        self.backgroundView.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.registerNotification()
        self.tableView.reloadData()
    }

    private func createSubviews() {
        self.view.addSubview(tableView)
        kWindow.addSubview(backgroundView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
        }
    }

    private func bindProperty() {
        self.customNavigationBar?.title = "个人资料"
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.register(YXUserInfoCell.classForCoder(), forCellReuseIdentifier: "kYXUserInfoCell")
        let tapBackgroundView = UITapGestureRecognizer(target: self, action: #selector(hideBaseAlert))
        self.backgroundView.addGestureRecognizer(tapBackgroundView)
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().barStyle      = .default
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            cameraPicker.sourceType    = .camera;
        }
        cameraPicker.delegate      = self
        cameraPicker.allowsEditing = true

        imagePicker.sourceType     = .photoLibrary
        imagePicker.delegate       = self
        imagePicker.allowsEditing  = true
        imagePicker.navigationBar.isTranslucent = false
        imagePicker.navigationBar.tintColor     = .black1
    }

    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(hideBaseAlert), name: NSNotification.Name(rawValue: "RemovePickerView"), object: nil)
    }

    // MARK: ==== Request ====
    private func uploadAvatar(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        DispatchQueue.main.async {
            YXUtils.showProgress(kWindow, info: "上传中……")
        }
        let request = YXOCRequest.changeAvatar(file: imageData)
        YYNetworkService.default.upload(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                YXUtils.hidenProgress(kWindow)
                YXUserModel.default.userAvatarImage = image
                self.tableView.reloadData()
            }
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    // MARK: ==== Event ====
    private func showChangeAvatarPickerView() {
        let leeAlert = LEEAlert.actionsheet()
        _ = leeAlert.config.leeAddAction({ [weak self] (action: LEEAction) in
            action.type  = .default
            action.title = "拍照"
            action.titleColor = .black1
            action.font = UIFont.regularFont(ofSize: AdaptFontSize(18))
            action.clickBlock = { [weak self] in
                guard let self = self else { return }
                self.present(self.cameraPicker, animated: true, completion: nil)
            }
        }).leeAddAction({ [weak self] (action: LEEAction) in
            action.type = .default
            action.title = "从相册中选择"
            action.titleColor = .black1
            action.font = UIFont.regularFont(ofSize: AdaptFontSize(18))
            action.clickBlock = { [weak self] in
                guard let self = self else { return }
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }).leeAddAction({ (action: LEEAction) in
            action.type = .default
            action.title = "取消"
            action.titleColor = .black1
            action.font = UIFont.regularFont(ofSize: AdaptFontSize(18))
        }).leeActionSheetCancelActionSpaceColor(UIColor.hex(0xF6F8FA)).leeActionSheetBottomMargin(0).leeCornerRadius(0).leeConfigMaxWidth({ _ in
            return screenWidth
        }).leeActionSheetBackgroundColor(.white).leeShow()
    }

    private func toChangeNameVC() {
        let vc = YXEditNameViewController()
        vc.name = self.nick
        vc.blackAction = { [weak self] (name: String) in
            guard let self = self else { return }
            self.nick = name
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func showChangeSexAlert() {
        self.basePicker = YXBasePickverView.showSexPickerView(on: self.sex, with: self)
        self.basePicker?.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: AdaptSize(272))
        self.showBaseAlert()
    }

    private func showChangeBirthdayAlert() {
        self.basePicker = YXBasePickverView.showBirthdayPickerView(on: self.birthday, with: self)
        self.showBaseAlert()
    }

    private func showChangeAreaAlert() {
        self.basePicker = YXBasePickverView.showLocationPickerView(on: self.area, with: self)
        self.showBaseAlert()
    }

    private func showChangeGradeAlert() {
        self.basePicker = YXBasePickverView.showGradePickerView(on: self.grade, with: self)
        self.showBaseAlert()
    }

    private func showBaseAlert() {
        if self.basePicker != nil {
            self.basePicker?.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: AdaptSize(272))
            self.basePicker?.backgroundColor = .clear
            kWindow.addSubview(basePicker!)
        }
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let self = self else { return }
            self.backgroundView.layer.opacity = 1.0
            self.basePicker?.transform = CGAffineTransform(translationX: 0, y: AdaptSize(-272))
        }) { [weak self] (result) in
            if result {
                self?.backgroundView.isUserInteractionEnabled = true
            }
        }
    }

    @objc
    private func hideBaseAlert() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let self = self else { return }
            self.backgroundView.layer.opacity = 0
            self.basePicker?.transform = .identity
        }) { [weak self] (result) in
            guard let self = self else { return }
            if result {
                self.basePicker?.removeFromSuperview()
            }
        }
    }

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
                cell.setData(title: "头像", detail: "", hideAvatar: false)
            case 1:
                cell.setData(title: "姓名", detail: nick)
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
                self.showChangeAvatarPickerView()
            case 1:
                self.toChangeNameVC()
            case 2:
                self.showChangeSexAlert()
            default:
                break
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                self.showChangeBirthdayAlert()
            case 1:
                self.showChangeAreaAlert()
            case 2:
                self.showChangeGradeAlert()
            default:
                break
            }
        }
        self.selectedIndexPath = indexPath
    }

    // MARK: ==== UIImagePickerControllerDelegate ====
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            guard let image = info[.editedImage] as? UIImage else { return }
            self.uploadAvatar(image: image)
        }
    }

    // MARK: ==== YXBasePickverViewDelegate ====
    func basePickverView(_ pickverView: YXBasePickverView, withSelectedTitle title: String) {
        guard let indexPath = self.selectedIndexPath else {
            return
        }
        switch indexPath.section {
        case 0:
            if indexPath.row == 2 {
                self.sex = title
            }
        case 1:
            switch indexPath.row {
            case 0:
                self.birthday = title
            case 1:
                self.area = title
            case 2:
                self.grade = title
            default:
                break
            }
        default:
            return
        }
        self.tableView.reloadData()
        YXLog(title)
    }
}
