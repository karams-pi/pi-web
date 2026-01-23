import { apiGet, apiPost, apiPut, apiDelete } from "./api";

export interface Configuracao {
  id: number;
  dataConfig: string;
  valorReducaoDolar: number;
  valorPercImposto: number;
  percentualComissao: number;
  percentualGordura: number;
  valorFCAFreteRodFronteira: number;
  valorDespesasFCA: number;
  valorFOBFretePortoParanagua: number;
  valorFOBDespPortRegDoc: number;
  valorFOBDespDespacAduaneiro: number;
  valorFOBDespCourier: number;
}

export const getConfigs = async () => {
  return await apiGet<Configuracao[]>("/api/configuracoes");
};

export const getLatestConfig = async () => {
  return await apiGet<Configuracao>("/api/configuracoes/latest");
};

export const getConfigById = async (id: number) => {
  return await apiGet<Configuracao>(`/api/configuracoes/${id}`);
};

export const createConfig = async (config: Omit<Configuracao, "id" | "dataConfig">) => {
  return await apiPost<Configuracao>("/api/configuracoes", config);
};

export const updateConfig = async (id: number, config: Configuracao) => {
  return await apiPut<void>(`/api/configuracoes/${id}`, config);
};

export const deleteConfig = async (id: number) => {
  await apiDelete(`/api/configuracoes/${id}`);
};
