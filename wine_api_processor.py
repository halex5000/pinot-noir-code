#!/usr/bin/env python3
"""
Wine API Data Processor

This script reads wine data from a CSV file and makes API calls to insert the data.
It supports configurable API endpoints, error handling, and logging.
"""

import csv
import requests
import time
import logging
import argparse
import sys
from typing import Dict, List, Optional
from urllib.parse import quote_plus
import json
import os
from datetime import datetime

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('wine_api_processor.log'),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

class WineAPIProcessor:
    def __init__(self, api_key: str, base_url: str, rate_limit_delay: float = 1.0, enable_mock_pricing: bool = False):
        """
        Initialize the Wine API Processor
        
        Args:
            api_key: API key for authentication
            base_url: Base URL for the API
            rate_limit_delay: Delay between API calls in seconds
            enable_mock_pricing: Whether to generate mock prices (for testing only)
        """
        self.api_key = api_key
        self.base_url = base_url.rstrip('/')
        self.rate_limit_delay = rate_limit_delay
        self.enable_mock_pricing = enable_mock_pricing
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'WineAPIProcessor/1.0',
            'Accept': 'application/json'
        })
        
    def process_csv(self, csv_file_path: str) -> Dict[str, int]:
        """
        Process CSV file and make API calls for each row
        
        Args:
            csv_file_path: Path to the CSV file
            
        Returns:
            Dictionary with processing statistics
        """
        stats = {
            'total_rows': 0,
            'successful_calls': 0,
            'failed_calls': 0,
            'skipped_rows': 0
        }
        
        # Store results for CSV output
        results = []
        
        try:
            with open(csv_file_path, 'r', encoding='utf-8') as file:
                reader = csv.DictReader(file)
                
                logger.info(f"Processing CSV with {len(reader.fieldnames)} columns")
                logger.info(f"CSV columns: {list(reader.fieldnames)}")
                
                for row_num, row in enumerate(reader, start=2):  # Start at 2 since row 1 is header
                    stats['total_rows'] += 1
                    
                    try:
                        # Make API call for every row
                        success = self._make_api_call(row)
                        
                        # Get wine name and vintage from the row
                        wine_name = row.get('Wine Name', row.get('\ufeffWine Name', 'Unknown'))
                        vintage = row.get('Vintage', 'Unknown')
                        
                        # Store result for CSV output
                        result = {
                            'Row': row_num,
                            'Wine Name': wine_name,
                            'Vintage': vintage,
                            'Status': 'Success' if success else 'Failed',
                            'Mock Price': self._generate_mock_price(vintage),
                            'Timestamp': time.strftime('%Y-%m-%d %H:%M:%S')
                        }
                        results.append(result)
                        
                        if success:
                            stats['successful_calls'] += 1
                            logger.info(f"Row {row_num}: Successfully processed {wine_name} ({vintage})")
                        else:
                            stats['failed_calls'] += 1
                            logger.error(f"Row {row_num}: API call failed for {wine_name} ({vintage})")
                            
                        # Rate limiting
                        if row_num < stats['total_rows']:  # Don't delay after last row
                            time.sleep(self.rate_limit_delay)
                            
                    except Exception as e:
                        stats['failed_calls'] += 1
                        logger.error(f"Row {row_num}: Error processing row: {str(e)}")
                        
                        # Store error result for CSV output
                        wine_name = row.get('Wine Name', row.get('\ufeffWine Name', 'Unknown'))
                        vintage = row.get('Vintage', 'Unknown')
                        result = {
                            'Row': row_num,
                            'Wine Name': wine_name,
                            'Vintage': vintage,
                            'Status': 'Error',
                            'Mock Price': self._generate_mock_price(vintage),
                            'Timestamp': time.strftime('%Y-%m-%d %H:%M:%S')
                        }
                        results.append(result)
                        continue
                        
        except FileNotFoundError:
            logger.error(f"CSV file not found: {csv_file_path}")
            raise
        except Exception as e:
            logger.error(f"Error reading CSV file: {str(e)}")
            raise
        
        # Write results CSV
        self._write_results_csv(results, csv_file_path)
        
        return stats
    
    def _make_api_call(self, row: Dict[str, str]) -> bool:
        """
        Make API call with the given row data
        
        Args:
            row: Dictionary containing wine data
            
        Returns:
            True if API call was successful, False otherwise
        """
        try:
            # Field mapping for CSV column names
            field_mapping = {
                'Wine Name': 'winename',
                '\ufeffWine Name': 'winename',  # Handle BOM character
                'Vintage': 'vintage'
            }
            
            # Map CSV fields to API fields
            mapped_row = {}
            for csv_field, api_field in field_mapping.items():
                if csv_field in row:
                    mapped_row[api_field] = row[csv_field]
                    logger.debug(f"Mapped '{csv_field}' -> '{api_field}': '{row[csv_field]}'")
            
            # Debug logging
            logger.debug(f"Original row: {row}")
            logger.debug(f"Mapped row: {mapped_row}")
            
            # Prepare query parameters
            params = {
                'api_key': self.api_key,
                'winename': quote_plus(mapped_row.get('winename', '')),
                'vintage': mapped_row.get('vintage', ''),
                'currencycode': 'USD',  # Hardcoded to USD
                'location': 'MA',  # Hardcoded to MA
                'state': 'MA',  # Hardcoded to MA
                'offer_type': 'sale'  # Hardcoded to sale
            }
            
            # Only add price if mock pricing is enabled
            if self.enable_mock_pricing:
                params['price'] = self._generate_mock_price(mapped_row.get('vintage', ''))
            
            # Hardcode country to USA
            params['country'] = 'USA'
            
            # Make the API request
            response = self.session.get(
                self.base_url,
                params=params,
                timeout=30
            )
            
            # Check response
            if response.status_code == 200:
                logger.debug(f"API call successful: {response.text[:200]}...")
                return True
            else:
                logger.error(f"API call failed with status {response.status_code}: {response.text}")
                return False
                
        except requests.exceptions.RequestException as e:
            logger.error(f"Request error: {str(e)}")
            return False
        except Exception as e:
            logger.error(f"Unexpected error during API call: {str(e)}")
            return False

    def _write_results_csv(self, results: List[Dict], csv_file_path: str) -> None:
        """Write processing results to a CSV file."""
        # Check if output file already exists
        output_csv_path = csv_file_path.replace('.csv', '_results.csv')
        
        if os.path.exists(output_csv_path):
            print(f"\n⚠️  Warning: Results file '{output_csv_path}' already exists!")
            overwrite = input("Do you want to overwrite it? (y/n): ").strip().lower()
            if overwrite not in ['y', 'yes']:
                # Generate new filename with timestamp
                timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                output_csv_path = csv_file_path.replace('.csv', f'_results_{timestamp}.csv')
                print(f"✅ New results file will be: {output_csv_path}")
        
        try:
            with open(output_csv_path, 'w', newline='', encoding='utf-8') as csvfile:
                # Define fieldnames based on whether mock pricing is enabled
                if self.enable_mock_pricing:
                    fieldnames = ['Row', 'Wine Name', 'Vintage', 'Status', 'Mock Price', 'Timestamp']
                else:
                    fieldnames = ['Row', 'Wine Name', 'Vintage', 'Status', 'Timestamp']
                
                writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
                writer.writeheader()
                
                # Write results with or without mock pricing
                for result in results:
                    if self.enable_mock_pricing:
                        writer.writerow({
                            'Row': result.get('Row', ''),
                            'Wine Name': result.get('Wine Name', ''),
                            'Vintage': result.get('Vintage', ''),
                            'Status': result.get('Status', ''),
                            'Mock Price': result.get('Mock Price', ''),
                            'Timestamp': result.get('Timestamp', '')
                        })
                    else:
                        writer.writerow({
                            'Row': result.get('Row', ''),
                            'Wine Name': result.get('Wine Name', ''),
                            'Vintage': result.get('Vintage', ''),
                            'Status': result.get('Status', ''),
                            'Timestamp': result.get('Timestamp', '')
                        })
                
            logger.info(f"Results written to {output_csv_path}")
        except Exception as e:
            logger.error(f"Error writing results CSV: {str(e)}")

    def _generate_mock_price(self, vintage: str) -> str:
        """
        Generates a mock price for a given vintage.
        
        Args:
            vintage: The vintage year as a string
            
        Returns:
            Mock price as a string (e.g., "$45.99")
        """
        if not self.enable_mock_pricing:
            return "N/A"
            
        try:
            year = int(vintage)
            current_year = datetime.now().year
            
            # More affordable pricing for unemployed wine lovers! 🍷
            if year < 2000:
                base_price = 25  # Older wines, but still affordable
            elif year < 2010:
                base_price = 35  # 2000s wines
            elif year < 2020:
                base_price = 28  # 2010s wines
            else:
                base_price = 22  # Recent vintages
            
            # Add some randomness
            import random
            variation = random.uniform(-5, 8)
            final_price = base_price + variation
            
            # Format as currency
            return f"${final_price:.2f}"
            
        except (ValueError, TypeError):
            return "$32.99"  # Default price if vintage parsing fails

def main():
    """Main function to handle command line arguments and run the processor."""
    parser = argparse.ArgumentParser(
        description="Process CSV wine data and make API calls",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Interactive mode (just run the script):
  python wine_api_processor.py
  
  # Command line mode:
  python wine_api_processor.py --csv-file "wines.csv" --api-key "my_key" --api-url "https://api.com"
  
  # With defaults:
  python wine_api_processor.py --csv-file "wines.csv"
        """
    )
    
    parser.add_argument("--csv-file", help="Path to the CSV file")
    parser.add_argument("--api-key", help="API key for authentication")
    parser.add_argument("--api-url", help="Base URL for the API endpoint")
    parser.add_argument("--rate-limit", type=float, default=1.0, help="Delay between API calls in seconds")
    parser.add_argument("--verbose", "-v", action="store_true", help="Enable verbose logging")
    parser.add_argument("--enable-mock-pricing", action="store_true", help="Enable mock pricing for testing (default: False)")
    
    args = parser.parse_args()
    
    # If no arguments provided, run interactive mode
    if not args.csv_file and not args.api_key and not args.api_url:
        run_interactive_mode()
        return
    
    # Validate required arguments for command line mode
    if not args.csv_file:
        print("❌ Error: --csv-file is required for command line mode")
        print("💡 Tip: Run without arguments for interactive mode!")
        return
    
    # Set defaults for missing optional arguments
    api_key = args.api_key or "test_api_key_123"
    api_url = args.api_url or "https://postman-echo.com/get"
    
    # Configure logging
    log_level = logging.DEBUG if args.verbose else logging.INFO
    logging.basicConfig(
        level=log_level,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.StreamHandler(),
            logging.FileHandler('wine_api_processor.log')
        ]
    )
    
    # Create processor and run
    try:
        processor = WineAPIProcessor(api_key, api_url, args.rate_limit, args.enable_mock_pricing)
        processor.process_csv(args.csv_file)
    except Exception as e:
        logging.error(f"Processing failed: {e}")
        sys.exit(1)

def run_interactive_mode():
    """Run the processor in interactive mode, prompting user for input."""
    print("🎉 🍷 WELCOME TO INTERACTIVE WINE PROCESSOR! 🍷 🎉")
    print("==================================================")
    print()
    print("I'll guide you through setting up your wine processing run!")
    print()
    
    # Step 1: Get CSV file
    while True:
        csv_file = input("📁 What's the path to your CSV file? ").strip()
        if os.path.exists(csv_file):
            break
        else:
            print(f"❌ File not found: {csv_file}")
            retry = input("Would you like to try again? (y/n): ").strip().lower()
            if retry not in ['y', 'yes']:
                print("Exiting...")
                return
    
    print()
    
    # Step 2: API configuration
    print("🔑 Let's configure your API settings!")
    print()
    
    api_key = input("What's your API key? (default: test_api_key_123): ").strip()
    if not api_key:
        api_key = "test_api_key_123"
    
    api_url = input("What's your API endpoint URL? (default: https://postman-echo.com/get): ").strip()
    if not api_url:
        api_url = "https://postman-echo.com/get"
    
    print()
    
    # Step 3: Mock pricing configuration
    print("🎭 Mock Pricing Configuration")
    print("This generates fake prices for testing purposes.")
    print()
    enable_mock = input("Enable mock pricing for testing? (y/N): ").strip().lower()
    enable_mock_pricing = enable_mock in ['y', 'yes']
    
    print()
    
    # Step 4: Confirm settings
    print("Here's what we're about to run:")
    print(f"  📁 CSV File: {csv_file}")
    print(f"  🔑 API Key: {api_key}")
    print(f"  🌐 API URL: {api_url}")
    print(f"  🎭 Mock Pricing: {'Enabled' if enable_mock_pricing else 'Disabled'}")
    print()
    
    confirm = input("Does this look correct? Ready to process your wines? (Y/n): ").strip().lower()
    if confirm in ['n', 'no']:
        print("No problem! Let's start over...")
        print()
        run_interactive_mode()
        return
    
    print()
    print("✅ Let's get this wine party started! 🍷🚀")
    print()
    
    # Configure logging
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.StreamHandler(),
            logging.FileHandler('wine_api_processor.log')
        ]
    )
    
    # Create processor and run
    try:
        processor = WineAPIProcessor(api_key, api_url, 1.0, enable_mock_pricing)
        processor.process_csv(csv_file)
    except Exception as e:
        logging.error(f"Processing failed: {e}")
        print(f"❌ Error: {e}")
        input("Press Enter to exit...")
        sys.exit(1)

if __name__ == "__main__":
    main()
