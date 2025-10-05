
# CryptoTicker

[![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-macOS%2014.0+-blue.svg)](https://developer.apple.com/macos/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A simple and elegant macOS menu bar application for tracking cryptocurrency prices in real-time. Built with SwiftUI and designed to be lightweight and unobtrusive.

## ✨ Features

- 🔍 **Live Price Tracking**: Real-time cryptocurrency price updates in your menu bar
- 🔄 **Auto-Update**: Automatic price refreshes every 2 minutes (can be toggled)
- ⚙️ **Customizable Coin List**: Add, remove, and reorder your favorite cryptocurrencies
- 🎨 **Native macOS Design**: Clean SwiftUI interface that follows macOS design guidelines
- 🔘 **Manual Refresh**: Instant price updates with a single click
- 📊 **Price Change Indicators**: Visual indicators for price movements (up/down)
- 🌐 **Reliable Data Source**: Powered by the trusted CoinGecko API
- 💾 **Persistent Settings**: Your coin preferences are saved between app launches

## 🚀 Getting Started

### Prerequisites

- macOS 14.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/CryptoTicker.git
   cd CryptoTicker
   ```

2. **Open in Xcode**
   ```bash
   open CryptoTicker.xcodeproj
   ```

3. **Build and Run**
   - Select the `CryptoTicker` scheme
   - Press `Cmd+R` or click the Run button
   - The app will appear in your menu bar with a Bitcoin icon

### Manual Setup (Alternative)

If you prefer to set up the project manually:

1. Open Xcode and create a new macOS project
2. Choose "App" template with SwiftUI interface
3. Name your project `CryptoTicker`
4. Copy all `.swift` files from this repository into your project
5. Build and run

## 🖥️ Usage

1. **Launch the app** - CryptoTicker will appear in your menu bar
2. **Click the Bitcoin icon** to open the price dashboard
3. **View current prices** for your selected cryptocurrencies
4. **Toggle auto-updates** using the timer button (updates every 2 minutes)
5. **Refresh manually** using the refresh button anytime
6. **Customize your list** using the settings interface

## 🏗️ Architecture

This project follows clean architecture principles:

- **SwiftUI Views**: Modern declarative UI framework
- **MVVM Pattern**: Clean separation of concerns
- **Combine Framework**: Reactive programming for data updates
- **UserDefaults**: Lightweight persistence for user preferences
- **URLSession**: Native networking for API calls

## 🔧 Configuration

The app uses sensible defaults but can be customized:

- **Default Coins**: Bitcoin (BTC), Ethereum (ETH), Solana (SOL)
- **Auto-Update**: Enabled by default, updates every 2 minutes
- **Update Frequency**: Automatic every 2 minutes + manual refresh available
- **Data Persistence**: Coin preferences and settings stored in UserDefaults

## 🌐 API Reference

CryptoTicker uses the [CoinGecko API](https://www.coingecko.com/en/api/documentation) for cryptocurrency data:

- **Endpoint**: `/api/v3/simple/price`
- **Rate Limits**: Respected automatically
- **Free Tier**: No API key required
- **Data**: Live prices, 24h changes, market data

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [CoinGecko](https://www.coingecko.com/) for providing free cryptocurrency data
- Apple for the excellent SwiftUI framework
- The cryptocurrency community for inspiration

## 📞 Support

If you encounter any issues or have questions:

- 🐛 **Bug Reports**: [Open an issue](https://github.com/yourusername/CryptoTicker/issues)
- 💡 **Feature Requests**: [Start a discussion](https://github.com/yourusername/CryptoTicker/discussions)
- 📧 **Contact**: [your.email@example.com](mailto:your.email@example.com)

---

<p align="center">Made with ❤️ for the macOS community</p>
