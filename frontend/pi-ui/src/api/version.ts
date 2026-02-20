import { apiGet } from './api';

export interface VersionInfo {
  app: {
    version: string;
    environment: string;
    framework: string;
    startedAt: string;
  };
  database: {
    provider: string;
    lastMigration: string;
    totalApplied: number;
    totalPending: number;
  };
  history: {
    versao: string;
    data: string;
  }[];
}

export const getVersion = () => apiGet<VersionInfo>('/api/Version');
