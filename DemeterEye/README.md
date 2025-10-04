# DemeterEye - Farming Satellite Data App

A SwiftUI app for farmers to monitor their fields using satellite data. The app features a clean, minimal, farmer-friendly design with earthy color tones and large readable text.

## Features

### 🔐 Authentication
- Clean login screen with email/password fields
- DemeterEye branding with eye icon
- Demo mode toggle for testing without API
- Error handling and loading states

### 🌾 Fields Management
- List view of all user fields
- Each field shows:
  - Thumbnail map with field boundary
  - Field name, crop type, and area
  - Clickable entries leading to details

### 📊 Field Details
- Interactive map with highlighted field polygon
- Summary cards showing:
  - Season start date and comparison to average
  - Peak NDVI value and date
  - Comparison to long-term average
  - Yield forecast with confidence level

## Architecture

### Data Models
- `Field`: Complete field data structure matching API
- `User`: User authentication model
- `AuthRequest/AuthResponse`: Authentication data transfer objects

### Network Layer
- `DemeterService`: Centralized API service with authentication
- Async/await pattern for all network calls
- Error handling with custom error types
- Demo mode support with mock data

### UI Components
- `LoginView`: Authentication screen
- `FieldsListView`: Fields overview with search and refresh
- `FieldDetailView`: Detailed field information
- `SummaryCardView`: Reusable card component

### Design System
- `DemeterDesignSystem`: Color palette and custom styles
- Earthy colors: greens, browns, light beige
- Custom text field and button styles
- Consistent spacing and typography

## API Integration

The app connects to the DemeterEye API:
- Base URL: `https://demetereye-api-1060536779509.us-central1.run.app/api`
- Authentication: Bearer token
- Endpoints:
  - `POST /auth/register` - User registration
  - `GET /fields` - Fetch user fields

## Usage

1. **Demo Mode**: Toggle demo mode in login screen to test with mock data
2. **Production**: Use real credentials to connect to the API
3. **Navigation**: 
   - Login → Fields List → Field Details
   - Pull to refresh fields list
   - Tap field cards to view details
   - Use back navigation in detail view

## Key SwiftUI Features Used

- `NavigationStack` for navigation
- `MapKit` integration with polygons and camera bounds
- `@StateObject` and `@ObservableObject` for MVVM pattern
- `@MainActor` for UI updates
- `Task` and async/await for network calls
- Custom `TextFieldStyle` and `ButtonStyle`
- Sheet presentation for detail views
- Pull to refresh functionality

## Color Scheme

- **Primary Green**: RGB(0.2, 0.6, 0.2) - Main brand color
- **Brown**: RGB(0.6, 0.4, 0.2) - Earthy accent
- **Beige**: RGB(0.96, 0.94, 0.9) - Light background
- **Background**: RGB(0.98, 0.98, 0.96) - Main background

This creates a farmer-friendly interface that's both functional and visually appealing while maintaining the clean, minimal aesthetic requested.