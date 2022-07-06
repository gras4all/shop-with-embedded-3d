//
//  ProductDetailViewController.swift
//  iStore
//
//  Created by Andrey Grunenkov on 27.05.2020.
//  Copyright © 2020 Andrey Grunenkov. All rights reserved.
//

import UIKit
import SceneKit

protocol AddToCartButtonDelegate: AnyObject {
    func didTapAddToCartButton(_ product: Product)
}

final class ProductDetailViewController: UIViewController {
    
    var onSelectDevice: ((Product) -> Void)?
    
    weak var delegate: AddToCartButtonDelegate?
    
    enum CommunicationType {
        case delegate
        case callback
    }
    
    private var communicationType: CommunicationType = .callback
    
    private let scrollView = UIScrollView()
    
    private let sceneView: SCNView = {
        let scene = SCNView()
        return scene
    }()

    private let modelNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .systemBlue
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 18)
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add To Cart", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = buttonHeight/2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let product: Product
    
    // MARK: - Life cycle
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
        updateProduct()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubviews(sceneView, modelNameLabel, priceLabel, descriptionLabel, addToCartButton)
        setupScene()
    }
    
    // MARK: - Actions
    
    @objc private func addToCartButtonTapped() {
        switch communicationType {
        case .delegate:
            delegate?.didTapAddToCartButton(product)
        case .callback:
            onSelectDevice?(product)
        }
    }
    
    private func updateProduct() {
        modelNameLabel.attributedText = TextFormatter.titleText(with: product.name)
        descriptionLabel.attributedText = TextFormatter.descriptionText(with: product.description ?? "")
        priceLabel.attributedText = TextFormatter.priceText(with: product.price)
        title = product.name
    }
    
    private func setupScene() {
        let scene = SCNScene(named: product.model)
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 35)
        scene?.rootNode.addChildNode(cameraNode)
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 0, z: 60)
        scene?.rootNode.addChildNode(lightNode)
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.darkGray
        scene?.rootNode.addChildNode(ambientLightNode)
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = UIColor.white
        sceneView.cameraControlConfiguration.allowsTranslation = false
        sceneView.scene = scene
    }
    
    // MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // // Layout with frames
        
        let imageWidth: CGFloat = view.bounds.width - 32 * 2
        let baseWidth: CGFloat = view.bounds.width - 32 * 2
        let baseTopInset: CGFloat = 8
        let modelLabelInset: CGFloat = 10
        let descriptionLabelInset: CGFloat = 24
        let priceLabelInset: CGFloat = 32
        let bottomInset: CGFloat = 24
        let modelNameHeight: CGFloat = modelNameLabel.attributedText?.height(widthLimit: baseWidth) ?? 0
        let descriptionHeight: CGFloat = descriptionLabel.attributedText?.height(widthLimit: baseWidth) ?? 0
        let priceHeight: CGFloat = priceLabel.attributedText?.height(widthLimit: baseWidth) ?? 0
        
        scrollView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width,
            height: view.bounds.height
        )
        
        sceneView.frame = CGRect(
            x: 32,
            y: view.safeAreaInsets.top + baseTopInset,
            width: imageWidth,
            height: imageWidth
        )
    
        modelNameLabel.frame = CGRect(
            x: (view.bounds.width - baseWidth) / 2,
            y: sceneView.frame.maxY + modelLabelInset,
            width: baseWidth,
            height: modelNameHeight
        )
        
        descriptionLabel.frame = CGRect(
            x: 32,
            y: modelNameLabel.frame.maxY + descriptionLabelInset,
            width: baseWidth,
            height: descriptionHeight
        )
        
        priceLabel.frame = CGRect(
            x: 32,
            y: descriptionLabel.frame.maxY + priceLabelInset,
            width: baseWidth,
            height: priceHeight
        )
        
        addToCartButton.frame = CGRect(
            x: (view.bounds.width - buttonWidth) / 2,
            y: priceLabel.frame.maxY + baseTopInset,
            width: buttonWidth,
            height: buttonHeight
        )
        
        let contentSizeHeight: CGFloat = baseTopInset + imageWidth + modelLabelInset + modelNameHeight + descriptionLabelInset + descriptionHeight + priceLabelInset + priceHeight + baseTopInset + buttonHeight + bottomInset
        
        scrollView.contentSize = CGSize(width: view.bounds.width, height: contentSizeHeight)
    }
    
}

extension ProductDetailViewController {
    var buttonHeight: CGFloat { return 44 }
    var buttonWidth: CGFloat { return 140 }
    
    static func labelHeight(with attributedText: NSAttributedString?) -> CGFloat {
        return attributedText?.height(widthLimit: UIScreen.main.bounds.width - 64) ?? 0
    }
}
