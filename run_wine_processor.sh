#!/bin/bash

# Wine API Processor Runner Script
# Usage: ./run_wine_processor.sh [python|node] [csv-file] [api-key] [api-url]

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_question() {
    echo -e "${PURPLE}[QUESTION]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check Python setup
check_python() {
    if ! command_exists python3; then
        print_error "Python 3 is not installed or not in PATH"
        print_warning "Please install Python 3 and try again"
        exit 1
    fi
    
    if [ ! -f "wine_api_processor.py" ]; then
        print_error "wine_api_processor.py not found in current directory"
        exit 1
    fi
    
    if [ ! -f "requirements.txt" ]; then
        print_warning "requirements.txt not found - dependencies may not be installed"
    fi
    
    # Check if virtual environment exists
    if [ -d "wine_env" ]; then
        print_info "Found Python virtual environment, activating..."
        source wine_env/bin/activate
    else
        print_warning "No virtual environment found. Consider creating one:"
        print_warning "  python3 -m venv wine_env"
        print_warning "  source wine_env/bin/activate"
        print_warning "  pip install -r requirements.txt"
    fi
}

# Function to check Node.js setup
check_node() {
    if ! command_exists node; then
        print_error "Node.js is not installed or not in PATH"
        print_warning "Please install Node.js and try again"
        exit 1
    fi
    
    if [ ! -f "wine_api_processor.js" ]; then
        print_error "wine_api_processor.js not found in current directory"
        exit 1
    fi
    
    if [ ! -f "package.json" ]; then
        print_warning "package.json not found - dependencies may not be installed"
    fi
    
    # Check if node_modules exists
    if [ ! -d "node_modules" ]; then
        print_warning "Dependencies not installed. Installing now..."
        print_warning "This might take a minute..."
        npm install
        if [ $? -ne 0 ]; then
            print_error "Failed to install dependencies. Please check your internet connection."
            exit 1
        fi
        print_info "Dependencies installed successfully!"
    else
        print_info "Dependencies already installed"
    fi
}

# Function to run interactive mode
run_interactive() {
    clear
    echo ""
    echo "🎉 🍷 WELCOME TO INTERACTIVE WINE PROCESSOR! 🍷 🎉"
    echo "=================================================="
    echo ""
    print_info "I'll guide you through setting up your wine processing run!"
    echo ""
    
    # Step 1: Choose language
    print_question "Which version would you like to run?"
    echo ""
    echo "  1. 🐍 Python - Great for data processing, includes virtual environment setup"
    echo "  2. 🟢 Node.js - Fast and modern, perfect for web developers"
    echo ""
    
    local choice
    while true; do
        read -p "Enter your choice (1-2): " choice
        if [ "$choice" = "1" ] || [ "$choice" = "2" ]; then
            break
        fi
        print_error "Please enter 1 or 2"
    done
    
    if [ "$choice" = "1" ]; then
        LANGUAGE="python"
    else
        LANGUAGE="node"
    fi
    
    echo ""
    
    # Step 2: Get CSV file
    print_question "What's the path to your CSV file?"
    echo ""
    print_info "💡 Pro tip: You can drag and drop your CSV file here, then press Enter!"
    echo ""
    
    local csv_file
    while true; do
        read -p "Enter CSV file path (or drag & drop): " csv_file
        
        # Remove quotes if user dragged and dropped
        csv_file=$(echo "$csv_file" | sed 's/^"//;s/"$//')
        
        if [ -f "$csv_file" ]; then
            break
        else
            print_error "File not found: $csv_file"
            read -p "Would you like to try again? (y/n): " retry
            if [[ ! "$retry" =~ ^[Yy] ]]; then
                print_error "Exiting..."
                exit 1
            fi
        fi
    done
    
    echo ""
    
    # Step 3: API configuration
    print_question "Let's configure your API settings!"
    echo ""
    print_info "🔑 API Key: This is like a password for your API"
    print_info "🌐 API URL: The web address where your API is located"
    echo ""
    
    read -p "What's your API key? (default: test_api_key_123): " api_key
    if [ -z "$api_key" ]; then
        api_key="test_api_key_123"
    fi
    
    read -p "What's your API endpoint URL? (default: https://postman-echo.com/get): " api_url
    if [ -z "$api_url" ]; then
        api_url="https://postman-echo.com/get"
    fi
    
    echo ""
    
    # Step 4: Confirm settings
    print_info "Here's what we're about to run:"
    echo "  🐍 Language: $LANGUAGE"
    echo "  📁 CSV File: $csv_file"
    echo "  🔑 API Key: $api_key"
    echo "  🌐 API URL: $api_url"
    echo ""
    
    read -p "Does this look correct? Ready to process your wines? (Y/n): " confirm
    if [[ "$confirm" =~ ^[Nn] ]]; then
        print_warning "No problem! Let's start over..."
        echo ""
        run_interactive
        return
    fi
    
    echo ""
    print_info "✅ Let's get this wine party started! 🍷🚀"
    echo ""
    
    # Run the processor based on language choice
    if [ "$LANGUAGE" = "python" ]; then
        check_python
        print_info "Running Python version..."
        print_info "CSV: $csv_file"
        print_info "API Key: $api_key"
        print_info "API URL: $api_url"
        echo ""
        python3 wine_api_processor.py --csv-file "$csv_file" --api-key "$api_key" --api-url "$api_url"
    else
        check_node
        print_info "Running Node.js version..."
        print_info "CSV: $csv_file"
        print_info "API Key: $api_key"
        print_info "API URL: $api_url"
        echo ""
        node wine_api_processor.js --csv-file "$csv_file" --api-key "$api_key" --api-url "$api_url"
    fi
}

# Function to show usage
show_usage() {
    echo "🍷 Wine API Processor Runner"
    echo ""
    echo "Usage: $0 [python|node] [csv-file] [api-key] [api-url]"
    echo ""
    echo "Arguments:"
    echo "  python|node    Choose Python or Node.js version"
    echo "  csv-file       Path to your CSV file"
    echo "  api-key        Your API key"
    echo "  api-url        API endpoint URL"
    echo ""
    echo "Examples:"
    echo "  $0 python \"Frenchie 10 Wines - Simple.csv\" test_api_key_123 https://postman-echo.com/get"
    echo "  $0 node \"Frenchie 10 Wines - Simple.csv\" test_api_key_123 https://postman-echo.com/get"
    echo ""
    echo "Default values:"
    echo "  api-key: test_api_key_123"
    echo "  api-url: https://postman-echo.com/get"
    echo ""
    echo "Note: Use quotes around file paths with spaces"
    echo ""
    echo "💡 Pro tip: Run without arguments for interactive mode!"
}

# Main function
main() {
    # Check if help is requested
    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$1" = "help" ]; then
        show_usage
        exit 0
    fi
    
    # If no arguments, run interactive mode
    if [ $# -eq 0 ]; then
        run_interactive
        exit 0
    fi
    
    # Check if we have at least the language choice
    if [ -z "$1" ]; then
        print_error "Missing required argument: language choice (python or node)"
        echo ""
        show_usage
        exit 1
    fi
    
    LANGUAGE="$1"
    CSV_FILE="$2"
    API_KEY="${3:-test_api_key_123}"
    API_URL="${4:-https://postman-echo.com/get}"
    
    # Validate language choice
    if [ "$LANGUAGE" != "python" ] && [ "$LANGUAGE" != "node" ]; then
        print_error "Invalid language choice: $LANGUAGE"
        print_error "Must be 'python' or 'node'"
        show_usage
        exit 1
    fi
    
    # Check if CSV file is provided
    if [ -z "$CSV_FILE" ]; then
        print_error "Missing required argument: CSV file path"
        show_usage
        exit 1
    fi
    
    # Check if CSV file exists
    if [ ! -f "$CSV_FILE" ]; then
        print_error "CSV file not found: $CSV_FILE"
        exit 1
    fi
    
    # Run the processor based on language choice
    if [ "$LANGUAGE" = "python" ]; then
        check_python
        print_info "Running Python version..."
        print_info "CSV: $CSV_FILE"
        print_info "API Key: $API_KEY"
        print_info "API URL: $API_URL"
        echo ""
        python3 wine_api_processor.py --csv-file "$CSV_FILE" --api-key "$API_KEY" --api-url "$API_URL"
    else
        check_node
        print_info "Running Node.js version..."
        print_info "CSV: $CSV_FILE"
        print_info "API Key: $API_KEY"
        print_info "API URL: $API_URL"
        echo ""
        node wine_api_processor.js --csv-file "$CSV_FILE" --api-key "$API_KEY" --api-url "$API_URL"
    fi
}

# Run main function with all arguments
main "$@"
