# 🪟 Windows Setup Guide

**Complete Windows instructions for running the Wine API Processor!** 🚀

This guide is specifically designed for **Windows users** (like Eric!) and focuses on the **easiest setup method** for Windows.

## 🎯 **Why Node.js is Best for Windows**

### **✅ Node.js Advantages on Windows:**
- **One-click installer** - Download and run
- **No virtual environments** - Everything works out of the box
- **Modern package manager** - `npm install` handles dependencies
- **Better Windows support** - Designed for cross-platform use
- **Faster execution** - No Python environment setup delays

### **❌ Python Challenges on Windows:**
- **Virtual environment setup** - More complex on Windows
- **Dependency conflicts** - Can be tricky with Windows paths
- **PATH issues** - Common Windows problem
- **Multiple Python versions** - Can cause confusion

## 🚀 **How to Run (Node.js Only)**

### **Interactive Mode (Recommended)**
Just run the script without arguments and follow the prompts:

```bash
node wine_api_processor.js
```

### **Command Line Mode**
Specify all parameters directly:

```bash
# Basic usage:
node wine_api_processor.js "Frenchie 10 Wines - Simple.csv"

# With all options:
node wine_api_processor.js --csv-file "wines.csv" --api-key "my_key" --api-url "https://api.com"

# With mock pricing for testing:
node wine_api_processor.js --csv-file "wines.csv" --enable-mock-pricing
```

## 📋 **Prerequisites**

### **Required Software:**
- **Node.js 14+** (LTS version recommended)
- **Windows 10/11** (Windows 8.1+ also works)

### **Installation:**
- 🟢 **Node.js**: https://nodejs.org/ (download the LTS version)
- **During installation**: Check "Add to PATH" option

## 🔧 **Setup Steps**

### **Step 1: Download the Project**
1. Download the entire `pinot-noir-code` folder
2. Extract it to a location like `C:\Users\Eric\Desktop\pinot-noir-code\`
3. Open Command Prompt in that folder

### **Step 2: Install Dependencies**
```cmd
npm install
```

### **Step 3: Run the Processor**
```cmd
# Interactive mode (recommended for first time):
node wine_api_processor.js

# Or with a specific CSV file:
node wine_api_processor.js "Frenchie 10 Wines - Simple.csv"
```

## 📱 **What Happens When You Run It**

### **Interactive Mode:**
1. **CSV File**: You'll be asked for the path to your wine CSV file
2. **API Key**: Enter your API key (or use the default for testing)
3. **API URL**: Enter your API endpoint (or use the default for testing)
4. **Mock Pricing**: Choose whether to enable fake prices for testing
5. **Confirmation**: Review your settings and confirm
6. **Processing**: The script processes your wines and saves results

### **Command Line Mode:**
- Specify everything upfront for automation
- Perfect for running the same configuration multiple times

## 🚨 **Common Windows Issues & Solutions**

### **"Node is not recognized"**
- **Solution**: Reinstall Node.js and check "Add to PATH" during installation
- **Verify**: Open Command Prompt and type `node --version`

### **"npm is not recognized"**
- **Solution**: Node.js installer should include npm. If not, reinstall Node.js
- **Verify**: Type `npm --version` in Command Prompt

### **"Permission Denied"**
- **Solution**: Right-click Command Prompt → "Run as Administrator"
- **Alternative**: Run from your user folder instead of Program Files

### **"File not found"**
- **Solution**: Make sure you're in the right directory
- **Check**: Type `dir` to see if `wine_api_processor.js` and other files are visible

### **"Cannot find module"**
- **Solution**: Run `npm install` in the project folder
- **Verify**: Check that `node_modules` folder exists

## 🎭 **Mock Pricing Feature**

### **What It Does:**
- Generates realistic fake prices for testing
- Prices vary based on wine vintage
- Only enabled when you choose to use it

### **When to Use:**
- **✅ Testing**: Enable mock pricing to see how the system works
- **❌ Production**: Disable mock pricing for real wine data

### **How to Control:**
```bash
# Enable for testing:
node wine_api_processor.js --enable-mock-pricing

# Disable for production (default):
node wine_api_processor.js
```

## 📊 **Example Output**

After processing, you'll get a results CSV file like:
```
Row,Wine Name,Vintage,Status,Timestamp
2,Test Wine 1,2015,Success,2025-08-27 18:04:46
3,Test Wine 2,2020,Success,2025-08-27 18:04:47
4,Test Wine 3,1995,Success,2025-08-27 18:04:47
```

## 🚀 **Pro Tips for Windows Users**

### **File Paths:**
- Use quotes around file paths with spaces: `"My Wines.csv"`
- You can drag and drop files into Command Prompt
- Use backslashes or forward slashes: `C:\Users\Eric\Desktop\wines.csv`

### **CSV Files:**
- Make sure your CSV has headers: `Wine Name,Vintage`
- Handle BOM characters automatically (the script does this for you)
- Use UTF-8 encoding for best compatibility

### **Performance:**
- Node.js is fast and efficient on Windows
- No need to worry about virtual environments or Python versions
- Dependencies are managed automatically by npm

## 🎯 **Ready to Start?**

1. **Install Node.js** from https://nodejs.org/
2. **Download the project** files
3. **Open Command Prompt** in the project folder
4. **Run `npm install`** to get dependencies
5. **Run `node wine_api_processor.js`** to start processing!

## 🆘 **Need Help?**

- **Check the logs**: The script shows detailed information as it runs
- **Verify your CSV**: Make sure it has the right format
- **Check Node.js**: Ensure it's properly installed and in your PATH
- **Review the [Node.js guide](nodejs.md)**: More detailed technical information

**Eric, you now have everything you need to run the wine processor on Windows with Node.js!** 🎯

The Node.js approach is much simpler than Python on Windows - no virtual environments, no dependency conflicts, just install and run! 🚀

**🍷 Happy wine processing on Windows!** 🪟✨
