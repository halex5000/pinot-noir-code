# 🐍 Python Setup Guide

**Complete Python instructions for running the Wine API Processor!** 🚀

This guide is specifically designed for **Python developers** and covers everything you need to get the wine processor running with Python.

## 🎯 **What You'll Get**

- ✅ **Pure Python implementation** with no external dependencies
- ✅ **Virtual environment support** for clean dependency management
- ✅ **Comprehensive logging** and error handling
- ✅ **Unit tests** included for development
- ✅ **Cross-platform compatibility** (Windows, macOS, Linux)

## 🚀 **Quick Start**

### **1. Install Dependencies**
```bash
# Create virtual environment (recommended)
python3 -m venv wine_env

# Activate virtual environment
# On macOS/Linux:
source wine_env/bin/activate
# On Windows:
wine_env\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### **2. Run the Processor**
```bash
# Basic usage with defaults
python wine_api_processor.py --csv-file "Frenchie 10 Wines - Simple.csv"

# Full custom parameters
python wine_api_processor.py \
  --csv-file "my_wines.csv" \
  --api-key "my_api_key" \
  --api-url "https://myapi.com/endpoint" \
  --rate-limit 2.0
```

## 📋 **Prerequisites**

### **Required Software:**
- **Python 3.6+** (Python 3.8+ recommended)
- **pip** (usually comes with Python)

### **Installation Links:**
- 🐍 **Python**: https://python.org/downloads/
- 📦 **pip**: Usually included with Python installation

### **Verify Installation:**
```bash
python3 --version
pip3 --version
```

## 🔧 **Setup Steps**

### **Step 1: Clone/Download the Project**
```bash
# If using git
git clone <repository-url>
cd weftful

# Or download and extract the ZIP file
cd weftful
```

### **Step 2: Set Up Virtual Environment**
```bash
# Create virtual environment
python3 -m venv wine_env

# Activate it
# macOS/Linux:
source wine_env/bin/activate
# Windows:
wine_env\Scripts\activate

# Your prompt should now show (wine_env)
```

### **Step 3: Install Dependencies**
```bash
# Install from requirements.txt
pip install -r requirements.txt

# Verify installation
pip list
```

### **Step 4: Test Your Setup**
```bash
# Run with sample data
python wine_api_processor.py --csv-file "Frenchie 10 Wines - Simple.csv"
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
| `--verbose` / `-v` | Enable verbose logging | No | `False` |

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
2025-08-27 12:49:34,910 - INFO - Starting wine data processing...
2025-08-27 12:49:34,911 - INFO - CSV file: Frenchie 10 Wines - Simple.csv
2025-08-27 12:49:34,911 - INFO - API URL: https://postman-echo.com/get
2025-08-27 12:49:34,911 - INFO - Rate limit: 1.0s between calls
2025-08-27 12:49:34,911 - INFO - Processing CSV with 2 columns
2025-08-27 12:49:34,911 - INFO - CSV columns: ['Wine Name', 'Vintage']
2025-08-27 12:49:35,287 - INFO - Row 2: Successfully processed Immich Batterieberg  (2018)
2025-08-27 12:49:35,367 - INFO - Row 3: Successfully processed Chateau Anglican Granit St Lu (2009)
...
```

### **Results CSV Output:**
The script creates a new CSV file with processing results:
```csv
Row,Wine Name,Vintage,Status,Mock Price,Timestamp
2,Immich Batterieberg ,2018,Success,$38,2025-08-27 12:49:35
3,Chateau Anglican Granit St Lu,2009,Success,$28,2025-08-27 12:49:35
...
```

## 🧪 **Testing with Postman Echo**

For development and testing, use Postman's echo service:

```bash
python wine_api_processor.py \
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

### **Run Unit Tests:**
```bash
# Run all tests
python -m pytest test_processor.py

# Run with verbose output
python -m pytest test_processor.py -v

# Run specific test
python -m pytest test_processor.py::test_api_call_success -v
```

### **Interactive Testing:**
```bash
# Use the interactive test script
python test_with_postman.py
```

### **Code Structure:**
```
wine_api_processor.py
├── WineAPIProcessor class
│   ├── __init__() - Initialize with configuration
│   ├── process_csv() - Main processing logic
│   ├── _make_api_call() - Individual API calls
│   ├── _write_results_csv() - Output results
│   └── _generate_mock_price() - Mock pricing logic
└── main() - Command-line interface
```

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
python wine_api_processor.py \
  --rate-limit 2.0 \
  --csv-file "data.csv" \
  --api-key "KEY" \
  --api-url "URL"

# Make calls every 0.5 seconds (faster)
python wine_api_processor.py \
  --rate-limit 0.5 \
  --csv-file "data.csv" \
  --api-key "KEY" \
  --api-url "URL"
```

### **Verbose Logging:**
```bash
# Enable detailed logging
python wine_api_processor.py \
  --verbose \
  --csv-file "data.csv" \
  --api-key "KEY" \
  --api-url "URL"
```

### **Custom API Endpoints:**
```bash
# Use your own API
python wine_api_processor.py \
  --csv-file "wines.csv" \
  --api-key "your_secret_key" \
  --api-url "https://your-api.com/wines/insert"
```

## 📁 **File Structure**

```
weftful/
├── 🐍 wine_api_processor.py        # Main Python script
├── 📋 requirements.txt              # Python dependencies
├── 🧪 test_processor.py            # Unit tests
├── 🧪 test_with_postman.py         # Interactive testing
├── 📄 config.example.py            # Configuration template
├── 📄 README-Python.md             # This file
└── 🍷 Frenchie 10 Wines - Simple.csv # Sample wine data
```

## 🚀 **Pro Tips for Python Developers**

### **1. Use Virtual Environments**
- Keeps dependencies isolated
- Prevents conflicts with system Python
- Easy to recreate on different machines

### **2. Check Dependencies**
```bash
# See what's installed
pip list

# Check for outdated packages
pip list --outdated

# Update packages
pip install --upgrade package_name
```

### **3. Debug Mode**
```bash
# Run with Python debugger
python -m pdb wine_api_processor.py --csv-file "wines.csv"

# Or add breakpoint() in your code
```

### **4. Logging Configuration**
The script uses Python's built-in logging module. You can customize it by modifying the logging configuration in the script.

## 🆘 **Troubleshooting**

### **Common Issues:**

#### **"ModuleNotFoundError: No module named 'requests'"**
```bash
# Solution: Install dependencies
pip install -r requirements.txt
```

#### **"Permission denied"**
```bash
# Solution: Use virtual environment
python3 -m venv wine_env
source wine_env/bin/activate  # macOS/Linux
pip install -r requirements.txt
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

## 🎉 **You're All Set!**

**You now have everything you need to run the wine processor with Python!** 

The script provides:
- ✅ Professional-grade error handling
- ✅ Comprehensive logging
- ✅ Unit tests for development
- ✅ Cross-platform compatibility
- ✅ Easy configuration

**Start processing your wine data today!** 🍷🚀

---

**🐍 Happy Python wine processing!** ✨
