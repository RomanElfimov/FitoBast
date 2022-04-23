//
//  ManualTemplatesViewController.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 22.04.2022.
//

import UIKit

class ManualTemplatesViewController: UITableViewController {
    
    private let dataArray = ["FF", "FF", "WW"]
    
    
    // MARK: - Interface Properties
    
    // Name
    
    private let templateNameCell = UITableViewCell()
    private lazy var templateNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Имя шаблона"
        return tf
    }()
    
    
    // Duration
    
    private let durationCell = UITableViewCell()
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.text = "Длительность, ч"
        return label
    }()
    private lazy var durationPicker = UIPickerView()
    
    
    // Red Cell
    
    private let redSliderCell = UITableViewCell()
    private lazy var redLabel: UILabel = {
        let label = UILabel()
        label.text = "Красный, R: 255"
        return label
    }()
    private lazy var redSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 255
        slider.thumbTintColor = UIColor.red
        slider.value = 255
        slider.addTarget(self, action: #selector(sliderAction), for: .valueChanged)
        return slider
    }()
    private lazy var minRedLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    private lazy var maxRedLabel: UILabel = {
        let label = UILabel()
        label.text = "255"
        return label
    }()
    
    
    // Green Cell
    
    private let greenSliderCell = UITableViewCell()
    private lazy var greenLabel: UILabel = {
        let label = UILabel()
        label.text = "Зеленый, G: 255"
        return label
    }()
    private lazy var greenSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 255
        slider.thumbTintColor = UIColor.green
        slider.value = 255
        slider.addTarget(self, action: #selector(sliderAction), for: .valueChanged)
        return slider
    }()
    private lazy var minGreenLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    private lazy var maxGreenLabel: UILabel = {
        let label = UILabel()
        label.text = "255"
        return label
    }()
    
    
    // Blue Cell
    
    private let blueSliderCell = UITableViewCell()
    private lazy var blueLabel: UILabel = {
        let label = UILabel()
        label.text = "Синий, B: 255"
        return label
    }()
    private lazy var blueSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 255
        slider.thumbTintColor = UIColor.blue
        slider.value = 255
        slider.addTarget(self, action: #selector(sliderAction), for: .valueChanged)
        return slider
    }()
    private lazy var minBlueLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    private lazy var maxBlueLabel: UILabel = {
        let label = UILabel()
        label.text = "255"
        return label
    }()
    
    
    // Color Pallete
    
    private let colorPalleteCell = UITableViewCell()
    private let colorPalleteView = UIView()
    
    
    // Show color on device
    
    private let showColorCell = UITableViewCell()
    private lazy var showColorButton: UIButton = {
        let button = UIButton()
        button.setTitle("Показать на устройстве", for: .normal)
        button.setTitleColor(UIColor.purple, for: .normal)
        button.addTarget(self, action: #selector(showColorButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    // Save Template
    
    private let saveCell = UITableViewCell()
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.backgroundColor = UIColor(named: "LightGreenColor")
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    
    // MARK: - Private Methods
    
    private func setupUI() {
        setupNavigationBar()
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        
        // Templates Cell
        
        templateNameCell.contentView.addSubview(templateNameTextField)
        templateNameTextField.anchor(top: templateNameCell.topAnchor, left: templateNameCell.leftAnchor, bottom: templateNameCell.bottomAnchor, right: templateNameCell.rightAnchor, paddingTop: 24, paddingLeft: 20, paddingBottom: 2, paddingRight: 0)
        
        
        // Duration Cell
        
        durationCell.contentView.addSubview(durationLabel)
        durationCell.contentView.addSubview(durationPicker)
        
        durationLabel.anchor(top: durationCell.topAnchor, left: durationCell.leftAnchor, bottom: durationCell.bottomAnchor, right: durationPicker.leftAnchor, paddingLeft: 16)
        durationPicker.anchor(top: durationCell.topAnchor, left: durationLabel.rightAnchor, bottom: durationCell.bottomAnchor, right: durationCell.rightAnchor, width: 200)
        
        durationPicker.delegate = self
        durationPicker.dataSource = self
        
        
        // Red Cell
        
        setupSliderCell(cell: redSliderCell, slider: redSlider, label: redLabel, minLabel: minRedLabel, maxLabel: maxRedLabel)
        
        
        // Greed Cell
        
        setupSliderCell(cell: greenSliderCell, slider: greenSlider, label: greenLabel, minLabel: minGreenLabel, maxLabel: maxGreenLabel)
        
        
        // Blue Cell
        
        setupSliderCell(cell: blueSliderCell, slider: blueSlider, label: blueLabel, minLabel: minBlueLabel, maxLabel: maxBlueLabel)
        
        
        // Color Pallete
        
        colorPalleteCell.addSubview(colorPalleteView)
        colorPalleteView.anchor(top: colorPalleteCell.topAnchor, left: colorPalleteCell.leftAnchor, bottom: colorPalleteCell.bottomAnchor, right: colorPalleteCell.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 15)
        colorPalleteView.backgroundColor = .cyan
        colorPalleteView.layer.cornerRadius = 15
        
        
        // Show Color Button
        
        showColorCell.contentView.addSubview(showColorButton)
        showColorButton.anchor(top: showColorCell.topAnchor, left: showColorCell.leftAnchor, bottom: showColorCell.bottomAnchor, right: showColorCell.rightAnchor, paddingTop: 16, paddingLeft: 44, paddingBottom: 16, paddingRight: 44)
        
        
        // Save Template
        
        saveCell.contentView.addSubview(saveButton)
        saveButton.layer.cornerRadius = 20
        saveButton.anchor(top: saveCell.topAnchor, left: saveCell.leftAnchor, bottom: saveCell.bottomAnchor, right: saveCell.rightAnchor, paddingTop: 16, paddingLeft: 44, paddingBottom: 16, paddingRight: 44)
        
        
        
        createGradientForSlider(colors: [CGColor.red1Color, CGColor.red2Color, CGColor.red3Color, UIColor.red.cgColor], slider: redSlider)
        createGradientForSlider(colors: [CGColor.green1Color, CGColor.green2Color, CGColor.green3Color, UIColor.green.cgColor], slider: greenSlider)
        createGradientForSlider(colors: [CGColor.blue1Color, CGColor.blue2Color, CGColor.blue3Color, UIColor.blue.cgColor], slider: blueSlider)
    }
    
    
    private func setupSliderCell(cell: UITableViewCell, slider: UISlider, label: UILabel, minLabel: UILabel, maxLabel: UILabel) {
        cell.separatorInset = UIEdgeInsets(top: 0, left: 777, bottom: 0, right: 0)
        
        cell.contentView.addSubview(label)
        cell.contentView.addSubview(slider)
        
        let redValueStack = UIStackView(arrangedSubviews: [minLabel, maxLabel])
        redValueStack.axis = .horizontal
        redValueStack.distribution = .equalSpacing
        cell.contentView.addSubview(redValueStack)
        
        label.anchor(top: cell.topAnchor, left: cell.leftAnchor, bottom: slider.topAnchor, right: cell.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        slider.anchor(top: label.bottomAnchor, left: cell.leftAnchor, bottom: redValueStack.topAnchor, right: cell.rightAnchor, paddingTop: 8, paddingLeft: 20, paddingBottom: 4, paddingRight: 20)
        
        redValueStack.anchor(top: slider.bottomAnchor, left: cell.leftAnchor, bottom: cell.bottomAnchor, right: cell.rightAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 4, paddingRight: 16)
    }
    
    
    private func createGradientForSlider(colors: [CGColor], slider: UISlider) {
        let tgl = CAGradientLayer()
        let frame = CGRect.init(x: 0, y: 0, width: slider.frame.size.width, height:5)
        tgl.frame = frame
        
        tgl.colors = colors
        
        tgl.startPoint = CGPoint.init(x: 0.0, y: 0.5)
        tgl.endPoint = CGPoint.init(x: 1.0, y: 0.5)
        
        UIGraphicsBeginImageContextWithOptions(tgl.frame.size, tgl.isOpaque, 0.0);
        tgl.render(in: UIGraphicsGetCurrentContext()!)
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            image.resizableImage(withCapInsets: UIEdgeInsets.zero)
            slider.setMinimumTrackImage(image, for: .normal)
        }
    }
    
    
    private func setupNavigationBar() {
        title = "Новый шаблон"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        // background color
        appearance.backgroundColor = UIColor(named: "LightGreenColor")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationItem.standardAppearance = appearance
        
        // Left button - Cancel
        let menuButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelButtonTapped))
        menuButton.tintColor = .white
        navigationItem.leftBarButtonItem = menuButton
        
    }
    
    
    
    // MARK: - Selectors
    
    @objc func sliderAction() {
        redLabel.text = "Красный, R: \(Int(redSlider.value))"
        greenLabel.text = "Зеленый, G: \(Int(greenSlider.value))"
        blueLabel.text = "Синий, B: \(Int(blueSlider.value))"
        
        colorPalleteView.backgroundColor = UIColor(red: CGFloat(redSlider.value)/255, green: CGFloat(greenSlider.value)/255, blue: CGFloat(blueSlider.value)/255, alpha: 1)
    }
    
    
    @objc func showColorButtonAction() {
        print("show color")
    }
    
    
    @objc func saveButtonTapped() {
        print("save")
    }
    
    
    @objc func cancelButtonTapped() {
        print("cancel")
    }
    
    
    
    
    
}



// MARK: - Table view data source

extension ManualTemplatesViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 6
        default:
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return templateNameCell
            case 1:
                return durationCell
            default:
                return UITableViewCell()
            }
        }
        
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                return redSliderCell
            case 1:
                return blueSliderCell
            case 2:
                return greenSliderCell
            case 3:
                return colorPalleteCell
            case 4:
                return showColorCell
            case 5:
                return saveCell
            default:
                return UITableViewCell()
            }
        }
        
        return UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: return 71
            case 1: return 80
            default: return 0
            }
        }
        
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0: return 119
            case 1: return 119
            case 2: return 119
            case 3: return 130
            case 4: return 80
            case 5: return 80
            default: return 0
            }
        }
        
        return 0
    }
}




// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension ManualTemplatesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = dataArray[row]
        return row
    }
}









