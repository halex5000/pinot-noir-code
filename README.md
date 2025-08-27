# 🍷 Wine API Processor

**Process your wine data CSV files and make API calls with ease!** 🚀

## 🎯 **What It Does**

1. **📁 Reads your CSV file** (wine names, vintages, etc.)
2. **🌐 Makes API calls** to your endpoint with the data
3. **💾 Saves results** to a new CSV file
4. **📊 Provides logging** of all operations

## 📋 **CSV Format**

Your CSV should have these columns:
- **Wine Name** - The name of the wine
- **Vintage** - The year of the wine

Other fields (state, country, currency, etc.) are automatically set to sensible defaults.

## 🚀 **How to Run It**

Choose your preferred language and click through for detailed instructions:

### **🐍 Python**
[Python Setup & Usage Guide](python.md)

### **🟢 Node.js**
[Node.js Setup & Usage Guide](nodejs.md)

### **🪟 Windows**
[Windows Setup & Usage Guide](windows.md)

**Each guide will walk you through setup and running step-by-step!**

## 🔧 **API Configuration**

- **API Key:** Your authentication key
- **API URL:** Your endpoint URL
- **Rate Limiting:** Built-in delays between calls

## 💡 **Pro Tips**

- **Interactive Mode:** Run any script without arguments for guided setup
- **Defaults:** Sensible defaults for testing (Postman Echo)
- **Mock Pricing:** Use `--enable-mock-pricing` flag for testing (generates fake prices)

---

**For Eric on Windows:** Just double-click `run_wine_processor.bat` and follow the prompts! 🎯🍷
