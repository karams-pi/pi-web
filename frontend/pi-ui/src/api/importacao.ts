import { apiPostFormData } from './api';

export const importTable = async (file: File, idFornecedor: number) => {
  const formData = new FormData();
  formData.append('file', file);
  formData.append('idFornecedor', String(idFornecedor));

  // apiPostFormData already handles Content-Type for FormData
  return apiPostFormData<any>('/api/Import/tabela-precos', formData);
};
export const importKarams = async (file: File, idFornecedor: number) => {
  const formData = new FormData();
  formData.append('file', file);
  formData.append('idFornecedor', String(idFornecedor));

  return apiPostFormData<any>('/api/Import/karams', formData);
};
