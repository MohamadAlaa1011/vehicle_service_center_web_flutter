# Vehicle Service Center - Flutter Web App

A modern, responsive Flutter web application for the Vehicle Service Center Management System. This frontend integrates seamlessly with the NestJS backend API to provide a complete solution for managing vehicle service operations.

## 🚀 Features

### ✅ Currently Implemented

- **Authentication System**
  - Secure login with JWT tokens
  - Automatic token refresh
  - Role-based access control
  - Session management

- **Modern UI/UX Design**
  - Clean, professional interface
  - Responsive design for all screen sizes
  - Modern Material Design 3 components
  - Consistent theming and branding

- **Dashboard**
  - Real-time statistics and KPIs
  - Revenue charts and analytics
  - Recent activities feed
  - System alerts and notifications
  - Quick action buttons

- **Customer Management**
  - Customer listing with search and pagination
  - Add new customers
  - Customer details view
  - Customer cards with actions

- **Navigation & Layout**
  - Professional sidebar navigation
  - Dynamic page titles
  - User profile management
  - Logout functionality

### 🔄 Coming Soon

- **Vehicle Management**
- **Service Orders**
- **Parts Inventory**
- **Invoice Management**
- **Reports & Analytics**
- **Settings & Configuration**

## 🛠 Technical Stack

- **Framework**: Flutter 3.41.9
- **State Management**: Riverpod 2.4.0
- **Routing**: Go Router 12.0.0
- **HTTP Client**: Dio 5.3.0
- **Storage**: Flutter Secure Storage 9.0.0
- **UI Components**: Material Design 3
- **Typography**: Google Fonts (Inter)
- **Charts**: FL Chart 0.66.0

## 🏗 Architecture

```
lib/
├── core/
│   ├── api/           # API service and HTTP client
│   ├── constants/     # App constants and configurations
│   ├── router/        # Route definitions and navigation
│   └── theme/         # App theming and design system
├── features/
│   ├── auth/          # Authentication screens and logic
│   ├── dashboard/     # Dashboard screens and widgets
│   ├── customers/     # Customer management
│   └── vehicles/      # Vehicle management
└── shared/
    ├── models/        # Data models and DTOs
    ├── widgets/       # Reusable UI components
    └── providers/     # Global state providers
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.13.0 or higher
- Chrome browser (for web development)
- NestJS backend running on localhost:3000 or Cloudflare Tunnel

### Installation

1. **Clone and install dependencies:**
   ```bash
   cd vehicle_service_center_web
   flutter pub get
   ```

2. **Configure API endpoint:**
   The app is pre-configured for the Bonto production API in `lib/core/constants/api_constants.dart`:
   ```dart
   static const String bontoBaseUrl = 'https://vsc-api.bonto.run/api/v1';
   static const String baseUrl = bontoBaseUrl;

   // For local development, switch to:
   // static const String baseUrl = localBaseUrl;
   ```

3. **Run the application:**
   ```bash
   flutter run -d chrome
   ```

### Default Login Credentials

```
Email: admin@vehicleservice.com
Password: Password@123
```

## 📱 Screenshots & Features

### Login Screen
- Clean, professional login interface
- Pre-filled demo credentials
- Secure authentication with JWT
- Responsive design

### Dashboard
- Real-time KPI cards (customers, orders, revenue, vehicles)
- Revenue analytics chart
- Recent activities feed
- System alerts panel
- Quick action buttons

### Customer Management
- Grid view of customer cards
- Search functionality
- Pagination support
- Add new customer dialog
- Customer detail views

### Navigation
- Professional sidebar with icons
- Dynamic page titles
- User profile display
- Role-based menu items

## 🔧 Configuration

### API Integration

The app is configured to work with your NestJS backend:

- **Authentication**: `/auth/login`, `/auth/refresh`
- **Dashboard**: `/dashboard/stats`, `/dashboard/alerts`
- **Customers**: `/customers` (CRUD operations)
- **Service Orders**: `/service-orders`
- **And more...**

### State Management

Using Riverpod for:
- Authentication state
- API data caching
- Loading states
- Error handling

### Responsive Design

The app is fully responsive:
- **Desktop**: Full sidebar navigation
- **Tablet**: Adaptive layout
- **Mobile**: Bottom navigation (planned)

## 🎨 Design System

### Colors
- **Primary**: Blue (#2563EB)
- **Secondary**: Green (#10B981)
- **Success**: Green (#10B981)
- **Warning**: Amber (#F59E0B)
- **Error**: Red (#EF4444)

### Typography
- **Font Family**: Inter (Google Fonts)
- **Sizes**: From 10px (label small) to 32px (display large)
- **Weights**: 400 (normal) to 700 (bold)

### Components
- Cards with subtle borders
- Rounded corners (8px buttons, 12px cards)
- Consistent spacing scale (4, 8, 16, 24, 32, 48px)
- Modern button styles with proper states

## 🔒 Security Features

- **JWT Token Management**: Automatic refresh and storage
- **Secure Storage**: Encrypted token storage
- **Route Protection**: Authentication-based redirects
- **Error Handling**: Proper API error handling
- **HTTPS Ready**: Works with SSL/TLS

## 📈 Performance

- **Fast Loading**: Optimized Flutter web build
- **Caching**: API response caching with Riverpod
- **Efficient Rendering**: Lazy loading for lists
- **Image Optimization**: Cached network images

## 🧪 Development

### Running in Development
```bash
flutter run -d chrome --dart-define=ENVIRONMENT=development
```

### Building for Production
```bash
flutter build web --release
```

### Code Generation (if needed)
```bash
flutter packages pub run build_runner build
```

## 📦 Deployment

The app can be deployed to:
- **Firebase Hosting**
- **Netlify**
- **Vercel**
- **GitHub Pages**
- **Any static hosting service**

## 🤝 Integration with NestJS Backend

This Flutter web app is designed to work perfectly with the Vehicle Service Center NestJS backend:

1. **Shared Data Models**: Matching DTOs and entities
2. **API Compatibility**: Full REST API integration
3. **Authentication**: JWT token-based auth
4. **Real-time Updates**: Polling for live data
5. **Error Handling**: Consistent error responses

## 🔮 Future Enhancements

- **Real-time Updates**: WebSocket integration
- **Offline Support**: PWA capabilities
- **Mobile App**: Flutter mobile version
- **Advanced Analytics**: More charts and reports
- **Notification System**: Push notifications
- **Multi-language**: i18n support
- **Dark Theme**: Theme switching

## 📞 Support

For issues, questions, or contributions:
1. Check the NestJS backend is running
2. Verify API endpoints are accessible
3. Check browser console for errors
4. Ensure Flutter version compatibility

---

**Built with ❤️ using Flutter & NestJS**