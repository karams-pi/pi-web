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

export const importLivintus = async (file: File, idFornecedor: number, dtRevisao?: string, preview: boolean = false) => {
  const formData = new FormData();
  formData.append('file', file);
  
  let url = `/api/Import/livintus?idFornecedor=${idFornecedor}&preview=${preview}`;
  if (dtRevisao) url += `&dtRevisao=${encodeURIComponent(dtRevisao)}`;

  return apiPostFormData<any>(url, formData);
};

export const resetSequences = async () => {
  return apiPostFormData<any>('/api/Import/reset-sequences', new FormData());
};

export const sincronizarItens = async (request: any) => {
  const { apiPost } = await import('./api');
  return apiPost<any>('/api/Import/sincronizar', request);
};
