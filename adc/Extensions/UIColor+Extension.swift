import UIKit

extension UIColor {
    static var primary: UIColor {
        UIColor(hex: 0x4DE87D) // зеленый
    }

    static var background: UIColor {
        UIColor(hex: 0x111216)
    }

    static var tabbar: UIColor {
        UIColor(hex: 0x272831)
    }

    static var placeholderText: UIColor {
        UIColor(hex: 0x939398)
    }

    static var darkText: UIColor {
        UIColor(hex: 0x15171D)
    }

    static var darkTextButton: UIColor {
        UIColor(hex: 0x1F1F23) // на кнопке подписаться/отписаться в профиле
    }

    static var textFieldBackground: UIColor {
        UIColor(hex: 0x31323E)
    }

    static var unsubscribe: UIColor {
        UIColor(hex: 0x474A5A)
    }

    static var errorRed: UIColor {
        UIColor(hex: 0xFF4444) // цвет при ошибке в текстовом поле на экране входа
    }

    static var secondaryText: UIColor {
        UIColor(hex: 0x8A8B8E) // лейбл с кол-вом друзей на экране профиля
    }

    static var loginText: UIColor {
        UIColor(hex: 0x1A1C22) // кнопка "войти" на экране входа
    }
    
    static var registrationButton: UIColor {
        UIColor(hex: 0x1D1E25) // кнопка регистрации на экране входа
    }
}


fileprivate extension UIColor {
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
