#!/usr/bin/env node
/**
 * Wine API Data Processor - Node.js Version
 * 
 * This script reads wine data from CSV files and makes API calls to insert the information.
 * It supports configurable API endpoints, error handling, and logging.
 */

const fs = require('fs');
const path = require('path');
const csv = require('csv-parser');
const axios = require('axios');
const { createObjectCsvWriter } = require('csv-writer');

// Configure logging
const log = {
    info: (msg) => console.log(`[INFO] ${new Date().toISOString()} - ${msg}`),
    error: (msg) => console.error(`[ERROR] ${new Date().toISOString()} - ${msg}`),
    warn: (msg) => console.warn(`[WARN] ${new Date().toISOString()} - ${msg}`),
    debug: (msg) => process.env.DEBUG && console.log(`[DEBUG] ${new Date().toISOString()} - ${msg}`)
};

class WineAPIProcessor {
    constructor(apiKey, baseUrl, rateLimitDelay = 1000, enableMockPricing = false) {
        this.apiKey = apiKey;
        this.baseUrl = baseUrl.replace(/\/$/, ''); // Remove trailing slash
        this.rateLimitDelay = rateLimitDelay;
        this.enableMockPricing = enableMockPricing;
        this.axiosInstance = axios.create({
            timeout: 30000,
            headers: {
                'User-Agent': 'WineAPIProcessor/1.0',
                'Accept': 'application/json'
            }
        });
    }

    /**
     * Process CSV file and make API calls for each row
     */
    async processCSV(csvFilePath) {
        const stats = {
            totalRows: 0,
            successfulCalls: 0,
            failedCalls: 0,
            skippedRows: 0
        };

        const results = [];

        try {
            log.info(`Processing CSV: ${csvFilePath}`);
            
            // Read and process CSV
            const rows = await this.readCSV(csvFilePath);
            log.info(`CSV columns: ${Object.keys(rows[0] || {}).join(', ')}`);

            for (let i = 0; i < rows.length; i++) {
                const row = rows[i];
                const rowNum = i + 2; // Start at 2 since row 1 is header
                stats.totalRows++;

                try {
                    // Make API call for every row
                    const success = await this.makeAPICall(row);
                    
                    // Get wine name and vintage from the row
                    const wineName = row['Wine Name'] || row['\ufeffWine Name'] || 'Unknown';
                    const vintage = row['Vintage'] || 'Unknown';
                    
                    // Store result for CSV output
                    const result = {
                        row: rowNum,
                        wineName: wineName,
                        vintage: vintage,
                        status: success ? 'Success' : 'Failed',
                        timestamp: new Date().toISOString().replace('T', ' ').substring(0, 19)
                    };
                    
                    // Only add mock price if enabled
                    if (this.enableMockPricing) {
                        result.mockPrice = this.generateMockPrice(vintage);
                    }
                    results.push(result);

                    if (success) {
                        stats.successfulCalls++;
                        log.info(`Row ${rowNum}: Successfully processed ${wineName} (${vintage})`);
                    } else {
                        stats.failedCalls++;
                        log.error(`Row ${rowNum}: API call failed for ${wineName} (${vintage})`);
                    }

                    // Rate limiting
                    if (i < rows.length - 1) { // Don't delay after last row
                        await this.sleep(this.rateLimitDelay);
                    }

                } catch (error) {
                    stats.failedCalls++;
                    log.error(`Row ${rowNum}: Error processing row: ${error.message}`);
                    
                    // Store error result for CSV output
                    const wineName = row['Wine Name'] || row['\ufeffWine Name'] || 'Unknown';
                    const vintage = row['Vintage'] || 'Unknown';
                    const result = {
                        row: rowNum,
                        wineName: wineName,
                        vintage: vintage,
                        status: 'Error',
                        timestamp: new Date().toISOString().replace('T', ' ').substring(0, 19)
                    };
                    
                    // Only add mock price if enabled
                    if (this.enableMockPricing) {
                        result.mockPrice = this.generateMockPrice(vintage);
                    }
                    results.push(result);
                }
            }

        } catch (error) {
            log.error(`Error reading CSV file: ${error.message}`);
            throw error;
        }

        // Write results CSV
        const outputCsvPath = await this.writeResultsCSV(results, csvFilePath);

        return stats;
    }

    /**
     * Read CSV file and return array of objects
     */
    readCSV(filePath) {
        return new Promise((resolve, reject) => {
            const results = [];
            fs.createReadStream(filePath)
                .pipe(csv())
                .on('data', (data) => results.push(data))
                .on('end', () => resolve(results))
                .on('error', (error) => reject(error));
        });
    }

    /**
     * Make API call with the given row data
     */
    async makeAPICall(row) {
        try {
            // Field mapping for CSV column names
            const fieldMapping = {
                'Wine Name': 'winename',
                '\ufeffWine Name': 'winename', // Handle BOM character
                'Vintage': 'vintage'
            };

            // Map CSV fields to API fields
            const mappedRow = {};
            for (const [csvField, apiField] of Object.entries(fieldMapping)) {
                if (row[csvField]) {
                    mappedRow[apiField] = row[csvField];
                    log.debug(`Mapped '${csvField}' -> '${apiField}': '${row[csvField]}'`);
                }
            }

            log.debug(`Original row: ${JSON.stringify(row)}`);
            log.debug(`Mapped row: ${JSON.stringify(mappedRow)}`);

            // Prepare query parameters
            const params = {
                api_key: this.apiKey,
                winename: encodeURIComponent(mappedRow.winename || ''),
                vintage: mappedRow.vintage || '',
                price: this.generateMockPrice(mappedRow.vintage || ''),
                currencycode: 'USD', // Hardcoded to USD
                location: 'MA', // Hardcoded to MA
                state: 'MA', // Hardcoded to MA
                offer_type: 'sale' // Hardcoded to sale
            };

            // Hardcode country to USA
            params.country = 'USA';

            // Make the API request
            const response = await this.axiosInstance.get(this.baseUrl, { params });

            // Check response
            if (response.status === 200) {
                log.debug(`API call successful: ${JSON.stringify(response.data).substring(0, 200)}...`);
                return true;
            } else {
                log.error(`API call failed with status ${response.status}: ${JSON.stringify(response.data)}`);
                return false;
            }

        } catch (error) {
            if (error.response) {
                log.error(`API call failed with status ${error.response.status}: ${JSON.stringify(error.response.data)}`);
            } else {
                log.error(`Request error: ${error.message}`);
            }
            return false;
        }
    }

    /**
     * Generate mock price for a given vintage
     */
    generateMockPrice(vintage) {
        if (!this.enableMockPricing) {
            return 'N/A';
        }
        
        try {
            const vintageInt = parseInt(vintage);
            // More realistic restaurant wine prices
            if (2015 <= vintageInt && vintageInt <= 2017) {
                return `$${vintageInt - 2010 + 25}`; // $30-32 range
            } else if (2018 <= vintageInt && vintageInt <= 2020) {
                return `$${vintageInt - 2015 + 35}`; // $38-40 range
            } else if (2021 <= vintageInt && vintageInt <= 2023) {
                return `$${vintageInt - 2020 + 42}`; // $43-45 range
            } else {
                return '$28'; // Default affordable price
            }
        } catch (error) {
            return '$28';
        }
    }

    /**
     * Write results to CSV file
     */
    async writeResultsCSV(results, csvFile) {
        // Generate output filename
        const baseName = csvFile.replace(/\.[^/.]+$/, "");
        let outputFile = `${baseName}_results.csv`;
        
        // Check if file exists and ask for confirmation
        if (fs.existsSync(outputFile)) {
            console.log(`\n⚠️  Warning: ${outputFile} already exists!`);
            const readline = require('readline');
            const rl = readline.createInterface({
                input: process.stdin,
                output: process.stdout
            });
            
            const overwrite = await new Promise((resolve) => {
                rl.question('Do you want to overwrite it? (y/N): ', (answer) => {
                    rl.close();
                    resolve(answer.trim().toLowerCase());
                });
            });
            
            if (overwrite === 'y' || overwrite === 'yes') {
                console.log('✅ Overwriting existing file...');
            } else {
                // Generate new filename with timestamp
                const timestamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
                outputFile = `${baseName}_results_${timestamp}.csv`;
                console.log(`✅ Using new filename: ${outputFile}`);
            }
        }
        
        try {
            // Define header based on whether mock pricing is enabled
            let header = [
                { id: 'row', title: 'Row' },
                { id: 'wineName', title: 'Wine Name' },
                { id: 'vintage', title: 'Vintage' },
                { id: 'status', title: 'Status' },
                { id: 'timestamp', title: 'Timestamp' }
            ];
            
            // Only add Mock Price column if mock pricing is enabled
            if (this.enableMockPricing) {
                header.splice(4, 0, { id: 'mockPrice', title: 'Mock Price' });
            }
            
            const csvWriter = createObjectCsvWriter({
                path: outputFile,
                header: header
            });
            
            await csvWriter.writeRecords(results);
            console.log(`[INFO] Results written to ${outputFile}`);
            return outputFile;
            
        } catch (error) {
            console.error(`[ERROR] Error writing results CSV: ${error.message}`);
            throw error;
        }
    }

    /**
     * Sleep function for rate limiting
     */
    sleep(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }
}

// Main execution
if (require.main === module) {
    main().catch(error => {
        console.error(`[ERROR] ${error.message}`);
        process.exit(1);
    });
}

async function main() {
    const args = process.argv.slice(2);
    
    // If no arguments provided, run interactive mode
    if (args.length === 0) {
        await runInteractiveMode();
        return;
    }
    
    // Parse command line arguments
    let csvFile = null;
    let apiKey = null;
    let apiUrl = null;
    let rateLimit = 1.0;
    let enableMockPricing = false;
    
    for (let i = 0; i < args.length; i++) {
        switch (args[i]) {
            case '--csv-file':
                csvFile = args[++i];
                break;
            case '--api-key':
                apiKey = args[++i];
                break;
            case '--api-url':
                apiUrl = args[++i];
                break;
            case '--rate-limit':
                rateLimit = parseFloat(args[++i]);
                break;
            case '--enable-mock-pricing':
                enableMockPricing = true;
                break;
            case '--help':
            case '-h':
                showHelp();
                return;
            default:
                if (!csvFile) {
                    csvFile = args[i];
                } else {
                    console.error(`[ERROR] Unknown argument: ${args[i]}`);
                    showHelp();
                    return;
                }
        }
    }
    
    // Validate required arguments for command line mode
    if (!csvFile) {
        console.error("❌ Error: CSV file path is required for command line mode");
        console.log("💡 Tip: Run without arguments for interactive mode!");
        console.log("   Examples:");
        console.log("     node wine_api_processor.js");
        console.log("     node wine_api_processor.js --csv-file wines.csv");
        console.log("     node wine_api_processor.js wines.csv --api-key my_key --api-url https://api.com");
        return;
    }
    
    // Set defaults for missing optional arguments
    apiKey = apiKey || "test_api_key_123";
    apiUrl = apiUrl || "https://postman-echo.com/get";
    
    // Check if CSV file exists
    if (!fs.existsSync(csvFile)) {
        console.error(`[ERROR] CSV file not found: ${csvFile}`);
        return;
    }
    
    // Create processor and run
    try {
        const processor = new WineAPIProcessor(apiKey, apiUrl, rateLimit, enableMockPricing);
        await processor.processCSV(csvFile);
    } catch (error) {
        console.error(`[ERROR] Processing failed: ${error.message}`);
        process.exit(1);
    }
}

function showHelp() {
    console.log("🍷 Wine API Processor - Node.js Version");
    console.log("");
    console.log("Usage:");
    console.log("  # Interactive mode (just run the script):");
    console.log("  node wine_api_processor.js");
    console.log("");
    console.log("  # Command line mode:");
    console.log("  node wine_api_processor.js --csv-file wines.csv --api-key my_key --api-url https://api.com");
    console.log("");
    console.log("  # With defaults:");
    console.log("  node wine_api_processor.js --csv-file wines.csv");
    console.log("");
    console.log("  # Short form:");
    console.log("  node wine_api_processor.js wines.csv");
    console.log("");
    console.log("Arguments:");
    console.log("  --csv-file    Path to the CSV file");
    console.log("  --api-key     API key for authentication");
    console.log("  --api-url     API endpoint URL");
    console.log("  --rate-limit  Delay between API calls in seconds (default: 1.0)");
    console.log("  --enable-mock-pricing  Enable mock pricing for testing (default: false)");
    console.log("  --help, -h    Show this help message");
}

async function runInteractiveMode() {
    console.log("🎉 🍷 WELCOME TO INTERACTIVE WINE PROCESSOR! 🍷 🎉");
    console.log("==================================================");
    console.log("");
    console.log("I'll guide you through setting up your wine processing run!");
    console.log("");
    
    // Step 1: Get CSV file
    let csvFile;
    while (true) {
        csvFile = await getUserInput("📁 What's the path to your CSV file? ");
        if (fs.existsSync(csvFile)) {
            break;
        } else {
            console.log(`❌ File not found: ${csvFile}`);
            const retry = await getUserInput("Would you like to try again? (y/n): ");
            if (retry.toLowerCase() !== 'y' && retry.toLowerCase() !== 'yes') {
                console.log("Exiting...");
                return;
            }
        }
    }
    
    console.log("");
    
    // Step 2: API configuration
    console.log("🔑 Let's configure your API settings!");
    console.log("");
    
    const apiKey = await getUserInput("What's your API key? (default: test_api_key_123): ") || "test_api_key_123";
    const apiUrl = await getUserInput("What's your API endpoint URL? (default: https://postman-echo.com/get): ") || "https://postman-echo.com/get";
    
    console.log("");
    
    // Step 3: Mock pricing configuration
    console.log("🎭 Mock Pricing Configuration");
    console.log("This generates fake prices for testing purposes.");
    console.log("");
    const enableMock = await getUserInput("Enable mock pricing for testing? (y/N): ");
    const enableMockPricing = enableMock.toLowerCase() === 'y' || enableMock.toLowerCase() === 'yes';
    
    console.log("");
    
    // Step 4: Confirm settings
    console.log("Here's what we're about to run:");
    console.log(`  📁 CSV File: ${csvFile}`);
    console.log(`  🔑 API Key: ${apiKey}`);
    console.log(`  🌐 API URL: ${apiUrl}`);
    console.log(`  🎭 Mock Pricing: ${enableMockPricing ? 'Enabled' : 'Disabled'}`);
    console.log("");
    
    const confirm = await getUserInput("Does this look correct? Ready to process your wines? (Y/n): ");
    if (confirm.toLowerCase() === 'n' || confirm.toLowerCase() === 'no') {
        console.log("No problem! Let's start over...");
        console.log("");
        await runInteractiveMode();
        return;
    }
    
    console.log("");
    console.log("✅ Let's get this wine party started! 🍷🚀");
    console.log("");
    
    // Create processor and run
    try {
        const processor = new WineAPIProcessor(apiKey, apiUrl, 1.0, enableMockPricing);
        await processor.processCSV(csvFile);
    } catch (error) {
        console.error(`❌ Error: ${error.message}`);
        await getUserInput("Press Enter to exit...");
        process.exit(1);
    }
}

function getUserInput(prompt) {
    return new Promise((resolve) => {
        const readline = require('readline');
        const rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });
        
        rl.question(prompt, (answer) => {
            rl.close();
            resolve(answer.trim());
        });
    });
}

module.exports = WineAPIProcessor;
