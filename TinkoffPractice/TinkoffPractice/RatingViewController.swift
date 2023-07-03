import UIKit

class RatingViewController: UIViewController {
    // Рейтинг по умолчанию
    private var rating = 0
    // Массив звезд
    private var stars: [UIImageView]!
    // UIStackView для звезд
    private var starsStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        // Создаем звезды
        createStars()
        
        // Устанавливаем звезды по центру экрана
        starsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        starsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    private func createStars() {
        // Создаем звезды
        let star1 = createStarView()
        let star2 = createStarView()
        let star3 = createStarView()
        let star4 = createStarView()
        let star5 = createStarView()
        
        stars = [star1, star2, star3, star4, star5]
        
        // Создаем UIStackView
        starsStackView = UIStackView(arrangedSubviews: stars)
        starsStackView.axis = .horizontal
        starsStackView.distribution = .fillEqually
        starsStackView.alignment = .fill
        starsStackView.spacing = 10
        starsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(starsStackView)
    }

    private func createStarView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(systemName: "star"))
        imageView.tintColor = .black
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(starTapped(_:))))
        imageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return imageView
    }

    @objc private func starTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedStar = sender.view as? UIImageView,
              let index = stars.firstIndex(of: tappedStar) else { return }
        
        // Устанавливаем рейтинг
        rating = index + 1
        
        // Обновляем отображение звезд
        for (index, star) in stars.enumerated() {
            star.image = UIImage(systemName: index < rating ? "star.fill" : "star")
            star.tintColor = index < rating ? .systemYellow : .black
        }
        
        // Тут вы можете использовать значение рейтинга, как вам нужно
        print("Rating is now \(rating)")
    }
}
