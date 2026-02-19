import { apiPostFormData } from './api';

export const importTable = async (file: File, idFornecedor: number, dtRevisao?: string) => {
  const formData = new FormData();
  formData.append('file', file);
  formData.append('idFornecedor', String(idFornecedor));
  if (dtRevisao) formData.append('dtRevisao', dtRevisao);

  // apiPostFormData already handles Content-Type for FormData
  return apiPostFormData<any>('/api/Import/tabela-precos', formData);
};
export const importKarams = async (file: File, idFornecedor: number, dtRevisao?: string) => {
  const formData = new FormData();
  formData.append('file', file);
  formData.append('idFornecedor', String(idFornecedor));
  if (dtRevisao) formData.append('dtRevisao', dtRevisao);

  return apiPostFormData<any>('/api/Import/karams', formData);
};

export const importKoyo = async (file: File, idFornecedor: number, dtRevisao?: string) => {
  const formData = new FormData();
  formData.append('file', file);
  formData.append('idFornecedor', String(idFornecedor));
  if (dtRevisao) formData.append('dtRevisao', dtRevisao);

  return apiPostFormData<any>('/api/Import/koyo', formData);
};

export const importFerguile = async (file: File, idFornecedor: number, dtRevisao?: string) => {
  const formData = new FormData();
  formData.append('file', file);
  formData.append('idFornecedor', String(idFornecedor));
  if (dtRevisao) formData.append('dtRevisao', dtRevisao);

  return apiPostFormData<any>('/api/Import/ferguile', formData);
};

export const importLivintus = async (file: File, idFornecedor: number, dtRevisao?: string) => {
  const formData = new FormData();
  formData.append('file', file);
  formData.append('idFornecedor', String(idFornecedor));
  if (dtRevisao) formData.append('dtRevisao', dtRevisao);

  return apiPostFormData<any>('/api/Import/livintus', formData);
};
