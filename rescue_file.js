const fs = require('fs');
const filePath = 'c:\\Portifólio\\pi-web\\frontend\\pi-ui\\src\\pages\\ProformaInvoiceV2Page.tsx';

const data = fs.readFileSync(filePath, 'utf8');

// Find the FIRST 'import React'
const startMarker = 'import React,';
const startIndex = data.indexOf(startMarker);

if (startIndex !== -1) {
    const cleaned = data.substring(startIndex);
    fs.writeFileSync(filePath, cleaned, 'utf8');
    console.log('Success: Garbage removed using indexOf.');
} else {
    // Maybe it's just 'import '
    const startMarker2 = 'import {';
    const startIndex2 = data.indexOf(startMarker2);
    if (startIndex2 !== -1) {
        const cleaned = data.substring(startIndex2);
        fs.writeFileSync(filePath, cleaned, 'utf8');
        console.log('Success: Garbage removed using backup marker.');
    } else {
        console.error('Marker not found at all.');
        process.exit(1);
    }
}
