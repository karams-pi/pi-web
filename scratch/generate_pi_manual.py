import os
import sys
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.pdfgen import canvas
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether
)
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.graphics.shapes import Drawing, Rect, String, Line, Polygon, Group

class NumberedCanvas(canvas.Canvas):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_decorations(num_pages)
            super().showPage()
        super().save()

    def draw_page_decorations(self, page_count):
        if self._pageNumber == 1:
            return
            
        self.saveState()
        
        # Colors
        slate_gray = colors.HexColor("#475569")
        light_border = colors.HexColor("#e2e8f0")
        
        # Header (A4 width is 595.27, height is 841.89)
        self.setFont("Helvetica-Bold", 8)
        self.setFillColor(colors.HexColor("#1e293b"))
        self.drawString(54, 805, "MANUAL DE INSTRUÇÕES DO USUÁRIO  |  MÓDULO PI")
        
        self.setFont("Helvetica", 8)
        self.setFillColor(slate_gray)
        self.drawRightString(541, 805, "SISTEMA PI-WEB")
        
        # Header Line
        self.setStrokeColor(light_border)
        self.setLineWidth(0.75)
        self.line(54, 797, 541, 797)
        
        # Footer
        self.setStrokeColor(light_border)
        self.setLineWidth(0.75)
        self.line(54, 52, 541, 52)
        
        self.setFont("Helvetica", 8)
        self.setFillColor(slate_gray)
        self.drawString(54, 38, "PI-Web  •  Módulo de Emissão de Proforma Invoice (PI) & Cotações")
        
        page_text = f"Página {self._pageNumber} de {page_count}"
        self.drawRightString(541, 38, page_text)
        
        self.restoreState()

def make_callout(text, type="info"):
    bg_color = colors.HexColor("#f0f9ff") # Light blue
    border_color = colors.HexColor("#0284c7") # Deep blue
    title = "<b>INFORMAÇÃO DO SISTEMA</b>"
    
    if type == "warning":
        bg_color = colors.HexColor("#fffbeb") # Light amber
        border_color = colors.HexColor("#d97706") # Amber
        title = "<b>ATENÇÃO / CUIDADO OPERACIONAL</b>"
    elif type == "tip":
        bg_color = colors.HexColor("#f0fdf4") # Light green
        border_color = colors.HexColor("#16a34a") # Green
        title = "<b>DICA DE PRODUTIVIDADE / ATALHO</b>"
    elif type == "legal":
        bg_color = colors.HexColor("#faf5ff") # Light purple
        border_color = colors.HexColor("#7c3aed") # Purple
        title = "<b>REGRAS COMERCIAIS E FINANCEIRAS</b>"
        
    p_text = f"<font color='{border_color.hexval()}'>{title}</font><br/>{text}"
    p = Paragraph(p_text, ParagraphStyle('CalloutBody', fontName='Helvetica', fontSize=8.5, leading=12, textColor=colors.HexColor("#334155")))
    
    t = Table([[p]], colWidths=[487])
    t.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), bg_color),
        ('LINELEFT', (0,0), (0,-1), 4, border_color),
        ('TOPPADDING', (0,0), (-1,-1), 8),
        ('BOTTOMPADDING', (0,0), (-1,-1), 8),
        ('LEFTPADDING', (0,0), (-1,-1), 12),
        ('RIGHTPADDING', (0,0), (-1,-1), 12),
    ]))
    
    return t

def make_field_table(fields):
    table_data = []
    
    # Header row
    table_data.append([
        Paragraph("<b>Elemento / Campo</b>", ParagraphStyle('TH1', fontName='Helvetica-Bold', fontSize=9, textColor=colors.white)),
        Paragraph("<b>Descrição, Ações e Comportamento no Sistema</b>", ParagraphStyle('TH2', fontName='Helvetica-Bold', fontSize=9, textColor=colors.white))
    ])
    
    for name, desc in fields:
        table_data.append([
            Paragraph(f"<b>{name}</b>", ParagraphStyle('TD1', fontName='Helvetica', fontSize=8, leading=10, textColor=colors.HexColor("#1e293b"))),
            Paragraph(desc, ParagraphStyle('TD2', fontName='Helvetica', fontSize=8, leading=10, textColor=colors.HexColor("#475569")))
        ])
        
    t = Table(table_data, colWidths=[140, 347])
    t.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#1e293b")),
        ('ALIGN', (0,0), (-1,-1), 'LEFT'),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('TOPPADDING', (0,0), (-1,-1), 5),
        ('BOTTOMPADDING', (0,0), (-1,-1), 5),
        ('LEFTPADDING', (0,0), (-1,-1), 6),
        ('RIGHTPADDING', (0,0), (-1,-1), 6),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, colors.HexColor("#f8fafc")]),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#e2e8f0")),
    ]))
    return t

def make_ui_wireframe(title, sections):
    bg_color = colors.HexColor("#0f172a") # Slate 900
    border_color = colors.HexColor("#334155") # Slate 700
    
    header_style = ParagraphStyle('UIHeader', fontName='Helvetica-Bold', fontSize=8.5, textColor=colors.HexColor("#3b82f6")) # Blue header for commercial
    body_style = ParagraphStyle('UIBody', fontName='Helvetica', fontSize=8, leading=11, textColor=colors.HexColor("#94a3b8"))
    
    rows = []
    rows.append([Paragraph(f"<b>LAYOUT DA TELA: {title.upper()}</b>", header_style)])
    
    body_text = "<br/>".join([f"• <b>{k}:</b> {v}" for k, v in sections])
    rows.append([Paragraph(body_text, body_style)])
    
    t = Table(rows, colWidths=[487])
    t.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), bg_color),
        ('BOX', (0,0), (-1,-1), 1.5, colors.HexColor("#2563eb")), # Blue border
        ('TOPPADDING', (0,0), (-1,-1), 8),
        ('BOTTOMPADDING', (0,0), (-1,-1), 8),
        ('LEFTPADDING', (0,0), (-1,-1), 12),
        ('RIGHTPADDING', (0,0), (-1,-1), 12),
        ('LINEBELOW', (0,0), (0,0), 1, border_color),
    ]))
    return t

def make_calculation_flowchart():
    d = Drawing(487, 85)
    # Background box
    d.add(Rect(0, 0, 487, 85, fillColor=colors.HexColor("#f8fafc"), strokeColor=colors.HexColor("#cbd5e1"), strokeWidth=0.5, rx=8, ry=8))
    
    # Step 1: Preço Tabela BRL
    d.add(Rect(15, 22, 95, 40, fillColor=colors.HexColor("#1e293b"), strokeColor=colors.HexColor("#475569"), rx=4, ry=4))
    d.add(String(22, 45, "1. Preço BRL", fontName="Helvetica-Bold", fontSize=8, fillColor=colors.white))
    d.add(String(22, 33, "(Tabela de Fábrica)", fontName="Helvetica", fontSize=7, fillColor=colors.HexColor("#94a3b8")))
    
    # Arrow 1
    d.add(Line(115, 42, 130, 42, strokeColor=colors.HexColor("#3b82f6"), strokeWidth=1.5))
    d.add(Polygon([127, 45, 133, 42, 127, 39], fillColor=colors.HexColor("#3b82f6"), strokeColor=None))
    
    # Step 2: Divisão Dólar Risco
    d.add(Rect(135, 22, 95, 40, fillColor=colors.HexColor("#1e293b"), strokeColor=colors.HexColor("#475569"), rx=4, ry=4))
    d.add(String(142, 45, "2. Divisão Câmbio", fontName="Helvetica-Bold", fontSize=8, fillColor=colors.white))
    d.add(String(142, 33, "(Dólar Risco)", fontName="Helvetica", fontSize=7, fillColor=colors.HexColor("#94a3b8")))
    
    # Arrow 2
    d.add(Line(230, 42, 245, 42, strokeColor=colors.HexColor("#3b82f6"), strokeWidth=1.5))
    d.add(Polygon([242, 45, 248, 42, 242, 39], fillColor=colors.HexColor("#3b82f6"), strokeColor=None))
    
    # Step 3: EXW Calculation
    d.add(Rect(250, 22, 105, 40, fillColor=colors.HexColor("#1e293b"), strokeColor=colors.HexColor("#475569"), rx=4, ry=4))
    d.add(String(257, 45, "3. EXW = Base +", fontName="Helvetica-Bold", fontSize=8, fillColor=colors.white))
    d.add(String(257, 33, "Comissão% + Gordura%", fontName="Helvetica", fontSize=7, fillColor=colors.HexColor("#94a3b8")))
    
    # Arrow 3
    d.add(Line(360, 42, 375, 42, strokeColor=colors.HexColor("#3b82f6"), strokeWidth=1.5))
    d.add(Polygon([372, 45, 378, 42, 372, 39], fillColor=colors.HexColor("#3b82f6"), strokeColor=None))
    
    # Step 4: Freight Apportionment
    d.add(Rect(380, 22, 92, 40, fillColor=colors.HexColor("#3b82f6"), strokeColor=colors.HexColor("#2563eb"), rx=4, ry=4))
    d.add(String(387, 45, "4. Rateio Frete", fontName="Helvetica-Bold", fontSize=8, fillColor=colors.white))
    d.add(String(387, 33, "(Volume m³ do Item)", fontName="Helvetica", fontSize=7, fillColor=colors.HexColor("#dbeafe")))
    
    return d

def make_architecture_diagram():
    d = Drawing(487, 105)
    # Background box
    d.add(Rect(0, 0, 487, 105, fillColor=colors.HexColor("#f8fafc"), strokeColor=colors.HexColor("#cbd5e1"), strokeWidth=0.5, rx=8, ry=8))
    
    # Left inputs
    d.add(Rect(15, 75, 115, 20, fillColor=colors.HexColor("#475569"), strokeColor=colors.HexColor("#64748b"), rx=3, ry=3))
    d.add(String(22, 81, "Clientes (País, Contatos)", fontName="Helvetica-Bold", fontSize=7.5, fillColor=colors.white))
    
    d.add(Rect(15, 45, 115, 20, fillColor=colors.HexColor("#475569"), strokeColor=colors.HexColor("#64748b"), rx=3, ry=3))
    d.add(String(22, 51, "Fornecedores & Incoterms", fontName="Helvetica-Bold", fontSize=7.5, fillColor=colors.white))
    
    d.add(Rect(15, 15, 115, 20, fillColor=colors.HexColor("#475569"), strokeColor=colors.HexColor("#64748b"), rx=3, ry=3))
    d.add(String(22, 21, "Módulos / Tecidos (Excel)", fontName="Helvetica-Bold", fontSize=7.5, fillColor=colors.white))
    
    # Middle: Margins & Rates Config
    d.add(Rect(185, 38, 125, 30, fillColor=colors.HexColor("#1e293b"), strokeColor=colors.HexColor("#334155"), rx=4, ry=4))
    d.add(String(192, 56, "Configurações Comerciais", fontName="Helvetica-Bold", fontSize=8, fillColor=colors.white))
    d.add(String(192, 45, "(Redução, Margens, Fretes)", fontName="Helvetica", fontSize=6.5, fillColor=colors.HexColor("#94a3b8")))
    
    # Right: Proforma Invoice
    d.add(Rect(360, 32, 112, 42, fillColor=colors.HexColor("#2563eb"), strokeColor=colors.HexColor("#1d4ed8"), rx=5, ry=5))
    d.add(String(368, 57, "Proforma Invoice (PI)", fontName="Helvetica-Bold", fontSize=8.5, fillColor=colors.white))
    d.add(String(368, 47, "• Conversão Risco USD", fontName="Helvetica", fontSize=6.5, fillColor=colors.HexColor("#dbeafe")))
    d.add(String(368, 39, "• PDF Comercial & Excel", fontName="Helvetica", fontSize=6.5, fillColor=colors.HexColor("#dbeafe")))
    
    # Connections
    d.add(Line(130, 85, 185, 58, strokeColor=colors.HexColor("#94a3b8"), strokeWidth=0.75))
    d.add(Line(130, 55, 185, 53, strokeColor=colors.HexColor("#94a3b8"), strokeWidth=0.75))
    d.add(Line(130, 25, 185, 48, strokeColor=colors.HexColor("#94a3b8"), strokeWidth=0.75))
    
    d.add(Line(310, 53, 360, 53, strokeColor=colors.HexColor("#2563eb"), strokeWidth=1.5))
    d.add(Polygon([354, 56, 360, 53, 354, 50], fillColor=colors.HexColor("#2563eb"), strokeColor=None))
    
    return d

def main():
    pdf_path = "c:/Portifólio/pi-web/Docs/MANUAL_DO_USUARIO.pdf"
    os.makedirs(os.path.dirname(pdf_path), exist_ok=True)

    doc = SimpleDocTemplate(
        pdf_path,
        pagesize=A4,
        leftMargin=54,
        rightMargin=54,
        topMargin=72,
        bottomMargin=72
    )

    styles = getSampleStyleSheet()

    title_style = ParagraphStyle(
        name="CoverTitle",
        fontName="Helvetica-Bold",
        fontSize=24,
        leading=28,
        textColor=colors.HexColor("#1e293b"),
        spaceAfter=15,
        alignment=0
    )

    subtitle_style = ParagraphStyle(
        name="CoverSubtitle",
        fontName="Helvetica",
        fontSize=12,
        leading=16,
        textColor=colors.HexColor("#2563eb"), # Blue themed subtitle
        spaceAfter=30,
        alignment=0
    )

    meta_style = ParagraphStyle(
        name="CoverMeta",
        fontName="Helvetica",
        fontSize=9,
        leading=14,
        textColor=colors.HexColor("#475569"),
        spaceAfter=4
    )

    h1_style = ParagraphStyle(
        name="SectionH1",
        fontName="Helvetica-Bold",
        fontSize=14,
        leading=18,
        textColor=colors.HexColor("#1e293b"),
        spaceBefore=18,
        spaceAfter=10,
        keepWithNext=True
    )

    h2_style = ParagraphStyle(
        name="SectionH2",
        fontName="Helvetica-Bold",
        fontSize=10.5,
        leading=14,
        textColor=colors.HexColor("#2563eb"),
        spaceBefore=12,
        spaceAfter=6,
        keepWithNext=True
    )

    body_style = ParagraphStyle(
        name="ManualBody",
        fontName="Helvetica",
        fontSize=9,
        leading=13,
        textColor=colors.HexColor("#334155"),
        spaceAfter=8
    )

    list_style = ParagraphStyle(
        name="ManualList",
        fontName="Helvetica",
        fontSize=9,
        leading=13,
        textColor=colors.HexColor("#334155"),
        leftIndent=15,
        firstLineIndent=-10,
        spaceAfter=4
    )

    story = []

    # ==================== CAPA (COVER PAGE) ====================
    story.append(Spacer(1, 15))
    banner_data = [[""]]
    banner_table = Table(banner_data, colWidths=[487], rowHeights=[15])
    banner_table.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#1e293b")),
    ]))
    story.append(banner_table)
    story.append(Spacer(1, 40))

    cover_data = [
        ["", Paragraph("MANUAL COMPLETO DO USUÁRIO", title_style)]
    ]
    cover_table = Table(cover_data, colWidths=[8, 479])
    cover_table.setStyle(TableStyle([
        ('LINELEFT', (0,0), (0,-1), 5, colors.HexColor("#2563eb")), # Blue line for PI module
        ('LEFTPADDING', (1,0), (1,-1), 12),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
        ('BOTTOMPADDING', (0,0), (-1,-1), 0),
        ('TOPPADDING', (0,0), (-1,-1), 0),
    ]))
    story.append(cover_table)
    story.append(Spacer(1, 10))
    story.append(Paragraph("Módulo PI • Geração e Emissão de Proforma Invoices e Tabelas de Exportação", subtitle_style))
    story.append(Spacer(1, 180))

    # Metadata card
    meta_data = [
        [Paragraph("<b>Sistema:</b>", meta_style), Paragraph("PI-Web Desktop (Gestão de Proformas e Custos)", meta_style)],
        [Paragraph("<b>Módulo Integrado:</b>", meta_style), Paragraph("PI (Proforma Invoice / Comercial / Exportação)", meta_style)],
        [Paragraph("<b>Fornecedores Integrados:</b>", meta_style), Paragraph("Karam's, Koyo, Ferguile, Livintus", meta_style)],
        [Paragraph("<b>Interface Visual:</b>", meta_style), Paragraph("Tema Dark Premium (Slate/Blue) em React com Lucide Icons", meta_style)],
        [Paragraph("<b>Versão do Sistema:</b>", meta_style), Paragraph("2.0 - Nova Versão Homologada com Câmbios Específicos", meta_style)],
        [Paragraph("<b>Data de Emissão:</b>", meta_style), Paragraph("Julho de 2026", meta_style)],
        [Paragraph("<b>Público-Alvo:</b>", meta_style), Paragraph("Equipes Operacionais, Analistas e Assistentes Comerciais", meta_style)],
    ]
    meta_table = Table(meta_data, colWidths=[130, 357])
    meta_table.setStyle(TableStyle([
        ('ALIGN', (0,0), (-1,-1), 'LEFT'),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('BOTTOMPADDING', (0,0), (-1,-1), 4),
        ('TOPPADDING', (0,0), (-1,-1), 4),
        ('LEFTPADDING', (0,0), (-1,-1), 0),
        ('RIGHTPADDING', (0,0), (-1,-1), 0),
    ]))

    card_table = Table([[meta_table]], colWidths=[487])
    card_table.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#f8fafc")),
        ('BOX', (0,0), (-1,-1), 0.5, colors.HexColor("#cbd5e1")),
        ('LEFTPADDING', (0,0), (-1,-1), 15),
        ('RIGHTPADDING', (0,0), (-1,-1), 15),
        ('TOPPADDING', (0,0), (-1,-1), 12),
        ('BOTTOMPADDING', (0,0), (-1,-1), 12),
    ]))
    story.append(card_table)
    story.append(PageBreak())

    # ==================== SEÇÃO 1 ====================
    story.append(Paragraph("1. Introdução ao Módulo PI", h1_style))
    story.append(Paragraph(
        "O módulo <b>PI (Proforma Invoice)</b> é a ferramenta central de negociação e emissão comercial do sistema "
        "<b>PI-Web</b>. Uma Proforma Invoice funciona como um orçamento formal de exportação de móveis "
        "e estofados, detalhando as condições de venda acordadas entre a fábrica brasileira (fornecedor) "
        "e o importador internacional (cliente).",
        body_style
    ))
    story.append(Paragraph(
        "A principal vantagem técnica do sistema reside na sua inteligência matemática de conversão de moedas, "
        "comissionamentos e rateio logístico em tempo real. O operador não precisa calcular em planilhas externas "
        "quanto de frete cada assento ou módulo ocupa, pois o sistema automatiza o rateio utilizando o volume cúbico (m³).",
        body_style
    ))
    
    story.append(make_callout(
        "A Proforma Invoice (PI) antecede a fatura comercial definitiva (Commercial Invoice) "
        "e é indispensável para que o importador providencie o fechamento de câmbio internacional "
        "e a contratação de fretes/seguros em conformidade com as regras aduaneiras.",
        "info"
    ))
    story.append(Spacer(1, 10))

    # Architecture diagram insertion
    story.append(Paragraph("Figura 1: Arquitetura de Fluxo de Dados do Módulo PI", ParagraphStyle('FigStyle', fontName='Helvetica-Bold', fontSize=8, leading=10, textColor=colors.HexColor("#475569"), alignment=1, spaceAfter=8)))
    story.append(make_architecture_diagram())
    story.append(PageBreak())

    # ==================== SEÇÃO 2 ====================
    story.append(Paragraph("2. Cadastros de Apoio e Tabelas de Preços", h1_style))
    story.append(Paragraph(
        "A consistência de uma PI depende dos dados cadastrados previamente no sistema. Abaixo estão descritas "
        "as principais tabelas de apoio que devem ser validadas antes do início do fluxo comercial.",
        body_style
    ))
    
    story.append(Paragraph("2.1. Cadastro de Fornecedores (Fábricas)", h2_style))
    story.append(Paragraph(
        "Os fornecedores representam as indústrias produtoras. O sistema possui cadastros otimizados e dados bancários "
        "internacionais integrados para <b>Karam's</b>, <b>Koyo</b>, <b>Ferguile</b> e <b>Livintus</b>.",
        body_style
    ))
    
    forn_fields = [
        ("CNPJ e Inscrição Estadual", "Identificação fiscal oficial das indústrias no território brasileiro."),
        ("Endereço Completo", "Necessário para a emissão correta da fatura comercial e documentos de origem."),
        ("Incoterms Preferenciais", "Geralmente configurado como FOB (Free On Board) ou EXW (Ex Works) de acordo com a logística padrão da fábrica."),
        ("Dados Bancários (Swift / IBAN)", "Contas e canais bancários internacionais pré-configurados para receber pagamentos em Dólar de exportação, incluindo bancos intermediários (ex: Bank of America, Banco Rendimento, Sicredi).")
    ]
    story.append(make_field_table(forn_fields))
    story.append(Spacer(1, 10))

    story.append(Paragraph("2.2. Importação e Cadastro de Módulos & Tecidos", h2_style))
    story.append(Paragraph(
        "Para que o sistema possua preços de tabela, o operador deve realizar a importação de planilhas de fábrica "
        "na tela de <b>Importação</b>. O sistema mapeia os tecidos em grupos e gera os cruzamentos de preços.",
        body_style
    ))
    
    prod_fields = [
        ("Módulos (Estruturas)", "Cadastro físico do estofado contendo largura, profundidade, altura, peso e cubagem m³."),
        ("Grupos de Tecidos", "Tabelas de tecidos divididas por faixas de preço/categoria. A composição da peça baseia-se na combinação [Módulo + Tecido]."),
        ("Tabela de Preços BRL", "Preço oficial em Reais (BRL) vigente da fábrica. Esta é a base de partida sobre a qual são executadas as conversões e markups.")
    ]
    story.append(make_field_table(prod_fields))
    story.append(PageBreak())

    # ==================== SEÇÃO 3 ====================
    story.append(Paragraph("3. Configurações Globais de Câmbio e Taxas", h1_style))
    story.append(Paragraph(
        "O controle cambial e de markups é realizado de forma global na tela de <b>Configurações</b> (`ConfiguracoesPage.tsx`). "
        "Esses parâmetros governam o cálculo de todas as PIs geradas no sistema.",
        body_style
    ))
    
    config_sections = [
        ("Margens Comerciais", "Campos para 'Porcentagem de Comissão' (comissão padrão do canal de vendas) e 'Porcentagem de Gordura' (margem de segurança)."),
        ("Gestão Cambial", "Campos para 'Cotação Comercial' (atualização da cotação do Banco Central) e 'Redução do Dólar' (margem de redução de segurança cambial)."),
        ("Controle de Fretes", "Listagem e cadastramento de custos logísticos estimados por tipo de contêiner ou veículo de transporte.")
    ]
    story.append(make_ui_wireframe("Configurações Globais do Sistema", config_sections))
    story.append(Spacer(1, 10))

    story.append(Paragraph("3.1. O Conceito de Dólar Risco", h2_style))
    story.append(Paragraph(
        "Devido à flutuação de câmbio durante o ciclo de fabricação e embarque, o sistema utiliza o conceito de <b>Dólar Risco</b>. "
        "O Dólar Risco é a taxa de câmbio artificialmente reduzida aplicada na conversão de preços para a Proforma.",
        body_style
    ))
    
    story.append(make_callout(
        "<b>Regra Especial por Fornecedor (Parâmetro Crítico):</b><br/>"
        "1. Para **Karam's e Koyo**: O Dólar Risco é calculado dinamicamente subtraindo a redução da cotação atual:<br/>"
        "   <i>Cotação Risco = Dólar Comercial - Redução Dólar</i> (Ex: R$ 5,30 - R$ 0,30 = R$ 5,00).<br/>"
        "2. Para **Ferguile e Livintus**: O sistema trata o campo 'Valor de Redução' como uma cotação **FIXA** predefinida.<br/>"
        "   <i>Cotação Risco = Valor de Redução Dólar</i> (Ex: se no cadastro a redução for inserida como R$ 4,80, a cotação risco será travada em R$ 4,80).",
        "warning"
    ))
    story.append(PageBreak())

    # ==================== SEÇÃO 4 ====================
    story.append(Paragraph("4. Geração de Proforma Invoice (Passo a Passo)", h1_style))
    story.append(Paragraph(
        "A tela `ProformaInvoiceV2Page.tsx` centraliza todo o fluxo operacional de emissão. Siga as instruções passo a passo "
        "abaixo para preencher e validar uma PI comercial de exportação.",
        body_style
    ))
    
    story.append(Paragraph("Passo 1: Criação do Documento e Cabeçalho", h2_style))
    story.append(Paragraph(
        "Clique no botão de Nova PI. Preencha as informações do cabeçalho:",
        body_style
    ))
    
    cabecalho_fields = [
        ("Prefixo e Sequência", "Prefixo padrão (ex: SW, FG, LV) e número sequencial gerado automaticamente pelo sistema."),
        ("Cliente e Fornecedor", "Seletores com busca inteligente. Ao selecionar o fornecedor, o sistema identifica se aplicará cotação fixa (Ferguile/Livintus) ou cotação dinâmica com redução (Karam's/Koyo)."),
        ("Tipo de Frete", "Seletor de frete (ex: Container 40ft, Truck, EXW). O sistema busca o custo total desse frete configurado no banco de dados e calcula o rateio correspondente."),
        ("Opções de Exibição", "Permite definir a Moeda de Exibição da PI (USD ou BRL) e a Validade da Proposta em dias (padrão 30 dias).")
    ]
    story.append(make_field_table(cabecalho_fields))
    story.append(Spacer(1, 10))

    story.append(Paragraph("Passo 2: Inserção de Itens na Grade", h2_style))
    story.append(Paragraph(
        "No painel 'Adicionar Itens', utilize o seletor premium de Módulo + Tecido. Ao selecionar o item:",
        body_style
    ))
    
    itens_fields = [
        ("Largura, Prof., Altura", "Dimensões físicas cadastradas na ficha técnica, que podem ser ajustadas pontualmente para pedidos sob medida."),
        ("P.A. (Pontos Acabamento)", "Quantidade de pontos de acabamento usados no rateio de custos de acabamento ou frete se configurado."),
        ("Volume Cubado (m³)", "Calculado automaticamente em metros cúbicos:<br/><i>Volume = (Largura × Profundidade × Altura) / 1.000.000</i>. O volume é recalculado dinamicamente caso você altere as dimensões."),
        ("Campos de Customização", "O operador pode preencher manualmente informações comerciais como o tipo de pé (Feet), acabamentos adicionais (Finishing) e Observações especiais por item.")
    ]
    story.append(make_field_table(itens_fields))
    story.append(Spacer(1, 10))
    
    story.append(make_callout(
        "Para acelerar o preenchimento, o sistema possui busca fonética por nome de módulo ou tecido "
        "e possibilita duplicar linhas de itens semelhantes para ajustes rápidos de dimensões.",
        "tip"
    ))
    story.append(PageBreak())

    # ==================== SEÇÃO 5 ====================
    story.append(Paragraph("5. Engine de Cálculo Comercial (A Matemática da PI)", h1_style))
    story.append(Paragraph(
        "Para garantir paridade contábil e eliminar erros humanos, o sistema processa automaticamente "
        "em tempo real quatro operações matemáticas fundamentais a cada modificação na grade de itens.",
        body_style
    ))

    # Flowchart insertion
    story.append(Paragraph("Figura 2: Fluxo Contábil e de Cálculo Dinâmico por Item na PI", ParagraphStyle('FigStyle2', fontName='Helvetica-Bold', fontSize=8, leading=10, textColor=colors.HexColor("#475569"), alignment=1, spaceAfter=8)))
    story.append(make_calculation_flowchart())
    story.append(Spacer(1, 15))

    math_steps = [
        ("Conversão Base (USD)", "Converte o valor original do item in Reais (BRL) cadastrado na tabela de fábrica para Dólar, dividindo-o pela cotação risco do estudo:<br/>"
                                "<i>Valor Base USD = Preço Tabela BRL / Cotação Risco</i>"),
        ("Preço EXW (Unitário USD)", "Adiciona as margens e a comissão configurada nas Configurações Globais ao valor base do item:<br/>"
                                     "<i>EXW USD = Valor Base USD × (1 + % Comissão / 100 + % Gordura / 100)</i>"),
        ("Rateio do Frete Internacional", "O custo do frete contratado é dividido proporcionalmente ao <b>Volume (m³)</b> do item em relação ao volume somado de toda a PI. "
                                          "Caso o tipo de rateio esteja como 'IGUAL', o frete é dividido igualmente pela quantidade de módulos.<br/>"
                                          "<i>Fator de Frete por m³ = Valor Total Frete USD / Volume Total m³ da PI</i><br/>"
                                          "<i>Frete Unitário do Item USD = Fator de Frete por m³ × Volume m³ Individual do Item</i>"),
        ("Preço Final Unitário da Linha", "Soma o preço na fábrica (EXW) e o custo de transporte alocado do item:<br/>"
                                          "<i>Preço Final USD = Preço EXW USD + Frete Unitário USD</i>")
    ]
    story.append(make_field_table(math_steps))
    story.append(Spacer(1, 10))
    
    story.append(make_callout(
        "<b>Exemplo Prático de Rateio de Frete:</b><br/>"
        "Imagine um contêiner com frete contratado a **USD 3.000** e cubagem total de itens de **60 m³**.<br/>"
        "1. O fator de rateio é: 3.000 / 60 = **USD 50,00 por m³**.<br/>"
        "2. Uma poltrona pequena que ocupa **0,4 m³** recebe: 0,4 × 50 = **USD 20,00** de frete.<br/>"
        "3. Um sofá grande que ocupa **1,8 m³** recebe: 1,8 × 50 = **USD 90,00** de frete.<br/>"
        "Isso evita distorções comerciais de cobrar o mesmo frete para volumes muito diferentes.",
        "info"
    ))
    story.append(PageBreak())

    # ==================== SEÇÃO 6 ====================
    story.append(Paragraph("6. Impressão, Exportação e Relatórios Comerciais", h1_style))
    story.append(Paragraph(
        "A Proforma Invoice gerada pode ser enviada ao cliente ou arquivada utilizando dois métodos de saída profissionais.",
        body_style
    ))
    
    story.append(Paragraph("6.1. Impressão PDF Premium", h2_style))
    story.append(Paragraph(
        "O botão de Impressão (`PrintPiPage.tsx` ou `PrintPiFerguilePage.tsx`) exibe o documento formatado "
        "com visual comercial de exportação limpo, ocultando o menu lateral e barras de ferramentas do sistema.",
        body_style
    ))
    
    print_options = [
        ("Design Geral (Karam's / Koyo)", "Fatura comercial tradicional com cabeçalho azul marinho, dados do importador e exportador, termos de pagamento, tabela de itens e campos de assinatura."),
        ("Design Especial (Ferguile)", "Algumas marcas (como Ferguile) possuem um template de impressão customizado contendo logo e especificações bancárias diferenciadas na base do PDF, garantindo conformidade com o canal comercial dessa marca.")
    ]
    story.append(make_field_table(print_options))
    story.append(Spacer(1, 10))

    story.append(Paragraph("6.2. Exportação para Excel (XLSX)", h2_style))
    story.append(Paragraph(
        "O botão 'Exportar Excel' aciona a exportação completa da Proforma formatada, preservando a identidade visual, "
        "as colunas de dados, metadados de frete, detalhes bancários internacionais e as fórmulas matemáticas das linhas.",
        body_style
    ))
    
    story.append(make_callout(
        "A exportação para Excel preserva a integridade de todas as fórmulas de cálculo. Isso significa que se o cliente "
        "internacional solicitar uma mudança rápida de quantidades fora do sistema, a planilha recalculará os totais e o rateio "
        "de frete de forma imediata.",
        "tip"
    ))
    story.append(Spacer(1, 10))

    # ==================== SEÇÃO 7 ====================
    story.append(Paragraph("7. Resolução de Problemas Comuns (FAQ)", h1_style))
    story.append(Paragraph(
        "Respostas rápidas para as principais dúvidas operacionais que as funcionárias e operadores comerciais podem encontrar:",
        body_style
    ))
    
    faq_data = [
        ("Por que os botões 'Salvar' ou 'Descartar' sumiram da tela?", 
         "Isso ocorria anteriormente em telas menores ou de notebooks devido a limitações de espaço vertical. Corrigimos esta tela implementando um limite máximo de altura (`max-height`) e barras de rolagem inteligentes. Agora, basta usar o scroll do mouse ou rolar a barra lateral do modal para acessar os botões."),
        ("Como mudo a cotação padrão do dólar?", 
         "Vá na tela de Configurações Globais e altere o campo 'Cotação Comercial'. O sistema atualizará automaticamente o Dólar Risco das novas PIs. Para PIs já salvas, o sistema mantém o câmbio original para não distorcer negociações passadas."),
        ("Por que a comissão não está aparecendo na impressão?", 
         "No painel lateral direito de parâmetros da PI, verifique se a opção 'Exibir Comissão' está ativada. Se estiver desmarcada, a comissão é calculada internamente no sistema, mas é omitida da via impressa enviada para o comprador."),
        ("Por que o frete unitário de um item mudou quando adicionei outro produto?", 
         "Como o frete é rateado pelo volume cúbico (m³), a adição ou remoção de produtos altera o volume cúbico total da carga, o que altera a proporção de frete alocada para cada um dos itens individuais.")
    ]
    
    faq_list = []
    for q, a in faq_data:
        faq_list.append(Paragraph(f"<b>P: {q}</b><br/>R: {a}<br/>", list_style))
        faq_list.append(Spacer(1, 4))
    story.extend(faq_list)

    # Build document
    doc.build(story, canvasmaker=NumberedCanvas)
    print("PDF Manual PI gerado com sucesso!")

if __name__ == "__main__":
    main()
