import UIKit
import SnapKit

protocol FilterHeaderDelegate: AnyObject {
    func filterButtonDidTap()
}


final class FilterHeader: UICollectionReusableView {
    
    weak var delegate: FilterHeaderDelegate?
    
    private lazy var filterButton: BaseButton = {
        let button = BaseButton()
        button.setTitle("Фильтры", for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.addTarget(self, action: #selector(filterButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func filterButtonDidTap() {
        delegate?.filterButtonDidTap()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(filterButton)
        
        filterButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(105)
            make.height.equalTo(30)
        }
    }
}

final class MainViewController: BaseViewController {
    
    private var viewModel: MainViewModelProtocol!
    private let dataManager = DataManager.shared
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: "ItemCell")
        return collectionView
    }()
    
    private let cellSpacing: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        
        title = "Main"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupSearchController()
        setupUI()
    
    }

    
    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search"
        
        self.navigationItem.searchController = searchController
        
        self.definesPresentationContext = false
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    
    private func bindViewModel() {
        viewModel = MainViewModel(dataManager: dataManager)
        viewModel.fetchProductsFromServer { [weak self] result in
            switch result {
            case .success:
                self?.collectionView.reloadData()
            case .failure(let error):
                print("Error: \(error)")
            }
            self?.collectionView.reloadData()
        }
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        setupHeaderView()
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupHeaderView() {
        collectionView.register(FilterHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FilterHeader")
    }
    

}


// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let itemDetailsViewModel = viewModel.getProductsDetailsViewModel(at: indexPath)
        let itemDetailsVC = ItemDetailsViewController(viewModel: itemDetailsViewModel)
        present(itemDetailsVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FilterHeader", for: indexPath) as! FilterHeader
        
        headerView.delegate = self

        return headerView
    }
    

}


// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as? ItemCell else {
            return UICollectionViewCell()
        }
        cell.viewModel = viewModel.getProductsCellViewModel(at: indexPath)
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 30)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 16
        let collectionViewWidth = collectionView.bounds.width
        let width = (collectionViewWidth - 3 * spacing) / 2
        let height = width * 1.35
        return CGSize(width: width, height: height)
    }
    
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults (for searchController: UISearchController) {
        print(searchController.searchBar.text)
    }
}

extension MainViewController: FilterHeaderDelegate {
    func filterButtonDidTap() {
        let filterVC = FilterViewController()
        present(filterVC, animated: true)
    }
}
