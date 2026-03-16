using System;
using System.IO;
using System.Linq;
using System.Globalization;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using OfficeOpenXml;

// Simplified version of the logic to verify extraction
public class LivintusVerifier
{
    public static void Main()
    {
        ExcelPackage.LicenseContext = LicenseContext.NonCommercial;
        var filePath = @"e:\teste\pi-web\Docs\teste2.xlsx";
        
        using var package = new ExcelPackage(new FileInfo(filePath));
        var worksheet = package.Workbook.Worksheets[0];
        var rowCount = worksheet.Dimension.Rows;

        Console.WriteLine($"Row | Brand | Description | L | A | P | Fabric | Price");
        Console.WriteLine("------------------------------------------------------------------");

        for (int row = 2; row <= 10; row++) // Check first few rows
        {
            var brandFromA = worksheet.Cells[row, 1].Text?.Trim();
            var brandFromB = worksheet.Cells[row, 2].Text?.Trim();
            
            var marcaNome = !string.IsNullOrEmpty(brandFromA) && !brandFromA.Equals("LINHA", StringComparison.OrdinalIgnoreCase) 
                            ? brandFromA : brandFromB;

            var largRaw = worksheet.Cells[row, 3].Value;
            var altRaw = worksheet.Cells[row, 4].Value;
            var profRaw = worksheet.Cells[row, 5].Value;
            var compositionRaw = worksheet.Cells[row, 6].Text?.Trim();
            var tecidoNome = worksheet.Cells[row, 7].Text?.Trim();
            var cellValor = worksheet.Cells[row, 8].Value;

            bool isNewSpec = (!string.IsNullOrEmpty(marcaNome) && !marcaNome.Equals("MODELO", StringComparison.OrdinalIgnoreCase))
                             || (!string.IsNullOrEmpty(brandFromB) && !string.IsNullOrEmpty(compositionRaw));

            if (isNewSpec && !string.IsNullOrEmpty(brandFromB) && !string.IsNullOrEmpty(compositionRaw))
            {
                var modelName = brandFromB;
                var descricaoNormalized = NormalizeString($"{modelName} - {compositionRaw}");
                
                var larg = UniversalParseDecimal(largRaw) * 100;
                var prof = UniversalParseDecimal(profRaw) * 100;
                var alt = UniversalParseDecimal(altRaw) * 100;
                var price = UniversalParseDecimal(cellValor);

                Console.WriteLine($"{row} | {marcaNome} | {descricaoNormalized} | {larg} | {alt} | {prof} | {tecidoNome} | {price}");
            }
        }
    }

    private static string NormalizeString(string input)
    {
        if (string.IsNullOrEmpty(input)) return string.Empty;
        var temp = Regex.Replace(input, @"\s+", " ").Trim();
        return temp.ToUpper();
    }

    private static decimal UniversalParseDecimal(object value)
    {
        if (value == null) return 0;
        if (value is double d) return (decimal)d;
        if (value is decimal dec) return dec;
        if (value is int i) return (decimal)i;
        if (value is long l) return (decimal)l;

        string text = value.ToString()?.Trim() ?? "";
        if (string.IsNullOrEmpty(text)) return 0;

        text = Regex.Replace(text, @"[^\d,.-]", "");
        if (string.IsNullOrEmpty(text)) return 0;

        if (text.Contains(",") && text.Contains("."))
        {
            if (text.LastIndexOf(',') > text.LastIndexOf('.'))
                text = text.Replace(".", "").Replace(",", ".");
            else
                text = text.Replace(",", "");
        }
        else if (text.Contains(",")) text = text.Replace(",", ".");

        if (decimal.TryParse(text, NumberStyles.Any, CultureInfo.InvariantCulture, out var result))
            return result;

        return 0;
    }
}
