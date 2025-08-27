# 🪟 Windows Setup Guide

**Complete Windows instructions for running the Wine API Processor!** 🚀

This guide is specifically designed for **Windows users** (like Eric!) and covers everything you need to get the wine processor running on your Windows machine.

## 🎯 **What You'll Get**

- ✅ **Two Windows script options** (Command Prompt + PowerShell)
- ✅ **Automatic setup** - scripts handle everything for you
- ✅ **Same functionality** as macOS/Linux versions
- ✅ **Professional error handling** with clear instructions

## 🚀 **Quick Start - Choose Your Script**

### **Option 1: PowerShell (Recommended) 🟦**
```powershell
.\run_wine_processor.ps1 python "Frenchie 10 Wines - Simple.csv"
.\run_wine_processor.ps1 node "Frenchie 10 Wines - Simple.csv"
```

### **Option 2: Command Prompt 🖥️**
```cmd
run_wine_processor.bat python "Frenchie 10 Wines - Simple.csv"
run_wine_processor.bat node "Frenchie 10 Wines - Simple.csv"
```

## 📋 **Prerequisites**

### **Required Software:**
- **Python 3.6+** OR **Node.js 14+** (you only need one!)
- **Windows 10/11** (Windows 8.1+ also works)

### **Installation Links:**
- 🐍 **Python**: https://python.org/downloads/ (check "Add to PATH" during install)
- 🟢 **Node.js**: https://nodejs.org/ (LTS version recommended)

## 🔧 **Setup Steps**

### **Step 1: Download the Project**
1. Download the entire `weftful` folder
2. Extract it to a location like `C:\Users\Eric\Desktop\weftful\`
3. Open Command Prompt or PowerShell in that folder

### **Step 2: Choose Your Language**

#### **🐍 Python Version (Recommended for beginners):**
```cmd
# Install Python dependencies
pip install -r requirements.txt

# Run with Python
.\run_wine_processor.ps1 python "Frenchie 10 Wines - Simple.csv"
```

#### **🟢 Node.js Version (Great for web developers):**
```cmd
# Install Node.js dependencies
npm install

# Run with Node.js
.\run_wine_processor.ps1 node "Frenchie 10 Wines - Simple.csv"
```

## 📱 **Script Options Explained**

### **PowerShell Script (`.ps1`) - RECOMMENDED**
- **✅ Modern Windows approach**
- **✅ Parameter validation**
- **✅ Beautiful colored output**
- **✅ Smart error handling**

### **Command Prompt Script (`.bat`)**
- **✅ Works on all Windows versions**
- **✅ Simple and reliable**
- **✅ No execution policy issues**

## 🚨 **Common Windows Issues & Solutions**

### **"Execution Policy" Error (PowerShell)**
```powershell
# Run this once to allow script execution
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Then run your script
.\run_wine_processor.ps1 python "wines.csv"
```

### **"Python/Node not found"**
- **Solution**: Reinstall Python/Node.js and check "Add to PATH" during installation
- **Verify**: Open Command Prompt and type `python --version` or `node --version`

### **"Permission Denied"**
- **Solution**: Right-click Command Prompt/PowerShell → "Run as Administrator"
- **Alternative**: Run from your user folder instead of Program Files

### **"File not found"**
- **Solution**: Make sure you're in the right directory
- **Check**: Type `dir` to see if `wine_api_processor.py` and other files are visible

## 🎯 **Usage Examples**

### **Basic Usage (Uses Defaults):**
```powershell
# Python version with default API settings
.\run_wine_processor.ps1 python "my_wines.csv"

# Node.js version with default API settings
.\run_wine_processor.ps1 node "wine_list.csv"
```

### **Custom API Settings:**
```powershell
# Custom API key and URL
.\run_wine_processor.ps1 python "wines.csv" "my_secret_key" "https://myapi.com/endpoint"

# Node.js with custom settings
.\run_wine_processor.ps1 node "wines.csv" "my_secret_key" "https://myapi.com/endpoint"
```

### **Command Prompt Examples:**
```cmd
# Python version
run_wine_processor.bat python "my_wines.csv"

# Node.js version
run_wine_processor.bat node "wine_list.csv"

# Custom settings
run_wine_processor.bat python "wines.csv" "my_key" "https://api.com/endpoint"
```

## 🌟 **What Happens When You Run It**

1. **🔍 Smart Detection** - Script checks if Python/Node.js is installed
2. **🔧 Auto-Setup** - Installs missing dependencies automatically
3. **📊 CSV Processing** - Reads your wine data file
4. **🌐 API Calls** - Makes requests to your endpoint
5. **📝 Results** - Creates a new CSV with processing results
6. **🎉 Success** - Shows summary of what was processed

## 📊 **Expected Output**

```
[INFO] 🍷 Starting Wine API Processor...
[INFO] Language: python
[INFO] CSV File: Frenchie 10 Wines - Simple.csv
[INFO] API Key: test_api_key_123
[INFO] API URL: https://postman-echo.com/get

[INFO] Found Python virtual environment, activating...
[INFO] Running Python version...
[INFO] CSV: Frenchie 10 Wines - Simple.csv
[INFO] API Key: test_api_key_123
[INFO] API URL: https://postman-echo.com/get

2025-08-27 12:49:34,910 - INFO - Starting wine data processing...
2025-08-27 12:49:34,911 - INFO - CSV file: Frenchie 10 Wines - Simple.csv
2025-08-27 12:49:34,911 - INFO - API URL: https://postman-echo.com/get
2025-08-27 12:49:34,911 - INFO - Rate limit: 1.0s between calls
2025-08-27 12:49:34,911 - INFO - Processing CSV with 2 columns
2025-08-27 12:49:34,911 - INFO - CSV columns: ['Wine Name', 'Vintage']
2025-08-27 12:49:35,287 - INFO - Row 2: Successfully processed Immich Batterieberg  (2018)
2025-08-27 12:49:35,367 - INFO - Row 3: Successfully processed Chateau Anglican Granit St Lu (2009)
...
[SUCCESS] Processing complete! 🎉
```

## 🎯 **File Structure (Windows View)**

```
C:\Users\Eric\Desktop\weftful\
├── 📄 README-Windows.md            # This file
├── 🐍 wine_api_processor.py        # Python version
├── 🟢 wine_api_processor.js        # Node.js version
├── 🪟 run_wine_processor.bat       # Command Prompt script
├── 🪟 run_wine_processor.ps1       # PowerShell script
├── 📋 requirements.txt              # Python dependencies
├── 📦 package.json                  # Node.js dependencies
└── 🍷 Frenchie 10 Wines - Simple.csv # Your wine data
```

## 🚀 **Pro Tips for Windows Users**

### **1. Use PowerShell When Possible**
- More powerful than Command Prompt
- Better error messages
- Parameter validation

### **2. Check Your PATH**
- Make sure Python/Node.js are in your system PATH
- Use `python --version` to verify installation

### **3. Run as Administrator (if needed)**
- Right-click PowerShell → "Run as Administrator"
- Helps with permission issues

### **4. Use Quotes for File Paths**
- Always use quotes around file names with spaces
- Example: `"Frenchie 10 Wines - Simple.csv"`

## 🆘 **Getting Help**

### **Script Help:**
```powershell
# PowerShell help
.\run_wine_processor.ps1 --help

# Command Prompt help
run_wine_processor.bat help
```

### **Common Commands:**
```cmd
# Check Python version
python --version

# Check Node.js version
node --version

# List files in directory
dir

# Change directory
cd C:\Users\Eric\Desktop\weftful
```

## 🎉 **You're All Set!**

**Eric, you now have everything you need to run the wine processor on Windows!** 

The scripts will:
- ✅ Automatically detect your setup
- ✅ Install missing dependencies
- ✅ Handle errors gracefully
- ✅ Give you clear instructions

**Just download the folder, open PowerShell, and run the commands above!** 🚀

---

**🍷 Happy wine processing on Windows!** 🪟✨
