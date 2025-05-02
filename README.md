# 🚀 CoinLedger

An iOS application that displays the top 100 cryptocurrencies from the [CoinRanking API](https://api.coinranking.com/v2), with features like pagination, sorting, filtering, favoriting, and detailed performance charts — built using a blend of **UIKit** and **SwiftUI**.
---

## 📱 Features

### ✅ Top 100 Coins List
- Fetches and displays the **top 100 coins** using pagination (**20 coins per page**).
- Shows each coin's:
  - 🪙 Icon  
  - 📛 Name  
  - 💰 Current Price  
  - 📈 24h Performance
- Users can:
  - 🔃 **Sort** by highest price or best 24h performance  
  - ❤️ **Swipe left** to favorite a coin using native gesture support

### ✅ Cryptocurrency Details
- On selection of a coin, navigates to a **detailed view** showing:
  - 📛 Name  
  - 📊 Performance chart (interactive)  
  - 🔁 Chart filtering options (e.g., 24h, 7d, 30d, 1y)  
  - 💸 Current price  
  - 📉 Additional statistics like market cap, volume, supply

### ✅ Favorites Screen
- Shows a list of **favorited coins**
- User can:
  - Tap to view coin details  
  - Swipe left to **unfavorite**

---

## 🛠️ Installation

### Prerequisites
- Xcode 16+
- Swift 5.9+
- iOS 16.0+

### Steps
1. Clone the repository:
   ```bash
   git clone git@github.com:gichukipaul/CoinLedger.git
   cd CoinLedger
   ```

2. Open in Xcode:
   ```bash
   open CoinLedger.xcodeproj
   ```

3. Build and run the app on a simulator or real device.

4. Add your API key in `App/Info.plist`:
   ```xml
    <key>coinAPIKey</key>
    <string>REPLACE THIS WITH YOUR KEY</string>
   ```

---

## 🧠 Assumptions & Design Decisions

- Pagination is done **client-side**, as the full data is fetched at once for simplicity.
- Coin details and favorites are persisted using **CoreData**.
- Used **SwiftUI** for reusable components (like coin cells, buttons, chart view), and **UIKit** for navigation-heavy screens and complex table behaviors.

---

## 🧪 Testing

- Unit tests included for:
  - API service layer (mocked responses)

Run all tests via `Product > Test` or `Cmd + U`.

---

## 🎨 UI/UX Highlights

- Responsive and **dark-mode compatible UI**
- Smooth animations using `withAnimation` and `UIView.transition`
- Performance chart implemented using **Swift Charts**
- Multiple filters for coin details screen: Line,Bar and Area charts to select: 1h, 3h, 12h,
24h, 7d, 30d, 3m, 1y, 3y and 5y time periods to select from.

---

## 🚧 Challenges & Solutions

| Challenge | Solution |
|----------|----------|
| Combining SwiftUI and UIKit | Used `UIHostingController` to embed SwiftUI inside UIKit scenes cleanly |
| Managing favorites persistently | Created a lightweight `FavoritesManager` using `Codable` + `CoreData` |

---

## 🧩 Technologies Used

- `UIKit` (main screens, navigation)
- `SwiftUI` (coin cell, detail views, performance charts)
- `Swift Charts` (performance graph)
- `Async await` (reactive UI updates)
- `CoreData` (favorites persistence)
- `URLSession` (API integration)

---

## 📄 License

MIT License © 2025 Paul Gichuki.
- see the LICENSE file for details.
