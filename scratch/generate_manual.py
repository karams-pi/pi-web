import os
import sys
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.pdfgen import canvas
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether
)
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle

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
        self.drawString(54, 805, "MANUAL DE UTILIZAÇÃO DO SISTEMA  |  MÓDULO EDC")
        
        self.setFont("Helvetica", 8)
        self.setFillColor(slate_gray)
        self.drawRightString(541, 805, "PI-WEB DESKTOP")
        
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
        self.drawString(54, 38, "PI-Web  •  Módulo de Estimativa de Custos de Importação")
        
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
        title = "<b>REGRAS FISCAIS E CONFORMIDADE ADUANEIRA</b>"
        
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
    # Renders a dark-themed visual block representing the UI layout (matching the dark theme in the react code)
    bg_color = colors.HexColor("#0f172a") # Slate 900
    border_color = colors.HexColor("#334155") # Slate 700
    
    header_style = ParagraphStyle('UIHeader', fontName='Helvetica-Bold', fontSize=8.5, textColor=colors.HexColor("#10b981"))
    body_style = ParagraphStyle('UIBody', fontName='Helvetica', fontSize=8, leading=11, textColor=colors.HexColor("#94a3b8"))
    
    rows = []
    # Header row
    rows.append([Paragraph(f"<b>LAYOUT DA TELA: {title.upper()}</b>", header_style)])
    
    # Body sections
    body_text = "<br/>".join([f"• <b>{k}:</b> {v}" for k, v in sections])
    rows.append([Paragraph(body_text, body_style)])
    
    t = Table(rows, colWidths=[487])
    t.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), bg_color),
        ('BOX', (0,0), (-1,-1), 1.5, colors.HexColor("#0d9488")), # Teal border
        ('TOPPADDING', (0,0), (-1,-1), 8),
        ('BOTTOMPADDING', (0,0), (-1,-1), 8),
        ('LEFTPADDING', (0,0), (-1,-1), 12),
        ('RIGHTPADDING', (0,0), (-1,-1), 12),
        ('LINEBELOW', (0,0), (0,0), 1, border_color),
    ]))
    return t

def main():
    pdf_path = "c:/Portifólio/pi-web/Docs/Manual_Completo_EDC.pdf"
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

    # Custom styles
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
        textColor=colors.HexColor("#0d9488"),
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
        textColor=colors.HexColor("#0d9488"),
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
        ('LINELEFT', (0,0), (0,-1), 5, colors.HexColor("#0d9488")), # teal line
        ('LEFTPADDING', (1,0), (1,-1), 12),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
        ('BOTTOMPADDING', (0,0), (-1,-1), 0),
        ('TOPPADDING', (0,0), (-1,-1), 0),
    ]))
    story.append(cover_table)
    story.append(Spacer(1, 10))
    story.append(Paragraph("Módulo EDC • Estimativa de Custos de Importação e Nacionalização de Produtos", subtitle_style))
    story.append(Spacer(1, 200))

    # Metadata card
    meta_data = [
        [Paragraph("<b>Sistema:</b>", meta_style), Paragraph("PI-Web Desktop (Gestão de Proformas e Custo Alfandegado)", meta_style)],
        [Paragraph("<b>Módulo Integrado:</b>", meta_style), Paragraph("EDC (Estudo de Custos / Nacionalização)", meta_style)],
        [Paragraph("<b>Interface Visual:</b>", meta_style), Paragraph("Tema Dark Premium (Slate/Teal) em React com Icons Lucide", meta_style)],
        [Paragraph("<b>Versão do Sistema:</b>", meta_style), Paragraph("1.0 - Homologação de Importações", meta_style)],
        [Paragraph("<b>Data de Emissão:</b>", meta_style), Paragraph("Junho de 2026", meta_style)],
        [Paragraph("<b>Equipe Responsável:</b>", meta_style), Paragraph("Departamento de T.I. & Comércio Exterior", meta_style)],
    ]
    meta_table = Table(meta_data, colWidths=[110, 377])
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
    story.append(Paragraph("1. Introdução ao Módulo EDC", h1_style))
    story.append(Paragraph(
        "O módulo <b>EDC (Estudo de Custos)</b> é a ferramenta central de inteligência aduaneira do sistema "
        "<b>PI-Web</b>. Ele permite projetar com precisão matemática todos os impostos de nacionalização "
        "e taxas portuárias brasileiras antes de efetuar o embarque das mercadorias de móveis e tecidos.",
        body_style
    ))
    story.append(Paragraph(
        "O sistema está integrado com um banco de dados unificado de <b>NCMs</b>, <b>Importadores</b>, "
        "<b>Exportadores</b> e <b>Produtos</b>, minimizando o trabalho manual e garantindo consistência tributária. "
        "A interface visual foi concebida sob um tema Dark moderno e intuitivo, facilitando longas jornadas de trabalho do analista.",
        body_style
    ))
    
    story.append(make_callout(
        "Toda a navegação pelo módulo EDC é orientada por cabeçalhos padronizados. "
        "Em cada página do sistema há uma linha horizontal com degradê de cores que reflete o contexto da rotina: "
        "verde (#10b981) para rotinas financeiras e de cálculo, azul (#3b82f6) para dados de suporte, e laranja (#f59e0b) para catálogo de produtos.",
        "info"
    ))
    story.append(Spacer(1, 10))

    # ==================== SEÇÃO 2 ====================
    story.append(Paragraph("2. Painel de Controle (Dashboard EDC)", h1_style))
    story.append(Paragraph(
        "A tela de entrada (`EdcDashboard.tsx`) apresenta uma visão geral das simulações "
        "ativas, indicadores chaves de performance (KPIs) e atalhos rápidos para navegação direta nos cadastros de apoio.",
        body_style
    ))
    
    dash_layout = [
        ("Cabeçalho", "Título 'Inteligência de Importação', ícone de calculadora e botão verde '+ Nova Simulação' no canto direito."),
        ("Grade de KPIs", "Quatro cartões informativos superiores detalhando volume de estudos, países ativos, portos utilizados e NCMs cadastrados."),
        ("Estudos Recentes (Esquerda)", "Tabela listando os 3 últimos estudos salvos, exibindo número de referência, data de criação, status e botão de seta para ver todos."),
        ("Atalhos Rápidos (Direita)", "Quatro botões secundários para acesso direto: 'Ver NCMs', 'Importadores', 'Taxas Aduaneiras' e 'Produtos EDC'.")
    ]
    story.append(make_ui_wireframe("Dashboard EDC (Painel Geral)", dash_layout))
    story.append(Spacer(1, 10))

    dash_fields = [
        ("Cartão Simulações", "Indica o número acumulado de estudos de nacionalização (ex: 24) e a taxa de crescimento (+12% vs mês anterior)."),
        ("Cartão Países Ativos", "Mostra o total de países de fornecedores cadastrados, destacando as principais origens (China, Itália, Índia)."),
        ("Cartão Logística Ativa", "Mostra os portos de entrada configurados (ex: Paranaguá - PNG, Santos - SSZ, Vitória - VIX)."),
        ("Cartão NCMs Monitorados", "Total de códigos fiscais cadastrados na base (ex: 158 NCMs) com indicador de atualização."),
        ("Atalhos de Cadastro", "Botões de clique rápido que redirecionam o usuário diretamente para as telas de dados mestres correspondentes.")
    ]
    story.append(make_field_table(dash_fields))
    story.append(PageBreak())

    # ==================== SEÇÃO 3 ====================
    story.append(Paragraph("3. Cadastros de Apoio (Dados Mestres)", h1_style))
    story.append(Paragraph(
        "Para realizar uma simulação precisa de custos, o sistema depende de dados mestres bem cadastrados. "
        "Abaixo estão detalhadas as telas de cadastro e a finalidade de cada campo na interface.",
        body_style
    ))
    
    story.append(Paragraph("3.1. Catálogo de NCMs (Classificação Fiscal)", h2_style))
    story.append(Paragraph(
        "A tela `NcmsPage.tsx` gerencia a base de Nomenclatura Comum do Mercosul (NCM) e suas respectivas alíquotas de impostos.",
        body_style
    ))

    ncm_layout = [
        ("Cabeçalho", "Título 'Catálogo de NCMs', ícone de livro azul e botão '+ Novo Código'."),
        ("Barra de Busca", "Filtro dinâmico localizado acima da tabela para busca imediata por código ou descrição."),
        ("Tabela de Dados", "Exibe colunas: Código (em badge cinza), Descrição (truncada com reticências para legibilidade), II (%), IPI (%), PIS/COF (%) e ICMS (%)."),
        ("Ações", "Botão de lápis para editar e lixeira vermelha para inativar o registro."),
        ("Modal Form", "Janela flutuante contendo campos de texto para Código NCM, Descrição e campos numéricos para alíquotas.")
    ]
    story.append(make_ui_wireframe("Catálogo de NCMs", ncm_layout))
    story.append(Spacer(1, 10))

    ncm_fields = [
        ("Código NCM", "Código de 8 dígitos sem pontuação (ex: 94016100). Usado para cruzar com o cadastro de produtos."),
        ("Descrição Completa", "Texto explicando detalhadamente a classificação fiscal (ex: Outros assentos, com armação de madeira, estofados)."),
        ("Alíquota II (%)", "Alíquota do Imposto de Importação (ex: 18.00). O valor cadastrado é em porcentagem comum (0 a 100)."),
        ("Alíquota IPI (%)", "Alíquota do Imposto sobre Produtos Industrializados (ex: 12.00)."),
        ("Alíquota PIS / COFINS (%)", "Campos separados para PIS (%) e COFINS (%) incidentes na importação."),
        ("ICMS Padrão (%)", "Alíquota básica de ICMS vinculada por padrão a este código fiscal (geralmente 19.00% no Paraná).")
    ]
    story.append(make_field_table(ncm_fields))
    story.append(PageBreak())

    # ==================== PAGE 4 ====================
    story.append(Paragraph("3.2. Cadastro de Importadores (Compradores Nacionais)", h2_style))
    story.append(Paragraph(
        "A tela `ImportadoresPage.tsx` gerencia as empresas brasileiras do grupo que figuram como declarantes nas DIs.",
        body_style
    ))
    
    imp_layout = [
        ("Cabeçalho", "Título 'Gestão de Importadores', ícone de prédio azul e botão '+ Novo Cliente'."),
        ("Barra de Busca", "Filtro por Razão Social ou CNPJ."),
        ("Tabela de Dados", "Colunas: Empresa/Razão Social (com ícone de prédio), CNPJ, Localização (badge com a UF, ex: PR), Regime Fiscal, ICMS Base (%) e Ações."),
        ("Modal Novo Importador", "Janela flutuante para preenchimento dos dados cadastrais e fiscais.")
    ]
    story.append(make_ui_wireframe("Cadastro de Importadores", imp_layout))
    story.append(Spacer(1, 10))

    imp_fields = [
        ("Razão Social", "Nome empresarial completo do importador no Brasil."),
        ("CNPJ", "Documento nacional de 14 dígitos. Usado para validações fiscais."),
        ("UF (Estado)", "Seletor de estado (ex: Paraná - PR, São Paulo - SP, Santa Catarina - SC). Define a alíquota interna de ICMS."),
        ("Regime Tributário", "Seletor com opções 'Lucro Real' ou 'Lucro Presumido'. Define regras de apropriação de créditos."),
        ("ICMS Padrão (%)", "Campo numérico para a alíquota de ICMS padrão do importador (ex: 19% para PR, 18% para SP).")
    ]
    story.append(make_field_table(imp_fields))
    story.append(Spacer(1, 10))

    story.append(Paragraph("3.3. Cadastro de Exportadores (Fornecedores Internacionais)", h2_style))
    story.append(Paragraph(
        "A tela `ExportadoresPage.tsx` centraliza os parceiros de negócios internacionais fabricantes dos produtos.",
        body_style
    ))

    exp_layout = [
        ("Cabeçalho", "Título 'Exportadores (Fornecedores)', ícone de globo roxo e botão '+ Novo Fornecedor'."),
        ("Tabela de Dados", "Exibe colunas: Nome, País de Origem (com ícone de pino de mapa), Tax ID / VAT, Incoterm Padrão (badge roxo), Contato e Ações."),
        ("Modal Cadastro", "Formulário de preenchimento com campos para Nome, País, Tax ID, Seletor Premium de Incoterm, Endereço e Contato.")
    ]
    story.append(make_ui_wireframe("Cadastro de Exportadores", exp_layout))
    story.append(Spacer(1, 10))

    exp_fields = [
        ("País de Origem", "País do fabricante (ex: China, Itália, Índia, Vietnã)."),
        ("Tax ID / VAT", "Identificação fiscal do fornecedor no país de origem."),
        ("Incoterm Padrão", "Termo de entrega padrão pré-cadastrado no fornecedor (ex: FOB, EXW, FCA, CIF). Auxilia no autopreenchimento de novos estudos."),
        ("Informações de Contato", "Nome do agente, telefone ou e-mail de contato do fornecedor.")
    ]
    story.append(make_field_table(exp_fields))
    story.append(PageBreak())

    # ==================== PAGE 5 ====================
    story.append(Paragraph("3.4. Catálogo de Produtos e Modelos EDC", h2_style))
    story.append(Paragraph(
        "A tela `ProdutosEdcPage.tsx` gerencia os produtos comercializados, registrando suas dimensões "
        "físicas e os modelos comerciais vinculados. O peso e o volume (cubagem) são essenciais para os rateios do frete.",
        body_style
    ))

    prod_layout = [
        ("Cabeçalho", "Título 'Catálogo de Produtos', ícone de pacote laranja e botão '+ Novo Produto'."),
        ("Barra de Busca", "Filtro dinâmico por referência técnica ou descrição."),
        ("Tabela de Dados", "Colunas: Referência, Descrição, NCM (badge cinza), U.M. (badge laranja), Peso Bruto, Volume (m³) e Ações."),
        ("Modal Produto", "Campos técnicos do produto. Se o produto já existir (modo edição), uma seção adicional 'Modelos Comerciais Vinculados' é exibida na parte inferior."),
        ("Modal de Sub-Modelo", "Janela secundária para cadastrar códigos e nomes comerciais específicos vinculados ao produto técnico principal.")
    ]
    story.append(make_ui_wireframe("Catálogo de Produtos", prod_layout))
    story.append(Spacer(1, 10))

    prod_fields = [
        ("Referência de Fábrica", "Código técnico único do produto (ex: FAB-TEX-001)."),
        ("Classificação NCM", "Seletor que busca os NCMs previamente cadastrados no catálogo do sistema."),
        ("Unidade de Medida (U.M.)", "Seletor contendo: UN (Unidade), KG (Quilograma) ou T (Tonelada)."),
        ("Peso Bruto", "Peso físico do produto com a embalagem de transporte. Determina rateio por peso."),
        ("Volume Total (m³)", "Cubagem física do produto (ex: 0.0450). Essencial para rateio por volume (m³) no container."),
        ("Modelos Comerciais", "Variações comerciais associadas ao mesmo código de fábrica (ex: tecido cor azul, cadeira acabamento linho)."),
        ("Ações de Sub-Modelo", "CRUD completo de modelos comerciais diretamente dentro do modal de edição do produto principal.")
    ]
    story.append(make_field_table(prod_fields))
    story.append(make_callout(
        "O sistema gera automaticamente um Modelo Comercial básico com o mesmo nome e referência do produto técnico "
        "no momento de sua criação. O usuário pode adicionar novos modelos conforme a necessidade de cores e tecidos.",
        "tip"
    ))
    story.append(PageBreak())

    # ==================== PAGE 6 ====================
    story.append(Paragraph("4. Parametrização de Custos e Regras Gerais", h1_style))
    story.append(Paragraph(
        "Esta seção detalha as telas que definem os parâmetros operacionais globais de despesas alfandegárias e alíquotas estaduais.",
        body_style
    ))
    
    story.append(Paragraph("4.1. Taxas Aduaneiras Pré-Configuradas", h2_style))
    story.append(Paragraph(
        "A tela `TaxasAduaneirasPage.tsx` gerencia a biblioteca de despesas fixas cobradas no porto de destino ou pelo despachante.",
        body_style
    ))

    tax_layout = [
        ("Cabeçalho", "Título 'Taxas Aduaneiras', ícone de moedas amarelas e botão '+ Nova Taxa'."),
        ("Tabela de Dados", "Exibe colunas: Descrição da Taxa/Despesa, Valor Base (formatado em decimal ou percentual), Moeda (badge), Tipo de Rateio e Ações."),
        ("Modal Cadastro", "Campos para Descrição, Seletor de Tipo (Fixo ou Percentual), Moeda (BRL ou USD) e Valor Base (campo numérico com 4 casas decimais).")
    ]
    story.append(make_ui_wireframe("Taxas Aduaneiras", tax_layout))
    story.append(Spacer(1, 10))

    tax_fields = [
        ("Descrição da Taxa", "Nome identificador da despesa (ex: THC, Siscomex, Desembaraço Aduaneiro)."),
        ("Tipo de Rateio", "Fixo (valor monetário absoluto) ou Percentual (calculado sobre outras bases no estudo)."),
        ("Moeda", "Moeda padrão de cobrança (BRL ou USD). Valores em USD são convertidos no câmbio do estudo."),
        ("Valor Base / (%)", "Valor padrão sugerido. Ex: se Tipo for Fixo, 150.00. Se for Percentual, 2.50 para representar 2.50%.")
    ]
    story.append(make_field_table(tax_fields))
    story.append(Spacer(1, 10))

    story.append(Paragraph("4.2. Configurações Fiscais (Matriz Tributária Estadual)", h2_style))
    story.append(Paragraph(
        "A tela `ConfiguracoesFiscaisPage.tsx` gerencia as alíquotas de ICMS e regras por UF, que alimentam o cálculo 'por dentro'.",
        body_style
    ))

    conf_layout = [
        ("Cabeçalho", "Título 'Configurações Fiscais (ICMS)', ícone de escudo verde e botão '+ Nova Regra UF'."),
        ("Tabela de Dados", "Colunas: Estado (UF em destaque 1.2rem), Alíquota ICMS (badge verde), Fundo de Combate à Pobreza (FCP %), Status Isenção IPI (ícone verde de check para isento ou ícone cinza para tributado) e Ações de exclusão.")
    ]
    story.append(make_ui_wireframe("Configurações Fiscais", conf_layout))
    story.append(Spacer(1, 10))
    story.append(make_callout(
        "A isenção de IPI configurada por estado impede que o sistema calcule o Imposto sobre Produtos Industrializados "
        "no cálculo por dentro do ICMS quando aplicável. O Fundo de Combate à Pobreza (FCP) é somado diretamente à alíquota de ICMS "
        "na composição da base de cálculo.",
        "legal"
    ))
    story.append(PageBreak())

    # ==================== PAGE 7 ====================
    story.append(Paragraph("5. Novo Estudo de Custos (Simulação Passo a Passo)", h1_style))
    story.append(Paragraph(
        "A tela `NovoEstudoEdcPage.tsx` é a central de simulações do sistema. Ela possui uma interface em duas colunas, "
        "permitindo ao analista alterar parâmetros na coluna direita e ver os totais estimados recalculados em tempo real.",
        body_style
    ))

    estudo_layout = [
        ("Cabeçalho", "Botão de seta para voltar, ícone de calculadora azul, título 'Nova Simulação' e linha de cabeçalho."),
        ("Grade Duas Colunas", "Esquerda: Formulários de Identificação e Itens da Proforma.<br/>Direita: Painel Fixo de Logística, Câmbio, Opções Fiscais Avançadas e live-totals."),
        ("Identificação (Esq)", "Campos: Referência Interna (gerada auto, ex: EDC-2026-4592), seletor de Importador (com ícone de prédio) e de Exportador (com ícone de globo). O exportador auto-carrega o Incoterm."),
        ("Itens da Proforma (Esq)", "Tabela dinâmica. Colunas: Modelo Comercial (seletor), U.M. (badge amarelo), Quantidade (campo numérico com peso kg dinâmico), FOB Unit. (USD), FOB Subfaturado Unit. (USD) (se ativo) e botão de lixeira."),
        ("Parâmetros (Dir)", "Campos: Câmbio USD, Spread/PTAX %, Frete Internacional USD, Seguro USD, Porto de Destino (seletor), Frete Informativo, Comissão % e check 'Exibir Comissão'."),
        ("Opções Fiscais (Dir)", "Campos avançados: Check 'Simular Subfaturamento (Split)', campo de Percentual Declarado (%), Método de ICMS (Simplificado vs Por Dentro Legal) e Tributos Federais (Simplificado vs Legal)."),
        ("Live Totals (Dir)", "Caixa de totais dinâmicos: FOB Total, FOB Declarado, Câmbio, Frete c/ PTAX, Seguro, Comissão e os custos nacionalizados final Cheio vs c/ SUB side-by-side.")
    ]
    story.append(make_ui_wireframe("Novo Estudo de Custos (Interface)", estudo_layout))
    story.append(Spacer(1, 10))

    estudo_fields = [
        ("Peso Dinâmico (⚖️)", "Ao selecionar um produto com U.M. = 'T' (Tonelada) e inserir a quantidade (ex: 2), o sistema exibe um badge azul '⚖️ 2.000 kg' sob a quantidade, auxiliando no controle de container."),
        ("FOB Subfaturado Unit.", "Coluna visível apenas se o check 'Simular Subfaturamento' estiver ativo. Permite sobrescrever o valor de declaração fiscal por item."),
        ("Custo Cheio vs c/ SUB", "A caixa de totais exibe o total BRL nacionalizado real projetado e, logo abaixo, o total com subfaturamento (Split) ativo, permitindo comparação financeira imediata."),
        ("Botão Gerar Estudo EDC", "Botão principal azul na lateral que valida as informações do formulário e redireciona o usuário para o relatório detalhado de nacionalização.")
    ]
    story.append(make_field_table(estudo_fields))
    story.append(PageBreak())

    # ==================== PAGE 8 ====================
    story.append(Paragraph("6. Relatório de Nacionalização (Resultados)", h1_style))
    story.append(Paragraph(
        "A tela `DetalheEstudoEdcPage.tsx` é gerada após a execução da engine de cálculos. "
        "Apresenta a consolidação fiscal do estudo em painéis estruturados.",
        body_style
    ))

    detalhe_layout = [
        ("Cabeçalho", "Título 'Relatório de Nacionalização', número do estudo, ícone de check verde e botões 'Imprimir' (ícone de impressora) e 'Exportar EDC' (ícone de download)."),
        ("Cards de Resumo Superior", "Três cartões lado a lado:<br/>1. Importador (CNPJ, IE, UF com borda azul)<br/>2. Exportador (País, Incoterm com borda roxa)<br/>3. Custo Total Nacionalizado (Valor em destaque 1.8rem, Câmbio Base, status do subfaturamento e métodos aplicados)."),
        ("Memória de Cálculo (Item)", "Tabela principal detalhando o custo de formação de cada item: Valor Aduaneiro, II, IPI, PIS/COF, Taxas Portuárias, ICMS e o Custo Final unitário em Reais."),
        ("Despesas Aduaneiras", "Tabela secundária detalhando as taxas locais cadastradas, o cálculo automático do AFRMM e a comissão comercial, totalizando em Reais na base."),
        ("Painéis de Conformidade", "Esquerda: Resumo de Carga Tributária (percentuais federais vs estaduais).<br/>Direita: Conformidade Fiscal (indica a data de geração e a UF fiscal do estudo).")
    ]
    story.append(make_ui_wireframe("Relatório de Nacionalização (Resultados)", detalhe_layout))
    story.append(Spacer(1, 10))

    detalhe_fields = [
        ("Ação Imprimir", "Executa a rotina `window.print()`, que dispara o layout de impressão CSS otimizado para papel A4, ocultando botões de navegação."),
        ("Ação Exportar EDC", "Dispara o download da planilha XLSX formatada com as exatas memórias de cálculo, imagens e taxas."),
        ("Cálculo do AFRMM", "Calcula e exibe automaticamente a taxa do AFRMM como 8% sobre o Frete Internacional Marítimo BRL."),
        ("Comissão Comercial", "Se marcada no estudo, é demonstrada como uma despesa aduaneira extra na tabela em Reais, baseada no FOB Total."),
        ("Resumo Carga Tributária", "Mostra o percentual que os Impostos Federais (II, IPI, PIS, COFINS) representam em relação ao custo final nacionalizado, comparado ao ICMS Estadual.")
    ]
    story.append(make_field_table(detalhe_fields))
    story.append(PageBreak())

    # ==================== PAGE 9 ====================
    story.append(Paragraph("7. Engine de Cálculo (A Matemática do EDC)", h1_style))
    story.append(Paragraph(
        "A precisão do módulo EDC é garantida pela engine de cálculos que executa de forma sequencial o cálculo tributário brasileiro.",
        body_style
    ))

    story.append(Paragraph("7.1. Lógica em Cascata de Impostos de Importação", h2_style))
    story.append(Paragraph(
        "O sistema opera de acordo com a legislação federal da Receita Federal e estadual da SEFAZ:",
        body_style
    ))

    formulas = [
        ("1. Câmbio Efetivo", "<i>Câmbio Efetivo = Cotação Dólar × (1 + Spread Cambial / 100)</i>"),
        ("2. Valor Aduaneiro do Item (BRL)", "<i>Valor Aduaneiro = (Preço FOB USD + Rateio Frete USD + Rateio Seguro USD) × Câmbio Efetivo</i>"),
        ("3. Imposto de Importação (II)", "<i>II = Valor Aduaneiro × Alíquota II</i>"),
        ("4. Imposto sobre Produtos Industrializados (IPI)", "<i>IPI = (Valor Aduaneiro + II) × Alíquota IPI</i>"),
        ("5. PIS e COFINS (Método Legal)", "<i>PIS = Valor Aduaneiro × Alíquota PIS</i><br/><i>COFINS = Valor Aduaneiro × Alíquota COFINS</i>"),
        ("6. ICMS - Cálculo Por Dentro (Legal)", "O ICMS tributa sobre si mesmo e sobre as despesas locais. Sua base é calculada da seguinte forma:<br/>"
                                                "<i>Base ICMS = (Valor Aduaneiro + II + IPI + PIS + COFINS + Taxas Portuárias Rateadas) / (1 - Alíquota ICMS)</i><br/>"
                                                "<i>ICMS = Base ICMS × Alíquota ICMS</i>")
    ]
    
    formula_table_data = []
    formula_table_data.append([
        Paragraph("<b>Etapa do Cálculo</b>", ParagraphStyle('FTH1', fontName='Helvetica-Bold', fontSize=9, textColor=colors.white)),
        Paragraph("<b>Fórmula Matemática Aplicada</b>", ParagraphStyle('FTH2', fontName='Helvetica-Bold', fontSize=9, textColor=colors.white))
    ])
    
    for step, f_text in formulas:
        formula_table_data.append([
            Paragraph(f"<b>{step}</b>", ParagraphStyle('FTD1', fontName='Helvetica', fontSize=8, leading=10, textColor=colors.HexColor("#1e293b"))),
            Paragraph(f_text, ParagraphStyle('FTD2', fontName='Helvetica', fontSize=8, leading=10, textColor=colors.HexColor("#475569")))
        ])
        
    t_formulas = Table(formula_table_data, colWidths=[180, 307])
    t_formulas.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#0d9488")), # teal header
        ('ALIGN', (0,0), (-1,-1), 'LEFT'),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('TOPPADDING', (0,0), (-1,-1), 5),
        ('BOTTOMPADDING', (0,0), (-1,-1), 5),
        ('LEFTPADDING', (0,0), (-1,-1), 6),
        ('RIGHTPADDING', (0,0), (-1,-1), 6),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, colors.HexColor("#f8fafc")]),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#cbd5e1")),
    ]))
    story.append(t_formulas)
    story.append(Spacer(1, 10))

    story.append(Paragraph("7.2. Métodos de Rateio de Custos Coletivos", h2_style))
    story.append(Paragraph(
        "As despesas gerais (como Frete Internacional, Seguro e Taxas Aduaneiras) são distribuídas para os itens individuais "
        "conforme a configuração do método de rateio selecionado na despesa:",
        body_style
    ))
    
    rateio_rules = [
        ("Valor FOB (Padrão)", "Distribui a despesa proporcionalmente ao valor FOB USD do item em relação ao FOB Total. Recomendado para comissões e despesas gerais de faturamento."),
        ("Quantidade", "Divide o valor total da despesa de forma igualitária pela quantidade total de peças, independente do tamanho ou valor do item."),
        ("Peso", "Rateia proporcionalmente ao peso líquido individual do item. Indicado para taxas aeroportuárias e de manuseio alfandegado."),
        ("Volume (M³)", "Rateia proporcionalmente à cubagem (M³) de cada item. É o método ideal e padrão para rateio do Frete Internacional Marítimo de containers.")
    ]
    
    rateio_list = []
    for name, desc in rateio_rules:
        rateio_list.append(Paragraph(f"• <b>{name}</b>: {desc}", list_style))
    story.extend(rateio_list)
    story.append(Spacer(1, 10))

    story.append(make_callout(
        "Diferente de planilhas Excel comuns, a engine realiza o cálculo intermediário com precisão de 8 casas decimais "
        "e arredonda legalmente para 2 casas apenas no fechamento final de custo de cada modelo. Isso elimina discrepâncias centesimais "
        "de arredondamento.",
        "tip"
    ))

    # Build document
    doc.build(story, canvasmaker=NumberedCanvas)
    print("PDF Manual gerado com sucesso!")

if __name__ == "__main__":
    main()
