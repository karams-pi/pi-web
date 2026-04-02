const fs = require('fs');
const filePath = 'c:\\Portifólio\\pi-web\\frontend\\pi-ui\\src\\pages\\ProformaInvoiceV2Page.tsx';

const data = fs.readFileSync(filePath, 'utf8');
const lines = data.split(/\\r?\\n/);

// Find the first line that starts with 'import React'
let importIndex = -1;
for (let i = 0; i < lines.length; i++) {
    if (lines[i].trim().startsWith('import React')) {
        importIndex = i;
        break;
    }
}

if (importIndex !== -1) {
    const final = lines.slice(importIndex).join('\\n');
    fs.writeFileSync(filePath, final, 'utf8');
    console.log('Success: Garbage at the top removed.');
} else {
    console.error('Could not find import statement');
    process.exit(1);
}
