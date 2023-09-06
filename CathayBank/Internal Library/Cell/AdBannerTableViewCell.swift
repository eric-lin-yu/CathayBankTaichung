//
//  AdTableViewCell.swift
//  CathayBank
//
//  Created by wistronits on 2023/8/11.
//

import UIKit

class AdBannerTableViewCell: UITableViewCell {
    private var viewModel: BannerViewModel
    private var adBannerArray: [BannerModel] = []
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // tableView
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.viewModel = BannerViewModel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraint()
        setUpCollcetionView()
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    //MARK: - setup
    private func setupViews() {
        let viewsToAdd: [UIView] = [
            collectionView,
            pageControl,
        ]
        viewsToAdd.forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraint() {
        let topContentViewAnchor = contentView.topAnchor
        let leftContentViewAnchor = contentView.leftAnchor
        let rightContentViewAnchor = contentView.rightAnchor
        let bottomContentViewAnchor = contentView.bottomAnchor
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topContentViewAnchor, constant: 24),
            collectionView.leftAnchor.constraint(equalTo: leftContentViewAnchor, constant: 24),
            collectionView.rightAnchor.constraint(equalTo: rightContentViewAnchor, constant: -24),
            collectionView.heightAnchor.constraint(equalToConstant: 87.9),
            
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 4),
            pageControl.leftAnchor.constraint(equalTo: collectionView.leftAnchor),
            pageControl.rightAnchor.constraint(equalTo: collectionView.rightAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomContentViewAnchor, constant: -4),
        ])
    }
    
    private func setUpCollcetionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(AdBannerCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: AdBannerCollectionViewCell.self))
    }
    
    func configure() {
        viewModel.getBannerData { result in
            self.adBannerArray = result
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

//MARK: - CollectionView
extension AdBannerTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return adBannerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AdBannerCollectionViewCell.self), for: indexPath) as? AdBannerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(image: adBannerArray[indexPath.row].linkUrl)
        pageControl.numberOfPages = adBannerArray.count
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width,
                      height: collectionView.bounds.height)
    }
}

//MARK: - UIScrollViewDelegate
extension AdBannerTableViewCell: UIScrollViewDelegate {
    // CollectionView 繼承自 ScrollView。可直接使用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width + 0.6
        pageControl.currentPage = Int(page)
    }
}
