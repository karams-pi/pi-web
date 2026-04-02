const fs = require('fs');
const filePath = 'c:\\Portifólio\\pi-web\\frontend\\pi-ui\\src\\pages\\ProformaInvoiceV2Page.tsx';

const content = fs.readFileSync(filePath, 'utf8');

const theadStart = '<thead style={{ position: "sticky", top: 0, zIndex: 10 }}>';
const tbodyStart = '<tbody style={{ background: "rgba(15, 23, 42, 0.4)" }}>';

const startIndex = content.indexOf(theadStart);
const endIndex = content.indexOf(tbodyStart);

if (startIndex === -1 || endIndex === -1) {
    console.error('Markers not found:', { startIndex, endIndex });
    process.exit(1);
}

const before = content.substring(0, startIndex + theadStart.length);
const after = content.substring(endIndex);

const cleanThead = `
                  <tr style={{ background: "#0f172a" }}>
                    {!isFerguile ? (
                      <>
                        <th style={{ ...thStyle, width: "40px", textAlign: "center" }}>#</th>
                        <th style={{ ...thStyle, width: "60px", textAlign: "center" }}>{translate("FOTO")}</th>
                        <th style={{ ...thStyle, width: "120px", textAlign: "center" }}>{translate("MARCA")}</th>
                        <th style={{ ...thStyle, width: "400px" }}>{translate("DESC")}</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "50px" }}>{translate("LARG").replace(/\\./g, "")}</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "50px" }}>{translate("PROF").replace(/\\./g, "")}</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "50px" }}>{translate("ALT").replace(/\\./g, "")}</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "60px" }}>{translate("QTD")}</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "80px" }}>{translate("QTD_PECA")}</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "70px" }}>{translate("M3").replace(/ TOTAL/g, "")}</th>
                        <th style={{ ...thStyle, width: "140px", textAlign: "center" }}>{translate("TECIDO")}</th>
                        <th style={{ ...thStyle, width: "100px" }}>{translate("PES")}</th>
                        <th style={{ ...thStyle, width: "120px" }}>{translate("ACAB")}</th>
                        <th style={{ ...thStyle, width: "140px" }}>{translate("OBS").replace(/\\./g, "")}</th>
                        <th style={{ ...thStyle, textAlign: "right", width: "100px" }}>{translate("FRETE").replace(/ UNIT/g, "")}</th>
                        <th style={{ ...thStyle, textAlign: "right", width: "100px" }}>{translate("EXW").replace(/ UNIT/g, "")}</th>
                        <th style={{ ...thStyle, textAlign: "right", width: "110px" }}>{translate("UNIT_FINAL")}</th>
                        <th style={{ ...thStyle, textAlign: "right", width: "110px" }}>{form.moedaExibicao} Unit</th>
                        <th style={{ ...thStyle, textAlign: "right", width: "130px" }}>{translate("TOTAL")} {form.moedaExibicao}</th>
                      </>
                    ) : (
                      <>
                        <th style={{ ...thStyle, width: "60px" }}>{translate("FOTO")}</th>
                        <th style={{ ...thStyle, width: "100px" }}>{translate("REF")}</th>
                        <th style={{ ...thStyle, width: "300px" }}>{translate("DESC").replace(/MÓDULO \\/ /g, "")}</th>
                        <th style={{ ...thStyle, width: "100px" }}>{translate("MARCA")}</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "50px" }}>{translate("LARG")}</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "50px" }}>{translate("ALT")}</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "50px" }}>{translate("PROF")}</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "60px" }}>{translate("QTD")}</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "80px" }}>{translate("QTD_PECA")}</th>
                        <th style={{ ...thStyle, textAlign: "center", width: "70px" }}>{translate("M3").replace(/TOTAL/g, "")}</th>
                        <th style={{ ...thStyle, width: "120px" }}>{translate("TECIDO")}</th>
                        <th style={{ ...thStyle, width: "100px" }}>{translate("TELA")}</th>
                        <th style={{ ...thStyle, width: "140px" }}>{translate("OBS")}</th>
                        <th style={{ ...thStyle, textAlign: "right", width: "90px" }}>{translate("UNIT")} ({form.moedaExibicao})</th>
                        <th style={{ ...thStyle, textAlign: "right", width: "100px" }}>{translate("TOTAL")} ({form.moedaExibicao})</th>
                      </>
                    )}
                    <th style={{ ...thStyle, width: "50px" }}></th>
                  </tr>
                </thead>`;

fs.writeFileSync(filePath, before + cleanThead + after, 'utf8');
console.log('Success: thead cleaned.');
