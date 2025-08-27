# 🟢 Node.js Setup Guide

**Complete Node.js instructions for running the Wine API Processor!** 🚀

This guide is specifically designed for **Node.js developers** and covers everything you need to get the wine processor running with Node.js.

## 🎯 **What You'll Get**

- ✅ **Windows users** (like Eric!) - No virtual environments needed!
- ✅ **Pure Node.js implementation** with modern ES6+ syntax
- ✅ **npm package management** for easy dependency handling
- ✅ **Async/await patterns** for clean asynchronous code
- ✅ **Comprehensive error handling** and logging
- ✅ **Cross-platform compatibility** (Windows, macOS, Linux)

## 🚀 **Quick Start**

### **1. Install Dependencies**
```bash
# Install Node.js dependencies
npm install

# Or if you prefer yarn
yarn install
```

### **2. Run the Processor**
```bash
# Basic usage with defaults
node wine_api_processor.js --csv-file "Frenchie 10 Wines - Simple.csv"

# Full custom parameters
node wine_api_processor.js \
  --csv-file "my_wines.csv" \
  --api-key "my_api_key" \
  --api-url "https://myapi.com/endpoint"
```

## 📋 **Prerequisites**

### **Required Software:**
- **Node.js 14+** (Node.js 16+ recommended)
- **npm** (usually comes with Node.js)

### **Installation Links:**
- 🟢 **Node.js**: https://nodejs.org/ (LTS version recommended)
- 📦 **npm**: Usually included with Node.js installation

### **Verify Installation:**
```bash
node --version
npm --version
```

## 🔧 **Setup Steps**

### **Step 1: Clone/Download the Project**
```bash
# If using git
git clone <repository-url>
cd pinot-noir-code

# Or download and extract the ZIP file
cd pinot-noir-code
```

### **Windows-Specific Notes:**
- **✅ No virtual environments needed** - Node.js works out of the box
- **✅ One-click installer** - Download from https://nodejs.org/
- **✅ Check "Add to PATH"** during Node.js installation
- **✅ Use Command Prompt** - Right-click folder → "Open Command Prompt here"

### **Step 2: Install Dependencies**
```bash
# Install from package.json
npm install

# Verify installation
npm list
```

### **Step 3: Test Your Setup**
```bash
# Run with sample data
node wine_api_processor.js --csv-file "Frenchie 10 Wines - Simple.csv"
```

## 📊 **CSV Format Requirements**

### **Required Fields:**
- `Wine Name` - Name of the wine (e.g., "Haut Brion")
- `Vintage` - Year of the wine (e.g., "1995")

### **Automatically Added Fields:**
- `currencycode` - Always "USD"
- `location` - Always "MA"
- `state` - Always "MA"
- `offer_type` - Always "sale"
- `country` - Always "USA"

### **Example CSV:**
```csv
Wine Name,Vintage
Immich Batterieberg,2018
Château Margaux,2000
Rémi Jobard,2020
```

## 🔧 **Command Line Options**

| Option | Description | Required | Default |
|--------|-------------|----------|---------|
| `--csv-file` | Path to the CSV file | Yes | - |
| `--api-key` | API key for authentication | No | `test_api_key_123` |
| `--api-url` | Base URL for the API endpoint | No | `https://postman-echo.com/get` |
| `--rate-limit` | Delay between API calls in seconds | No | `1.0` |

## 🌐 **API Request Format**

The script sends **GET requests** with the following structure:

```
GET {api_url}?api_key=YOUR_API_KEY&winename=wine+name&vintage=2020&currencycode=USD&location=MA&state=MA&offer_type=sale&country=USA
```

### **Parameters Sent:**
- `api_key` - Your API key
- `winename` - Wine name from CSV (URL encoded)
- `vintage` - Vintage year from CSV
- `currencycode` - Hardcoded to "USD"
- `location` - Hardcoded to "MA"
- `state` - Hardcoded to "MA"
- `offer_type` - Hardcoded to "sale"
- `country` - Hardcoded to "USA"

## 📝 **Logging & Output**

### **Console Output:**
```
[INFO] 2025-08-27T16:49:41.678Z - Starting wine data processing...
[INFO] 2025-08-27T16:49:41.679Z - CSV file: Frenchie 10 Wines - Simple.csv
[INFO] 2025-08-27T16:49:41.679Z - API URL: https://postman-echo.com/get
[INFO] 2025-08-27T16:49:41.679Z - Rate limit: 1s between calls
[INFO] 2025-08-27T16:49:41.679Z - Processing CSV: Frenchie 10 Wines - Simple.csv
[INFO] 2025-08-27T16:49:41.682Z - CSV columns: Wine Name, Vintage
[INFO] 2025-08-27T16:49:41.893Z - Row 2: Successfully processed Immich Batterieberg  (2018)
[INFO] 2025-08-27T16:49:42.945Z - Row 3: Successfully processed Chateau Anglican Granit St Lu (2009)
...
```

### **Results CSV Output:**
The script creates a new CSV file with processing results:
```csv
Row,Wine Name,Vintage,Status,Mock Price,Timestamp
2,Immich Batterieberg ,2018,Success,$38,2025-08-27 16:49:41
3,Chateau Anglican Granit St Lu,2009,Success,$28,2025-08-27 16:49:42
...
```

## 🧪 **Testing with Postman Echo**

For development and testing, use Postman's echo service:

```bash
node wine_api_processor.js \
  --csv-file "Frenchie 10 Wines - Simple.csv" \
  --api-key "test_api_key_123" \
  --api-url "https://postman-echo.com/get"
```

**Benefits of Postman Echo:**
- ✅ Always responds with 200 status
- ✅ Echoes back all your data
- ✅ No authentication required
- ✅ Perfect for testing and development

## 🛠️ **Development & Testing**

### **Code Structure:**
```
wine_api_processor.js
├── WineAPIProcessor class
│   ├── constructor() - Initialize with configuration
│   ├── processCSV() - Main processing logic
│   ├── makeAPICall() - Individual API calls
│   ├── writeResultsCSV() - Output results
│   ├── generateMockPrice() - Mock pricing logic
│   └── sleep() - Rate limiting utility
└── main() - Command-line interface
```

### **Key Dependencies:**
- **`axios`** - HTTP client for API calls
- **`csv-parser`** - CSV file reading
- **`csv-writer`** - CSV file writing

### **Modern JavaScript Features:**
- **Async/await** for clean asynchronous code
- **ES6+ syntax** for modern development
- **Promise-based** error handling
- **Template literals** for string formatting

## 🚨 **Error Handling**

The script handles various error scenarios gracefully:

- **Missing CSV file**: Clear error message with file path
- **Invalid CSV format**: Validation before processing
- **API failures**: Individual row failures don't stop the process
- **Network issues**: Timeout handling and retry logic
- **Missing dependencies**: Clear installation instructions

## 🔒 **Security Considerations**

- **API keys**: Passed as command-line arguments
- **HTTPS**: All API requests use HTTPS when available
- **User-Agent**: Set for identification
- **Rate limiting**: Prevents server overload

## 🚀 **Advanced Usage**

### **Custom Rate Limiting:**
```bash
# Make calls every 2 seconds
node wine_api_processor.js \
  --csv-file "data.csv" \
  --api-key "KEY" \
  --api-url "URL" \
  --rate-limit 2.0

# Make calls every 0.5 seconds (faster)
node wine_api_processor.js \
  --csv-file "data.csv" \
  --api-key "KEY" \
  --api-url "URL" \
  --rate-limit 0.5
```

### **Custom API Endpoints:**
```bash
# Use your own API
node wine_api_processor.js \
  --csv-file "wines.csv" \
  --api-key "your_secret_key" \
  --api-url "https://your-api.com/wines/insert"
```

### **Environment Variables:**
```bash
# Set environment variables
export API_KEY="your_secret_key"
export API_URL="https://your-api.com/endpoint"

# Run the script
node wine_api_processor.js --csv-file "wines.csv"
```

## 📁 **File Structure**

```
weftful/
├── 🟢 wine_api_processor.js        # Main Node.js script
├── 📦 package.json                  # Node.js dependencies
├── 📦 package-lock.json            # Dependency lock file
├── 📄 README-NodeJS.md             # This file
└── 🍷 Frenchie 10 Wines - Simple.csv # Sample wine data
```

## 🚀 **Pro Tips for Node.js Developers**

### **1. Use npm Scripts**
```json
{
  "scripts": {
    "start": "node wine_api_processor.js",
    "dev": "node --inspect wine_api_processor.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  }
}
```

### **2. Check Dependencies**
```bash
# See what's installed
npm list

# Check for outdated packages
npm outdated

# Update packages
npm update
```

### **3. Debug Mode**
```bash
# Run with Node.js debugger
node --inspect wine_api_processor.js --csv-file "wines.csv"

# Or use the dev script
npm run dev -- --csv-file "wines.csv"
```

### **4. Package Management**
```bash
# Add new dependencies
npm install package-name

# Remove dependencies
npm uninstall package-name

# Install dev dependencies
npm install --save-dev package-name
```

## 🆘 **Troubleshooting**

### **Common Issues:**

#### **"Cannot find module 'csv-parser'"**
```bash
# Solution: Install dependencies
npm install
```

#### **"Permission denied"**
```bash
# Solution: Check file permissions
ls -la wine_api_processor.js

# Or run with sudo (not recommended)
sudo npm install
```

#### **"CSV file not found"**
```bash
# Solution: Check file path and current directory
ls -la  # macOS/Linux
dir      # Windows
```

#### **"API call failed"**
- Check your internet connection
- Verify the API URL is correct
- Check if the API requires authentication
- Use Postman Echo for testing

#### **"ECONNREFUSED" or network errors**
- Check if the API endpoint is accessible
- Verify firewall settings
- Test with a simple curl command first

## 🔄 **Comparison with Python Version**

| Feature | Node.js | Python |
|---------|---------|---------|
| **Performance** | Fast V8 engine | Interpreted, but optimized |
| **Dependencies** | npm ecosystem | pip ecosystem |
| **Async handling** | Native async/await | asyncio (Python 3.7+) |
| **Memory usage** | Generally lower | Generally higher |
| **Startup time** | Fast | Slower (imports) |
| **Cross-platform** | Excellent | Excellent |
| **Learning curve** | Moderate | Easy for beginners |

## 🎉 **You're All Set!**

**You now have everything you need to run the wine processor with Node.js!** 

The script provides:
- ✅ Modern JavaScript development experience
- ✅ Professional-grade error handling
- ✅ Comprehensive logging
- ✅ Cross-platform compatibility
- ✅ Easy configuration

**Start processing your wine data today!** 🍷🚀

---

**🟢 Happy Node.js wine processing!** ✨
