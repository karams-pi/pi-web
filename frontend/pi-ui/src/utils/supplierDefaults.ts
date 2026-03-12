
export interface SupplierMetadata {
  name: string;
  cnpj: string;
  address: string;
  city: string;
  zip: string;
  state: string;
  country: string;
  email: string;
  website: string;
  phone: string;
  logo: string;
  bankDetails: {
    intermediary?: string;
    intermediaryAddress?: string;
    intermediarySwift?: string;
    intermediaryAccount?: string;
    beneficiary: string;
    beneficiaryAddress?: string;
    beneficiarySwift: string;
    beneficiaryIban?: string;
    beneficiaryAccount: string;
    beneficiaryName: string;
  };
  details: {
    brand: string;
    ncm: string;
    origin: string;
  };
}

export const SUPPLIERS: Record<string, SupplierMetadata> = {
  karams: {
    name: "KARAM'S INDUSTRIA E COMERCIO DE ESTOFADOS LTDA",
    cnpj: "02.670.170/0001-09",
    address: "ROD PR 180 - KM 04 - LOTE 11 N8 B1 BAIRRO RURAL",
    city: "TERRA RICA",
    zip: "87890-000",
    state: "PARANÁ",
    country: "BRASIL",
    email: "KARAMS@KARAMS.COM.BR",
    website: "https://karams.com.br/",
    phone: "(44) 3441-8400 | (44) 3441-1908",
    logo: "/logo-karams.png",
    bankDetails: {
      intermediary: "BANK OF AMERICA, N.A.",
      intermediaryAddress: "NEW YORK - US",
      intermediarySwift: "BOFAUS3N",
      intermediaryAccount: "6550925836",
      beneficiary: "BANCO RENDIMENTO S/A",
      beneficiaryAddress: "SÃO PAULO - BR",
      beneficiarySwift: "RENDBRSP",
      beneficiaryIban: "BR4468900810000010025069901i1",
      beneficiaryAccount: "00250699000148",
      beneficiaryName: "KARAM'S INDUSTRIA E COMERCIO DE ESTOFADOS LTDA",
    },
    details: {
      brand: "Karams",
      ncm: "94016100",
      origin: "Hecho en Brasil",
    }
  },
  koyo: {
    name: "KOYO INDUSTRIA E COMERCIO DE ESTOFADOS LTDA",
    cnpj: "02.670.170/0001-09", // Reuse Karams if unknown
    address: "ROD PR 180 - KM 04 - LOTE 11 N8 B1 BAIRRO RURAL",
    city: "TERRA RICA",
    zip: "87890-000",
    state: "PARANÁ",
    country: "BRASIL",
    email: "KOYO@KOYO.COM.BR",
    website: "https://karams.com.br/",
    phone: "(44) 3441-8400",
    logo: "/logo-koyo.jpeg",
    bankDetails: {
      intermediary: "BANK OF AMERICA, N.A.",
      intermediaryAddress: "NEW YORK - US",
      intermediarySwift: "BOFAUS3N",
      intermediaryAccount: "6550925836",
      beneficiary: "BANCO RENDIMENTO S/A",
      beneficiaryAddress: "SÃO PAULO - BR",
      beneficiarySwift: "RENDBRSP",
      beneficiaryIban: "BR4468900810000010025069901i1",
      beneficiaryAccount: "00250699000148",
      beneficiaryName: "KOYO INDUSTRIA E COMERCIO DE ESTOFADOS LTDA",
    },
    details: {
      brand: "Koyo",
      ncm: "94016100",
      origin: "Hecho en Brasil",
    }
  },
  ferguile: {
    name: "FERGUILE ESTOFADOS LTDA",
    cnpj: "27.499.537/0001-02",
    address: "RUA CANÁRIO DO BREJO, 630 - RIBEIRÃO BANDEIRANTE DO NORTE",
    city: "ARAPONGAS",
    zip: "86703-797",
    state: "PARANÁ",
    country: "BRASIL",
    email: "financeiro@ferguile.com.br",
    website: "www.ferguile.com.br",
    phone: "(43) 3252-1234", // Placeholder
    logo: "/logo-ferguile_.png",
    bankDetails: {
      beneficiary: "SICREDI 748",
      beneficiarySwift: "BCSIBRRS748",
      beneficiaryIban: "BR7001181521007230000003252C1",
      beneficiaryAccount: "0723/032524",
      beneficiaryName: "FERGUILE ESTOFADOS LTDA",
    },
    details: {
      brand: "Ferguile",
      ncm: "94016100",
      origin: "Hecho en Brasil",
    }
  },
  livintus: {
    name: "LIVINTUS ESTOFADOS LTDA",
    cnpj: "27.499.537/0001-02", // Reuse Ferguile if unknown
    address: "RUA CANÁRIO DO BREJO, 630 - RIBEIRÃO BANDEIRANTE DO NORTE",
    city: "ARAPONGAS",
    zip: "86703-797",
    state: "PARANÁ",
    country: "BRASIL",
    email: "comercial@livintus.com.br",
    website: "www.livintus.com.br",
    phone: "(43) 3252-1234",
    logo: "/logo-livintus.png",
    bankDetails: {
      beneficiary: "SICREDI 748",
      beneficiarySwift: "BCSIBRRS748",
      beneficiaryIban: "BR7001181521007230000003252C1",
      beneficiaryAccount: "0723/032524",
      beneficiaryName: "LIVINTUS ESTOFADOS LTDA",
    },
    details: {
      brand: "Livintus",
      ncm: "94016100",
      origin: "Hecho en Brasil",
    }
  }
};

export function getSupplierMetadata(name: string): SupplierMetadata {
  const n = name.toLowerCase();
  if (n.includes("koyo")) return SUPPLIERS.koyo;
  if (n.includes("livintus")) return SUPPLIERS.livintus;
  if (n.includes("ferguile")) return SUPPLIERS.ferguile;
  return SUPPLIERS.karams; // Default
}
