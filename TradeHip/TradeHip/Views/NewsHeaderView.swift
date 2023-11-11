//
//  NewsHeaderView.swift
//  TradeHip
//
//  Created by 김우섭 on 11/9/23.
//

import UIKit

/// 헤더 이벤트를 알리는 위임
protocol NewsHeaderViewDelegate: AnyObject {
    /// 사용자가 탭한 헤더 버튼에 알림
    /// - Parameter headerView: 헤더 뷰 참조
    func newsHeaderViewDidTapAddButton(_ headerView: NewsHeaderView)
}

/// 뉴스의 TableView 헤더
final class NewsHeaderView: UITableViewHeaderFooterView {
    static let identifier = "NewsHeaderView"
    
    static let preferredHeight: CGFloat = 70
    
    weak var delegate: NewsHeaderViewDelegate?
    
    /// 헤더뷰모델
    struct ViewModel {
        let title: String
        let shouldShowAddButton: Bool
    }
    // MARK: - Private
    private let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 32)
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("+ 관심 목록", for: .normal)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: - Init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(label, button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    /// 핸들 버튼 탭
    @objc private func didTapButton() {
        delegate?.newsHeaderViewDidTapAddButton(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 14, y: 0, width: contentView.width - 28, height: contentView.height)
        
        button.sizeToFit()
        button.frame = CGRect(x: contentView.width - button.width - 16, y: (contentView.height - button.height) / 2, width: button.width + 8, height: button.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    /// Configure 뷰
    /// - Parameter viewModel: 뷰모델
    public func configure(with viewModel: ViewModel) {
        label.text = viewModel.title
        button.isHidden = !viewModel.shouldShowAddButton
    }
}
