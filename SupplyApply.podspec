Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '12.0'
s.name = "SupplyApply"
s.summary = "SupplyApply lets a user select an ice cream flavor."
s.static_framework = true

# 2
s.version = "1.0.0"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "ayushkumar8286" => "ayushkumar8286@gmail.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/AyushKumar8286"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/AyushKumar8286/SupplyApplyPod26.git",
             :tag => "#{s.version}" }

# 7
s.framework = "UIKit"
s.dependency 'Alamofire', '5.0.0-beta.2'
s.dependency 'AppCenter'
s.dependency 'NVActivityIndicatorView'
s.dependency 'Nuke'
s.dependency 'IQKeyboardManagerSwift'
s.dependency 'GoogleMaps'
s.dependency 'DropDown'
s.dependency 'Stripe'

# 8
s.source_files = 'SupplyApply/Model/**/*.{swift}', 'SupplyApply/Data/**/*.{swift}', 'SupplyApply/Model/APIClient/**/*.{swift}', 'SupplyApply/Constants/**/*.{swift}', 'SupplyApply/Helpers/**/*.{swift}','SupplyApply/Helpers/**/*.{swift}','SupplyApply/Routing/**/*.{swift}','SupplyApply/Screens/CustomViewController/**/*.{swift}','SupplyApply/Screens/CustomViewController/ViewTemplates/AnimatedAppTabBar/**/*.{swift,xib}', 'SupplyApply/Screens/Splash/**/*.{swift,xib}', 'SupplyApply/Screens/Authentication/Signin/**/*.{swift,xib}', 'SupplyApply/Screens/Authentication/Signup/**/*.{swift,xib}',
    'SupplyApply/Screens/Authentication/LicenseValidation/**/*.{swift,xib}', 'SupplyApply/Screens/Authentication/ForgotPassword/**/*.{swift,xib}', 'SupplyApply/Screens/Dashboard/**/*.{swift,xib}', 'SupplyApply/Screens/Dashboard/ProductList/**/*.{swift,xib}','SupplyApply/Screens/Dashboard/ProductList/ProductCell/**/*.{swift,xib}',
    'SupplyApply/Screens/Dashboard/SubCategories/**/*.{swift,xib}', 'SupplyApply/Screens/Dashboard/SubCategories/SubCategoryCells/SortCell/**/*.{swift,xib}', 'SupplyApply/Screens/Dashboard/SubCategories/SubCategoryCells/ProductCell/**/*.{swift,xib}', 'SupplyApply/Screens/Dashboard/SubCategories/SubCategoryCells/SubCategoryCell/**/*.{swift,xib}', 'SupplyApply/Screens/Dashboard/CategoryCell/**/*.{swift,xib}', 'SupplyApply/Screens/Chat/**/*.{swift,xib}', 'SupplyApply/Screens/DealOfTheDay/**/*.{swift,xib}', 'SupplyApply/Screens/DealOfTheDay/DealofDayCell/**/*.{swift,xib}', 'SupplyApply/Screens/CartController/**/*.{swift,xib}', 'SupplyApply/Screens/CartController/CartCell/**/*.{swift,xib}', 'SupplyApply/Screens/SearchAndFilter/**/*.{swift,xib}', 'SupplyApply/Screens/SearchAndFilter/SearchCell/**/*.{swift,xib}', 'SupplyApply/Screens/Checkout/**/*.{swift,xib}', 'SupplyApply/Screens/Checkout/OrderSummaryCell/**/*.{swift,xib}', 'SupplyApply/Screens/Checkout/CheckoutCell/**/*.{swift,xib}', 'SupplyApply/Screens/Checkout/ShippingCell/**/*.{swift,xib}', 'SupplyApply/Screens/Settings/**/*.{swift,xib}', 'SupplyApply/Screens/Settings/SettingsCell/**/*.{swift,xib}',
       'SupplyApply/Screens/Settings/MyAccount/**/*.{swift,xib}', 'SupplyApply/Screens/Settings/MyOrder/**/*.{swift,xib}', 'SupplyApply/Screens/Settings/MyOrder/MyOrderCell/**/*.{swift,xib}', 'SupplyApply/Screens/Settings/Notification/**/*.{swift,xib}', 'SupplyApply/Screens/Settings/Notification/NoticationCell/**/*.{swift,xib}', 'SupplyApply/Screens/Settings/AboutUs/**/*.{swift,xib}', 'SupplyApply/Screens/Settings/FAQ/**/*.{swift,xib}', 'SupplyApply/Fonts/Raleway/**/*.{ttf,txt}'


# 9
#s.resources = "SupplyApply/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,pdf}"


# 10

s.swift_versions = "5.0"

end
