import UIKit

class SportsCollectionViewCell: UICollectionViewCell {
    static let identifier = "SportsCollectionViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sportImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sportLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.92, y: 0.92) : .identity
            }, completion: nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        containerView.addSubview(sportImageView)
        containerView.addSubview(overlayView)
        containerView.addSubview(sportLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            sportImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            sportImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            sportImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            sportImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            overlayView.topAnchor.constraint(equalTo: containerView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            sportLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            sportLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            
            sportLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 16),
            sportLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16
                                                )
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with sport: String) {
        sportLabel.text = sport
        sportImageView.image = UIImage(named: "\(sport.lowercased())") ?? UIImage(systemName: "sportscourt")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sportLabel.text = nil
        sportImageView.image = nil
    }
}
